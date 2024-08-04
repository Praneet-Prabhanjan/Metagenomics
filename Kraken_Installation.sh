#!/bin/bash

# Software versions
KRAKEN2_VERSION="2.1.1"
BRACKEN_VERSION="2.6.2"
KRAKENTOOLS_VERSION="1.1"
PAVIAN_VERSION="1.0"
BOWTIE2_VERSION="2.4.4"
SAMTOOLS_VERSION="1.10" # Newer version than 0.1.20

# Define installation paths
INSTALL_DIR="$HOME/metagenomics_tools"
KRAKEN2_DIR="$INSTALL_DIR/kraken2"
BRACKEN_DIR="$INSTALL_DIR/bracken"
KRAKENTOOLS_DIR="$INSTALL_DIR/krakentools"
PAVIAN_DIR="$INSTALL_DIR/pavian"
BOWTIE2_DIR="$INSTALL_DIR/bowtie2"
SAMTOOLS_DIR="$INSTALL_DIR/samtools"

# Create installation directory
mkdir -p $INSTALL_DIR

# Install Kraken 2
echo "Installing Kraken 2..."
git clone --recurse-submodules https://github.com/DerrickWood/kraken2.git $KRAKEN2_DIR
cd $KRAKEN2_DIR
git checkout v$KRAKEN2_VERSION
./install_kraken2.sh $INSTALL_DIR
echo "Kraken 2 installed."

# Install Bracken
echo "Installing Bracken..."
git clone https://github.com/jenniferlu717/Bracken.git $BRACKEN_DIR
cd $BRACKEN_DIR
git checkout v$BRACKEN_VERSION
bash install_bracken.sh
echo "Bracken installed."

# Install KrakenTools
echo "Installing KrakenTools..."
git clone https://github.com/jenniferlu717/KrakenTools.git $KRAKENTOOLS_DIR
cd $KRAKENTOOLS_DIR
git checkout v$KRAKENTOOLS_VERSION
echo "KrakenTools installed."

# Install Bowtie 2
echo "Installing Bowtie 2..."
git clone --branch v$BOWTIE2_VERSION https://github.com/BenLangmead/bowtie2.git $BOWTIE2_DIR
cd $BOWTIE2_DIR
make
echo "Bowtie 2 installed."

# Install Samtools
echo "Installing Samtools..."
git clone --branch $SAMTOOLS_VERSION https://github.com/samtools/samtools.git $SAMTOOLS_DIR
cd $SAMTOOLS_DIR
./configure --prefix=$SAMTOOLS_DIR
make
make install
echo "Samtools installed."

# Install R and RStudio (assuming Linux environment)
echo "Installing R..."
sudo apt update
sudo apt install -y r-base
echo "R installed."

echo "Installing RStudio..."
sudo apt install gdebi-core -y
wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.4.1717-amd64.deb
sudo gdebi --non-interactive rstudio-1.4.1717-amd64.deb
rm rstudio-1.4.1717-amd64.deb
echo "RStudio installed."

# Install Pavian in R
echo "Installing Pavian..."
Rscript -e "install.packages('devtools', repos='http://cran.rstudio.com/')"
Rscript -e "devtools::install_github('fbreitwieser/pavian', build_vignettes=TRUE)"
echo "Pavian installed."

echo "All software installations completed successfully."
