package main

import (
	"github.com/gin-gonic/gin"
	"api/Database"
	"api/Config"
	"fmt"
)

func main() {
	

	db := Database.GetDb()
	defer db.Close()

	router := gin.Default()
	router.Run(fmt.Sprintf(":%s", Config.GetConfig().Port))
}
