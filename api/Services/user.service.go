package Services

import (
	"api/Database"
)

func CreateUser() (*Database.User, error) {
	return (_, _)
}

func AuthenticateUser(username string, hashedPwd string) (string, error) {
	return ("", _)
}

func RetrieveUserById(id string) (*Database.User, error) {
	return (_, _)
}