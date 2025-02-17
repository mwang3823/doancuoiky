package order

import (
	"MSA-Project/internal/domain/models"
	"errors"

	"gorm.io/gorm"
)

type OrderRepository interface {
	CreateOrder(order *models.Order) error
	DeleteOrder(order *models.Order) error
	UpdateOrder(order *models.Order) error

	GetAllOrders(page, pageSize int) ([]models.Order, error)
	SearchOrderByPhoneNumber(phoneNumber string, page, pageSize int) ([]models.Order, error)
	GetOrderByID(id uint) (*models.Order, error)
	GetOrderWithDetails(orderID uint) (*models.Order, error)

	GetOrdersByUserIDWithStatus(userID uint, status string, offset int, limit int, orders *[]*models.Order) error
}

type orderRepository struct {
	db *gorm.DB
}

func NewOrderRepository(db *gorm.DB) OrderRepository {
	return &orderRepository{db}
}

func (r *orderRepository) CreateOrder(order *models.Order) error {
	return r.db.Create(order).Error
}

func (r *orderRepository) DeleteOrder(order *models.Order) error {
	var paymentCount int64
	if err := r.db.Model(&models.Payment{}).Where("order_id = ?", order.ID).Count(&paymentCount).Error; err != nil {
		return err
	}
	if paymentCount > 0 {
		return errors.New("cannot delete order: associated payments exist")
	}
	var deliveryCount int64
	if err := r.db.Model(&models.Delivery{}).Where("order_id = ?", order.ID).Count(&deliveryCount).Error; err != nil {
		return err
	}
	if deliveryCount > 0 {
		return errors.New("cannot delete order: associated deliveries exist")
	}
	return r.db.Model(&models.Order{}).Where("id = ?", order.ID).Delete(order).Error
}

func (r *orderRepository) UpdateOrder(order *models.Order) error {
	err := r.db.Model(&models.Order{}).Where("id = ?", order.ID).Updates(map[string]interface{}{
		"status": order.Status,
	}).Error
	if err != nil {
		return err
	}

	return r.db.Preload("User").
		Preload("Cart").
		Preload("Cart.User").
		First(order, order.ID).Error
}

func (r *orderRepository) GetAllOrders(page, pageSize int) ([]models.Order, error) {
	var orders []models.Order
	err := r.db.Preload("User").
		Preload("Cart").
		Preload("Cart.User").
		Preload("OrderDetails").Preload("OrderDetails.Product").Preload("OrderDetails.Order").Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&orders).Error
	return orders, err
}

func (r *orderRepository) SearchOrderByPhoneNumber(phoneNumber string, page, pageSize int) ([]models.Order, error) {
	var orders []models.Order
	err := r.db.Preload("User").
		Preload("Cart").
		Preload("Cart.User").
		Joins("JOIN users ON users.id = orders.user_id").
		Where("users.phone_number = ?", phoneNumber).
		Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&orders).Error
	return orders, err
}

func (r *orderRepository) GetOrderByID(id uint) (*models.Order, error) {
	var order models.Order
	err := r.db.Preload("User").
		Preload("Cart").
		Preload("Cart.User").First(&order, id).Error
	return &order, err
}

func (r *orderRepository) GetOrderWithDetails(orderID uint) (*models.Order, error) {
	var order models.Order
	if err := r.db.Preload("User").
		Preload("Cart").
		Preload("Cart.User").
		First(&order, orderID).Error; err != nil {
		return nil, err
	}
	return &order, nil
}

func (r *orderRepository) GetOrdersByUserIDWithStatus(userID uint, status string, offset int, limit int, orders *[]*models.Order) error {
	return r.db.Preload("User").
		Preload("Cart").Preload("OrderDetails.Product").Preload("OrderDetails.Product.Category").Preload("OrderDetails.Product.Manufacturer").
		Preload("OrderDetails.Order").Preload("OrderDetails.Order.User").Preload("OrderDetails.Order.Cart").Preload("OrderDetails.Order.Cart.User").
		Where("user_id = ? AND status = ?", userID, status).
		Order("created_at DESC").
		Offset(offset).
		Limit(limit).
		Find(orders).
		Error
}
