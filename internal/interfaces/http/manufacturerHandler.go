package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/product"
	"MSA-Project/internal/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type manufacturerHandler struct {
	manufacturerUsecase product.ManufacturerUsecase
}

type ManufacturerHandler interface {
	CreateManufacturer(c *gin.Context)
	UpdateManufacturer(c *gin.Context)
	DeleteManufacturer(c *gin.Context)

	GetManufacturerByID(c *gin.Context)
	GetAllManufacturers(c *gin.Context)
}

func NewManufacturerHandler(mu product.ManufacturerUsecase) ManufacturerHandler {
	return &manufacturerHandler{
		manufacturerUsecase: mu,
	}
}

func (h *manufacturerHandler) CreateManufacturer(c *gin.Context) {
	var reqManufacturer requests.Manufacturer
	if err := c.ShouldBindJSON(&reqManufacturer); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	manufacturer := models.Manufacturer{
		Name:    reqManufacturer.Name,
		Address: reqManufacturer.Address,
		Contact: reqManufacturer.Contact,
	}

	if err := h.manufacturerUsecase.CreateManufacturer(&manufacturer); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, manufacturer)
}

func (h *manufacturerHandler) UpdateManufacturer(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	manufacturer, err := h.manufacturerUsecase.GetManufacturerByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqManufacturer requests.Manufacturer
	if err := c.ShouldBindJSON(&reqManufacturer); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	manufacturer.Name = reqManufacturer.Name
	manufacturer.Address = reqManufacturer.Address
	manufacturer.Contact = reqManufacturer.Contact

	if err := h.manufacturerUsecase.UpdateManufacturer(manufacturer); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, manufacturer)
}

func (h *manufacturerHandler) DeleteManufacturer(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	manufacturer := models.Manufacturer{}
	manufacturer.ID = uint(id)

	if err := h.manufacturerUsecase.DeleteManufacturer(&manufacturer); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Manufacturer deleted"})
}

func (h *manufacturerHandler) GetManufacturerByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	manufacturer, err := h.manufacturerUsecase.GetManufacturerByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, manufacturer)
}

func (h *manufacturerHandler) GetAllManufacturers(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	manufacturers, err := h.manufacturerUsecase.GetAllManufacturers(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, manufacturers)
}
