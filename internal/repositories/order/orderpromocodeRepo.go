package order

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type OrderPromoCodeRepository interface {
	CreateOrderPromoCode(orderPromoCode *models.OrderPromoCode) error
	DeleteOrderPromoCode(orderPromoCode *models.OrderPromoCode) error
	UpdateOrderPromoCode(orderPromoCode *models.OrderPromoCode) error
	GetOrderPromoCodeByID(id uint) (*models.OrderPromoCode, error)
}

type orderPromoCodeRepository struct {
	db *gorm.DB
}

func NewOrderPromoCodeRepository(db *gorm.DB) OrderPromoCodeRepository {
	return &orderPromoCodeRepository{db}
}

func (r *orderPromoCodeRepository) CreateOrderPromoCode(orderPromoCode *models.OrderPromoCode) error {
	return r.db.Create(orderPromoCode).Preload("PromoCode").Preload("Order").First(orderPromoCode, orderPromoCode.ID).Error
}

func (r *orderPromoCodeRepository) DeleteOrderPromoCode(orderPromoCode *models.OrderPromoCode) error {
	return r.db.Model(&models.OrderPromoCode{}).Where("id = ?", orderPromoCode.ID).Delete(orderPromoCode).Error
}

func (r *orderPromoCodeRepository) UpdateOrderPromoCode(orderPromoCode *models.OrderPromoCode) error {
	err := r.db.Model(&models.OrderPromoCode{}).Where("id = ?", orderPromoCode.ID).Updates(map[string]interface{}{
		"order_id":     orderPromoCode.OrderID,
		"promocode_id": orderPromoCode.PromoCodeID,
	}).Error
	if err != nil {
		return err
	}
	return r.db.Preload("PromoCode").Preload("Order").First(orderPromoCode, orderPromoCode.ID).Error
}

func (r *orderPromoCodeRepository) GetOrderPromoCodeByID(id uint) (*models.OrderPromoCode, error) {
	var orderPromoCode models.OrderPromoCode
	err := r.db.Preload("PromoCode").Preload("Order").First(&orderPromoCode, id).Error
	return &orderPromoCode, err
}
