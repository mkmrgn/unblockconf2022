#!/bin/bash

# Defined by Buildkite agent as config.GitMirrorsPath. This is the default:
GIT_MIRRORS_PATH=/var/lib/buildkite-agent/git-mirrors
GIT_CACHE_BUCKET="buildkite-git-cache778"

# Download the main repo archived by a scheduled pipeline.
# The scheduled pipeline should do something like `git clone -v --mirror -- git@github.com:org/monorepo.git`
# and upload the archive to S3.

# Make sure that the Elastic CI stack has been given the necessary IAM policy to access S3
echo "Fetch monorepo from S3"
aws s3 cp "s3://${GIT_CACHE_BUCKET}/linux.tar" /root/linux.tar --no-progress
echo "Extracting cache archive"
tar xf /root/linux.tar -C "${GIT_MIRRORS_PATH}"