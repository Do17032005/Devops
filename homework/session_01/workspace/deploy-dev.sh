#!/bin/bash

# Kiểm tra quyền root (bắt buộc vì thao tác với /opt và quản lý tiến trình hệ thống)
if [ "$EUID" -ne 0 ]; then
  echo -e "\033[31m[ERROR] Vui lòng chạy script này với quyền root (sudo).\033[0m"
  exit 1
fi

# Nhận tham số dịch vụ đầu vào (ví dụ: user)
SERVICE_NAME=$1

if [ "$SERVICE_NAME" != "user" ]; then
  echo -e "\033[31m[ERROR] Tham số không hợp lệ! Sử dụng: ./deploy-dev.sh user\033[0m"
  exit 1
fi

# Khai báo biến cấu hình cho User Service
PORT=8080
TARGET_DIR="/opt/quickbite/dev/user-service"
RUN_USER="user-svc"

echo "=========================================="
echo " BẮT ĐẦU TRIỂN KHAI DỊCH VỤ: user-service "
echo "=========================================="

# Bước 1: Cập nhật mã nguồn mới nhất từ Git
echo "[1/5] Đang cập nhật mã nguồn từ Git (git pull)..."
git pull
if [ $? -ne 0 ]; then
  echo -e "\033[31m[ERROR] Lỗi khi thực hiện git pull!\033[0m"
  exit 1
fi

# Bước 2: Biên dịch Fail-fast với Gradle
echo "[2/5] Đang biên dịch ứng dụng (Gradle build)..."
chmod +x gradlew
./gradlew clean bootJar

# Kiểm tra mã lỗi ($?) theo cơ chế Fail-fast
if [ $? -ne 0 ]; then
  echo -e "\033[31m[FAIL-FAST] Biên dịch thất bại! Dừng script ngay lập tức.\033[0m"
  exit 1
fi

# Bước 3: Tắt tiến trình cũ đang chạy ở cổng 8080 (nếu có)
echo "[3/5] Kiểm tra và dừng tiến trình cũ đang chiếm cổng $PORT..."
PID=$(ss -lptn 'sport = :'$PORT | grep -oP 'pid=\K[0-9]+')
if [ -n "$PID" ]; then
  echo "Phát hiện tiến trình cũ (PID: $PID) đang chạy, đang tiến hành kill -9..."
  kill -9 $PID
else
  echo "Không có tiến trình nào đang chạy trên cổng $PORT."
fi

# Bước 4: Copy file JAR vào thư mục đích và phân quyền
echo "[4/5] Đang sao chép file JAR vào thư mục đích ($TARGET_DIR)..."
mkdir -p $TARGET_DIR
# Tìm file jar trong thư mục build/libs/
JAR_FILE=$(find build/libs -name "*.jar" | head -n 1)

if [ -z "$JAR_FILE" ]; then
  echo -e "\033[31m[ERROR] Không tìm thấy file .jar sau khi build!\033[0m"
  exit 1
fi

cp $JAR_FILE $TARGET_DIR/user-service.jar
chown -R $RUN_USER:$RUN_USER $TARGET_DIR

echo "[5/5] Đang khởi động ứng dụng ngầm dưới quyền user: $RUN_USER..."
cd $TARGET_DIR

# Chạy ngầm ứng dụng bằng nohup với quyền của user-svc
sudo -u $RUN_USER nohup java -jar user-service.jar > app.log 2>&1 &

echo -e "\033[32m[SUCCESS] Triển khai thành công dịch vụ user-service trên cổng $PORT!\033[0m"