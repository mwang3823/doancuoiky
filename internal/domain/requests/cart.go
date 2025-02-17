package requests

import (
	"gorm.io/gorm"
)

type Cart struct {
	gorm.Model
	Status string `json:"status"`

	UserID uint `json:"user_id"`
	User   User `gorm:"foreignKey:UserID"`

	CartItems []CartItem `gorm:"foreignKey:CartID" json:"items"`
	Orders    []Order    `gorm:"foreignKey:CartID" json:"orders"`
}

type CartItem struct {
	gorm.Model
	Status   string  `json:"status"`
	Price    float64 `json:"price"`
	Quantity int     `json:"quantity"`

	CartID    uint    `json:"cart_id"`
	ProductID uint    `json:"product_id"`
	Product   Product `gorm:"foreignKey:ProductID"`
	Cart      Cart    `gorm:"foreignKey:CartID"`
}
