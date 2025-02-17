package delivery

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/delivery"
)

type DeliveryDetailUsecase interface {
	CreateDeliveryDetail(deliveryDetail *models.DeliveryDetails) error
	UpdateDeliveryDetail(deliveryDetail *models.DeliveryDetails) error
	DeleteDeliveryDetail(deliveryDetail *models.DeliveryDetails) error

	GetDeliveryDetailByID(id uint) (*models.DeliveryDetails, error)
	GetAllDeliveryDetails(page, pageSize int) ([]models.DeliveryDetails, error)
	GetAllDeliveryDetailsByDeliveryID(deliveryId uint, page, pageSize int) ([]models.DeliveryDetails, error)
}

type deliveryDetailUsecase struct {
	deliveryDetailRepo delivery.DeliveryDetailRepository
}

func NewDeliveryDetailUsecase(deliveryDetailRepo delivery.DeliveryDetailRepository) DeliveryDetailUsecase {
	return &deliveryDetailUsecase{deliveryDetailRepo}
}

func (u *deliveryDetailUsecase) CreateDeliveryDetail(deliveryDetail *models.DeliveryDetails) error {
	return u.deliveryDetailRepo.CreateDeliveryDetail(deliveryDetail)
}

func (u *deliveryDetailUsecase) UpdateDeliveryDetail(deliveryDetail *models.DeliveryDetails) error {
	return u.deliveryDetailRepo.UpdateDeliveryDetail(deliveryDetail)
}

func (u *deliveryDetailUsecase) DeleteDeliveryDetail(deliveryDetail *models.DeliveryDetails) error {
	return u.deliveryDetailRepo.DeleteDeliveryDetail(deliveryDetail)
}

func (u *deliveryDetailUsecase) GetDeliveryDetailByID(id uint) (*models.DeliveryDetails, error) {
	return u.deliveryDetailRepo.GetDeliveryDetailByID(id)
}

func (u *deliveryDetailUsecase) GetAllDeliveryDetails(page, pageSize int) ([]models.DeliveryDetails, error) {
	return u.deliveryDetailRepo.GetAllDeliveryDetails(page, pageSize)
}

func (u *deliveryDetailUsecase) GetAllDeliveryDetailsByDeliveryID(deliveryId uint, page, pageSize int) ([]models.DeliveryDetails, error) {
	return u.deliveryDetailRepo.GetAllDeliveryDetailsByDeliveryID(deliveryId, page, pageSize)
}
