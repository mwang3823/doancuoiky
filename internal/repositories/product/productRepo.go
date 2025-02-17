package product

import (
	"MSA-Project/internal/domain/models"

	"gorm.io/gorm"
)

type ProductRepository interface {
	CreateProduct(product *models.Product) error
	DeleteProduct(product *models.Product) error
	UpdateProduct(product *models.Product) error

	GetProductByID(id uint) (*models.Product, error)
	GetAllProducts(page, pageSize int) ([]models.Product, error)
	SearchProductsByName(name string, page, pageSize int) ([]models.Product, error)
	FilterAndSortProducts(size int, minPrice, maxPrice float64, color string, categoryID uint, page, pageSize int) ([]models.Product, error)
}

type productRepository struct {
	db *gorm.DB
}

func NewProductRepository(db *gorm.DB) ProductRepository {
	return &productRepository{db}
}

func (r *productRepository) CreateProduct(product *models.Product) error {
	return r.db.Create(product).Preload("Category").Preload("Manufacturer").First(product, product.ID).Error
}

func (r *productRepository) DeleteProduct(product *models.Product) error {
	return r.db.Delete(product).Error
}

func (r *productRepository) UpdateProduct(product *models.Product) error {
	err := r.db.Model(&models.Product{}).Where("id = ?", product.ID).Updates(map[string]interface{}{
		"name":            product.Name,
		"price":           product.Price,
		"image":           product.Image,
		"sales":           product.Sales,
		"size":            product.Size,
		"color":           product.Color,
		"specification":   product.Specification,
		"description":     product.Description,
		"expiry":          product.Expiry,
		"stock_number":    product.StockNumber,
		"stock_level":     product.StockLevel,
		"category_id":     product.CategoryID,
		"manufacturer_id": product.ManufacturerID,
	}).Error
	if err != nil {
		return err
	}

	return r.db.Preload("Category").Preload("Manufacturer").First(product, product.ID).Error
}

func (r *productRepository) GetProductByID(id uint) (*models.Product, error) {
	var product models.Product
	if err := r.db.Preload("Category").Preload("Manufacturer").Preload("OrderDetails").Preload("OrderDetails.Product").Preload("OrderDetails.Order").First(&product, id).Error; err != nil {
		return nil, err
	}
	return &product, nil
}

func (r *productRepository) GetAllProducts(page, pageSize int) ([]models.Product, error) {
	var products []models.Product
	err := r.db.Preload("Category").Preload("Manufacturer").Preload("OrderDetails").Preload("OrderDetails.Product").Preload("OrderDetails.Order").Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&products).Error
	return products, err
}

func (r *productRepository) SearchProductsByName(name string, page, pageSize int) ([]models.Product, error) {
	var products []models.Product
	err := r.db.Preload("Category").Preload("Manufacturer").Where("name LIKE ?", "%"+name+"%").
		Limit(pageSize).
		Offset((page - 1) * pageSize).
		Find(&products).Error
	return products, err
}

func (r *productRepository) FilterAndSortProducts(size int, minPrice, maxPrice float64, color string, categoryID uint, page, pageSize int) ([]models.Product, error) {
	var products []models.Product
	query := r.db.Preload("Category").Preload("Manufacturer").Where("1=1")

	if size > 0 {
		query = query.Where("size = ?", size)
	}
	if minPrice >= 0 {
		query = query.Where("price >= ?", minPrice)
	}
	if maxPrice > 0 {
		query = query.Where("price <= ?", maxPrice)
	}
	if color != "" {
		query = query.Where("color = ?", color)
	}
	if categoryID > 0 {
		query = query.Where("category_id = ?", categoryID)
	}

	query = query.Order("sales DESC").
		Limit(pageSize).
		Offset((page - 1) * pageSize)

	err := query.Find(&products).Error
	return products, err
}
