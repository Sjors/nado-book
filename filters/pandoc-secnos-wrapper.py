#!/usr/bin/env python3

import re
import site
import subprocess
import sys

for path in site.getusersitepackages().split(":"):
    if path and path not in sys.path:
        sys.path.insert(0, path)

import pandocxnos.core


def patched_get_pandoc_version(pandocversion=None, doc=None):
    if pandocversion is None:
        try:
            output = subprocess.check_output(["pandoc", "-v"])
            line = output.decode("utf-8").split("\n")[0]
            pandocversion = line.split(" ")[-1].strip()
        except Exception:
            pass

    if pandocversion is None:
        raise RuntimeError("Cannot determine pandoc version.")

    if not re.match(r"^3\.[0-9]+(?:\.[0-9]+)?(?:\.[0-9]+)?$", pandocversion):
        raise RuntimeError(
            f"Unsupported pandoc version: {pandocversion}. "
            "This wrapper is intended for pandoc 3."
        )

    return pandocversion


pandocxnos.core._get_pandoc_version = patched_get_pandoc_version

import pandoc_secnos  # noqa: E402


if __name__ == "__main__":
    sys.exit(pandoc_secnos.main())
