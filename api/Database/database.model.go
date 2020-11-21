package Database

type UserModel struct {
	Id string
	Username string
	HashedPwd string
}

type ImageModel struct {
	Id string
	SubZoneId string
	OriginalName string
	Ext string
	Path string
}

type ZoneModel struct {
	Id string
	Latitude float32
	Longitude float32
	Title string
}

type SubZoneModel struct {
	Id string
	ZoneId string
	Title string
	Description string
}

type SubZoneImagesModel struct {
	SubZoneImageId string
	ImageId string
}