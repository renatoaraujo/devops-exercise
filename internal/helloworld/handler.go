package helloworld

import (
	"errors"
	"fmt"
	"math"
	"time"
)

type Storage interface {
	Save(string, string) error
	GetDateOfBirthFromUsername(username string) (string, error)
}

type Handler struct {
	storage Storage
}

func NewHandler(storage Storage) *Handler {
	return &Handler{
		storage: storage,
	}
}

func (h *Handler) StoreUsername(username Username, birth DateOfBirth) error {
	return h.storage.Save(username.Username, birth.DateOfBirth)
}

func (h *Handler) GetBirthdayMessage(username Username) (string, error) {
	dateOfBirth, err := h.storage.GetDateOfBirthFromUsername(username.Username)
	if err != nil {
		return "", errors.New("failed to get date of birth")
	}

	birthdayMessage, err := calculateBirthdayMessage(dateOfBirth)
	if err != nil {
		return "", errors.New("failed to calculate birthday message")
	}

	return fmt.Sprintf("Hello, %s! %s", username.Username, birthdayMessage), nil
}

func calculateBirthdayMessage(dob string) (string, error) {
	layout := "2006-01-02"
	birthday, err := time.Parse(layout, dob)
	if err != nil {
		return "", err
	}

	now := time.Now().Truncate(24 * time.Hour)
	nextBirthday := time.Date(now.Year(), birthday.Month(), birthday.Day(), 0, 0, 0, 0, time.UTC)

	if nextBirthday.Before(now) {
		nextBirthday = time.Date(now.Year()+1, birthday.Month(), birthday.Day(), 0, 0, 0, 0, time.UTC)
	}

	daysUntil := math.Round(nextBirthday.Sub(now).Hours() / 24)
	if daysUntil == 0 {
		return "Happy birthday!", nil
	}

	return fmt.Sprintf("Your birthday is in %d day(s)", int(daysUntil)), nil
}
