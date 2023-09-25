package helloworld

import (
	"errors"
	"testing"

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
