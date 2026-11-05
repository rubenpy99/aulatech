FROM node:22-alpine AS frontend
WORKDIR /app
COPY package*.json tsconfig.json ./
RUN npm ci
COPY frontend ./frontend
RUN npm run build
FROM python:3.13-slim
WORKDIR /app
COPY backend ./backend
COPY web ./web
COPY --from=frontend /app/web/dist ./web/dist
ENV HOST=0.0.0.0 PORT=8000 DATABASE_PATH=/app/data/aula.sqlite3
EXPOSE 8000
CMD ["python", "-m", "backend.server"]
