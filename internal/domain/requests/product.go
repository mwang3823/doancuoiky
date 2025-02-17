package requests

import (
	"gorm.io/gorm"
)

type Product struct {
	gorm.Model
	Name  string  `json:"name"`
	Price float64 `json:"price"`
	Image string  `json:"image"`
	Sales uint64  `json:"sales"`

	Size          int    `json:"size"`
	Color         string `json:"color"`
	Specification string `json:"specification"`
	Description   string `json:"description"`
	Expiry        string `json:"expiry"`
	StockNumber   int    `json:"stocknumber"`
	StockLevel    string `json:"stocklevel"`

	CategoryID     *uint `json:"category_id"`
	ManufacturerID *uint `json:"manufacturer_id"`

	CartItems    []CartItem    `gorm:"foreignKey:ProductID" json:"cart_items"`
	OrderDetails []OrderDetail `gorm:"foreignKey:ProductID" json:"order_details"`
	Feedbacks    []Feedback    `gorm:"foreignKey:ProductID" json:"feedbacks"`

	Category     Category     `gorm:"foreignKey:CategoryID"`
	Manufacturer Manufacturer `gorm:"foreignKey:ManufacturerID"`
}

type Category struct {
	gorm.Model
	Name        string `json:"name"`
	Description string `json:"description"`

	ParentID *uint      `json:"parent_id"`
	Children []Category `gorm:"foreignKey:ParentID" json:"children"`

	Products []Product `gorm:"foreignKey:CategoryID" json:"products"`
}

type Manufacturer struct {
	gorm.Model
	Name    string `json:"name"`
	Address string `json:"address"`
	Contact string `json:"contact"`

	Products []Product `gorm:"foreignKey:ManufacturerID" json:"products"`
}
