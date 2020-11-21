package Services

import (
	"api/Contracts"
	"api/Database"
)

func RetrieveImage(id string) (string, *Contracts.ApiError) {

	model := Database.ImageModel{Id: id, OriginalName: "", Ext: "Ext", Path: ""}

	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT `Path` FROM `Images` WHERE `id` = ?")

	if err != nil {
		return "", Contracts.DatabaseQueryError(err.Error())
	}

	err = stmt.QueryRow(model.Id).Scan(&model.Path)

	if err != nil {
		return "", Contracts.DatabaseQueryError(err.Error())
	}

	return model.Path, nil
}