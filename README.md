# TaniMart
Marketplace pertanian (SvelteKit + TypeScript + Tailwind + Supabase + Vercel).

## Setup
1. `npm install`
2. Salin `.env.example` ke `.env.local`, isi URL dan anon key Supabase.
3. Di Supabase SQL Editor jalankan `supabase/migrations/001_init.sql` lalu `supabase/seed.sql` (membuat tabel, RLS, bucket Storage `product-images`, `avatars`, `store-images`).
4. Authentication > URL Configuration: isi Site URL (lokal `http://localhost:5173`).
5. `npm run dev`; build: `npm run build`.

## Deploy Vercel
Push ke GitHub, import di Vercel, tambahkan env `PUBLIC_SUPABASE_URL` dan `PUBLIC_SUPABASE_ANON_KEY`. Adapter `@sveltejs/adapter-vercel` sudah dikonfigurasi.

## Membuat admin
Ubah `profiles.role` menjadi `admin` lewat SQL Editor. Role tidak bisa diubah dari frontend (trigger `block_role_change`).

## Login tidak bisa?
- Supabase > Authentication > Providers > Email: matikan **Confirm email** saat pengembangan (menghindari "email rate limit exceeded").
- Jalankan `supabase/migrations/002_fix_auth.sql` di SQL Editor.
- Akun percobaan lama: hapus di Authentication > Users lalu daftar ulang di /register.

## Catatan
Ini tahap awal (MVP). Lihat `PROGRESS.md` untuk fitur yang sudah dan belum ada. QRIS/transfer/COD belum diimplementasikan.
