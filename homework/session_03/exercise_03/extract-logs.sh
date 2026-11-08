cat << 'EOF' > extract-logs.sh
#!/bin/bash

# Trích xuất 15 dòng log cuối cùng của container rikkei-course-service, kèm theo mốc thời gian
docker logs -t --tail 15 rikkei-course-service
EOF
