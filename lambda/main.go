package main

import (
	"context"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

func main() {
	log.Println("main:start")
	defer log.Println("main:end")

	x := 0

	lambda.Start(runFn(&x))
}

func runFn(x *int) func(ctx context.Context, payload []byte) (interface{}, error) {
	return func(ctx context.Context, payload []byte) (interface{}, error) {
		log.Println("run:start")
		defer log.Println("run:end")

		log.Println(x)
		*x++
		return *x, nil
	}
}
