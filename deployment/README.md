Some deployment has to go in the root directory:
* [travis.yml](../travis.yml)
* [Dockerfile](../Dockerfile)
* [docker.mk](../docker.mk)

Docker is really just used to control global dependencies on travis ci, and to
avoid allow us to run most of ci process locally rather than having to push
several times to iron out travis.yml issues.

It's much slower, but we are not really in a hurry. (this time)

Locally, the the docker container is only needed if the globally installed ruby,
php, python, and bundler versions are not compatible.
