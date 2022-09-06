{ lib
, rustPlatform
, fetchCrate
, pkg-config
, openssl
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.17.0";

  src = fetchCrate {
    inherit pname version;
    sha256 = "sha256-NwWoF7VkCy+9/8xwaIhR7763JGtC3UheuJdj/FtGzMg=";
  };

  cargoSha256 = "sha256-HFTGtDS4dWzt0q2iC0qgby4fDvnoaNd+Y1eKzhwb3Hs=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  # Tests fail
  doCheck = false;

  meta = with lib; {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    homepage = "https://github.com/Enselic/cargo-public-api";
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}

