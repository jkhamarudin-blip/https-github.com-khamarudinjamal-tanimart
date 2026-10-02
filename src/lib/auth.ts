export const pesan = (m: string) =>
  /not confirmed/i.test(m) ? 'Email belum diverifikasi. Cek email Anda, atau minta admin mematikan "Confirm email" di Supabase.'
  : /invalid login/i.test(m) ? 'Email atau kata sandi salah.'
  : /rate limit/i.test(m) ? 'Batas pengiriman email Supabase tercapai. Matikan "Confirm email" di Supabase atau tunggu sekitar 1 jam.'
  : /already registered/i.test(m) ? 'Email sudah terdaftar. Silakan masuk.'
  : /database error/i.test(m) ? 'Gagal membuat profil. Jalankan supabase/migrations/002_fix_auth.sql.'
  : /password/i.test(m) ? 'Kata sandi minimal 6 karakter.'
  : m;
