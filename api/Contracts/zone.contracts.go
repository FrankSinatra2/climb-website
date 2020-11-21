package Contracts

type ZoneCreateRequest struct {
	Latitude float32 `json:"latitude"`
	Longitude float32 `json:"longitude"`
	Title string `json:"title"`
}

type ZoneCreateResponse struct {
	Id string `json:"id"`
}

type ZoneRetrieveResponse struct {
	Id string `json:"id"`
	Latitude float32 `json:"latitude"`
	Longitude float32 `json:"longitude"`
	Title string `json:"title"`
}

type ZoneSubZonePageResponse struct {
	PageLinks `json:"links"`
	TotalCount int `json:"total_count"`
	SubZones []SubZoneRetrieveResponse `json:"records"`
}