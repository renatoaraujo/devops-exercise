package storage

type DatabaseClient struct {
}

func NewDatabase(connString string) (DatabaseClient, error) {
	return DatabaseClient{}, nil
}

func (db DatabaseClient) Save(username, dateOfBirth string) error {
	return nil
}
