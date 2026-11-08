cat << 'EOF' > exec-frontend.sh
#!/bin/bash

# 1. Khởi chạy container Nginx và truyền biến môi trường
docker run -d --name rikkei-frontend-qa -e API_ENDPOINT=https://qa-api.rikkei.edu.vn nginx

# 2. Truy cập vào bash shell của container (Lệnh này yêu cầu tương tác tty)
# docker exec -it rikkei-frontend-qa bash

# 3. Lệnh kiểm tra biến môi trường khi đang ở bên trong container
# echo $API_ENDPOINT
EOF
