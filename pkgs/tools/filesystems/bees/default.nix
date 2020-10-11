{ stdenv, runCommand, fetchFromGitHub, bash, btrfs-progs, coreutils, python3Packages, utillinux }:

let

  version = "0.6.3";
  sha256 = "sha256-brEjr7lhmKDCIDeLq+XP+ZTxv1RvwoUlszMSEYygxv8=";

  bees = stdenv.mkDerivation {
    pname = "bees";
    inherit version;

    src = fetchFromGitHub {
      owner = "Zygo";
      repo = "bees";
      rev = "v${version}";
      inherit sha256;
    };

    buildInputs = [
      btrfs-progs               # for btrfs/ioctl.h
      utillinux                 # for uuid.h
    ];

    nativeBuildInputs = [
      python3Packages.markdown   # documentation build
    ];

    preBuild = ''
      git() { if [[ $1 = describe ]]; then echo ${version}; else command git "$@"; fi; }
      export -f git
    '';

    postBuild = ''
      unset -f git
    '';

    buildFlags = [
      "ETC_PREFIX=/var/run/bees/configs"
    ];

    makeFlags = [
      "SHELL=bash"
      "PREFIX=$(out)"
      "ETC_PREFIX=$(out)/etc"
      "BEES_VERSION=${version}"
      "SYSTEMD_SYSTEM_UNIT_DIR=$(out)/etc/systemd/system"
    ];

    meta = with stdenv.lib; {
      homepage = "https://github.com/Zygo/bees";
      description = "Block-oriented BTRFS deduplication service";
      license = licenses.gpl3;
      platforms = platforms.linux;
      maintainers = with maintainers; [ chaduffy ];
      longDescription = "Best-Effort Extent-Same: bees finds not just identical files, but also identical extents within files that differ";
    };
  };

in

runCommand "bees-service-${version}" {
  inherit bash bees coreutils utillinux;
  btrfsProgs = btrfs-progs; # needs to be a valid shell variable name
} ''
  mkdir -p -- "$out/bin"
  substituteAll ${./bees-service-wrapper} "$out"/bin/bees-service-wrapper
  chmod +x "$out"/bin/bees-service-wrapper
  ln -s ${bees}/bin/beesd "$out"/bin/beesd
''
