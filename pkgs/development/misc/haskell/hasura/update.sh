#!/usr/bin/env nix-shell
#!nix-shell -i bash -p cabal2nix curl jq -I nixpkgs=.
#
# This script will update the hasura derivations to the latest version using
# cabal2nix.
#
# Note that you should always try building hasura graphql-engine after updating it here, since
# some of the overrides in pkgs/development/haskell/configuration-nix.nix may
# need to be updated/changed.

set -eo pipefail

# This is the directory of this update.sh script.
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# graphql-engine derivation created with cabal2nix.
engine_derivation_file="${script_dir}/graphql-engine.nix"
parser_derivation_file="${script_dir}/graphql-parser.nix"
ciinfo_derivation_file="${script_dir}/ci-info.nix"
pgclient_derivation_file="${script_dir}/pg-client.nix"
pool_derivation_file="${script_dir}/pool.nix"
ekgcore_derivation_file="${script_dir}/ekg-core.nix"
ekgjson_derivation_file="${script_dir}/ekg-json.nix"
kritilang_derivation_file="${script_dir}/kriti-lang.nix"

# TODO: get current revision of graphql-engine in Botpkgs.
# old_version="$(sed -En 's/.*\bversion = "(.*?)".*/\1/p' "$engine_derivation_file")"

# This is the latest release version of graphql-engine on GitHub.
new_version=$(curl --silent "https://api.github.com/repos/hasura/graphql-engine/releases" | jq 'map(select(.prerelease | not)) | .[0].tag_name' --raw-output)

echo "Running cabal2nix and outputting to ${engine_derivation_file}..."

echo "# This has been automatically generated by the script" > "$engine_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$engine_derivation_file"

cabal2nix --revision "$new_version" --subpath server --maintainer lassulus --no-check "https://github.com/hasura/graphql-engine.git" >> "$engine_derivation_file"

echo "Running cabal2nix and outputting to ${parser_derivation_file}..."

echo "# This has been automatically generated by the script" > "$parser_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$parser_derivation_file"

cabal2nix --maintainer lassulus "https://github.com/hasura/graphql-parser-hs.git" >> "$parser_derivation_file"

echo "Running cabal2nix and outputting to ${ciinfo_derivation_file}..."

echo "# This has been automatically generated by the script" > "$ciinfo_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$ciinfo_derivation_file"

cabal2nix --maintainer lassulus "https://github.com/hasura/ci-info-hs.git" >> "$ciinfo_derivation_file"

echo "Running cabal2nix and outputting to ${pgclient_derivation_file}..."

echo "# This has been automatically generated by the script" > "$pgclient_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$pgclient_derivation_file"

cabal2nix --maintainer lassulus "https://github.com/hasura/pg-client-hs.git" >> "$pgclient_derivation_file"

echo "Running cabal2nix and outputting to ${pool_derivation_file}..."

echo "# This has been automatically generated by the script" > "$pool_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$pool_derivation_file"

cabal2nix --maintainer lassulus "https://github.com/hasura/pool.git" >> "$pool_derivation_file"

echo "Running cabal2nix and outputting to ${ekgcore_derivation_file}..."

echo "# This has been automatically generated by the script" > "$ekgcore_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$ekgcore_derivation_file"

cabal2nix --maintainer lassulus "https://github.com/hasura/ekg-core.git" >> "$ekgcore_derivation_file"

echo "Running cabal2nix and outputting to ${ekgjson_derivation_file}..."

echo "# This has been automatically generated by the script" > "$ekgjson_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$ekgjson_derivation_file"

cabal2nix --maintainer lassulus "https://github.com/hasura/ekg-json.git" >> "$ekgjson_derivation_file"

echo "Running cabal2nix and outputting to ${kritilang_derivation_file}..."

echo "# This has been automatically generated by the script" > "$kritilang_derivation_file"
echo "# ./update.sh.  This should not be changed by hand." >> "$kritilang_derivation_file"

new_kritilang_version=$(curl --silent "https://api.github.com/repos/hasura/kriti-lang/tags" | jq '.[0].name' --raw-output)

cabal2nix --revision "$new_kritilang_version" --maintainer lassulus "https://github.com/hasura/kriti-lang.git" >> "$kritilang_derivation_file"

echo "###################"
echo "please update pkgs/servers/hasura/cli.nix vendorHash"
echo "please update pkgs/development/haskell-modules/configuration-common.nix graphql-engine version"
echo "###################"

echo "Finished."
