#!/usr/bin/env python3
import sys
import gzip
from Bio import SeqIO

def read_fastq_until_invalid(filepath):
    opener = gzip.open if filepath.endswith(".gz") else open
    handle = open(filepath, "r")
    nrecords = 0
    verbosity=10
    try:
        with opener(filepath, 'rt') as handle:
            for record in SeqIO.parse(handle, "fastq"):
                # Process the record here
                SeqIO.write(record, sys.stdout, "fastq")

                nrecords += 1
                if nrecords % verbosity == 0:
                    outmsg=f"Read {nrecords}"
                    print(outmsg + "\b" * len(outmsg), end="", flush=True, file=sys.stderr)

                # this will cause greater leaps between reported numbers as the scale increases
                if nrecords > (verbosity*20):
                    verbosity = int(verbosity * 1.25) 
                    #print(f"{verbosity=}", file=sys.stderr)

    except ValueError as e:
        print()
        print("Invalid FASTQ record encountered:", e, file=sys.stderr)
        print(f"{nrecords} valid fastq seqs", file=sys.stderr)
        return False
    except BrokenPipeError:
        pass

    finally:
        handle.close()

    print(f"{nrecords} valid fastq seqs", file=sys.stderr)
    return True

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} input.fastq > valid_records.fastq")
        sys.exit(1)

    if sys.stdout.isatty():
        print("Warning: Writing FASTQ records to the terminal", file=sys.stderr)
        response=input("Continue? N/y:")
        if not response or response.upper().startswith('N'):
            sys.exit(0)
            
    try: 
        # such as user writing to head or quitting output
        rval = read_fastq_until_invalid(sys.argv[1])
    except BrokenPipeError:
        pass

    if rval:
        sys.exit(0)
    else:
        sys.exit(2)
