# Smart Credit MMB

**Smart Credit MMB** — проект интеллектуального кредитного кабинета для малого и микробизнеса.

Цель проекта — разработать веб-приложение с ИИ-ассистентом, который поможет предпринимателям подбирать кредитные продукты, оформлять заявки и отслеживать их статус.

> **Статус:** подготовка инфраструктуры к хакатону. На данном этапе реализован только технический фундамент, без полноценной бизнес-логики и ML-моделей.

## Технологический стек

| Компонент | Технологии |
|---|---|
| Backend | Python 3.12, FastAPI, Uvicorn |
| Database | PostgreSQL 17 |
| ORM | SQLAlchemy 2.x (AsyncSession) |
| Database driver | asyncpg |
| Infrastructure | Docker, Docker Compose |
| API | REST, OpenAPI |
| Frontend | Будет определён командой |
| ML | Python, библиотеки будут определены командой |
| Version Control | Git, GitHub |

## Структура проекта

```text
smart-credit-mmb/
├── backend/
│   ├── app/
│   │   ├── api/
│   │   │   └── routers/
│   │   │       └── health.py
│   │   ├── db/
│   │   │   └── database.py
│   │   └── main.py
│   ├── Dockerfile
│   ├── .dockerignore
│   └── requirements.txt
├── frontend/
├── ml/
├── docs/
│   └── schema.sql
├── .env.example
├── .gitignore
├── compose.yaml
└── README.md
```

### Назначение директорий

| Директория | Назначение |
|---|---|
| `backend/` | FastAPI, API и работа с базой данных |
| `frontend/` | Будущий пользовательский интерфейс |
| `ml/` | Будущие ML-модели и рекомендательные алгоритмы |
| `docs/` | SQL-схемы и документация проекта |

## Быстрый запуск

### Требования

Для запуска понадобятся:

- Git
- Docker
- Docker Compose

Локальная установка Python и PostgreSQL не требуется при использовании Docker.

### 1. Клонирование репозитория

```bash
git clone git@github.com:cemcerok/smart-credit-mmb.git
cd smart-credit-mmb
```

Репозиторий приватный. Для клонирования необходим доступ к нему и настроенная SSH-аутентификация GitHub.

### 2. Настройка переменных окружения

Создайте файл `.env` на основе примера:

```bash
cp .env.example .env
```

Содержимое `.env.example`:

```dotenv
POSTGRES_DB=credit_db
POSTGRES_USER=credit_user
POSTGRES_PASSWORD=change_me

DATABASE_URL=postgresql+asyncpg://credit_user:change_me@db:5432/credit_db
```

Замените `change_me` на собственный пароль в обеих переменных.

**Важно:** `.env` содержит секреты и не должен добавляться в Git. При использовании специальных символов в пароле для `DATABASE_URL` может потребоваться URL-кодирование.

### 3. Запуск контейнеров

Из корневой директории проекта:

```bash
docker compose up -d --build
```

Проверка состояния контейнеров:

```bash
docker compose ps
```

После запуска должны работать два сервиса:

| Сервис | Назначение |
|---|---|
| `backend` | FastAPI, порт 8000 |
| `db` | PostgreSQL, порт 5432 внутри Docker-сети |

### 4. Проверка API

После запуска откройте:

**Swagger UI:** http://localhost:8000/docs

**Проверка API:**

```bash
curl http://localhost:8000/health
```

Ожидаемый ответ:

```json
{"status":"ok"}
```

**Проверка подключения к PostgreSQL:**

```bash
curl http://localhost:8000/health/db
```

Ожидаемый ответ:

```json
{"status":"ok"}
```

Endpoint выполняет тестовый SQL-запрос `SELECT 1` через асинхронную сессию SQLAlchemy.

При первом запуске PostgreSQL может потребоваться некоторое время для инициализации.

## API endpoints

| Метод | Endpoint | Назначение |
|---|---|---|
| GET | `/` | Информация об API |
| GET | `/health` | Проверка работоспособности backend |
| GET | `/health/db` | Проверка соединения с PostgreSQL |
| GET | `/docs` | Swagger UI |

Полноценные API для пользователей, бизнеса, кредитных продуктов и заявок будут реализованы во время разработки MVP.

## База данных

Используется PostgreSQL 17 с асинхронным подключением через SQLAlchemy и asyncpg.

В `docs/schema.sql` определены четыре таблицы:

| Таблица | Назначение |
|---|---|
| `users` | Пользователи системы |
| `businesses` | Предприятия пользователей |
| `credit_products` | Кредитные продукты |
| `applications` | Кредитные заявки |

При первом запуске PostgreSQL с пустым Docker Volume SQL-скрипт выполняется автоматически.

Данные PostgreSQL сохраняются в именованном Docker Volume `postgres_data`.

Схема служит первоначальной заготовкой и может изменяться во время хакатона.

## Полезные Docker-команды

Просмотр логов backend:

```bash
docker compose logs -f backend
```

Просмотр логов PostgreSQL:

```bash
docker compose logs -f db
```

Открытие PostgreSQL CLI:

```bash
docker compose exec db psql -U credit_user -d credit_db
```

Просмотр таблиц внутри `psql`:

```sql
\dt
```

Остановка контейнеров:

```bash
docker compose down
```

Повторный запуск:

```bash
docker compose up -d
```

**Внимание:** команда `docker compose down -v` удаляет также Docker Volume с данными PostgreSQL. Не используйте её без необходимости.

## Организация командной разработки

Работа ведётся через GitHub и Pull Requests.

Основные правила:

1. `main` — стабильная ветка проекта.
2. Новые задачи выполняются в отдельных ветках, например `feature/credit-api`.
3. Для объединения изменений создаётся Pull Request в `main`.
4. Перед слиянием изменений проводится Code Review.
5. Секреты, `.env`, виртуальные окружения и временные файлы не добавляются в репозиторий.

### Распределение ролей

| Роль | Ответственность |
|---|---|
| Backend #1 / Team Lead | Архитектура, FastAPI, Docker, интеграция |
| Backend #2 | PostgreSQL, SQLAlchemy, бизнес-логика |
| Frontend Developer | Пользовательский интерфейс |
| Data Scientist / ML Engineer | ML и рекомендательная логика |
| Product / UX / Business Analyst | Требования, UX, пользовательские сценарии, презентация |

## Текущий статус

Технический фундамент включает:

- Базовое FastAPI-приложение.
- Dockerfile и Docker Compose.
- PostgreSQL 17.
- Асинхронное подключение через SQLAlchemy.
- Проверочные API endpoints.
- Начальную SQL-схему.
- Заготовки директорий frontend и ML.
- Пример переменных окружения.

Авторизация, кредитный скоринг, рекомендательные модели и полноценная бизнес-логика намеренно не входят в текущий этап подготовки.

## Дальнейшая разработка

На хакатоне команда планирует реализовать пользовательский интерфейс, работу с предпринимателями и кредитными продуктами, обработку заявок и интеграцию ИИ-ассистента.

Приоритет — работающий MVP с понятным пользовательским сценарием.
