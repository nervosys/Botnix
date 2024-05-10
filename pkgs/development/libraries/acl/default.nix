{ lib, stdenv, fetchurl, gettext, attr }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Botpkgs as
# files.

stdenv.mkDerivation rec {
  pname = "acl";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://savannah/acl/acl-${version}.tar.gz";
    sha256 = "sha256-dgxhxokBs3/dXu/ur0wMeia9/disdHoe3/HODiQ8Ea8=";
  };

  patches = [
    ./LFS64.patch
  ];

  outputs = [ "bin" "dev" "out" "man" "doc" ];

  nativeBuildInputs = [ gettext ];
  buildInputs = [ attr ];

  # causes failures in coreutils test suite
  hardeningDisable = [ "fortify3" ];

  # Upstream use C++-style comments in C code. Remove them.
  # This comment breaks compilation if too strict gcc flags are used.
  postPatch = ''
    echo "Removing C++-style comments from include/acl.h"
    sed -e '/^\/\//d' -i include/acl.h

    patchShebangs .
  '';

  meta = with lib; {
    homepage = "https://savannah.nongnu.org/projects/acl";
    description = "Library and tools for manipulating access control lists";
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };
}
