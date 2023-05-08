#!/usr/bin/env bash
# shellcheck shell=bash
# This script depends on curl, jq and ffmpeg.

# Strict mode
set -euo pipefail
IFS=$'\n\t'

# Format the episode number with a leading zero (01, 02, 03 etc.)
EP=$(printf %02d "$1")
API_ID=$(basename "$2")

COOKIE_JAR="$(mktemp)"

curl -sSL -c "$COOKIE_JAR" https://play.nova.bg > /dev/null

FILENAME="With River at Heart S01E$EP.mp4"
if [ -f "$FILENAME" ]; then
  echo "File already exists. Remove it to continue."
  exit 1
fi

ACCESS_TOKEN="$(curl -sS --location --request GET 'https://play.nova.bg/api/client' \
  -b "$COOKIE_JAR" \
| jq -r ".accessToken")"

URL="$(curl -sS --location --request GET "https://nbg-api.fite.tv/api/v2/videos/$API_ID/streams" \
--header 'X-Flipps-User-Agent: Flipps/75/10.7' \
--header 'X-Flipps-Version: 2022-05-17' \
--header "Authorization: Bearer $ACCESS_TOKEN" \
| jq -r '.[0].links.play.href')"


NEW_URL="$(curl -sSL -o /dev/null "$URL" -w "%{url_effective}")"

PLAYLIST="$(curl -sSL "$URL" | grep -v '#')"

# Try to download highest available quality
if echo "$PLAYLIST" | grep -q 1080; then
  DOWNLOAD_URL="$(echo "$PLAYLIST" | grep 1080)"
elif echo "$PLAYLIST" | grep -q 720; then
  DOWNLOAD_URL="$(echo "$PLAYLIST" | grep 720)"
elif echo "$PLAYLIST" | grep -q 480; then
  DOWNLOAD_URL="$(echo "$PLAYLIST" | grep 480)"
elif echo "$PLAYLIST" | grep -q 360; then
  DOWNLOAD_URL="$(echo "$PLAYLIST" | grep 360)"
elif echo "$PLAYLIST" | grep -q 240; then
  DOWNLOAD_URL="$(echo "$PLAYLIST" | grep 240)"
fi

FINAL_URL="$(dirname "$NEW_URL")/$DOWNLOAD_URL"

ffmpeg -i "$FINAL_URL" -c copy "$FILENAME"
