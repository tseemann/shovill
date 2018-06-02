#!/bin/sh

set -e

HERE="$PWD"
WGET="wget --quiet"
MAKE="make --silent -j"
UNTAR="tar xf"

SAMTOOLSVER=1.8
SAMTOOLS=samtools-$SAMTOOLSVER
echo "* $SAMTOOLS"
$WGET https://github.com/samtools/samtools/releases/download/$SAMTOOLSVER/$SAMTOOLS.tar.bz2
$UNTAR $SAMTOOLS.tar.bz2
(cd $SAMTOOLS && ./configure --prefix=$HERE/$SAMTOOLS && $MAKE install)
PATH=$HERE/$SAMTOOLS/bin:$PATH

BWAVER=0.7.17
BWA=bwa-$BWAVER
echo "* $BWA"
$WGET https://github.com/lh3/bwa/releases/download/v$BWAVER/$BWA.tar.bz2
$UNTAR $BWA.tar.bz2
$MAKE -C $BWA 
PATH=$HERE/$BWA:$PATH

MASHVER=2.0
MASH="mash-Linux64-v$MASHVER"
MASHTAR="$MASH.tar"
echo "* $MASH"
$WGET https://github.com/marbl/Mash/releases/download/v$MASHVER/$MASHTAR
$UNTAR $MASHTAR
PATH=$HERE/$MASH:$PATH

SEQTKVER=1.2
SEQTK=v$SEQTKVER.tar.gz
echo "* seqtk $SEQTK"
$WGET https://github.com/lh3/seqtk/archive/$SEQTK
$UNTAR $SEQTK
$MAKE -C seqtk-$SEQTKVER
chmod g-w seqtk-$SEQTKVER/seqtk
PATH=$HERE/seqtk-$SEQTKVER:$PATH

SKESA=skesa
echo "* $SKESA"
mkdir -p $SKESA
$WGET -O $SKESA/skesa https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/skesa.centos6.9
#$WGET -O $SKESA/skesa https://ftp.ncbi.nlm.nih.gov/pub/agarwala/skesa/skesa.centos7.4
chmod +x $SKESA/skesa
PATH=$HERE/$SKESA:$PATH

MEGAHITVER=1.1.3
MEGAHIT=megahit_v${MEGAHITVER}_LINUX_CPUONLY_x86_64-bin
MEGAHITTAR=$MEGAHIT.tar.gz
echo "* $MEGAHIT"
$WGET https://github.com/voutcn/megahit/releases/download/v$MEGAHITVER/$MEGAHITTAR
$UNTAR $MEGAHITTAR
PATH=$HERE/$MEGAHIT:$PATH

#KMC=KMC3.linux.tar.gz
#echo "* $KMC"
#$WGET https://github.com/refresh-bio/KMC/releases/download/v3.0.0/$KMC
#tar xvf $KMC
#rm -fv kmc_dump kmc_tools
#PATH=$HERE:$PATH

PILONVER=1.22
JAR=pilon-$PILONVER.jar
PILON=pilon
PILONSH=$PILON/$PILON
echo "* $JAR"
$WGET https://github.com/broadinstitute/pilon/releases/download/v$PILONVER/$JAR
mkdir -p $PILON
echo "exec java -jar $PWD/$JAR" '"$@"' > $PILONSH
chmod +x $PILONSH
cat "$PILONSH"
PATH=$HERE/$PILON:$PATH

# http://cab.spbu.ru/files/release3.12.0/SPAdes-3.12.0-Linux.tar.gz
SPADESVER=3.12.0
SPADES=SPAdes-$SPADESVER-Linux
echo "* $SPADES"
$WGET http://cab.spbu.ru/files/release$SPADESVER/$SPADES.tar.gz
$UNTAR $SPADES.tar.gz
PATH=$HERE/$SPADES/bin:$PATH

LIGHTER=v1.1.1.tar.gz
echo "* $LIGHTER"
$WGET https://github.com/mourisl/Lighter/archive/$LIGHTER
$UNTAR $LIGHTER
$MAKE -C Lighter-1.1.1 
PATH=$HERE/Lighter-1.1.1:$PATH

FLASH=FLASH-1.2.11
echo "* $FLASH"
$WGET https://downloads.sourceforge.net/project/flashpage/$FLASH.tar.gz
$UNTAR $FLASH.tar.gz
$MAKE -C $FLASH 
PATH=$HERE/$FLASH:$PATH

TRIMVER=0.36
TRIM=Trimmomatic-$TRIMVER.zip
TRIMDIR=Trimmomatic-$TRIMVER
TRIMSH=$TRIMDIR/trimmomatic
echo "* $TRIM"
$WGET http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/$TRIM
unzip $TRIM
echo "exec java -jar $PWD/Trimmomatic-$TRIMVER/trimmomatic-$TRIMVER.jar" '"$@"' > $TRIMSH
chmod +x "$TRIMSH"
cat "$TRIMSH"
PATH=$HERE/$TRIMDIR:$PATH

VELVET=velvet
mkdir $VELVET
wget -O $VELVET/velveth 'https://github.com/Victorian-Bioinformatics-Consortium/vague/blob/master/velvet-binaries/linux-x86_64/velveth?raw=true'
wget -O $VELVET/velvetg 'https://github.com/Victorian-Bioinformatics-Consortium/vague/blob/master/velvet-binaries/linux-x86_64/velvetg?raw=true'
chmod +x $VELVET/*
PATH=$HERE/$VELVET:$PATH

# cover anything else
PATH=$PATH:$HERE

echo "Deleting source files"
rm -vf "$HERE/*.tar.*"
rm -vf "$HERE/*/*.{c,h,cpp,hpp,o}"

echo $PATH
export PATH
