package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/order"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type OrderDetailHandler interface {
	CreateOrderDetail(c *gin.Context)
	UpdateOrderDetail(c *gin.Context)
	DeleteOrderDetail(c *gin.Context)

	GetOrderDetailByID(c *gin.Context)
}

type orderDetailHandler struct {
	orderDetailUsecase order.OrderDetailUsecase
}

func NewOrderDetailHandler(odu order.OrderDetailUsecase) OrderDetailHandler {
	return &orderDetailHandler{
		orderDetailUsecase: odu,
	}
}

func (h *orderDetailHandler) CreateOrderDetail(c *gin.Context) {
	var reqOrderDetail requests.OrderDetail
	if err := c.ShouldBindJSON(&reqOrderDetail); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	orderDetail := models.OrderDetail{
		Status:     reqOrderDetail.Status,
		Quantity:   reqOrderDetail.Quantity,
		UnitPrice:  reqOrderDetail.UnitPrice,
		TotalPrice: reqOrderDetail.TotalPrice,
		OrderID:    reqOrderDetail.OrderID,
		ProductID:  reqOrderDetail.ProductID,
	}

	if err := h.orderDetailUsecase.CreateOrderDetail(&orderDetail); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, reqOrderDetail)
}

func (h *orderDetailHandler) UpdateOrderDetail(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	orderDetail, err := h.orderDetailUsecase.GetOrderDetailByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqOrderDetail requests.OrderDetail
	if err := c.ShouldBindJSON(&reqOrderDetail); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	orderDetail.Quantity = reqOrderDetail.Quantity
	orderDetail.UnitPrice = reqOrderDetail.UnitPrice
	orderDetail.TotalPrice = reqOrderDetail.TotalPrice
	orderDetail.Status = reqOrderDetail.Status
	orderDetail.OrderID = reqOrderDetail.OrderID
	orderDetail.ProductID = reqOrderDetail.ProductID

	if err := h.orderDetailUsecase.UpdateOrderDetail(orderDetail); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orderDetail)
}

func (h *orderDetailHandler) DeleteOrderDetail(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	orderDetail := models.OrderDetail{}
	orderDetail.ID = uint(id)

	if err := h.orderDetailUsecase.DeleteOrderDetail(&orderDetail); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Order Detail deleted"})
}

func (h *orderDetailHandler) GetOrderDetailByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	orderDetail, err := h.orderDetailUsecase.GetOrderDetailByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, orderDetail)
}
