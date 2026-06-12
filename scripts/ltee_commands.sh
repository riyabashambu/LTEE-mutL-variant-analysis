#!/bin/bash

#################################################
# LTEE mutL Variant Analysis - Command Record
# Author: Riya Bishambu
#################################################

# ---------------------------
# System Setup
# ---------------------------
cat /etc/os-release
uname -a

# ---------------------------
# Project Structure
# ---------------------------
mkdir -p LTEE_project/{data,results,docs,scripts}

# ---------------------------
# Download LTEE datasets
# ---------------------------
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/003/SRR2584863/SRR2584863_2.fastq.gz

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/006/SRR2584866/SRR2584866_2.fastq.gz

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR258/004/SRR2589044/SRR2589044_2.fastq.gz

# ---------------------------
# Quality Control
# ---------------------------
fastqc data/*.fastq.gz -o results

# ---------------------------
# Trimming (Trimmomatic)
# ---------------------------
java -jar /usr/share/java/trimmomatic.jar PE \
data/SRR2589044_1.fastq.gz data/SRR2589044_2.fastq.gz \
results/trimmed/SRR2589044_1.trimmed.fastq.gz results/orphaned/SRR2589044_1.unpaired.fastq.gz \
results/trimmed/SRR2589044_2.trimmed.fastq.gz results/orphaned/SRR2589044_2.unpaired.fastq.gz \
SLIDINGWINDOW:4:20 MINLEN:25

# (same for other samples - already executed in your work)

# ---------------------------
# Alignment (Bowtie2)
# ---------------------------
bowtie2 -x data/reference/rel606 \
-1 results/trimmed/SRR2584866_1.trimmed.fastq.gz \
-2 results/trimmed/SRR2584866_2.trimmed.fastq.gz \
-S results/sam/SRR2584866.sam --very-fast -p 4

# ---------------------------
# SAM → BAM processing
# ---------------------------
samtools view -S -b results/sam/SRR2584866.sam > results/bam/SRR2584866.bam
samtools sort -o results/bam/SRR2584866_sorted.bam results/bam/SRR2584866.bam
samtools index results/bam/SRR2584866_sorted.bam

# ---------------------------
# Variant Calling
# ---------------------------
bcftools mpileup -O b \
-f data/reference/GCF_000017985.1_ASM1798v1_genomic.fna \
results/bam/SRR2584866_sorted.bam \
-o results/bcf/SRR2584866_raw.bcf

bcftools call --ploidy 1 -m -v \
-o results/vcf/SRR2584866_variants.vcf \
results/bcf/SRR2584866_raw.bcf

vcfutils.pl varFilter results/vcf/SRR2584866_variants.vcf \
> results/vcf/SRR2584866_final_variants.vcf

# ---------------------------
# mutL region extraction
# ---------------------------
bcftools view -r NC_012967.1:4375567-4377414 \
results/vcf/SRR2584866_final_variants.vcf.gz \
-o results/mutLvar/SRR2584866_mutL.vcf

# ---------------------------
# Variant summary
# ---------------------------
grep -v "^#" results/mutLvar/SRR2584866_mutL.vcf | wc -l
