package Routes

import (
	"api/Handlers"
	"github.com/gin-gonic/gin"
)

func BindUserRoutes(group *gin.RouterGroup) {
	group.POST("/signup", Handlers.HandleCreateUser)
	group.POST("/authenticate", Handlers.HandleAuthenticateUser)

	group.GET("/:id", Handlers.HandleRetrieveUser)
} 