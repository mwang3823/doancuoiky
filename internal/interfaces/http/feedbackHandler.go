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

type feedbackHandler struct {
	feedbackUsecase order.FeedbackUsecase
}

type FeedbackHandler interface {
	CreateFeedback(c *gin.Context)
	UpdateFeedback(c *gin.Context)
	DeleteFeedback(c *gin.Context)

	GetFeedbackByID(c *gin.Context)
	GetAllFeedbacksByProductID(c *gin.Context)
}

func NewFeedbackHandler(fu order.FeedbackUsecase) FeedbackHandler {
	return &feedbackHandler{
		feedbackUsecase: fu,
	}
}

func (h *feedbackHandler) CreateFeedback(c *gin.Context) {
	var reqFeedback requests.Feedback
	if err := c.ShouldBindJSON(&reqFeedback); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	feedback := models.Feedback{
		Rating:    reqFeedback.Rating,
		Comments:  reqFeedback.Comments,
		UserID:    reqFeedback.UserID,
		ProductID: reqFeedback.ProductID,
	}

	if err := h.feedbackUsecase.CreateFeedback(&feedback); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, feedback)
}

func (h *feedbackHandler) UpdateFeedback(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	feedback, err := h.feedbackUsecase.GetFeedbackByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqFeedback requests.Feedback
	if err := c.ShouldBindJSON(&reqFeedback); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	feedback.Rating = reqFeedback.Rating
	feedback.Comments = reqFeedback.Comments
	feedback.UserID = reqFeedback.UserID
	feedback.ProductID = reqFeedback.ProductID

	if err := h.feedbackUsecase.UpdateFeedback(feedback); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feedback)
}

func (h *feedbackHandler) DeleteFeedback(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	feedback := models.Feedback{}
	feedback.ID = uint(id)

	if err := h.feedbackUsecase.DeleteFeedback(&feedback); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Feedback deleted"})
}

func (h *feedbackHandler) GetFeedbackByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	feedback, err := h.feedbackUsecase.GetFeedbackByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feedback)
}

func (h *feedbackHandler) GetAllFeedbacksByProductID(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	productIDStr := c.Param("product_id")
	productID, err := strconv.ParseUint(productIDStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid Product ID"})
		return
	}

	feedbacks, err := h.feedbackUsecase.GetAllFeedbacksByProductID(uint(productID), page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, feedbacks)
}
