# Устанавливаем базовый образ Node.js
FROM node:14.17-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем package.json и package-lock.json
COPY package*.json ./

# Устанавливаем зависимости
RUN npm install

# Копируем все файлы из директории проекта в контейнер
COPY . .

# Собираем проект
RUN npm run build

# Устанавливаем образ nginx в контейнер
FROM nginx:1.21-alpine

# Копируем собранные файлы из первого образа в образ nginx
COPY --from=0 /app/build /usr/share/nginx/html

# Копируем настройки nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт 80
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
