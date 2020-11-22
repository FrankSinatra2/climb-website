package main

import (
	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"
	"api/Database"
	"api/Config"
	"api/Routes"
	"fmt"
)

func main() {
	

	db := Database.GetDb()
	defer db.Close()

	router := gin.Default()

	router.Use(cors.Default())

	Routes.BindUserRoutes(router.Group("/users"))
	Routes.BindImageRoutes(router.Group("/images"))
	Routes.BindSubZoneRoutes(router.Group("/subzones"))
	Routes.BindZoneRoutes(router.Group("/zones"))

	router.Run(fmt.Sprintf(":%s", Config.GetConfig().Port))
}
