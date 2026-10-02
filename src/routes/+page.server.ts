export const load = async ({ locals }) => {
  const q = () => locals.supabase.from('products').select('*, stores(store_name)').eq('status', 'active');
  const [neu, best, cats] = await Promise.all([q().order('created_at', { ascending: false }).limit(8), q().order('sold_count', { ascending: false }).limit(8), locals.supabase.from('categories').select('*')]);
  return { neu: neu.data ?? [], best: best.data ?? [], cats: cats.data ?? [] };
};
