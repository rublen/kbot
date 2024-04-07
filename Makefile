VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGET_OS=linux
format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v

build: format
	CGO_ENABLED=0 GOODS=${TARGET_OS} GO_ARCH=${shell dpkg --print-architecture} go build -v -o kbot -ldflags "-X="github.com/rublen/kbot/cmd.appVersion=${VERSION}

clean:
	rm -rf kbot
