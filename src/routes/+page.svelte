<script lang="ts">
  import ProductCard from '$lib/ProductCard.svelte';
  let { data } = $props();
</script>
<svelte:head><title>TaniMart – Marketplace Pertanian</title></svelte:head>
<section class="bg-tani-900 text-white"><div class="mx-auto max-w-6xl px-4 py-16">
  <h1 class="max-w-2xl text-4xl font-extrabold md:text-5xl">Semua Kebutuhan Pertanian, Dalam Satu Tempat.</h1>
  <p class="mt-4 max-w-xl text-tani-100">Temukan hasil pertanian, benih, pupuk, alat, dan berbagai kebutuhan pertanian dari penjual terpercaya.</p>
  <form action="/products" class="mt-6 flex max-w-xl gap-2"><input name="q" placeholder="Cari produk pertanian..." class="flex-1 rounded px-4 py-3 text-stone-900"/><button class="rounded bg-padi px-5 font-semibold text-stone-900">Cari</button></form>
  <div class="mt-4 flex gap-3"><a href="/products" class="rounded bg-tani-600 px-4 py-2 font-semibold">Belanja Sekarang</a><a href="/login" class="rounded border border-white/40 px-4 py-2">Jual Produk</a></div>
</div></section>
<div class="mx-auto max-w-6xl space-y-10 px-4 pt-10">
  <section><h2 class="mb-3 text-xl font-bold">Kategori</h2><div class="grid grid-cols-2 gap-3 md:grid-cols-4">
    {#each data.cats as c}<a href="/products?kategori={c.slug}" class="rounded-lg border bg-white p-4 font-medium hover:border-tani-600">{c.name}</a>{/each}</div></section>
  {#each [['Produk Terbaru', data.neu], ['Produk Terlaris', data.best]] as [t, list]}
    <section><h2 class="mb-3 text-xl font-bold">{t}</h2><div class="grid grid-cols-2 gap-3 md:grid-cols-4">{#each list as p}<ProductCard {p} />{/each}</div></section>
  {/each}
</div>
