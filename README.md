# Scripts and data files for "Encoded lysine(s) near the N terminal increase the yield of expressed proteins in bacteria"

Scripts are under the CeCILL 2.1 licence which is a free software licence, explicitly compatible with the GNU GPL.

**Contacts**

- Claire Toffano-Nioche (<claire.toffano-nioche@u-psud.fr>)
- Daniel Gautheret (<daniel.gautheret@u-psud.fr>)
- Jean Lehmann (<rnalehmann03@gmail.com>)

# Preparing environment and data

## Configuring computing environement

### Script and configuration files
Clone (`git clone git@github.com:i2bc/n_terminal_lysine`) or donwload this archive. 

In a `n_terminal_lysine` repository, you may have:
- KRNHYIaa_GCA_000146045.2.pdf : the graph of some aa frequencies by position for Saccharomyces cerevisiae S288C R64 strain
- aaFreqByPos.R: R script to create a graph
- compute.sh: compute measurements and create summary table (isoelectric point, CG%, Plong, Pavg, and P2nd)
- conda_env_Rbase_n_terminal_lysine.yml: recipe to create a conda environment and run R script
- conda_env_compute_n_terminal_lysine.yml: recipe to create a conda environment and run shell script
- get_nt.awk: get n fisrt nucleotides for each sequence of a multiple fasta file (used in compute.sh)
- prepare_graphs.sh: prepare a shell file to create graph 
- transpose.awk: matrix transposition (used in compute.sh)
- README.md (this file)
- species_Archaea.list, species_Bacteria.list, species_Eukaryotes.list (lists of cdna_sequences used in the article)

### Note about the third-party tools
In order to increase the reproducibility of the computational analyses we worked with conda environements (see the yml files to create them, `conda_env_*_n_terminal_lysine.yml`). Otherwise, softwares emboss (version 6.0) and R (version 4.3.1, including dplyr and ggplot2 libraries) are needed.

## Data

### Optimal growth temperature

We download the [200617_TEMPURA.csv](http://togodb.org/release/200617_TEMPURA.csv), a table containing optimal growth temperature for some archaea and bacteria species.

### Species selection

**bacteria** and **archaea** species were selected when they have both a Topt_average and an Assembly_or_asseccion values in the [200617_TEMPURA.csv](http://togodb.org/release/200617_TEMPURA.csv) and a corresponding cDNA files (`*cdna_from_genomics files.fasta.gz`) to download from the ncbi ftp site.

**eukaryota** selection: downloaded from ncbi assembly query with [eukaryotes[organism] AND “reference genome"[RefSeq Category]](https://www.ncbi.nlm.nih.gov/assembly/?term=eukaryotes%5borganism%5d+AND+%E2%80%9Creference+genome%22%5bRefSeq+Category%5d) added with green alga, african frog and fission yeast. 
Downloaded cDNA files versions (*_cds_from_genomic.fna.gz) are:
```
GCA_000001215.4_Release_6_plus_ISO1_MT          # Drosophila melanogaster 6           # fruit fly
GCA_000001735.2_TAIR10.1                        # Arabidopsis thaliana TAIR10         # thale cress
GCA_000002595.3_Chlamydomonas_reinhardtii_v5.5  # Chlamydomonas reinhardtii v5.5      # green alga
GCA_000002945.2_ASM294v2_SchPom                 # Schizosaccharomyces pombe ASM294v2  # fission yeast
GCA_000002985.3_WBcel235                        # Caenorhabditis elegans cel235       # worm
GCA_000146045.2_R64SacCer                       # Saccharomyces cerevisiae S288C      # baker's yeast
GCF_000001405.40_GRCh38.p14                     # Homo sapiens GRCh38.p14             # human
GCF_000001635.27_GRCm39                         # Mus musculus GRCm39                 # house mouse
GCF_000002035.6_GRCz11                          # Danio rerio GRCz11                  # zebrafish
GCF_017654675.1_J_2021                          # Xenopus laevis                      # African frog
```

# Runing 

Run first the `compute.sh` script to get a summary table, the `prepare_graphs.sh` script to create a shell script adapted to your data, and next this last shell script to obtains one frequencies amino-acids graph by spacies.

## Get the frequencies amino-acids table

Run `n_terminal_lysine/compute.sh` to get a summary table, `*.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv`

This table contains 83 columns: 

* GCA_ID: the ncbi GCA identifier
* X_P2nd, X_Pavg, X_Plong: 78 values for the 3 measurements to characterize a peak for each letter of the alphabet standing for aa
* geeceeCDS: mean of the GC% computed on the CDS aa sequences
* tempura_Topt_ave: optimal growth temperature extracted from the TEMPURA database when available
* iepCDS: mean of the iso-electric points computed on the CDS aa sequences
* species_name: name of the species

## Get the frequencies amino-acids graphes

Run `n_terminal_lysine/prepare_graphs.sh` (and run the resulting file, `*KRNHYIaa_aaFreqByPos_graphes.sh`) to get graphes (`Tmp/KRNHYIaa_*.pdf` and `Tmp/KRNHYIaa_*.png`) for each species with the K, R, N, H, Y, and I aa. `KRNHYIaa_GCA_000146045.2.pdf` is an example for the the Saccharomyces cerevisiae S288C R64 strain.

## A usage example with 2 species from the 3 domain of life
Go to the `n_terminal_lysine` repository.

### Data

Download data (TEMPURA DB, 2 bacteria, 2 archaea, 2 eukaryota):
```
wget http://togodb.org/release/200617_TEMPURA.csv
mkdir -p ncbi_gca ; cd ncbi_gca ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/305/GCA_000007305.1_ASM730v1/GCA_000007305.1_ASM730v1_cds_from_genomic.fna.gz ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/085/GCA_000007085.1_ASM708v1/GCA_000007085.1_ASM708v1_cds_from_genomic.fna.gz ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/009/965/GCA_000009965.1_ASM996v1/GCA_000009965.1_ASM996v1_cds_from_genomic.fna.gz ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/010/305/GCA_000010305.1_ASM1030v1/GCA_000010305.1_ASM1030v1_cds_from_genomic.fna.gz ;
wget ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/146/045/GCA_000146045.2_R64/GCA_000146045.2_R64_cds_from_genomic.fna.gz ;
wget ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/002/945/GCA_000002945.2_ASM294v2/GCA_000002945.2_ASM294v2_cds_from_genomic.fna.gz ;
cd .. ;
```
Create 3 files that lists selected archaea, bacteria and eukaryota species with genbank identifier in column 1 and species name in column 2 (see `species_Archaea.list`, `species_Bacteria.list` and `species_Eukaryota.list` files for the lists used in the article).
```
echo GCA_000007085.1$'\t'Caldanaerobacter subterraneus subsp. tengcongensis MB4$'\n'GCA_000010305.1$'\t'Gemmatimonas aurantiaca T-27 > bact.list ;
echo GCA_000007305.1$'\t'Pyrococcus furiosus DSM 3638$'\n'GCA_000009965.1$'\t'Thermococcus kodakarensis KOD1 > arch.list ;
echo GCA_000146045.2$'\t'Saccharomyces cerevisiae S288C R64$'\n'GCA_000002945.2$'\t'Schizosaccharomyces pombe > euka.list ;
```
You may have: 
```
.
├── 200617_TEMPURA.csv
├── arch.list
├── bact.list
├── euka.list
├── ncbi_gca
│   ├── GCA_000002945.2_ASM294v2_cds_from_genomic.fna.gz
|   ├── GCA_000007085.1_ASM708v1_cds_from_genomic.fna.gz
│   ├── GCA_000007305.1_ASM730v1_cds_from_genomic.fna.gz
│   ├── GCA_000009965.1_ASM996v1_cds_from_genomic.fna.gz
│   ├── GCA_000010305.1_ASM1030v1_cds_from_genomic.fna.gz
│   └── GCA_000146045.2_R64_cds_from_genomic.fna.gz
└── ...
```
### Measures

Compute measurements:

Activate the conda environment: `conda activate emboss_ce`

For eukaryota, end with 0 in place of 11 for archaea and bacteria (genetic code, `-table` option of the `emboss::transeq` tool).
```
for sp in arch bact ; do bash compute.sh ${sp}.list ../n_terminal_lysine 11 ; done
for sp in euka ; do bash compute.sh ${sp}.list ../n_terminal_lysine 0 ; done
```

which generates: 
```
.
├── ...
├── arch.list.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
├── bact.list.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
├── euka.list.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
└── Tmp
    ├── arch.list.geeceeCDS.tsv
    ├── arch.list.iepCDS.tsv
    ├── arch.list.P2nd_Pavg_Plong.tsv
    ├── arch.list.tempura_Topt_ave.tsv
    ├── bact.list.geeceeCDS.tsv
    ├── bact...
    ├── GCA_000002945.2_60nt_cfg.fna
    ├── GCA_000002945.2_60nt.faa
    ├── GCA_000002945.2_allAA.csv
    ├── GCA_000002945.2.geecee
    ├── GCA_000002945.2.iep
    ├── GCA_000002945.2.prophecy
    ├── GCA_000002945.2.transeq
    ├── GCA_000007085.1_60nt_cfg.fna
    ├── ...
    └── GCA_000146045.2.transeq
```
The `*.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv` are the resulting tables.

### Graphs

Create graphs for amino acids K, R, N, H, Y, and I frequencies on the first 20 protein residus: 

Activate the conda environment: `conda activate Rgraph_n_terminal_lysine`

The `prepare_graphs.sh` script prepares a shell script, `*KRNHYIaa_aaFreqByPos_graphes.sh`, for each list of species. And when it is run, it will create one graph for each species (need Rscript):
```
for i in arch bact euka ; do
   bash prepare_graphs.sh $i.list ../n_terminal_lysine ;
   bash $i.list.KRNHYIaa_aaFreqByPos_graphes.sh ;
done
```
which generates: 
```
.
├── ...
├── arch.list.KRNHYIaa_aaFreqByPos_graphes.sh
├── bact.list.KRNHYIaa_aaFreqByPos_graphes.sh
├── euka.list.KRNHYIaa_aaFreqByPos_graphes.sh
├── ...
└── Tmp
    ├── ...
    ├── KRNHYIaa_GCA_000002945.2.csv
    ├── KRNHYIaa_GCA_000002945.2.pdf
    ├── KRNHYIaa_GCA_000002945.2.png
    ├── ...
    └── KRNHYIaa_GCA_000146045.2.png
```
Resulting graphs stand in the `Tmp` repository (`pdf` and `png` formats).
The graph for the Saccharomyces cerevisiae S288C R64 strain, `KRNHYIaa_GCA_000146045.2.pdf`, is supplied as an example of the correct operation of the codes.
