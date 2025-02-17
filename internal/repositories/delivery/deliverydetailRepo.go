package delivery

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type DeliveryDetailRepository interface {
	CreateDeliveryDetail(deliverydetail *models.DeliveryDetails) error
	DeleteDeliveryDetail(deliverydetail *models.DeliveryDetails) error
	UpdateDeliveryDetail(deliverydetail *models.DeliveryDetails) error

	GetDeliveryDetailByID(id uint) (*models.DeliveryDetails, error)
	GetAllDeliveryDetails(page, pageSize int) ([]models.DeliveryDetails, error)
	GetAllDeliveryDetailsByDeliveryID(deliveryId uint, page, pageSize int) ([]models.DeliveryDetails, error)
}

type deliveryDetailRepository struct {
	db *gorm.DB
}

func NewDeliveryDetailRepository(db *gorm.DB) DeliveryDetailRepository {
	return &deliveryDetailRepository{db}
}

func (r *deliveryDetailRepository) CreateDeliveryDetail(deliverydetail *models.DeliveryDetails) error {
	return r.db.Create(deliverydetail).Preload("Delivery").Preload("Delivery.Order").Preload("Delivery.User").Preload("Delivery.Order.Cart").First(deliverydetail, deliverydetail.ID).Error
}

func (r *deliveryDetailRepository) DeleteDeliveryDetail(deliverydetail *models.DeliveryDetails) error {
	return r.db.Model(&models.DeliveryDetails{}).Where("id = ?", deliverydetail.ID).Delete(deliverydetail).Error
}

func (r *deliveryDetailRepository) UpdateDeliveryDetail(deliverydetail *models.DeliveryDetails) error {
	err := r.db.Model(&models.DeliveryDetails{}).Where("id = ?", deliverydetail.ID).Updates(map[string]interface{}{
		"delivery_name":    deliverydetail.DeliveryName,
		"shipcode":         deliverydetail.ShipCode,
		"description":      deliverydetail.Description,
		"weight":           deliverydetail.Weight,
		"delivery_address": deliverydetail.DeliveryAddress,
		"delivery_contact": deliverydetail.DeliveryContact,
		"delivery_fee":     deliverydetail.DeliveryFee,
		"delivery_id":      deliverydetail.DeliveryID,
	}).Error
	if err != nil {
		return err
	}
	return r.db.Preload("Delivery").Preload("Delivery.Order").Preload("Delivery.User").Preload("Delivery.Order.Cart").First(deliverydetail, deliverydetail.ID).Error
}

func (r *deliveryDetailRepository) GetDeliveryDetailByID(id uint) (*models.DeliveryDetails, error) {
	var deliveydetail models.DeliveryDetails
	err := r.db.Preload("Delivery").Preload("Delivery.Order").Preload("Delivery.User").Preload("Delivery.Order.Cart").First(&deliveydetail, id).Error
	return &deliveydetail, err
}

func (r *deliveryDetailRepository) GetAllDeliveryDetails(page, pageSize int) ([]models.DeliveryDetails, error) {
	var deliveryDetails []models.DeliveryDetails
	err := r.db.Preload("Delivery").Preload("Delivery.Order").Preload("Delivery.User").Preload("Delivery.Order.Cart").Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&deliveryDetails).Error
	return deliveryDetails, err
}

func (r *deliveryDetailRepository) GetAllDeliveryDetailsByDeliveryID(deliveryId uint, page, pageSize int) ([]models.DeliveryDetails, error) {
	var deliveryDetails []models.DeliveryDetails
	err := r.db.Preload("Delivery").Preload("Delivery.Order").Preload("Delivery.User").Preload("Delivery.Order.Cart").Where("delivery_id = ?", deliveryId).Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&deliveryDetails).Error
	return deliveryDetails, err
}
