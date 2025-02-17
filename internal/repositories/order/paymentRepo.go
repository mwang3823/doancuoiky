package order

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type PaymentRepository interface {
	CreatePayment(payment *models.Payment) error
	DeletePayment(payment *models.Payment) error
	UpdatePayment(payment *models.Payment) error

	GetPaymentByID(id uint) (*models.Payment, error)
	GetAllPayments(page, pageSize int) ([]models.Payment, error)
}

type paymentRepository struct {
	db *gorm.DB
}

func NewPaymentRepository(db *gorm.DB) PaymentRepository {
	return &paymentRepository{db}
}

func (r *paymentRepository) CreatePayment(payment *models.Payment) error {
	return r.db.Create(payment).Preload("User").Preload("Order").Preload("Order.User").Preload("Order.Cart").Preload("Order.Cart.User").First(payment, payment.ID).Error
}

func (r *paymentRepository) DeletePayment(payment *models.Payment) error {
	return r.db.Model(&models.Payment{}).Where("id = ?", payment.ID).Delete(payment).Error
}

func (r *paymentRepository) UpdatePayment(payment *models.Payment) error {
	err := r.db.Model(&models.Payment{}).Where("id = ?", payment.ID).Updates(map[string]interface{}{
		"payment_method": payment.PaymentMethod,
		"status":         payment.Status,
	}).Error
	if err != nil {
		return err
	}

	return r.db.Preload("User").Preload("Order").Preload("Order.User").Preload("Order.Cart").Preload("Order.Cart.User").First(payment, payment.ID).Error
}

func (r *paymentRepository) GetPaymentByID(id uint) (*models.Payment, error) {
	var payment models.Payment
	err := r.db.Preload("User").Preload("Order").Preload("Order.User").Preload("Order.Cart").Preload("Order.Cart.User").First(&payment, id).Error
	return &payment, err
}

func (r *paymentRepository) GetAllPayments(page, pageSize int) ([]models.Payment, error) {
	var payments []models.Payment
	err := r.db.Preload("User").Preload("Order").Preload("Order.User").Preload("Order.Cart").Preload("Order.Cart.User").Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&payments).Error
	return payments, err
}
