from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import pickle
import yaml
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# SET FOR THE MODULE BY THE session_names FIXTURE IN THE ROOT conftest.py
log = None

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"
pathToOutputDir = moduleDirectory + "/output/"

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)

pathToPickleFile = pathToInputDir + "/list-of-dictionaries.p"

listOfDictionaries = pickle.load(open(pathToPickleFile, "rb"))


class test_list_of_dictionaries(unittest.TestCase):

    def test_list_of_dictionaries_function(self):

        from fundamentals.renderer import list_of_dictionaries

        dataSet = list_of_dictionaries(log=log, listOfDictionaries=listOfDictionaries)
        # print(dataSet.table())
        dataSet.table(filepath=pathToOutputDir + "myData.dat")
        # print(dataSet.csv())
        dataSet.csv(filepath=pathToOutputDir + "myData.csv")
        # print(dataSet.mysql(tableName="TNS"))
        dataSet.mysql(tableName="TNS", filepath=pathToOutputDir + "myData.mysql")

        # print(dataSet.json())
        dataSet.json(filepath=pathToOutputDir + "myData.json")
        # print(dataSet.yaml())
        dataSet.yaml(filepath=pathToOutputDir + "myData.yaml")
        # print(dataSet.markdown())
        dataSet.markdown(filepath=pathToOutputDir + "myData.md")

    def test_list_of_dictionaries_function_02(self):

        dataList = [
            {"owner": "daisy", "pet": "dog", "address": "belfast, uk"},
            {"owner": "john", "pet": "snake", "address": "the moon"},
            {"owner": "susan", "pet": "crocodile", "address": "larne"},
        ]

        from fundamentals.renderer import list_of_dictionaries

        dataSet = list_of_dictionaries(log=log, listOfDictionaries=dataList)
        # print(dataSet.table())
        dataSet.table(filepath=pathToOutputDir + "myData.dat")
        # print(dataSet.csv())
        dataSet.csv(filepath=pathToOutputDir + "myData.csv")
        # print(dataSet.mysql(tableName="TNS"))
        dataSet.mysql(tableName="TNS", filepath=pathToOutputDir + "myData.mysql")
        # print(dataSet.json())
        dataSet.json(filepath=pathToOutputDir + "myData.json")
        # print(dataSet.yaml())
        dataSet.yaml(filepath=pathToOutputDir + "myData.yaml")
        # print(dataSet.markdown())
        dataSet.markdown(filepath=pathToOutputDir + "myData.md")

    def test_list_of_dictionaries_function_exception(self):

        from fundamentals.renderer import list_of_dictionaries

        try:
            this = list_of_dictionaries(
                log=log, listOfDictionaries=listOfDictionaries, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function


def test_csv_writes_file_when_filepath_has_no_directory(tmp_path, monkeypatch):
    from fundamentals.renderer import list_of_dictionaries

    monkeypatch.chdir(tmp_path)
    dataList = [{"owner": "daisy", "pet": "dog", "address": "belfast, uk"}]
    dataSet = list_of_dictionaries(log=log, listOfDictionaries=dataList)

    dataSet.csv(filepath="out.csv")

    assert (tmp_path / "out.csv").exists()


def _render(dataList):
    from fundamentals.renderer import list_of_dictionaries

    return list_of_dictionaries(log=log, listOfDictionaries=dataList)


def test_csv_uses_union_of_keys_in_first_seen_order():
    dataList = [{"a": 1, "b": 2}, {"b": 3, "c": 4}]

    rendered = _render(dataList).csv()

    assert rendered.splitlines() == ["a,b,c", "1,2,", ",3,4"]


def test_table_renders_missing_values_as_empty_cells():
    dataList = [{"a": "x", "b": "y"}, {"a": "z"}]

    rendered = _render(dataList).table()

    lastRow = rendered.splitlines()[-2]
    assert lastRow.strip("|").split("|")[1].strip() == ""
    assert "None" not in rendered


def test_json_serialises_decimal_and_date_values():
    import json
    from datetime import date
    from decimal import Decimal

    dataList = [{"price": Decimal("2.50"), "day": date(2020, 1, 2)}]

    rendered = _render(dataList).json()

    assert json.loads(rendered) == [{"price": "2.50", "day": "2020-01-02"}]


def test_json_serialises_nested_temporal_values():
    import json
    from datetime import datetime
    from decimal import Decimal

    dataList = [
        {"nested": {"when": datetime(2020, 1, 2, 3, 4, 5)}, "items": [Decimal("1")]}
    ]

    rendered = _render(dataList).json()

    assert json.loads(rendered) == [
        {"nested": {"when": "20200102t030405"}, "items": ["1"]}
    ]


def test_json_keeps_top_level_datetime_format():
    from datetime import datetime

    dataList = [{"when": datetime(2020, 1, 2, 3, 4, 5)}]

    rendered = _render(dataList).json()

    assert '"when": "20200102t030405"' in rendered


def test_markdown_leaves_pipe_dash_in_data_cells_untouched():
    dataList = [{"a": "x|--y", "b": "z"}]

    rendered = _render(dataList).markdown()

    lines = rendered.splitlines()
    assert "--y" in lines[2]
    assert ":-y" not in lines[2]
    assert lines[1].startswith("|:-")


def test_rest_leaves_pipe_dash_in_data_cells_untouched():
    dataList = [{"a": "x|--y|", "b": "z"}]

    rendered = _render(dataList).reST()

    dataLine = rendered.splitlines()[3]
    assert "x|--y|" in dataLine
    assert "x+--y" not in dataLine
    assert rendered.splitlines()[4].startswith("+--")


def test_csv_decodes_bytes_cells_instead_of_rendering_repr():
    dataList = [{"name": "caf\u00e9".encode("utf-8")}]

    rendered = _render(dataList).csv()

    assert rendered.splitlines() == ["name", "caf\u00e9"]


def test_csv_replaces_undecodable_bytes_cells():
    dataList = [{"name": b"caf\xe9"}]

    rendered = _render(dataList).csv()

    assert rendered.splitlines() == ["name", "caf\ufffd"]


def test_yaml_writer_opens_file_as_utf8(tmp_path, monkeypatch):
    import builtins

    opened = []
    real_open = builtins.open

    def spy_open(*args, **kwargs):
        opened.append((args, kwargs))
        return real_open(*args, **kwargs)

    monkeypatch.setattr(builtins, "open", spy_open)
    filepath = str(tmp_path / "out.yaml")

    _render([{"name": "café"}]).yaml(filepath=filepath)

    writes = [kw for args, kw in opened if args and args[0] == filepath]
    assert writes and all(kw.get("encoding") == "utf-8" for kw in writes)


def test_mysql_writer_writes_utf8_under_ascii_locale(tmp_path):
    import subprocess
    import sys

    filepath = tmp_path / "out.sql"
    script = (
        "import logging;"
        "from fundamentals.renderer import list_of_dictionaries;"
        "list_of_dictionaries(log=logging.getLogger('x'),"
        "listOfDictionaries=[{'name': 'caf\\u00e9'}])"
        ".mysql('t', filepath=%r)" % str(filepath)
    )
    env = {
        "PATH": os.environ["PATH"],
        "PYTHONPATH": os.getcwd(),
        "LC_ALL": "C",
        "PYTHONCOERCECLOCALE": "0",
        "PYTHONUTF8": "0",
    }

    result = subprocess.run(
        [sys.executable, "-c", script], env=env, capture_output=True, text=True
    )

    assert result.returncode == 0, result.stderr
    assert "café" in filepath.read_text(encoding="utf-8")


def test_json_raises_type_error_for_unsupported_values():
    import pytest

    dataList = [{"thing": object()}]

    with pytest.raises(TypeError, match="not JSON serializable"):
        _render(dataList).json()
