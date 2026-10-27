import ast
import re
import sys
import tomllib
import unittest
from pathlib import Path

PACKAGE_DIR = Path(__file__).resolve().parents[1]
PYPROJECT_PATH = PACKAGE_DIR.parent / "pyproject.toml"
PACKAGE_NAME = "fundamentals"

# IMPORT NAME -> DISTRIBUTION NAME, WHERE THE TWO DIFFER
IMPORT_TO_DISTRIBUTION = {
    "yaml": "pyyaml",
    "dateutil": "python-dateutil",
    "daemon": "python-daemon",
}

# GUARDED FALLBACK IMPORTS THAT ARE NEVER NEEDED ON A SUPPORTED PLATFORM
GUARDED_FALLBACK_IMPORTS = {
    "StringIO",  # PYTHON 2 FALLBACK
    "importlib_metadata",  # PYTHON < 3.8 FALLBACK
    "pyreadline3",  # WINDOWS-ONLY READLINE REPLACEMENT
}


def _distribution_name(requirement):
    """*return the normalised distribution name of a requirement string*

    **Key Arguments:**

    - ``requirement`` -- a PEP 508 requirement string, e.g. ``"fundamentals[tests, docs]"``

    **Return:**

    - ``name`` -- the lower-cased distribution name with ``_`` and ``.`` replaced by ``-``
    """
    name = re.split(r"[\s\[<>=!~;(]", requirement.strip(), maxsplit=1)[0]
    return re.sub(r"[-_.]+", "-", name).lower()


def _declared_pyproject():
    with open(PYPROJECT_PATH, "rb") as handle:
        return tomllib.load(handle)["project"]


def _declared_runtime_distributions():
    project = _declared_pyproject()
    requirements = list(project.get("dependencies", []))
    for extraRequirements in project.get("optional-dependencies", {}).values():
        requirements.extend(extraRequirements)
    return {_distribution_name(r) for r in requirements} - {PACKAGE_NAME}


def _is_test_file(path):
    return "tests" in path.parts or path.name.startswith("test_")


def _imported_third_party_modules():
    """*return a map of third-party top-level module name -> files importing it*"""
    importedBy = {}
    for path in PACKAGE_DIR.rglob("*.py"):
        if _is_test_file(path.relative_to(PACKAGE_DIR)):
            continue
        for node in ast.walk(ast.parse(path.read_text(encoding="utf-8"))):
            if isinstance(node, ast.Import):
                names = [alias.name for alias in node.names]
            elif isinstance(node, ast.ImportFrom) and node.level == 0 and node.module:
                names = [node.module]
            else:
                continue
            for name in names:
                topLevel = name.split(".")[0]
                if topLevel in sys.stdlib_module_names or topLevel == PACKAGE_NAME:
                    continue
                importedBy.setdefault(topLevel, set()).add(
                    str(path.relative_to(PACKAGE_DIR)))
    return importedBy


class test_declared_dependencies(unittest.TestCase):

    def test_every_third_party_import_is_declared_in_pyproject(self):
        declared = _declared_runtime_distributions()
        undeclared = {}
        for module, files in _imported_third_party_modules().items():
            if module in GUARDED_FALLBACK_IMPORTS:
                continue
            distribution = IMPORT_TO_DISTRIBUTION.get(module, module)
            if _distribution_name(distribution) not in declared:
                undeclared[module] = sorted(files)

        self.assertEqual(undeclared, {})

    def test_package_does_not_depend_on_itself(self):
        dependencies = _declared_pyproject().get("dependencies", [])

        names = [_distribution_name(d) for d in dependencies]

        self.assertNotIn(PACKAGE_NAME, names)

    def test_stats_extra_holds_astropy_and_numpy(self):
        extras = _declared_pyproject().get("optional-dependencies", {})

        names = {_distribution_name(r) for r in extras.get("stats", [])}

        self.assertTrue({"astropy", "numpy"} <= names)

    def test_unicodecsv_is_a_core_dependency(self):
        dependencies = _declared_pyproject().get("dependencies", [])

        names = {_distribution_name(d) for d in dependencies}

        self.assertIn("unicodecsv", names)


if __name__ == "__main__":
    unittest.main()
