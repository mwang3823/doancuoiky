package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/order"
	"MSA-Project/internal/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type ReturnOrderHandler interface {
	CreateReturnOrder(c *gin.Context)
	UpdateReturnOrder(c *gin.Context)
	DeleteReturnOrder(c *gin.Context)

	GetReturnOrderByID(c *gin.Context)
	GetAllReturnOrders(c *gin.Context)
}

type returnOrderHandler struct {
	returnOrderUsecase order.ReturnOrderUsecase
}

func NewReturnOrderHandler(rou order.ReturnOrderUsecase) ReturnOrderHandler {
	return &returnOrderHandler{
		returnOrderUsecase: rou,
	}
}

func (h *returnOrderHandler) CreateReturnOrder(c *gin.Context) {
	orderIDStr := c.Param("order_id")
	orderID, err := strconv.ParseUint(orderIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid OrderID"})
		return
	}
	var returnOrder requests.ReturnOrder
	if err := c.ShouldBindJSON(&returnOrder); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	rOrder := models.ReturnOrder{
		Status:       returnOrder.Status,
		Reason:       returnOrder.Reason,
		RefundAmount: returnOrder.RefundAmount,
		OrderID:      uint(orderID),
	}

	if err := h.returnOrderUsecase.CreateReturnOrder(&rOrder); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, rOrder)
}

func (h *returnOrderHandler) UpdateReturnOrder(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	existingReturnOrder, err := h.returnOrderUsecase.GetReturnOrderByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqReturnOrder requests.ReturnOrder
	if err := c.ShouldBindJSON(&reqReturnOrder); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	existingReturnOrder.Status = reqReturnOrder.Status
	existingReturnOrder.Reason = reqReturnOrder.Reason
	existingReturnOrder.RefundAmount = reqReturnOrder.RefundAmount
	existingReturnOrder.OrderID = reqReturnOrder.OrderID

	if err := h.returnOrderUsecase.UpdateReturnOrder(existingReturnOrder); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, existingReturnOrder)
}

func (h *returnOrderHandler) DeleteReturnOrder(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	returnOrder := &models.ReturnOrder{}
	returnOrder.ID = uint(id)

	if err := h.returnOrderUsecase.DeleteReturnOrder(returnOrder); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Return order deleted"})
}

func (h *returnOrderHandler) GetReturnOrderByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	returnOrder, err := h.returnOrderUsecase.GetReturnOrderByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, returnOrder)
}

func (h *returnOrderHandler) GetAllReturnOrders(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	returnOrders, err := h.returnOrderUsecase.GetAllReturnOrders(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, returnOrders)
}
