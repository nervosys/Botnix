{ lib
, stdenv
, fetchurl
, gmp
, writeScript
}:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Botpkgs as
# files.

stdenv.mkDerivation rec {
  version = "4.2.1";
  pname = "mpfr";

  src = fetchurl {
    urls = [
      "https://www.mpfr.org/${pname}-${version}/${pname}-${version}.tar.xz"
      "mirror://gnu/mpfr/${pname}-${version}.tar.xz"
    ];
    hash = "sha256-J3gHNTpnJpeJlpRa8T5Sgp46vXqaW3+yeTiU4Y8fy7I=";
  };

  outputs = [ "out" "dev" "doc" "info" ];

  strictDeps = true;
  # mpfr.h requires gmp.h
  propagatedBuildInputs = [ gmp ];

  configureFlags = lib.optional stdenv.hostPlatform.isSunOS "--disable-thread-safe"
    ++ lib.optional stdenv.hostPlatform.is64bit "--with-pic"
    ++ lib.optionals stdenv.hostPlatform.isPower64 [
      # Without this, the `tget_set_d128` test experiences a link
      # error due to missing `__dpd_trunctdkf`.
      "--disable-decimal-float"
    ];

  doCheck = true; # not cross;

  enableParallelBuilding = true;

  passthru = {
    updateScript = writeScript "update-mpfr" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl pcre common-updater-scripts

      set -eu -o pipefail

      # Expect the text in format of '<title>GNU MPFR version 4.1.1</title>'
      new_version="$(curl -s https://www.mpfr.org/mpfr-current/ |
          pcregrep -o1 '<title>GNU MPFR version ([0-9.]+)</title>')"
      update-source-version ${pname} "$new_version"
    '';
  };

  meta = {
    homepage = "https://www.mpfr.org/";
    description = "Library for multiple-precision floating-point arithmetic";

    longDescription = ''
      The GNU MPFR library is a C library for multiple-precision
      floating-point computations with correct rounding.  MPFR is
      based on the GMP multiple-precision library.

      The main goal of MPFR is to provide a library for
      multiple-precision floating-point computation which is both
      efficient and has a well-defined semantics.  It copies the good
      ideas from the ANSI/IEEE-754 standard for double-precision
      floating-point arithmetic (53-bit mantissa).
    '';

    license = lib.licenses.lgpl2Plus;

    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
