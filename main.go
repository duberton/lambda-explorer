package main

import (
	"context"
	"log"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Body struct {
	Name string `json:"name"`
}

func handler(ctx context.Context, body Body) (events.SQSEventResponse, error) {
	failures := []events.SQSBatchItemFailure{}

	// for _, record := range sqsEvent.Records {
	// 	log.Printf("Event name %v", record.Body)
	// }
	log.Printf("Body %v", body.Name)
	time.Sleep(3 * time.Second)
	return events.SQSEventResponse{BatchItemFailures: failures}, nil
}

func main() {
	lambda.Start(handler)
}
