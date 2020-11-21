package Middleware

import (
	"github.com/gin-gonic/gin"
	"fmt"
)

func AuthRequired() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		header := ctx.Request.Header["Authorization"]

		fmt.Println(header)
		ctx.Next()
	}
}