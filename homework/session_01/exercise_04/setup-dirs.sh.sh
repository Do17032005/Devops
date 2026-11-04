#!/bin/bash

# Kiểm tra quyền root
if [ "$EUID" -ne 0 ]; then
  echo "Vui lòng chạy script này với quyền root (sử dụng sudo)."
  exit 1
fi

echo "=== 1. Tạo thư mục làm việc của dự án /opt/quickbite/user-service ==="
sudo mkdir -p /opt/quickbite/user-service

echo "=== 2. Thay đổi chủ sở hữu và nhóm sở hữu thành quickbite:quickbite ==="
sudo chown -R quickbite:quickbite /opt/quickbite

echo "=== 3. Phân quyền truy cập 750 cho thư mục /opt/quickbite ==="
sudo chmod 750 /opt/quickbite

echo "=== Hoàn tất thiết lập thư mục và phân quyền! ==="