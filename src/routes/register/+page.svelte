<script lang="ts">
  let { form } = $props();
</script>
<svelte:head><title>Daftar – TaniMart</title></svelte:head>
<div class="mx-auto max-w-sm px-4 py-12"><h1 class="mb-4 text-2xl font-bold">Daftar</h1>
  {#if form?.message}<p class="mb-3 rounded p-2 text-sm {form.ok ? 'bg-tani-50 text-tani-900' : 'bg-red-50 text-red-700'}">{form.message}</p>{/if}
  <form method="POST" class="space-y-3">
    <input name="full_name" required value={form?.full_name ?? ''} placeholder="Nama lengkap" class="w-full rounded border px-3 py-2"/>
    <input name="email" type="email" required value={form?.email ?? ''} placeholder="Email" class="w-full rounded border px-3 py-2"/>
    <input name="password" type="password" required minlength="6" placeholder="Kata sandi (min. 6 karakter)" class="w-full rounded border px-3 py-2"/>
    <button class="w-full rounded bg-tani-600 py-2 font-semibold text-white">Daftar</button></form>
  <p class="mt-4 text-sm">Sudah punya akun? <a href="/login" class="font-semibold text-tani-700">Masuk</a></p></div>
