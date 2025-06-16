
# 📘 Documentation: Loading Data into OLTP and OLAP Databases

## 📥 1. Loading Data into the OLTP Database (`video_content_db`)

### 📁 Data Format

Source data is provided as several `.csv` files:

- `Genres.csv` – video genres  
- `Users.csv` – users  
- `Videos.csv` – videos  
- `Comments.csv` – comments  
- `Likes.csv` – likes  
- `Views.csv` – video views  
- `Playlists.csv` – playlists  
- `PlaylistVideos.csv` – playlist contents  

📂 **File path:**  
`D:\Course_BD\data_for_oltp`

📌 **Note:**  
**Natural keys** are used (e.g., `username`, `title`), **no surrogate keys**.

---

### ⚙️ Loading Process

1. Open `pgAdmin`.
2. Execute the `sql/schema.sql` file to create the table structure.
3. Ensure the `.csv` files are located in `D:\Course_BD\data_for_oltp`.
4. Run `sql/load_data.sql` **as an administrator**.
5. Verify data with:

   ```sql
   SELECT * FROM table_name;
   ```

---

### ✅ OLTP Requirements

- Support for high-frequency transactions (e.g., view insertions).
- Use of **natural keys**.
- No data aggregation — only raw transactional data.

---

## 📥 2. Loading Data into the OLAP Database (`olap_video_analytics`)

### 📁 Data Format

The same `.csv` files are used as in the OLTP process:

- `Genres.csv`, `Users.csv`, `Videos.csv`, `Comments.csv`, `Likes.csv`, `Views.csv`, `Playlists.csv`, `PlaylistVideos.csv`

📂 **File path:**  
`D:\Course_BD\data_for_oltp`

📌 **Note:**  
**Natural keys** are also used; no surrogate identifiers.

---

### ⚙️ Loading Process

1. Open `pgAdmin`.
2. Execute `sql/schema.sql` to create the analytics tables.
3. Ensure `.csv` files are accessible via the specified path.
4. Run `sql/load_data.sql` **as an administrator**.
5. Check data using:

   ```sql
   SELECT * FROM table_name;
   ```

---

### 🔄 ETL Process

- ETL is implemented via the `etl_load_data.sql` script.
- It connects to the OLTP database (`video_content_db`) using `dblink` and transfers data to `olap_video_analytics`.
- Performs aggregation of video views and populates dimension tables.

📦 **Tables Created:**
- `dim_time`, `dim_users`, `dim_videos`, `fact_video_views`

---

### 📊 OLAP Requirements

- Aggregated data (e.g., total view counts per video/date/user).
- Support for analytical queries (grouping, filtering, visualization).
- Use of **natural keys** in dimension tables.

---

### 📝 General Recommendations

- Make sure the `dblink` extension is enabled:
  ```sql
  CREATE EXTENSION IF NOT EXISTS dblink;
  ```
- Update file paths if necessary.
- Verify results after each loading step.

---

© 2025 — Video Views Analytics Project
