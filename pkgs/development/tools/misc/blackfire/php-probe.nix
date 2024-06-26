{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, php
, writeShellScript
, curl
, jq
, common-updater-scripts
}:

assert lib.assertMsg (!php.ztsSupport) "blackfire only supports non zts versions of PHP";

let
  phpMajor = lib.versions.majorMinor php.version;

  version = "1.92.9";

  hashes = {
    "x86_64-linux" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-pvJHzqhpKdLyWexqCdynOXIoIkb6WPFogQzzdGSl0Go=";
        "8.2" = "sha256-M2ihNS2IK0tO+lXXSrJZLguRzyrV8q/45gmK0pfxjuo=";
        "8.3" = "sha256-v4vt0GkM8pbZ+zJrNqu+h1TM680RpnCQwNDyFFD/vuE=";
      };
    };
    "i686-linux" = {
      system = "i386";
      hash = {
        "8.1" = "sha256-+IrL8OGjny+FPLNNj0N0oJGSuUA9nZFBkalW6qbBtbI=";
        "8.2" = "sha256-z5oFFh+0spuku+nZf9ICL17upLHoA2k6StAmVpKIxyw=";
        "8.3" = "sha256-1maDNZb92ptbbiIUZxwEBNk6oQPf6f2LVHvsXrpmdQ8=";
      };
    };
    "aarch64-linux" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-apIHM85SDtdrNy2zkgue4nLS+IYg0aqO67tjt3iPMvQ=";
        "8.2" = "sha256-vafJYIXksjQXNOufSNsRCBOkhh9Da1sp0X1JJtH0wNM=";
        "8.3" = "sha256-JTfFszym+zq4U2V1HOkGB41OR/mt7GotHo1HThjLEV0=";
      };
    };
    "aarch64-darwin" = {
      system = "arm64";
      hash = {
        "8.1" = "sha256-zj4oSpW2ubEdk5n8FjQF4oOWcjMd5V1G5ul8kHj/fyU=";
        "8.2" = "sha256-aedyASZs4Sy0CEX9Y5qjJnzzcvUdO9eYg9nZXrOcVnI=";
        "8.3" = "sha256-Sla+W+dz2foTnF3ys4MIcnP0FnSjiyWHfsMW0+Vhkpw=";
      };
    };
    "x86_64-darwin" = {
      system = "amd64";
      hash = {
        "8.1" = "sha256-YorZctBEUgPHnoXtcf8xkn6DfhM1BZnBNpfi5o7y0AM=";
        "8.2" = "sha256-5zmwJu1Ux5vebFeu1WMHRCKalB/qgm3/G74OPrd7nhc=";
        "8.3" = "sha256-vm2VK3jPR25ICxiKMqzh9DyzG9EVJ/rX3i7LQMox3gs=";
      };
    };
  };

  makeSource = { system, phpMajor }:
    let
      isLinux = builtins.match ".+-linux" system != null;
    in
    assert !isLinux -> (phpMajor != null);
    fetchurl {
      url = "https://packages.blackfire.io/binaries/blackfire-php/${version}/blackfire-php-${if isLinux then "linux" else "darwin"}_${hashes.${system}.system}-php-${builtins.replaceStrings [ "." ] [ "" ] phpMajor}.so";
      hash = hashes.${system}.hash.${phpMajor};
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "php-blackfire";
  extensionName = "blackfire";
  inherit version;

  src = makeSource {
    system = stdenv.hostPlatform.system;
    inherit phpMajor;
  };

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    autoPatchelfHook
  ];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -D ${finalAttrs.src} $out/lib/php/extensions/blackfire.so

    runHook postInstall
  '';

  passthru = {
    updateScript = writeShellScript "update-${finalAttrs.pname}" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://blackfire.io/api/v1/releases | jq .probe.php --raw-output)

      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      for source in ${lib.concatStringsSep " " (builtins.attrNames finalAttrs.passthru.updateables)}; do
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "0" "sha256-${lib.fakeSha256}"
        update-source-version "$UPDATE_NIX_ATTR_PATH.updateables.$source" "$NEW_VERSION"
      done
    '';

    # All sources for updating by the update script.
    updateables =
      let
        createName = path:
          builtins.replaceStrings [ "." ] [ "_" ] (lib.concatStringsSep "_" path);

        createSourceParams = path:
          let
            # The path will be either [«system» sha256], or [«system» sha256 «phpMajor» «zts»],
            # Let’s skip the sha256.
            rest = builtins.tail (builtins.tail path);
          in
          {
            system =
              builtins.head path;
            phpMajor =
              if builtins.length rest == 0
              then null
              else builtins.head rest;
          };

        createUpdateable = path: _value:
          lib.nameValuePair
            (createName path)
            (finalAttrs.finalPackage.overrideAttrs (attrs: {
              src = makeSource (createSourceParams path);
            }));

        # Filter out all attributes other than hashes.
        hashesOnly = lib.filterAttrsRecursive (name: _value: name != "system") hashes;
      in
      builtins.listToAttrs
        # Collect all leaf attributes (containing hashes).
        (lib.collect
          (attrs: attrs ? name)
          (lib.mapAttrsRecursive createUpdateable hashesOnly));
  };

  meta = {
    description = "Blackfire Profiler PHP module";
    homepage = "https://blackfire.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ shyim ];
    platforms = [ "x86_64-linux" "aarch64-linux" "i686-linux" "x86_64-darwin" "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
