{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "yafetch";
  version = "unstable-2022-04-20";

  src = fetchFromGitHub {
    owner = "kira64xyz";
    repo = pname;
    rev = "a118cfc13f0b475db7c266105c10138d838788b8";
    sha256 = "bSJlerfbJG6h5dDwWQKHnVLH6DEuvuUyqaRuJ7jvOsA=";
  };

  # Use the provided Botnix logo automatically
  prePatch = ''
    substituteInPlace ./config.h --replace \
      "#include \"ascii/gnu.h\"" "#include \"ascii/botnix.h\""

    sed '1i#include <array>' -i config.h # gcc12
  '';

  # Fixes installation path
  PREFIX = placeholder "out";

  meta = with lib; {
    homepage = "https://github.com/kira64xyz/yafetch";
    description = "Yet another fetch clone written in C++";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivar ashley ];
    platforms = platforms.linux;
    mainProgram = "yafetch";
  };
}
