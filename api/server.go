package main

import (
	"github.com/gin-gonic/gin"
	"api/Database"
	"api/Config"
	"api/Routes"
	"fmt"
)

func main() {
	

	db := Database.GetDb()
	defer db.Close()

	router := gin.Default()

	Routes.BindUserRoutes(router.Group("/users"))

	router.Run(fmt.Sprintf(":%s", Config.GetConfig().Port))
}
