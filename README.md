[![Build Status](https://travis-ci.org/tseemann/shovill.svg?branch=master)](https://travis-ci.org/tseemann/shovill)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# Shovill
Faster SPAdes (or better SKESA/Megahit/Velvet) assembly of Illumina reads 

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
* Velvet >= 1.2
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

Filename | Description
---------|------------
`contigs.fa` | The final assembly you should use
`shovill.log` | Full log file for bug reporting
`shovill.corrections` | List of post-assembly corrections
`contigs.gfa` | Assembly graph (spades)
`contigs.fastg` | Assembly graph (megahit)
`contigs.LastGraph` | Assembly graph (velvet)
`skesa.fasta` | Raw assembly (skesa)
`spades.fasta` | Raw assembled contigs (spades)
`megahit.fasta` | Raw assembly (megahit)
`velvet.fasta` | Raw assembly (velvet)

### `contigs.fa`

This is most important output file - the final, corrected assembly.
It contains entries like this:

```
>contig00001 len=263154 cov=8.9 corr=1 origname=NODE_1_length_263154_cov_8.86703_pilon
>contig00041 len=339 cov=8.8 corr=0 origname=NODE_41_length_339_cov_8.77027_pilon
```

The sequence IDs are named as per the `--namefmt` option, and the comment field
is a series of space-separated `name=value` pairs with the following meanings:

Pair | Meaning
----|--------
`len`  | Length of contig in basepairs
`cov`  | Average k-mer coverage as reported by assembler
`corr` | Number of post-assembly corrections (unless `--nocorr` used)
`origname` | The original name of the contig (before applying `--namefmt`)

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
  --minlen N      Minimum contig length <0=AUTO> (default: 0)
  --mincov n.nn   Minimum contig coverage <0=AUTO> (default: 2)
  --namefmt XXX   Format of contig FASTA IDs in 'printf' style (default: 'contig%05d')
  --keepfiles     Keep intermediate files (default: OFF)
RESOURCES
  --tmpdir XXX    Fast temporary directory (default: '/tmp/tseemann')
  --cpus N        Number of CPUs to use (0=ALL) (default: 0)
  --ram n.nn      Try to keep RAM usage below this many GB (default: 8)
ASSEMBLER
  --assembler XXX Assembler: spades skesa megahit velvet (default: 'skesa')
  --kmers XXX     K-mers to use <blank=AUTO> (default: '')
  --opts XXX      Extra assembler options eg. spades: --plasmid --sc ... (default: '')
MODULES
  --trim          Enable adaptor trimming (default: OFF)
  --noreadcorr    Disable read error correction (default: OFF)
  --nostitch      Disable read stitching (default: OFF)
  --nocorr        Disable post-assembly correction (default: OFF)
```

### --depth
Giving an assembler too much data is a bad thing. There comes a point where you are no
longer adding new information (as the genome is a fixed size), and only adding more noise 
(sequencing errors). Most assemblers seem to be happy with ~100x depth, so Shovill will
downsample your FASTQ files to this depth. It estimates depth by dividing read yield by
genome size.

### --gsize
The genome size is needed to estimate depth and for the read error correction stage.
If you don't provide `--gsize`, it will be estimated via k-mer frequencies using `mash`.
It doesn't need to be a perfect estimate, just in the right ballpark.

### --keepfiles
This will keep all the intermediate files in `--outdir` so you can explore and debug.

### --cpus
By default it will attempt to use all available CPU cores.

### --ram
Shovill will do its best to keep memory usage below this value, but it is not guaranteed.
If you are on a HPC cluster, you should make sure you tell your job submission engine
a value higher than this.

### --assembler
By default it will use SPAdes, but you can also choose Megahit or SKESA. These are much
faster than SPAdes, but give lesser assemblies. If you use SKESA you can probably use
`--noreadcorr` and `--nocoor` because it has some of that functionality inbuilt and is
conservative.

### --kmers
A series of kmers are chosen based on the read length distribution. You can override
this with this option.

### Choosing which stages to use

Stage | Enable | Disable
------|--------|--------
Genome size estimation | _default_ | `--gsize XX`
Read subsampling | `--depth N` | `--depth 0`
Read trimming | `--trim` | _default_
Read error correction | _default_ | `--noreadcorr`
Read stitching/overlap | _default_ | `--nostitch`
Contig correction | _default_ | `--nocorr`

## Environment variables recognised

These env-vars will be used as defaults instead of the built-in defaults.
You can use the normal command line option to override them still.

Variable | Option | Default
---------|--------|------------
`$SHOVILL_CPUS` | `--cpus` | 1
`$SHOVILL_RAM` | `--ram` | 4
`$SHOVILL_ASSEMBLER` | `--assembler` | `spades`
`$TMPDIR` | `--tmpdir` | `/tmp`

## FAQ

* _Does `shovill` accept single-end reads?_

  No, but it might one day.

* _Do you support long reads from Pacbio or Nanopore?_

  No, this is strictly an Illumina based pipeline.

* _Why does Shovill crash?_

  Shovill has a lot of dependencies. If any dependencies
  are not installed correctly it will die. Spades also
  doesn't handle --cpus > 16 very well - try giving more RAM.

## Feedback

Please file questions, bugs or ideas 
to the [Issue Tracker](https://github.com/tseemann/shovill/issues)

## License

[GPLv3](https://raw.githubusercontent.com/tseemann/shovill/master/LICENSE)

## Citation

Not published yet.

## Authors

* Torsten Seemann (with Jason Kwong, Simon Gladman, Anders Goncalves da Silva)
