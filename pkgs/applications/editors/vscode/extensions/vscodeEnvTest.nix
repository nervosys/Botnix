with import <botpkgs>{};
callPackage (import ./vscodeEnv.nix) {
  extensionsFromVscodeMarketplace = vscode-utils.extensionsFromVscodeMarketplace;
  vscodeDefault = vscode;
} {
  mutableExtensionsFile = ./extensions.nix;
  settings = {
    a = "fdsdf";
    t = "test";
  };
}
