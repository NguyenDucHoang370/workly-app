# Workly — Kế hoạch 12 tuần

Kế hoạch tham khảo cho nhóm 2 người; một người có thể làm nhưng cần giảm tính năng phụ và giữ tập trung vào demo end-to-end. Tuần 1–3 là phân tích/thiết kế; tuần 4–10 là triển khai theo sprint; tuần 11–12 dành cho kiểm thử và bàn giao.

| Tuần | Giai đoạn | Công việc | Kết quả |
|---|---|---|---|
| 1 | Khởi động | Chốt phạm vi, phân vai, repository, board công việc | Scope và backlog |
| 2 | Phân tích | Yêu cầu, use case, user story, luồng nghiệp vụ | SRS rút gọn |
| 3 | Thiết kế | Schema, kiến trúc, wireframe/UI kit, chuẩn bị Firebase | Tài liệu và prototype |
| 4 | Sprint 1 | Nền tảng app, theme, router, đăng nhập/chọn vai trò | Luồng xác thực |
| 5 | Sprint 2 | Hồ sơ Client/Freelancer, ảnh đại diện | Hồ sơ cơ bản |
| 6 | Sprint 3 | Tạo, xem, sửa, đóng job | Luồng đăng job |
| 7 | Sprint 4 | Tìm kiếm, lọc, danh mục, phân trang | Tìm được việc |
| 8 | Sprint 5 | Proposal, chấp nhận/từ chối, tạo contract | Luồng thuê việc |
| 9 | Sprint 6 | Chat realtime, file/ảnh nếu khả thi, thông báo | Trao đổi hai chiều |
| 10 | Sprint 7 | Nộp sản phẩm, yêu cầu sửa, nghiệm thu, đánh giá | Vòng đời MVP |
| 11 | Hoàn thiện | Unit/widget/manual test, sửa lỗi, UI, Security Rules | Release candidate |
| 12 | Bàn giao | Build Android/iOS, báo cáo, slide, demo/video | Bản bàn giao |

## Nếu chỉ có 10 tuần

Gộp tuần 1–3 thành khoảng 2 tuần; giới hạn thời gian thiết kế; ưu tiên Auth, hồ sơ tối thiểu, Job, Proposal/Contract và luồng nghiệm thu. Chat có thể giữ ở mức văn bản cơ bản; bỏ thanh toán, yêu thích, đa ngôn ngữ và các tính năng quản trị nâng cao.

## Nguyên tắc ưu tiên

1. Hoàn tất luồng Client đăng job → Freelancer gửi proposal → Client thuê.
2. Hoàn tất giao việc và nghiệm thu để demo được kết quả.
3. Đưa chat, thông báo và đánh giá vào phạm vi khi thời gian cho phép.
4. Không bắt đầu thanh toán thật hoặc tranh chấp trong MVP.
