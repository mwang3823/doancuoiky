package order

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type ReturnOrderRepository interface {
	CreateReturnOrder(returnOrder *models.ReturnOrder) error
	DeleteReturnOrder(returnOrder *models.ReturnOrder) error
	UpdateReturnOrder(returnOrder *models.ReturnOrder) error

	GetReturnOrderByID(id uint) (*models.ReturnOrder, error)
	GetAllReturnOrders(page int, pageSize int) ([]models.ReturnOrder, error)
}

type returnOrderRepository struct {
	db *gorm.DB
}

func NewReturnOrderRepository(db *gorm.DB) ReturnOrderRepository {
	return &returnOrderRepository{db}
}

func (r *returnOrderRepository) CreateReturnOrder(returnOrder *models.ReturnOrder) error {
	return r.db.Create(returnOrder).Preload("Order").Preload("Order.Cart").Preload("Order.Cart.User").Preload("Order.User").First(returnOrder, returnOrder.ID).Error
}

func (r *returnOrderRepository) DeleteReturnOrder(returnOrder *models.ReturnOrder) error {
	return r.db.Where("id = ?", returnOrder.ID).Delete(returnOrder).Error
}

func (r *returnOrderRepository) UpdateReturnOrder(returnOrder *models.ReturnOrder) error {
	err := r.db.Model(&models.ReturnOrder{}).Where("id = ?", returnOrder.ID).Updates(map[string]interface{}{
		"status": returnOrder.Status,
		"reason": returnOrder.Reason,
	}).Error
	if err != nil {
		return err
	}

	return r.db.Preload("Order").Preload("Order.Cart").Preload("Order.Cart.User").Preload("Order.User").Save(returnOrder).Error
}

func (r *returnOrderRepository) GetReturnOrderByID(id uint) (*models.ReturnOrder, error) {
	var returnOrder models.ReturnOrder
	err := r.db.Preload("Order").Preload("Order.Cart").Preload("Order.Cart.User").Preload("Order.User").First(&returnOrder, id).Error
	return &returnOrder, err
}

func (r *returnOrderRepository) GetAllReturnOrders(page int, pageSize int) ([]models.ReturnOrder, error) {
	var returnOrders []models.ReturnOrder
	offset := (page - 1) * pageSize
	err := r.db.Preload("Order").Preload("Order.Cart").Preload("Order.Cart.User").Preload("Order.User").Offset(offset).Limit(pageSize).Find(&returnOrders).Error
	if err != nil {
		return nil, err
	}
	return returnOrders, nil
}
