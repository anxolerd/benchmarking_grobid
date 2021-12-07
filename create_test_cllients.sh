#!/bin/bash

# vim: set ts=4 sw=4 sts=4 noet :


mkdir -p test_clients
for dataset in $(ls datasets); do
    cat <<EOF >"test_clients/config_${dataset}.json"
{
    "grobid_server": "localhost",
    "grobid_port": "8070",
    "batch_size": 1000,
    "sleep_time": 5,
    "timeout": 60,
    "coordinates": ["persName", "figure", "ref", "biblStruct", "formula", "s"]
}
EOF

    cat <<EOF >"test_clients/client_${dataset}.py"
import os
import os.path
import time

from grobid_client.grobid_client import GrobidClient

if __name__ == "__main__":
    client = GrobidClient(config_path="./config_${dataset}.json")
    start = time.monotonic_ns()
    client.process(
        service="processFulltextDocument", 
        input_path="../datasets/${dataset}",
        output="../out/${dataset}/",
        n=10,
    )
    end = time.monotonic_ns()
    time_elapsed = end - start

    files_processed = [
        os.path.join("../datasets/${dataset}", name)
        for name in os.listdir("../datasets/${dataset}")
        if os.path.isfile(os.path.join("../datasets/${dataset}", name)) and name.endswith('.pdf')
    ]
    files_count = len(files_processed)
    files_total_size = sum([os.path.getsize(path) for path in files_processed])
    print('Dataset ${dataset}:')
    print('\ttime: ', time_elapsed, ' ns')
    print('\tfiles: ', files_count, ' files')
    print('\tsize: ', files_total_size, ' bytes')
print('Done')
EOF

    mkdir -p "out/${dataset}"
done
