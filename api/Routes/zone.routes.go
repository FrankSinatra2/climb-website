package Routes

import (
	"api/Handlers"
	"github.com/gin-gonic/gin"
	"api/Middleware"
)

func BindZoneRoutes(group *gin.RouterGroup) {
	group.Use(Middleware.AuthRequired())
	
	group.POST("/", Handlers.HandleCreateZone)
	group.GET("/:id", Handlers.HandleRetrieveZone)
	group.GET("", Handlers.HandlePageZones)

	group.GET("/:id/subzones", Handlers.HandlePageZoneSubZones)
}