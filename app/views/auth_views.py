from django.shortcuts import render, redirect
from django.contrib.auth import login, logout, authenticate
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from ..models import User


# ==================== LOGIN ====================
def login_view(request):
    """Login untuk semua role"""
    if request.user.is_authenticated:
        return redirect_after_login(request.user)

    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '').strip()

        if not username or not password:
            messages.error(request, 'Username dan password wajib diisi.')
            return render(request, 'auth/login.html')

        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            messages.success(request, f'Selamat datang, {user.username}!')
            return redirect_after_login(user)
        else:
            messages.error(request, 'Username atau password salah.')

    return render(request, 'auth/login.html')


# ==================== REGISTER ====================
def register_view(request):
    """Register untuk masyarakat"""
    if request.user.is_authenticated:
        return redirect_after_login(request.user)

    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '').strip()
        password2 = request.POST.get('password2', '').strip()
        email = request.POST.get('email', '').strip()
        phone = request.POST.get('phone', '').strip()
        alamat = request.POST.get('alamat', '').strip()

        # Validasi
        if not username or not password or not password2:
            messages.error(request, 'Username dan password wajib diisi.')
            return render(request, 'auth/register.html')

        if password != password2:
            messages.error(request, 'Konfirmasi password tidak cocok.')
            return render(request, 'auth/register.html')

        if len(password) < 6:
            messages.error(request, 'Password minimal 6 karakter.')
            return render(request, 'auth/register.html')

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username sudah digunakan.')
            return render(request, 'auth/register.html')

        if email and User.objects.filter(email=email).exists():
            messages.error(request, 'Email sudah digunakan.')
            return render(request, 'auth/register.html')

        # Buat user
        user = User.objects.create_user(
            username=username,
            password=password,
            email=email,
            role='MASYARAKAT',
            phone=phone,
            alamat=alamat
        )

        messages.success(request, 'Registrasi berhasil. Silakan login.')
        return redirect('auth_login')

    return render(request, 'auth/register.html')


# ==================== LOGOUT ====================
@login_required
def logout_view(request):
    """Logout"""
    logout(request)
    messages.success(request, 'Anda telah logout.')
    return redirect('public_landing')


# ==================== REDIRECT BERDASARKAN ROLE ====================
def redirect_after_login(user):
    """Redirect user ke dashboard sesuai role"""
    if user.role == 'ADMIN':
        return redirect('admin_dashboard')
    elif user.role == 'PETUGAS':
        return redirect('petugas_dashboard')
    else:
        return redirect('masyarakat_dashboard')