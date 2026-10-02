-- Aman dijalankan berulang. Memperbaiki trigger profil dan membuat profil untuk akun yang sudah ada.
create or replace function handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin
  insert into public.profiles(user_id,full_name,email,role) values(new.id,new.raw_user_meta_data->>'full_name',new.email,'buyer') on conflict (user_id) do nothing;
  return new;
exception when others then
  return new; -- jangan gagalkan pendaftaran karena profil
end $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute function handle_new_user();
insert into public.profiles(user_id,full_name,email,role)
select id,raw_user_meta_data->>'full_name',email,'buyer' from auth.users on conflict (user_id) do nothing;
