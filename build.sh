#!/bin/bash

set -euo pipefail;
shopt -s extglob;

output="${1-./build}";
echo "Building to: '${output}'";

mkdir -p "${output}";

# Remove any extra files
cd ${output};
rm -rf * !("src"|"build.sh") || true;
cd ..;

for path in \
	"static"                       \
	"manifest.webmanifest"         \
	"service_worker.js"            \
	"robots.txt"                   \
	"google66b7e1d4dbf56798.html"  \
; do
	cp -r "src/${path}" "${output}/";
done

asciidoctor "src/index.adoc" -a webfonts! -o "${output}/index.html";

# Lazy load images
sed -i 's/<img/<img loading="lazy"/g' ${output}/index.html;

echo "Build complete";
