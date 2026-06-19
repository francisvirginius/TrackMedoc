FROM nginx:alpine

RUN rm -f /usr/share/nginx/html/index.html

RUN echo '<!DOCTYPE html><html><head><title>TruckMedoc Dashboard</title><style>body{font-family:Arial;margin:40px;background:#f5f5f5}.container{max-width:800px;margin:0 auto;background:white;padding:20px;border-radius:10px}button{background:#007bff;color:white;padding:10px 20px;border:none;border-radius:5px;cursor:pointer;margin:5px}#result{background:#f8f9fa;padding:15px;margin:15px 0;border-radius:5px;white-space:pre-wrap;border:1px solid #ddd;font-family:monospace}</style></head><body><div class="container"><h1>🚛 TruckMedoc Dashboard</h1><p>Interface pour tester l API Backend C++</p><button onclick="testHealth()">🏥 Health</button><button onclick="testMolecules()">🧪 Molecules</button><button onclick="testMolecule(1)">🔍 Mol #1</button><div id="result">Cliquez pour tester...</div></div><script>const API="http://localhost:8080";async function testApi(e){const r=document.getElementById("result");try{r.textContent="Loading...";const t=await fetch(API+e),n=await t.json();r.textContent=JSON.stringify(n,null,2)}catch(t){r.textContent="Error: "+t.message}}function testHealth(){testApi("/health")}function testMolecules(){testApi("/api/molecules")}function testMolecule(e){testApi("/api/molecules/"+e)}</script></body></html>' > /usr/share/nginx/html/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
