REGISTRY=rublen
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGET_OS=linux # linux darwin windows
# TARGET_ARCH=arm64 # amd64
TARGET_ARCH=$(shell dpkg --print-architecture)

APP_NAME=$(shell basename $(shell git remote get-url origin) .git)
IMAGE_NAME=${REGISTRY}/${APP_NAME}:${VERSION}-${TARGET_ARCH}

test_vars:
	echo "\nAPP_NAME: ${APP_NAME}\nIMAGE_NAME: ${IMAGE_NAME}\nTARGET_ARCH: ${TARGET_ARCH}\n"
format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v
get:
	go get

image:
	docker build . -t ${IMAGE_NAME}
push:
	docker push ${IMAGE_NAME}

build: format get
	CGO_ENABLED=0 GOOS=${TARGET_OS} GOARCH=${TARGET_ARCH} go build -v -o kbot -ldflags "-X="github.com/rublen/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
