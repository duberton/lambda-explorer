package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"github.com/aws/aws-lambda-go/lambda"
)

type Body struct {
	Name string `json:"name"`
}

func handler(context context.Context, request Body) (string, error) {
	// var body Body
	// err := json.Unmarshal([]byte(request.Body), &body)
	log.Printf("Event name %v", request)
	time.Sleep(3 * time.Second)
	return fmt.Sprintf("Hello, %s", request.Name), nil
}

func main() {
	lambda.Start(handler)
}
