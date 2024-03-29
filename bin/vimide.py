#!/usr/bin/python

"""
Writes all the files into a list.
"""

import os, sys, re, fnmatch

allow_patterns = [
    '*.cc', '*.cpp', '*.h',
    "*.java", "*.scala",
    "*.rb", "*.py",
    "*.go",
    "*.cu",
    "*.vue",
    "*.sh",
    "*.jsx", "*.js", "*.ts", "*.tsx",
    "*.html", "*.hbs",
    "*.css", "*.scss", "*.less",
    "*.md",
    "*.yml",
    "*.tex",
    "*.conf",
    "*.yaml",
    #"*.json",
    "package.json",
    'run', 'Makefile', 'Dockerfile*', 'README',
]

def read_gitignore():
    """Return list of ignore patterns."""
    path = '.gitignore'
    patterns = ['.git']
    if os.path.exists(path):
        for line in open(path):
            line = re.sub('#.*$', '', line)
            pattern = line.strip().rstrip('/')
            if pattern == '':
                continue
            patterns.append(pattern)
    return patterns

def matches(filename, patterns):
    return any(fnmatch.fnmatch(filename, pattern) for pattern in patterns)

def find_all_files(path, out):
    subpaths = []
    for filename in sorted(os.listdir(path)):
        if matches(filename, disallow_patterns):
            continue
        subpath = os.path.join(path, filename)
        if any(subpath.endswith(pattern) for pattern in disallow_patterns if pattern.startswith('/')):
            continue
        if os.path.isdir(subpath):
            subpaths.append(subpath)
        else:
            if matches(filename, allow_patterns):
                print(subpath, file=out)
    for subpath in subpaths:
        find_all_files(subpath, out)

############################################################

disallow_patterns = read_gitignore()

path = 'nav'
with open(path, 'w') as out:
    find_all_files('.', out)
os.system('ctags -L {}'.format(path))
os.system('vim {}'.format(path))
