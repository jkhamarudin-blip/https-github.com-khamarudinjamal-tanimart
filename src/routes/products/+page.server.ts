export const load = async ({ locals, url }) => {
  const q = url.searchParams.get('q') ?? '', sort = url.searchParams.get('sort') ?? 'new';
  const min = Number(url.searchParams.get('min') || 0), max = Number(url.searchParams.get('max') || 0);
  let s = locals.supabase.from('products').select('*, stores(store_name)').eq('status', 'active').gte('price', min);
  if (max) s = s.lte('price', max);
  if (q) s = s.or(`name.ilike.%${q.replace(/[%,]/g, '')}%,description.ilike.%${q.replace(/[%,]/g, '')}%,location.ilike.%${q.replace(/[%,]/g, '')}%`);
  const order: Record<string, [string, boolean]> = { new: ['created_at', false], low: ['price', true], high: ['price', false], sold: ['sold_count', false], rating: ['rating', false] };
  const [col, asc] = order[sort] ?? order.new;
  const { data } = await s.order(col, { ascending: asc }).limit(48);
  return { products: data ?? [], q, sort };
};
