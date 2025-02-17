package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
)

type OrderDetailUsecase interface {
	CreateOrderDetail(orderDetail *models.OrderDetail) error
	UpdateOrderDetail(orderDetail *models.OrderDetail) error
	DeleteOrderDetail(orderDetail *models.OrderDetail) error

	GetOrderDetailByID(id uint) (*models.OrderDetail, error)
	GetOrderDetailsByOrderID(orderID uint) ([]models.OrderDetail, error)
}

type orderDetailUsecase struct {
	orderDetailRepo order.OrderDetailRepository
}

func NewOrderDetailUsecase(orderDetailRepo order.OrderDetailRepository) OrderDetailUsecase {
	return &orderDetailUsecase{orderDetailRepo}
}

func (u *orderDetailUsecase) CreateOrderDetail(orderDetail *models.OrderDetail) error {
	return u.orderDetailRepo.CreateOrderDetail(orderDetail)
}

func (u *orderDetailUsecase) UpdateOrderDetail(orderDetail *models.OrderDetail) error {
	return u.orderDetailRepo.UpdateOrderDetail(orderDetail)
}

func (u *orderDetailUsecase) DeleteOrderDetail(orderDetail *models.OrderDetail) error {
	return u.orderDetailRepo.DeleteOrderDetail(orderDetail)
}

func (u *orderDetailUsecase) GetOrderDetailByID(id uint) (*models.OrderDetail, error) {
	return u.orderDetailRepo.GetOrderDetailByID(id)
}

func (u *orderDetailUsecase) GetOrderDetailsByOrderID(orderID uint) ([]models.OrderDetail, error) {
	return u.orderDetailRepo.GetOrderDetailsByOrderID(orderID)
}
