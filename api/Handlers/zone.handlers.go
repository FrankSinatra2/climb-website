package Handlers

import (
	"api/Contracts"
	"api/Services"
	"github.com/gin-gonic/gin"
	"strconv"
)

func HandleCreateZone(ctx *gin.Context) {
	var body Contracts.ZoneCreateRequest
	err := ctx.ShouldBindJSON(&body)
	
	if err != nil {
		res := Contracts.BadRequestError()
		ctx.JSON(res.StatusCode, res)
		return
	}

	res, apiError := Services.CreateZone(body.Latitude, body.Longitude, body.Title)

	if apiError != nil {
		ctx.JSON(apiError.StatusCode, apiError)
	} else {
		ctx.JSON(200, res)
	}
}

func HandleRetrieveZone(ctx *gin.Context) {
	res, apiError := Services.RetrieveZoneById(ctx.Param("id"))
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, apiError)
	} else {
		ctx.JSON(200, res)
	}
}

func HandlePatchZone(ctx *gin.Context) {
	res := Contracts.NotImplementedError()
	ctx.JSON(res.StatusCode, res)
}

func HandlePageZoneSubZones(ctx *gin.Context) {
	url := Services.CreateFullUrl(ctx.Request.Proto, ctx.Request.Host, ctx.Request.URL.Path)
	page, _ := strconv.Atoi(ctx.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(ctx.DefaultQuery("limit", "10"))

	res, err := Services.PageZoneSubZones(ctx.Param("id"), page, limit, url)

	if err != nil {
		ctx.JSON(err.StatusCode, err)
	} else {
		ctx.JSON(200, res)
	}
}