package product

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/product"
)

type ManufacturerUsecase interface {
	CreateManufacturer(manufacturer *models.Manufacturer) error
	UpdateManufacturer(manufacturer *models.Manufacturer) error
	DeleteManufacturer(manufacturer *models.Manufacturer) error

	GetManufacturerByID(id uint) (*models.Manufacturer, error)
	GetAllManufacturers(page, pageSize int) ([]models.Manufacturer, error)
}

type manufacturerUsecase struct {
	manufacturerRepo product.ManufacturerRepository
}

func NewManufacturerUsecase(manufacturerRepo product.ManufacturerRepository) ManufacturerUsecase {
	return &manufacturerUsecase{manufacturerRepo}
}

func (u *manufacturerUsecase) CreateManufacturer(manufacturer *models.Manufacturer) error {
	return u.manufacturerRepo.CreateManufacturer(manufacturer)
}

func (u *manufacturerUsecase) UpdateManufacturer(manufacturer *models.Manufacturer) error {
	return u.manufacturerRepo.UpdateManufacturer(manufacturer)
}

func (u *manufacturerUsecase) DeleteManufacturer(manufacturer *models.Manufacturer) error {
	return u.manufacturerRepo.DeleteManufacturer(manufacturer)
}

func (u *manufacturerUsecase) GetManufacturerByID(id uint) (*models.Manufacturer, error) {
	return u.manufacturerRepo.GetManufacturerByID(id)
}

func (u *manufacturerUsecase) GetAllManufacturers(page, pageSize int) ([]models.Manufacturer, error) {
	return u.manufacturerRepo.GetAllManufacturers(page, pageSize)
}
