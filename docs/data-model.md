# Workly — Mô hình dữ liệu gợi ý

Mô hình dưới đây là khởi điểm cho thiết kế Firestore; cần chốt schema, quy tắc truy cập và chiến lược truy vấn trước khi triển khai.

## Collection / thực thể

```text
users
  id, email, displayName, avatarUrl, role, createdAt

freelancer_profiles
  userId, bio, skills[], hourlyRate, portfolio[], ratingAvg, ratingCount

client_profiles
  userId, company, location

categories
  id, name, icon

jobs
  id, clientId, title, description, categoryId, skills[], budgetMin, budgetMax,
  deadline, status, createdAt

proposals
  id, jobId, freelancerId, price, duration, coverLetter, status, createdAt

contracts
  id, jobId, proposalId, clientId, freelancerId, agreedPrice, status,
  startedAt, completedAt

submissions
  id, contractId, files[], note, status

chats
  id, participantIds[], jobId, lastMessage, updatedAt
  messages subcollection: senderId, text, fileUrl, createdAt, isRead

reviews
  id, contractId, fromUserId, toUserId, rating, comment

notifications
  id, userId, type, refId, isRead, createdAt

favorites
  userId, targetType, targetId
```

## Quan hệ chính

- User 1–1 Client profile hoặc Freelancer profile.
- Client 1–N Job.
- Job 1–N Proposal.
- Proposal 1–0..1 Contract.
- Contract 1–N Submission.
- Contract có tối đa hai đánh giá, mỗi bên một đánh giá.

## Lưu ý Firestore

- Thiết kế collection/subcollection dựa trên truy vấn thực tế; Firestore không có join quan hệ kiểu SQL.
- Denormalize có kiểm soát các trường thường xuyên hiển thị như tên/avatar người đăng hoặc nội dung tin nhắn cuối.
- Lập chỉ mục cho các truy vấn lọc/sắp xếp cần thiết.
- Viết và kiểm thử Security Rules theo vai trò, chủ sở hữu và participant; quy tắc phải ngăn client tự sửa các trạng thái nhạy cảm trái phép.
- Xem xét giới hạn kích thước và quyền truy cập file trong Storage Rules.
