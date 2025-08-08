# 🚀 Руководство по деплою на Render

## 📋 Предварительные требования

- Аккаунт на [Render.com](https://render.com)
- Репозиторий GitHub с кодом проекта
- Настроенная PostgreSQL база данных

## 🗄️ Шаг 1: Создание базы данных

1. Войдите в Render Dashboard
2. Нажмите "New" → "PostgreSQL"
3. Заполните параметры:
   - **Name**: `auto-project-db`
   - **Database**: `auto_project`
   - **User**: `auto_project_user`
   - **Region**: выберите ближайший регион
   - **Plan**: Free (для тестирования)

4. Нажмите "Create Database"
5. **Важно**: Скопируйте "External Database URL" - он понадобится для веб-сервиса

## 🌐 Шаг 2: Создание веб-сервиса

1. В Render Dashboard нажмите "New" → "Web Service"
2. Подключите ваш GitHub репозиторий
3. Заполните параметры:

### Основные настройки:
- **Name**: `auto-project`
- **Environment**: `Node`
- **Region**: тот же, что и для базы данных
- **Branch**: `main` (или ваша основная ветка)

### Команды сборки и запуска:
- **Build Command**: 
  ```bash
  npm ci && npm run build && npx prisma generate && npx prisma db push
  ```
- **Start Command**: 
  ```bash
  npm start
  ```

### Переменные окружения:
Добавьте следующие environment variables:

```env
NODE_ENV=production
DATABASE_URL=<URL_вашей_БД_из_шага_1>
NEXTAUTH_URL=https://ваше-название-app.onrender.com
NEXTAUTH_SECRET=ваш-секретный-ключ-минимум-32-символа
RENDER=true
```

**Где получить DATABASE_URL:**
1. Перейдите в созданную БД
2. Скопируйте "External Database URL"
3. Вставьте в переменную DATABASE_URL

4. **Plan**: Free (для тестирования)
5. Нажмите "Create Web Service"

## 🔧 Шаг 3: Автоматический деплой

Render автоматически:
1. Скачает код из репозитория
2. Установит зависимости (`npm ci`)
3. Соберет проект (`npm run build`)
4. Сгенерирует Prisma client (`npx prisma generate`)
5. Создаст таблицы в БД (`npx prisma db push`)
6. Запустит приложение (`npm start`)

## 🌱 Шаг 4: Инициализация данных (опционально)

После успешного деплоя можно добавить тестовые данные:

1. Откройте Render Shell для вашего сервиса
2. Выполните команду:
   ```bash
   npm run db:seed
   ```

## 📂 Шаг 5: Файлы и изображения

**Важно**: На Render файловая система эфемерна. Загруженные изображения сохраняются в `/tmp` и могут быть удалены при перезапуске.

Для production рекомендуется использовать:
- **Cloudinary** (изображения)
- **AWS S3** (файлы)
- **Google Cloud Storage** (файлы)

## 🔐 Шаг 6: Настройка домена (опционально)

1. В настройках сервиса перейдите в "Settings"
2. В разделе "Custom Domains" добавьте ваш домен
3. Обновите `NEXTAUTH_URL` на ваш домен

## 📊 Мониторинг и логи

- **Логи**: Render Dashboard → ваш сервис → "Logs"
- **Метрики**: Render Dashboard → ваш сервис → "Metrics"
- **Управление**: Restart, Force Deploy, Shell доступ

## 🐛 Возможные проблемы

### Ошибка подключения к БД
- Проверьте правильность DATABASE_URL
- Убедитесь, что БД и веб-сервис в одном регионе

### Ошибка сборки
- Проверьте команду сборки
- Убедитесь, что все зависимости в package.json

### Проблемы с Prisma
- Убедитесь, что `npx prisma generate` выполняется в build команде
- Проверьте schema.prisma на совместимость с PostgreSQL

### Файлы не загружаются
- Проверьте API endpoint `/api/files/[filename]`
- Для production настройте внешнее хранилище

## 🔄 Обновление приложения

1. Внесите изменения в код
2. Сделайте commit и push в GitHub
3. Render автоматически запустит новый деплой
4. Следите за процессом в логах

## 💰 Стоимость

**Free Plan включает:**
- 750 часов в месяц (веб-сервис)
- 1GB RAM
- PostgreSQL БД (90 дней, затем удаляется)

**Для production рекомендуется Starter Plan:**
- $7/месяц за веб-сервис
- $7/месяц за PostgreSQL БД

---

## 🆘 Поддержка

Если возникли проблемы:
1. Проверьте логи в Render Dashboard
2. Убедитесь в правильности переменных окружения
3. Проверьте статус БД и веб-сервиса
4. Обратитесь к документации Render: https://render.com/docs
