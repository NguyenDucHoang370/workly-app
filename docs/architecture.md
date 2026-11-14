# Workly — Kiến trúc đề xuất

## 1. Lựa chọn cho MVP

Ưu tiên **Flutter + Firebase** để giảm thời gian dựng backend, có xác thực, dữ liệu realtime, lưu trữ file và push notification. Nếu môn học yêu cầu backend riêng, có thể cân nhắc Flutter + Node.js (NestJS/Express) + PostgreSQL + Socket.IO + REST API.

## 2. Thành phần công nghệ

| Tầng | Công nghệ đề xuất | Ghi chú |
|---|---|---|
| Mobile | Flutter / Dart | Một codebase cho Android và iOS |
| State management | Riverpod hoặc Bloc | Nhóm cần chọn một, không dùng lẫn tùy tiện |
| Điều hướng | go_router | Khai báo route và điều hướng |
| Authentication | Firebase Authentication | Email và Google |
| Database | Cloud Firestore | Dữ liệu nghiệp vụ và cập nhật realtime |
| File | Firebase Storage | Avatar, portfolio, file nộp bài |
| Push | Firebase Cloud Messaging | Thông báo thiết bị |
| Logic server | Cloud Functions (tùy chọn) | Tạo thông báo, tính rating, kiểm tra thao tác tin cậy |

## 3. Clean Architecture rút gọn

```text
lib/
├── core/        # theme, constants, router, utils, shared widgets
├── data/        # models, repositories implementations, data sources
├── domain/      # entities, repository contracts, use cases
└── features/    # auth, profile, jobs, proposals, chat, contracts, reviews
```

Mỗi feature có thể tổ chức theo `data/`, `domain/`, `presentation/` khi bắt đầu triển khai. Hiện tại repo chỉ lưu tài liệu và cấu trúc định hướng, chưa tạo implementation.

## 4. Nguyên tắc thiết kế

- Tách UI khỏi truy cập Firestore/Storage thông qua repository và data source.
- Dùng component dùng chung như JobCard, FreelancerCard, StatusChip và EmptyState.
- Có trạng thái loading, empty, error rõ ràng.
- Có thể denormalize một số dữ liệu hiển thị thường xuyên (ví dụ tên/avatar trong job, lastMessage trong chat), nhưng cần thống nhất cách cập nhật để tránh dữ liệu lệch.
- Security Rules phải giới hạn quyền đọc/ghi theo người dùng, vai trò và quan hệ với job/contract; không dựa vào kiểm tra phía giao diện בלבד.
- Không lưu thông tin bí mật hoặc mật khẩu thô trong ứng dụng.

## 5. Màn hình định hướng

Chung: Splash, onboarding, đăng nhập, đăng ký, chọn vai trò, quên mật khẩu.

- Client: Trang chủ, việc đã đăng, đăng việc, tin nhắn, hồ sơ.
- Freelancer: Trang chủ, tìm việc, proposal của tôi, tin nhắn, hồ sơ.
- Màn hình chi tiết: job, danh sách/chi tiết proposal, hồ sơ freelancer, contract/tiến độ, nộp sản phẩm, chat, đánh giá, thông báo, cài đặt.

Thiết kế UI có thể thực hiện trên Figma; đề xuất Material 3 và một màu chủ đạo nhất quán.
