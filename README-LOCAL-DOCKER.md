# Локальный запуск с Docker

## 🚀 Быстрый старт

### 1. Подготовка

Убедитесь, что у вас установлены:
- Docker Desktop
- Docker Compose

### 2. Настройка переменных окружения

Скопируйте пример файла и настройте ваши AWS ключи:

```bash
# Linux/Mac
cp env.local.example .env.local

# Windows PowerShell
Copy-Item env.local.example .env.local
```

Отредактируйте `.env.local` и добавьте ваши реальные AWS ключи:

```env
# AWS S3 (обязательно)
AWS_ACCESS_KEY_ID=your_real_aws_access_key_id
AWS_SECRET_ACCESS_KEY=your_real_aws_secret_access_key
AWS_REGION=eu-north-1
AWS_S3_BUCKET=autodealer-images

# Остальные настройки можно оставить по умолчанию
```

### 3. Запуск

#### Linux/Mac:
```bash
chmod +x start-local.sh
./start-local.sh
```

#### Windows PowerShell:
```powershell
.\start-local.ps1
```

#### С тестовыми данными:
```bash
# Linux/Mac
./start-local.sh --seed

# Windows PowerShell
.\start-local.ps1 -Seed
```

#### С очисткой кэша:
```bash
# Linux/Mac
./start-local.sh --clean

# Windows PowerShell
.\start-local.ps1 -Clean
```

## 📱 Доступ к приложению

После успешного запуска:

- **Приложение**: http://localhost:3000
- **База данных**: localhost:5432
- **Prisma Studio**: http://localhost:5555 (если запущен)

## 🛠️ Управление

### Просмотр логов:
```bash
docker-compose -f docker-compose.local.yml logs -f app
```

### Остановка:
```bash
docker-compose -f docker-compose.local.yml down
```

### Перезапуск:
```bash
docker-compose -f docker-compose.local.yml restart
```

### Полная очистка:
```bash
docker-compose -f docker-compose.local.yml down -v
docker system prune -af
```

## 🔧 Разработка

### Hot Reload
Приложение настроено на автоматическую перезагрузку при изменении файлов.

### База данных
- PostgreSQL 15
- Данные сохраняются в Docker volume
- Автоматические миграции при запуске

### Переменные окружения
Все переменные окружения передаются в контейнер из файла `.env.local`.

## 🐛 Устранение неполадок

### Приложение не запускается
1. Проверьте логи: `docker-compose -f docker-compose.local.yml logs app`
2. Убедитесь, что порт 3000 свободен
3. Проверьте переменные окружения в `.env.local`

### Проблемы с базой данных
1. Проверьте логи: `docker-compose -f docker-compose.local.yml logs postgres`
2. Убедитесь, что порт 5432 свободен
3. Попробуйте пересоздать volume: `docker-compose -f docker-compose.local.yml down -v`

### Проблемы с AWS S3
1. Проверьте правильность AWS ключей в `.env.local`
2. Убедитесь, что у ключей есть права на S3 bucket
3. Проверьте регион AWS

### Очистка и перезапуск
```bash
# Полная очистка
docker-compose -f docker-compose.local.yml down -v
docker system prune -af

# Перезапуск
./start-local.sh --clean
```

## 📁 Структура файлов

```
├── docker-compose.local.yml    # Конфигурация для локальной разработки
├── Dockerfile.dev              # Dockerfile для разработки
├── start-local.sh              # Скрипт запуска (Linux/Mac)
├── start-local.ps1             # Скрипт запуска (Windows)
├── env.local.example           # Пример переменных окружения
└── .env.local                  # Ваши переменные окружения (создается автоматически)
```

## 🔄 Обновление

Для обновления кода:

1. Остановите контейнеры: `docker-compose -f docker-compose.local.yml down`
2. Обновите код (git pull)
3. Запустите заново: `./start-local.sh`

## 📊 Мониторинг

### Статус контейнеров:
```bash
docker-compose -f docker-compose.local.yml ps
```

### Использование ресурсов:
```bash
docker stats
```

### Логи всех сервисов:
```bash
docker-compose -f docker-compose.local.yml logs -f
```
