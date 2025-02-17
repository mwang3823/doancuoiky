package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	services "MSA-Project/internal/services"
	"MSA-Project/internal/usecases/user"
	"MSA-Project/internal/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type userHandler struct {
	userUsecase  user.UserUsecase
	emailService services.EmailService
}

type UserHandler interface {
	GetUserByPhoneNumber(c *gin.Context)
	GetUserById(c *gin.Context)
	GenerateAndSetRandomPassword(c *gin.Context)

	VerifyOTP(c *gin.Context)
	UpdateUserInf(c *gin.Context)
	UpdateUser(c *gin.Context)
	DeleteUser(c *gin.Context)
	GetNewPassword(c *gin.Context)
	LoginWithGoogle(c *gin.Context)
	Login(c *gin.Context)
	RegisterUser(c *gin.Context)
	GetAllUsers(c *gin.Context)
}

func NewUserHandler(uu user.UserUsecase, es services.EmailService) UserHandler {
	return &userHandler{
		userUsecase:  uu,
		emailService: es,
	}
}

func (h *userHandler) RegisterUser(c *gin.Context) {
	var reqUser requests.User
	if err := c.ShouldBindJSON(&reqUser); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	if err := reqUser.Validate(); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user := models.User{
		FullName:    reqUser.FullName,
		Email:       reqUser.Email,
		Password:    reqUser.Password,
		Role:        reqUser.Role,
		PhoneNumber: reqUser.PhoneNumber,
		Birthday:    reqUser.Birthday,
		Address:     reqUser.Address,
	}

	email, err := h.userUsecase.RegisterUser(&user)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"email": email})
}

func (h *userHandler) Login(c *gin.Context) {
	var request requests.User

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	_, err := h.userUsecase.Login(request.Email, request.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "OTP sent to your email"})
}

func (h *userHandler) VerifyOTP(c *gin.Context) {
	var rq struct {
		Otp string `json:"otp"`
	}

	if err := c.ShouldBindJSON(&rq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid OTP"})
		return
	}

	token, user, err := h.userUsecase.VerifyOTP(rq.Otp)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": token, "user": user})
}

func (h *userHandler) GetNewPassword(c *gin.Context) {
	var request requests.User

	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	_, err := h.userUsecase.GetNewPassword(request.Email)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "OTP sent to your email"})
}

func (h *userHandler) LoginWithGoogle(c *gin.Context) {
	var req struct {
		AccessToken string `json:"access_token" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Access token is required"})
		return
	}

	tokenStr, user, err := h.userUsecase.LoginWithGoogle(req.AccessToken)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"token": tokenStr, "user": user})
}

func (h *userHandler) DeleteUser(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	user := models.User{}
	user.ID = uint(id)

	if err := h.userUsecase.DeleteUser(&user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "User deleted"})
}

func (h *userHandler) UpdateUser(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	user, err := h.userUsecase.GetUserByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var rq struct {
		CurrentPassword string `json:"currentpassword"`
		Password        string `json:"password"`
	}

	if err := c.ShouldBindJSON(&rq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	user.Password = rq.Password

	if err := h.userUsecase.UpdateUser(user, rq.CurrentPassword); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (h *userHandler) UpdateUserInf(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	user, err := h.userUsecase.GetUserByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var rq requests.User

	if err := c.ShouldBindJSON(&rq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	user.FullName = rq.FullName
	user.PhoneNumber = rq.PhoneNumber
	user.Email = rq.Email
	user.Password = rq.Password

	if err := h.userUsecase.UpdateUserInf(user); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"message": "User information updated successfully",
	})
}

func (h *userHandler) GenerateAndSetRandomPassword(c *gin.Context) {
	var rq requests.User

	if err := c.ShouldBindJSON(&rq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	message, err := h.userUsecase.GenerateAndSetRandomPasswordByEmail(rq.Email)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": message})
}

func (h *userHandler) GetUserById(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	user, err := h.userUsecase.GetUserByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (h *userHandler) GetUserByPhoneNumber(c *gin.Context) {
	phoneNumber := c.Param("phone")

	user, err := h.userUsecase.GetUserByPhoneNumber(phoneNumber)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (h *userHandler) GetAllUsers(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	users, err := h.userUsecase.GetAllUsers(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, users)
}
