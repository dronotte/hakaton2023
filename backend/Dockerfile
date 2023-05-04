# Устанавливаем базовый образ с JDK 11
FROM adoptopenjdk/openjdk11:jdk-11.0.11_9-alpine

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем сборку проекта в контейнер
COPY build/libs/*.jar app.jar

# Открываем порт 8080
EXPOSE 8080

# Запускаем приложение
CMD ["java", "-jar", "app.jar"]
