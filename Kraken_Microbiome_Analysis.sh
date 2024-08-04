#!/bin/bash

# Start the timer
start=$SECONDS

# Define paths to installed tools
KRAKEN2="$HOME/metagenomics_tools/kraken2/kraken2"
BRACKEN="$HOME/metagenomics_tools/bracken/bracken"
KRAKENTOOLS="$HOME/metagenomics_tools/krakentools"
BOWTIE2="$HOME/metagenomics_tools/bowtie2/bowtie2"
SAMTOOLS="$HOME/metagenomics_tools/samtools/samtools"

# Define paths for input data and output directories
INPUT_FASTQ1="sample_R1.fastq"
INPUT_FASTQ2="sample_R2.fastq"
OUTPUT_DIR="output"
KRAKEN_DB="kraken2_db" # Replace with your Kraken database path

# Create output directory
mkdir -p $OUTPUT_DIR

# Step 1: Run Kraken 2 for microbial identification
echo "Running Kraken 2..."
$KRAKEN2 --db $KRAKEN_DB --paired $INPUT_FASTQ1 $INPUT_FASTQ2 --output $OUTPUT_DIR/kraken2_output --report $OUTPUT_DIR/kraken2_report
echo "Kraken 2 classification completed."

# Step 2: Run Bracken for abundance estimation
echo "Running Bracken..."
$BRACKEN -d $KRAKEN_DB -i $OUTPUT_DIR/kraken2_report -o $OUTPUT_DIR/bracken_output -r 150 -l S
echo "Bracken abundance estimation completed."

# Step 3: Estimate diversity (alpha and beta) using KrakenTools
echo "Estimating diversity with KrakenTools..."
python3 $KRAKENTOOLS/DiversityTools/DiversityEstimation.py -i $OUTPUT_DIR/kraken2_output -o $OUTPUT_DIR/diversity_output
echo "Diversity estimation completed."

# Step 4: Visualize results with Pavian
echo "Launching Pavian for visualization..."
Rscript -e "pavian::runApp('$OUTPUT_DIR')"
echo "Pavian visualization completed."

# Step 5: Use Bowtie 2 for additional alignment (optional)
echo "Running Bowtie 2 alignment..."
$BOWTIE2 -x $KRAKEN_DB -1 $INPUT_FASTQ1 -2 $INPUT_FASTQ2 -S $OUTPUT_DIR/bowtie2_output.sam
echo "Bowtie 2 alignment completed."

# Step 6: Convert SAM to BAM, sort and index using Samtools
echo "Processing alignment with Samtools..."
$SAMTOOLS view -bS $OUTPUT_DIR/bowtie2_output.sam > $OUTPUT_DIR/bowtie2_output.bam
$SAMTOOLS sort $OUTPUT_DIR/bowtie2_output.bam -o $OUTPUT_DIR/bowtie2_output.sorted.bam
$SAMTOOLS index $OUTPUT_DIR/bowtie2_output.sorted.bam
echo "SAM to BAM conversion, sorting, and indexing completed."

# Calculate elapsed time
elapsed=$(( SECONDS - start ))
echo "Metagenomics analysis completed in $elapsed seconds."
