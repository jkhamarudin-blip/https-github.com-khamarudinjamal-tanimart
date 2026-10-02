<script lang="ts">
  import { rupiah } from '$lib/format';
  let { p } = $props();
</script>
<a href="/products/{p.slug}" class="block rounded-lg border bg-white p-3 hover:border-tani-600">
  <div class="mb-2 flex aspect-square items-center justify-center rounded bg-tani-50 text-4xl">🌾</div>
  <h3 class="line-clamp-2 text-sm font-semibold">{p.name}</h3>
  <p class="font-bold text-tani-700">{rupiah(p.price)} <span class="text-xs font-normal text-stone-500">/ {p.unit}</span></p>
  <p class="text-xs text-stone-500">⭐ {p.rating} · terjual {p.sold_count} · {p.location}</p>
  <p class="text-xs text-stone-500">{p.stores?.store_name}</p>
</a>
