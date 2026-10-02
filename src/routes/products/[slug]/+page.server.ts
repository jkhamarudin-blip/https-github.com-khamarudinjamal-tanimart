import { error } from '@sveltejs/kit';
export const load = async ({ locals, params }) => {
  const { data } = await locals.supabase.from('products').select('*, stores(store_name, location), product_images(image_url)').eq('slug', params.slug).maybeSingle();
  if (!data) throw error(404, 'Produk tidak ditemukan');
  const { data: reviews } = await locals.supabase.from('reviews').select('rating, comment, created_at').eq('product_id', data.id);
  return { product: data, reviews: reviews ?? [] };
};
