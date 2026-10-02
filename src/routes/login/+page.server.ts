import { fail, redirect } from '@sveltejs/kit';
import { pesan } from '$lib/auth';
export const load = async ({ locals }) => { if (locals.user) throw redirect(303, '/'); return {}; };
export const actions = {
  login: async ({ request, locals }) => {
    const f = await request.formData();
    const email = String(f.get('email') ?? '').trim();
    const { error } = await locals.supabase.auth.signInWithPassword({ email, password: String(f.get('password') ?? '') });
    if (error) { console.error('login:', error.message); return fail(400, { message: pesan(error.message), email }); }
    throw redirect(303, '/');
  },
  logout: async ({ locals }) => { await locals.supabase.auth.signOut(); throw redirect(303, '/'); }
};
