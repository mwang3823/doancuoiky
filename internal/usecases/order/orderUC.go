package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
	services "MSA-Project/internal/services"
	"MSA-Project/internal/usecases/cart"
	"MSA-Project/internal/usecases/product"
	"MSA-Project/internal/usecases/user"
	"errors"
	"fmt"
)

type OrderUsecase interface {
	CreateOrder(userID uint, cartID uint, promoCode string) (*models.Order, error)
	CalculateOrderSummary(userID uint, cartID uint, promoCode string) (float64, float64, float64, error)
	UpdateOrder(order *models.Order) error
	DeleteOrder(order *models.Order) error

	GetOrderByID(id uint) (*models.Order, error)
	SearchOrderByPhoneNumber(phoneNumber string, page, pageSize int) ([]models.Order, error)
	GetAllOrders(page, pageSize int) ([]models.Order, error)
	GetOrdersByUserIDWithStatus(userID uint, status string, page int, size int) ([]*models.Order, error)
}

type orderUsecase struct {
	orderRepo             order.OrderRepository
	cartUsecase           cart.CartUsecase
	cartItemUsecase       cart.CartItemUsecase
	promoCodeUsecase      PromoCodeUsecase
	orderPromoCodeUsecase OrderPromoCodeUsecase
	orderDetailUsecase    OrderDetailUsecase
	productUsecase        product.ProductUsecase
	userUsecase           user.UserUsecase
	emailSvs              services.EmailService
}

func NewOrderUsecase(
	orderRepo order.OrderRepository,
	cartUsecase cart.CartUsecase,
	cartItemUsecase cart.CartItemUsecase,
	promoCodeUsecase PromoCodeUsecase,
	orderPromoCodeUsecase OrderPromoCodeUsecase,
	orderDetailUsecase OrderDetailUsecase,
	productUsecase product.ProductUsecase,
	userUsecase user.UserUsecase,
	emailSvs services.EmailService,
) OrderUsecase {
	return &orderUsecase{
		orderRepo:             orderRepo,
		cartUsecase:           cartUsecase,
		cartItemUsecase:       cartItemUsecase,
		promoCodeUsecase:      promoCodeUsecase,
		orderPromoCodeUsecase: orderPromoCodeUsecase,
		orderDetailUsecase:    orderDetailUsecase,
		productUsecase:        productUsecase,
		userUsecase:           userUsecase,
		emailSvs:              emailSvs,
	}
}

func (u *orderUsecase) CreateOrder(userID uint, cartID uint, promoCode string) (*models.Order, error) {
	// Sử dụng hàm CalculateOrderSummary để tính toán tổng tiền và giảm giá
	_, discount, grandTotal, err := u.CalculateOrderSummary(userID, cartID, promoCode)
	if err != nil {
		return nil, err
	}

	// Tạo đơn hàng mới
	order := &models.Order{
		UserID:     userID,
		CartID:     cartID,
		GrandTotal: grandTotal,
		Status:     "pending",
	}

	// Lưu đơn hàng vào cơ sở dữ liệu
	if err := u.orderRepo.CreateOrder(order); err != nil {
		return nil, err
	}

	// Lưu thông tin mã giảm giá cho đơn hàng (nếu có)
	if discount > 0 {
		promo, _ := u.promoCodeUsecase.GetPromoCodeByCode(promoCode) // Lấy mã giảm giá
		orderPromoCode := &models.OrderPromoCode{
			OrderID:     order.ID,
			PromoCodeID: promo.ID,
		}
		if err := u.orderPromoCodeUsecase.CreateOrderPromoCode(orderPromoCode); err != nil {
			return nil, err
		}
	}

	// Lấy chi tiết đơn hàng đầy đủ
	fullOrder, err := u.orderRepo.GetOrderWithDetails(order.ID)
	if err != nil {
		return nil, err
	}

	// Lấy danh sách sản phẩm trong giỏ hàng
	cartItems, err := u.cartItemUsecase.GetCartItemsByCartID(cartID)
	if err != nil {
		return nil, err
	}

	// Tạo chi tiết đơn hàng và cập nhật số lượng sản phẩm
	for _, cartItem := range cartItems {
		orderDetail := &models.OrderDetail{
			OrderID:    order.ID,
			ProductID:  cartItem.ProductID,
			Quantity:   cartItem.Quantity,
			UnitPrice:  cartItem.Product.Price,
			TotalPrice: float64(cartItem.Quantity) * cartItem.Product.Price,
		}
		if err := u.orderDetailUsecase.CreateOrderDetail(orderDetail); err != nil {
			return nil, err
		}

		// Cập nhật số lượng tồn kho của sản phẩm
		if err := u.productUsecase.UpdateStockNumber(cartItem.ProductID, cartItem.Quantity); err != nil {
			return nil, err
		}
	}

	// Xóa giỏ hàng sau khi đặt hàng
	if err := u.cartItemUsecase.ClearCart(cartID); err != nil {
		return nil, err
	}

	// Lấy thông tin người dùng để gửi email
	user, err := u.userUsecase.GetUserByID(userID)
	if err != nil {
		return nil, fmt.Errorf("failed to retrieve user: %w", err)
	}

	// Gửi email xác nhận đơn hàng
	if err := u.SendOrderDetails(fullOrder, user.Email); err != nil {
		return nil, err
	}

	return fullOrder, nil
}

func (u *orderUsecase) CalculateOrderSummary(userID uint, cartID uint, promoCode string) (float64, float64, float64, error) {
	// Lấy thông tin giỏ hàng
	cart, err := u.cartUsecase.GetCartByID(cartID)
	if err != nil || cart.UserID != userID {
		return 0, 0, 0, errors.New("cart not found or does not belong to the user")
	}

	// Tính tổng tiền giỏ hàng
	totalCost, err := u.cartItemUsecase.CalculateCartTotal(cartID)
	if err != nil {
		return 0, 0, 0, errors.New("calculate cart total failed")
	}

	discount := 0.0
	grandTotal := totalCost

	// Tính toán mã giảm giá (nếu có)
	if promoCode != "" {
		promo, err := u.promoCodeUsecase.GetPromoCodeByCode(promoCode)
		if err == nil && totalCost >= promo.MinimumOrderValue {
			discount = totalCost * (promo.DiscountPercentage / 100)
			grandTotal -= discount
		} else if err != nil {
			return 0, 0, 0, errors.New("promo code not found or does not meet minimum order value requirements")
		}
	}

	return totalCost, discount, grandTotal, nil
}

func (u *orderUsecase) UpdateOrder(order *models.Order) error {
	return u.orderRepo.UpdateOrder(order)
}

func (u *orderUsecase) DeleteOrder(order *models.Order) error {
	return u.orderRepo.DeleteOrder(order)
}

func (u *orderUsecase) GetOrderByID(id uint) (*models.Order, error) {
	return u.orderRepo.GetOrderByID(id)
}

func (u *orderUsecase) SearchOrderByPhoneNumber(phoneNumber string, page, pageSize int) ([]models.Order, error) {
	return u.orderRepo.SearchOrderByPhoneNumber(phoneNumber, page, pageSize)
}

func (u *orderUsecase) GetAllOrders(page, pageSize int) ([]models.Order, error) {
	return u.orderRepo.GetAllOrders(page, pageSize)
}

func (u *orderUsecase) GetOrdersByUserIDWithStatus(userID uint, status string, page int, size int) ([]*models.Order, error) {
	// Tính toán offset
	offset := (page - 1) * size

	// Khởi tạo danh sách đơn hàng
	var orders []*models.Order
	err := u.orderRepo.GetOrdersByUserIDWithStatus(userID, status, offset, size, &orders)
	if err != nil {
		return nil, err
	}

	return orders, nil
}

func (u *orderUsecase) SendOrderDetails(order *models.Order, userEmail string) error {
	// Tạo nội dung email cảm ơn và xác nhận đơn hàng
	emailBody := fmt.Sprintf("Thank you for your order\n\nOrder Confirmation\n\n-------------------------------------\nOrderID: %d\nGrand Total: %.2f\n", order.ID, order.GrandTotal)
	// Lấy thông tin chi tiết đơn hàng
	orderDetails, err := u.orderDetailUsecase.GetOrderDetailsByOrderID(order.ID)

	// Thêm thông tin sản phẩm vào nội dung email
	for _, detail := range orderDetails {
		productName := detail.Product.Name
		quantity := detail.Quantity
		unitPrice := detail.UnitPrice

		emailBody += fmt.Sprintf("\n-------------------------------------\nProduct: %s\nQuantity: %d\nUnit Price: %.2f\n\n", productName, quantity, unitPrice)
	}

	// Gửi email với tiêu đề "Xác nhận đơn hàng"
	subject := "Order Confirmation - Your Order Details"
	if err := u.emailSvs.SendEmail(userEmail, subject, emailBody); err != nil {
		return fmt.Errorf("failed to send order confirmation email: %w", err)
	}

	return err
}
