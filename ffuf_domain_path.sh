#!/bin/bash

# Default wordlist
DEFAULT_WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"

# Function to display usage
usage() {
  echo "Usage: $0 [-w wordlist] -u url"
  echo
  echo "Options:"
  echo "  -w wordlist  Path to the wordlist file (default: $DEFAULT_WORDLIST)"
  echo "  -u url       The target URL with FUZZ in place (e.g., http://example.com/FUZZ or example.com/FUZZ)"
  echo
  echo "Example:"
  echo "  $0 -w /path/to/custom-wordlist.txt -u http://test.com/FUZZ"
  echo "  $0 -u test.com/FUZZ"
  echo
  exit 1
}

# Parse command line arguments
while getopts "w:u:" opt; do
  case ${opt} in
    w )
      WORDLIST=$OPTARG
      ;;
    u )
      URL=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if URL is set
if [ -z "$URL" ]; then
  echo "Error: No URL provided."
  usage
fi

# Set default wordlist if not provided
WORDLIST=${WORDLIST:-$DEFAULT_WORDLIST}

# Check if URL starts with http:// or https://
if [[ $URL != http://* && $URL != https://* ]]; then
  URL="http://$URL"
fi

# Replace FUZZ in the wordlist path with FUZZ
WORDLIST_PATH=$(echo "$WORDLIST" | sed 's#FUZZ#FUZZ#g')

# Run the ffuf command
ffuf -w "$WORDLIST_PATH" -u "$URL"
