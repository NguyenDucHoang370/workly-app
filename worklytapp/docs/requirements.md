# Workly — Yêu cầu và phạm vi MVP

## 1. Tổng quan

Workly kết nối Client có nhu cầu thuê người làm việc với Freelancer. Quy trình chính gồm đăng job, gửi proposal, trao đổi, chốt contract, giao/nộp việc, nghiệm thu và đánh giá.

## 2. Vai trò

- **Client:** đăng và quản lý job, xem proposal, chọn freelancer, nghiệm thu, đánh giá.
- **Freelancer:** tạo hồ sơ, tìm job, gửi proposal, trao đổi, nộp sản phẩm, đánh giá.
- **Admin:** duyệt/giám sát người dùng và xử lý báo cáo vi phạm. Công cụ quản trị có thể là web đơn giản hoặc màn hình nội bộ.

## 3. Mục tiêu và giới hạn MVP

- Chạy trên Android và iOS với một codebase.
- Demo được vòng đời công việc từ đăng job đến đánh giá.
- Không tích hợp thanh toán thật và không xây dựng hệ thống tranh chấp phức tạp trong MVP.
- Quy mô kế hoạch: 1–2 người, khoảng 10–12 tuần; cần giảm phạm vi nếu chỉ có một người hoặc thời gian ngắn hơn.

## 4. Yêu cầu chức năng

| Module | Phạm vi | Ưu tiên |
|---|---|---|
| Tài khoản | Email, Google, chọn vai trò, quên mật khẩu | Must |
| Hồ sơ | Thông tin Client; bio, kỹ năng, giá, portfolio của Freelancer | Must |
| Job | Đăng, sửa, đóng; mô tả, danh mục, ngân sách, deadline, kỹ năng | Must |
| Tìm kiếm | Từ khóa, bộ lọc, sắp xếp, phân trang | Must |
| Proposal | Freelancer gửi; Client xem, chấp nhận hoặc từ chối | Must |
| Contract | Tạo khi proposal được chấp nhận; theo dõi trạng thái | Must |
| Chat | Trao đổi realtime; ảnh/file nếu kịp | Must |
| Giao việc | Nộp sản phẩm, yêu cầu sửa, nghiệm thu | Should, nhưng cần cho demo trọn vòng đời |
| Đánh giá | Đánh giá hai chiều sau khi hoàn thành | Should, nhưng cần cho demo trọn vòng đời |
| Thông báo | Proposal mới, tin nhắn, thay đổi trạng thái | Should |
| Yêu thích | Lưu job hoặc freelancer | Could |
| Thanh toán | Ví/escrow giả lập hoặc tích hợp cổng thật | Could / ngoài MVP |
| Báo cáo, ngôn ngữ, giao diện tối | Tùy thời gian và yêu cầu môn học | Could |

## 5. Use case chính

- UC01: Đăng ký và chọn vai trò
- UC02: Hoàn thiện hồ sơ
- UC03: Client đăng job
- UC04: Freelancer tìm và xem job
- UC05: Freelancer gửi proposal
- UC06: Client duyệt proposal, chấp nhận/từ chối
- UC07: Client và Freelancer chat
- UC08: Freelancer nộp sản phẩm, Client yêu cầu sửa hoặc nghiệm thu
- UC09: Hai bên đánh giá sau khi hoàn thành

## 6. Vòng đời công việc

`Open → Có proposal → In Progress → Submitted → Completed → Reviewed`

Nhánh phụ: Client yêu cầu sửa thì quay lại `In Progress`; job/contract có thể bị `Cancelled` theo quy tắc nghiệp vụ được chốt trong thiết kế.

## 7. Yêu cầu phi chức năng

- Đa nền tảng Android/iOS.
- Danh sách hướng đến thời gian tải dưới 2 giây và có phân trang; cần xác nhận bằng môi trường kiểm thử thực tế.
- Giao tiếp HTTPS; phân quyền theo vai trò; không tự lưu mật khẩu dạng thô.
- Màn hình cần có trạng thái loading, empty và error.
- Tách lớp và module để có thể thay backend hoặc bổ sung tính năng.
