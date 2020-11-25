package Services

import (
	"api/Contracts"
	"api/Database"
	"github.com/google/uuid"
	"fmt"
)

func CreateZone(lat float32, long float32, title string) (*Contracts.ZoneCreateResponse, *Contracts.ApiError) {

	db := Database.GetDb()
	stmt, err := db.Prepare("INSERT INTO `Zones` (id, latitude, longitude, title) VALUES (?, ?, ?, ?)")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	defer stmt.Close()

	id := uuid.New().String()
	model := Database.ZoneModel{
		Id: id,
		Latitude: lat,
		Longitude: long,
		Title: title,
	}

	_, err = stmt.Exec(model.Id, model.Latitude, model.Longitude, model.Title)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	return &Contracts.ZoneCreateResponse{Id: id}, nil
}

func RetrieveZoneById(id string) (*Contracts.ZoneRetrieveResponse, *Contracts.ApiError) {
	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT * FROM `Zones` WHERE `Id` = ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	var result = Database.ZoneModel{
		Id: "",
		Latitude: 0.0,
		Longitude: 0.0,
		Title: "",
	}

	err = stmt.QueryRow(id).Scan(&result.Id, &result.Latitude, &result.Longitude, &result.Title)

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	response := &Contracts.ZoneRetrieveResponse{
		Id: result.Id,
		Latitude: result.Latitude,
		Longitude: result.Longitude,
		Title: result.Title,
	}

	return response, nil
}

func getZoneCount() (int, *Contracts.ApiError) {
	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT COUNT(*) FROM `Zones`")

	if err != nil {
		return 0, Contracts.DatabaseQueryError(err.Error())
	}

	var count = 0
	err = stmt.QueryRow().Scan(&count)

	if err != nil {
		return 0, Contracts.DatabaseQueryError(err.Error())
	}

	return count, nil
}

func PageZones(page int, limit int, url string) (*Contracts.ZonePageResponse, *Contracts.ApiError) {
	linksFormat := "%s?page=%d&limit=%d"
	count, apiError := getZoneCount()
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
	stmt, err := db.Prepare("SELECT * FROM `Zones` LIMIT ?, ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	rows, err := stmt.Query(offset, limit)

	if err != nil {
		if count == 0 {
			return nil, Contracts.NotFoundError("No Zones Were Found")
		}
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	zones := []Contracts.ZoneRetrieveResponse{}

	for rows.Next() {
		var id string
		var lat float32
		var long float32
		var title string

		err = rows.Scan(&id, &lat, &long, &title)

		if err != nil {
			return nil, Contracts.DatabaseQueryError(err.Error())
		}

		zones = append(zones, Contracts.ZoneRetrieveResponse{Id: id, Latitude: lat, Longitude: long, Title: title})
	}

	response := &Contracts.ZonePageResponse{
		PageLinks: pageLinks,
		TotalCount: count,
		Zones: zones,
	}

	return response, nil
}

func getSubZoneCount(id string) (int, *Contracts.ApiError) {
	db := Database.GetDb()
	stmt, err := db.Prepare("SELECT COUNT(*) FROM `SubZones` WHERE `zoneId` = ?")

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

func PageZoneSubZones(id string, page int, limit int, url string) (*Contracts.ZoneSubZonePageResponse, *Contracts.ApiError) {
	linksFormat := "%s?page=%d&limit=%d"
	count, apiError := getSubZoneCount(id)
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
	stmt, err := db.Prepare("SELECT `id`, `zoneId`, `title`, `description` FROM `SubZones` WHERE `zoneId` = ? LIMIT ?, ?")

	if err != nil {
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	rows, err := stmt.Query(id, offset, limit)

	if err != nil {
		if count == 0 {
			return nil, Contracts.NotFoundError("No SubZones Were Found")
		}
		return nil, Contracts.DatabaseQueryError(err.Error())
	}

	subZones := []Contracts.SubZoneRetrieveResponse{}

	for rows.Next() {
		subZone := Contracts.SubZoneRetrieveResponse{
			Id: "",
			ZoneId: "",
			Title: "",
			Description: "",
		}

		err = rows.Scan(&subZone.Id, &subZone.ZoneId, &subZone.Title, &subZone.Description)

		if err != nil {
			return nil, Contracts.DatabaseQueryError(err.Error())
		}

		subZones = append(subZones, subZone)
	}

	response := &Contracts.ZoneSubZonePageResponse{
		PageLinks: pageLinks,
		TotalCount: count,
		SubZones: subZones,
	}

	return response, nil
}