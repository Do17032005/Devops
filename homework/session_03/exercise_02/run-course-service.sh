cat << 'EOF' > run-course-service.sh
#!/bin/bash

# 1. Khởi chạy container Course-Service mock ở chế độ ngầm
docker run -d --name rikkei-course-service -p 8081:80 nginxdemos/hello

# 2. Kiểm tra danh sách container đang hoạt động
docker ps

# 3. Kiểm thử request đến service
curl http://localhost:8081
EOF
