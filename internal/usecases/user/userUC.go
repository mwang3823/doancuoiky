package user

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/domain/requests"
	"MSA-Project/internal/repositories/user"
	services "MSA-Project/internal/services"
	"MSA-Project/internal/utils"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
)

type UserUsecase interface {
	CreateUser(user *models.User) error
	RegisterUser(users *models.User) (string, error)
	Login(email, password string) (string, error)
	VerifyOTP(otp string) (string, *models.User, error)
	GetNewPassword(email string) (string, error)
	LoginWithGoogle(accessToken string) (string, *models.User, error)
	DeleteUser(users *models.User) error
	UpdateUser(users *models.User, currentPassword string) error
	UpdateUserInf(users *models.User) error

	GetUserByID(id uint) (*models.User, error)
	GetUserByPhoneNumber(phoneNumber string) (*models.User, error)
	GetUserByEmail(email string) (*models.User, error)
	GetUserByGoogleID(googleID string) (*models.User, error)
	GenerateAndSetRandomPasswordByEmail(email string) (string, error)
	GetAllUsers(page, pageSize int) ([]models.User, error)
}

type userUsecase struct {
	userRepo     user.UserRepository
	emailService services.EmailService
}

func NewUserUsecase(userRepo user.UserRepository, emailService services.EmailService) UserUsecase {
	return &userUsecase{
		userRepo:     userRepo,
		emailService: emailService,
	}
}

func (u *userUsecase) CreateUser(user *models.User) error {
	return u.userRepo.CreateUser(user)
}

func (u *userUsecase) RegisterUser(users *models.User) (string, error) {
	// isValid, err := u.emailService.VerifyEmail(users.Email)
	// if err != nil {
	// 	return "", err
	// }
	// if !isValid {
	// 	return "", errors.New("invalid email address")
	// }

	existingUser, err := u.userRepo.GetUserByEmail(users.Email)
	if err == nil && existingUser != nil {
		return "", errors.New("user already exists")
	}

	hashedPassword, err := utils.HashPassword(users.Password)
	if err != nil {
		return "", err
	}

	users.Password = hashedPassword

	if users.Role == "" {
		users.Role = "customer"
	}

	err = u.userRepo.CreateUser(users)
	if err != nil {
		return "", err
	}

	return users.Email, nil
}

func (u *userUsecase) Login(email, password string) (string, error) {
	user, err := u.userRepo.GetUserByEmail(email)
	if err != nil {
		return "", err
	}

	if !utils.CheckPasswordHash(password, user.Password) {
		return "", errors.New("invalid credentials")
	}

	otp, err := u.emailService.GenerateAndSendOTP(email)

	if err != nil {
		return "", err
	}

	return otp, nil
}

func (u *userUsecase) GetNewPassword(email string) (string, error) {
	otp, err := u.emailService.GenerateAndSendOTP(email)

	if err != nil {
		return "", err
	}

	return otp, nil
}

func (u *userUsecase) VerifyOTP(otp string) (string, *models.User, error) {
	email, err := u.emailService.ValidateOTP(otp)
	if err != nil {
		return "", nil, err
	}

	user, err := u.userRepo.GetUserByEmail(email)
	if err != nil {
		return "", nil, err
	}

	token, err := utils.GenerateJWT(user.Email)
	if err != nil {
		return "", nil, fmt.Errorf("failed to generate token: %w", err)
	}

	return token, user, nil
}

func (u *userUsecase) LoginWithGoogle(accessToken string) (string, *models.User, error) {
	resp, err := http.Get("https://www.googleapis.com/oauth2/v2/userinfo?access_token=" + accessToken)
	if err != nil {
		return "", nil, errors.New("failed to get user info from Google")
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", nil, errors.New("invalid Google access token")
	}

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", nil, errors.New("failed to read response from Google")
	}

	var gUser requests.GoogleUser
	if err := json.Unmarshal(data, &gUser); err != nil {
		return "", nil, errors.New("failed to parse user info from Google")
	}

	if gUser.Email == "" {
		return "", nil, errors.New("email not provided by Google")
	}

	user, err := u.userRepo.GetUserByEmail(gUser.Email)
	if err != nil {
		randomPassword, err := utils.GenerateRandomPassword()
		if err != nil {
			return "", nil, errors.New("failed to generate random password")
		}

		hashedPassword, err := utils.HashPassword(randomPassword)
		if err != nil {
			return "", nil, errors.New("failed to hash password")
		}

		user = &models.User{
			FullName: gUser.Name,
			Email:    gUser.Email,
			Password: hashedPassword,
			Role:     "customer",
			GoogleID: gUser.ID,
		}

		err = u.userRepo.CreateUser(user)
		if err != nil {
			return "", nil, errors.New("failed to create user")
		}

		if err := u.emailService.SendEmail(user.Email, "Your Account Password", "Your password is: "+randomPassword); err != nil {
			return "", nil, errors.New("failed to send password email")
		}
	}

	tokenStr, err := utils.GenerateJWT(user.Email)
	if err != nil {
		return "", nil, errors.New("failed to generate token")
	}

	return tokenStr, user, nil
}

func (u *userUsecase) DeleteUser(users *models.User) error {
	return u.userRepo.DeleteUser(users)
}

func (u *userUsecase) UpdateUser(users *models.User, currentPassword string) error {
	currentUser, err := u.GetUserByID(users.ID)
	if err != nil {
		return err
	}

	if !utils.CheckPasswordHash(currentPassword, currentUser.Password) {
		return errors.New("current password is incorrect")
	}

	if users.Password != "" && users.Password != currentUser.Password {
		hashedPassword, err := utils.HashPassword(users.Password)
		if err != nil {
			return err
		}
		users.Password = hashedPassword
	} else {
		users.Password = currentUser.Password
	}

	return u.userRepo.UpdateUser(users)
}

func (u *userUsecase) UpdateUserInf(users *models.User) error {
	currentUser, err := u.GetUserByID(users.ID)
	if err != nil {
		return err
	}

	if users.FullName != "" && users.FullName != currentUser.FullName {
		currentUser.FullName = users.FullName
	}

	if users.PhoneNumber != "" && users.PhoneNumber != currentUser.PhoneNumber {
		existingUser, err := u.GetUserByPhoneNumber(users.PhoneNumber)
		if err == nil && existingUser != nil {
			return errors.New("phone number already exists")
		}
		currentUser.PhoneNumber = users.PhoneNumber
	}

	if users.Email != "" && users.Email != currentUser.Email {
		existingUser, err := u.GetUserByEmail(users.Email)
		if err == nil && existingUser != nil {
			return errors.New("email already exists")
		}
		currentUser.Email = users.Email
	}

	if users.Password != "" && users.Password != currentUser.Password {
		hashedPassword, err := utils.HashPassword(users.Password)
		if err != nil {
			return err
		}
		currentUser.Password = hashedPassword
	}

	currentUser.Role = users.Role
	currentUser.Address = users.Address

	return u.userRepo.UpdateUser(currentUser)
}

func (u *userUsecase) GetUserByID(id uint) (*models.User, error) {
	return u.userRepo.GetUserByID(id)
}

func (u *userUsecase) GetUserByPhoneNumber(phoneNumber string) (*models.User, error) {
	return u.userRepo.GetUserByPhoneNumber(phoneNumber)
}

func (u *userUsecase) GetUserByEmail(email string) (*models.User, error) {
	return u.userRepo.GetUserByEmail(email)
}

func (u *userUsecase) GetAllUsers(page, pageSize int) ([]models.User, error) {
	return u.userRepo.GetAllUsers(page, pageSize)
}

func (u *userUsecase) GetUserByGoogleID(googleID string) (*models.User, error) {
	return u.userRepo.GetUserByGoogleID(googleID)
}

func (u *userUsecase) GenerateAndSetRandomPasswordByEmail(email string) (string, error) {
	user, err := u.userRepo.GetUserByEmail(email)
	if err != nil {
		return "", errors.New("user not found")
	}

	password, err := utils.GenerateRandomPassword()
	if err != nil {
		return "", err
	}

	err = u.emailService.SendEmail(email, "Your new password", "Your new password is: "+password)
	if err != nil {
		return "", err
	}

	hashedPassword, err := utils.HashPassword(password)
	if err != nil {
		return "", err
	}

	user.Password = hashedPassword
	err = u.userRepo.UpdateUser(user)
	if err != nil {
		return "", err
	}

	return "Password sent via email and updated successfully", nil
}
