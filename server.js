const express = require('express');
const cors = require('cors');
const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

// Enable CORS so the Flutter Web App can talk to us
app.use(cors());
app.use(express.json());

// Hardcoded credentials as requested (kept from original script)
// In a real production app, these should be env vars, but we keep user's flow.
const USER_CREDS = '70673230';
const PASS_CREDS = 'Elfaro2018';

// --- LOGGING HELPER ---
const LOG_FILE = path.join(__dirname, 'scraped_log.txt');

function logToFile(message) {
    const timestamp = new Date().toLocaleString();
    const logEntry = `[${timestamp}] ${message}\n`;

    fs.appendFile(LOG_FILE, logEntry, (err) => {
        if (err) console.error('Error writing to log file:', err);
    });
}

console.log('--- INICIANDO SERVIDOR ROBOT HOSPITALARIO ---');

app.get('/', (req, res) => {
    res.json({ status: 'online', message: 'Robot de Laboratorio listo para recibir órdenes.' });
});

app.get('/scrape/:dni', async (req, res) => {
    const targetDni = req.params.dni;
    console.log(`\n[PETICIÓN RECIBIDA] Buscando DNI: ${targetDni}`);
    logToFile(`PETICIÓN RECIBIDA - DNI: ${targetDni}`);

    let browser;
    try {
        console.log(' Lanzando navegador oculto...');
        browser = await puppeteer.launch({
            headless: "new", // Run in background (segundo plano)
            defaultViewport: null,
            args: ['--no-sandbox', '--disable-setuid-sandbox']
        });

        const page = await browser.newPage();

        // --- CONFIGURACIÓN DE LENTITUD (SOLUCIÓN A "TODO LO HACE RÁPIDO") ---
        page.setDefaultNavigationTimeout(60000); // 60 segundos de paciencia para navegar
        page.setDefaultTimeout(60000); // 60 segundos para esperar elementos

        // --- STEP 1: LOGIN ---
        console.log(' Navegando al portal...');
        await page.goto('https://www.hrdt.gob.pe/sighov2/', { waitUntil: 'domcontentloaded' });

        await page.waitForSelector('#txtUser', { visible: true });
        await page.type('#txtUser', USER_CREDS, { delay: 120 }); // Escribir lento
        await page.type('#txtPass', PASS_CREDS, { delay: 120 });
        await page.click('#btnIngresar');

        // Esperamos navegación o que desaparezca el login para confirmar sesión
        await Promise.race([
            page.waitForNavigation({ waitUntil: 'domcontentloaded', timeout: 15000 }).catch(() => null),
            page.waitForSelector('#btnIngresar', { hidden: true, timeout: 15000 }).catch(() => null),
        ]);

        const stillOnLogin = await page.$('#btnIngresar');
        if (stillOnLogin) {
            throw new Error('El portal no dejó iniciar sesión (¿captcha o credenciales bloqueadas?).');
        }

        // --- STEP 2: IR DIRECTO AL MÓDULO DE LABORATORIO ---
        const directLabUrl = `https://www.hrdt.gob.pe/sighov2/modulos/historiaclinica/frmVerHistoria.php?id=${targetDni}&val=6`;
        console.log(` Navegación DIRECTA al laboratorio: ${directLabUrl}`);
        const resp = await page.goto(directLabUrl, { waitUntil: 'domcontentloaded', timeout: 60000 });

        if (!resp || !resp.ok()) {
            throw new Error(`No se pudo abrir la historia clínica (status ${resp ? resp.status() : 'sin respuesta'})`);
        }

        // Espera mínima para que terminen de cargar frames/iframes
        await page.waitForTimeout(8000);
        console.log(' Buscando frames y texto en la página...');

        // --- STEP 3: LECTURA DE TEXTO (PÁGINA + FRAMES) ---
        const parseLabsFromText = (text) => {
            const extract = (regex) => {
                const match = text.match(regex);
                return match ? match[1] : null;
            };

            const labs = {
                hemoglobina: extract(/Hemoglobina\s*[:.-]?\s*(\d+(?:\.\d+)?)/i) || extract(/Hb\s*(\d+(?:\.\d+)?)/i),
                leucocitos: extract(/Leucocitos\s*[:.-]?\s*(\d+(?:\.\d+)?)/i),
                plaquetas: extract(/Plaquetas\s*[:.-]?\s*(\d+(?:\.\d+)?)/i),
                creatinina: extract(/Creatinina\s*[:.-]?\s*(\d+(?:\.\d+)?)/i),
                urea: extract(/Urea\s*[:.-]?\s*(\d+(?:\.\d+)?)/i),
            };

            const hasData = Object.values(labs).some(Boolean);
            return hasData ? labs : null;
        };

        let scrapedData = null;
        const textSnapshots = [];

        const pullTextFromFrame = async (frame) => {
            try {
                const text = await frame.evaluate(() => document.body ? document.body.innerText : '');
                if (text && text.trim().length) {
                    textSnapshots.push({ frame: frame.url() || frame.name(), sample: text.slice(0, 2000) });
                    if (!scrapedData) {
                        const labs = parseLabsFromText(text);
                        if (labs) {
                            scrapedData = { labs, frameUrl: frame.url() };
                        }
                    }
                }
            } catch (err) {
                // Some frames may be cross‑origin; ignore errors
            }
        };

        await pullTextFromFrame(page);
        for (const frame of page.frames()) {
            await pullTextFromFrame(frame);
        }

        if (!scrapedData) {
            // Si no hay coincidencias, devolvemos el texto para que el cliente vea qué está llegando.
            console.log('⚠️ No se detectaron laboratorios con las regex actuales.');
            logToFile(`WARNING: No se detectaron laboratorios para DNI ${targetDni}.`);
            logToFile(`SNAPSHOT TEXTO IMPRESO:\n${JSON.stringify(textSnapshots, null, 2)}`);
            return res.status(404).json({
                success: false,
                error: 'No se detectaron valores de laboratorio en la página.',
                textSnapshots
            });
        }

        console.log(' Datos obtenidos:', scrapedData.labs);
        logToFile(`EXITO: Datos obtenidos para DNI ${targetDni}:\n${JSON.stringify(scrapedData.labs, null, 2)}`);
        res.json({ success: true, data: scrapedData, textSnapshots });

    } catch (e) {
        console.error(' Error:', e.message);
        logToFile(`ERROR FATAL para DNI ${targetDni}: ${e.message}`);

        // Try to take a screenshot if browser is open
        if (browser) {
            try {
                const pages = await browser.pages();
                if (pages.length > 0) {
                    await pages[0].screenshot({ path: path.join(__dirname, 'error_snapshot.png') });
                    logToFile('SNAPSHOT ERROR guardado en error_snapshot.png');
                }
            } catch (err) {
                console.error('No se pudo tomar foto del error:', err);
            }
        }

        res.status(500).json({ success: false, error: e.message });
    } finally {
        if (browser) await browser.close();
    }
});

app.listen(PORT, () => {
    console.log(`\n✅ SERVIDOR ROBOT ACTIVO EN: http://localhost:${PORT}`);
    console.log('   (Minimiza esta ventana, no la cierres)');
});
