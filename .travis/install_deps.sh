
HERE="$PWD"
WGET="wget --quiet"
MAKE="make --silent -j"
UNTAR="tar xf"

SEQTKVER=1.2
SEQTK=v$SEQTKVER.tar.gz
echo "* $SEQTK"
$WGET https://github.com/lh3/seqtk/archive/$SEQTK
$UNTAR $SEQTK
$MAKE -C seqtk-$SEQTKVER
chmod g-w seqtk-$SEQTKVER/seqtk
PATH=$HERE/seqtk-$SEQTKVER:$PATH

KMC=KMC3.linux.tar.gz
echo "* $KMC"
$WGET https://github.com/refresh-bio/KMC/releases/download/v3.0.0/$KMC
tar xvf $KMC
rm -fv kmc_dump kmc_tools
PATH=$HERE:$PATH

PILONVER=1.22
JAR=pilon-$PILONVER.jar
PILON=pilon
echo "* $JAR"
$WGET https://github.com/broadinstitute/pilon/releases/download/v$PILONVER/$JAR
echo "exec java -jar $PWD/$JAR" '"$@"' > $PILON
chmod +x $PILON

SPADESVER=3.11.0
SPADES=SPAdes-$SPADESVER-Linux
echo "* $SPADES"
$WGET http://spades.bioinf.spbau.ru/release$SPADESVER/$SPADES.tar.gz
$UNTAR $SPADES.tar.gz
PATH=$HERE/$SPADES/bin:$PATH

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
TRIMSH=trimmomatic
echo "* $TRIM"
$WGET http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/$TRIM
unzip $TRIM
echo "exec java ar $PWD/Trimmomatic-$TRIMVER/trimmomatic-$TRIMVER.jar" '"$@"' > $TRIMSH
chmod +x $TRIMSH

echo "Deleting source files"
rm -vf "$HERE/*.tar.*"
rm -vf "$HERE/*/*.{c,h,cpp,hpp,o}"

echo $PATH
export PATH
