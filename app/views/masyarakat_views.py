from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from ..models import Laporan, Notifikasi, LogAktivitas, RatingFeedback, StatusHistory, Penanganan, DokumentasiPenanganan


# ==================== DASHBOARD MASYARAKAT ====================
@login_required
def dashboard(request):
    """Dashboard masyarakat"""
    if request.user.role != 'MASYARAKAT':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    total_laporan = Laporan.objects.filter(pelapor=request.user).count()
    laporan_menunggu = Laporan.objects.filter(pelapor=request.user, status='MENUNGGU').count()
    laporan_diproses = Laporan.objects.filter(pelapor=request.user, status__in=['DIVERIFIKASI', 'DITUGASKAN', 'MENUJU_LOKASI', 'DIPROSES']).count()
    laporan_selesai = Laporan.objects.filter(pelapor=request.user, status='SELESAI').count()
    laporan_terbaru = Laporan.objects.filter(pelapor=request.user).order_by('-created_at')[:5]
    
    # Notifikasi
    notifikasi = Notifikasi.objects.filter(user=request.user, is_read=False).order_by('-created_at')[:5]
    
    context = {
        'total_laporan': total_laporan,
        'laporan_menunggu': laporan_menunggu,
        'laporan_diproses': laporan_diproses,
        'laporan_selesai': laporan_selesai,
        'laporan_terbaru': laporan_terbaru,
        'notifikasi': notifikasi,
    }
    return render(request, 'masyarakat/dashboard.html', context)


# ==================== RIWAYAT LAPORAN ====================
@login_required
def riwayat_laporan(request):
    """Riwayat laporan milik sendiri"""
    if request.user.role != 'MASYARAKAT':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    status_filter = request.GET.get('status', '')
    laporan_list = Laporan.objects.filter(pelapor=request.user)
    
    if status_filter:
        laporan_list = laporan_list.filter(status=status_filter)
    
    laporan_list = laporan_list.order_by('-created_at')
    
    context = {
        'laporan_list': laporan_list,
        'status_filter': status_filter,
        'status_choices': Laporan.STATUS_CHOICES,
    }
    return render(request, 'masyarakat/riwayat_laporan.html', context)


# ==================== DETAIL LAPORAN ====================
@login_required
def detail_laporan(request, laporan_id):
    """Detail laporan milik sendiri"""
    if request.user.role != 'MASYARAKAT':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    laporan = get_object_or_404(Laporan, id=laporan_id, pelapor=request.user)
    status_history = StatusHistory.objects.filter(laporan=laporan).order_by('-changed_at')
    feedback = RatingFeedback.objects.filter(laporan=laporan).first()

    dokumentasi_list = []
    penanganan = Penanganan.objects.filter(laporan=laporan).first()
    if penanganan:
        dokumentasi_list = DokumentasiPenanganan.objects.filter(penanganan=penanganan).order_by('-uploaded_at')
    
    context = {
        'laporan': laporan,
        'status_history': status_history,
        'feedback': feedback,
        'dokumentasi_list': dokumentasi_list,
    }
    return render(request, 'masyarakat/detail_laporan.html', context)


# ==================== FEEDBACK ====================
@login_required
def feedback(request, laporan_id):
    """Memberikan rating dan feedback untuk laporan yang sudah selesai"""
    if request.user.role != 'MASYARAKAT':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    laporan = get_object_or_404(Laporan, id=laporan_id, pelapor=request.user)
    
    if laporan.status != 'SELESAI':
        messages.error(request, 'Feedback hanya bisa diberikan untuk laporan yang sudah selesai.')
        return redirect('masyarakat_detail_laporan', laporan_id=laporan_id)
    
    if RatingFeedback.objects.filter(laporan=laporan).exists():
        messages.warning(request, 'Anda sudah memberikan feedback untuk laporan ini.')
        return redirect('masyarakat_detail_laporan', laporan_id=laporan_id)
    
    if request.method == 'POST':
        rating = request.POST.get('rating', '')
        komentar = request.POST.get('komentar', '').strip()
        
        try:
            rating = int(rating)
            if rating < 1 or rating > 5:
                messages.error(request, 'Rating harus antara 1-5.')
                return render(request, 'masyarakat/feedback.html', {'laporan': laporan})
        except (ValueError, TypeError):
            messages.error(request, 'Rating tidak valid.')
            return render(request, 'masyarakat/feedback.html', {'laporan': laporan})
        
        RatingFeedback.objects.create(
            laporan=laporan,
            rating=rating,
            komentar=komentar
        )
        
        LogAktivitas.objects.create(
            user=request.user,
            aksi='Memberikan Feedback',
            detail=f'Feedback rating {rating} untuk Laporan #{laporan.id}'
        )
        
        messages.success(request, 'Terima kasih atas feedback Anda.')
        return redirect('masyarakat_detail_laporan', laporan_id=laporan_id)
    
    return render(request, 'masyarakat/feedback.html', {'laporan': laporan})


# ==================== PROFIL ====================
@login_required
def profil(request):
    """Profil masyarakat"""
    if request.user.role != 'MASYARAKAT':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    if request.method == 'POST':
        user = request.user
        user.phone = request.POST.get('phone', '').strip()
        user.alamat = request.POST.get('alamat', '').strip()
        
        if 'foto_profil' in request.FILES:
            user.foto_profil = request.FILES['foto_profil']
        
        user.save()
        messages.success(request, 'Profil berhasil diperbarui.')
        return redirect('masyarakat_profil')
    
    return render(request, 'masyarakat/profil.html')