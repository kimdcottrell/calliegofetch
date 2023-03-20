# Callie Go Fetch

Presently, merely sample code for folks looking at my resume.

Eventually, a worker-centric hiring website made with Django, Terraform, Kubernetes, Docker and hosted on AWS.

# Requirements

I use OSX as my workstation of choice.

Local-machine specific tooling is reliant on [asdf](https://asdf-vm.com/) and [Docker](https://www.docker.com/).

To install all local dependencies, run:

```
# install all the tooling in .tool-versions
asdf install
# preview what you're going to run
awk -F ' ' '{ print "asdf local " $1 " " $2 }' .tool-versions
# run it!
awk -F ' ' '{ system("asdf local " $1 " " $2) }' .tool-versions
# check if the versions are correct
asdf current
```
