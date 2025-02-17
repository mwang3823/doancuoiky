package delivery

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/delivery"
)

type DeliveryUsecase interface {
	CreateDelivery(delivery *models.Delivery) error
	UpdateDelivery(delivery *models.Delivery) error
	DeleteDelivery(delivery *models.Delivery) error

	GetDeliveryByID(id uint) (*models.Delivery, error)
}

type deliveryUsecase struct {
	deliveryRepo delivery.DeliveryRepository
}

func NewDeliveryUsecase(deliveryRepo delivery.DeliveryRepository) DeliveryUsecase {
	return &deliveryUsecase{deliveryRepo}
}

func (u *deliveryUsecase) CreateDelivery(delivery *models.Delivery) error {
	delivery.Status = "delivering"
	return u.deliveryRepo.CreateDelivery(delivery)
}

func (u *deliveryUsecase) UpdateDelivery(delivery *models.Delivery) error {
	return u.deliveryRepo.UpdateDelivery(delivery)
}

func (u *deliveryUsecase) DeleteDelivery(delivery *models.Delivery) error {
	return u.deliveryRepo.DeleteDelivery(delivery)
}

func (u *deliveryUsecase) GetDeliveryByID(id uint) (*models.Delivery, error) {
	return u.deliveryRepo.GetDeliveryByID(id)
}
