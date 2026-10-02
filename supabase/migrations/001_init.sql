create extension if not exists pgcrypto;
create table profiles(id uuid primary key default gen_random_uuid(), user_id uuid unique references auth.users on delete cascade, full_name text, email text, phone text, role text not null default 'buyer' check(role in('buyer','seller','admin')), avatar_url text, created_at timestamptz default now(), updated_at timestamptz default now());
create table stores(id uuid primary key default gen_random_uuid(), owner_id uuid references auth.users, store_name text not null, slug text unique not null, description text, logo_url text, location text, phone text, status text default 'active', created_at timestamptz default now(), updated_at timestamptz default now());
create table categories(id uuid primary key default gen_random_uuid(), name text not null, slug text unique not null, description text, image_url text, created_at timestamptz default now());
create table products(id uuid primary key default gen_random_uuid(), seller_id uuid references stores on delete cascade, category_id uuid references categories, name text not null, slug text unique not null, description text, price numeric not null check(price>=0), stock int not null default 0 check(stock>=0), unit text default 'kg', location text, status text default 'active', sold_count int default 0, rating numeric(2,1) default 0, created_at timestamptz default now(), updated_at timestamptz default now());
create table product_images(id uuid primary key default gen_random_uuid(), product_id uuid references products on delete cascade, image_url text not null, sort_order int default 0, created_at timestamptz default now());
create table carts(id uuid primary key default gen_random_uuid(), user_id uuid unique references auth.users on delete cascade, created_at timestamptz default now(), updated_at timestamptz default now());
create table cart_items(id uuid primary key default gen_random_uuid(), cart_id uuid references carts on delete cascade, product_id uuid references products on delete cascade, quantity int not null default 1 check(quantity>0), created_at timestamptz default now(), unique(cart_id,product_id));
create table addresses(id uuid primary key default gen_random_uuid(), user_id uuid references auth.users on delete cascade, recipient_name text, phone text, address text, city text, province text, postal_code text, is_default boolean default false, created_at timestamptz default now(), updated_at timestamptz default now());
create table orders(id uuid primary key default gen_random_uuid(), order_number text unique not null, user_id uuid references auth.users, total_amount numeric not null, shipping_cost numeric default 0, payment_method text check(payment_method in('qris','transfer','cod')), payment_status text default 'pending', order_status text default 'menunggu_pembayaran', shipping_address jsonb, created_at timestamptz default now(), updated_at timestamptz default now());
create table order_items(id uuid primary key default gen_random_uuid(), order_id uuid references orders on delete cascade, product_id uuid references products, seller_id uuid references stores, product_name text not null, price numeric not null, quantity int not null, subtotal numeric not null, created_at timestamptz default now());
create table wishlists(id uuid primary key default gen_random_uuid(), user_id uuid references auth.users on delete cascade, product_id uuid references products on delete cascade, created_at timestamptz default now(), unique(user_id,product_id));
create table reviews(id uuid primary key default gen_random_uuid(), user_id uuid references auth.users, product_id uuid references products on delete cascade, order_id uuid references orders, rating int check(rating between 1 and 5), comment text, created_at timestamptz default now(), updated_at timestamptz default now());
create table notifications(id uuid primary key default gen_random_uuid(), user_id uuid references auth.users on delete cascade, type text, title text, message text, order_id uuid references orders, is_read boolean default false, created_at timestamptz default now());

create function is_admin() returns boolean language sql security definer stable as $$ select exists(select 1 from profiles where user_id=auth.uid() and role='admin') $$;
create function handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$ begin insert into profiles(user_id,full_name,email,role) values(new.id,new.raw_user_meta_data->>'full_name',new.email,'buyer'); return new; end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function handle_new_user();
-- cegah user mengubah role sendiri
create function block_role_change() returns trigger language plpgsql as $$ begin if new.role<>old.role and not is_admin() then new.role:=old.role; end if; return new; end $$;
create trigger profiles_role_guard before update on profiles for each row execute function block_role_change();

do $$ declare t text; begin foreach t in array array['profiles','stores','categories','products','product_images','carts','cart_items','addresses','orders','order_items','wishlists','reviews','notifications'] loop execute format('alter table %I enable row level security',t); end loop; end $$;

create policy "profil sendiri" on profiles for select using(user_id=auth.uid() or is_admin());
create policy "ubah profil sendiri" on profiles for update using(user_id=auth.uid() or is_admin());
create policy "toko publik" on stores for select using(true);
create policy "kelola toko sendiri" on stores for all using(owner_id=auth.uid() or is_admin()) with check(owner_id=auth.uid() or is_admin());
create policy "kategori publik" on categories for select using(true);
create policy "admin kategori" on categories for all using(is_admin()) with check(is_admin());
create policy "produk publik" on products for select using(status='active' or exists(select 1 from stores s where s.id=seller_id and s.owner_id=auth.uid()) or is_admin());
create policy "kelola produk sendiri" on products for all using(exists(select 1 from stores s where s.id=seller_id and s.owner_id=auth.uid()) or is_admin()) with check(exists(select 1 from stores s where s.id=seller_id and s.owner_id=auth.uid()) or is_admin());
create policy "gambar publik" on product_images for select using(true);
create policy "kelola gambar sendiri" on product_images for all using(exists(select 1 from products p join stores s on s.id=p.seller_id where p.id=product_id and s.owner_id=auth.uid()) or is_admin());
create policy "cart sendiri" on carts for all using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy "item cart sendiri" on cart_items for all using(exists(select 1 from carts c where c.id=cart_id and c.user_id=auth.uid())) with check(exists(select 1 from carts c where c.id=cart_id and c.user_id=auth.uid()));
create policy "alamat sendiri" on addresses for all using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy "pesanan sendiri" on orders for select using(user_id=auth.uid() or is_admin() or exists(select 1 from order_items oi join stores s on s.id=oi.seller_id where oi.order_id=orders.id and s.owner_id=auth.uid()));
create policy "buat pesanan sendiri" on orders for insert with check(user_id=auth.uid());
create policy "item pesanan terkait" on order_items for select using(exists(select 1 from orders o where o.id=order_id and o.user_id=auth.uid()) or is_admin() or exists(select 1 from stores s where s.id=seller_id and s.owner_id=auth.uid()));
create policy "wishlist sendiri" on wishlists for all using(user_id=auth.uid()) with check(user_id=auth.uid());
create policy "review publik" on reviews for select using(true);
create policy "review pembeli" on reviews for insert with check(user_id=auth.uid() and exists(select 1 from orders o join order_items oi on oi.order_id=o.id where o.id=order_id and o.user_id=auth.uid() and oi.product_id=reviews.product_id and o.order_status='selesai'));
create policy "notifikasi sendiri" on notifications for all using(user_id=auth.uid()) with check(user_id=auth.uid());

insert into storage.buckets(id,name,public) values('product-images','product-images',true),('avatars','avatars',true),('store-images','store-images',true) on conflict do nothing;
create policy "gambar dibaca publik" on storage.objects for select using(bucket_id in('product-images','avatars','store-images'));
create policy "upload folder sendiri" on storage.objects for insert to authenticated with check(bucket_id in('product-images','avatars','store-images') and (storage.foldername(name))[1]=auth.uid()::text);
