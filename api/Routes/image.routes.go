package Routes

import (
	"api/Handlers"
	"api/Middleware"
	"github.com/gin-gonic/gin"
)

func BindImageRoutes(group *gin.RouterGroup) {
	group.Use(Middleware.AuthRequired())
	group.GET("/:id", Handlers.HandleRetrieveImage)
} 