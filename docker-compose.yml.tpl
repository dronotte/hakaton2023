version: '3'

services:
  db:
    image: postgres:12-alpine
    environment:
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: ${POSTGRES_DB}
    volumes:
      - /var/lib/postgresql:/var/lib/postgresql
    ports:
      - "5432:5432"

  backend:
    image: dronotte/backend:${IMAGE_TAG}
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://db:5432/${POSTGRES_DB}
      SPRING_DATASOURCE_USERNAME: ${POSTGRES_USER}
      SPRING_DATASOURCE_PASSWORD: ${POSTGRES_PASSWORD}
      SPRING_JPA_HIBERNATE_DDL_AUTO: update
      SPRING_JPA_PROPERTIES_HIBERNATE_FORMAT_SQL: "true"
      SPRING_JPA_SHOW_SQL: "true"
    ports:
      - "8080:8080"
    depends_on:
      - db

  frontend:
    image: dronotte/frontend:${IMAGE_TAG}
    ports:
      - "3000:3000"

  nginx:
    image: nginx
    ports:
      - "80:80"
    depends_on:
      - frontend
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf