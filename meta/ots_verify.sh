#!/bin/bash
# https://opentimestamps.org
# Verify that the following commit existed in March, 2022.
#
# Usage: ./meta/ots_verify.sh
c=86a7cd200acb1812b6b2f8be27c8380ea44c9470
git verify-commit $c
git cat-file -p $c > meta/commit
ots verify meta/commit.ots
