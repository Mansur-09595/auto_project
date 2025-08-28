#!/bin/bash

# Скрипт для запуска проекта локально с Docker

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

log "🚀 Запуск проекта локально с Docker..."

# Проверяем наличие Docker
if ! command -v docker &> /dev/null; then
    error "Docker не установлен. Установите Docker и попробуйте снова."
fi

if ! command -v docker-compose &> /dev/null; then
    error "Docker Compose не установлен. Установите Docker Compose и попробуйте снова."
fi

# Проверяем наличие файла переменных окружения
if [[ ! -f ".env.local" ]]; then
    warning "Файл .env.local не найден. Создаем из примера..."
    if [[ -f "env.local.example" ]]; then
        cp env.local.example .env.local
        warning "Создан файл .env.local из примера. Отредактируйте его и добавьте ваши AWS ключи."
        warning "Нажмите Enter после редактирования файла..."
        read
    else
        error "Файл env.local.example не найден. Создайте .env.local вручную."
    fi
fi

# Останавливаем существующие контейнеры
log "🛑 Останавливаем существующие контейнеры..."
docker-compose -f docker-compose.local.yml down --remove-orphans || true

# Удаляем старые образы (опционально)
if [[ "$1" == "--clean" ]]; then
    log "🧹 Удаляем старые образы..."
    docker system prune -f
    docker image prune -f
fi

# Собираем и запускаем контейнеры
log "🔨 Собираем и запускаем контейнеры..."
docker-compose -f docker-compose.local.yml up --build -d

# Ждем запуска базы данных
log "⏳ Ждем запуска базы данных..."
sleep 10

# Запускаем миграции
log "🗄️ Запускаем миграции базы данных..."
docker-compose -f docker-compose.local.yml exec -T app npx prisma db push || warning "Ошибка при выполнении миграций"

# Сидим тестовые данные (опционально)
if [[ "$2" == "--seed" ]]; then
    log "🌱 Сидим тестовые данные..."
    docker-compose -f docker-compose.local.yml exec -T app npm run db:seed || warning "Ошибка при сидинге данных"
fi

# Проверяем статус контейнеров
log "📊 Проверяем статус контейнеров..."
docker-compose -f docker-compose.local.yml ps

# Ждем запуска приложения
log "⏳ Ждем запуска приложения..."
sleep 15

# Проверяем здоровье приложения
log "🏥 Проверяем здоровье приложения..."
for i in {1..10}; do
    if curl -f http://localhost:3000/api/health > /dev/null 2>&1; then
        log "✅ Приложение успешно запущено!"
        break
    else
        warning "Попытка $i/10: Приложение еще не готово, ждем..."
        sleep 10
    fi
    
    if [[ $i -eq 10 ]]; then
        error "Приложение не запустилось в течение 100 секунд"
    fi
done

log "🎉 Проект успешно запущен!"
log "📱 Приложение доступно по адресу: http://localhost:3000"
log "🗄️ База данных доступна по адресу: localhost:5432"
log ""
log "📋 Полезные команды:"
log "  • Просмотр логов: docker-compose -f docker-compose.local.yml logs -f app"
log "  • Остановка: docker-compose -f docker-compose.local.yml down"
log "  • Перезапуск: docker-compose -f docker-compose.local.yml restart"
log "  • Обновление: ./start-local.sh --clean"
