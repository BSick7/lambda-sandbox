SHELL := /bin/bash

build-lambda:
	mkdir -p tf/dist
	GOOS=linux GOARCH=amd64 go build -o tf/dist/sandbox ./lambda/main.go
	build-lambda-zip -o tf/dist/sandbox.zip tf/dist/sandbox
