<script lang="ts">
  import ProductCard from '$lib/ProductCard.svelte';
  let { data } = $props();
</script>
<div class="mx-auto max-w-6xl px-4 py-8">
  <form class="mb-6 flex flex-wrap gap-2"><input name="q" value={data.q} placeholder="Cari produk pertanian..." class="min-w-0 flex-1 rounded border px-3 py-2"/>
    <input name="min" type="number" placeholder="Harga min" class="w-28 rounded border px-3 py-2"/><input name="max" type="number" placeholder="Harga maks" class="w-28 rounded border px-3 py-2"/>
    <select name="sort" class="rounded border px-3 py-2"><option value="new">Terbaru</option><option value="low">Harga terendah</option><option value="high">Harga tertinggi</option><option value="sold">Terlaris</option><option value="rating">Rating tertinggi</option></select>
    <button class="rounded bg-tani-600 px-4 py-2 text-white">Terapkan</button></form>
  {#if data.products.length}<div class="grid grid-cols-2 gap-3 md:grid-cols-4">{#each data.products as p}<ProductCard {p} />{/each}</div>
  {:else}<p class="text-stone-500">Produk tidak ditemukan. Ubah kata kunci atau filter.</p>{/if}
</div>
