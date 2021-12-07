Test machine specs
------------------
Model: Lenovo Thinkpad T470p
CPU: Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz (4 cores + hyperthreading)
RAM: 16G
Storage: SSD

How to
------

1. Download datasets using ``retrieve_datasets.sh`` script. Be
   patient as it may take a lot of time

2. Download and run grobid server

   .. code-block:: console

      user@pc ~ $ git clone git@github.com:kermitt2/grobid
      user@pc ~ $ cd grobid
      user@pc ~/grobid $ ./gradlew run

3. In separate window generate test clients and configs
   ``create_test_cllients.sh``.

4. Install grobid client ``install_client.sh``

5. Run test client

   .. code-block:: console

      user@pc $ source . ./.venv/bin/activate
      (.venv) user@pc $ cd test_clients
      (.venv) user@pc test_clients $ python client_XXX.py
                                                   ^^^
                         Replace XXX with dataset name
      Dataset XXX:
              time: 1488 ns
              files: 666 files
              size: 6942 bytes
      Done


Results
-------

See ``results.csv``.
