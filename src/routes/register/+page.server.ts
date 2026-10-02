import { fail, redirect } from '@sveltejs/kit';
import { pesan } from '$lib/auth';
export const load = async ({ locals }) => { if (locals.user) throw redirect(303, '/'); return {}; };
export const actions = {
  default: async ({ request, locals, url }) => {
    const f = await request.formData();
    const email = String(f.get('email') ?? '').trim(), full_name = String(f.get('full_name') ?? '').trim();
    const password = String(f.get('password') ?? '');
    if (password.length < 6) return fail(400, { message: 'Kata sandi minimal 6 karakter.', email, full_name });
    const { data, error } = await locals.supabase.auth.signUp({ email, password, options: { data: { full_name }, emailRedirectTo: `${url.origin}/auth/callback` } });
    if (error) { console.error('register:', error.message); return fail(400, { message: pesan(error.message), email, full_name }); }
    if (data.user && data.user.identities?.length === 0) return fail(400, { message: 'Email sudah terdaftar. Silakan masuk.', email, full_name });
    if (data.session) throw redirect(303, '/');
    return { ok: true, message: 'Pendaftaran berhasil. Cek email untuk verifikasi, lalu masuk.' };
  }
};
