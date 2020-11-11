package Handlers

import (
	"github.com/gin-gonic/gin"
)

func HandleCreateUser(ctx *gin.Context) {
	ctx.JSON(501, gin.H{ "message": "Not Implemented" })
}

func HandleAuthenticateUser(ctx *gin.Context) {
	ctx.JSON(501, gin.H{ "message": "Not Implemented" })
}

func HandleRetrieveUser(ctx *gin.Context) {
	ctx.JSON(501, gin.H{ "message": "Not Implemented" })
}