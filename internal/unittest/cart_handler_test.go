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

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
	"gorm.io/gorm"
)

type MockCartUsecase struct {
	mock.Mock
}

func (m *MockCartUsecase) CreateCart(cart *models.Cart) error {
	args := m.Called(cart)
	return args.Error(0)
}

func (m *MockCartUsecase) UpdateCart(cart *models.Cart) error {
	args := m.Called(cart)
	return args.Error(0)
}

func (m *MockCartUsecase) DeleteCart(cart *models.Cart) error {
	args := m.Called(cart)
	return args.Error(0)
}

func (m *MockCartUsecase) GetCartByID(id uint) (*models.Cart, error) {
	args := m.Called(id)
	if args.Get(0) == nil {
		return nil, args.Error(1) // Trả về nil thay vì panic
	}
	return args.Get(0).(*models.Cart), args.Error(1)
}

func (m *MockCartUsecase) GetOrCreateCartForUser(userID uint) (*models.Cart, error) {
	args := m.Called(userID)
	if args.Get(0) == nil {
		return nil, args.Error(1) // Return nil without attempting a type assertion
	}
	return args.Get(0).(*models.Cart), args.Error(1)
}

func setupRouter() *gin.Engine {
	return gin.Default()
}

func TestCartHandler(t *testing.T) {
	mockUsecase := new(MockCartUsecase)
	handler := interfaces.NewCartHandler(mockUsecase)
	r := setupRouter()

	t.Run("CreateCart", func(t *testing.T) {
		r.POST("/carts", handler.CreateCart)

		reqBody := requests.Cart{UserID: 1, Status: "active"}
		cart := models.Cart{UserID: 1, Status: "active"}

		mockUsecase.On("CreateCart", &cart).Return(nil)

		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPost, "/carts", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusCreated, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("UpdateCart", func(t *testing.T) {
		r.PUT("/carts/:id", handler.UpdateCart)

		cart := &models.Cart{Model: gorm.Model{ID: 1}, UserID: 1, Status: "active"}
		updatedCart := &models.Cart{Model: gorm.Model{ID: 1}, UserID: 1, Status: "updated"}

		mockUsecase.On("GetCartByID", uint(1)).Return(cart, nil)
		mockUsecase.On("UpdateCart", updatedCart).Return(nil)

		reqBody := requests.Cart{UserID: 1, Status: "updated"}
		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPut, "/carts/1", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("DeleteCart", func(t *testing.T) {
		r.DELETE("/carts/:id", handler.DeleteCart)

		cart := &models.Cart{Model: gorm.Model{ID: 1}}
		mockUsecase.On("DeleteCart", cart).Return(nil)

		req, _ := http.NewRequest(http.MethodDelete, "/carts/1", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("GetCartByID", func(t *testing.T) {
		r.GET("/carts/:id", handler.GetCartByID)

		cart := &models.Cart{Model: gorm.Model{ID: 1}, UserID: 1, Status: "active"}
		mockUsecase.On("GetCartByID", uint(1)).Return(cart, nil)

		req, _ := http.NewRequest(http.MethodGet, "/carts/1", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("GetOrCreateCartForUser", func(t *testing.T) {
		r.GET("/carts/user/:user_id", handler.GetOrCreateCartForUser)

		cart := &models.Cart{Model: gorm.Model{ID: 1}, UserID: 1, Status: "active"}
		mockUsecase.On("GetOrCreateCartForUser", uint(1)).Return(cart, nil)

		req, _ := http.NewRequest(http.MethodGet, "/carts/user/1", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})
}

func TestCartHandler_ErrorCases(t *testing.T) {
	mockUsecase := new(MockCartUsecase)
	handler := interfaces.NewCartHandler(mockUsecase)
	r := setupRouter()

	t.Run("CreateCart_Error", func(t *testing.T) {
		r.POST("/carts", handler.CreateCart)

		reqBody := requests.Cart{UserID: 0, Status: "active"} // UserID không hợp lệ
		body, _ := json.Marshal(reqBody)

		mockUsecase.On("CreateCart", mock.Anything).Return(gorm.ErrInvalidData)

		req, _ := http.NewRequest(http.MethodPost, "/carts", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code) // Kiểm tra mã lỗi trả về
		mockUsecase.AssertExpectations(t)
	})

	t.Run("UpdateCart_Error", func(t *testing.T) {
		r.PUT("/carts/:id", handler.UpdateCart)

		mockUsecase.On("GetCartByID", uint(1)).Return(nil, gorm.ErrRecordNotFound) // Không tìm thấy Cart

		reqBody := requests.Cart{UserID: 1, Status: "updated"}
		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPut, "/carts/1", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code) // Trả về lỗi 404
		mockUsecase.AssertExpectations(t)
	})

	t.Run("DeleteCart_Error", func(t *testing.T) {
		r.DELETE("/carts/:id", handler.DeleteCart)

		mockUsecase.On("DeleteCart", mock.Anything).Return(gorm.ErrRecordNotFound) // Không tìm thấy Cart

		req, _ := http.NewRequest(http.MethodDelete, "/carts/1", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("GetCartByID_Error", func(t *testing.T) {
		r.GET("/carts/:id", handler.GetCartByID)

		mockUsecase.On("GetCartByID", uint(99)).Return(nil, gorm.ErrRecordNotFound) // Không tìm thấy Cart

		req, _ := http.NewRequest(http.MethodGet, "/carts/99", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code) // Trả về lỗi 404
		mockUsecase.AssertExpectations(t)
	})

	t.Run("GetOrCreateCartForUser_Error", func(t *testing.T) {
		r.GET("/carts/user/:user_id", handler.GetOrCreateCartForUser)

		mockUsecase.On("GetOrCreateCartForUser", uint(99)).Return(nil, gorm.ErrRecordNotFound)

		req, _ := http.NewRequest(http.MethodGet, "/carts/user/99", nil)
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

}
