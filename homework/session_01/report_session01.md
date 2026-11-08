# BÁO CÁO THỰC HÀNH SESSION 01: THIẾT LẬP HẠ TẦNG VÀ TỰ ĐỘNG HÓA DEPLOY

## I. Nhiệm vụ 1: Thiết lập Hệ điều hành và Quản trị Phân quyền
Dưới đây là các câu lệnh Linux đã sử dụng để chuẩn bị môi trường phát triển tuân thủ nguyên tắc đặc quyền tối thiểu:

1. Tạo nhóm người dùng chuyên trách `quickbite-apps`:
   ```bash
   sudo groupadd quickbite-apps