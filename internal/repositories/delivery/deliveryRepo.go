package delivery

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type DeliveryRepository interface {
	CreateDelivery(delivery *models.Delivery) error
	DeleteDelivery(delivery *models.Delivery) error
	UpdateDelivery(delivery *models.Delivery) error

	GetDeliveryByID(id uint) (*models.Delivery, error)
}

type deliveryRepository struct {
	db *gorm.DB
}

func NewDeliveryRepository(db *gorm.DB) DeliveryRepository {
	return &deliveryRepository{db}
}

func (r *deliveryRepository) CreateDelivery(delivery *models.Delivery) error {
	return r.db.Create(delivery).Preload("User").Preload("Order").First(delivery, delivery.ID).Error
}

func (r *deliveryRepository) DeleteDelivery(delivery *models.Delivery) error {
	return r.db.Model(&models.Delivery{}).Where("id = ? ", delivery.ID).Delete(delivery).Error
}

func (r *deliveryRepository) UpdateDelivery(delivery *models.Delivery) error {
	err := r.db.Model(&models.Delivery{}).Where("id = ?", delivery.ID).Updates(map[string]interface{}{
		"status": delivery.Status,
	}).Error
	if err != nil {
		return err
	}
	return r.db.Preload("User").Preload("Order").First(delivery, delivery.ID).Error
}

func (r *deliveryRepository) GetDeliveryByID(id uint) (*models.Delivery, error) {
	var delivery models.Delivery
	err := r.db.Preload("User").Preload("Order").First(&delivery, id).Error
	return &delivery, err
}
