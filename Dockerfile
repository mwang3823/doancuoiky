# Sử dụng image Golang chính thức với phiên bản Alpine (nhẹ)
FROM golang:1.22.6-alpine

# Cài đặt các gói cần thiết cho CGO và SQLite
RUN apk add --no-cache gcc musl-dev

# Thiết lập thư mục làm việc trong container
WORKDIR /app

# Sao chép các file go.mod và go.sum vào container (nếu có)
COPY go.mod go.sum ./

# Tải các dependencies
RUN go mod download

# Sao chép toàn bộ mã nguồn vào container
COPY . .

# Build ứng dụng
ENV CGO_ENABLED=1
RUN go build -o main ./cmd  

# Khai báo cổng mà ứng dụng sẽ sử dụng
EXPOSE 8080

# Lệnh để chạy ứng dụng
CMD ["./main"]
