package unittest

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	interfaces "MSA-Project/internal/interfaces/http"
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"gorm.io/gorm"
)

type MockCartItemUsecase struct {
	mock.Mock
}

func (m *MockCartItemUsecase) CreateCartItem(cartItem *models.CartItem) error {
	args := m.Called(cartItem)
	return args.Error(0)
}

func (m *MockCartItemUsecase) GetCartItem(cartID, productID uint) (*models.CartItem, error) {
	args := m.Called(cartID, productID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*models.CartItem), args.Error(1)
}

func (m *MockCartItemUsecase) UpdateCartItem(cartItem *models.CartItem) error {
	args := m.Called(cartItem)
	return args.Error(0)
}

func (m *MockCartItemUsecase) UpdateCartItemsStatus(cartItemIDs []uint, status string) error {
	args := m.Called(cartItemIDs, status)
	return args.Error(0)
}

func (m *MockCartItemUsecase) DeleteCartItem(cartItem *models.CartItem) error {
	args := m.Called(cartItem)
	return args.Error(0)
}

func (m *MockCartItemUsecase) ClearCart(cartID uint) error {
	args := m.Called(cartID)
	return args.Error(0)
}

func (m *MockCartItemUsecase) GetCartItemByID(id uint) (*models.CartItem, error) {
	args := m.Called(id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*models.CartItem), args.Error(1)
}

func (m *MockCartItemUsecase) GetCartItemsByCartID(cartID uint) ([]models.CartItem, error) {
	args := m.Called(cartID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]models.CartItem), args.Error(1)
}

func (m *MockCartItemUsecase) GetAllCartItemsByCartID(cartID uint) ([]models.CartItem, error) {
	args := m.Called(cartID)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).([]models.CartItem), args.Error(1)
}

func (m *MockCartItemUsecase) AddProductToCart(cartID, productID uint, quantity int) (*models.CartItem, error) {
	args := m.Called(cartID, productID, quantity)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*models.CartItem), args.Error(1)
}

func (m *MockCartItemUsecase) CalculateCartTotal(cartID uint) (float64, error) {
	args := m.Called(cartID)
	return args.Get(0).(float64), args.Error(1)
}

func TestCartItemHandler(t *testing.T) {
	mockUsecase := new(MockCartItemUsecase)
	handler := interfaces.NewCartItemHandler(mockUsecase)
	r := setupRouter()

	t.Run("AddProductToCart", func(t *testing.T) {
		r.POST("/cart/:cartID/items", handler.AddProductToCart)

		reqBody := requests.CartItem{ProductID: 1, Quantity: 2}
		cartItem := &models.CartItem{CartID: 1, ProductID: 1, Quantity: 2}

		mockUsecase.On("AddProductToCart", uint(1), uint(1), 2).Return(cartItem, nil)

		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPost, "/cart/1/items", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("UpdateCartItem", func(t *testing.T) {
		r.PUT("/cart/items/:id", handler.UpdateCartItem)

		cartItem := &models.CartItem{Model: gorm.Model{ID: 1}, ProductID: 1, Quantity: 2, Price: 100}
		updatedItem := &models.CartItem{Model: gorm.Model{ID: 1}, ProductID: 1, Quantity: 3, Price: 120}

		mockUsecase.On("GetCartItemByID", uint(1)).Return(cartItem, nil)
		mockUsecase.On("UpdateCartItem", updatedItem).Return(nil)

		reqBody := requests.CartItem{ProductID: 1, Quantity: 3, Price: 120}
		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPut, "/cart/items/1", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})
}

func TestCartItemHandler_ErrorCases(t *testing.T) {
	mockUsecase := new(MockCartItemUsecase)
	handler := interfaces.NewCartItemHandler(mockUsecase)
	r := setupRouter()

	t.Run("AddProductToCart_Error", func(t *testing.T) {
		r.POST("/cart/:cartID/items", handler.AddProductToCart)

		reqBody := requests.CartItem{ProductID: 1, Quantity: 2}
		mockUsecase.On("AddProductToCart", uint(1), uint(1), 2).Return(nil, gorm.ErrInvalidData)

		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPost, "/cart/1/items", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("UpdateCartItem_Error", func(t *testing.T) {
		r.PUT("/cart/items/:id", handler.UpdateCartItem)

		mockUsecase.On("GetCartItemByID", uint(1)).Return(nil, gorm.ErrRecordNotFound)

		reqBody := requests.CartItem{ProductID: 1, Quantity: 3}
		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPut, "/cart/items/1", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code)
		mockUsecase.AssertExpectations(t)
	})
}
