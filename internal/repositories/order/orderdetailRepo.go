package order

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type OrderDetailRepository interface {
	CreateOrderDetail(orderDetail *models.OrderDetail) error
	DeleteOrderDetail(orderDetail *models.OrderDetail) error
	UpdateOrderDetail(orderDetail *models.OrderDetail) error
	GetOrderDetailByID(id uint) (*models.OrderDetail, error)
	GetOrderDetailsByOrderID(orderID uint) ([]models.OrderDetail, error)
}

type orderDetailRepository struct {
	db *gorm.DB
}

func NewOrderDetailRepository(db *gorm.DB) OrderDetailRepository {
	return &orderDetailRepository{db}
}

func (r *orderDetailRepository) CreateOrderDetail(orderDetail *models.OrderDetail) error {
	return r.db.Create(orderDetail).Preload("Product").Preload("Order").First(orderDetail, orderDetail.ID).Error
}

func (r *orderDetailRepository) DeleteOrderDetail(orderDetail *models.OrderDetail) error {
	return r.db.Model(&models.OrderDetail{}).Where("id = ?", orderDetail.ID).Delete(orderDetail).Error
}

func (r *orderDetailRepository) UpdateOrderDetail(orderDetail *models.OrderDetail) error {
	err := r.db.Model(&models.OrderDetail{}).Where("id = ?", orderDetail.ID).Updates(map[string]interface{}{
		"status": orderDetail.Status,
	}).Error
	if err != nil {
		return err
	}
	return r.db.Preload("Product").Preload("Order").First(orderDetail, orderDetail.ID).Error
}

func (r *orderDetailRepository) GetOrderDetailByID(id uint) (*models.OrderDetail, error) {
	var orderDetail models.OrderDetail
	err := r.db.Preload("Product").Preload("Order").First(&orderDetail, id).Error
	return &orderDetail, err
}

func (r *orderDetailRepository) GetOrderDetailsByOrderID(orderID uint) ([]models.OrderDetail, error) {
	var orderDetails []models.OrderDetail
	err := r.db.Preload("Product").Preload("Order").Where("order_id = ?", orderID).Find(&orderDetails).Error
	return orderDetails, err
}
