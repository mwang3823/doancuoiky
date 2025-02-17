package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/order"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type OrderPromoCodeHandler interface {
	CreateOrderPromoCode(c *gin.Context)
	UpdateOrderPromoCode(c *gin.Context)
	DeleteOrderPromoCode(c *gin.Context)

	GetOrderPromoCodeByID(c *gin.Context)
}

type orderPromoCodeHandler struct {
	orderPromoCodeUsecase order.OrderPromoCodeUsecase
}

func NewOrderPromoCodeHandler(opcUsecase order.OrderPromoCodeUsecase) OrderPromoCodeHandler {
	return &orderPromoCodeHandler{
		orderPromoCodeUsecase: opcUsecase,
	}
}

func (h *orderPromoCodeHandler) CreateOrderPromoCode(c *gin.Context) {
	var reqOrderPromoCode requests.OrderPromoCode
	if err := c.ShouldBindJSON(&reqOrderPromoCode); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	orderPromoCode := models.OrderPromoCode{
		OrderID:     reqOrderPromoCode.OrderID,
		PromoCodeID: reqOrderPromoCode.PromoCodeID,
	}

	if err := h.orderPromoCodeUsecase.CreateOrderPromoCode(&orderPromoCode); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, orderPromoCode)
}

func (h *orderPromoCodeHandler) UpdateOrderPromoCode(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	orderPromoCode, err := h.orderPromoCodeUsecase.GetOrderPromoCodeByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqOrderPromoCode requests.OrderPromoCode
	if err := c.ShouldBindJSON(&reqOrderPromoCode); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	orderPromoCode.OrderID = reqOrderPromoCode.OrderID
	orderPromoCode.PromoCodeID = reqOrderPromoCode.PromoCodeID

	if err := h.orderPromoCodeUsecase.UpdateOrderPromoCode(orderPromoCode); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orderPromoCode)
}

func (h *orderPromoCodeHandler) DeleteOrderPromoCode(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	orderPromoCode := models.OrderPromoCode{}
	orderPromoCode.ID = uint(id)

	if err := h.orderPromoCodeUsecase.DeleteOrderPromoCode(&orderPromoCode); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Order Promo Code deleted"})
}

func (h *orderPromoCodeHandler) GetOrderPromoCodeByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	orderPromoCode, err := h.orderPromoCodeUsecase.GetOrderPromoCodeByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orderPromoCode)
}
