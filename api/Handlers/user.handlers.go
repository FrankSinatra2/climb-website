package Handlers

import (
	"api/Contracts"
	"api/Services"
	"github.com/gin-gonic/gin"
)

func HandleCreateUser(ctx *gin.Context) {
	var payload Contracts.UserCreateRequest
	ctx.BindJSON(payload)

	res, err := Services.CreateUser(payload.Username, payload.Password)

	if err == nil {
		ctx.JSON(200, res)
	} else {
		ctx.JSON(err.StatusCode, err)
	}
}

func HandleAuthenticateUser(ctx *gin.Context) {
	var payload Contracts.UserAuthenticateRequest
	ctx.BindJSON(payload)

	res, err := Services.AuthenticateUser(payload.Username, payload.Password)

	if err == nil {
		ctx.JSON(200, res)
	} else {
		ctx.JSON(err.StatusCode, err)
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