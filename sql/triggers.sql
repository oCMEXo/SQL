-- Файл: sql/triggers.sql
-- Описание: Триггеры для базы данных видеоконтента

-- Триггер для обновления view_count при добавлении просмотра
CREATE OR REPLACE FUNCTION update_view_count()
RETURNS TRIGGER AS $ $
BEGIN
  UPDATE
    Videos
  SET view_count = view_count + 1
  WHERE
    video_id = NEW.video_id;
  RETURN
  NEW;
END;
$ $
LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_view_count
AFTER INSERT
ON Views
FOR EACH ROW EXECUTE FUNCTION update_view_count();