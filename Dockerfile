FROM --platform=$BUILDPLATFORM golang:1.22 as builder
ARG BUILDPLATFORM=linux/amd64

WORKDIR /go/src/app

COPY . .

RUN make build BUILDPLATFORM=$BUILDPLATFORM

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/kbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs

ENTRYPOINT ["./kbot"]
