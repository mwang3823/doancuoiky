package http

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/usecases/product"
	"MSA-Project/internal/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type categoryHandler struct {
	categoryUsecase product.CategoryUsecase
}

type CategoryHandler interface {
	CreateCategory(c *gin.Context)
	UpdateCategory(c *gin.Context)
	DeleteCategory(c *gin.Context)

	GetCategoryByID(c *gin.Context)
	GetAllCategories(c *gin.Context)
}

func NewCategoryHandler(cu product.CategoryUsecase) CategoryHandler {
	return &categoryHandler{
		categoryUsecase: cu,
	}
}

func (h *categoryHandler) CreateCategory(c *gin.Context) {
	var reqCategory requests.Category
	if err := c.ShouldBindJSON(&reqCategory); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	category := models.Category{
		Name:        reqCategory.Name,
		Description: reqCategory.Description,
		ParentID:    &reqCategory.ID,
	}

	if err := h.categoryUsecase.CreateCategory(&category); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusCreated, category)
}

func (h *categoryHandler) UpdateCategory(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	category, err := h.categoryUsecase.GetCategoryByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	var reqCategory requests.Category
	if err := c.ShouldBindJSON(&reqCategory); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	category.Name = reqCategory.Name
	category.Description = reqCategory.Description
	category.ParentID = &reqCategory.ID

	if err := h.categoryUsecase.UpdateCategory(category); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, category)
}

func (h *categoryHandler) DeleteCategory(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	category := models.Category{}
	category.ID = uint(id)

	if err := h.categoryUsecase.DeleteCategory(&category); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "Category deleted"})
}

func (h *categoryHandler) GetCategoryByID(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid ID"})
		return
	}

	category, err := h.categoryUsecase.GetCategoryByID(uint(id))
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, category)
}

func (h *categoryHandler) GetAllCategories(c *gin.Context) {
	page, pageSize := utils.GetPageAndSize(c)
	categories, err := h.categoryUsecase.GetAllCategories(page, pageSize)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, categories)
}
