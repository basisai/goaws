# build image
FROM golang:alpine as build

WORKDIR /go/src/github.com/basisai/goaws

ENV CGO_ENABLED=0
ENV GOOS=linux
ENV GOARCH=amd64

COPY . .
RUN go test ./app/...
RUN go build -o goaws app/cmd/goaws.go

# release image
FROM alpine

COPY --from=build /go/src/github.com/basisai/goaws/goaws /goaws

COPY app/conf/goaws.yaml /conf/

EXPOSE 4100
ENTRYPOINT ["/goaws"]
