from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from django.utils import timezone
from django.db.models import Count, Q, Avg
from django.http import JsonResponse
from django.http import HttpResponse
from reportlab.lib.pagesizes import A4, landscape
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.lib.units import cm
import csv
from django.http import HttpResponse
from ..models import (
    Laporan, Penanganan, DokumentasiPenanganan, 
    StatusHistory, RatingFeedback, Notifikasi, 
    LogAktivitas, User
)


# ==================== DASHBOARD ADMIN ====================
@login_required
def dashboard(request):
    """Dashboard admin dengan statistik"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    # Statistik umum
    total_laporan = Laporan.objects.count()
    total_masyarakat = User.objects.filter(role='MASYARAKAT').count()
    total_petugas = User.objects.filter(role='PETUGAS').count()
    
    # Statistik status
    menunggu = Laporan.objects.filter(status='MENUNGGU').count()
    diverifikasi = Laporan.objects.filter(status='DIVERIFIKASI').count()
    ditugaskan = Laporan.objects.filter(status='DITUGASKAN').count()
    diproses = Laporan.objects.filter(status__in=['MENUJU_LOKASI', 'DIPROSES']).count()
    selesai = Laporan.objects.filter(status='SELESAI').count()
    ditolak = Laporan.objects.filter(status='DITOLAK').count()
    
    # Statistik kategori
    kategori_stats = Laporan.objects.values('kategori').annotate(
        total=Count('id')
    ).order_by('-total')
    
    # Laporan terbaru
    laporan_terbaru = Laporan.objects.select_related('pelapor').order_by('-created_at')[:10]
    
    # Laporan belum ditangani
    laporan_pending = Laporan.objects.filter(
        status__in=['MENUNGGU', 'DIVERIFIKASI']
    ).count()
    
    # Rating rata-rata
    avg_rating = RatingFeedback.objects.aggregate(
        avg=Avg('rating')
    )['avg'] or 0
    
    # Notifikasi
    notifikasi = Notifikasi.objects.filter(user=request.user, is_read=False).order_by('-created_at')[:5]
    
    context = {
        'total_laporan': total_laporan,
        'total_masyarakat': total_masyarakat,
        'total_petugas': total_petugas,
        'menunggu': menunggu,
        'diverifikasi': diverifikasi,
        'ditugaskan': ditugaskan,
        'diproses': diproses,
        'selesai': selesai,
        'ditolak': ditolak,
        'kategori_stats': kategori_stats,
        'laporan_terbaru': laporan_terbaru,
        'laporan_pending': laporan_pending,
        'avg_rating': round(avg_rating, 1),
        'notifikasi': notifikasi,
    }
    return render(request, 'admin/dashboard.html', context)


@login_required
def admin_buat_laporan(request):
    """Admin membuat laporan manual (dari WA/telp)"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    if request.method == 'POST':
        judul = request.POST.get('judul', '').strip()
        deskripsi = request.POST.get('deskripsi', '').strip()
        kategori = request.POST.get('kategori', 'LAINNYA')
        alamat_kejadian = request.POST.get('alamat_kejadian', '').strip()
        nama_pelapor = request.POST.get('nama_pelapor', '').strip()
        
        if not judul or not deskripsi:
            messages.error(request, 'Judul dan deskripsi wajib diisi.')
            return redirect('admin_semua_laporan')
        
        full_deskripsi = deskripsi
        if nama_pelapor:
            full_deskripsi = f"[📞 Pelapor: {nama_pelapor}]\n\n{deskripsi}"
        full_deskripsi += "\n\n[📞 Laporan via Telepon/WA - Diinput Admin]"
        
        Laporan.objects.create(
            pelapor=request.user,
            judul=judul,
            deskripsi=full_deskripsi,
            kategori=kategori,
            latitude=3.5833,
            longitude=98.6333,
            alamat_kejadian=alamat_kejadian or 'Laporan via Telepon/WA',
        )
        
        messages.success(request, f'✅ Laporan berhasil dibuat!')
        return redirect('admin_semua_laporan')
    
    return redirect('admin_semua_laporan')

# ==================== SEMUA LAPORAN ====================
@login_required
def semua_laporan(request):
    """Melihat semua laporan dengan filter"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    status_filter = request.GET.get('status', '')
    kategori_filter = request.GET.get('kategori', '')
    search = request.GET.get('search', '').strip()
    
    laporan_list = Laporan.objects.select_related('pelapor').all()
    
    if status_filter:
        laporan_list = laporan_list.filter(status=status_filter)
    
    if kategori_filter:
        laporan_list = laporan_list.filter(kategori=kategori_filter)
    
    if search:
        laporan_list = laporan_list.filter(
            Q(judul__icontains=search) | 
            Q(deskripsi__icontains=search) |
            Q(pelapor__username__icontains=search) |
            Q(id__icontains=search)  # ← TAMBAHKAN BARIS INI
    )
    
    laporan_list = laporan_list.order_by('-created_at')
    
    context = {
        'laporan_list': laporan_list,
        'status_filter': status_filter,
        'kategori_filter': kategori_filter,
        'search': search,
        'status_choices': Laporan.STATUS_CHOICES,
        'kategori_choices': Laporan.KATEGORI_CHOICES,
        'petugas_list': User.objects.filter(role='PETUGAS'),
    }
    return render(request, 'admin/semua_laporan.html', context)


# ==================== VERIFIKASI LAPORAN ====================
@login_required
def verifikasi_laporan(request, laporan_id):
    """Verifikasi laporan oleh admin"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    laporan = get_object_or_404(Laporan, id=laporan_id)
    
    if request.method == 'POST':
        action = request.POST.get('action', '')
        keterangan = request.POST.get('keterangan', '').strip()
        
        if action == 'verifikasi':
            if laporan.status != 'MENUNGGU':
                messages.error(request, 'Hanya laporan dengan status MENUNGGU yang bisa diverifikasi.')
                return redirect('admin_semua_laporan')
            
            laporan.status = 'DIVERIFIKASI'
            laporan._changed_by = request.user
            laporan._status_keterangan = keterangan or 'Laporan telah diverifikasi oleh admin'
            laporan.save()
            
            # Notifikasi ke pelapor
            Notifikasi.objects.create(
                user=laporan.pelapor,
                judul='Laporan Diverifikasi',
                pesan=f'Laporan "{laporan.judul}" telah diverifikasi. {keterangan}',
                link=f'/masyarakat/laporan/{laporan.id}/'
            )
            
            LogAktivitas.objects.create(
                user=request.user,
                aksi='Verifikasi Laporan',
                detail=f'Laporan #{laporan.id} diverifikasi'
            )
            
            messages.success(request, 'Laporan berhasil diverifikasi.')
        
        elif action == 'tolak':
            if laporan.status != 'MENUNGGU':
                messages.error(request, 'Hanya laporan dengan status MENUNGGU yang bisa ditolak.')
                return redirect('admin_semua_laporan')
            
            laporan.status = 'DITOLAK'
            laporan._changed_by = request.user
            laporan._status_keterangan = keterangan or 'Laporan ditolak oleh admin'
            laporan.save()
            
            # Notifikasi ke pelapor
            Notifikasi.objects.create(
                user=laporan.pelapor,
                judul='Laporan Ditolak',
                pesan=f'Laporan "{laporan.judul}" ditolak. {keterangan}',
                link=f'/masyarakat/laporan/{laporan.id}/'
            )
            
            LogAktivitas.objects.create(
                user=request.user,
                aksi='Tolak Laporan',
                detail=f'Laporan #{laporan.id} ditolak: {keterangan}'
            )
            
            messages.success(request, 'Laporan ditolak.')
        
        return redirect('admin_semua_laporan')
    
    # GET: tampilkan detail laporan via modal di halaman semua_laporan
    return redirect('admin_semua_laporan')


# ==================== ASSIGN PETUGAS (MULTIPLE) ====================
@login_required
def assign_petugas(request, laporan_id):
    """Assign petugas untuk laporan yang sudah diverifikasi (bisa lebih dari 1)"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    laporan = get_object_or_404(Laporan, id=laporan_id)
    
    if request.method == 'POST':
        petugas_ids = request.POST.getlist('petugas_id')  # ← getlist untuk multiple
        catatan = request.POST.get('catatan', '').strip()
        
        if laporan.status != 'DIVERIFIKASI':
            messages.error(request, 'Hanya laporan dengan status DIVERIFIKASI yang bisa ditugaskan.')
            return redirect('admin_semua_laporan')
        
        if not petugas_ids:
            messages.error(request, 'Pilih minimal 1 petugas.')
            return redirect('admin_semua_laporan')
        
        # Buat atau ambil penanganan
        penanganan, created = Penanganan.objects.get_or_create(
            laporan=laporan,
            defaults={'catatan': catatan}
        )
        
        if not created:
            penanganan.catatan = catatan
            penanganan.save()
        
        # Tambah petugas satu per satu
        nama_petugas = []
        for pid in petugas_ids:
            petugas = get_object_or_404(User, id=pid, role='PETUGAS')
            penanganan.petugas.add(petugas)
            nama_petugas.append(petugas.username)
            
            # Notifikasi ke petugas
            Notifikasi.objects.create(
                user=petugas,
                judul='Tugas Baru',
                pesan=f'Anda ditugaskan untuk menangani laporan: {laporan.judul}',
                link=f'/petugas/tugas/'
            )
        
        # Update status laporan
        laporan.status = 'DITUGASKAN'
        laporan._changed_by = request.user
        laporan._status_keterangan = f'Ditugaskan kepada {", ".join(nama_petugas)}'
        laporan.save()
        
        # Notifikasi ke pelapor
        Notifikasi.objects.create(
            user=laporan.pelapor,
            judul='Laporan Ditugaskan',
            pesan=f'Laporan "{laporan.judul}" telah ditugaskan ke petugas.',
            link=f'/masyarakat/laporan/{laporan.id}/'
        )
        
        LogAktivitas.objects.create(
            user=request.user,
            aksi='Assign Petugas',
            detail=f'Laporan #{laporan.id} ditugaskan ke {len(nama_petugas)} petugas: {", ".join(nama_petugas)}'
        )
        
        messages.success(request, f'Laporan berhasil ditugaskan ke {len(nama_petugas)} petugas!')
        return redirect('admin_semua_laporan')
    
    return redirect('admin_semua_laporan')


# ==================== MONITORING PETA ====================
@login_required
def monitoring_peta(request):
    """Full monitoring peta dengan Leaflet"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    status_filter = request.GET.get('status', '')
    
    if status_filter:
        laporan_list = Laporan.objects.filter(status=status_filter).select_related('pelapor')
    else:
        laporan_list = Laporan.objects.all().select_related('pelapor')
    
    # Warna marker berdasarkan status
    status_colors = {
        'MENUNGGU': 'red',
        'DIVERIFIKASI': 'orange',
        'DITUGASKAN': 'blue',
        'MENUJU_LOKASI': 'purple',
        'DIPROSES': 'darkblue',
        'SELESAI': 'green',
        'DITOLAK': 'gray',
        'KADALUARSA': 'black',
    }
    
    laporan_json = []
    for l in laporan_list:
        laporan_json.append({
            'id': l.id,
            'judul': l.judul,
            'status': l.get_status_display(),
            'kategori': l.get_kategori_display(),
            'pelapor': l.pelapor.username,
            'latitude': float(l.latitude),
            'longitude': float(l.longitude),
            'color': status_colors.get(l.status, 'gray'),
            'created_at': l.created_at.strftime('%d/%m/%Y'),
        })
    
    context = {
        'laporan_json': laporan_json,
        'status_filter': status_filter,
        'status_choices': Laporan.STATUS_CHOICES,
    }
    return render(request, 'admin/monitoring_peta.html', context)


# ==================== API LAPORAN JSON (untuk peta) ====================
@login_required
def api_laporan_json(request):
    """API endpoint untuk data peta"""
    if request.user.role != 'ADMIN':
        return JsonResponse({'error': 'Akses ditolak'}, status=403)
    
    status_filter = request.GET.get('status', '')
    
    if status_filter:
        laporan_list = Laporan.objects.filter(status=status_filter).select_related('pelapor')
    else:
        laporan_list = Laporan.objects.all().select_related('pelapor')
    
    status_colors = {
        'MENUNGGU': 'red',
        'DIVERIFIKASI': 'orange',
        'DITUGASKAN': 'blue',
        'MENUJU_LOKASI': 'purple',
        'DIPROSES': 'darkblue',
        'SELESAI': 'green',
        'DITOLAK': 'gray',
        'KADALUARSA': 'black',
    }
    
    data = []
    for l in laporan_list:
        dokumentasi_list = []
        penanganan = Penanganan.objects.filter(laporan=l).first()
        if penanganan:
            docs = DokumentasiPenanganan.objects.filter(penanganan=penanganan)
            for d in docs:
                dokumentasi_list.append({
                    'foto_url': d.foto.url if d.foto else '',
                    'keterangan': d.keterangan or '',
                })

        bukti_url = ''
        bukti_is_video = False
        if l.foto:
            bukti_url = l.foto.url
            ext = l.foto.url.lower()
            if any(vid_ext in ext for vid_ext in ['.mp4', '.avi', '.mov', '.webm']):
                bukti_is_video = True

        data.append({
            'id': l.id,
            'judul': l.judul,
            'status': l.status(),
            'status_display': l.get_status_display(),
            'kategori': l.get_kategori_display(),
            'pelapor': l.pelapor.username,
            'latitude': float(l.latitude),
            'longitude': float(l.longitude),
            'color': status_colors.get(l.status, 'gray'),
            'created_at': l.created_at.strftime('%d/%m/%Y %H:%M'),
            'dokumentasi': dokumentasi_list,
            'foto_url': bukti_url,
            'foto_is_video': bukti_is_video,
        })
    
    return JsonResponse({'laporan': data})


# ==================== MANAJEMEN USER ====================
@login_required
def manajemen_user(request):
    """CRUD user oleh admin"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    role_filter = request.GET.get('role', '')
    search = request.GET.get('search', '').strip()
    
    user_list = User.objects.all()
    
    if role_filter:
        user_list = user_list.filter(role=role_filter)
    
    if search:
        user_list = user_list.filter(
            Q(username__icontains=search) | 
            Q(email__icontains=search)
        )
    
    user_list = user_list.order_by('-date_joined')
    
    context = {
        'user_list': user_list,
        'role_filter': role_filter,
        'search': search,
        'role_choices': User.ROLE_CHOICES,
    }
    return render(request, 'admin/manajemen_user.html', context)


# ==================== FORM USER (TAMBAH/EDIT) ====================
@login_required
def form_user(request, user_id=None):
    """Form tambah/edit user"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    edit_user = None
    if user_id:
        edit_user = get_object_or_404(User, id=user_id)
    
    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        email = request.POST.get('email', '').strip()
        password = request.POST.get('password', '').strip()
        role = request.POST.get('role', 'MASYARAKAT')
        phone = request.POST.get('phone', '').strip()
        alamat = request.POST.get('alamat', '').strip()
        jabatan = request.POST.get('jabatan', '').strip()
        
        if edit_user:
            # Edit existing user
            if User.objects.filter(username=username).exclude(id=edit_user.id).exists():
                messages.error(request, 'Username sudah digunakan.')
                return render(request, 'admin/form_user.html', {'edit_user': edit_user})
            
            edit_user.username = username
            edit_user.email = email
            edit_user.role = role
            edit_user.phone = phone
            edit_user.alamat = alamat
            edit_user.jabatan = jabatan
            
            if password:
                edit_user.set_password(password)
            
            edit_user.save()
            
            LogAktivitas.objects.create(
                user=request.user,
                aksi='Edit User',
                detail=f'User {edit_user.username} diupdate'
            )
            
            messages.success(request, f'User {edit_user.username} berhasil diperbarui.')
        else:
            # Tambah user baru
            if User.objects.filter(username=username).exists():
                messages.error(request, 'Username sudah digunakan.')
                return render(request, 'admin/form_user.html')
            
            if not password:
                messages.error(request, 'Password wajib diisi.')
                return render(request, 'admin/form_user.html')
            
            user = User.objects.create_user(
                username=username,
                password=password,
                email=email,
                role=role,
                phone=phone,
                alamat=alamat,
                jabatan=jabatan
            )
            
            LogAktivitas.objects.create(
                user=request.user,
                aksi='Tambah User',
                detail=f'User {username} dengan role {role} dibuat'
            )
            
            messages.success(request, f'User {user.username} berhasil dibuat.')
        
        return redirect('admin_manajemen_user')
    
    context = {
        'edit_user': edit_user,
        'role_choices': User.ROLE_CHOICES,
    }
    return render(request, 'admin/form_user.html', context)


# ==================== HAPUS USER ====================
@login_required
def hapus_user(request, user_id):
    """Hapus user"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    user = get_object_or_404(User, id=user_id)
    
    if user.id == request.user.id:
        messages.error(request, 'Tidak bisa menghapus akun sendiri.')
        return redirect('admin_manajemen_user')
    
    username = user.username
    user.delete()
    
    LogAktivitas.objects.create(
        user=request.user,
        aksi='Hapus User',
        detail=f'User {username} dihapus'
    )
    
    messages.success(request, f'User {username} berhasil dihapus.')
    return redirect('admin_manajemen_user')


# ==================== LOG AKTIVITAS ====================
@login_required
def log_aktivitas(request):
    """Melihat log aktivitas"""
    if request.user.role != 'ADMIN':
        messages.error(request, 'Akses ditolak.')
        return redirect('auth_login')
    
    search = request.GET.get('search', '').strip()
    
    log_list = LogAktivitas.objects.select_related('user').all()
    
    if search:
        log_list = log_list.filter(
            Q(user__username__icontains=search) |
            Q(aksi__icontains=search) |
            Q(detail__icontains=search)
        )
    
    log_list = log_list.order_by('-created_at')[:100]
    
    context = {
        'log_list': log_list,
        'search': search,
    }
    return render(request, 'admin/log_aktivitas.html', context)


# ==================== MARK NOTIFIKASI READ ====================
@login_required
def mark_notifikasi_read(request, notifikasi_id):
    """Tandai notifikasi sudah dibaca"""
    if request.method == 'POST':
        notifikasi = get_object_or_404(Notifikasi, id=notifikasi_id, user=request.user)
        notifikasi.is_read = True
        notifikasi.save()
    
    # Redirect back
    referer = request.META.get('HTTP_REFERER', '/')
    return redirect(referer)



# ==================== PROFIL ADMIN ====================
@login_required
def profil(request):
    """Profil admin"""
    if request.user.role != 'ADMIN':
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
        return redirect('admin_profil')
    
    return render(request, 'admin/profil.html')


@login_required
def export_laporan_pdf(request):
    if request.user.role != 'ADMIN':
        return redirect('auth_login')
    
    status_filter = request.GET.get('status', '')
    kategori_filter = request.GET.get('kategori', '')
    search = request.GET.get('search', '').strip()
    
    laporan_list = Laporan.objects.select_related('pelapor').all()
    if status_filter: laporan_list = laporan_list.filter(status=status_filter)
    if kategori_filter: laporan_list = laporan_list.filter(kategori=kategori_filter)
    if search:
        laporan_list = laporan_list.filter(Q(judul__icontains=search) | Q(pelapor__username__icontains=search))
    laporan_list = laporan_list.order_by('-created_at')
    
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="rekap_laporan.pdf"'
    
    doc = SimpleDocTemplate(response, pagesize=landscape(A4), rightMargin=0.5*cm, leftMargin=0.5*cm, topMargin=0.5*cm, bottomMargin=0.5*cm)
    elements = []
    
    # Judul
    styles = getSampleStyleSheet()
    title = Paragraph(f"<b>REKAP LAPORAN TRANTIBUM</b><br/>Kec. Medan Selayang | {laporan_list.count()} Laporan", styles['Title'])
    elements.append(title)
    elements.append(Spacer(1, 0.3*cm))
    
    # Header
    data = [['No', 'Judul', 'Pelapor', 'Kategori', 'Status', 'Tgl', 'Petugas']]
    
    for i, lap in enumerate(laporan_list, 1):
        petugas_list = []
        penanganan = lap.penanganan.first()
        if penanganan: petugas_list = [p.username for p in penanganan.petugas.all()]
        
        data.append([str(i), lap.judul[:60], lap.pelapor.username, lap.get_kategori_display(), 
                     lap.get_status_display(), lap.created_at.strftime('%d/%m/%Y'), 
                     ', '.join(petugas_list) if petugas_list else '-'])
    
    table = Table(data, colWidths=[1*cm, 6*cm, 3*cm, 6*cm, 3.5*cm, 2.5*cm, 5*cm])
    table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), colors.HexColor('#f97316')),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('FONTSIZE', (0,0), (-1,0), 9),
        ('ALIGN', (0,0), (0,-1), 'CENTER'),
        ('FONTSIZE', (0,1), (-1,-1), 8),
        ('GRID', (0,0), (-1,-1), 0.3, colors.HexColor('#cccccc')),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, colors.HexColor('#f5f5f5')]),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
    ]))
    elements.append(table)
    doc.build(elements)
    return response

@login_required
def export_laporan_excel(request):
    if request.user.role != 'ADMIN':
        return redirect('auth_login')
    
    status_filter = request.GET.get('status', '')
    kategori_filter = request.GET.get('kategori', '')
    search = request.GET.get('search', '').strip()
    
    laporan_list = Laporan.objects.select_related('pelapor').all()
    if status_filter: laporan_list = laporan_list.filter(status=status_filter)
    if kategori_filter: laporan_list = laporan_list.filter(kategori=kategori_filter)
    if search:
        laporan_list = laporan_list.filter(Q(judul__icontains=search) | Q(pelapor__username__icontains=search))
    laporan_list = laporan_list.order_by('-created_at')
    
    response = HttpResponse(content_type='text/csv; charset=utf-8-sig')
    response['Content-Disposition'] = 'attachment; filename="rekap_laporan.csv"'
    
    writer = csv.writer(response, delimiter=';')
    writer.writerow(['NO', 'ID', 'JUDUL', 'PELAPOR', 'KATEGORI', 'STATUS', 'TANGGAL', 'PETUGAS'])
    
    for i, lap in enumerate(laporan_list, 1):
        petugas_list = []
        penanganan = lap.penanganan.first()
        if penanganan: petugas_list = [p.username for p in penanganan.petugas.all()]
        
        writer.writerow([i, lap.id, lap.judul, lap.pelapor.username, lap.get_kategori_display(),
                        lap.get_status_display(), lap.created_at.strftime('%d/%m/%Y'),
                        ', '.join(petugas_list) if petugas_list else '-'])
    
    return response