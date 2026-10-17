#!/bin/sh
# Points the formula and cask at a Mirinae release. Reads the checksums from the SHA256SUMS
# asset the release workflow attaches. Usage: Scripts/bump.sh <version>
set -eu
cd "$(dirname "$0")/.."
version="${1:?usage: Scripts/bump.sh <version>}"
sums="$(curl -fsSL "https://github.com/agriyakhetarpal/mirinae/releases/download/v${version}/SHA256SUMS")"
zip_sha="$(printf '%s\n' "$sums" | awk '$2 == "Mirinae-'"$version"'.zip" { print $1 }')"
tar_sha="$(printf '%s\n' "$sums" | awk '$2 == "v'"$version"'.tar.gz" { print $1 }')"
[ -n "$zip_sha" ] && [ -n "$tar_sha" ] || { echo "SHA256SUMS for v${version} is missing an entry" >&2; exit 1; }

sed -i.bak \
    -e 's|^  version ".*"$|  version "'"$version"'"|' \
    -e 's|^  sha256 ".*"$|  sha256 "'"$zip_sha"'"|' \
    Casks/mirinae.rb
sed -i.bak \
    -e 's|archive/refs/tags/v[0-9.]*\.tar\.gz|archive/refs/tags/v'"$version"'.tar.gz|' \
    -e 's|^  sha256 ".*"$|  sha256 "'"$tar_sha"'"|' \
    Formula/mirinae.rb
rm -f Casks/mirinae.rb.bak Formula/mirinae.rb.bak
git --no-pager diff --stat -- Casks/mirinae.rb Formula/mirinae.rb
echo "Formula and cask now point at v${version}"
