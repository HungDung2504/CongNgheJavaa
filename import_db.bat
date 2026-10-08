C:\xampp\mysql\bin\mysql.exe -u root -e "CREATE DATABASE IF NOT EXISTS nexora_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
C:\xampp\mysql\bin\mysql.exe -u root nexora_db < nexora_db.sql
C:\xampp\mysql\bin\mysql.exe -u root nexora_db < update_anh_chinh_xac.sql
C:\xampp\mysql\bin\mysql.exe -u root nexora_db < update_anh_that.sql
C:\xampp\mysql\bin\mysql.exe -u root nexora_db < update_pass.sql
