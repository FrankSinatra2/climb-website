package Contracts

type ApiError struct {
	StatusCode int `json:"-"`
	Message string `json:"message"`
	ErrorDescription string `json:"error_description,omitempty"`
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

func DatabaseQueryError(description string) *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could Not Execute Query", ErrorDescription: description}
}

func HashFailureError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could not Hash String"}
}

func GenerateJwtError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Could not Generate A Jwt"}
}

func FailedToSaveFileError() *ApiError {
	return &ApiError{StatusCode: 500, Message: "Failed to Save File"}
}

/**
* 400 errors
*/
func BadRequestError() *ApiError {
	return &ApiError{StatusCode: 400, Message: "Bad Request"}
}

func MissingFileError() *ApiError {
	return &ApiError{StatusCode: 400, Message: "Request Missing File"}
}

func NotFoundError(msg string) *ApiError {
	return &ApiError{StatusCode: 404, Message: msg}
}