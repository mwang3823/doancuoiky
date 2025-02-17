package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/cart"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type CartHandler interface {
	CreateCart(c *gin.Context)
	UpdateCart(c *gin.Context)
	DeleteCart(c *gin.Context)

	GetCartByID(c *gin.Context)
	GetOrCreateCartForUser(c *gin.Context)
}

type cartHandler struct {
	cartUsecase cart.CartUsecase
}

func NewCartHandler(cu cart.CartUsecase) CartHandler {
	return &cartHandler{
		cartUsecase: cu,
	}
}

func (h *cartHandler) CreateCart(c *gin.Context) {
	var req requests.Cart
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	cart := models.Cart{
		UserID: req.UserID,
		Status: req.Status,
	}

	if err := h.cartUsecase.CreateCart(&cart); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, cart)
}

func (h *cartHandler) UpdateCart(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	cart, err := h.cartUsecase.GetCartByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
 
	var req requests.Cart
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	cart.Status = req.Status
	cart.UserID = req.UserID

	if err := h.cartUsecase.UpdateCart(cart); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cart)
}

func (h *cartHandler) DeleteCart(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	cart := models.Cart{}
	cart.ID = uint(id)

	if err := h.cartUsecase.DeleteCart(&cart); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Cart deleted"})
}

func (h *cartHandler) GetCartByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	cart, err := h.cartUsecase.GetCartByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cart)
}

func (h *cartHandler) GetOrCreateCartForUser(c *gin.Context) {
	userIDStr := c.Param("user_id")
	userID, err := strconv.ParseUint(userIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid User ID"})
		return
	}

	cart, err := h.cartUsecase.GetOrCreateCartForUser(uint(userID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cart)
}
