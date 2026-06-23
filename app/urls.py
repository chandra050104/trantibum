from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from .views import public_views, auth_views, masyarakat_views, petugas_views, admin_views


urlpatterns = [
    # ==================== PUBLIC ====================
    path('', public_views.landing, name='public_landing'),
    path('buat-laporan/', public_views.buat_laporan, name='public_buat_laporan'),
    path('tracking/', public_views.tracking, name='public_tracking'),
    path('info/', public_views.info, name='public_info'),
    
    # ==================== AUTH ====================
    path('login/', auth_views.login_view, name='auth_login'),
    path('register/', auth_views.register_view, name='auth_register'),
    path('logout/', auth_views.logout_view, name='auth_logout'),
    
    # ==================== MASYARAKAT ====================
    path('masyarakat/dashboard/', masyarakat_views.dashboard, name='masyarakat_dashboard'),
    path('masyarakat/riwayat/', masyarakat_views.riwayat_laporan, name='masyarakat_riwayat_laporan'),
    path('masyarakat/laporan/<int:laporan_id>/', masyarakat_views.detail_laporan, name='masyarakat_detail_laporan'),
    path('masyarakat/laporan/<int:laporan_id>/feedback/', masyarakat_views.feedback, name='masyarakat_feedback'),
    path('masyarakat/profil/', masyarakat_views.profil, name='masyarakat_profil'),
    
    # ==================== PETUGAS ====================
    path('petugas/dashboard/', petugas_views.dashboard, name='petugas_dashboard'),
    path('petugas/tugas/', petugas_views.daftar_tugas, name='petugas_daftar_tugas'),
    path('petugas/tugas/<int:penanganan_id>/', petugas_views.detail_tugas, name='petugas_detail_tugas'),
    path('petugas/tugas/<int:penanganan_id>/update-status/', petugas_views.update_status, name='petugas_update_status'),
    path('petugas/tugas/<int:penanganan_id>/upload-dokumentasi/', petugas_views.upload_dokumentasi, name='petugas_upload_dokumentasi'),
    path('petugas/profil/', petugas_views.profil, name='petugas_profil'),
    
    # ==================== ADMIN ====================
    path('admin/dashboard/', admin_views.dashboard, name='admin_dashboard'),
    path('admin/laporan/buat/', admin_views.admin_buat_laporan, name='admin_buat_laporan'),
    path('admin/laporan/', admin_views.semua_laporan, name='admin_semua_laporan'),
    path('admin/laporan/<int:laporan_id>/verifikasi/', admin_views.verifikasi_laporan, name='admin_verifikasi_laporan'),
    path('admin/laporan/<int:laporan_id>/assign/', admin_views.assign_petugas, name='admin_assign_petugas'),
    path('admin/monitoring-peta/', admin_views.monitoring_peta, name='admin_monitoring_peta'),
    path('admin/api/laporan-json/', admin_views.api_laporan_json, name='admin_api_laporan_json'),
    path('admin/manajemen-user/', admin_views.manajemen_user, name='admin_manajemen_user'),
    path('admin/manajemen-user/tambah/', admin_views.form_user, name='admin_form_user_tambah'),
    path('admin/manajemen-user/<int:user_id>/edit/', admin_views.form_user, name='admin_form_user_edit'),
    path('admin/manajemen-user/<int:user_id>/hapus/', admin_views.hapus_user, name='admin_hapus_user'),
    path('admin/log-aktivitas/', admin_views.log_aktivitas, name='admin_log_aktivitas'),
    path('admin/notifikasi/<int:notifikasi_id>/read/', admin_views.mark_notifikasi_read, name='admin_mark_notifikasi_read'),
    path('admin/profil/', admin_views.profil, name='admin_profil'),
    path('admin/laporan/export-pdf/', admin_views.export_laporan_pdf, name='admin_export_pdf'),
    path('admin/laporan/export-excel/', admin_views.export_laporan_excel, name='admin_export_excel'),
]

# Serve media files in development
if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)