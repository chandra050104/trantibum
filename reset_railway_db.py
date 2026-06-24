import MySQLdb

conn = MySQLdb.connect(
    host='reseau.proxy.rlwy.net', 
    port=44289, 
    user='root', 
    passwd='kpnqZErPFYrHZxdESuEepXfUiViwOAxG', 
    db='railway'
)
cursor = conn.cursor()
cursor.execute('SET FOREIGN_KEY_CHECKS=0')

# TRUNCATE (hapus data + reset auto increment)
tables = ['dokumentasi_penanganan', 'penanganan_petugas', 'penanganan', 
          'status_history', 'rating_feedback', 'notifikasi', 
          'log_aktivitas', 'laporan', 'user']

for t in tables:
    cursor.execute(f'TRUNCATE TABLE {t}')
    print(f'✅ {t} dibersihkan (auto-increment direset)')

cursor.execute('SET FOREIGN_KEY_CHECKS=1')
conn.commit()
print('🗑️ Semua data Railway dihapus total!')
conn.close()