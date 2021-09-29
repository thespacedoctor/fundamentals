from setuptools import setup, find_packages
import os

moduleDirectory = os.path.dirname(os.path.realpath(__file__))
exec(open(moduleDirectory + "/fundamentals/__version__.py").read())


def readme():
    with open(moduleDirectory + '/README.md') as f:
        return f.read()

install_requires = [
    'pyyaml',
    'fundamentals',
    'future',
    'docopt',
    'psutil',
    'python-dateutil',
    'coloredlogs',
    'requests'
]

# READ THE DOCS SERVERS
exists = os.path.exists("/home/docs/")
if exists:
    c_exclude_list = ['healpy', 'astropy',
                      'numpy', 'sherlock', 'wcsaxes', 'HMpTy', 'ligo-gracedb']
    for e in c_exclude_list:
        try:
            install_requires.remove(e)
        except:
            pass

setup(name="fundamentals",
      version=__version__,
      description="Some fundamental tools required by most self-respecting python-packages bundled in one place. Very opinionated project setup tools including logging, plain-text settings files and database connections.",
      long_description=readme(),
      long_description_content_type='text/markdown',
      classifiers=[
          'Development Status :: 4 - Beta',
          'License :: OSI Approved :: MIT License',
          'Programming Language :: Python :: 3.7',
          'Topic :: Utilities',
      ],
      keywords=['logging, database'],
      url='https://github.com/thespacedoctor/fundamentals',
      download_url='https://github.com/thespacedoctor/fundamentals/archive/v%(__version__)s.zip' % locals(
      ),
      author='David Young',
      author_email='davidrobertyoung@gmail.com',
      license='MIT',
      packages=find_packages(),
      include_package_data=True,
      install_requires=install_requires,
      test_suite='nose2.collector.collector',
      tests_require=['nose2', 'cov-core'],
      entry_points={
          'console_scripts': ['mysqlSucker=fundamentals.mysql.directory_script_runner:main',
                              'yaml2db=fundamentals.mysql.yaml_to_database:main',
                              # 'fundamentals=fundamentals.cl_utils:main',
                              'sqlite2mysql=fundamentals.mysql.sqlite2mysql:main'],
      },
      zip_safe=False)
