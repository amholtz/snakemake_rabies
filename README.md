# ML analysis of Global Rabies Reconstruction

This folder contains Snakemake [Köster *et al.*, 2012](https://doi.org/10.1093/bioinformatics/bts480) pipelines
for reconstruction of evolutionary history of Rabies virus.

This pipeline has been adapted from a similar ML analysis [[Zhukova 2020]](https://github.com/evolbioinfo/zika_Vietnam)

The pipeline steps are detailed below.

## Pipeline

### 0. Input data
The input data are located in the [data](data) folder and contain (1) Rabies Sequences
 [ncbi_RABV_11500_12000_cleaned.fasta](data/ncbi_RABV_11500_12000_cleaned.fasta),
which were downloaded from GenBank [[Benson *et al.* 2013]](https://www.ncbi.nlm.nih.gov/pubmed/23193287)
on 10-October 2020 with the keywords: organism “Rabies virus”, and sequence length between 11500 and 12000 (full genome).


### 1. Metadata and MSA
#### Sampling dates and countries
Meta data was downloaded from [NCBI Virus Database](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/) with collection_date, country, sequence length, and 
host species.

#### Cleaning
248 sequences without any corresponding metadata were removed from the fa file 
by running [remove_sequences](snakemake/r/remove_sequences.R) R script. Additionally, six sequences determined to be
laboratory strains of RABV were also removed (GQ412744, JN234411, KF154998, FJ959397, EF564174, HQ317918).

### MSA

The sequences were aligned against the reference [[Tordo *et al.* 1988]](https://pubmed.ncbi.nlm.nih.gov/3407152/) 
, which was removed from the alignment, with MAFFT [[Katoh and Standley 2013](https://academic.oup.com/mbe/article/30/4/772/1073398)].

##### *DIY*

The metadata extraction, sequence combining and alignment pipeline [snakefile_MSA](snakemake/snakefile_MSA)
is available in the [snakemake](snakemake) folder and can be rerun as (from the snakemake folder):
```bash
snakemake --snakefile snakefile_MSA --keep-going --config folder=.. --use-singularity -singularity-args "--home ~"
```

### 2. Phylogeny reconstruction
We reconstructed a maximum likelihood tree from the DNA sequences using partitioning into four groups: (1) coding 
regions for positions 1-2, (2) coding regions for positions 3, (3) noncoding regions within in a gene, and (4)
noncoding regions outside of any gene. 
The tree reconstruction was performed with 2 ML tools allowing for partitioning (GTRGAMMA+G6+I):
RAxML-NG [[Stamatakis, 2014](https://doi.org/10.1093/bioinformatics/btu033)] and IQ-TREE 2 [[Minh *et al.*, 2020](https://doi.org/10.1093/molbev/msaa015)],
resulting in 2 trees with different topologies.

The non-informative branches (<= 1/2 mutation) were then collapsed.

#### DIY
The phylogeny reconstruction pipeline [snakefile_phylogeny](snakemake/snakefile_phylogeny) is avalable in the [snakemake](snakemake) folder and can be rerun as (from the snakemake folder):
```bash
snakemake --snakefile snakefile_phylogeny --keep-going --config folder=.. --use-singularity -singularity-args "--home ~"
```
### 3. Phylogeography
The phylogeny was dated and rooted with LSD 2 [To *et al.*, 2015](https://academic.oup.com/sysbio/article/65/1/82/2461506) (with temporal outlier removal).
The rootings were reviewed and any clade formations were observed against country of origin and virus host species.
To identify the order and family of the host species, the R script [species_to_family.R](snakemake/r/species_to_family). Three
distinct groups in the original tree were identified, and the tree was split into three different groups by isolating 
their accession numbers from the original global tree. The MSA alignment file was then 
regrouped by the skunks and raccoons group, bats groups, and dogs group.


#### DIY
To perform phylogeographic analysis, from the [snakemake](snakemake)folder, run the [snakefile_phylogeography](snakemake/snakefile_phylogeography) pipeline:
```bash
snakemake --snakefile snakefile_phylogeography --keep-going --config folder=.. --use-singularity --singularity-args "--home ~"
```

### 4. Phylogeography
