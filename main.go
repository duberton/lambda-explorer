package main

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
)

type Event struct {
	Name string `json:"name"`
}

func handler(context context.Context, event Event) (string, error) {
	log.Printf("Name %s", event.Name)
	return fmt.Sprintf("Hello, %s", event.Name), nil
}

func main() {
	lambda.Start(handler)
}
