package helloworld

import (
	"fmt"

	"renatoaraujo/helloworld/pkg/logger"
)

type Handler struct {
	Logger logger.LoggerClient
}

func NewHandler(loggerClient logger.LoggerClient) *Handler {
	return &Handler{
		Logger: loggerClient,
	}
}

func (h *Handler) StoreUsername(username Username, birth DateOfBirth) error {
	// TODO: Implement database storage logic
	h.Logger.Info(fmt.Sprintf("storing user with username %s and date of birth %s", username.Username, birth.DateOfBirth))

	return nil
}
