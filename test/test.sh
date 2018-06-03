#!/bin/sh

set -eu

TESTDIR=$(dirname $0)
SHOVILL="$TESTDIR/../bin/shovill"
OUTDIR="$TESTDIR/testout"

echo "TESTDIR = $TESTDIR"
echo "OUTDIR = $OUTDIR"
echo "SHOVILL = $SHOVILL"

$SHOVILL --version
$SHOVILL --check
$SHOVILL --help
! $SHOVILL --doesnotexist
$SHOVILL --outdir "$OUTDIR" --R1 "$TESTDIR/R1.fq.gz" --R2 "$TESTDIR/R2.fq.gz" \
	--ram 3 --cpus 8 --depth 25 --force
grep '>' "$OUTDIR/contigs.fa"
rm -frv "$OUTDIR"
