from django.db import models
from django.contrib.auth.models import AbstractUser
from django.core.validators import FileExtensionValidator
from django.utils import timezone

# ==================== USER ====================
class User(AbstractUser):
    ROLE_CHOICES = [
        ('MASYARAKAT', 'Masyarakat'),
        ('PETUGAS', 'Petugas'),
        ('ADMIN', 'Admin'),
    ]

    JABATAN_CHOICES = [
        ('LURAH', 'Lurah'),
        ('KEPLING', 'Kepala Lingkungan'),
        ('KASI_TRANTIB', 'Kasi Trantibum'),
        ('STAFF_TRANTIB', 'staff Trantibum'),
        ('LAINNYA', 'Lainnya'),
    ]

    role = models.CharField(max_length=20, choices=ROLE_CHOICES, default='MASYARAKAT')
    jabatan = models.CharField(max_length=30, choices=JABATAN_CHOICES, blank=True, null=True)
    phone = models.CharField(max_length=15, blank=True, null=True)
    alamat = models.TextField(blank=True, null=True)
    foto_profil = models.ImageField(upload_to='profil/', blank=True, null=True)

    def __str__(self):
        return f"{self.username} ({self.get_role_display()})"

    class Meta:
        db_table = 'user'

# ==================== LAPORAN ====================
class Laporan(models.Model):
    STATUS_CHOICES = [
        ('MENUNGGU', 'Menunggu'),
        ('DIVERIFIKASI', 'Diverifikasi'),
        ('DITUGASKAN', 'Ditugaskan'),
        ('MENUJU_LOKASI', 'Menuju Lokasi'),
        ('DIPROSES', 'Diproses'),
        ('SELESAI', 'Selesai'),
        ('DITOLAK', 'Ditolak'),
        ('KADALUARSA', 'Kadaluarsa'),
    ]
    KATEGORI_CHOICES = [
        ('KEAMANAN', 'Gangguan Keamanan'),
        ('KETERTIBAN', 'Gangguan Ketertiban Umum'),
        ('PENYAKIT_MSY', 'Miras, prostitusi, Narkoba & Judi'),
        ('BENCANA', 'Bencana / Kejadian Khusus'),
        ('PENEGAKAN_PERDA', 'Pelanggaran Perda'),
        ('LAINNYA', 'Lainnya'),
    ]

    pelapor = models.ForeignKey(User, on_delete=models.CASCADE, related_name='laporan')
    judul = models.CharField(max_length=200)
    deskripsi = models.TextField()
    kategori = models.CharField(max_length=30, choices=KATEGORI_CHOICES, default='LAINNYA')
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='MENUNGGU')
    latitude = models.DecimalField(max_digits=10, decimal_places=7)
    longitude = models.DecimalField(max_digits=10, decimal_places=7)
    alamat_kejadian = models.TextField(blank=True, null=True)
    foto = models.ImageField(
        upload_to='laporan/',
        blank=True,
        null=True,
        validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png', 'gif'])]
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    kadaluarsa_at = models.DateTimeField(blank=True, null=True)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._old_status = self.status if self.pk else None

    def save(self, *args, **kwargs):
        is_new = self.pk is None
        status_changed = not is_new and self._old_status != self.status
        
        super().save(*args, **kwargs)
        
        if is_new:
            StatusHistory.objects.create(
                laporan=self,
                status=self.status,
                changed_by=self.pelapor if hasattr(self, '_changed_by') else None,
                keterangan='Laporan dibuat'
            )
        elif status_changed:
            StatusHistory.objects.create(
                laporan=self,
                status=self.status,
                changed_by=getattr(self, '_changed_by', None),
                keterangan=getattr(self, '_status_keterangan', 'Status diperbarui')
            )
        
        self._old_status = self.status

    def __str__(self):
        return f"[{self.get_status_display()}] {self.judul}"

    class Meta:
        db_table = 'laporan'

# ==================== PENANGANAN ====================
class Penanganan(models.Model):
    laporan = models.ForeignKey(Laporan, on_delete=models.CASCADE, related_name='penanganan')
    petugas = models.ManyToManyField(User, related_name='penanganan')
    catatan = models.TextField(blank=True, null=True)
    assigned_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Penanganan #{self.id} - {self.laporan.judul}"

    class Meta:
        db_table = 'penanganan'

# ==================== DOKUMENTASI PENANGANAN ====================
class DokumentasiPenanganan(models.Model):
    penanganan = models.ForeignKey(Penanganan, on_delete=models.CASCADE, related_name='dokumentasi')
    foto = models.ImageField(
        upload_to='dokumentasi/',
        validators=[FileExtensionValidator(allowed_extensions=['jpg', 'jpeg', 'png', 'gif'])]
    )
    keterangan = models.CharField(max_length=200, blank=True, null=True)
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Dokumentasi #{self.id}"

    class Meta:
        db_table = 'dokumentasi_penanganan'

# ==================== STATUS HISTORY ====================
class StatusHistory(models.Model):
    laporan = models.ForeignKey(Laporan, on_delete=models.CASCADE, related_name='status_history')
    status = models.CharField(max_length=20, choices=Laporan.STATUS_CHOICES)
    changed_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    keterangan = models.TextField(blank=True, null=True)
    changed_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.laporan.judul} → {self.status}"

    class Meta:
        db_table = 'status_history'
        ordering = ['-changed_at']

# ==================== RATING & FEEDBACK ====================
class RatingFeedback(models.Model):
    laporan = models.OneToOneField(Laporan, on_delete=models.CASCADE, related_name='feedback')
    rating = models.PositiveSmallIntegerField(default=5)
    komentar = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Rating {self.rating} - {self.laporan.judul}"

    class Meta:
        db_table = 'rating_feedback'

# ==================== NOTIFIKASI ====================
class Notifikasi(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifikasi')
    judul = models.CharField(max_length=200)
    pesan = models.TextField()
    is_read = models.BooleanField(default=False)
    link = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Notif to {self.user.username}: {self.judul}"

    class Meta:
        db_table = 'notifikasi'
        ordering = ['-created_at']

# ==================== LOG AKTIVITAS ====================
class LogAktivitas(models.Model):
    user = models.ForeignKey(User, on_delete=models.SET_NULL, null=True)
    aksi = models.CharField(max_length=100)
    detail = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"[{self.created_at}] {self.user} - {self.aksi}"

    class Meta:
        db_table = 'log_aktivitas'
        ordering = ['-created_at']