.PHONY: default
default: build

DOCKER_IMAGE ?= golang-nix-template

# get build date
BUILD_DATE = $(strip $(shell date -u +'%Y-%m-%dT%H:%M:%SZ'))
# get the latest commit
GIT_COMMIT = $(strip $(shell git rev-parse --short HEAD))
# get remote origin url
GIT_URL = $(strip $(shell git config --get remote.origin.url))
# get version
VERSION = $(strip $(shell cat VERSION))

.PHONY: build
build: docker-build
	@echo Successfully built: $(DOCKER_IMAGE):$(VERSION)

.PHONY: docker-build
docker-build:
	# build docker image
	docker build \
	--build-arg BUILD_DATE=$(BUILD_DATE) \
	--build-arg VCS_REF=$(GIT_COMMIT) \
	--build-arg VCS_URL=$(GIT_URL) \
	-t $(DOCKER_IMAGE):$(VERSION) .

.PHONY: run
run: docker-run

PHONY: docker-run
docker-run:
	# run docker image
	docker run \
	--rm $(DOCKER_IMAGE):$(VERSION)

