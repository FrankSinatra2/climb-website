package Services

import (
	"api/Contracts"
	"api/Database"
	"fmt"
	"github.com/google/uuid"
	"github.com/gin-gonic/gin"
	"mime/multipart"
	"strings"
)

func CreateSubZone(payload *Contracts.SubZoneCreateRequest) (*Contracts.SubZoneCreateResponse, *Contracts.ApiError) {
	
	id := uuid.New().String()
	model := Database.SubZoneModel{
		Id: id,
		ZoneId: payload.ZoneId,
		Title: payload.Title,
		Description: payload.Description,
	}

	db := Database.GetDb()
	stmt, err := db.Prepare("INSERT INTO `SubZones` (id, zoneId, title, description) VALUES (?, ?, ?, ?)")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	_, err = stmt.Exec(model.Id, model.ZoneId, model.Title, model.Description)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	return &Contracts.SubZoneCreateResponse{Id: id}, nil
}

func RetrieveSubZoneById(id string) (*Contracts.SubZoneRetrieveResponse, *Contracts.ApiError) {
	db := Database.GetDb()

	stmt, err := db.Prepare("SELECT `id`, `zoneId`, `title`, `description` FROM `SubZones` WHERE `id` = ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	defer stmt.Close()

	var result = &Database.SubZoneModel{
		Id: "",
		ZoneId: "",
		Title: "",
		Description: "",
	}

	err = stmt.QueryRow(id).Scan(&result.Id, &result.ZoneId, &result.Title, &result.Description)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	response := &Contracts.SubZoneRetrieveResponse{
		Id: result.Id,
		ZoneId: result.ZoneId,
		Title: result.Title,
		Description: result.Description,
	}

	return response, nil
}

func getImageCount(id string) (int, *Contracts.ApiError) {
	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT COUNT(*) FROM `Images` WHERE `subZoneId` = ?")

	if err != nil {
		return 0, Contracts.DatabaseQueryError(err.Error())
	}

	var count = 0
	err = stmt.QueryRow(id).Scan(&count)

	if err != nil {
		return 0, Contracts.DatabaseQueryError(err.Error())
	}

	return count, nil
}

func PageSubZoneSlideshow(id string, page int, limit int, url string) (*Contracts.SubZoneSlideshowPageResponse, *Contracts.ApiError) {
	linksFormat := "%s?page=%d&limit=%d"
	count, apiError := getImageCount(id)
	if apiError != nil {
		return nil, apiError
	}

	offset := (page - 1) * limit
	lastPage := int(count / limit)
	
	pageLinks := Contracts.PageLinks{
		Self: "",
		First: "",
		Next: "",
		Previous: "",
		Last: "",
	}
	
	pageLinks.Self = fmt.Sprintf(linksFormat, url, page, limit)
	if lastPage > 1 {
		pageLinks.First = fmt.Sprintf(linksFormat, url, 1, limit)
		if page != lastPage {
			pageLinks.Previous = fmt.Sprintf(linksFormat, url, lastPage, limit)
		}
	}

	if page < lastPage {
		pageLinks.Next = fmt.Sprintf(linksFormat, url, page + 1, limit)
	}
	
	if page != 1 {
		pageLinks.Previous = fmt.Sprintf(linksFormat, url, page - 1, limit)
	}
	

	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT `id` FROM `Images` WHERE `subZoneId` = ? LIMIT ?, ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	rows, err := stmt.Query(id, offset, limit)

	if err != nil {

		if count == 0 {
			return nil, Contracts.NotFoundError("No Images Were Found")
		}
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	imageIds := []string{}

	for rows.Next() {
		var id string

		err = rows.Scan(&id)

		if err != nil {
			return nil, Contracts.DatabaseQueryError(err.Error())
		}

		imageIds = append(imageIds, id)
	}

	response := &Contracts.SubZoneSlideshowPageResponse{
		PageLinks: pageLinks,
		TotalCount: count,
		ImageIds: imageIds,
	}

	return response, nil
}

func AddToSubZoneSlideshow(id string, file *multipart.FileHeader, ctx *gin.Context) (*Contracts.SlideshowAddResponse, *Contracts.ApiError) {

	imageId := uuid.New().String()
	originalName := file.Filename
	ext := strings.Split(file.Filename, ".")[1]
	path := fmt.Sprintf("images/%s.%s", imageId, ext)

	model := Database.ImageModel{
		Id: imageId,
		SubZoneId: id,
		OriginalName: originalName,
		Ext: ext,
		Path: path,
	}

	db := Database.GetDb()
	stmt, err := db.Prepare("INSERT INTO `Images` (id, subZoneId, originalName, ext, path) VALUES (?, ?, ?, ?, ?)")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	defer stmt.Close()

	_, err = stmt.Exec(model.Id, model.SubZoneId, model.OriginalName, model.Ext, model.Path)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	err = ctx.SaveUploadedFile(file, model.Path)

	if err != nil {
		return nil, Contracts.FailedToSaveFileError()
	}

	return &Contracts.SlideshowAddResponse{ImageId: imageId}, nil
}