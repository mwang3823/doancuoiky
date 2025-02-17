package product

import (
	"MSA-Project/internal/domain/models"
	"errors"

	"gorm.io/gorm"
)

type CategoryRepository interface {
	CreateCategory(category *models.Category) error
	DeleteCategory(category *models.Category) error
	UpdateCategory(category *models.Category) error

	GetCategoryByID(id uint) (*models.Category, error)
	GetAllCategories(page, pageSize int) ([]models.Category, error)
}

type categoryRepository struct {
	db *gorm.DB
}

func NewCategoryRepository(db *gorm.DB) CategoryRepository {
	return &categoryRepository{db}
}

func (r *categoryRepository) CreateCategory(category *models.Category) error {
	return r.db.Create(category).Error
}

func (r *categoryRepository) DeleteCategory(category *models.Category) error {
	var productCount int64
	if err := r.db.Model(&models.Product{}).Where("category_id = ?", category.ID).Count(&productCount).Error; err != nil {
		return err
	}
	if productCount > 0 {
		return errors.New("cannot delete category: category has associated products")
	}
	return r.db.Delete(category).Error
}

func (r *categoryRepository) UpdateCategory(category *models.Category) error {
	err := r.db.Model(&models.Category{}).Where("id = ?", category.ID).Updates(map[string]interface{}{
		"name":        category.Name,
		"description": category.Description,
		"parent_id":   category.ParentID,
	}).Error
	if err != nil {
		return err
	}
	return r.db.Save(category).Error
}

func (r *categoryRepository) GetCategoryByID(id uint) (*models.Category, error) {
	var category models.Category
	if err := r.db.First(&category, id).Error; err != nil {
		return nil, err
	}
	return &category, nil
}

func (r *categoryRepository) GetAllCategories(page, pageSize int) ([]models.Category, error) {
	var categories []models.Category
	err := r.db.Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&categories).Error
	return categories, err
}
