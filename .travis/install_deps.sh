
HERE=$PWD

KMC=KMC3.linux.tar.gz
wget https://github.com/refresh-bio/KMC/releases/download/v3.0.0/$KMC
tar xvf $KMC
PATH=$HERE:$PATH

JAR=pilon-1.22.jar
PILON=pilon
wget https://github.com/broadinstitute/pilon/releases/download/v1.22/$JAR
echo "exec java -jar $PWD/$JAR" '"$@"' > $PILON
chmod +x $PILON

SPADES=SPAdes-3.11.0-Linux
wget http://spades.bioinf.spbau.ru/release3.11.0/$SPADES.tar.gz
tar xf $SPADES.tar.gz
PATH=$HERE/$SPADES/bin:$PATH

SAMTOOLS=samtools-1.4.1
wget https://github.com/samtools/samtools/releases/download/1.4.1/$SAMTOOLS.tar.bz2
tar xf $SAMTOOLS.tar.bz2
(cd $SAMTOOLS && ./configure --prefix=$HERE/$SAMTOOLS && make -j install)
PATH=$HERE/$SAMTOOLS/bin:$PATH

BWA=bwa-0.7.16a
wget https://github.com/lh3/bwa/releases/download/v0.7.16/$BWA.tar.bz2
tar xf $BWA.tar.bz2
make -C $BWA -j
PATH=$HERE/$BWA:$PATH

SEQTK=v1.2.tar.gz
wget https://github.com/lh3/seqtk/archive/$SEQTK
tar xf $SEQTK
make -C seqtk-1.2 -j
PATH=$HERE/seqtk-1.2:$PATH

LIGHTER=v1.1.1.tar.gz
wget https://github.com/mourisl/Lighter/archive/$LIGHTER
tar xf $LIGHTER
make -C Lighter-1.1.1 -j
PATH=$HERE/Lighter-1.1.1:$PATH

FLASH=FLASH-1.2.11
wget https://downloads.sourceforge.net/project/flashpage/$FLASH.tar.gz
tar xf $FLASH.tar.gz
make -C $FLASH -j
PATH=$HERE/$FLASH:$PATH

TRIM=Trimmomatic-0.36.zip
TRIMSH=trimmomatic
wget http://www.usadellab.org/cms/uploads/supplementary/Trimmomatic/$TRIM
unzip $TRIM
echo "exec java -jar $PWD/Trimmomatic-0.36/trimmomatic-0.36.jar" '"$@"' > $TRIMSH
chmod +x $TRIMSH

echo $PATH

export PATH
