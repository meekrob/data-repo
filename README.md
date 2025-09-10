# data-repo: tools to help organize your datasets
Need more organization? Here is a light-weight set of tools to treat your datasets more like a repository, with best-practice materials and scripts ready to use.

The idea is to help with organization and provenance when managing datasets.  It does not have a mechanism for data versioning currently.

Automation of tasks is simplistic: starting with a file or set of files, 
* create a subdirectory, file list, and
* compute checksums using parallel tasks on large files.

This can be run within a pre-existing analysis project directory, or be part of a data-repo This is of particular interest when managing several sources of data, 
public or user-generated.
