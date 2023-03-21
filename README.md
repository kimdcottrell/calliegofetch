# Callie Go Fetch

Presently, merely sample code for folks looking at my resume.

Eventually, a worker-centric hiring website made with Django, Terraform, Kubernetes, Docker and hosted on AWS.

# Requirements

I use OSX as my workstation of choice.

Local-machine specific tooling is reliant on [asdf](https://asdf-vm.com/) and [Docker](https://www.docker.com/).

To install all local dependencies, run:

```bash
# install all the tooling in .tool-versions
asdf install
# preview what you're going to run
awk -F ' ' '{ print "asdf global " $1 " " $2 }' .tool-versions
# run it!
awk -F ' ' '{ system("asdf global " $1 " " $2) }' .tool-versions
# check if the versions are correct
asdf current
# maybe source your shell so the asdf shims in the path get picked up
~/.zshrc
```

Next, configure your [pre-commit hooks](https://pre-commit.com/#quick-start).

```bash
pre-commit install
pre-commit run --all-files
```

# Overview

| Dir                                | Notes                                                                                                                         |
|------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| cicd                               | contains most files utilized by Docker, Terraform, and Kubernetes                                                             |
| cicd/containers                    | root of docker-compose.yaml utilized during CICD                                                                              |
| cicd/helm                          | TBD                                                                                                                           |
| cicd/infrastructure                | root of Terraform project                                                                                                     |
| cicd/infrastructure/config         | yaml to be utilized inside Terraform for_each loops in resources, modules, etc                                                |
| cicd/infrastructure/config/modules | nested module structure as advised by TF [docs](https://developer.hashicorp.com/terraform/language/modules/develop/structure) | |
