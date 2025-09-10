# data-repo: tools to help organize your datasets
Need more organization? Here is a light-weight set of tools to treat your datasets more like a repository, with best-practice materials and scripts ready to use.

The idea is to help with organization and provenance when managing datasets.  It does not have a mechanism for data versioning currently.

Automation of tasks is simplistic: starting with a file or set of files, 
* create a subdirectory, file list, and
* compute checksums using parallel tasks on large files.

This can be run within a pre-existing analysis project directory, or be part of a data-repo This is of particular interest when managing several sources of data, 
public or user-generated.

## Example usage

I want create a data repo of files I downloaded from SRA.



```
├── pacBio_dataset.filelist.md5
├── pacBio_dataset.filelist.txt
├── projects
│   └── pacBio_dataset_assembly -> /nfs/home/dking/pacBio_dataset
├── README
├── scripts
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
├── SRR...101.fastq.gz
├── SRR...102.fastq.gz
├── SRR...103.fastq.gz
├── SRR...104.fastq.gz
├── SRR...105.fastq.gz
├── SRR...106.fastq.gz
├── SRR...107.fastq.gz
├── SRR...108.fastq.gz
├── SRR...109.fastq.gz
├── SRR...110.fastq.gz
├── SRR...111.fastq.gz
├── SRR...112.fastq.gz
├── SRR...113.fastq.gz
├── SRR...114.fastq.gz
├── SRR...115.fastq.gz
├── SRR...116.fastq.gz
├── SRR...117.fastq.gz
├── SRR...118.fastq.gz
├── SRR...119.fastq.gz
├── SRR...120.fastq.gz
├── SRR...121.fastq.gz
├── SRR...122.fastq.gz
├── SRR...123.fastq.gz
├── SRR...124.fastq.gz
├── SRR_Acc_List.txt

```
