[doc('Deploy a `scenario` to the cluster')]
deploy scenario:
  kluctl deploy --project-dir scenarios/{{scenario}} -t dev -y

[doc('Delete a `scenario` from the cluster.')]
delete scenario:
  kluctl delete --project-dir scenarios/{{scenario}} -t dev -y

[doc('Install kluctl')]
install:
  ./install.sh

[doc('Show the help page')]
help:
    just --list
