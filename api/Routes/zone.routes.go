package Routes

import (
	"api/Handlers"
	"github.com/gin-gonic/gin"
)

func BindZoneRoutes(group *gin.RouterGroup) {
	group.POST("/", Handlers.HandleCreateZone)
	group.GET("/:id", Handlers.HandleRetrieveZone)

	group.GET("/:id/subzones", Handlers.HandlePageZoneSubZones)
}