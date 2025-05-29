#!/usr/bin/env bash
set -eo pipefail

SCRIPT_DIR="$(
  cd "$(dirname "$0")"
  pwd -P
)"

function infoEcho() {
  echo "INFO: ${1}" 1>&2
}

function errorEcho() {
  echo "ERROR: ${1}" 1>&2
  exit 1
}

function errorUsage() {
  echo ${1} 1>&2
  usage
  exit 1
}

# check prerequisites
for cmd in git; do
  command -v ${cmd} >/dev/null || {
    echo >&2 "${cmd} must be installed - exiting..."
    exit 1
  }
done

DEFAULT_BASE_VERSION="0.0.0"
DEFAULT_README_FILE="README.md"
DEFAULT_DOCKER_FILE="Dockerfile"
DEFAULT_VERSION_PATTERN='^v?([0-9]+)\.([0-9]+)\.([0-9]+)$'
DEFAULT_SECTION_HEADER="PACKAGES"

function usage() {
  echo "Determine next version and update installed packages in readme file."
  echo "usage: $0 [options]"
  echo ""
  echo "        -b --base-version:            Version string used if no git tag is found (default: ${DEFAULT_BASE_VERSION}) (ENV: BASE_VERSION)"
  echo "        -r --readme-file              Name of Readme file (default: ${DEFAULT_README_FILE}) (ENV: README_FILE)"
  echo "        -d --docker-file              Name of Dockerfile (default: ${DEFAULT_DOCKER_FILE}) (ENV: DOCKER_FILE)"
  echo "        -p --version-pattern:         Version pattern to match tags (default: ${DEFAULT_VERSION_PATTERN}) (ENV: VERSION_PATTERN)"
  echo "        -s --section-header:          Section header to update in readme file (default: ${DEFAULT_SECTION_HEADER}) (ENV: SECTION_HEADER)"
  echo "                                      The headers will always be wrapped in '<!-- BEGIN_$HEADER -->' and '<!-- END_$HEADER -->"
  echo "        -h --help:                    Show this help message"
  echo ""
  echo "environment variables:"
  echo ""
  echo "        BASE_VERSION:                 Version string used if no git tag is found (default: ${DEFAULT_BASE_VERSION})"
  echo "        README_FILE:                  Name of Readme file (default: ${DEFAULT_README_FILE})"
  echo "        DOCKER_FILE:                  Name of Dockerfile (default: ${DEFAULT_DOCKER_FILE})"
  echo "        VERSION_PATTERN:              Version pattern to match tags (default: ${DEFAULT_VERSION_PATTERN})"
  echo "        SECTION_HEADER:               Section header to update in readme file (default: ${DEFAULT_SECTION_HEADER})"
}

while [[ $# -gt 0 ]]; do
  key="${1}"

  case $key in
  --base-version | -b)
    shift
    export BASE_VERSION="${1}"
    shift
    ;;
  --readme-file | -r)
    shift
    export README_FILE="${1}"
    shift
    ;;
  --docker-file | -d)
    shift
    export DOCKER_FILE="${1}"
    shift
    ;;
  --version-pattern | -p)
    shift
    export VERSION_PATTERN="${1}"
    shift
    ;;
  --section-header | -s)
    shift
    export SECTION_HEADER="${1}"
    shift
    ;;
  --help | -h | help)
    usage
    exit 0
    ;;
  *)
    shift
    ;;
  esac
done

# Abort if required argument is empty
#for variable in PAT_TOKEN ORGANISATION FROM TO; do
#  if [[ -z ${!variable} || ${!variable} == '<no value>' ]]; then
#    errorUsage "${variable}"
#  fi
#done

# Assign default values if optional argument is empty
for variable in BASE_VERSION README_FILE DOCKER_FILE VERSION_PATTERN SECTION_HEADER; do
  if [[ -z ${!variable} || ${!variable} == '<no value>' ]]; then
    default_var_name="DEFAULT_${variable}"
    export "${variable}=${!default_var_name}"
  fi
done

# Get the latest tag (fallback to $BASE_VERSION if none)
last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "${BASE_VERSION}")
[[ $last_tag =~ $VERSION_PATTERN ]] || {
  echo "Invalid tag format: $last_tag"
  exit 1
}

major="${BASH_REMATCH[1]}"
minor="${BASH_REMATCH[2]}"
patch="${BASH_REMATCH[3]}"

# Check for readme file
if [[ ! -f "${README_FILE}" ]]; then
  errorEcho "Readme file ${README_FILE} does not exist."
fi

# Read section from readme file
section_begin="<!-- BEGIN_${SECTION_HEADER} -->"
section_end="<!-- END_${SECTION_HEADER} -->"

section_content=$(awk "/${section_begin}/{flag=1; next} /${section_end}/{flag=0} flag" "${README_FILE}")

echo "${section_content}"
