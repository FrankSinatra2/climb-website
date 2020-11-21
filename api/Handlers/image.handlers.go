package Handlers

import (
	"api/Services"
	"github.com/gin-gonic/gin"
)

func HandleRetrieveImage(ctx *gin.Context) {
	res, err := Services.RetrieveImage(ctx.Param("id"))

	if err != nil {
		ctx.JSON(err.StatusCode, err)
		return
	}

	ctx.File(res)
}