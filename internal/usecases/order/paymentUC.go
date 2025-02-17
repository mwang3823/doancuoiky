package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
)

type PaymentUsecase interface {
	CreatePayment(payment *models.Payment) error
	UpdatePayment(payment *models.Payment) error
	DeletePayment(payment *models.Payment) error

	GetPaymentByID(id uint) (*models.Payment, error)
	GetAllPayments(page, pageSize int) ([]models.Payment, error)
}

type paymentUsecase struct {
	paymentRepo  order.PaymentRepository
	orderUsecase OrderUsecase
}

func NewPaymentUsecase(paymentRepo order.PaymentRepository, orderUsecase OrderUsecase) PaymentUsecase {
	return &paymentUsecase{paymentRepo, orderUsecase}
}

func (u *paymentUsecase) CreatePayment(payment *models.Payment) error {
	order, err := u.orderUsecase.GetOrderByID(payment.OrderID)
	if err != nil {
		return err
	}

	payment.Status = "paying"
	payment.GrandTotal = order.GrandTotal

	return u.paymentRepo.CreatePayment(payment)
}

func (u *paymentUsecase) UpdatePayment(payment *models.Payment) error {
	return u.paymentRepo.UpdatePayment(payment)
}

func (u *paymentUsecase) DeletePayment(payment *models.Payment) error {
	return u.paymentRepo.DeletePayment(payment)
}

func (u *paymentUsecase) GetPaymentByID(id uint) (*models.Payment, error) {
	return u.paymentRepo.GetPaymentByID(id)
}

func (u *paymentUsecase) GetAllPayments(page, pageSize int) ([]models.Payment, error) {
	return u.paymentRepo.GetAllPayments(page, pageSize)
}
