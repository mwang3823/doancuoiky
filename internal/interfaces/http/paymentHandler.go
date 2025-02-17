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

type paymentHandler struct {
	paymentUsecase order.PaymentUsecase
}

type PaymentHandler interface {
	CreatePayment(c *gin.Context)
	UpdatePayment(c *gin.Context)
	DeletePayment(c *gin.Context)

	GetPaymentByID(c *gin.Context)
	GetAllPayments(c *gin.Context)
}

func NewPaymentHandler(pu order.PaymentUsecase) PaymentHandler {
	return &paymentHandler{
		paymentUsecase: pu,
	}
}

func (h *paymentHandler) CreatePayment(c *gin.Context) {
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
	var reqPayment requests.Payment
	if err := c.ShouldBindJSON(&reqPayment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	payment := models.Payment{
		PaymentMethod: reqPayment.PaymentMethod,
		Status:        reqPayment.Status,
		GrandTotal:    reqPayment.GrandTotal,
		UserID:        uint(userID),
		OrderID:       uint(orderID),
	}

	if err := h.paymentUsecase.CreatePayment(&payment); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, payment)
}

func (h *paymentHandler) UpdatePayment(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	payment, err := h.paymentUsecase.GetPaymentByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqPayment requests.Payment
	if err := c.ShouldBindJSON(&reqPayment); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	payment.PaymentMethod = reqPayment.PaymentMethod
	payment.Status = reqPayment.Status
	payment.GrandTotal = reqPayment.GrandTotal

	if err := h.paymentUsecase.UpdatePayment(payment); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, payment)
}

func (h *paymentHandler) DeletePayment(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	payment := models.Payment{}
	payment.ID = uint(id)

	if err := h.paymentUsecase.DeletePayment(&payment); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Payment deleted"})
}

func (h *paymentHandler) GetPaymentByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	payment, err := h.paymentUsecase.GetPaymentByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, payment)
}

func (h *paymentHandler) GetAllPayments(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	payments, err := h.paymentUsecase.GetAllPayments(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, payments)
}
