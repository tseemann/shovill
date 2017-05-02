# Shovill
Faster smarter SPAdes assembly of Illumina reads

## Introduction

The SPAdes genome assembler has become the *de facto* standard *de novo* genome assembler
for Illumina whole genome sequencing data of bacteria and other small microbes. SPAdes
was a major improvement over previous assemblers like Velvet, but it can be very slow to run
and does not handle overlapping paired-end reads well.

Shovill is a pipeline which uses SPAdes at its core, but alters the steps before and after
the primary assembly step to get near-identical results in far less time.  

## Main steps

1. Estimate genome size and read length distribution from reads
2. Trim adapters from reads
3. Correct reads conservatively
4. Pre-overlap paired-end reads
5. Assemble with "vanilla" SPAdes with modified kmer range and PE + long SE reads
6. Use contigs not scaffolds
7. Correct minor assembly errors

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

>contig00001 NODE_1_length_54882_cov_28.4218_pilon
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
* Java
* Trimmomatic

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
* Mark Schultz
* Dieter Bulach
