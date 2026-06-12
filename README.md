# LTEE mutL Variant Analysis

## Project Overview

This project investigates genetic variation in the **mutL DNA mismatch repair gene** from sequencing datasets derived from the Long-Term Evolution Experiment (LTEE) with *Escherichia coli*. The analysis pipeline was implemented in a Linux (WSL) environment and includes quality control, read preprocessing, genome alignment, variant calling, and targeted mutation analysis.

## Prerequisites & Installation

### System Requirements
- Linux (WSL or Ubuntu recommended)
- 8 GB RAM minimum
- 10–15 GB storage

### Tools Used
| Tool        | Purpose                                   |
| ----------- | ----------------------------------------- |
| FastQC      | Quality assessment of raw reads           |
| Trimmomatic | Read trimming and filtering               |
| BWA         | Reference genome alignment                |
| SAMtools    | Alignment processing and BAM manipulation |
| BCFtools    | Variant calling and filtering             |

### Installation (Ubuntu/WSL)

```bash
sudo apt update
sudo apt install fastqc bwa samtools bcftools trimmomatic
```

## Background

The Long-Term Evolution Experiment (LTEE), initiated by Richard Lenski in 1988, tracks evolutionary changes in *E. coli* populations over tens of thousands of generations. Mutations in DNA repair genes such as **mutL** can influence mutation rates and contribute to adaptive evolution.

This project focuses on identifying and examining variants within the **mutL** genomic region from selected LTEE sequencing datasets.

## Objectives

* Download and process publicly available LTEE sequencing data.
* Assess sequencing quality using FastQC.
* Trim low-quality bases and adapter contamination.
* Align sequencing reads to the reference genome.
* Perform variant calling and filtering.
* Extract and analyze variants located in the **mutL** gene region.
* Generate reproducible results using command-line bioinformatics tools.

## Datasets

The following sequencing runs were analyzed:

| SRA Accession |
| ------------- |
| SRR2584863    |
| SRR2584866    |
| SRR2589044    |
Data was obtained from NCBI SRA (LTEE project)

### Reference Genome
- Escherichia coli K-12 MG1655 (NCBI RefSeq)

## Analysis Workflow

1. **Data Acquisition**

   * Download sequencing data from the NCBI Sequence Read Archive (SRA).

2. **Quality Control**

   * Evaluate read quality using FastQC.

3. **Read Preprocessing**

   * Remove low-quality bases and sequencing artifacts.

4. **Genome Alignment**

   * Align filtered reads to the reference genome using BWA.

5. **Alignment Processing**

   * Convert SAM to BAM format.
   * Sort and index alignment files using SAMtools.

6. **Variant Calling**

   * Generate variant calls using BCFtools.

7. **Variant Filtering**

   * Retain high-confidence variants.

8. **mutL Gene Analysis**

   * Extract variants overlapping the mutL genomic region.
   * Examine candidate mutations for further interpretation.

Variant counts were obtained using bcftools after removing header lines and filtering for high-quality calls.

## Repository Structure

```text
LTEE_project/
├── data/                # Raw sequencing data (excluded from GitHub)
├── scripts/             # Analysis scripts
├── results/
│   ├── mutLvar/         # mutL-specific variant results
│   └── vcf/             # Filtered variant call files
├── README.md
```
## Key Results

Variant calling was performed on three LTEE *E. coli* datasets:

* SRR2584863
* SRR2584866
* SRR2589044

### Summary of Variants Detected

| Sample     | Total Variants Identified    |
| ---------- | ---------------------------- |
| SRR2584863 | 32                           |
| SRR2584866 | 833                          |
| SRR2589044 | 29                           |
These counts represent raw variant calls after alignment and initial filtering.

### mutL Gene Findings

* A total of **1 high-confidence variant** was identified within the **mutL gene region (or its flanking region)**.
* These variants were extracted and filtered for high-confidence calls.
* The final annotated mutation set is stored in:

```
results/mutLvar/SRR2584866_mutL.vcf
```
| Chromosome  | Position | Reference | Alternate | QUAL   | Type |
|-------------|----------|-----------|-----------|--------|------|
| NC_012967.1 | 4377265  | A         | G         | 225.417| SNP  |

### Interpretation

A single nucleotide polymorphism (SNP) was identified in the mutL gene region at position 4377265, involving an A → G substitution.

This mutation shows:
- High confidence (QUAL = 225.417)
- Strong read support (DP4 = 0,0,30,24)
- No filter failure (PASS)

If located within the coding region, this SNP may:
- Be synonymous (no amino acid change), or  
- Be nonsynonymous (amino acid substitution affecting protein function)

Since mutL is a DNA mismatch repair gene, such mutations may contribute to a **mutator phenotype**, increasing genome-wide mutation rates in LTEE populations and accelerating evolutionary adaptation.

## Key Outputs

- Quality control reports (FastQC)
- BAM/SAM processed alignments
- Filtered VCF files
- mutL-specific variant extraction

## Reproducibility

The analysis was performed in a Linux (WSL) environment using open-source bioinformatics software. Large raw sequencing datasets and intermediate alignment files are excluded from this repository because of GitHub storage limitations. Processed outputs and workflow documentation are included to support reproducibility.

## Future Improvements

* Functional annotation of identified variants
* Comparative analysis across LTEE populations
* Automated workflow implementation using Snakemake or Nextflow
* Visualization of variant distributions and mutation patterns

## Author

**Riya**
Bioinformatics Project – LTEE Variant Analysis

## Citation

Dataset sourced from the NCBI Sequence Read Archive (SRA) as part of the LTEE project.






