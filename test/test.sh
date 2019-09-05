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
rm -frv "$OUTDIR"
$SHOVILL --outdir "$OUTDIR" --R1 "$TESTDIR/R1.fq.gz" --R2 "$TESTDIR/R2.fq.gz" \
	 --depth 25 --force --trim
grep '>' "$OUTDIR/contigs.fa" | head
