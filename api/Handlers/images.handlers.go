package Handlers

import (
	"api/Services"
	"github.com/gin-gonic/gin"
	"fmt"
)

func HandlePostImage(ctx *gin.Context) {
	res, err := Services.SaveImage(ctx)

	if err == nil {
		ctx.JSON(200, res)
	} else {
		ctx.JSON(err.StatusCode, err)
	}
}

func HandleRetrieveImage(ctx *gin.Context) {
	res, err := Services.RetrieveImage(ctx.Param("id"))

	if err != nil {
		ctx.JSON(err.StatusCode, err)
		return
	}
	fmt.Println(res)
	ctx.File(res)
}