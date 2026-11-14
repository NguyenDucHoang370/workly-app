# Workly

Workly là ứng dụng kết nối Khách hàng (Client) cần thuê người làm việc với Freelancer. Repo này chứa cấu trúc dự án và tài liệu phân tích/kế hoạch cho MVP; **chưa triển khai code nghiệp vụ**.

## Mục tiêu MVP

Hoàn thiện vòng đời công việc: **đăng job → gửi proposal → chấp nhận và tạo contract → trao đổi → nộp sản phẩm → nghiệm thu → đánh giá**. MVP dự kiến chạy trên Android và iOS bằng một codebase Flutter. Thanh toán thật và xử lý tranh chấp phức tạp nằm ngoài phạm vi ban đầu.

## Vai trò

- **Client:** đăng job, duyệt proposal, thuê freelancer, nghiệm thu và đánh giá.
- **Freelancer:** hoàn thiện hồ sơ, tìm job, gửi proposal, nộp sản phẩm và nhận đánh giá.
- **Admin:** giám sát người dùng và xử lý báo cáo vi phạm; có thể làm giao diện web đơn giản hoặc màn hình quản trị nội bộ.

## Công nghệ đề xuất

- Flutter + Dart
- Chọn thống nhất một state management: Riverpod **hoặc** Bloc
- go_router
- Firebase Authentication, Cloud Firestore, Firebase Storage, Firebase Cloud Messaging
- Cloud Functions khi cần xử lý nghiệp vụ phía server

Phương án backend riêng nếu có yêu cầu: Flutter + Node.js (NestJS/Express) + PostgreSQL + Socket.IO + REST API.

## Cấu trúc dự kiến

```text
.
├── docs/                 # Phân tích, kiến trúc, mô hình dữ liệu, kế hoạch
├── lib/
│   ├── core/             # Theme, constants, router, utils, shared widgets
│   ├── data/             # Models, repositories, data sources
│   ├── domain/           # Entities, repository interfaces, use cases
│   └── features/         # auth, profile, jobs, proposals, chat, contracts, reviews
├── test/                 # Unit, widget, integration tests
├── assets/               # Images, icons, fonts
├── analysis_options.yaml
├── pubspec.yaml
└── README.md
```

Các thư mục Flutter ở trên hiện là cấu trúc định hướng; repo chưa có code ứng dụng.

## Tài liệu

- [Yêu cầu và phạm vi MVP](docs/requirements.md)
- [Kiến trúc đề xuất](docs/architecture.md)
- [Mô hình dữ liệu](docs/data-model.md)
- [Kế hoạch 12 tuần](docs/roadmap.md)

## Phạm vi tính năng

**Must:** tài khoản, hồ sơ, đăng và tìm job, proposal, contract, chat.  
**Should:** nộp sản phẩm, nghiệm thu, đánh giá, push notification.  
**Could / để mở rộng:** yêu thích, thanh toán giả lập hoặc thật, báo cáo, đa ngôn ngữ, dark mode.

## Giả định kế hoạch

Kế hoạch hiện giả định nhóm 2 người (có thể một người đảm nhiệm toàn bộ) và thời lượng 10–12 tuần. Lộ trình chi tiết trong tài liệu đang chia thành 12 tuần; nếu thời gian thực tế ngắn hơn, nên ưu tiên luồng MVP đầu-cuối và giảm tính năng Should/Could.

## Trạng thái

Repo đang ở giai đoạn **scaffold tài liệu và cấu trúc**, chưa có mã nguồn ứng dụng hoặc cấu hình Firebase thực tế.
