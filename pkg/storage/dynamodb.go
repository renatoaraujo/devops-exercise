package storage

import (
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/dynamodb"
)

type DynamoDBClientInterface interface {
	SaveUser(username string, dateOfBirth string) error
	GetUser(username string) (string, error)
}

type DynamoDBClient struct {
	db *dynamodb.DynamoDB
}

func NewDynamoDBClient(dsn, region string) (DynamoDBClientInterface, error) {
	sess, err := session.NewSession(&aws.Config{
		Endpoint: aws.String(dsn),
		Region:   aws.String(region),
	})
	if err != nil {
		return nil, err
	}

	return &DynamoDBClient{
		db: dynamodb.New(sess),
	}, nil
}

func (dc *DynamoDBClient) SaveUser(username string, dateOfBirth string) error {
	input := &dynamodb.PutItemInput{
		TableName: aws.String("Users"),
		Item: map[string]*dynamodb.AttributeValue{
			"Username": {
				S: aws.String(username),
			},
			"DateOfBirth": {
				S: aws.String(dateOfBirth),
			},
		},
	}

	_, err := dc.db.PutItem(input)
	return err
}

func (dc *DynamoDBClient) GetUser(username string) (string, error) {
	input := &dynamodb.GetItemInput{
		TableName: aws.String("Users"),
		Key: map[string]*dynamodb.AttributeValue{
			"Username": {
				S: aws.String(username),
			},
		},
	}

	result, err := dc.db.GetItem(input)
	if err != nil {
		return "", err
	}

	if result.Item == nil {
		return "", nil
	}

	return *result.Item["DateOfBirth"].S, nil
}
