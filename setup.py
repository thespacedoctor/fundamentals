from setuptools import setup, find_packages
import os

moduleDirectory = os.path.dirname(os.path.realpath(__file__))
exec(open(moduleDirectory + "/fundamentals/__version__.py").read())


def readme():
    with open(moduleDirectory + '/README.rst') as f:
        return f.read()

setup(
    name='fundamentals',
    version=__version__,
    description='Some project setup tools including logging, settings and database connections',
    long_description=readme(),
    classifiers=[
        'Development Status :: 4 - Beta',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 2.7',
        'Topic :: Utilities',
    ],
    keywords=['logging', 'database'],
    url='https://github.com/thespacedoctor/fundamentals',
    download_url='https://github.com/thespacedoctor/fundamentals/archive/v%(__version__)s.zip' % locals(
    ),
    author='David Young',
    author_email='davidrobertyoung@gmail.com',
    license='MIT',
    packages=find_packages(),
    package_data={'fundamentals': [
        'resources/*/*', 'resources/*.*']},
    include_package_data=True,
    install_requires=[
        'pyyaml',
        'docopt',
        'python-dateutil',
        'eventlet',
        'requests==2.11.1',
        'unicodecsv',
        'pyprof2calltree',
        'nose2',
        'cov-core',
        'pymysql'
    ],
    test_suite='nose2.collector.collector',
    tests_require=['nose2', 'cov-core'],
    entry_points={
        'console_scripts': ['mysqlSucker=fundamentals.mysql.directory_script_runner:main',
                            'yaml2db=fundamentals.mysql.yaml_to_database:main',
                            'sqlite2mysql=fundamentals.mysql.sqlite2mysql:main'],
    },
    zip_safe=False
)
