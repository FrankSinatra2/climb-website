package Config

import (
	"os"
)

type Configuration struct {
	Port string

	MysqlUser string
	MysqlPass string
	MysqlDatabase string

	JwtSecret string
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

	jwtSecret := defaultGetenv("JWT_SECRET", "anime-tiddies")

	config = &Configuration{
		Port: port,
		MysqlUser: mysqlUser,
		MysqlPass: mysqlPass,
		MysqlDatabase: mysqlDatabase,
		JwtSecret: jwtSecret,
	}
}

func GetConfig() *Configuration {
	if config == nil {
		initConfiguration()
	}
	return config
}
