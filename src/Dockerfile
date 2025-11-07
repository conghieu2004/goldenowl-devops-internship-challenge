# GIAI ĐOẠN 1: Cài đặt Dependencies
FROM node:18-alpine AS deps

# 1. Tạo thư mục /app ảo BÊN TRONG IMAGE
WORKDIR /app

# 2. Copy CHỈ file package.json từ máy bạn VÀO /app
COPY package.json package-lock.json ./

# 3. Chạy npm ci BÊN TRONG /app
RUN npm ci --production

# ---

# GIAI ĐOẠN 2: Xây dựng Image Production
FROM node:18-alpine AS production

ENV NODE_ENV=production

# 4. Tạo thư mục /app ảo MỚI
WORKDIR /app

# 5. Copy node_modules đã cài đặt từ GIAI ĐOẠN 1
COPY --from=deps /app/node_modules ./node_modules

# 6. Copy TOÀN BỘ code (src/, index.js, v.v.) từ máy bạn VÀO /app
COPY . .

# 7. Mở cổng
EXPOSE 3000

# 8. Chạy file index.js (file này giờ đang nằm ở /app/index.js)
CMD ["node", "index.js"]