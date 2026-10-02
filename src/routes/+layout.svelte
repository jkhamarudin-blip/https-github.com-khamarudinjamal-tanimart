<script lang="ts">
  import '../app.css';
  let { data, children } = $props();
  let open = $state(false);
  const links = [['/', 'Beranda'], ['/products', 'Produk'], ['/products', 'Kategori'], ['/products', 'Promo'], ['/', 'Tentang Kami'], ['/', 'Bantuan']];
</script>
<header class="sticky top-0 z-40 border-b border-tani-100 bg-white/95 backdrop-blur">
  <div class="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
    <a href="/" class="text-xl font-extrabold text-tani-700">🌱 TaniMart</a>
    <nav class="hidden gap-6 text-sm font-medium md:flex">{#each links as [h, t]}<a href={h} class="hover:text-tani-600">{t}</a>{/each}</nav>
    <div class="flex items-center gap-3 text-sm">
      <a href="/products">Cari</a><a href="/cart">Keranjang</a>
      {#if data.user}<form method="POST" action="/login?/logout"><button class="text-tani-700">Keluar</button></form>{:else}<a href="/login" class="rounded bg-tani-600 px-3 py-1.5 text-white">Masuk</a>{/if}
      <button class="md:hidden" onclick={() => (open = !open)} aria-label="Menu">☰</button>
    </div>
  </div>
  {#if open}<nav class="flex flex-col gap-2 border-t px-4 py-3 md:hidden">{#each links as [h, t]}<a href={h}>{t}</a>{/each}</nav>{/if}
</header>
<main>{@render children()}</main>
<footer class="mt-16 border-t py-8 text-center text-sm text-stone-500">© TaniMart. Marketplace pertanian.</footer>
