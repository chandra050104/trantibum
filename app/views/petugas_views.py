from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
import json
from ..models import Laporan, Penanganan, DokumentasiPenanganan, StatusHistory, Notifikasi, LogAktivitas, User


# ==================== DASHBOARD PETUGAS ====================
@login_required
def dashboard(request):
    """Dashboard petugas"""
    if request.user.role != 'PETUGAS':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    tugas_list = Penanganan.objects.filter(petugas=request.user).select_related('laporan')
    
    tugas_aktif = tugas_list.exclude(laporan__status__in=['SELESAI', 'DITOLAK', 'KADALUARSA']).count()
    tugas_selesai = tugas_list.filter(laporan__status='SELESAI').count()
    tugas_terbaru = tugas_list.order_by('-assigned_at')[:5]
    
    notifikasi = Notifikasi.objects.filter(user=request.user, is_read=False).order_by('-created_at')[:5]
    
    context = {
        'tugas_aktif': tugas_aktif,
        'tugas_selesai': tugas_selesai,
        'tugas_terbaru': tugas_terbaru,
        'notifikasi': notifikasi,
    }
    return render(request, 'petugas/dashboard.html', context)


# ==================== DAFTAR TUGAS ====================
@login_required
def daftar_tugas(request):
    """Daftar tugas yang diberikan ke petugas"""
    if request.user.role != 'PETUGAS':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    status_filter = request.GET.get('status', '')
    tugas_list = Penanganan.objects.filter(petugas=request.user).select_related('laporan')
    
    if status_filter:
        tugas_list = tugas_list.filter(laporan__status=status_filter)
    
    tugas_list = tugas_list.order_by('-assigned_at')
    
    context = {
        'tugas_list': tugas_list,
        'status_filter': status_filter,
        'status_choices': Laporan.STATUS_CHOICES,
    }
    return render(request, 'petugas/daftar_tugas.html', context)


# ==================== DETAIL TUGAS ====================
@login_required
def detail_tugas(request, penanganan_id):
    """Detail tugas dan update status penanganan"""
    if request.user.role != 'PETUGAS':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    penanganan = get_object_or_404(Penanganan, id=penanganan_id, petugas=request.user)
    laporan = penanganan.laporan
    status_history = StatusHistory.objects.filter(laporan=laporan).order_by('-changed_at')
    dokumentasi_list = DokumentasiPenanganan.objects.filter(penanganan=penanganan).order_by('-uploaded_at')
    
    # Status yang bisa dipilih petugas (workflow ketat)
    if laporan.status == 'DITUGASKAN':
        next_status = [('MENUJU_LOKASI', 'Menuju Lokasi')]
    elif laporan.status == 'MENUJU_LOKASI':
        next_status = [('DIPROSES', 'Diproses')]
    elif laporan.status == 'DIPROSES':
        next_status = [('SELESAI', 'Selesai')]
    else:
        next_status = []
    
    context = {
        'penanganan': penanganan,
        'laporan': laporan,
        'status_history': status_history,
        'dokumentasi_list': dokumentasi_list,
        'next_status': next_status,
        'latitude_float': float(laporan.latitude),
        'longitude_float': float(laporan.longitude),
        # TAMBAHKAN INI - SAMA PERSIS DENGAN ADMIN
        'laporan_json': json.dumps({
            'latitude': float(laporan.latitude),
            'longitude': float(laporan.longitude),
            'judul': laporan.judul,
            'alamat': laporan.alamat_kejadian or 'Lokasi Laporan',
        }),
    }
    return render(request, 'petugas/detail_tugas.html', context)


# ==================== UPDATE STATUS ====================
@login_required
def update_status(request, penanganan_id):
    """Update status penanganan oleh petugas"""
    if request.user.role != 'PETUGAS':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    penanganan = get_object_or_404(Penanganan, id=penanganan_id, petugas=request.user)
    laporan = penanganan.laporan
    
    if request.method == 'POST':
        status_baru = request.POST.get('status', '').strip()
        keterangan = request.POST.get('keterangan', '').strip()
        
        # Validasi workflow ketat
        allowed_transitions = {
            'DITUGASKAN': ['MENUJU_LOKASI'],
            'MENUJU_LOKASI': ['DIPROSES'],
            'DIPROSES': ['SELESAI'],
        }
        
        if laporan.status not in allowed_transitions:
            messages.error(request, 'Status saat ini tidak dapat diubah.')
            return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)
        
        if status_baru not in allowed_transitions.get(laporan.status, []):
            messages.error(request, f'Tidak dapat mengubah status dari {laporan.get_status_display()} ke status yang dipilih.')
            return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)
        
        # Update status
        laporan.status = status_baru
        laporan._changed_by = request.user
        laporan._status_keterangan = keterangan or f'Status diubah oleh petugas: {status_baru}'
        laporan.save()
        
        # Notifikasi ke pelapor
        Notifikasi.objects.create(
            user=laporan.pelapor,
            judul='Status Laporan Diperbarui',
            pesan=f'Laporan "{laporan.judul}" status: {laporan.get_status_display()}. {keterangan}',
            link=f'/masyarakat/laporan/{laporan.id}/'
        )
        
        # Log aktivitas
        LogAktivitas.objects.create(
            user=request.user,
            aksi='Update Status',
            detail=f'Laporan #{laporan.id}: {laporan.get_status_display()} - {keterangan}'
        )
        
        messages.success(request, f'Status berhasil diubah menjadi {laporan.get_status_display()}.')
        return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)
    
    return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)


# ==================== UPLOAD DOKUMENTASI ====================
@login_required
def upload_dokumentasi(request, penanganan_id):
    """Upload foto dokumentasi penanganan"""
    if request.user.role != 'PETUGAS':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    penanganan = get_object_or_404(Penanganan, id=penanganan_id, petugas=request.user)
    
    if request.method == 'POST':
        foto = request.FILES.get('foto')
        keterangan = request.POST.get('keterangan', '').strip()
        
        if not foto:
            messages.error(request, 'Foto dokumentasi wajib diupload.')
            return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)
        
        DokumentasiPenanganan.objects.create(
            penanganan=penanganan,
            foto=foto,
            keterangan=keterangan
        )
        
        LogAktivitas.objects.create(
            user=request.user,
            aksi='Upload Dokumentasi',
            detail=f'Dokumentasi untuk Penanganan #{penanganan_id}'
        )
        
        messages.success(request, 'Dokumentasi berhasil diupload.')
        return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)
    
    return redirect('petugas_detail_tugas', penanganan_id=penanganan_id)


# ==================== PROFIL PETUGAS ====================
@login_required
def profil(request):
    """Profil petugas"""
    if request.user.role != 'PETUGAS':
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
        return redirect('petugas_profil')
    
    return render(request, 'petugas/profil.html')