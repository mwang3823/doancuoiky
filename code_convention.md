# CRM E-Commerce Backend Project

## Project Overview
The CRM e-commerce backend supports the management of customer relationships, orders, products, inventory, and analytics for an online store. This system integrates with the front-end e-commerce platform, ensuring seamless operations and a unified view of customer interactions.

## Golang Code Convention

### 1. Formatting
- Use `gofmt` to format your code.
- Ensure all code is formatted before committing.

### 2. Naming Conventions
- Use camelCase for variable names and mixedCaps for function names.
- Use ALL_CAPS for constants.

### 3. Comments
- Write clear and concise comments.
- Use `//` for single-line comments and `/* */` for multi-line comments.

### 4. Error Handling
- Always check for errors and handle them appropriately.
- Use `if err != nil` to handle errors.

### 5. Packages
- Organize code into packages.
- Name packages using lowercase, short, and meaningful names.

### 6. Testing
- Write tests for all functions.
- Use `go test` to run tests.
- Ensure tests pass before committing.

### 7. Imports
- Organize imports into three groups: standard library, external packages, and internal packages.
- Use blank lines to separate these groups.

### 8. Code Structure
- Follow a consistent code structure for readability.
- Group related functions together.

### 9. Documentation
- Write comprehensive documentation for all packages, functions, and types.
- Use `godoc` conventions.

### 10. Version Control
- Use meaningful commit messages.
- Commit small, logical changes.


## Project Structure

A typical project structure following Clean Architecture in Golang can be organized as follows:  
```
crm-ecommerce-backend/
├── cmd/
│ └── app/
│ └── main.go
├── internal/
│ ├── config/
│ ├── domain/
│ │ ├── customer/
│ │ ├── order/
│ │ ├── product/
│ │ └── ...
│ ├── interfaces/
│ │ ├── http/
│ │ ├── database/
│ │ └── ...
│ ├── usecases/
│ │ ├── customer/
│ │ ├── order/
│ │ ├── product/
│ │ └── ...
│ ├── repositories/
│ │ ├── customer/
│ │ ├── order/
│ │ ├── product/
│ │ └── ...
│ ├── services/
│ │ ├── customer/
│ │ ├── order/
│ │ ├── product/
│ │ └── ...
│ └── utils/
└── pkg/
└── ...
```

## Layers Description

### 1. `cmd/`
This directory contains the entry point of the application.

- `main.go`: The main function to start the application.

### 2. `internal/`
Contains the core application code which is not exposed to the outside world.

#### a. `config/`
Contains configuration files and logic for the application.

#### b. `domain/`
Contains the business logic and entities of the application.

- **Entities**: Define the core business objects (e.g., Customer, Order, Product).

#### c. `interfaces/`
Contains the external interfaces and adapters.

- **HTTP**: Handles HTTP requests and responses.
- **Database**: Handles database operations.

#### d. `usecases/`
Contains the application-specific business rules.

- **Use Cases**: Define the operations that the system supports (e.g., CreateCustomer, GetOrderDetails).

#### e. `repositories/`
Contains the repository interfaces and their implementations.

- **Repositories**: Define the data access methods for the entities (e.g., CustomerRepository, OrderRepository).

#### f. `services/`
Contains the service interfaces and their implementations.

- **Services**: Define the business services (e.g., CustomerService, OrderService).

#### g. `utils/`
Contains utility functions and helpers.

### 3. `pkg/`
Contains reusable packages and libraries that can be shared across different projects.


## Code Structure Details

### Example: Customer Management

#### 1. `domain/customer/customer.go`  
```go
package customer

type Customer struct {
    ID    string
    Name  string
    Email string
    // other fields...
}
```

#### 2. `interfaces/http/customer_handler.go`
```go
package http

import (
    "net/http"
    "github.com/gin-gonic/gin"
    "crm-ecommerce-backend/internal/usecases/customer"
)

type CustomerHandler struct {
    CustomerUseCase customer.UseCase
}

func NewCustomerHandler(r *gin.Engine, useCase customer.UseCase) {
    handler := &CustomerHandler{
        CustomerUseCase: useCase,
    }
    r.POST("/customers", handler.CreateCustomer)
    r.GET("/customers/:id/create", handler.GetCustomer)
} 

func (h *CustomerHandler) CreateCustomer(c *gin.Context) {
    // implementation...
}

func (h *CustomerHandler) GetCustomer(c *gin.Context) {
    // implementation...
}
```

#### 3. `usecases/customer/usecase.go`
```go
package customer

type UseCase interface {
    CreateCustomer(customer Customer) error
    GetCustomer(id string) (Customer, error)
}

type useCase struct {
    repo Repository
}

func NewUseCase(repo Repository) UseCase {
    return &useCase{repo: repo}
}

func (u *useCase) CreateCustomer(customer Customer) error {
    // implementation...
}

func (u *useCase) GetCustomer(id string) (Customer, error) {
    // implementation...
}
```

#### 4. `repositories/customer/repository.go`
```go
package customer

type Repository interface {
    Save(customer Customer) error
    FindByID(id string) (Customer, error)
}

type repository struct {
    // db connection...
}

func NewRepository(/* db connection */) Repository {
    return &repository{/* db connection */}
}

func (r *repository) Save(customer Customer) error {
    // implementation...
}

func (r *repository) FindByID(id string) (Customer, error) {
    // implementation...
}
```

#### 5. `services/customer/service.go`
```go
package customer

type Service interface {
    RegisterCustomer(customer Customer) error
}

type service struct {
    useCase UseCase
}

func NewService(useCase UseCase) Service {
    return &service{useCase: useCase}
}

func (s *service) RegisterCustomer(customer Customer) error {
    // implementation...
}
```

---
