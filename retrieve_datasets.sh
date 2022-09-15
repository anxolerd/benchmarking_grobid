#!/bin/bash


# Retrieve archive.org data
mkdir -p arxiv-all
for num in `seq 1 3647`; do
    curl --silent --show-error --fail \
        $(printf "https://arxiv.org/pdf/2012.%05d.pdf" $num) \
        -o $(printf "arxiv-all/2021.%05d.pdf" $num);
done


# Retrieve cv data
git clone git@github.com:arefinnomi/curriculum_vitae_data


# Retrieve technical articles, manuals and slides data
git clone git@github.com:tpn/pdfs

# Retrieve biorxiv data
mkdir -p biorxiv
cd biorxiv
for purpose in "test-2000" "train-6000" "validation-2000"; do
  wget -c https://zenodo.org/record/3873702/files/biorxiv-10k-${purpose}.zip?download=1 -O ${purpose}.zip
  mkdir -p ${purpose}
  unzip ${purpose}.zip -d ${purpose}
done
cd ../


# Create datasets direcories
mkdir -p datasets/{arxiv,cv,tech,biorxiv,biorxiv-test,biorxiv-train,biorxiv-validation}

# Hardlink pdfs from datasets to corresponding directories
find curriculum_vitae_data/ -name '*.pdf' -print -exec ln {} datasets/cv/ \;
find arxiv-all/ -name '*.pdf' -print -exec ln {} datasets/arxiv/ \;
find pdfs/ -name '*.pdf' -print -exec ln {} datasets/tech/ \;
find biorxiv/ -name '*.pdf' -print -exec ln {} datasets/biorxiv/ \;
find biorxiv/test-2000/ -name '*.pdf' -print -exec ln {} datasets/biorxiv-test/ \;
find biorxiv/train-6000/ -name '*.pdf' -print -exec ln {} datasets/biorxiv-train/ \;
find biorxiv/validation-2000/ -name '*.pdf' -print -exec ln {} datasets/biorxiv-validation/ \;

# Done, print datasets sizes
echo -e 'Dataset\tSamples'
for dataset in $(ls datasets); do
    echo -e "${dataset}\t$(ls datasets/${dataset} | wc -l)"
done
