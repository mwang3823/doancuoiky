package order

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/repositories/order"
	"MSA-Project/internal/usecases/product"
)

type ReturnOrderUsecase interface {
	CreateReturnOrder(returnOrder *models.ReturnOrder) error
	UpdateReturnOrder(returnOrder *models.ReturnOrder) error
	DeleteReturnOrder(returnOrder *models.ReturnOrder) error

	GetReturnOrderByID(id uint) (*models.ReturnOrder, error)
	GetAllReturnOrders(page int, pageSize int) ([]models.ReturnOrder, error)
}

type returnOrderUsecase struct {
	returnOrderRepo    order.ReturnOrderRepository
	orderDetailUsecase OrderDetailUsecase
	productUsecase     product.ProductUsecase
	orderUsecase       OrderUsecase
}

func NewReturnOrderUsecase(returnOrderRepo order.ReturnOrderRepository, orderDetailUsecase OrderDetailUsecase,
	productUsecase product.ProductUsecase, orderUsecase OrderUsecase) ReturnOrderUsecase {
	return &returnOrderUsecase{returnOrderRepo, orderDetailUsecase, productUsecase, orderUsecase}
}

func (u *returnOrderUsecase) CreateReturnOrder(returnOrder *models.ReturnOrder) error {
	// Lấy thông tin đơn hàng dựa trên ID của đơn hàng trả lại
	order, err := u.orderUsecase.GetOrderByID(returnOrder.OrderID)
	if err != nil {
		return err
	}

	// Cập nhật trạng thái và số tiền hoàn lại cho đơn trả hàng
	returnOrder.Status = "success"              // Trạng thái mặc định của đơn trả hàng
	returnOrder.RefundAmount = order.GrandTotal // Số tiền hoàn lại bằng tổng tiền của đơn hàng gốc
	order.Status = "returned"                   // Cập nhật trạng thái đơn hàng gốc

	if err := u.orderUsecase.UpdateOrder(order); err != nil {
		return err
	}

	// Lưu đơn trả hàng vào cơ sở dữ liệu
	if err := u.returnOrderRepo.CreateReturnOrder(returnOrder); err != nil {
		return err
	}

	// Lấy chi tiết sản phẩm trong đơn hàng gốc
	orderDetails, err := u.orderDetailUsecase.GetOrderDetailsByOrderID(returnOrder.OrderID)
	if err != nil {
		return err
	}

	// Khôi phục số lượng sản phẩm trong kho cho từng sản phẩm của đơn hàng
	for _, orderDetail := range orderDetails {
		if err := u.productUsecase.RestoreStock(orderDetail.ProductID, orderDetail.Quantity); err != nil {
			return err
		}
	}

	return nil
}

func (u *returnOrderUsecase) UpdateReturnOrder(returnOrder *models.ReturnOrder) error {
	return u.returnOrderRepo.UpdateReturnOrder(returnOrder)
}

func (u *returnOrderUsecase) DeleteReturnOrder(returnOrder *models.ReturnOrder) error {
	return u.returnOrderRepo.DeleteReturnOrder(returnOrder)
}

func (u *returnOrderUsecase) GetReturnOrderByID(id uint) (*models.ReturnOrder, error) {
	return u.returnOrderRepo.GetReturnOrderByID(id)
}

func (u *returnOrderUsecase) GetAllReturnOrders(page int, pageSize int) ([]models.ReturnOrder, error) {
	return u.returnOrderRepo.GetAllReturnOrders(page, pageSize)
}
