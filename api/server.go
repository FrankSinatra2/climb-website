package main

import (
	"github.com/gin-gonic/gin"
	"api/Database"
	"api/Config"
	"api/Routes"
	"api/Middleware"
	"fmt"
)

func main() {
	

	db := Database.GetDb()
	defer db.Close()

	router := gin.Default()

	router.Use(Middleware.Cors())

	Routes.BindUserRoutes(router.Group("/users"))
	Routes.BindImageRoutes(router.Group("/images"))
	Routes.BindSubZoneRoutes(router.Group("/subzones"))
	Routes.BindZoneRoutes(router.Group("/zones"))

	router.Run(fmt.Sprintf(":%s", Config.GetConfig().Port))
}
