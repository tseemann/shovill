

.PHONY: reads spades shovill quast test  pub
.DEFAULT: test

test: clean quast
	fa -e test.fna test.shovill/contigs.fa test.spades/scaffolds.fasta

quast: shovill spades
#	rm -fr ./quast
	quast.py  -o quast -R test.fna test.shovill/contigs.fa test.spades/scaffolds.fasta

shovill: reads
#	rm -fr ./test.shovill
	../bin/shovill --outdir test.shovill --R1 test_R1.fq --R2 test_R2.fq --force

spades: reads
#	rm -fr ./test.spades
	spades.py -1 test_R1.fq -2 test_R2.fq --tmp-dir /tmp -o test.spades --careful

reads: test_R2.fq

test_R1.fq: test.fna
	wgsim -1 150 -2 150 -h -r 0 -R 0.005 -N 50000 test.fna test_R1.fq test_R2.fq
	
test_R2.fq: test_R1.fq

clean:
	rm -fr ./quast ./test.spades ./test.shovill test_R1.fq test_R2.fq
	
pub: quast
	cp -vrf quast/* /home/tseemann/public_html/tmp/quast/
	