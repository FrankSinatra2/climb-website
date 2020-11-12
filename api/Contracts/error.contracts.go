package Contracts

type ApiError struct {
	StatusCode int
	Message string `json:"message"`
}

/**
* 500 errors
*/
func NotImplementedError() *ApiError {
	return &ApiError{StatusCode: 501, Message: "Not Implemented"}
}

func DatabaseConnectionError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could Not Connect to Database"}
}

func DatabaseQueryError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could Not Execute Query"}
}

func HashFailureError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could not Hash String"}
}

func GenerateJwtError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could not Generate A Jwt"}
}

/**
* 400 errors
*/
func BadRequestError() *ApiError {
	return &ApiError{StatusCode: 400, Message: "Bad Request"}
}

func NotFoundError(msg string) *ApiError {
	return &ApiError{StatusCode: 404, Message: msg}
}