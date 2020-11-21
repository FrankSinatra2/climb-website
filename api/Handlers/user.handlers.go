package Handlers

import (
	"api/Contracts"
	"api/Services"
	"github.com/gin-gonic/gin"
)

func HandleCreateUser(ctx *gin.Context) {
	var payload Contracts.UserCreateRequest
	err := ctx.ShouldBindJSON(&payload)

	if err != nil {
		apiError := Contracts.BadRequestError()
		ctx.JSON(apiError.StatusCode, apiError)
		return
	}

	res, apiError := Services.CreateUser(payload.Username, payload.Password)

	if apiError == nil {
		ctx.JSON(200, res)
	} else {
		ctx.JSON(apiError.StatusCode, apiError)
	}
}

func HandleAuthenticateUser(ctx *gin.Context) {
	var payload Contracts.UserAuthenticateRequest
	err := ctx.ShouldBindJSON(&payload)

	if err != nil {
		apiError := Contracts.BadRequestError()
		ctx.JSON(apiError.StatusCode, apiError)
		return
	}

	res, apiError := Services.AuthenticateUser(payload.Username, payload.Password)

	if apiError == nil {
		ctx.JSON(200, res)
	} else {
		ctx.JSON(apiError.StatusCode, apiError)
	}
}

func HandleRetrieveUser(ctx *gin.Context) {
	res, err := Services.RetrieveUserById(ctx.Param("id"))

	if err == nil {
		ctx.JSON(200, res)
	} else {
		ctx.JSON(err.StatusCode, err)
	}
}