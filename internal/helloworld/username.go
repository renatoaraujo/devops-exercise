package helloworld

type Username struct {
	Username string
}

func NewUsername(username string) Username {
	// TODO: Adds validation
	return Username{Username: username}
}
