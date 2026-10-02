<script lang="ts">
  let { form } = $props();
</script>
<svelte:head><title>Masuk – TaniMart</title></svelte:head>
<div class="mx-auto max-w-sm px-4 py-12"><h1 class="mb-4 text-2xl font-bold">Masuk</h1>
  {#if form?.message}<p class="mb-3 rounded bg-red-50 p-2 text-sm text-red-700">{form.message}</p>{/if}
  <form method="POST" action="?/login" class="space-y-3">
    <input name="email" type="email" required value={form?.email ?? ''} placeholder="Email" class="w-full rounded border px-3 py-2"/>
    <input name="password" type="password" required placeholder="Kata sandi" class="w-full rounded border px-3 py-2"/>
    <button class="w-full rounded bg-tani-600 py-2 font-semibold text-white">Masuk</button></form>
  <p class="mt-4 text-sm">Belum punya akun? <a href="/register" class="font-semibold text-tani-700">Daftar</a></p></div>
