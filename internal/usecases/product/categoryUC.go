package product

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/product"
)

type CategoryUsecase interface {
	CreateCategory(category *models.Category) error
	UpdateCategory(category *models.Category) error
	DeleteCategory(category *models.Category) error

	GetCategoryByID(id uint) (*models.Category, error)
	GetAllCategories(page, pageSize int) ([]models.Category, error)
}

type categoryUsecase struct {
	categoryRepo product.CategoryRepository
}

func NewCategoryUsecase(categoryRepo product.CategoryRepository) CategoryUsecase {
	return &categoryUsecase{categoryRepo}
}

func (u *categoryUsecase) CreateCategory(category *models.Category) error {
	return u.categoryRepo.CreateCategory(category)
}

func (u *categoryUsecase) UpdateCategory(category *models.Category) error {
	return u.categoryRepo.UpdateCategory(category)
}

func (u *categoryUsecase) DeleteCategory(category *models.Category) error {
	return u.categoryRepo.DeleteCategory(category)
}

func (u *categoryUsecase) GetCategoryByID(id uint) (*models.Category, error) {
	return u.categoryRepo.GetCategoryByID(id)
}

func (u *categoryUsecase) GetAllCategories(page, pageSize int) ([]models.Category, error) {
	return u.categoryRepo.GetAllCategories(page, pageSize)
}
