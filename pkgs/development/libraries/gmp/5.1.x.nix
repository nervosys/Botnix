{ lib, stdenv, fetchurl, m4
, cxx ? true
, withStatic ? stdenv.hostPlatform.isStatic
}:

let inherit (lib) optional; in

let self = stdenv.mkDerivation rec {
  pname = "gmp";
  version = "5.1.3";

  src = fetchurl { # we need to use bz2, others aren't in bootstrapping stdenv
    urls = [ "mirror://gnu/gmp/gmp-${version}.tar.bz2" "ftp://ftp.gmplib.org/pub/gmp-${version}/gmp-${version}.tar.bz2" ];
    sha256 = "0q5i39pxrasgn9qdxzpfbwhh11ph80p57x6hf48m74261d97j83m";
  };

  #outputs TODO: split $cxx due to libstdc++ dependency
  # maybe let ghc use a version with *.so shared with rest of botpkgs and *.a added
  # - see #5855 for related discussion
  outputs = [ "out" "dev" "info" ];
  passthru.static = self.out;

  nativeBuildInputs = [ m4 ];

  patches = [
    ./5.1.3-CVE-2021-43618.patch
  ] ++ lib.optionals stdenv.isDarwin [
    ./need-size-t.patch
  ];

  configureFlags = [
    "--with-pic"
    (lib.enableFeature cxx "cxx")
    # Build a "fat binary", with routines for several sub-architectures
    # (x86), except on Solaris where some tests crash with "Memory fault".
    # See <https://hydra.nixos.org/build/2760931>, for instance.
    #
    # no darwin because gmp uses ASM that clang doesn't like
    (lib.enableFeature (!stdenv.isSunOS && stdenv.hostPlatform.isx86) "fat")
    # The config.guess in GMP tries to runtime-detect various
    # ARM optimization flags via /proc/cpuinfo (and is also
    # broken on multicore CPUs). Avoid this impurity.
    "--build=${stdenv.buildPlatform.config}"
  ] ++ optional (cxx && stdenv.isDarwin) "CPPFLAGS=-fexceptions"
    ++ optional (stdenv.isDarwin && stdenv.is64bit) "ABI=64"
    ;

  doCheck = true;

  dontDisableStatic = withStatic;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://gmplib.org/";
    description = "GNU multiple precision arithmetic library";
    license = licenses.gpl3Plus;

    longDescription =
      '' GMP is a free library for arbitrary precision arithmetic, operating
         on signed integers, rational numbers, and floating point numbers.
         There is no practical limit to the precision except the ones implied
         by the available memory in the machine GMP runs on.  GMP has a rich
         set of functions, and the functions have a regular interface.

         The main target applications for GMP are cryptography applications
         and research, Internet security applications, algebra systems,
         computational algebra research, etc.

         GMP is carefully designed to be as fast as possible, both for small
         operands and for huge operands.  The speed is achieved by using
         fullwords as the basic arithmetic type, by using fast algorithms,
         with highly optimised assembly code for the most common inner loops
         for a lot of CPUs, and by a general emphasis on speed.

         GMP is faster than any other bignum library.  The advantage for GMP
         increases with the operand sizes for many operations, since GMP uses
         asymptotically faster algorithms.
      '';

    platforms = platforms.all;
    badPlatforms = [ "x86_64-darwin" ];
    # never built on aarch64-darwin since first introduction in botpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
};
  in self
