REGISTRY=rublen
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
APP_NAME=$(shell basename $(shell git remote get-url origin) .git)
IMAGE_NAME=${REGISTRY}/${APP_NAME}:${VERSION}-${target_arch}

target_os?=linux
target_arch?=$(shell dpkg --print-architecture)
platform=${target_os}/${target_arch}
binary_name?=kbot

arm:     target_arch=arm64
darwin:  target_os=darwin
darwin:  target_arch=amd64
windows: target_os=windows
windows: target_arch=amd64
windows: binary_name=kbot.exe

test_vars:
	echo "\nAPP_NAME: ${APP_NAME}\nIMAGE_NAME: ${IMAGE_NAME}\nTARGET_ARCH: ${target_arch}\nTARGET_OS: ${target_os}\nPLATFORM: ${platform}\n"

format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v
get:
	go get

image:
	docker build . -t ${IMAGE_NAME} --build-arg BUILDPLATFORM=${platform}
push:
	docker push ${IMAGE_NAME}

build_current: format get
	CGO_ENABLED=0 go build -v -o ${binary_name} -ldflags "-X="github.com/rublen/kbot/cmd.appVersion=${VERSION}

build: format get
	CGO_ENABLED=0 GOOS=${shell ${BUILDPLATFORM%/*}} GOARCH=${shell ${BUILDPLATFORM#*/}} go build -v -o ${binary_name} -ldflags "-X="github.com/rublen/kbot/cmd.appVersion=${VERSION}

linux: test_vars format get image
darwin: test_vars format get image
arm: test_vars format get image
windows: test_vars format get image

clean:
	rm -rf kbot
	rm -rf kbot.exe
