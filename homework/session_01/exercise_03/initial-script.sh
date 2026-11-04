#!/bin/bash

# Kiểm tra xem script có chạy với quyền root không
if [ "$EUID" -ne 0 ]; then
  echo "Vui lòng chạy script này với quyền root (sử dụng sudo)."
  exit 1
fi

echo "=== 1. Cập nhật hệ thống ==="
sudo apt-get update && sudo apt-get upgrade -y

echo "=== 2. Cài đặt các gói phần mềm bắt buộc (openjdk-17-jdk, git, curl) ==="
sudo apt-get install -y openjdk-17-jdk git curl

echo "=== 3. Kiểm tra và tạo group 'quickbite' nếu chưa tồn tại ==="
if getent group quickbite > /dev/null 2>&1; then
  echo "Nhóm 'quickbite' đã tồn tại."
else
  echo "Đang tạo nhóm 'quickbite'..."
  sudo groupadd quickbite
  echo "Đã tạo thành công nhóm 'quickbite'."
fi

echo "=== 4. Tạo tài khoản system user 'quickbite' thuộc nhóm 'quickbite' ==="
if id "quickbite" &>/dev/null; then
  echo "Tài khoản 'quickbite' đã tồn tại trên hệ thống."
else
  # -r: Tạo system account (thường có UID nhỏ hơn và không cần tạo home directory mặc định)
  # -g quickbite: Gán primary group là quickbite
  # -s /bin/false: Khóa quyền đăng nhập trực tiếp bằng cách gán shell là /bin/false
  # -M: Đảm bảo không tạo thư mục home cá nhân
  sudo useradd -r -g quickbite -s /bin/false -M quickbite
  echo "Đã tạo thành công tài khoản system user 'quickbite'."
fi

echo "=== Hoàn tất quá trình thiết lập môi trường ban đầu cho QuickBite! ==="