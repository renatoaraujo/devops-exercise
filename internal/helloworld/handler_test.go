package helloworld

import (
	"errors"
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"github.com/stretchr/testify/require"
)

func TestHandler_StoreUsername(t *testing.T) {
	tests := []struct {
		name         string
		username     Username
		dateOfBirth  DateOfBirth
		storageSetup func(mock *StorageMock)
		wantErr      bool
	}{
		{
			name: "failed to store username",
			storageSetup: func(client *StorageMock) {
				client.On("Save", mock.Anything, mock.Anything).Return(errors.New("failed to save"))
			},
			wantErr: true,
		},
		{
			name: "successfully stored username",
			storageSetup: func(client *StorageMock) {
				client.On("Save", mock.Anything, mock.Anything).Return(nil)
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			storage := &StorageMock{}
			if tt.storageSetup != nil {
				tt.storageSetup(storage)
			}

			h := &Handler{
				storage: storage,
			}

			err := h.StoreUsername(tt.username, tt.dateOfBirth)
			if tt.wantErr {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}
		})
	}
}

func TestHandler_GetBirthdayMessage(t *testing.T) {
	tests := []struct {
		name         string
		username     Username
		storageSetup func(mock *StorageMock)
		message      string
		wantErr      bool
	}{
		{
			name:     "failed to get date of birth from username",
			username: Username{Username: "johndoe"},
			storageSetup: func(client *StorageMock) {
				client.On("GetDateOfBirthFromUsername", mock.Anything).Return(
					"",
					errors.New("failed to save"),
				)
			},
			wantErr: true,
		},
		{
			name:     "success calculating the date of birth of username in 3 days",
			username: Username{Username: "johndoe"},
			storageSetup: func(client *StorageMock) {
				inTenDays := time.Now().AddDate(0, 0, +3).Format("2006-01-02")
				client.On("GetDateOfBirthFromUsername", mock.Anything).Return(
					inTenDays,
					nil,
				)
			},
			message: "Hello, johndoe! Your birthday is in 3 day(s)",
			wantErr: false,
		},
		{
			name:     "success calculating the date of birth of username today",
			username: Username{Username: "johndoe"},
			storageSetup: func(client *StorageMock) {
				today := time.Now().Format("2006-01-02")
				client.On("GetDateOfBirthFromUsername", mock.Anything).Return(
					today,
					nil,
				)
			},
			message: "Hello, johndoe! Happy birthday!",
			wantErr: false,
		},
		{
			name:     "success calculating the date of birth of username in 365 days with yesterday date",
			username: Username{Username: "johndoe"},
			storageSetup: func(client *StorageMock) {
				yesterday := time.Now().AddDate(0, 0, -1).Format("2006-01-02")
				client.On("GetDateOfBirthFromUsername", mock.Anything).Return(
					yesterday,
					nil,
				)
			},
			message: "Hello, johndoe! Your birthday is in 365 day(s)",
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			storage := &StorageMock{}
			if tt.storageSetup != nil {
				tt.storageSetup(storage)
			}

			h := &Handler{
				storage: storage,
			}

			message, err := h.GetBirthdayMessage(tt.username)
			if tt.wantErr {
				require.Error(t, err)
			} else {
				require.NoError(t, err)
			}

			assert.Equal(t, tt.message, message)
		})
	}
}
