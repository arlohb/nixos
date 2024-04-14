// From AGS wiki
// https://aylur.github.io/ags-docs/config/type-checking/

const entry = App.configDir + "/src/config.ts";
const outdir = "/tmp/ags/js"

try {
    await Utils.execAsync([
        'bun', 'build', entry,
        '--outdir', outdir,
        '--external', 'resource://*',
        '--external', 'gi://*',
    ]);
    await import(`file://${outdir}/config.js`);
} catch (error) {
    console.error(error);
}

