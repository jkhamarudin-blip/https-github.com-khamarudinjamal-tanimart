import { redirect } from '@sveltejs/kit';
export const load = async ({ locals }) => {
  if (!locals.user) throw redirect(303, '/login');
  const { data } = await locals.supabase.from('cart_items').select('id, quantity, products(name, price, unit)');
  return { items: data ?? [] };
};
export const actions = {
  add: async ({ request, locals }) => {
    if (!locals.user) throw redirect(303, '/login');
    const pid = String((await request.formData()).get('product_id'));
    let { data: cart } = await locals.supabase.from('carts').select('id').eq('user_id', locals.user.id).maybeSingle();
    if (!cart) ({ data: cart } = await locals.supabase.from('carts').insert({ user_id: locals.user.id }).select('id').single());
    await locals.supabase.from('cart_items').upsert({ cart_id: cart!.id, product_id: pid, quantity: 1 }, { onConflict: 'cart_id,product_id' });
    throw redirect(303, '/cart');
  }
};
