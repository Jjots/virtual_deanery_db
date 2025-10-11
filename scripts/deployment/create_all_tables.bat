@echo off
echo Creating all tables in virtual_deanery database...

psql -U postgres -d virtual_deanery -f virtual_deanery_db\sql\01_base_tables\lp1_student_contingent.sql
psql -U postgres -d virtual_deanery -f virtual_deanery_db\sql\01_base_tables\lp2_education_process.sql
psql -U postgres -d virtual_deanery -f virtual_deanery_db\sql\01_base_tables\lp3_teachers.sql
psql -U postgres -d virtual_deanery -f virtual_deanery_db\sql\01_base_tables\lp4_events_deadlines.sql
psql -U postgres -d virtual_deanery -f virtual_deanery_db\sql\01_base_tables\lp5_student_performance.sql

echo All tables created successfully!
pause