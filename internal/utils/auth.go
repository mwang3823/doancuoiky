package utils

import (
	"crypto/rand"
	"math/big"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

func GenerateOTP() (string, error) {
	const otpLength = 6
	const digits = "0123456789"
	var otp string
	for i := 0; i < otpLength; i++ {
		num, err := rand.Int(rand.Reader, big.NewInt(int64(len(digits))))
		if err != nil {
			return "", err
		}
		otp += string(digits[num.Int64()])
	}
	return otp, nil
}

func GenerateRandomPassword() (string, error) {
	const passwordLength = 8
	const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
	var password string
	for i := 0; i < passwordLength; i++ {
		num, err := rand.Int(rand.Reader, big.NewInt(int64(len(charset))))
		if err != nil {
			return "", err
		}
		password += string(charset[num.Int64()])
	}
	return password, nil
}

// Khoá bí mật để ký JWT
var jwtKey = []byte("nopainnogain")

// Cấu trúc Claims chứa thông tin người dùng và các claim đã đăng ký của JWT
type Claims struct {
	Email string `json:"email"`
	jwt.RegisteredClaims
}

// Hàm GenerateJWT tạo một JWT mới với email của người dùng
func GenerateJWT(email string) (string, error) {
	// Thiết lập thời gian hết hạn cho token
	expirationTime := time.Now().Add(24 * time.Hour)
	claims := &Claims{
		Email: email,
		RegisteredClaims: jwt.RegisteredClaims{
			ExpiresAt: jwt.NewNumericDate(expirationTime),
		},
	}

	// Tạo token mới với phương thức ký HS256
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		return "", err
	}

	return tokenString, nil
}

// Hàm ValidateJWT xác thực và giải mã token thành Claims
func ValidateJWT(tokenString string) (*Claims, error) {
	claims := &Claims{}

	// Giải mã token với khóa bí mật
	token, err := jwt.ParseWithClaims(tokenString, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil {
		if err == jwt.ErrSignatureInvalid {
			return nil, jwt.ErrSignatureInvalid
		}
		return nil, err
	}

	// Kiểm tra tính hợp lệ của token
	if !token.Valid {
		return nil, jwt.ErrSignatureInvalid
	}

	return claims, nil
}

// Middleware AuthRequired yêu cầu xác thực JWT cho các yêu cầu HTTP
func AuthRequired() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Lấy header Authorization từ yêu cầu
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Authorization token not provided"})
			c.Abort()
			return
		}

		// Loại bỏ tiền tố "Bearer " khỏi chuỗi token
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")
		if tokenString == authHeader {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid Authorization format"})
			c.Abort()
			return
		}

		// Xác thực token và lấy thông tin Claims
		claims, err := ValidateJWT(tokenString)
		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid or expired token"})
			c.Abort()
			return
		}

		// Lưu email người dùng vào context
		c.Set("user_email", claims.Email)

		c.Next()
	}
}

func GetPageAndSize(c *gin.Context) (int, int) {
	page, err := strconv.Atoi(c.DefaultQuery("page", "1"))
	if err != nil || page < 1 {
		page = 1
	}
	pageSize, err := strconv.Atoi(c.DefaultQuery("page_size", "10"))
	if err != nil || pageSize < 1 {
		pageSize = 10
	}
	return page, pageSize
}
