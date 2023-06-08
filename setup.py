from distutils.core import setup
from setuptools import setup, find_packages
import py2exe


setup(
    name='fix_unicode_filenames',
    author="Claire",
    description="ascii filename fixer",
    version='0.2',
    packages=find_packages(include=['polyglot', 'python_romkan', 'tzdata']),
    entry_points={
        'console_scripts': [
            'fix_unicode_filenames = fix_unicode_filenames:main',
        ],
    },
    options={
        'py2exe': {
            'bundle_files': 1,
            'compressed': True,
        }
    },
    console=['fix_unicode_filenames.py'],
    #windows=['your_main_script.py'],
    zipfile=None,
)
