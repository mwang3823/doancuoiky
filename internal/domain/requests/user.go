package requests

import (
	"github.com/go-playground/validator/v10"
	"gorm.io/gorm"
)

type User struct {
	gorm.Model
	FullName    string `json:"fullname"`
	Email       string `json:"email"`
	PhoneNumber string `json:"phonenumber"`
	Birthday    string `json:"birthday"`
	Password    string `json:"password"`
	Address     string `json:"address"`
	Role        string `json:"role"`

	GoogleID string `json:"google_id"`

	Carts      []Cart     `gorm:"foreignKey:UserID" json:"carts"`
	Orders     []Order    `gorm:"foreignKey:UserID" json:"orders"`
	Feedbacks  []Feedback `gorm:"foreignKey:UserID" json:"feedbacks"`
	Payments   []Payment  `gorm:"foreignKey:UserID" json:"payments"`
	Deliveries []Delivery `gorm:"foreignKey:UserID" json:"deliveries"`
}

type GoogleUser struct {
	ID            string `json:"id"`
	Email         string `json:"email"`
	VerifiedEmail bool   `json:"verified_email"`
	Name          string `json:"name"`
	GivenName     string `json:"given_name"`
	FamilyName    string `json:"family_name"`
	Picture       string `json:"picture"`
	Locale        string `json:"locale"`
}

func (u *User) Validate() error {
	validate := validator.New()
	return validate.Struct(u)
}
