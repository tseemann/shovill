# Shovill
Faster SPAdes assembly of Illumina reads

## Introduction

The SPAdes genome assembler has become the *de facto* standard *de novo* genome assembler
for Illumina whole genome sequencing data of bacteria and other small microbes. SPAdes
was a major improvement over previous assemblers like Velvet, but it can be very slow to run
and does not handle overlapping paired-end reads well.

Shovill is a pipeline which uses SPAdes at its core, but alters the steps before and after
the primary assembly step to get near-identical results in far less time.  

## Main steps

1. Estimate genome size and read length from reads (unless `--gsize` provided)
2. Reduce FASTQ files to a sensible depth (default `--depth 50`)
3. Trim adapters from reads (with `--trim` only)
4. Conservatively correct reads sequencing errors
5. Pre-overlap paired-end reads
6. Assemble with "vanilla" SPAdes with modified kmer range and PE + long SE reads
7. Use contigs not scaffolds
8. Correct minor assembly errors
9. Produce final FASTA with nicer names

## Quick Start

```bash
% shovill --outdir mrsa --R1 staph_R1.fq.gz --R2 staph_R2.fq.gz

<snip>
Final assembly in: mrsa/contigs.fa
It contains 17 (min=150) contigs totalling 169611 bp.
Done.

% ls mrsa

00-shovill.log  30-trimmomatic.log  60-spades.log  assembly_graph.fastg  contigs.fa     pilon.changes
10-seqtk.tab    40-lighter.log      70-bwa.log     assembly_graph.gfa    contigs.fasta  scaffolds.fasta
20-kmc.log      50-flash.log        80-pilon.log   before_rr.fasta       flash.hist

% head -n 4 mrsa/contigs.fa

>contig00001 len=52653 cov=32.7 corr=1 spades=NODE_1_length_52642_cov_32.67243_pilon
ATAACGCCCTGCTGGCCCAGGTCATTTTATCCAATCTGGACCTCTCGGCTCGCTTTGAAGAAT
GAGCGAATTCGCCGTTCAGTCCGCTGGACTTCGGACTTAAAGCCGCCTAAAACTGCACGAACC
ATTGTTCTGAGGGCCTCACTGGATTTTAACATCCTGCTAACGTCAGTTTCCAACGTCCTGTCG
```

## Installation

### Homebrew

```
brew tap homebrew/science
brew tap tseemann/bioinformatics-linux
brew install shovill
```
Using Homebrew will install all the dependencies for you: 
[Linux](http://linuxbrew.sh) or [MacOS](http://brew.sh)

### Source

```
git clone https://github.com/tseemann/shovill.git
./shovill/shovill -h
```
You will need to install all the dependencies manually:
* SPAdes
* Lighter
* FLASH
* SAMtools >= 1.3
* BWA MEM
* PILON
* KMC
* seqtk
* pigz
* Java
* Trimmomatic

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
>contig00001 len=263154 cov=8.9 corr=1 spades=NODE_1_length_263154_cov_8.86703_pilon
>contig00041 len=339 cov=8.8 corr=0 spades=NODE_41_length_339_cov_8.77027_pilon
```

There is a log file for each of the tools used to generate the assembly:
```
00-shovill.log
10-seqtk.tab
20-kmc.log
30-trimmomatic.log
40-lighter.log
50-flash.log
60-spades.log
70-bwa.log
80-pilon.log
```

As Spades is the most important tool used, some useful output files are
kept.<br>
&#9888; Do not confuse the final `contigs.fa` with these files!
```
assembly_graph.fastg
assembly_graph.gfa
before_rr.fasta
contigs.fasta
scaffolds.fasta
```

A couple of tool output files are also kept and may be useful to examine:
```
flash.hist
pilon.changes
```

## Advanced options

```
  --help          This help
  --debug         Debug info (default: OFF)
  --version       Print version and exit
  --cpus N        Number of CPUs to use (default: 16)
  --outdir XXX    Output folder (default: '')
  --force         Force overwite of existing output folder (default: OFF)
  --R1 XXX        Read 1 FASTQ (default: '')
  --R2 XXX        Read 2 FASTQ (default: '')
  --depth N       Sub-sample --R1/--R2 to this depth. Disable with --depth 0 (default: 50)
  --gsize XXX     Estimated genome size <blank=AUTODETECT> (default: '')
  --kmers XXX     K-mers to use <blank=AUTO> (default: '')
  --opts XXX      Extra SPAdes options eg. --plasmid --sc ... (default: '')
  --nocorr        Disable post-assembly correction (default: OFF)
  --trim          Use Trimmomatic to remove common adaptors first (default: OFF)
  --trimopt XXX   Trimmomatic options (default: 'ILLUMINACLIP:/home/tseemann/git/shovill/bin/../db/trimmomatic.fa:1:30:11 LEADING:3 TRAILING:3 MINLEN:30 TOPHRED33')
  --minlen N      Minimum contig length <0=AUTO> (default: 0)
  --mincov n.nn   Minimum contig coverage <0=AUTO> (default: 2)
  --asm XXX       Spades result to correct: before_rr contigs scaffolds (default: 'contigs')
  --tmpdir XXX    Fast temporary directory (default: '/tmp/tseemann')
  --ram N         Try to keep RAM usage below this many GB (default: 32)
  --keepfiles     Keep intermediate files (default: OFF)
```

## Feedback

Please file questions, bugs or ideas to the [Issue Tracker](https://github.com/tseemann/shovill/issues)

## License

[GPLv3](https://raw.githubusercontent.com/tseemann/shovill/master/LICENSE)

## Citation

Not published yet.

## Authors

* **Torsten Seemann**
* Jason Kwong
* Anders Goncalves da Silva
