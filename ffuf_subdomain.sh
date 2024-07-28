#!/bin/bash

# Default wordlist
DEFAULT_WORDLIST="/usr/share/wordlists/seclists/SecLists-master/Discovery/DNS/subdomains-top1million-110000.txt"

# Function to display usage
usage() {
  echo "Usage: $0 [-w wordlist] -u domain"
  echo
  echo "Options:"
  echo "  -w wordlist  Path to the wordlist file (default: $DEFAULT_WORDLIST)"
  echo "  -u domain    The target domain for ffuf (e.g., http://example.com/)"
  echo
  echo "Example:"
  echo "  $0 -w /path/to/custom-wordlist.txt -u http://test.com/"
  echo "  $0 -u http://test.com/"
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
      DOMAIN=$OPTARG
      ;;
    \? )
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if domain is set
if [ -z "$DOMAIN" ]; then
  echo "Error: No domain provided."
  usage
fi

# Set default wordlist if not provided
WORDLIST=${WORDLIST:-$DEFAULT_WORDLIST}

# Remove trailing slash from domain if it exists
DOMAIN=${DOMAIN%/}

# Extract the base domain and check for "www"
BASE_DOMAIN=$(echo $DOMAIN | sed -e 's#http://##' -e 's#https://##' -e 's#^www\.##')

# Determine the correct Host header
if [[ $DOMAIN == *"www."* ]]; then
  HOST_HEADER="Host: FUZZ.$BASE_DOMAIN"
else
  HOST_HEADER="Host: FUZZ.$BASE_DOMAIN"
fi

# Run the ffuf command
ffuf -w "$WORDLIST" -u "$DOMAIN" -H "$HOST_HEADER" -fw 3913
