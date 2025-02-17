package models

import (
	"gorm.io/gorm"
)

type Delivery struct {
	gorm.Model
	Status string `json:"status"`

	OrderID uint  `json:"order_id"`
	Order   Order `gorm:"foreignKey:OrderID"`

	UserID uint `json:"user_id"`
	User   User `gorm:"foreignKey:UserID"`

	Details []DeliveryDetails `gorm:"foreignKey:DeliveryID" json:"details"`
}

type DeliveryDetails struct {
	gorm.Model
	DeliveryName    string  `json:"deliveryname"`
	ShipCode        string  `json:"shipcode"`
	Description     string  `json:"description"`
	Weight          float64 `json:"weight"`
	DeliveryAddress string  `json:"deliveryaddress"`
	DeliveryContact string  `json:"deliverycontact"`
	DeliveryFee     float64 `json:"deliveryfee"`

	DeliveryID uint     `json:"delivery_id"`
	Delivery   Delivery `gorm:"foreignKey:DeliveryID"`
}
