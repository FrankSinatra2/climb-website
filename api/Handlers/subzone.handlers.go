package Handlers

import (
	"api/Services"
	"api/Contracts"
	"github.com/gin-gonic/gin"
	"strconv"
)

func HandleCreateSubZone(ctx *gin.Context) {
	var body Contracts.SubZoneCreateRequest
	err := ctx.ShouldBindJSON(&body)
	
	if err != nil {
		res := Contracts.BadRequestError()
		ctx.JSON(res.StatusCode, res)
		return
	}

	res, apiError := Services.CreateSubZone(&body)

	if apiError != nil {
		ctx.JSON(apiError.StatusCode, apiError)
	} else {
		ctx.JSON(200, res)
	}
}

func HandleRetrieveSubZone(ctx *gin.Context) {
	res, apiError := Services.RetrieveSubZoneById(ctx.Param("id"))
	if apiError != nil {
		ctx.JSON(apiError.StatusCode, apiError)
	} else {
		ctx.JSON(200, res)
	}
}

func HandlePatchSubZone(ctx *gin.Context) {
	res := Contracts.NotImplementedError()
	ctx.JSON(res.StatusCode, res)
}

func HandlePageSubZoneSlideshow(ctx *gin.Context) {
	url := Services.CreateFullUrl(ctx.Request.Proto, ctx.Request.Host, ctx.Request.URL.Path)
	page, _ := strconv.Atoi(ctx.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(ctx.DefaultQuery("limit", "10"))

	res, err := Services.PageSubZoneSlideshow(ctx.Param("id"), page, limit, url)

	if err != nil {
		ctx.JSON(err.StatusCode, err)
	} else {
		ctx.JSON(200, res)
	}
}

func HandleAddToSubZoneSlideshow(ctx *gin.Context) {
	id := ctx.Param("id")
	file, err := ctx.FormFile("image")

	if err != nil {
		apiError := Contracts.BadRequestError()
		ctx.JSON(apiError.StatusCode, apiError)
		return
	}

	res, apiError := Services.AddToSubZoneSlideshow(id, file, ctx)

	if apiError != nil {
		ctx.JSON(apiError.StatusCode, apiError)
	} else {
		ctx.JSON(200, res)
	}
}
