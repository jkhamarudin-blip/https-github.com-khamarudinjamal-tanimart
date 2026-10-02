import { createServerClient } from '@supabase/ssr';
import { PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY } from '$env/static/public';
import type { Handle } from '@sveltejs/kit';
export const handle: Handle = async ({ event, resolve }) => {
  event.locals.supabase = createServerClient(PUBLIC_SUPABASE_URL, PUBLIC_SUPABASE_ANON_KEY, {
    cookies: { getAll: () => event.cookies.getAll(),
      setAll: (c) => c.forEach(({ name, value, options }) => event.cookies.set(name, value, { ...options, path: '/' })) } });
  const { data } = await event.locals.supabase.auth.getUser();
  event.locals.user = data.user; event.locals.session = null;
  return resolve(event, { filterSerializedResponseHeaders: (n) => n === 'content-range' || n === 'x-supabase-api-version' });
};
