{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, alembic
, boto3
, botorch
, catboost
, cma
, cmaes
, colorlog
, distributed
, fakeredis
, fastai
, google-cloud-storage
, lightgbm
, matplotlib
, mlflow
, moto
, numpy
, packaging
, pandas
, plotly
, pytest-xdist
, pytorch-lightning
, pyyaml
, redis
, scikit-learn
, scikit-optimize
, scipy
, setuptools
, shap
, sqlalchemy
, tensorflow
, torch
, torchaudio
, torchvision
, tqdm
, wandb
, wheel
, xgboost
}:

buildPythonPackage rec {
  pname = "optuna";
  version = "3.4.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "optuna";
    repo = "optuna";
    rev = "refs/tags/v${version}";
    hash = "sha256-WUjO13NxX0FneOPS4nn6aHq48X95r+GJR/Oxir6n8Pk=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    alembic
    colorlog
    numpy
    packaging
    sqlalchemy
    tqdm
    pyyaml
  ];

  passthru.optional-dependencies = {
    integration = [
      botorch
      catboost
      cma
      distributed
      fastai
      lightgbm
      mlflow
      pandas
      # pytorch-ignite
      pytorch-lightning
      scikit-learn
      scikit-optimize
      shap
      tensorflow
      torch
      torchaudio
      torchvision
      wandb
      xgboost
    ];
    optional = [
      boto3
      botorch
      cmaes
      google-cloud-storage
      matplotlib
      pandas
      plotly
      redis
      scikit-learn
    ];
  };

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  nativeCheckInputs = [
    fakeredis
    moto
    pytest-xdist
    pytestCheckHook
    scipy
  ] ++ fakeredis.optional-dependencies.lua
    ++ passthru.optional-dependencies.optional;

  pytestFlagsArray = [
    "-m 'not integration'"
  ];

  disabledTestPaths = [
    # require unpackaged kaleido and building it is a bit difficult
    "tests/visualization_tests"
  ];

  pythonImportsCheck = [
    "optuna"
  ];

  meta = with lib; {
    description = "A hyperparameter optimization framework";
    homepage = "https://optuna.org/";
    changelog = "https://github.com/optuna/optuna/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
