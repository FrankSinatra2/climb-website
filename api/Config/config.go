package Config

import (
	"os"
	"fmt"
)

type Configuration struct {
	Port string

	MysqlUser string
	MysqlPass string
	MysqlDatabase string
}

var config *Configuration = nil

func defaultGetenv(env string, def string) string {
	if value := os.Getenv(env); value != "" {
		return value
	}	
	return def
}

func initConfiguration() {
	port := defaultGetenv("PORT", "8080")

	mysqlUser := defaultGetenv("MYSQL_USER", "admin")
	mysqlPass := defaultGetenv("MYSQL_PASS", "hunter2")
	mysqlDatabase := defaultGetenv("MYSQL_DATABASE", "ClimbingExploration")

	fmt.Println(mysqlUser)
	fmt.Println(mysqlPass)
	fmt.Println(mysqlDatabase)

	config = &Configuration{
		Port: port,
		MysqlUser: mysqlUser,
		MysqlPass: mysqlPass,
		MysqlDatabase: mysqlDatabase,
	}
}

func GetConfig() *Configuration {
	if config == nil {
		initConfiguration()
	}
	return config
}
