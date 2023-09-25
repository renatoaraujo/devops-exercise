package logger

import "go.uber.org/zap"

type LoggerClient interface {
	Info(msg string, keysAndValues ...interface{})
	Error(msg string, keysAndValues ...interface{})
	Fatal(msg string, keysAndValues ...interface{})
}

type Client struct {
	logger *zap.Logger
}

func NewLogger() LoggerClient {
	logger, _ := zap.NewProduction()
	defer logger.Sync()

	return &Client{logger: logger}
}

func (c *Client) Info(msg string, keysAndValues ...interface{}) {
	c.logger.Sugar().Infow(msg, keysAndValues...)
}

func (c *Client) Error(msg string, keysAndValues ...interface{}) {
	c.logger.Sugar().Errorw(msg, keysAndValues...)
}

func (c *Client) Fatal(msg string, keysAndValues ...interface{}) {
	c.logger.Sugar().Fatalw(msg, keysAndValues...)
}
