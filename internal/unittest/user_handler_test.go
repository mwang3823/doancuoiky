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

type MockEmailService struct {
	mock.Mock
}

func (m *MockEmailService) SendEmail(to string, subject string, body string) error {
	args := m.Called(to, subject, body)
	return args.Error(0)
}

func (m *MockEmailService) GenerateAndSendOTP(email string) (string, error) {
	args := m.Called(email)
	return args.String(0), args.Error(1)
}

func (m *MockEmailService) ValidateOTP(otp string) (string, error) {
	args := m.Called(otp)
	return args.String(0), args.Error(1)
}

func (m *MockEmailService) GenerateAndSendPassword(email string) (string, error) {
	args := m.Called(email)
	return args.String(0), args.Error(1)
}

func (m *MockEmailService) VerifyEmail(email string) (bool, error) {
	args := m.Called(email)
	return args.Bool(0), args.Error(1)
}

type MockUserUsecase struct {
	mock.Mock
}

func (m *MockUserUsecase) CreateUser(user *models.User) error {
	args := m.Called(user)
	return args.Error(0)
}

func (m *MockUserUsecase) RegisterUser(users *models.User) (string, error) {
	args := m.Called(users)
	return args.String(0), args.Error(1)
}

func (m *MockUserUsecase) Login(email string, password string) (string, error) {
	args := m.Called(email, password)
	return args.String(0), args.Error(1)
}

func (m *MockUserUsecase) VerifyOTP(otp string) (string, *models.User, error) {
	args := m.Called(otp)
	user := args.Get(1)
	if user != nil {
		return args.String(0), user.(*models.User), args.Error(2)
	}
	return args.String(0), nil, args.Error(2)
}

func (m *MockUserUsecase) GetNewPassword(email string) (string, error) {
	args := m.Called(email)
	return args.String(0), args.Error(1)
}

func (m *MockUserUsecase) LoginWithGoogle(accessToken string) (string, *models.User, error) {
	args := m.Called(accessToken)
	user := args.Get(1)
	if user != nil {
		return args.String(0), user.(*models.User), args.Error(2)
	}
	return args.String(0), nil, args.Error(2)
}

func (m *MockUserUsecase) DeleteUser(users *models.User) error {
	args := m.Called(users)
	return args.Error(0)
}

func (m *MockUserUsecase) UpdateUser(users *models.User, currentPassword string) error {
	args := m.Called(users, currentPassword)
	return args.Error(0)
}

func (m *MockUserUsecase) UpdateUserInf(users *models.User) error {
	args := m.Called(users)
	return args.Error(0)
}

func (m *MockUserUsecase) GetUserByID(id uint) (*models.User, error) {
	args := m.Called(id)
	user := args.Get(0)
	if user != nil {
		return user.(*models.User), args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *MockUserUsecase) GetUserByPhoneNumber(phoneNumber string) (*models.User, error) {
	args := m.Called(phoneNumber)
	user := args.Get(0)
	if user != nil {
		return user.(*models.User), args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *MockUserUsecase) GetUserByEmail(email string) (*models.User, error) {
	args := m.Called(email)
	user := args.Get(0)
	if user != nil {
		return user.(*models.User), args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *MockUserUsecase) GetUserByGoogleID(googleID string) (*models.User, error) {
	args := m.Called(googleID)
	user := args.Get(0)
	if user != nil {
		return user.(*models.User), args.Error(1)
	}
	return nil, args.Error(1)
}

func (m *MockUserUsecase) GenerateAndSetRandomPasswordByEmail(email string) (string, error) {
	args := m.Called(email)
	return args.String(0), args.Error(1)
}

func (m *MockUserUsecase) GetAllUsers(page, pageSize int) ([]models.User, error) {
	args := m.Called(page, pageSize)
	users := args.Get(0)
	if users != nil {
		return users.([]models.User), args.Error(1)
	}
	return nil, args.Error(1)
}

func TestUserHandler(t *testing.T) {
	mockUsecase := new(MockUserUsecase)
	mockEmailService := new(MockEmailService)
	handler := interfaces.NewUserHandler(mockUsecase, mockEmailService)
	r := setupRouter()

	t.Run("RegisterUser", func(t *testing.T) {
		r.POST("/users/register", handler.RegisterUser)

		reqBody := requests.User{
			FullName:    "John Doe",
			Email:       "john.doe@example.com",
			Password:    "password123",
			Role:        "user",
			PhoneNumber: "1234567890",
			Address:     "123 Main St",
		}

		user := models.User{
			FullName:    reqBody.FullName,
			Email:       reqBody.Email,
			Password:    reqBody.Password,
			Role:        reqBody.Role,
			PhoneNumber: reqBody.PhoneNumber,
			Address:     reqBody.Address,
		}

		mockUsecase.On("RegisterUser", &user).Return(reqBody.Email, nil)

		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPost, "/users/register", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusCreated, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("Login", func(t *testing.T) {
		r.POST("/users/login", handler.Login)

		reqBody := requests.User{
			Email:    "john.doe@example.com",
			Password: "password123",
		}

		mockUsecase.On("Login", reqBody.Email, reqBody.Password).Return("123456", nil)

		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPost, "/users/login", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusOK, resp.Code)
		mockUsecase.AssertExpectations(t)
	})
}

func TestUserHandler_ErrorCases(t *testing.T) {
	mockUsecase := new(MockUserUsecase)
	mockEmailService := new(MockEmailService)
	handler := interfaces.NewUserHandler(mockUsecase, mockEmailService)
	r := setupRouter()

	t.Run("RegisterUser_Error", func(t *testing.T) {
		r.POST("/users/register", handler.RegisterUser)

		reqBody := requests.User{
			Email: "invalid-email",
		}

		body, _ := json.Marshal(reqBody)
		mockUsecase.On("RegisterUser", mock.Anything).Return("", gorm.ErrInvalidData)

		req, _ := http.NewRequest(http.MethodPost, "/users/register", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusInternalServerError, resp.Code)
		mockUsecase.AssertExpectations(t)
	})

	t.Run("Login_Error", func(t *testing.T) {
		r.POST("/users/login", handler.Login)

		reqBody := requests.User{
			Email:    "john.doe@example.com",
			Password: "wrongpassword",
		}

		mockUsecase.On("Login", reqBody.Email, reqBody.Password).Return("", gorm.ErrRecordNotFound)

		body, _ := json.Marshal(reqBody)
		req, _ := http.NewRequest(http.MethodPost, "/users/login", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		resp := httptest.NewRecorder()

		r.ServeHTTP(resp, req)

		assert.Equal(t, http.StatusUnauthorized, resp.Code)
		mockUsecase.AssertExpectations(t)
	})
}
