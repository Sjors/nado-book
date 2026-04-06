#!/usr/bin/env python3
"""Pad an A5 interior PDF to A5 + 3 mm bleed and set explicit PDF boxes."""

from __future__ import annotations

import sys

import pikepdf


MM_TO_PT = 72 / 25.4
BLEED_MM = 3
TRIM_WIDTH_MM = 148
TRIM_HEIGHT_MM = 210
FULL_WIDTH_MM = TRIM_WIDTH_MM + (2 * BLEED_MM)
FULL_HEIGHT_MM = TRIM_HEIGHT_MM + (2 * BLEED_MM)

BLEED_PT = BLEED_MM * MM_TO_PT
TRIM_WIDTH_PT = TRIM_WIDTH_MM * MM_TO_PT
TRIM_HEIGHT_PT = TRIM_HEIGHT_MM * MM_TO_PT
FULL_WIDTH_PT = FULL_WIDTH_MM * MM_TO_PT
FULL_HEIGHT_PT = FULL_HEIGHT_MM * MM_TO_PT


def main() -> int:
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} INPUT_PDF OUTPUT_PDF", file=sys.stderr)
        return 1

    input_pdf, output_pdf = sys.argv[1], sys.argv[2]

    pdf = pikepdf.Pdf.open(input_pdf)
    for page in pdf.pages:
        prefix = pdf.make_stream(
            f"q\n1 0 0 1 {BLEED_PT:.6f} {BLEED_PT:.6f} cm\n".encode("ascii")
        )
        suffix = pdf.make_stream(b"Q\n")

        contents = page.obj["/Contents"]
        if isinstance(contents, pikepdf.Array):
            page.obj["/Contents"] = pikepdf.Array([prefix, *contents, suffix])
        else:
            page.obj["/Contents"] = pikepdf.Array([prefix, contents, suffix])

        trim_box = pikepdf.Array(
            [BLEED_PT, BLEED_PT, BLEED_PT + TRIM_WIDTH_PT, BLEED_PT + TRIM_HEIGHT_PT]
        )
        full_box = pikepdf.Array([0, 0, FULL_WIDTH_PT, FULL_HEIGHT_PT])

        page.obj["/MediaBox"] = pikepdf.Array(full_box)
        page.obj["/CropBox"] = pikepdf.Array(full_box)
        page.obj["/BleedBox"] = pikepdf.Array(full_box)
        page.obj["/TrimBox"] = pikepdf.Array(trim_box)
        page.obj["/ArtBox"] = pikepdf.Array(trim_box)

    pdf.save(
        output_pdf,
        object_stream_mode=pikepdf.ObjectStreamMode.generate,
        compress_streams=True,
        recompress_flate=True,
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
