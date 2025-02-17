package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/usecases/order"
	"MSA-Project/internal/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type OrderHandler interface {
	CreateOrder(c *gin.Context)
	PreviewOrder(c *gin.Context)
	UpdateOrder(c *gin.Context)
	DeleteOrder(c *gin.Context)

	GetOrderByID(c *gin.Context)
	GetAllOrders(c *gin.Context)
	GetOrdersByStatus(c *gin.Context)
	SearchOrderByPhoneNumber(c *gin.Context)
}

type orderHandler struct {
	orderUsecase order.OrderUsecase
}

func NewOrderHandler(ou order.OrderUsecase) OrderHandler {
	return &orderHandler{
		orderUsecase: ou,
	}
}

func (h *orderHandler) CreateOrder(c *gin.Context) {
	userIDStr := c.Query("user_id")
	cartIDStr := c.Query("cart_id")
	promoCode := c.Query("promo_code")

	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user_id"})
		return
	}

	cartID, err := strconv.ParseUint(cartIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid cart_id"})
		return
	}

	order, err := h.orderUsecase.CreateOrder(uint(userID), uint(cartID), promoCode)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, order)
}

func (h *orderHandler) PreviewOrder(c *gin.Context) {
	userIDStr := c.Query("user_id")
	cartIDStr := c.Query("cart_id")
	promoCode := c.Query("promo_code")

	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user_id"})
		return
	}

	cartID, err := strconv.ParseUint(cartIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid cart_id"})
		return
	}

	totalCost, discount, grandTotal, err := h.orderUsecase.CalculateOrderSummary(uint(userID), uint(cartID), promoCode)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"total_cost":  totalCost,
		"discount":    discount,
		"grand_total": grandTotal,
	})
}

func (h *orderHandler) UpdateOrder(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	order, err := h.orderUsecase.GetOrderByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqOrder models.Order
	if err := c.ShouldBindJSON(&reqOrder); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	order.GrandTotal = reqOrder.GrandTotal
	order.Status = reqOrder.Status
	order.CartID = reqOrder.CartID
	order.UserID = reqOrder.UserID

	if err := h.orderUsecase.UpdateOrder(order); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, order)
}

func (h *orderHandler) DeleteOrder(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	order := models.Order{}
	order.ID = uint(id)

	if err := h.orderUsecase.DeleteOrder(&order); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Order deleted"})
}

func (h *orderHandler) GetOrderByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	order, err := h.orderUsecase.GetOrderByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, order)
}

func (h *orderHandler) GetAllOrders(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	orders, err := h.orderUsecase.GetAllOrders(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orders)
}

func (h *orderHandler) SearchOrderByPhoneNumber(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	phoneNumber := c.Query("phone_number")
	if phoneNumber == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Phone number is required"})
		return
	}

	orders, err := h.orderUsecase.SearchOrderByPhoneNumber(phoneNumber, page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orders)
}

func (h *orderHandler) GetOrdersByStatus(c *gin.Context) {
	idStr := c.Param("user_id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid user_id"})
		return
	}

	page, err := strconv.Atoi(c.DefaultQuery("page", "1"))
	if err != nil || page < 1 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid page parameter"})
		return
	}

	size, err := strconv.Atoi(c.DefaultQuery("size", "10"))
	if err != nil || size < 1 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid size parameter"})
		return
	}

	status := c.Param("status") // Lấy trạng thái từ URL
	if status != "delivering" && status != "paying" && status != "success" && status != "returned" && status != "pending" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid status parameter"})
		return
	}

	// Lấy danh sách đơn hàng
	orders, err := h.orderUsecase.GetOrdersByUserIDWithStatus(uint(id), status, page, size)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orders)
}
