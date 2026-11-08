cat << 'EOF' > setup-workspace.sh
#!/bin/bash

# 1. Tạo user mới có tên là rikkeilms
sudo useradd -m rikkeilms

# 2. Tạo thư mục gốc để chứa mã nguồn
sudo mkdir -p /opt/rikkei/course-service

# 3. Chuyển quyền sở hữu (owner & group) của thư mục cho user rikkeilms
sudo chown rikkeilms:rikkeilms /opt/rikkei/course-service

# 4. Phân quyền thư mục (drwxr-xr-x)
sudo chmod 755 /opt/rikkei/course-service

# 5. Lệnh kiểm tra trạng thái quyền
ls -ld /opt/rikkei/course-service
EOF
