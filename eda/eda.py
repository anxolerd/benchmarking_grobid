import os
import sys

from collections import NamedTuple

import matplotlib.pyplot as plt

from PyPDF2 import PdfFileReader

BASE_DIR = os.path.abspath(os.path.dirname(__name__))


class DocStats(NamedTuple):
    path: str
    pages: int
    page_layout: str
    size: int
    outline: list
    has_form: bool


def usage():
    print('Usage:')
    print('\t%s DATASET' % sys.argv[0])
    return os.EX_USAGE


def list_pdfs(path):
    for f in os.path.listdir(path):
        new_path = os.path.join(path, f)
        if os.path.isdir(new_path):
            yield from list_pdfs(new_path)
        elif if os.path.isfile(new_path):
            if new_path[-4:].lower() == '.pdf':
                yield new_path


if __name__ == '__main__':
    if len(sys.argv != 2):
         return sys.exit(usage())

    dataset = sys.argv[1]
    dataset_dir = os.path.join(BASE_DIR, 'datasets', dataset)
    if not os.path.isdir(dataset_dir):
        print('Dataset %s does not exist at %s' % (dataset, dataset_dir))
        return sys.exit(os.EX_NOTFOUND)

    docstats = []
    for pdf in list_pdfs(dataset_dir):
        with open(pdf, 'rb') as pdf_file:
            reader = PdfFileReader(pdf_file)
            docstats.append(DocStats(
                path=pdf,
                pages=reader.getNumPages(),
                page_layout=reader.getPageLayout(),
                creator=reader.getDocumentInfo().creator,
                size=os.path.getsize(pdf),
                outline=reader.getOutlines(),
                has_form=bool(reader.getFields()),
            ))
