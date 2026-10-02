<script lang="ts">
  import { rupiah } from '$lib/format';
  let { data } = $props();
  const total = $derived(data.items.reduce((s: number, i: any) => s + i.quantity * i.products.price, 0));
</script>
<div class="mx-auto max-w-3xl px-4 py-8"><h1 class="mb-4 text-2xl font-bold">Keranjang</h1>
  {#each data.items as i}<div class="flex justify-between border-b py-2"><span>{i.products.name} × {i.quantity}</span><span>{rupiah(i.quantity * i.products.price)}</span></div>{:else}<p class="text-stone-500">Keranjang kosong. Tambahkan produk dari katalog.</p>{/each}
  <p class="mt-4 text-right text-xl font-bold">Total {rupiah(total)}</p></div>
