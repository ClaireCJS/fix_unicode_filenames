from distutils.core import setup
from setuptools import setup, find_packages
import py2exe


setup(
    name='fixUnicodeFilenames',
    author="Claire",
    description="ascii filename fixer",
    version='0.2',
    packages=find_packages(include=['polyglot', 'python_romkan', 'tzdata']),
    entry_points={
        'console_scripts': [
            'fixUnicodeFilenames = fixUnicodeFilenames:main',
        ],
    },
    options={
        'py2exe': {
            'bundle_files': 1,
            'compressed': True,
        }
    },
    console=['fixUnicodeFilenames.py'],
    #windows=['your_main_script.py'],
    zipfile=None,
)
