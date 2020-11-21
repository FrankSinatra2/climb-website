package Handlers

import (
	"api/Services"
	"api/Contracts"
	"github.com/gin-gonic/gin"
	"fmt"
)

func HandleRetrieveImage(ctx *gin.Context) {
	res, err := Services.RetrieveImage(ctx.Param("id"))

	if err != nil {
		ctx.JSON(err.StatusCode, err)
		return
	}
	fmt.Println(res)
	ctx.File(res)
}