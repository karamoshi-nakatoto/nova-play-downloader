#!/usr/bin/env bash
# This script depends on curl, jq and ffmpeg.

# Strict mode
set -euo pipefail
IFS=$'\n\t'

# Format the episode number with a leading zero (01, 02, 03 etc.)
EP=$(printf %02d $1)
API_ID=$(basename "$2")

# You may need to refresh this cookie by inspecting the headers of the first
# request to https://play.nova.bg/api/client. Copy the cookie header and put it here
COOKIE="cid=9b788db8-f4d9-381c-a211-dd95c103eb59; soma=Fe26.2*1*3122390cff1340888046cb0c01d27d5f5ce5cb92c631d1ef0319516f6549eb37*TszPULIn9NHkawPxkcL5MA*_qhQI-qaIteecFhB_ERnEOf4-FNVrFy-uyKjsSFK22JiOAVWPuoqYfmjDMkclCvprrKEsHk_WdKgOVJRGApWJN1spocZ9p7YnmKVtHwraFFr3Xv1X2OCfH_gnrf0554zjt9GjXISLVtuniTefZD0LCrzyz9j3x8DaxraM0_-4nMxeDAPO64aBp_Yeb68uZ2CFrM1h8KVykXQU5mGk6bJmFxB6Sx79eUPnn1kg7ixzoguVsvTk_QlC3YYWy1qbkZPYrQyGcmErcAqncfjozh9RhWOjpahsABPkMLL36r0zpaOG6NyqXK35YAJJM7VCBB0h6XstmkFsUSzD9Vz1-jV4txt0QkPqHzb3sq2-XnL6MIElQAqcGcThpOg2J-YivE7P1vGH10UERA5hwzZT657yxeWSr_gE96GxszTtVrIi2wLbRO5Xe9LF0BCFv0xrBCUgzixjxn_wSukOgybPg8L5IpRcDr26tHQCbpgFjkN9VsWqPPZQfxJmjUhwgWRICXZxH7lyQAxB_cuiG-a1sg6uv1m4-UxJzOblDuTc2SVs1rMfUfQeLP7QArGPlXfsvAzrP1bLdMAapfIWqQNt_UmnUip9shg3Cl_xXswpTJCc2vzwGwRqNqA2LKxr1x4QT5Z_EoRhbRIjnnpOsr6yQAtiNEv3L_eKcj2WRSIROBmucr2MsG0gNz_u_xmToSqQPzOpemdVC8GyTt5mfMHpjeGUEquJi13VuYgaJEzUwb-iY1Rb4I6eRSRboccyvw4qZF13MIGfCiQIJWhMMXK8AFYGNakDEMexo9OJxtVIk6vunzLnlfAFuQC7ts-M8JJD8kbyQbv3exKQvMu_ay_4V-jRdMC5TrOLO86VKj9N6RdH9bo6bmJmXfxBOtg5ba64HIhpVqz4Hfe2IzyB1mt97rWJmAxDb7KvX-o47zzGTqU6ST2mRQinGbLqQHdgEtgASd1xzdtTIDEhJ1v0bxKLg57W7EPG_vgygFN-_z3GZ3kblsmvkLpWZ7iKcTYLBcIp7QKDqVktzTSFE5qPQXAb8d2dsfKPXEmjH9UngRRb78LN3FoPWi0icpD5bg1ca-op8loRiaI1XQYxrlG3pBQJZkSXCvaRHRLbGeEBmbGmp2gPX2_KnOvnSu4Bb0bY2z4pgDwcFlV6wYENAQlWW2mKHVBfj9W2xFqoBUC_oNxwiFc3y7zfj-K6fr18ApqEs7kCUMnQj6y-_uYcWWVCgYZ385un0ufbv_VY6KadMb54A92THuz4jt-cNuX-ddzdY9IK8E6sKge7GBtbHGCXZTO9b_MmxRnK2RwReVsgeCE1k3DNtNlZYqvhA33u8gsefW0_hrHpxMa1ByYhLPzedzuCMtWzoGSKW8SIai-oLZZJmhvqP8uXfmEh4rL-93LSYIYiZzJD56ahWcZrAwktB1ThFjjJ9PEZj4U-RiqqbU3VgADQQ2Na37-E4v5CES-VG-ibG5vkjFNja8cUp7VsCZl6bBhz1TV63_sBPH7hzkpVVp5kGRh8W3t9txt-tHQKCaX1e48ofawTsS2pAhqiED8ZQyy2TaXAnj7jb5Y0zuKfqViTLGacyJK2en6NxOgMrYZJSQ5**def73fb115fad661ebfc0ca84a59cc82285b452e33d6a1216f8753c992f16d9b*pHuNuk2CY-T5ei-AIZSgrhOjRVNb_ljRGjHCJTfsYok; _ga_GBHZ6GEC50=GS1.1.1668950011.2.0.1668950011.0.0.0; _ga=GA1.1.751811158.1668944855; didomi_token=eyJ1c2VyX2lkIjoiMTg0OTRkZDgtMTQ3OC02NzNiLTg0NmItZDk2NTBhMTdmYWFhIiwiY3JlYXRlZCI6IjIwMjItMTEtMjBUMTE6NDc6MzYuNzY3WiIsInVwZGF0ZWQiOiIyMDIyLTExLTIwVDExOjQ3OjM2Ljc2N1oiLCJ2ZW5kb3JzIjp7ImVuYWJsZWQiOlsidHdpdHRlciIsImdvb2dsZSIsImM6eW91dHViZSIsImM6aW5zdGFncmFtIiwiYzpodHRwb29sIiwiYzpnb29nbGVhbmEtNFRYbkppZ1IiLCJjOnNtYXJ0cnRiLUg0N01pakxHIiwiYzplc3RlcnNvbmwtNzZDS0FLRHAiLCJjOmludHVpdGluYy1KckVaYTl4ZCIsImM6dHlwZWZvcm1zLVQ0azZmQnRnIiwiYzpvbmVzaWduYWwtblVWM0pia2kiLCJjOm5ldGluZm9lLW5WOHRBTlFEIiwiYzptZXRhLXB0N0drellxIl19LCJwdXJwb3NlcyI6eyJlbmFibGVkIjpbImdlb19tYXJrZXRpbmdfc3R1ZGllcyIsImdlb19hZHMiLCJkaXJlY3RtYWktUDZ0Q2lGTTIiLCJzb2N6aWFsbmktV3l6TUtLNmgiLCJkZXZpY2VfY2hhcmFjdGVyaXN0aWNzIiwiZ2VvbG9jYXRpb25fZGF0YSJdfSwidmVuZG9yc19saSI6eyJlbmFibGVkIjpbImdvb2dsZSIsImM6c21hcnRydGItSDQ3TWlqTEciXX0sInZlcnNpb24iOjIsImFjIjoiQ2pTQUVBRmtGR2dBLkNqU0FDQ2pRIn0=; euconsent-v2=CPivkwAPivkwAAHABBENCqCsAP_AAE7AAAIwGMwFgAFAANAAgABUADoAIAAVAAyABoAEUALYAYQBCAFIATSAo8BUgC4QFygLpAXmAxkC84A4AFQAQAAyABoAEUAQgC8wAg0AGAAIJICIAMAAQSQA.f_gACdgAAAAA"

FILENAME="With River at Heart S01E$EP.mp4"
if [ -f "$FILENAME" ]; then
  echo "File already exists. Remove it to continue."
  exit 1
fi

ACCESS_TOKEN="$(curl -sS --location --request GET 'https://play.nova.bg/api/client' \
--header "Cookie: $COOKIE" \
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
