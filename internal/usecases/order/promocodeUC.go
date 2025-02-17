package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
)

type PromoCodeUsecase interface {
	CreatePromoCode(promoCode *models.PromoCode) error
	UpdatePromoCode(promoCode *models.PromoCode) error
	DeletePromoCode(promoCode *models.PromoCode) error

	GetPromoCodeByID(id uint) (*models.PromoCode, error)
	GetPromoCodeByCode(code string) (*models.PromoCode, error)
	GetAllPromocodes(page, pageSize int) ([]models.PromoCode, error)
}

type promoCodeUsecase struct {
	promoCodeRepo order.PromoCodeRepository
}

func NewPromoCodeUsecase(promoCodeRepo order.PromoCodeRepository) PromoCodeUsecase {
	return &promoCodeUsecase{promoCodeRepo}
}

func (u *promoCodeUsecase) CreatePromoCode(promoCode *models.PromoCode) error {
	return u.promoCodeRepo.CreatePromoCode(promoCode)
}

func (u *promoCodeUsecase) UpdatePromoCode(promoCode *models.PromoCode) error {
	return u.promoCodeRepo.UpdatePromoCode(promoCode)
}

func (u *promoCodeUsecase) DeletePromoCode(promoCode *models.PromoCode) error {
	return u.promoCodeRepo.DeletePromoCode(promoCode)
}

func (u *promoCodeUsecase) GetPromoCodeByID(id uint) (*models.PromoCode, error) {
	return u.promoCodeRepo.GetPromoCodeByID(id)
}

func (u *promoCodeUsecase) GetPromoCodeByCode(code string) (*models.PromoCode, error) {
	return u.promoCodeRepo.GetPromoCodeByCode(code)
}

func (u *promoCodeUsecase) GetAllPromocodes(page, pageSize int) ([]models.PromoCode, error) {
	return u.promoCodeRepo.GetAllPromocodes(page, pageSize)
}
