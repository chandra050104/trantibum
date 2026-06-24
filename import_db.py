import MySQLdb

conn = MySQLdb.connect(
    host='reseau.proxy.rlwy.net', 
    port=44289, 
    user='root', 
    passwd='kpnqZErPFYrHZxdESuEepXfUiViwOAxG', 
    db='railway'
)
cursor = conn.cursor()

with open(r'C:\Trantibum\full_db.sql', 'r', encoding='utf-8') as f:
    sql = f.read()
    for statement in sql.split(';'):
        if statement.strip():
            try:
                cursor.execute(statement)
            except Exception as e:
                print(f'⚠️ Skip: {str(e)[:80]}')

conn.commit()
print('✅ Data berhasil diimport ke Railway!')
conn.close()