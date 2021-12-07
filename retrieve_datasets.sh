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


# Create datasets direcories
mkdir -p datasets/{arxiv,cv,tech}

# Hardlink pdfs from datasets to corresponding directories
find curriculum_vitae_data/ -name '*.pdf' -print -exec ln {} datasets/cv/ \;
find arxiv-all/ -name '*.pdf' -print -exec ln {} datasets/arxiv/ \;
find pdfs/ -name '*.pdf' -print -exec ln {} datasets/tech/ \;

# Done, print datasets sizes
echo -e 'Dataset\tSamples'
for dataset in $(ls datasets); do
    echo -e "${dataset}\t$(ls datasets/${dataset} | wc -l)"
done
