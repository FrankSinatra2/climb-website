package Database


import (
	"fmt"
	"log"
	"time"
	"database/sql"
	_ "github.com/go-sql-driver/mysql"

	"api/Config"
)
 
var db *sql.DB = nil

func initMysqlDb() error {

	config := Config.GetConfig()
	connectionString := fmt.Sprintf("%s:%s@tcp(%s)/%s", config.MysqlUser, config.MysqlPass, config.MysqlAddress, config.MysqlDatabase)

	maybeDb, err := sql.Open("mysql", connectionString)

	if err != nil {
		return err
	}

	maybeDb.SetConnMaxLifetime(time.Minute * 3)
	maybeDb.SetMaxOpenConns(10)
	maybeDb.SetMaxIdleConns(10)

	err = maybeDb.Ping()
	if err != nil {
		return err
	}

	db = maybeDb
	return nil
}

func GetDb() *sql.DB {
	if db == nil {
		err := initMysqlDb()

		if err != nil {
			fmt.Printf("could not get database connection: ")
			log.Fatal(err)
		}
	}

	return db
}