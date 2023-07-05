# Scripts and data files for "Encoded lysine(s) near the N terminal increase the yield of expressed proteins in bacteria"

**Contacts**

- Claire Toffano-Nioche (<claire.toffano-nioche@u-psud.fr>)
- Daniel Gautheret (<daniel.gautheret@u-psud.fr>)
- Jean Lehmann (<rnalehmann03@gmail.com>)

## Note about the third-party tools

In order to increase the reproducibility of the computational analyses we worked with conda environements and yml files to create them are given. Oherwise, softwares emboss (version 6.0) and R (version 4.1.2, including dplyr and ggplot2 libraries) are needed.

## Scripts and computing environment configuration

- aaFreqByPos.R: R script to create a graph 
- associate.sh: combines the measurements calculated for all species in a table (to run after compute.sh)
- compute.sh: compute measurements for one species (isoelectric point, CG%, Plong, Pavg, and P2nd)
- conda_env_Rbase_n_terminal_lysine.yml: recipe to create a conda environment and run R script
- conda_env_compute_n_terminal_lysine.yml: recipe to create a conda environment and run shell script
- get_nt.awk: get n fisrt nucleotides for each sequence of a multiple fasta file (used in compute.sh)
- transpose.awk: matrix transposition (used in compute.sh)

## Preparing data

selection of bacteria and archaea species: species were selected when they had a Topt_average and an Assembly_or_asseccion values in the [TEMPURA DB](http://togodb.org/db/tempura) and corresponding cDNA files (*cdna_from_genomics files.fasta.gz) were downloaded from the ncbi ftp site.

eukaryota selection: downloaded from ncbi assembly query with [eukaryotes[organism] AND “reference genome"[RefSeq Category]](https://www.ncbi.nlm.nih.gov/assembly/?term=eukaryotes%5borganism%5d+AND+%E2%80%9Creference+genome%22%5bRefSeq+Category%5d) added with green alga, african frog and fission yeast. 
Downloaded cDNA files versions (*_cds_from_genomic.fna.gz) are:
GCA_000001215.4_Release_6_plus_ISO1_MT GCA_000001735.2_TAIR10.1 GCA_000002595.3_Chlamydomonas_reinhardtii_v5.5 GCA_000002945.2_ASM294v2_SchPom GCA_000002985.3_WBcel235 GCA_000146045.2_R64SacCer GCF_000001405.40_GRCh38.p14 GCF_000001635.27_GRCm39 GCF_000002035.6_GRCz11 GCF_017654675.1_J_2021 GCF_018350175.1_Fca126

### Repository architecture 
