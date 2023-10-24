{ python3, fetchFromGitHub }:

let
  python = python3.override {
    packageOverrides = self: super: rec {
      poetry = self.callPackage ./unwrapped.nix { };

      # The versions of Poetry and poetry-core need to match exactly,
      # and poetry-core in nixpkgs requires a staging cycle to be updated,
      # so apply an override here.
      #
      # We keep the override around even when the versions match, as
      # it's likely to become relevant again after the next Poetry update.
      poetry-core = super.poetry-core.overridePythonAttrs (old: rec {
        version = poetry.version;
        src = fetchFromGitHub {
          owner = "python-poetry";
          repo = "poetry-core";
          rev = version;
          hash = "sha256-OfY2zc+5CgOrgbiPVnvMdT4h1S7Aek8S7iThl6azmsk=";
        };
      });
    } // (plugins self);
  };

  plugins = ps: with ps; {
    poetry-audit-plugin = callPackage ./plugins/poetry-audit-plugin.nix { };
    poetry-plugin-export = callPackage ./plugins/poetry-plugin-export.nix { };
    poetry-plugin-up = callPackage ./plugins/poetry-plugin-up.nix { };
  };

  # selector is a function mapping pythonPackages to a list of plugins
  # e.g. poetry.withPlugins (ps: with ps; [ poetry-plugin-up ])
  withPlugins = selector: let
    selected = selector (plugins python.pkgs);
  in python.pkgs.toPythonApplication (python.pkgs.poetry.overridePythonAttrs (old: {
    propagatedBuildInputs = old.propagatedBuildInputs ++ selected;

    # save some build time when adding plugins by disabling tests
    doCheck = selected == [ ];

    # Propagating dependencies leaks them through $PYTHONPATH which causes issues
    # when used in nix-shell.
    postFixup = ''
      rm $out/nix-support/propagated-build-inputs
    '';

    passthru = {
      plugins = plugins python.pkgs;
      inherit withPlugins python;
    };
  }));
in withPlugins (ps: [ ])
