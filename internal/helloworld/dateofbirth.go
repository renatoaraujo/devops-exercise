package helloworld

type DateOfBirth struct {
	DateOfBirth string
}

func NewDateOfBirth(dateOfBirth string) DateOfBirth {
	// TODO: Adds validation
	return DateOfBirth{DateOfBirth: dateOfBirth}
}
