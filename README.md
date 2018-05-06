[![Build Status](https://travis-ci.org/tseemann/shovill.svg?branch=master)](https://travis-ci.org/tseemann/shovill) [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [](#lang-au)

# Shovill
Faster SPAdes (or better SKESA/Megahit) assembly of Illumina reads 

## Introduction

The SPAdes genome assembler has become the *de facto* standard *de novo* genome assembler
for Illumina whole genome sequencing data of bacteria and other small microbes. SPAdes
was a major improvement over previous assemblers like Velvet, but it can be very slow to run
and does not handle overlapping paired-end reads well.

Shovill is a pipeline which uses SPAdes at its core, but alters the steps before and after
the primary assembly step to get similar results in less time.

Shovill also supports other assemblers like SKESA and Megahit, so you can take advantage
of the pre- and post-processing the Shovill provides with those too.

## Main steps

1. Estimate genome size and read length from reads (unless `--gsize` provided)
2. Reduce FASTQ files to a sensible depth (default `--depth 100`)
3. Trim adapters from reads (with `--trim` only)
4. Conservatively correct sequencing errors in reads
5. Pre-overlap ("stitch") paired-end reads
6. Assemble with SPAdes/SKESA/Megahit with modified kmer range and PE + long SE reads
7. Correct minor assembly errors by mapping reads back to contigs
8. Remove contigs that are too short, too low coverage, or pure homopolymers
9. Produce final FASTA with nicer names and parseable annotations

## Quick Start

```bash
% shovill --outdir out --R1 test/R1.fq.gz --R2 test/R2.fq.gz

<snip>
Final assembly in: test/contigs.fa
It contains 17 (min=150) contigs totalling 169611 bp.
Done.

% ls out

contigs.fa   contigs.gfa   shovill.corrections  
shovill.log  spades.fasta

% head -n 4 out/contigs.fa

>contig00001 len=52653 cov=32.7 corr=1 origname=NODE_1_length_52642_cov_32.67243_pilon
ATAACGCCCTGCTGGCCCAGGTCATTTTATCCAATCTGGACCTCTCGGCTCGCTTTGAAGAAT
GAGCGAATTCGCCGTTCAGTCCGCTGGACTTCGGACTTAAAGCCGCCTAAAACTGCACGAACC
ATTGTTCTGAGGGCCTCACTGGATTTTAACATCCTGCTAACGTCAGTTTCCAACGTCCTGTCG
```

## Installation

### Homebrew

```
brew install brewsci/bio/shovill
shovill --check
```
Using Homebrew will install all the dependencies for you: 
[Linux](http://linuxbrew.sh) or [MacOS](http://brew.sh)

### Conda

```
conda -c bioconda install shovill
shovill --check
```
Big thanks to [@slugger70](https://github.com/slugger70) who tirelessly handles 
[Bioconda](https://bioconda.github.io/) packaging for all my tools.

### Docker

Use the 
[Bioboxes Shovill container](https://github.com/bioboxes/shovill/blob/master/Dockerfile).

### Source

```
git clone https://github.com/tseemann/shovill.git
./shovill/bin/shovill --help
./shovill/bin/shovill --check
```
You will need to install all the dependencies manually:
* SPAdes >= 3.11
* SKESA
* MEGAHIT
* Lighter
* FLASH
* SAMtools >= 1.3
* BWA MEM 
* MASH >= 2.0
* seqtk
* pigz
* Pilon (Java)
* Trimmomatic (Java)

## Output files

The most important output file is the final, corrected assembly:
```
contigs.fa
```

The FASTA description of each sequence in `contigs.fa` have space-separated
`name=value` pairs with the length in bases (`len`), the average coverage
(`cov`), the number of post-assembly SNP/indel corrections made (`corr`),
and the original contig name from Spades (`spades`). Two examples are:
```
>contig00001 len=263154 cov=8.9 corr=1 origname=NODE_1_length_263154_cov_8.86703_pilon
>contig00041 len=339 cov=8.8 corr=0 origname=NODE_41_length_339_cov_8.77027_pilon
```

The (uncorrected) assembly graph file for viewing in 
[Bandage](https://rrwick.github.io/Bandage/) is available too:
```
contigs.gfa  # or contigs.fastg
```

There is a log file to examine when things don't succeed:
``
shovill.log
```

The original contigs file produced by the chosen assembler is also present.<BR>
&#9888; Do not confuse the final `contigs.fa` with these files!
```
skesa.fasta
spades.fasta
megahit.fasta
```

The corrections made to the assembler output are in
```
shovill.corrections
```

## Advanced options

```
GENERAL
  --help          This help
  --version       Print version and exit
  --check         Check dependencies are installed
INPUT
  --R1 XXX        Read 1 FASTQ (default: '')
  --R2 XXX        Read 2 FASTQ (default: '')
  --depth N       Sub-sample --R1/--R2 to this depth. Disable with --depth 0 (default: 100)
  --gsize XXX     Estimated genome size eg. 3.2M <blank=AUTODETECT> (default: '')
OUTPUT
  --outdir XXX    Output folder (default: '')
  --force         Force overwite of existing output folder (default: OFF)
  --minlen N      Minimum contig length <0=AUTO> (default: 1)
  --mincov n.nn   Minimum contig coverage <0=AUTO> (default: 2)
  --namefmt XXX   Format of contig FASTA IDs in 'printf' style (default: 'contig%05d')
  --keepfiles     Keep intermediate files (default: OFF)
RESOURCES
  --tmpdir XXX    Fast temporary directory (default: '/tmp/tseemann')
  --cpus N        Number of CPUs to use (0=ALL) (default: 0)
  --ram n.nn      Try to keep RAM usage below this many GB (default: 8)
ASSEMBLER
  --assembler XXX Assembler: megahit spades skesa (default: 'spades')
  --kmers XXX     K-mers to use <blank=AUTO> (default: '')
  --opts XXX      Extra assembler options: eg. spades: --plasmid --sc ... (default: '')
MODULES
  --nocorr        Disable post-assembly correction (default: OFF)
  --trim          Use Trimmomatic to remove common adaptors first (default: OFF)
  --trimopt XXX   Trimmomatic options (default: 'ILLUMINACLIP:/home/tseemann/git/shovill/db/trimmomatic.fa:1:30:11 LEADING:3 TRAILING:3 MINLEN:30 TOPHRED33')
```

## Feedback

Please file questions, bugs or ideas 
to the [Issue Tracker](https://github.com/tseemann/shovill/issues)

## License

[GPLv3](https://raw.githubusercontent.com/tseemann/shovill/master/LICENSE)

## Citation

Not published yet.

## Authors

* **Torsten Seemann**
* Jason Kwong, Simon Gladman, Anders Goncalves da Silva
