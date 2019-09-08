#!/usr/bin/env python

"""
Writes all the files into a list.
"""

import os, sys, re, fnmatch

allow_patterns = [
    '*.cc', '*.h',
    "*.java", "*.scala",
    "*.rb", "*.py",
    "*.go",
    "*.jsx", "*.js", "*.ts", "*.tsx",
    "*.html", "*.hbs",
    "*.css", "*.less",
    "*.md",
    "*.yml",
    "*.tex",
    "*.conf",
    #"*.json",
    "package.json",
    'run', 'Makefile', 'Dockerfile*', 'README',
]

def read_gitignore():
    """Return list of ignore patterns."""
    path = '.gitignore'
    patterns = []
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
        if any(path.endswith(pattern) for pattern in disallow_patterns):
            continue
        subpath = os.path.join(path, filename)
        if os.path.isdir(subpath):
            subpaths.append(subpath)
        else:
            if matches(filename, allow_patterns):
                print >>out, subpath
    for subpath in subpaths:
        find_all_files(subpath, out)

############################################################

disallow_patterns = read_gitignore()

path = 'nav'
#if not os.path.exists(path):
with open(path, 'w') as out:
    find_all_files('.', out)
os.system('ctags -L {}'.format(path))
os.system('vim {}'.format(path))
