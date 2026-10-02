<script lang="ts">
  import { rupiah } from '$lib/format';
  let { data } = $props();
  const p = $derived(data.product);
</script>
<div class="mx-auto grid max-w-6xl gap-8 px-4 py-8 md:grid-cols-2">
  <div class="flex aspect-square items-center justify-center rounded-lg bg-tani-50 text-7xl">🌾</div>
  <div><h1 class="text-2xl font-bold">{p.name}</h1>
    <p class="mt-2 text-3xl font-extrabold text-tani-700">{rupiah(p.price)} <span class="text-base font-normal">/ {p.unit}</span></p>
    <p class="mt-2 text-sm text-stone-600">⭐ {p.rating} · terjual {p.sold_count} · stok {p.stock} · {p.stores?.store_name}, {p.location}</p>
    <p class="mt-4">{p.description}</p>
    <form method="POST" action="/cart?/add" class="mt-6 flex gap-3"><input type="hidden" name="product_id" value={p.id}/>
      <button class="rounded bg-tani-600 px-5 py-2 font-semibold text-white">Tambah ke Keranjang</button></form>
    <h2 class="mt-8 font-bold">Ulasan ({data.reviews.length})</h2>
    {#each data.reviews as r}<p class="mt-2 text-sm">⭐ {r.rating} — {r.comment}</p>{/each}</div>
</div>
