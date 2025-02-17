package config

import (
	"MSA-Project/internal/domain/models"
	"MSA-Project/internal/interfaces/http"
	"MSA-Project/internal/utils"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	database, err := gorm.Open(sqlite.Open("msa.db?_busy_timeout=5000"), &gorm.Config{})
	if err != nil {
		log.Fatal("Failed to connect to database!")
		os.Exit(1)
	}

	database.AutoMigrate(&models.User{}, &models.Product{}, &models.Manufacturer{}, &models.Category{}, &models.Cart{},
		&models.CartItem{}, &models.Delivery{}, &models.DeliveryDetails{}, &models.Feedback{}, &models.Payment{},
		&models.Order{}, &models.OrderDetail{}, &models.OrderPromoCode{}, &models.PromoCode{}, &models.ReturnOrder{})

	DB = database
}

func UserRoutes(router *gin.Engine, userHandler http.UserHandler) {
	users := router.Group("/users")
	{
		users.POST("/register", userHandler.RegisterUser)
		users.POST("/login", userHandler.Login)
		users.POST("/verify", userHandler.VerifyOTP)
		users.POST("/login/google", userHandler.LoginWithGoogle)
		users.POST("/resetpass", userHandler.GetNewPassword)

		secured := users.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.DELETE("/:id", userHandler.DeleteUser)
			secured.PUT("/:id/password", userHandler.UpdateUser)
			secured.PUT("/:id", userHandler.UpdateUserInf)
			secured.GET("/:id", userHandler.GetUserById)
			secured.GET("/", userHandler.GetAllUsers)
			secured.GET("/phone/:phone", userHandler.GetUserByPhoneNumber)
		}
	}
}

func ProductRoutes(router *gin.Engine, productHandler http.ProductHandler) {
	products := router.Group("/products")
	{
		products.GET("/", productHandler.GetAllProducts)
		products.GET("/:id", productHandler.GetProductByID)
		products.GET("/search", productHandler.SearchProducts)        //http://localhost:8080/products/search?name=Headphones&page=1&pageSize=10
		products.GET("/filter", productHandler.FilterAndSortProducts) //http://localhost:8080/products/filter?size=5&min_price=50&max_price=200&color=Black&category_id=2&page=1&pageSize=10

		secured := products.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", productHandler.CreateProduct)
			secured.PUT("/:id", productHandler.UpdateProduct)
			secured.DELETE("/:id", productHandler.DeleteProduct)
		}
	}
}

func CategoryRoutes(router *gin.Engine, categoryHandler http.CategoryHandler) {
	categories := router.Group("/categories")
	{
		categories.GET("/", categoryHandler.GetAllCategories)
		categories.GET("/:id", categoryHandler.GetCategoryByID)

		secured := categories.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", categoryHandler.CreateCategory)
			secured.PUT("/:id", categoryHandler.UpdateCategory)
			secured.DELETE("/:id", categoryHandler.DeleteCategory)
		}
	}
}

func ManufacturerRoutes(router *gin.Engine, manufacturerHandler http.ManufacturerHandler) {
	manufacturers := router.Group("/manufacturers")
	{
		manufacturers.GET("/", manufacturerHandler.GetAllManufacturers)
		manufacturers.GET("/:id", manufacturerHandler.GetManufacturerByID)

		secured := manufacturers.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.PUT("/:id", manufacturerHandler.UpdateManufacturer)
			secured.DELETE("/:id", manufacturerHandler.DeleteManufacturer)
			secured.POST("/", manufacturerHandler.CreateManufacturer)
		}
	}
}

func CartRoutes(router *gin.Engine, cartHandler http.CartHandler) {
	carts := router.Group("/carts")
	{

		secured := carts.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", cartHandler.CreateCart)
			secured.POST("/:user_id", cartHandler.GetOrCreateCartForUser)
			// secured.PUT("/:id", cartHandler.UpdateCart)
			secured.DELETE("/:id", cartHandler.DeleteCart)
			secured.GET("/:id", cartHandler.GetCartByID)
		}
	}
}

func CartItemRoutes(router *gin.Engine, cartitemHandler http.CartItemHandler) {
	cartitems := router.Group("/cartitems")
	{
		secured := cartitems.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/addproduct/:cartID", cartitemHandler.AddProductToCart)
			secured.POST("/clearcart", cartitemHandler.ClearCart)
			secured.PUT("/:id", cartitemHandler.UpdateCartItem)
			secured.PUT("/", cartitemHandler.UpdateCartItemsStatus)
			secured.DELETE("/:id", cartitemHandler.DeleteCartItem)
			secured.GET("/:id", cartitemHandler.GetCartItemByID)
			secured.GET("/carts/:cartID", cartitemHandler.GetCartItemsByCartID)
			secured.GET("/carts/all/:cartID", cartitemHandler.GetAllCartItemsByCartID)
		}
	}
}

func OrderDetailRoutes(router *gin.Engine, orderdetailHandler http.OrderDetailHandler) {
	orderdetails := router.Group("/orderdetails")
	{
		secured := orderdetails.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", orderdetailHandler.CreateOrderDetail)
			// secured.PUT("/:id", orderdetailHandler.UpdateOrderDetail)
			secured.DELETE("/:id", orderdetailHandler.DeleteOrderDetail)
			secured.GET("/:id", orderdetailHandler.GetOrderDetailByID)
		}
	}
}

func OrderPromoCodeRoutes(router *gin.Engine, orderPromoCodeHandler http.OrderPromoCodeHandler) {
	orderpromocodes := router.Group("/orderpromocodes")
	{
		secured := orderpromocodes.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", orderPromoCodeHandler.CreateOrderPromoCode)
			// secured.PUT("/:id", orderPromoCodeHandler.UpdateOrderPromoCode)
			secured.DELETE("/:id", orderPromoCodeHandler.DeleteOrderPromoCode)
			secured.GET("/:id", orderPromoCodeHandler.GetOrderPromoCodeByID)
		}
	}
}

func OrderRoutes(router *gin.Engine, orderHandler http.OrderHandler) {
	orders := router.Group("/orders")
	{
		secured := orders.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", orderHandler.CreateOrder) //http://localhost:8080/orders?user_id=1&cart_id=1&promo_code=BLACKFRIDAY
			secured.PUT("/:id", orderHandler.UpdateOrder)
			secured.DELETE("/:id", orderHandler.DeleteOrder)
			secured.GET("/:id", orderHandler.GetOrderByID)
			secured.GET("/", orderHandler.GetAllOrders)
			secured.GET("/preview-order", orderHandler.PreviewOrder) //http://localhost:8080/orders/preview-order?user_id=1&cart_id=1&promo_code=NY2024
			secured.GET("history/:user_id/:status", orderHandler.GetOrdersByStatus)
			secured.GET("/search", orderHandler.SearchOrderByPhoneNumber)
		}
	}
}

func PromoCodeRoutes(router *gin.Engine, promoCodeHandler http.PromoCodeHandler) {
	promocodes := router.Group("/promocodes")
	{
		promocodes.GET("/:id", promoCodeHandler.GetPromoCodeByID)

		secured := promocodes.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", promoCodeHandler.CreatePromoCode)
			secured.PUT("/:id", promoCodeHandler.UpdatePromoCode)
			secured.DELETE("/:id", promoCodeHandler.DeletePromoCode)

			secured.GET("/code/:code", promoCodeHandler.GetPromoCodeByCode)
			secured.GET("/", promoCodeHandler.GetAllPromocodes)
		}
	}
}

func FeedbackRoutes(router *gin.Engine, feedbackHandler http.FeedbackHandler) {
	feedbacks := router.Group("/feedbacks")
	{
		feedbacks.GET("/:id", feedbackHandler.GetFeedbackByID)

		secured := feedbacks.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", feedbackHandler.CreateFeedback)
			secured.PUT("/:id", feedbackHandler.UpdateFeedback)
			secured.DELETE("/:id", feedbackHandler.DeleteFeedback)
			secured.GET("/product/:product_id", feedbackHandler.GetAllFeedbacksByProductID)
		}
	}
}

func ReturnOrderRoutes(router *gin.Engine, returnOrderHandler http.ReturnOrderHandler) {
	returnorders := router.Group("/returnorders")
	{
		secured := returnorders.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/:order_id", returnOrderHandler.CreateReturnOrder)
			// secured.PUT("/:id", returnOrderHandler.UpdateReturnOrder)
			secured.DELETE("/:id", returnOrderHandler.DeleteReturnOrder)

			secured.GET("/all", returnOrderHandler.GetAllReturnOrders)
			secured.GET("/:id", returnOrderHandler.GetReturnOrderByID)
		}
	}
}

func PaymentRoutes(router *gin.Engine, paymentHandler http.PaymentHandler) {
	payments := router.Group("/payments")
	{
		secured := payments.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/:user_id/:order_id", paymentHandler.CreatePayment)
			secured.PUT("/:id", paymentHandler.UpdatePayment)
			secured.DELETE("/:id", paymentHandler.DeletePayment)

			secured.GET("/all", paymentHandler.GetAllPayments)
			secured.GET("/:id", paymentHandler.GetPaymentByID)
		}
	}
}

func DeliveryRoutes(router *gin.Engine, deliveryHandler http.DeliveryHandler) {
	deliveries := router.Group("/deliveries")
	{
		secured := deliveries.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/:user_id/:order_id", deliveryHandler.CreateDelivery)
			secured.PUT("/:id", deliveryHandler.UpdateDelivery)
			secured.DELETE("/:id", deliveryHandler.DeleteDelivery)

			secured.GET("/:id", deliveryHandler.GetDeliveryByID)
		}
	}
}

func DeliveryDetailRoutes(router *gin.Engine, deliveryDetailHandler http.DeliveryDetailHandler) {
	deliverydetails := router.Group("/deliverydetails")
	{
		secured := deliverydetails.Group("/")
		secured.Use(utils.AuthRequired())
		{
			secured.POST("/", deliveryDetailHandler.CreateDeliveryDetail)
			secured.PUT("/:id", deliveryDetailHandler.UpdateDeliveryDetail)
			secured.DELETE("/:id", deliveryDetailHandler.DeleteDeliveryDetail)

			secured.GET("/:id", deliveryDetailHandler.GetDeliveryDetailByID)
			secured.GET("/", deliveryDetailHandler.GetAllDeliveryDetails)
			secured.GET("/delivery/:delivery_id", deliveryDetailHandler.GetAllDeliveryDetailsByDeliveryID)
		}
	}
}
