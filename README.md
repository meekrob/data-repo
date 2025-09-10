# data-repo: tools to help organize your datasets
Need more organization? Here is a light-weight set of tools to treat your datasets more like a repository, with best-practice materials and scripts ready to use.

The idea is to help with organization and provenance when managing datasets.  It does not have a mechanism for data versioning currently.

Automation of tasks is simplistic: starting with a file or set of files, 
* create a subdirectory, file list, and
* compute checksums using parallel tasks on large files.

This can be run within a pre-existing analysis project directory, or be part of a data-repo This is of particular interest when managing several sources of data, 
public or user-generated.

## Installation

```
$ git clone this repository
$ cd repository
$ bash install.sh
```
Will prompt for choice from your PATH. 
Then run:

```
$ init-data-repo 
Error: No input files provided
Usage: datadir [options] file[s]

Options:
  -h, --help            Show this help message and exit
  -n, --name NAME       Name to use for the operation (overrides destination)
  -d, --destination DIR Destination directory (ignored if --name is set)
  -m, --move-method M   Move method: mv, cp, hardlink, softlink (default: "cp")
```


## Example usage

I want create a data repo of files I downloaded from SRA.

```
init-data-repo --move-method mv --name pacBio_dataset *.fastq.gz
```

This attaches a date to the provided name (pacBio_dataset) and moves `*.fastq.gz` into the created directory.  
It creates `pacBio_dataset.filelist.txt`, which the slurm scripts use to run md5sum on each file individually, merging the result into `pacBio_dataset.filelist.md5` 

A README is created which starts you off with a report of the command which initialized the data repo.  
```
pacBio_dataset-2025-09-08-14-37/
├── pacBio_dataset.filelist.md5
├── pacBio_dataset.filelist.txt
├── README
├── data-repo-scripts
│   └── slurm-md5-array
│       ├── concat-md5.sbatch
│       ├── launch-md5sum.sh
│       └── md5sum-array.sbatch
├── SRR...090.fastq.gz
├── SRR...091.fastq.gz
├── SRR...092.fastq.gz
├── SRR...093.fastq.gz
├── SRR...094.fastq.gz
├── SRR...095.fastq.gz
├── SRR...096.fastq.gz
├── SRR...097.fastq.gz
├── SRR...098.fastq.gz
├── SRR...099.fastq.gz
├── SRR...100.fastq.gz
  ...
├── SRR_Acc_List.txt

```
