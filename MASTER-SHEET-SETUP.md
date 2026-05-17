# AgentWell — Master Client Sheet (CRM Trung tâm)

## Tổng quan

Một Google Sheet duy nhất quản lý toàn bộ khách hàng AgentWell.
Tất cả shared workflows đọc từ sheet này — thêm khách mới chỉ cần thêm 1 dòng.

---

## Bước 1 — Tạo Google Sheet

1. Vào **sheets.google.com** → Tạo mới → Đặt tên: `AgentWell — Master Clients`
2. Copy **Sheet ID** từ URL:
   ```
   https://docs.google.com/spreadsheets/d/[SHEET_ID_NẰM_ĐÂY]/edit
   ```
3. Dán vào n8n: **Settings → Variables → MASTER_SHEET_ID = [ID vừa copy]**

---

## Bước 2 — Cấu trúc cột (Row 1 = Header)

| Cột | Tên Header | Ví dụ | Mô tả |
|-----|-----------|-------|-------|
| A | client_id | AW001 | ID duy nhất, không đổi |
| B | name | Mia Spa | Tên doanh nghiệp |
| C | owner_name | Nguyễn Thị Lan | Tên chủ |
| D | phone | 0901234567 | SĐT liên hệ |
| E | package | growth | starter / growth / scale |
| F | start_date | 01/06/2026 | Định dạng DD/MM/YYYY |
| G | end_date | 30/06/2026 | Định dạng DD/MM/YYYY |
| H | status | active | active / expired / suspended |
| I | telegram_chat_id | 123456789 | ID Telegram của chủ |
| J | booking_sheet_id | 1BxKabc123... | Google Sheet ID booking của khách |
| K | zalo_access_token | at.abc123... | Access token Zalo OA |
| L | zalo_oa_id | 123456 | OA ID của Zalo |
| M | monthly_price | 4900000 | Số tiền VND/tháng |
| N | ai_context | Resort 3 sao, phòng view biển, 1.2-2.5tr/đêm | Mô tả ngắn cho AI chatbot |
| O | notes | Khách đầu tiên, setup xong 05/06 | Ghi chú nội bộ |

---

## Bước 3 — Dữ liệu mẫu (copy vào Row 2)

```
AW001 | Mia Spa & Wellness | Nguyễn Thị Lan | 0901234567 | growth | 01/06/2026 | 30/06/2026 | active | 123456789 | 1BxK... | at.xxx | 111111 | 4900000 | Spa cao cấp tại Đà Nẵng, dịch vụ massage, chăm sóc da, yoga | Khách Growth đầu tiên
```

---

## Bước 4 — Cấp quyền Service Account

Chia sẻ sheet với Service Account email của Google Sheets trong n8n:
1. Sheet → **Share** → Paste email service account (dạng `...@...iam.gserviceaccount.com`)
2. Quyền: **Viewer** (chỉ cần đọc) hoặc **Editor** (nếu muốn workflow cập nhật status)

---

## Bước 5 — Set biến môi trường trong n8n (Railway)

Vào Railway → n8n service → **Variables** → Thêm:

```
MASTER_SHEET_ID = [ID sheet vừa tạo]
OWNER_TELEGRAM_ID = 7970044894
```

---

## Quy tắc quản lý

### Thêm khách mới
1. Thêm 1 dòng mới vào sheet
2. Điền đầy đủ thông tin
3. **status = active**
4. Các workflows tự động nhận diện ngay lần chạy tiếp theo

### Khi khách hết hạn
1. Vào n8n → tắt workflow của khách đó
2. Đổi **status = expired** trong sheet
3. Subscription Manager sẽ KHÔNG gửi nhắc thêm cho expired clients

### Khi khách gia hạn
1. Cập nhật **end_date** sang tháng mới
2. Bật lại workflow trong n8n
3. **status = active**

### Khi tạm ngưng dịch vụ (chưa hết hạn)
- Đổi **status = suspended**
- Tắt workflow trong n8n

---

## Lấy Telegram Chat ID của khách

Hướng dẫn khách:
1. Tìm bot `@userinfobot` trên Telegram
2. Gửi `/start`
3. Bot trả về: `Id: 123456789` — đó là chat ID

---

## Lưu ý quan trọng

- **client_id** không bao giờ thay đổi, dùng để identify trong tất cả workflows
- **booking_sheet_id** là ID sheet Google Sheets của KHÁCH (họ tự có), không phải Master Sheet
- **zalo_access_token** hết hạn sau 90 ngày — cần cập nhật định kỳ từ Zalo Developer Console
- Định dạng ngày bắt buộc: **DD/MM/YYYY** (01/06/2026, không phải 1/6/2026)
