// From AGS wiki
// https://aylur.github.io/ags-docs/config/type-checking/

// TODO: Just move config.ts and music.ts to a src/ folder
// TODO: Split up stylesheet? (and folderize)
//       Maybe a stylesheet for each widget?
const entry = App.configDir + "/config.ts";
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

