package http

import (
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/cart"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type CartItemHandler interface {
	AddProductToCart(c *gin.Context)
	UpdateCartItem(c *gin.Context)
	UpdateCartItemsStatus(c *gin.Context)
	DeleteCartItem(c *gin.Context)
	ClearCart(c *gin.Context)
	GetCartItemByID(c *gin.Context)
	GetCartItemsByCartID(c *gin.Context)
	GetAllCartItemsByCartID(c *gin.Context)
}

type cartItemHandler struct {
	cartItemUsecase cart.CartItemUsecase
}

func NewCartItemHandler(ciu cart.CartItemUsecase) CartItemHandler {
	return &cartItemHandler{
		cartItemUsecase: ciu,
	}
}

func (h *cartItemHandler) AddProductToCart(c *gin.Context) {
	var req requests.CartItem
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	cartID, _ := strconv.ParseUint(c.Param("cartID"), 10, 32)
	cartItem, err := h.cartItemUsecase.AddProductToCart(uint(cartID), req.ProductID, req.Quantity)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cartItem)
}

func (h *cartItemHandler) UpdateCartItem(c *gin.Context) {
	var req requests.CartItem
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	cartItem, err := h.cartItemUsecase.GetCartItemByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	cartItem.Quantity = req.Quantity
	cartItem.Price = req.Price
	cartItem.Status = req.Status
	cartItem.ProductID = req.ProductID
	cartItem.CartID = req.CartID
	if err := h.cartItemUsecase.UpdateCartItem(cartItem); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cartItem)
}

func (h *cartItemHandler) UpdateCartItemsStatus(c *gin.Context) {
	var req struct {
		CartItemIDs []uint `json:"cart_item_ids"`
		Status      string `json:"status"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request"})
		return
	}

	err := h.cartItemUsecase.UpdateCartItemsStatus(req.CartItemIDs, req.Status)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update cart items"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Cart items updated successfully"})
}

func (h *cartItemHandler) DeleteCartItem(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	cartItem, err := h.cartItemUsecase.GetCartItemByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	if err := h.cartItemUsecase.DeleteCartItem(cartItem); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Cart item deleted"})
}

func (h *cartItemHandler) ClearCart(c *gin.Context) {
	cartID, _ := strconv.ParseUint(c.Param("cartID"), 10, 32)
	if err := h.cartItemUsecase.ClearCart(uint(cartID)); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Cart cleared"})
}

func (h *cartItemHandler) GetCartItemByID(c *gin.Context) {
	id, _ := strconv.ParseUint(c.Param("id"), 10, 32)
	cartItem, err := h.cartItemUsecase.GetCartItemByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cartItem)
}

func (h *cartItemHandler) GetCartItemsByCartID(c *gin.Context) {
	cartID, _ := strconv.ParseUint(c.Param("cartID"), 10, 32)
	cartItems, err := h.cartItemUsecase.GetCartItemsByCartID(uint(cartID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cartItems)
}

func (h *cartItemHandler) GetAllCartItemsByCartID(c *gin.Context) {
	cartID, _ := strconv.ParseUint(c.Param("cartID"), 10, 32)
	cartItems, err := h.cartItemUsecase.GetAllCartItemsByCartID(uint(cartID))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, cartItems)
}
