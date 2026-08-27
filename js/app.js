function formatRupiah(n){return new Intl.NumberFormat('id-ID',{style:'currency',currency:'IDR',maximumFractionDigits:0}).format(n)}
function getCart(){return JSON.parse(localStorage.getItem('mangan_cart')||'[]')}
function saveCart(c){localStorage.setItem('mangan_cart',JSON.stringify(c));updateCartCount()}
function updateCartCount(){const el=document.getElementById('cartCount');if(el)el.textContent=getCart().reduce((s,x)=>s+x.qty,0)}
function addToCart(id){const c=getCart(),f=makanan.find(x=>x.id===id),item=c.find(x=>x.id===id);if(!f)return;if(item)item.qty++;else c.push({id,qty:1});saveCart(c);alert(f.nama+' ditambahkan ke keranjang')}
function removeFromCart(id){saveCart(getCart().filter(x=>x.id!==id));if(typeof renderCart==='function')renderCart()}
updateCartCount();