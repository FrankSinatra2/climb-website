package Contracts

type SubZoneCreateRequest struct {
	ZoneId string `json:"zone_id"`
	Title string `json:"title"`
	Description string `json:"description"`
}

type SubZoneCreateResponse struct {
	Id string `json:"id"`
}

type SubZoneRetrieveRequest struct {
	Id string `json:"id"`
}

type SubZoneRetrieveResponse struct {
	Id string `json:"id"`
	ZoneId string `json:"zone_id"`
	Title string `json:"title"`
	Description string `json:"description"`
}

type SubZoneSlideshowPageResponse struct {
	PageLinks `json:"links"`
	TotalCount int `json:"total_count"`
	ImageIds []string `json:"records"`
}

type SlideshowAddResponse struct {
	ImageId string `json:"image_id"`
}




