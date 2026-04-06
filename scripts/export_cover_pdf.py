#!/usr/bin/env python3
"""Export the Scribus cover source to an RGB PDF.

Run via Scribus, for example:

  /Applications/Scribus.app/Contents/MacOS/Scribus \
    --no-splash \
    --python-script scripts/export_cover_pdf.py
"""

from __future__ import annotations

import os
import sys

import scribus


REPO_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INPUT_FILE = os.path.join("meta", "nado-cover.sla")
OUTPUT_FILE = os.path.join(REPO_ROOT, "meta", "nado-cover-rgb.pdf")


def main() -> int:
    input_path = os.path.join(REPO_ROOT, INPUT_FILE)
    if not os.path.exists(input_path):
        print(f"Input Scribus file not found: {input_path}", file=sys.stderr)
        return 1

    if scribus.haveDoc():
        scribus.closeDoc()

    os.chdir(REPO_ROOT)

    print(f"Opening Scribus document: {INPUT_FILE}")
    scribus.openDoc(INPUT_FILE)

    pdf = scribus.PDFfile()
    pdf.file = OUTPUT_FILE
    pdf.pages = [1]
    pdf.compress = 1
    pdf.compressmtd = 0
    pdf.quality = 0
    pdf.fontEmbedding = 0
    # The Scribus document is trim-sized; use its 3 mm bleed settings on export.
    pdf.useDocBleeds = 1
    pdf.outdst = 1
    pdf.info = "nado-cover.sla"
    pdf.profiles = 1
    pdf.profilei = 1
    pdf.solidpr = "Adobe RGB (1998)"
    pdf.imagepr = "sRGB IEC61966-2.1"
    pdf.printprofc = "ISO Coated v2 300% (basICColor)"
    pdf.intents = 1
    pdf.intenti = 0
    # Scribus stores PDF/X-4 as version 10 in the .sla file.
    pdf.version = 10

    print(f"Exporting PDF to: {OUTPUT_FILE}")
    pdf.save()
    scribus.closeDoc()
    print("Export complete.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
