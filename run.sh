#!/usr/bin/env bash
echo "Running Robot tests"
robot -d out .
echo "Uploading report"
python3 uploader.py