package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/delivery"
	"MSA-Project/internal/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type DeliveryDetailHandler interface {
	CreateDeliveryDetail(c *gin.Context)
	UpdateDeliveryDetail(c *gin.Context)
	DeleteDeliveryDetail(c *gin.Context)
	GetDeliveryDetailByID(c *gin.Context)
	GetAllDeliveryDetails(c *gin.Context)
	GetAllDeliveryDetailsByDeliveryID(c *gin.Context)
}

type deliveryDetailHandler struct {
	deliveryDetailUsecase delivery.DeliveryDetailUsecase
}

func NewDeliveryDetailHandler(dd delivery.DeliveryDetailUsecase) DeliveryDetailHandler {
	return &deliveryDetailHandler{
		deliveryDetailUsecase: dd,
	}
}

func (h *deliveryDetailHandler) CreateDeliveryDetail(c *gin.Context) {
	var reqDetail requests.DeliveryDetails
	if err := c.ShouldBindJSON(&reqDetail); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	detail := models.DeliveryDetails{
		DeliveryName:    reqDetail.DeliveryName,
		ShipCode:        reqDetail.ShipCode,
		Description:     reqDetail.Description,
		Weight:          reqDetail.Weight,
		DeliveryAddress: reqDetail.DeliveryAddress,
		DeliveryContact: reqDetail.DeliveryContact,
		DeliveryFee:     reqDetail.DeliveryFee,
		DeliveryID:      reqDetail.DeliveryID,
	}

	if err := h.deliveryDetailUsecase.CreateDeliveryDetail(&detail); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, detail)
}

func (h *deliveryDetailHandler) UpdateDeliveryDetail(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	detail, err := h.deliveryDetailUsecase.GetDeliveryDetailByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqDetail requests.DeliveryDetails
	if err := c.ShouldBindJSON(&reqDetail); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	detail.DeliveryName = reqDetail.DeliveryName
	detail.ShipCode = reqDetail.ShipCode
	detail.Description = reqDetail.Description
	detail.Weight = reqDetail.Weight
	detail.DeliveryAddress = reqDetail.DeliveryAddress
	detail.DeliveryContact = reqDetail.DeliveryContact
	detail.DeliveryFee = reqDetail.DeliveryFee

	if err := h.deliveryDetailUsecase.UpdateDeliveryDetail(detail); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, detail)
}

func (h *deliveryDetailHandler) DeleteDeliveryDetail(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	detail := models.DeliveryDetails{}
	detail.ID = uint(id)

	if err := h.deliveryDetailUsecase.DeleteDeliveryDetail(&detail); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Delivery detail deleted"})
}

func (h *deliveryDetailHandler) GetDeliveryDetailByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	detail, err := h.deliveryDetailUsecase.GetDeliveryDetailByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, detail)
}

func (h *deliveryDetailHandler) GetAllDeliveryDetails(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)

	details, err := h.deliveryDetailUsecase.GetAllDeliveryDetails(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, details)
}

func (h *deliveryDetailHandler) GetAllDeliveryDetailsByDeliveryID(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	idStr := c.Param("delivery_id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}
	details, err := h.deliveryDetailUsecase.GetAllDeliveryDetailsByDeliveryID(uint(id), page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, details)
}
