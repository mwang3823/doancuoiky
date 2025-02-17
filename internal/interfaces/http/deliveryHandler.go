package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/delivery"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type DeliveryHandler interface {
	CreateDelivery(c *gin.Context)
	UpdateDelivery(c *gin.Context)
	DeleteDelivery(c *gin.Context)
	GetDeliveryByID(c *gin.Context)
}

type deliveryHandler struct {
	deliveryUsecase delivery.DeliveryUsecase
}

func NewDeliveryHandler(du delivery.DeliveryUsecase) DeliveryHandler {
	return &deliveryHandler{
		deliveryUsecase: du,
	}
}

func (h *deliveryHandler) CreateDelivery(c *gin.Context) {
	userIDStr := c.Param("user_id")
	orderIDStr := c.Param("order_id")

	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid UserID"})
		return
	}

	orderID, err := strconv.ParseUint(orderIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid OrderID"})
		return
	}
	var reqDelivery requests.Delivery
	if err := c.ShouldBindJSON(&reqDelivery); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	delivery := models.Delivery{
		Status:  reqDelivery.Status,
		UserID:  uint(userID),
		OrderID: uint(orderID),
	}

	if err := h.deliveryUsecase.CreateDelivery(&delivery); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, delivery)
}

func (h *deliveryHandler) UpdateDelivery(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	delivery, err := h.deliveryUsecase.GetDeliveryByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqDelivery requests.Delivery
	if err := c.ShouldBindJSON(&reqDelivery); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	delivery.Status = reqDelivery.Status

	if err := h.deliveryUsecase.UpdateDelivery(delivery); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, delivery)
}

func (h *deliveryHandler) DeleteDelivery(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	delivery := models.Delivery{}
	delivery.ID = uint(id)

	if err := h.deliveryUsecase.DeleteDelivery(&delivery); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Delivery deleted"})
}

func (h *deliveryHandler) GetDeliveryByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	delivery, err := h.deliveryUsecase.GetDeliveryByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, delivery)
}
