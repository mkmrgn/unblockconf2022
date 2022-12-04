#!/bin/bash

decision_steps=$(cat <<EOF
steps:
  - block: "What now?"
    prompt: "Choose the next set of steps to be dynamically generated"
    fields:
      - select: "Choices"
        key: "choice"
        options:
          - label: "Display the UnblockConf logo again"
            value: "logo"
          - label: "Print 'hello world' a bunch of times in parallel"
            value: "hello-world"
          - label: "Finish the build green"
            value: "build-pass"
          - label: "Finish the build red"
            value: "build-fail"
  - label: "Process input"
    command: ".buildkite/generate_steps.sh"
EOF
)

# this bit is an ugly hack to avoid checking metadata on first run of the script
current_state=""
first_step_label=":pipeline: Upload Pipeline"
if [ "$BUILDKITE_LABEL" != "$first_step_label" ]; then
  current_state=$(buildkite-agent meta-data get "choice")
else
  printf "$decision_steps"
  exit 0
fi

case $current_state in
  logo)
    buildkite-agent pipeline upload <<EOF
  - label: "Display UnblockConf Logo"
    command: "buildkite-agent artifact upload unblock.png && ../log_image.sh artifact://unblock.png"
EOF
  ;;

  hello-world)
    buildkite-agent pipeline upload <<EOF
  - label: "Parallel job %N of %t"
    command: "echo 'Hello, world!'"
    parallelism: 5 
EOF
  ;;

  build-pass)
    buildkite-agent pipeline upload <<EOF    
  - label: "Passing build"
    command: "echo "Exiting build with status 0" && exit 0"
EOF
  ;;

  build-fail)
    buildkite-agent pipeline upload <<EOF  
  - label: "Failing build"
    command "echo "Exiting build with status 1" && exit 1"
EOF
  ;;
esac

printf "decision_steps" | buildkite-agent pipeline upload
