#!/bin/bash

printf ""This is a link to step $BUILDKITE_PARALLEL_JOB - [Step $BUILDKITE_PARALLEL_INDEX]($BUILDKITE_BUILD_URL#$BUILDKITE_JOB_ID)\n"" | buildkite-agent annotate --append
