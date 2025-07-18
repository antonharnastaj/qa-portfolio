# 🧪 API Тест-кейсы для авторизации

## 📌 Endpoint

```
POST /api/login
```

**Content-Type:** `application/json`

Пример запроса:
```json
{
  "email": "eve.holt@reqres.in",
  "password": "cityslicka"
}
```

---

## ✅ Позитивные тест-кейсы

| ID         | Название                             | Метод | Тело запроса                                                                 | Ожидаемый ответ         |
|------------|---------------------------------------|--------|------------------------------------------------------------------------------|--------------------------|
| TC_API_01  | Успешная авторизация с email          | POST   | `{"username": "eve.holt@reqres.in", "password": "cityslicka"}`                     | `200 OK`, JWT токен      |
| TC_API_02  | Успешная авторизация с телефоном      | POST   | `{"username": "+79991234567", "password": "cityslicka"}`                         | `200 OK`, JWT токен      |
| TC_API_03  | Авторизация с пробелами в email       | POST   | `{"username": " eve.holt@reqres.in ", "password": "cityslicka"}`                   | `200 OK`, JWT токен      |

---

## ❌ Негативные тест-кейсы

| ID         | Название                             | Метод | Тело запроса                                                                 | Ожидаемый ответ         |
|------------|---------------------------------------|--------|------------------------------------------------------------------------------|--------------------------|
| TC_API_04  | Пустое тело запроса                   | POST   | `{}`                                                                         | `400 Bad Request`        |
| TC_API_05  | Неверный пароль                       | POST   | `{"username": "eve.holt@reqres.in", "password": "wrong"}`                      | `401 Unauthorized`       |
| TC_API_06  | Несуществующий пользователь           | POST   | `{"username": "nouser@mail.com", "password": "cityslicka"}`                      | `401 Unauthorized`       |
| TC_API_07  | Отсутствие поля `password`            | POST   | `{"username": "eve.holt@reqres.in"}`                                           | `400 Bad Request`        |
| TC_API_08  | SQL-инъекция                          | POST   | `{"username": "' OR 1=1 --", "password": "cityslicka"}`                          | `400/401`, не вход       |
| TC_API_09  | XSS в логине                          | POST   | `{"username": "<script>alert(1)</script>", "password": "cityslicka"}`            | `400 Bad Request`        |
| TC_API_10  | Короткий пароль                       | POST   | `{"username": "eve.holt@reqres.in", "password": "1"}`                          | `400 Bad Request`        |

---

## 🔒 Безопасность и ограничения

| ID         | Название                             | Метод  | Тело запроса                                        | Ожидаемый результат              |
|------------|---------------------------------------|---------|-----------------------------------------------------|----------------------------------|
| TC_API_11  | Невалидный JSON                       | POST    | `{username: "eve.holt@reqres.in", password:cityslicka}`      | `400 Bad Request`               |
| TC_API_12  | Проверка CORS                         | OPTIONS | -                                                   | `204 No Content` или `200 OK`   |
| TC_API_13  | Ограничение частоты запросов          | POST    | Множественные запросы > 5/сек                       | `429 Too Many Requests`         |
| TC_API_14  | Запрос по HTTP                        | POST    | - (отправка без HTTPS)                              | Ошибка клиента или блокировка   |

---

## 🧩 Примечания

- Все поля чувствительны к регистру.
- Ответ должен включать токен и его срок действия (если авторизация успешна).
- Поведение может отличаться в зависимости от реализации API.
