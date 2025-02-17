package product

import (
	"MSA-Project/internal/domain/models"
	"errors"

	"gorm.io/gorm"
)

type ManufacturerRepository interface {
	CreateManufacturer(manufacturer *models.Manufacturer) error
	DeleteManufacturer(manufacturer *models.Manufacturer) error
	UpdateManufacturer(manufacturer *models.Manufacturer) error

	GetManufacturerByID(id uint) (*models.Manufacturer, error)
	GetAllManufacturers(page, pageSize int) ([]models.Manufacturer, error)
}

type manufacturerRepository struct {
	db *gorm.DB
}

func NewManufacturerRepository(db *gorm.DB) ManufacturerRepository {
	return &manufacturerRepository{db}
}

func (r *manufacturerRepository) CreateManufacturer(manufacturer *models.Manufacturer) error {
	return r.db.Create(manufacturer).Error
}

func (r *manufacturerRepository) DeleteManufacturer(manufacturer *models.Manufacturer) error {
	var productCount int64
	if err := r.db.Model(&models.Product{}).Where("manufacturer_id = ?", manufacturer.ID).Count(&productCount).Error; err != nil {
		return err
	}
	if productCount > 0 {
		return errors.New("cannot delete manufacturer: manufacturer has associated products")
	}
	return r.db.Delete(manufacturer).Error
}

func (r *manufacturerRepository) UpdateManufacturer(manufacturer *models.Manufacturer) error {
	return r.db.Save(manufacturer).Error
}

func (r *manufacturerRepository) GetManufacturerByID(id uint) (*models.Manufacturer, error) {
	var manufacturer models.Manufacturer
	if err := r.db.First(&manufacturer, id).Error; err != nil {
		return nil, err
	}
	return &manufacturer, nil
}

func (r *manufacturerRepository) GetAllManufacturers(page, pageSize int) ([]models.Manufacturer, error) {
	var manufacturers []models.Manufacturer
	err := r.db.Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&manufacturers).Error
	return manufacturers, err
}
