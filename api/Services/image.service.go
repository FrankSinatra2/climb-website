package Services

import (
	"api/Contracts"
	"api/Database"
	"github.com/google/uuid"
	"github.com/gin-gonic/gin"
	"fmt"
)

func SaveImage(ctx *gin.Context) (*Contracts.ImagePostResponse, *Contracts.ApiError) {

	// form, err := ctx.MultipartForm()
	// fmt.Printf("%+v, %+v\n", form, err)
	// files := form.File["file"]

	// if len(files) < 1 {
	// 	return nil, Contracts.MissingFileError()
	// }

	// file := files[0]

	_, header , err := ctx.Request.FormFile("file")
	// fmt.Printf("%+v, %+v, %+v\n", file, header, err)

	id := uuid.New().String()
	originalName := header.Filename
	path := fmt.Sprintf("images/%s.png", id)
	ext := "png" // TODO: do better

	model := Database.ImageModel{
		Id: id,
		OriginalName: originalName,
		Ext: ext,
		Path: path,
	}

	db := Database.GetDb()

	stmt, err := db.Prepare("INSERT INTO `Images` (id, originalName, ext, path) VALUES (?, ?, ?, ?)")
	
	if err != nil {
		return nil, Contracts.DatabaseQueryError()
	}

	defer stmt.Close()

	_, err = stmt.Exec(model.Id, model.OriginalName, model.Ext, model.Path)

	if err != nil {
		fmt.Println(err.Error())
		return nil, Contracts.DatabaseQueryError()
	}

	err = ctx.SaveUploadedFile(header, model.Path)

	if err != nil {
		// delete db entry?
		fmt.Println(err.Error())
		return nil, Contracts.FailedToSaveFileError()
	}

	return &Contracts.ImagePostResponse{Id: id}, nil
}

func RetrieveImage(id string) (string, *Contracts.ApiError) {

	model := Database.ImageModel{Id: id, OriginalName: "", Ext: "Ext", Path: ""}

	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT `Path` FROM `Images` WHERE `id` = ?")

	if err != nil {
		fmt.Println(err.Error())
		return "", Contracts.DatabaseQueryError()
	}

	err = stmt.QueryRow(model.Id).Scan(&model.Path)

	if err != nil {
		fmt.Printf(err.Error())
		return "", Contracts.DatabaseQueryError()
	}

	return model.Path, nil
}