# MANGAN O
Prototype aplikasi pesan makanan dengan struktur terpisah.

## Menjalankan
Buka `index.html` di browser.

## Database MySQL
Schema dan data awal tersedia di [database/mangan_o.sql](database/mangan_o.sql).

### Import melalui XAMPP
1. Jalankan Apache dan MySQL dari XAMPP Control Panel.
2. Buka `http://localhost/phpmyadmin`.
3. Pilih menu **Import**, pilih file `database/mangan_o.sql`, lalu klik **Go**.

Database `mangan_o` berisi tabel `users`, `restaurants`, `categories`, `menu_items`,
`addresses`, `orders`, dan `order_items`. Data menu pada database mengikuti data
yang saat ini ada di folder `data`.

Frontend prototype ini masih membaca katalog dari JavaScript dan menyimpan keranjang
serta pesanan di `localStorage`. Agar database digunakan saat aplikasi berjalan,
dibutuhkan backend/API untuk menggantikan sumber data tersebut.

## Struktur
- pages: halaman aplikasi
- css: stylesheet
- js: logika aplikasi
- data: data makanan/restoran/kategori
- assets: tempat gambar dan ikon

Keranjang dan pesanan menggunakan localStorage browser.
"# projectmangano" 
