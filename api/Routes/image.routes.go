package Routes

import (
	"api/Handlers"
	"github.com/gin-gonic/gin"
)

func BindImageRoutes(group *gin.RouterGroup) {
	group.GET("/:id", Handlers.HandleRetrieveImage)
	group.POST("/", Handlers.HandlePostImage)
} 