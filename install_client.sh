#!/bin/bash
python -m venv ./.venv
source ./.venv/bin/activate

git clone https://github.com/kermitt2/grobid_client_python
cd grobid_client_python
python setup.py install
