package Routes

import (
	"api/Handlers"
	"github.com/gin-gonic/gin"
)

func BindSubZoneRoutes(group *gin.RouterGroup) {
	group.POST("/", Handlers.HandleCreateSubZone)
	group.GET("/:id", Handlers.HandleRetrieveSubZone)
	
	group.GET("/:id/slideshow", Handlers.HandlePageSubZoneSlideshow)
	group.POST("/:id/slideshow", Handlers.HandleAddToSubZoneSlideshow)
} 