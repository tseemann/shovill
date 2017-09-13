
HERE="$PWD"
WGET="wget --quiet"
MAKE="make --silent -j"
UNTAR="tar xf"

SEQTK=v1.2.tar.gz
$WGET https://github.com/lh3/seqtk/archive/$SEQTK
$UNTAR $SEQTK
$MAKE -C seqtk-1.2
chmod g-w seqtk-1.2/seqtk
PATH=$HERE/seqtk-1.2:$PATH

KMC=KMC3.linux.tar.gz
$WGET https://github.com/refresh-bio/KMC/releases/download/v3.0.0/$KMC
tar xvf $KMC
rm -fv kmc_dump kmc_tools
PATH=$HERE:$PATH

JAR=pilon-1.22.jar
PILON=pilon
$WGET https://github.com/broadinstitute/pilon/releases/download/v1.22/$JAR
echo "exec java ar $PWD/$JAR" '"$@"' > $PILON
chmod +x $PILON

SPADES=SPAdes-3.11.0-Linux
$WGET http://spades.bioinf.spbau.ru/release3.11.0/$SPADES.tar.gz
$UNTAR $SPADES.tar.gz
PATH=$HERE/$SPADES/bin:$PATH

SAMTOOLS=samtools-1.5
$WGET https://github.com/samtools/samtools/releases/download/1.5/$SAMTOOLS.tar.bz2
$UNTAR $SAMTOOLS.tar.bz2
(cd $SAMTOOLS && ./configure --prefix=$HERE/$SAMTOOLS && $MAKE install)
PATH=$HERE/$SAMTOOLS/bin:$PATH

BWA=bwa-0.7.16a
$WGET https://github.com/lh3/bwa/releases/download/v0.7.16/$BWA.tar.bz2
$UNTAR $BWA.tar.bz2
$MAKE -C $BWA 
PATH=$HERE/$BWA:$PATH

LIGHTER=v1.1.1.tar.gz
$WGET https://github.com/mourisl/Lighter/archive/$LIGHTER
$UNTAR $LIGHTER
$MAKE -C Lighter-1.1.1 
PATH=$HERE/Lighter-1.1.1:$PATH

FLASH=FLASH-1.2.11
$WGET https://downloads.sourceforge.net/project/flashpage/$FLASH.tar.gz
$UNTAR $FLASH.tar.gz
$MAKE -C $FLASH 
PATH=$HERE/$FLASH:$PATH

TRIM=Trimmomatic-0.36.zip
TRIMSH=trimmomatic
$WGET http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/$TRIM
unzip $TRIM
echo "exec java ar $PWD/Trimmomatic-0.36/trimmomatic-0.36.jar" '"$@"' > $TRIMSH
chmod +x $TRIMSH

echo "Deleting source files"
rm -vf "$HERE/*.tar.*"
rm -vf "$HERE/*/*.{c,h,cpp,hpp,o}"

echo $PATH
export PATH
