package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
)

type OrderPromoCodeUsecase interface {
	CreateOrderPromoCode(opc *models.OrderPromoCode) error
	UpdateOrderPromoCode(opc *models.OrderPromoCode) error
	DeleteOrderPromoCode(opc *models.OrderPromoCode) error

	GetOrderPromoCodeByID(id uint) (*models.OrderPromoCode, error)
}

type orderPromoCodeUsecase struct {
	orderPromoCodeRepo order.OrderPromoCodeRepository
}

func NewOrderPromoCodeUsecase(orderPromoCodeRepo order.OrderPromoCodeRepository) OrderPromoCodeUsecase {
	return &orderPromoCodeUsecase{orderPromoCodeRepo}
}

func (u *orderPromoCodeUsecase) CreateOrderPromoCode(opc *models.OrderPromoCode) error {
	return u.orderPromoCodeRepo.CreateOrderPromoCode(opc)
}

func (u *orderPromoCodeUsecase) UpdateOrderPromoCode(opc *models.OrderPromoCode) error {
	return u.orderPromoCodeRepo.UpdateOrderPromoCode(opc)
}

func (u *orderPromoCodeUsecase) DeleteOrderPromoCode(opc *models.OrderPromoCode) error {
	return u.orderPromoCodeRepo.DeleteOrderPromoCode(opc)
}

func (u *orderPromoCodeUsecase) GetOrderPromoCodeByID(id uint) (*models.OrderPromoCode, error) {
	return u.orderPromoCodeRepo.GetOrderPromoCodeByID(id)
}
