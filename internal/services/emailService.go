package service

import (
	"MSA-Project/internal/utils"
	// "encoding/json"
	"errors"
	// "fmt"
	// "io"
	// "net/http"
	"sync"

	"gopkg.in/gomail.v2"
)

type EmailService interface {
	SendEmail(to string, subject string, body string) error
	GenerateAndSendOTP(email string) (string, error)
	ValidateOTP(otp string) (string, error)
	GenerateAndSendPassword(email string) (string, error)
	// VerifyEmail(email string) (bool, error)
}

type EmailVerificationResponse struct {
	Status string `json:"status"`
}

func NewEmailService() EmailService {
	return &emailService{
		otpStore:      make(map[string]string),
		passwordStore: make(map[string]string),
	}
}

type emailService struct {
	otpStore      map[string]string
	passwordStore map[string]string
	mu            sync.Mutex
}

func (s *emailService) SendEmail(to string, subject string, body string) error {
	m := gomail.NewMessage()
	m.SetHeader("From", "anhquan20102003@gmail.com")
	m.SetHeader("To", to)
	m.SetHeader("Subject", subject)
	m.SetBody("text/plain", body)

	d := gomail.NewDialer("smtp.gmail.com", 587, "anhquan20102003@gmail.com", "gofr ptlj wgjp tmmg")

	if err := d.DialAndSend(m); err != nil {
		return err
	}
	return nil
}

// Sinh ra một OTP ngẫu nhiên và gửi đến email của người dùng
func (s *emailService) GenerateAndSendOTP(email string) (string, error) {
	otp, err := utils.GenerateOTP()
	if err != nil {
		return "", err
	}

	// Gửi email cho người dùng với OTP vừa sinh ra
	err = s.SendEmail(email, "Mã OTP của bạn", "Mã OTP của bạn là: "+otp)
	if err != nil {
		return "", err
	}

	// Lưu trữ OTP vừa sinh ra vào map: key là OTP, value là email của người dùng
	// Ví dụ: otpStore["123456"] = "anhquan20102003@gmail.com"
	s.mu.Lock()
	s.otpStore[otp] = email
	s.mu.Unlock()

	return otp, nil
}

func (s *emailService) ValidateOTP(otp string) (string, error) {
	s.mu.Lock()
	email, exists := s.otpStore[otp]
	s.mu.Unlock()

	if !exists {
		return "", errors.New("invalid OTP")
	}

	s.mu.Lock()
	delete(s.otpStore, otp)
	s.mu.Unlock()

	return email, nil
}

func (s *emailService) GenerateAndSendPassword(email string) (string, error) {
	password, err := utils.GenerateRandomPassword()
	if err != nil {
		return "", err
	}

	err = s.SendEmail(email, "Your Temporary Password", "Your temporary password is: "+password)
	if err != nil {
		return "", err
	}

	s.mu.Lock()
	s.passwordStore[email] = password
	s.mu.Unlock()

	return password, nil
}

// func (s *emailService) VerifyEmail(email string) (bool, error) {
// 	apiKey := "5497d5ce12ee486da7951f94d381b2c4"
// 	url := fmt.Sprintf("https://api.zerobounce.net/v2/validate?api_key=%s&email=%s", apiKey, email)

// 	resp, err := http.Get(url)
// 	if err != nil {
// 		return false, err
// 	}
// 	defer resp.Body.Close()

// 	body, err := io.ReadAll(resp.Body)
// 	if err != nil {
// 		return false, err
// 	}

// 	var result EmailVerificationResponse
// 	if err := json.Unmarshal(body, &result); err != nil {
// 		return false, err
// 	}

// 	return result.Status == "valid", nil
// }
