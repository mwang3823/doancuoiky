package cart

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type CartRepository interface {
	CreateCart(cart *models.Cart) error
	DeleteCart(cart *models.Cart) error
	UpdateCart(cart *models.Cart) error
	GetCartByUserID(userID uint) (*models.Cart, error)

	GetCartByID(id uint) (*models.Cart, error)
}

type cartRepository struct {
	db *gorm.DB
}

func NewCartRepository(db *gorm.DB) CartRepository {
	return &cartRepository{db}
}

func (r *cartRepository) CreateCart(cart *models.Cart) error {
	return r.db.Create(cart).Preload("User").First(cart, cart.ID).Error
}

func (r *cartRepository) DeleteCart(cart *models.Cart) error {
	return r.db.Model(&models.Cart{}).Where("id = ?", cart.ID).Delete(cart).Error
}

func (r *cartRepository) UpdateCart(cart *models.Cart) error {
	err := r.db.Model(&models.Cart{}).Where("id = ?", cart.ID).Updates(map[string]interface{}{
		"status": cart.Status,
	}).Error
	if err != nil {
		return err
	}

	return r.db.Preload("User").First(cart, cart.ID).Error
}

func (r *cartRepository) GetCartByID(id uint) (*models.Cart, error) {
	var cart models.Cart
	err := r.db.Preload("User").First(&cart, id).Error
	return &cart, err
}

func (r *cartRepository) GetCartByUserID(userID uint) (*models.Cart, error) {
	var cart models.Cart
	err := r.db.Preload("User").Preload("CartItems").Where("user_id = ?", userID).First(&cart).Error
	if err == gorm.ErrRecordNotFound {
		return nil, nil
	} else if err != nil {
		return nil, err
	}
	return &cart, nil
}
