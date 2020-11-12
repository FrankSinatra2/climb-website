package Contracts

type UserCreateRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

type UserCreateResponse struct {
	Id string `json:"id"`
	Username string `json:"username"`
}

type UserAuthenticateRequest = UserCreateRequest

type UserAuthenticateResponse struct {
	AccessToken string `json:"access_token"`
}

type UserRetrieveRequest struct {
	Id string `json:"id"`
}

type UserRetrieveResponse = UserCreateResponse
