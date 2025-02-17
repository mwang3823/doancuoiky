package order

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type PromoCodeRepository interface {
	CreatePromoCode(promoCode *models.PromoCode) error
	DeletePromoCode(promoCode *models.PromoCode) error
	UpdatePromoCode(promoCode *models.PromoCode) error

	GetPromoCodeByID(id uint) (*models.PromoCode, error)
	GetPromoCodeByCode(code string) (*models.PromoCode, error)
	GetAllPromocodes(page, pageSize int) ([]models.PromoCode, error)
}

type promoCodeRepository struct {
	db *gorm.DB
}

func NewPromoCodeRepository(db *gorm.DB) PromoCodeRepository {
	return &promoCodeRepository{db}
}

func (r *promoCodeRepository) CreatePromoCode(promoCode *models.PromoCode) error {
	return r.db.Create(promoCode).Error
}

func (r *promoCodeRepository) DeletePromoCode(promoCode *models.PromoCode) error {
	return r.db.Model(&models.PromoCode{}).Where("id = ?", promoCode.ID).Delete(promoCode).Error
}

func (r *promoCodeRepository) UpdatePromoCode(promoCode *models.PromoCode) error {
	return r.db.Save(promoCode).Error
}

func (r *promoCodeRepository) GetPromoCodeByID(id uint) (*models.PromoCode, error) {
	var promoCode models.PromoCode
	err := r.db.First(&promoCode, id).Error
	return &promoCode, err
}

func (r *promoCodeRepository) GetPromoCodeByCode(code string) (*models.PromoCode, error) {
	var promocode models.PromoCode
	if err := r.db.Where("code = ?", code).First(&promocode).Error; err != nil {
		return nil, err
	}
	return &promocode, nil
}

func (r *promoCodeRepository) GetAllPromocodes(page, pageSize int) ([]models.PromoCode, error) {
	var promocodes []models.PromoCode
	err := r.db.Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&promocodes).Error
	return promocodes, err
}
