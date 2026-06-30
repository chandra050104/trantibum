from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from django.urls import reverse
from django.db.models import Q, Avg
from ..models import Laporan, Notifikasi, LogAktivitas, User,RatingFeedback


# ==================== LANDING PAGE ====================
def landing(request):
    """Halaman utama"""
    # Ambil rating rata-rata dari database
    avg_rating = RatingFeedback.objects.aggregate(avg=Avg('rating'))['avg'] or 0
    total_feedback = RatingFeedback.objects.count()
    
    # Ambil 3 testimoni terbaru dari feedback yang ada komentar
    testimoni_list = RatingFeedback.objects.exclude(komentar__isnull=True).exclude(komentar='').select_related('laporan__pelapor').order_by('-created_at')[:3]
    
    context = {
        'avg_rating': round(avg_rating, 1),
        'total_feedback': total_feedback,
        'testimoni_list': testimoni_list,
    }
    return render(request, 'public/landing.html', context)


# ==================== BUAT LAPORAN ====================
@login_required
def buat_laporan(request):
    """Form pelaporan oleh masyarakat"""
    if request.method == 'POST':
        judul = request.POST.get('judul', '').strip()
        deskripsi = request.POST.get('deskripsi', '').strip()
        kategori = request.POST.get('kategori', 'LAINNYA')
        latitude = request.POST.get('latitude', '').strip()
        longitude = request.POST.get('longitude', '').strip()
        alamat_kejadian = request.POST.get('alamat_kejadian', '').strip()
        foto = request.FILES.get('foto')

        if not judul or not deskripsi or not latitude or not longitude:
            messages.error(request, 'Semua field wajib diisi (termasuk pin lokasi di peta).')
            return render(request, 'public/buat_laporan.html')

        try:
            lat = float(latitude)
            lng = float(longitude)
        except (ValueError, TypeError):
            messages.error(request, 'Koordinat tidak valid.')
            return render(request, 'public/buat_laporan.html')

        # ========== VALIDASI FILE ==========
        if foto:
            # Validasi ukuran (max 10MB)
            if foto.size > 10 * 1024 * 1024:
                messages.error(request, 'Ukuran file terlalu besar. Maksimal 10MB.')
                return render(request, 'public/buat_laporan.html')
            
            # Validasi ekstensi
            allowed_extensions = ['jpg', 'jpeg', 'png', 'gif', 'mp4', 'avi', 'mov', 'webm']
            ext = foto.name.split('.')[-1].lower() if '.' in foto.name else ''
            if ext not in allowed_extensions:
                messages.error(request, f'Format file .{ext} tidak didukung. Gunakan: {", ".join(allowed_extensions)}')
                return render(request, 'public/buat_laporan.html')
        # ========== AKHIR VALIDASI ==========

        try:
            laporan = Laporan.objects.create(
                pelapor=request.user,
                judul=judul,
                deskripsi=deskripsi,
                kategori=kategori,
                latitude=lat,
                longitude=lng,
                alamat_kejadian=alamat_kejadian or '',
                foto=foto
            )
        except Exception as e:
            messages.error(request, f'Gagal upload file. Pastikan file tidak rusak. Error: {str(e)}')
            return render(request, 'public/buat_laporan.html')

        # Notifikasi ke semua admin
        admin_list = User.objects.filter(role='ADMIN')
        for admin in admin_list:
            Notifikasi.objects.create(
                user=admin,
                judul='Laporan Baru',
                pesan=f'Masyarakat {request.user.username} membuat laporan: {judul}',
                link=f'/admin/laporan/{laporan.id}/'
            )

        # Log aktivitas
        LogAktivitas.objects.create(
            user=request.user,
            aksi='Membuat Laporan',
            detail=f'Laporan #{laporan.id}: {judul}'
        )

        messages.success(request, f'Laporan berhasil dikirim! ID Laporan Anda: #{laporan.id}.')
        return redirect(f"{reverse('public_tracking')}?q={laporan.id}")

    return render(request, 'public/buat_laporan.html')


# ==================== TRACKING LAPORAN ====================
@login_required
def tracking(request):
    """Tracking laporan milik sendiri"""
    laporan = None
    query = request.GET.get('q', '').strip()
    
    if query:
        try:
            laporan_id = int(query)
            laporan = Laporan.objects.filter(
                id=laporan_id,
                pelapor=request.user
            ).first()
        except ValueError:
            laporan = Laporan.objects.filter(
                Q(judul__icontains=query) | Q(deskripsi__icontains=query),
                pelapor=request.user
            ).first()
        
        if not laporan:
            messages.warning(request, 'Laporan tidak ditemukan atau bukan milik Anda.')
    
    context = {
        'laporan': laporan,
        'query': query
    }
    return render(request, 'public/tracking.html', context)


# ==================== INFO (BERITA + FAQ + KONTAK + EDUKASI) ====================
def info(request):
    """Halaman info statis (berita, faq, kontak, edukasi)"""
    tab = request.GET.get('tab', 'berita')
    return render(request, 'public/info.html', {'active_tab': tab})
