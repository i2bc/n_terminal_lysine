# Scripts and data files for "Encoded lysine(s) near the N terminal increase the yield of expressed proteins in bacteria"

**Contacts**

- Claire Toffano-Nioche (<claire.toffano-nioche@u-psud.fr>)
- Daniel Gautheret (<daniel.gautheret@u-psud.fr>)
- Jean Lehmann (<rnalehmann03@gmail.com>)

## Scripts and computing environment configuration

- aaFreqByPos.R: R script to create a graph
- compute.sh: compute measurements and create summary table (isoelectric point, CG%, Plong, Pavg, and P2nd)
- conda_env_Rbase_n_terminal_lysine.yml: recipe to create a conda environment and run R script
- conda_env_compute_n_terminal_lysine.yml: recipe to create a conda environment and run shell script
- get_nt.awk: get n fisrt nucleotides for each sequence of a multiple fasta file (used in compute.sh)
- prepare_graphs.sh: prepare a shell file to create graph 
- transpose.awk: matrix transposition (used in compute.sh)

## Preparing data

### species selection

selection of **bacteria** and **archaea** species: species were selected when they have a Topt_average and an Assembly_or_asseccion values in the [TEMPURA DB](http://togodb.org/db/tempura) and corresponding cDNA files (*cdna_from_genomics files.fasta.gz) were downloaded from the ncbi ftp site.

**eukaryota** selection: downloaded from ncbi assembly query with [eukaryotes[organism] AND “reference genome"[RefSeq Category]](https://www.ncbi.nlm.nih.gov/assembly/?term=eukaryotes%5borganism%5d+AND+%E2%80%9Creference+genome%22%5bRefSeq+Category%5d) added with green alga, african frog and fission yeast. 
Downloaded cDNA files versions (*_cds_from_genomic.fna.gz) are:
GCA_000001215.4_Release_6_plus_ISO1_MT GCA_000001735.2_TAIR10.1 GCA_000002595.3_Chlamydomonas_reinhardtii_v5.5 GCA_000002945.2_ASM294v2_SchPom GCA_000002985.3_WBcel235 GCA_000146045.2_R64SacCer GCF_000001405.40_GRCh38.p14 GCF_000001635.27_GRCm39 GCF_000002035.6_GRCz11 GCF_017654675.1_J_2021 GCF_018350175.1_Fca126

### resources files

- download the [200617_TEMPURA.csv](http://togodb.org/release/200617_TEMPURA.csv) TEMPURA DB
- create 3 tsv files that list selected archaea, bacteria and eukaryota: genbank idientifier in column 1 and species name in column 2 (see `species_Archaea.list`, `species_Bacteria.list` and `species_Eukaryota.list` files for the lists used in the article).

### note about the third-party tools
In order to increase the reproducibility of the computational analyses we worked with conda environements and yml files to create them are given. Otherwise, softwares emboss (version 6.0) and R (version 4.1.2, including dplyr and ggplot2 libraries) are needed.

## Get frequencies amino-acids table and graphes
- run `n_terminal_lysine-main/compute.sh` to get the summary table => `*.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv`
- run `n_terminal_lysine-main/prepare_graphs.sh` (and run the resulting file) to get graphes for each species => `Tmp/KRNHYIaa_*.pdf` and `Tmp/KRNHYIaa_*.png`

## Usage example
download scripts:
```
unzip n_terminal_lysine-main.zip ;
```
which create: 
```
.
└── n_terminal_lysine-main
    ├── aaFreqByPos.R
    ├── compute.sh
    ├── get_nt.awk
    ├── README.md
    └── transpose.awk
```
download data (TEMPURA DB, 2 bacteria, 2 archaea):
```
wget http://togodb.org/release/200617_TEMPURA.csv
mkdir -p ncbi_gca ; cd ncbi_gca ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/305/GCA_000007305.1_ASM730v1/GCA_000007305.1_ASM730v1_cds_from_genomic.fna.gz ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/007/085/GCA_000007085.1_ASM708v1/GCA_000007085.1_ASM708v1_cds_from_genomic.fna.gz ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/009/965/GCA_000009965.1_ASM996v1/GCA_000009965.1_ASM996v1_cds_from_genomic.fna.gz ;
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/010/305/GCA_000010305.1_ASM1030v1/GCA_000010305.1_ASM1030v1_cds_from_genomic.fna.gz ;

cd .. ;
echo GCA_000007085.1$'\t'Caldanaerobacter subterraneus subsp. tengcongensis MB4$'\n'GCA_000010305.1$'\t'Gemmatimonas aurantiaca T-27 > bact.list ;
echo GCA_000007305.2$'\t'Pyrococcus furiosus DSM 3638$'\n'GCA_000009965.2$'\t'Thermococcus kodakarensis KOD1 > arch.list ;
```
which create: 
```
.
├── 200617_TEMPURA.csv
├── arch.list
├── bact.list
├── ncbi_gca
│   ├── GCA_000002945.2_ASM294v2_SchPom_cds_from_genomic.fna.gz
│   ├── GCA_000007305.1_ASM730v1_cds_from_genomic.fna.gz
│   ├── GCA_000007085.1_ASM708v1_cds_from_genomic.fna.gz
│   ├── GCA_000009965.1_ASM996v1_cds_from_genomic.fna.gz
│   ├── GCA_000010305.1_ASM1030v1_cds_from_genomic.fna.gz
│   └── GCA_000146045.2_R64SacCer_cds_from_genomic.fna.gz
└── n_term...
```
compute measurements:
for eukaryota, end with 0 in place of 11 (genetic code, -table option of emboss::transeq tools)
```
for sp in arch bact ; do bash compute.sh ${sp}.list n_terminal_lysine-main 11 ; done
```

which generate: 
```
.
├── ...
├── arch.list.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
├── bact.list.allAA_Plong_geeceeCDS_Toptave_iep_sp.tsv
└── Tmp
    ├── arch.list.geeceeCDS.tsv
    ├── arch.list.iepCDS.tsv
    ├── arch.list.P2nd_Pavg_Plong.tsv
    ├── arch.list.tempura_Topt_ave.tsv
    ├── bact.list.geeceeCDS.tsv
    ├── bact...
    ├── GCA_000007085.1_60nt_cfg.fna
    ├── GCA_000007085.1_60nt.faa
    ├── GCA_000007085.1_allAA.csv
    ├── GCA_000007085.1.geecee
    ├── GCA_000007085.1.iep
    ├── GCA_000007085.1.prophecy
    ├── GCA_000007085.1.transeq
    ├── GCA_000010305.1_60nt_cfg.fna
    ├── ...
    └── GCA_000010305.1.transeq
```
Graph creation for amino acids K, R, N, H, Y, and I frequencies on the first 20 protein residus: 
`prepare_graphs.sh` writes a shell script `*KRNHYIaa_aaFreqByPos_graphes.sh` that will create one graph by species (need Rscript):
```
for i in arch bact ; do bash prepare_graphs.sh $i.list n_terminal_lysine-main ; bash $i.list.KRNHYIaa_aaFreqByPos_graphes.sh ; done
```
which generate: 
```
.
├── ...
├── arch.list.KRNHYIaa_aaFreqByPos_graphes.sh
├── bact.list.KRNHYIaa_aaFreqByPos_graphes.sh
├── ...
└── Tmp
    ├── ...
    ├── KRNHYIaa_GCA_000007085.1.csv
    ├── KRNHYIaa_GCA_000007085.1.pdf
    ├── KRNHYIaa_GCA_000007085.1.png
    ├── ...
    └── KRNHYIaa_GCA_000010305.1.png
```
Resulting graphs stand in the `Tmp` repository, with `pdf` and `png` formats.

