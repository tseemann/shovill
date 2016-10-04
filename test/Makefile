
test: reads
	../bin/shovill --outdir test.out --R1 test_R1.fq.gz --R2 test_R2.fq.gz --gsize 0.2M --force --kmers 51,91

reads: test_R1.fq.gz test_R2.fq.gz

test_R1.fq.gz: test.fna
	wgsim -1 150 -2 150 -h -r 0 -R 0 -N 50000 test.fna test_R1.fq test_R2.fq
	gzip test_R1.fq test_R2.fq
	
test_R2.fq.gz: test_R1.fq.gz

clean:
	rm -fr ./test.out test_R1.fq test_R2.fq
			