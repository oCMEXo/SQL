# Инструкции по загрузке данных в OLTP базу данных

## Формат данных

- Несколько `.csv` файлов:
  1. `D:\Course_BD\data_for_oltp - Genres.csv`: Данные для `Genres`.
  2. `D:\Course_BD\data_for_oltp - Users.csv`: Данные для `Users`.
  3. `D:\Course_BD\data_for_oltp - Videos.csv`: Данные для `Videos`.
  4. `D:\Course_BD\data_for_oltp - Comments.csv`: Данные для `Comments`.
  5. `D:\Course_BD\data_for_oltp - Likes.csv`: Данные для `Likes`.
  6. `D:\Course_BD\data_for_oltp - Views.csv`: Данные для `Views`.
  7. `D:\Course_BD\data_for_oltp - Playlists.csv`: Данные для `Playlists`.
  8. `D:\Course_BD\data_for_oltp - PlaylistVideos.csv`: Данные для `PlaylistVideos`.
- Нет суррогатных ключей; используются естественные ключи (например, `username`, `title`).

## Процесс загрузки

1. Выполните `sql/schema.sql` для создания таблиц.
2. Убедитесь, что все `.csv` файлы доступны по путям (например, `D:\Course_BD\data_for_oltp - Genres.csv`) и настроены права доступа для пользователя PostgreSQL.
3. Выполните `sql/load_data.sql` в pgAdmin (запустите от администратора, если нужно). Если ошибка доступа, используйте `\copy` в psql.
4. Проверьте данные командами `SELECT * FROM table_name;`.

## Требования OLTP

- Данные поддерживают быстрые транзакции (вставка просмотров, лайков).
- Естественные ключи используются для начальной загрузки, суррогатные ключи генерируются базой.
