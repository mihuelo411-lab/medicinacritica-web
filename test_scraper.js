const puppeteer = require('puppeteer');

(async () => {
    const user = '70673230';
    const pass = 'Elfaro2018';
    // const userHcl = '123456'; // PENDING USER INPUT

    console.log('--- INICIANDO ROBOT DE PRUEBA ---');
    console.log('Lanzando navegador...');

    const browser = await puppeteer.launch({
        headless: "new", // Headless mode
        args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();

    try {
        console.log('Navegando al portal...');
        await page.goto('https://www.hrdt.gob.pe/sighov2/', { waitUntil: 'networkidle2' });

        console.log('Portal cargado. Intentando Login...');

        // Fill credentials
        await page.type('#txtUser', user);
        await page.type('#txtPass', pass);

        // Click login
        await Promise.all([
            page.click('#btnIngresar'),
            page.waitForNavigation({ waitUntil: 'networkidle2' }).catch(e => console.log('No navigation occurred immediately...'))
        ]);

        // Check if login succeeded
        const url = page.url();
        console.log(`URL actual: ${url}`);

        if (url.includes('index.php')) {
            console.log('✅ LOGIN EXITOSO. Estamos dentro.');

            // Go to search page
            console.log('Navegando a Historia Clínica...');
            await page.goto('https://www.hrdt.gob.pe/sighov2/modulos/historiaclinica/frmVerHistoria.php', { waitUntil: 'networkidle2' });

            console.log('Pantalla de búsqueda cargada.');
            // Screenshot to verify
            // await page.screenshot({ path: 'search_page.png' });

            console.log('⚠️ ESPERANDO HCL DEL USUARIO PARA CONTINUAR...');
        } else {
            console.log('❌ LOGIN FALLÓ. Probablemente credenciales o ReCAPTCHA.');
            // Print error message from page if possible
            const errorMsg = await page.evaluate(() => {
                const el = document.querySelector('.alertify-message'); // Guessing class based on alertify lib usage
                return el ? el.innerText : 'No se encontró mensaje de error claro';
            });
            console.log('Mensaje en pantalla: ' + errorMsg);
        }

    } catch (error) {
        console.error('Error fatal:', error);
    } finally {
        await browser.close();
        console.log('--- FIN DE LA PRUEBA ---');
    }
})();
