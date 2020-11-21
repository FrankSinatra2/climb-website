package Services

import (
	"api/Database"
	"api/Contracts"
	"api/Authentication"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"
	"fmt"
)

func CreateUser(username string, pwd string) (*Contracts.UserCreateResponse, *Contracts.ApiError) {
	db := Database.GetDb()

	id := uuid.New().String()
	hashedPwd, err := bcrypt.GenerateFromPassword([]byte(pwd), bcrypt.DefaultCost)
	stmt, err := db.Prepare("INSERT INTO `Users` (id, username, hashedPwd) VALUES (?, ?, ?)")

	{
		if err != nil {
			return nil, Contracts.DatabaseQueryError(err.Error())
		}

		defer stmt.Close()

		_, err = stmt.Exec(id, username, hashedPwd)

		if err != nil {
			return nil, Contracts.DatabaseQueryError(fmt.Sprintf("CreateUser: %s", err.Error()))
		}
	}

	return RetrieveUserById(id)

}

func AuthenticateUser(username string, password string) (*Contracts.UserAuthenticateResponse, *Contracts.ApiError) {
	db := Database.GetDb()

	stmt, err := db.Prepare("SELECT * FROM `Users` WHERE `username` = ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	defer stmt.Close()

	var result = Database.UserModel{Id: "", Username: ""}
	var hashedPwd string
	err = stmt.QueryRow(username).Scan(&result.Id, &result.Username, &hashedPwd)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	err = bcrypt.CompareHashAndPassword([]byte(hashedPwd), []byte(password))

	if err != nil {
		return nil, Contracts.HashFailureError()
	}

	accessToken, err := Authentication.GenerateJwt(result.Username, result.Id)

	if err != nil {
		return nil, Contracts.GenerateJwtError()
	}

	return &Contracts.UserAuthenticateResponse{AccessToken: accessToken}, nil
}

func RetrieveUserById(id string) (*Contracts.UserRetrieveResponse, *Contracts.ApiError) {
	db := Database.GetDb()

	stmt, err := db.Prepare("SELECT `id`, `username` FROM `Users` WHERE `id` = ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(fmt.Sprintf("RetrieveUserById1: %s", err.Error()))
	}

	defer stmt.Close()

	var result = &Database.UserModel{Id: "", Username: ""}
	err = stmt.QueryRow(id).Scan(&result.Id, &result.Username)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(fmt.Sprintf("RetrieveUserById2: %s", err.Error()))
	}

	response := &Contracts.UserRetrieveResponse{Id: result.Id, Username: result.Username}

	return response, nil
}