# Scripts and data files for "Encoded lysine(s) near the N terminal increase the yield of expressed proteins in bacteria"

**Contacts**

- Claire Toffano-Nioche (<claire.toffano-nioche@u-psud.fr>)
- Daniel Gautheret (<daniel.gautheret@u-psud.fr>)
- Jean Lehmann (<rnalehmann03@gmail.com>)

## Note about the third-party tools

In order to increase the reproducibility of the computational analyses you may use the same conda environement (see yml files to create them).
Otherwise, install emboss (version 6.0) and Rbase (version 4.1.2) softwares.

## Scripts and computing environment configuration

- associate.sh: combines the measurements calculated for all species in a table
- compute.sh: compute measurements for one species (isoelectric point, CG%, Plong, Pavg, and P2nd)
- conda_env_Rbase_n_terminal_lysine.yml: file to create a conda environment to run R scripts
- conda_env_compute_n_terminal_lysine.yml: file to create a conda environment to run shell scripts
- get_nt.awk: get n fisrt nucleotides for each sequence of a multiple fasta file (used in compute.sh)
- transpose.awk: matrix transposition (used in compute.sh)

## Preparing data

selection of bacteria and archaea species: species were selected when they had a Topt_average and an Assembly_or_asseccion values in the [TEMPURA DB](http://togodb.org/db/tempura) and corresponding cDNA files (*cdna_from_genomics files.fasta.gz) were downloaded from the ncbi ftp site

eukaryota selection: downloaded from ncbi assembly query with [eukaryotes[organism] AND “reference genome"[RefSeq Category]](https://www.ncbi.nlm.nih.gov/assembly/?term=eukaryotes%5borganism%5d+AND+%E2%80%9Creference+genome%22%5bRefSeq+Category%5d). ?? and ?? were added to this selection.

### Repository architecture 
