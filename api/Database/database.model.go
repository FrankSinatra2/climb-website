package Database

type UserModel struct {
	Id string
	Username string
	HashedPwd string
}

type ImageModel struct {
	Id string
	OriginalName string
	Ext string
	Path string
}