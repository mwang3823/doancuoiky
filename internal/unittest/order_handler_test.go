package unittest

import (
	"MSA-Project/internal/domain/models"
	interfaces "MSA-Project/internal/interfaces/http"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"gorm.io/gorm"
)

type MockOrderUsecase struct {
	mock.Mock
}

// CreateOrder
func (m *MockOrderUsecase) CreateOrder(userID uint, cartID uint, promoCode string) (*models.Order, error) {
	args := m.Called(userID, cartID, promoCode)
	order := args.Get(0)
	if order != nil {
		return order.(*models.Order), args.Error(1)
	}
	return nil, args.Error(1)
}

// CalculateOrderSummary
func (m *MockOrderUsecase) CalculateOrderSummary(userID uint, cartID uint, promoCode string) (float64, float64, float64, error) {
	args := m.Called(userID, cartID, promoCode)
	return args.Get(0).(float64), args.Get(1).(float64), args.Get(2).(float64), args.Error(3)
}

// UpdateOrder
func (m *MockOrderUsecase) UpdateOrder(order *models.Order) error {
	args := m.Called(order)
	return args.Error(0)
}

// DeleteOrder
func (m *MockOrderUsecase) DeleteOrder(order *models.Order) error {
	args := m.Called(order)
	return args.Error(0)
}

// GetOrderByID
func (m *MockOrderUsecase) GetOrderByID(id uint) (*models.Order, error) {
	args := m.Called(id)
	order := args.Get(0)
	if order != nil {
		return order.(*models.Order), args.Error(1)
	}
	return nil, args.Error(1)
}

// SearchOrderByPhoneNumber
func (m *MockOrderUsecase) SearchOrderByPhoneNumber(phoneNumber string, page, pageSize int) ([]models.Order, error) {
	args := m.Called(phoneNumber, page, pageSize)
	orders := args.Get(0)
	if orders != nil {
		return orders.([]models.Order), args.Error(1)
	}
	return nil, args.Error(1)
}

// GetAllOrders
func (m *MockOrderUsecase) GetAllOrders(page, pageSize int) ([]models.Order, error) {
	args := m.Called(page, pageSize)
	orders := args.Get(0)
	if orders != nil {
		return orders.([]models.Order), args.Error(1)
	}
	return nil, args.Error(1)
}

// GetOrdersByUserIDWithStatus
func (m *MockOrderUsecase) GetOrdersByUserIDWithStatus(userID uint, status string, page int, size int) ([]*models.Order, error) {
	args := m.Called(userID, status, page, size)
	orders := args.Get(0)
	if orders != nil {
		return orders.([]*models.Order), args.Error(1)
	}
	return nil, args.Error(1)
}

func TestCreateOrder(t *testing.T) {
	// Khởi tạo MockOrderUsecase
	mockUsecase := new(MockOrderUsecase)
	handler := interfaces.NewOrderHandler(mockUsecase) // Giả sử bạn có hàm NewOrderHandler
	r := setupRouter()

	r.POST("/orders", handler.CreateOrder)

	t.Run("CreateOrder_Success", func(t *testing.T) {
		// Dữ liệu đầu vào
		userID := uint(1)
		cartID := uint(2)
		promoCode := "DISCOUNT10"
		order := &models.Order{
			Model:  gorm.Model{ID: 1},
			UserID: userID,
			CartID: cartID,
			Status: "Created",
		}

		// Mock hàm CreateOrder trả về order và nil error
		mockUsecase.On("CreateOrder", userID, cartID, promoCode).Return(order, nil)

		req, _ := http.NewRequest(http.MethodPost, "/orders?user_id=1&cart_id=2&promo_code=DISCOUNT10", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusCreated, resp.Code)
		var returnedOrder models.Order
		json.Unmarshal(resp.Body.Bytes(), &returnedOrder)
		assert.Equal(t, order, &returnedOrder)

		mockUsecase.AssertExpectations(t)
	})

	t.Run("CreateOrder_InvalidUserID", func(t *testing.T) {
		req, _ := http.NewRequest(http.MethodPost, "/orders?user_id=abc&cart_id=2&promo_code=DISCOUNT10", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusBadRequest, resp.Code)
		assert.Contains(t, resp.Body.String(), "Invalid user_id")
	})

	t.Run("CreateOrder_InvalidCartID", func(t *testing.T) {
		req, _ := http.NewRequest(http.MethodPost, "/orders?user_id=1&cart_id=abc&promo_code=DISCOUNT10", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusBadRequest, resp.Code)
		assert.Contains(t, resp.Body.String(), "Invalid cart_id")
	})
}
