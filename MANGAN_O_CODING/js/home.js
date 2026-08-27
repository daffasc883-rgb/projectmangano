const catBox=document.getElementById('categories'),grid=document.getElementById('foodGrid');
catBox.innerHTML=kategori.map(c=>`<button class="category" onclick="showCategory('${c[0]}')"><span>${c[1]}</span><b>${c[0]}</b></button>`).join('');
function showCategory(cat){const list=cat==='Semua'?makanan:makanan.filter(x=>x.kategori===cat);renderFoods(list)}
function renderFoods(list){grid.innerHTML=list.map(f=>`<article class="food-card"><div class="food-img">${f.emoji}</div><div class="food-info"><h3>${f.nama}</h3><div class="muted">${f.restoran} · ⭐ 4.8</div><div class="price">${formatRupiah(f.harga)}</div><button class="add-btn" onclick="addToCart('${f.id}')">+ Tambah</button></div></article>`).join('')}
renderFoods(makanan.slice(0,4));