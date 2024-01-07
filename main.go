package main

import (
	"context"
	"encoding/json"
	"fmt"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Body struct {
	Name string `json:"name"`
}

func handler(context context.Context, request events.APIGatewayProxyRequest) (string, error) {
	var body Body
	err := json.Unmarshal([]byte(request.Body), &body)
	return fmt.Sprintf("Hello, %s", body.Name), err
}

func main() {
	lambda.Start(handler)
}
