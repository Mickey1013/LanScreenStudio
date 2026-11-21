#!/usr/bin/env bash
set -euo pipefail

tag="v${VERSION}"
base="LanScreenStudio-${VERSION}-Windows-x64"
portable="${base}-Portable.zip"
work=$(mktemp -d)
cd "$work"
gh release view "$tag" --repo "$GITHUB_REPOSITORY" --json assets > assets.json
if jq -e --arg name "$portable" '.assets | any(.name == $name and .state == "uploaded" and .size > 100000000)' assets.json > /dev/null; then
  echo 'The standalone ZIP is already available.'
  exit 0
fi
mkdir volumes
gh release download "$tag" --repo "$GITHUB_REPOSITORY" --pattern "${base}.z*" --dir volumes
zip -s 0 "volumes/${base}.zip" --out "$portable" > /dev/null
python - "$portable" "$VERSION" <<'PY'
import json
import sys
import zipfile
from pathlib import Path

archive, version = sys.argv[1:]
if Path(archive).stat().st_size <= 100_000_000:
    raise ValueError("Standalone ZIP is unexpectedly small")
with zipfile.ZipFile(archive) as package:
    exe = package.getinfo("LanScreenStudio.exe")
    if exe.file_size != 249_978_368:
        raise ValueError("Incorrect Electron executable size")
    with package.open(exe) as executable:
        if executable.read(2) != b"MZ":
            raise ValueError("Invalid Windows executable header")
    metadata = json.loads(package.read("resources/app/package.json"))
    if metadata["version"] != version:
        raise ValueError("Incorrect bundled version")
    for expected in ("LICENSE-app.txt", "CREDITS.md", "resources/app/main.cjs"):
        package.getinfo(expected)
PY
gh release upload "$tag" "$portable" --repo "$GITHUB_REPOSITORY"
size=$(stat -c '%s' "$portable")
gh release view "$tag" --repo "$GITHUB_REPOSITORY" --json assets \
  | jq -e --arg name "$portable" --argjson size "$size" \
    '.assets | any(.name == $name and .size == $size and .state == "uploaded")'
