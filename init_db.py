import sqlite3

# 1. Подключаемся к файлу базы данных (если его нет, Python создаст новый)
connection = sqlite3.connect("project.db")
cursor = connection.cursor()

# 2. Читаем ваш файл со структурой таблиц
with open("schema.sql", "r", encoding="utf-8") as file:
    sql_script = file.read()

# 3. Выполняем все SQL-команды из файла разом
cursor.executescript(sql_script)

# 4. Сохраняем изменения и закрываем соединение
connection.commit()
connection.close()

print("База данных успешно инициализирована!")