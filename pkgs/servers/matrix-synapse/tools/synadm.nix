{ lib
, python3
, fetchPypi
, nix-update-script
}:

python3.pkgs.buildPythonApplication rec {
  pname = "synadm";
  version = "0.45";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KstWVSU0IE1ncfIkIH1QsaQc/Yfs2lF+6+5x9zw9cA8=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    click
    click-option-group
    dnspython
    tabulate
    pyyaml
    requests
  ];

  checkPhase = ''
    runHook preCheck
    export HOME=$TMPDIR
    $out/bin/synadm -h > /dev/null
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Command line admin tool for Synapse";
    longDescription = ''
      A CLI tool to help admins of Matrix Synapse homeservers
      conveniently issue commands available via its admin API's
      (element-hq/synapse@master/docs/admin_api)
    '';
    changelog = "https://github.com/JOJ0/synadm/releases/tag/v${version}";
    homepage = "https://github.com/JOJ0/synadm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
