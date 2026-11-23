#!/usr/bin/env bash
# Regenerates the typed Dart API client (packages/miser_api) from ../api/openapi.json.
#
# Usage: tool/generate_api.sh [path/to/openapi.json]
#   Requires: node (npx), Java 11+, python3, flutter/dart.
#
# The backend's springdoc output describes POST /api/statements/upload as a JSON
# body with accountId/creditCardId/password as query parameters. The controller
# actually takes multipart/form-data and rejects a password in the query string,
# so we patch a temporary copy of the spec to the real multipart contract before
# generating. The source spec is never modified.
set -euo pipefail

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SPEC="${1:-$APP_DIR/../api/openapi.json}"
OUT="$APP_DIR/packages/miser_api"
GEN_VERSION="${OPENAPI_GENERATOR_VERSION:-7.27.0}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

python3 -I - "$SPEC" "$TMP/openapi.json" <<'PY'
import json, sys
src, dst = sys.argv[1], sys.argv[2]
spec = json.load(open(src))
op = spec["paths"]["/api/statements/upload"]["post"]
op["parameters"] = []
op["requestBody"] = {
    "required": True,
    "content": {"multipart/form-data": {"schema": {
        "type": "object",
        "required": ["file"],
        "properties": {
            "file": {"type": "string", "format": "binary"},
            "accountId": {"type": "integer", "format": "int64"},
            "creditCardId": {"type": "integer", "format": "int64"},
            "password": {"type": "string"},
        },
    }}},
}
spec["servers"] = [{"url": "http://localhost:8080"}]
json.dump(spec, open(dst, "w"), indent=2)
PY

# Paths are passed relative to $TMP: the npx wrapper re-splits arguments, so
# absolute paths containing spaces would break.
cat > "$TMP/openapitools.json" <<JSON
{"generator-cli": {"version": "$GEN_VERSION"}}
JSON
(cd "$TMP" && npx --yes @openapitools/openapi-generator-cli@2 generate \
  -i openapi.json \
  -g dart-dio \
  -o out \
  --additional-properties=pubName=miser_api,pubAuthor=miser,serializationLibrary=json_serializable,dateLibrary=core \
  --skip-validate-spec)

rm -rf "$OUT"
mkdir -p "$(dirname "$OUT")"
cp -R "$TMP/out" "$OUT"

# Drop generator-produced docs/tests/CI files we don't use.
rm -rf "$OUT/doc" "$OUT/test" "$OUT/.travis.yml" "$OUT/git_push.sh" "$OUT/.openapi-generator-ignore"

cd "$OUT"
# The generator pins an old SDK floor; json_serializable emits null-aware
# map elements, which need Dart >= 3.8.
sed -i.bak -E "s/sdk: '>=3\.[0-9]+\.[0-9]+ <4\.0\.0'/sdk: '>=3.8.0 <4.0.0'/" pubspec.yaml && rm -f pubspec.yaml.bak
sed -i.bak -e 's/^homepage: homepage$//' -e 's/^description: .*/description: Generated Miser API client (do not edit; run tool\/generate_api.sh)/' pubspec.yaml && rm -f pubspec.yaml.bak
printf '\npublish_to: none\n' >> pubspec.yaml
# Align copy_with_extension with what package:oidc (oidc_core) requires, so the
# app can resolve both.
sed -i.bak -E -e "s/copy_with_extension: '?\^[0-9.]+'?/copy_with_extension: ^15.0.1/" \
  -e "s/copy_with_extension_gen: '?\^[0-9.]+'?/copy_with_extension_gen: ^15.0.1/" pubspec.yaml && rm -f pubspec.yaml.bak
dart pub get
dart run build_runner build --delete-conflicting-outputs
echo "Generated $OUT"
