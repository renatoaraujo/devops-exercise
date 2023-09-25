package helloworld

type Storage interface {
	Save(string, string) error
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
