import esbuild from 'esbuild';
import archiver from 'archiver';
import fs from 'fs';
import path from 'path';

async function build() {
  const entry = path.resolve('src/functions/index.mjs');
  const outDir = path.resolve('dist');
  const outfile = path.join(outDir, 'index.js');
  const zipPath = path.join(outDir, 'function.zip');

  if (!fs.existsSync(outDir)) fs.mkdirSync(outDir, { recursive: true });

  console.log('Bundling with esbuild...');
  await esbuild.build({
    entryPoints: [entry],
    bundle: true,
    platform: 'node',
    target: ['node14'],
    format: 'cjs',
    outfile,
    sourcemap: false,
  });

  console.log('Creating zip:', zipPath);
  const output = fs.createWriteStream(zipPath);
  const archive = archiver('zip', { zlib: { level: 9 } });

  return new Promise((resolve, reject) => {
    output.on('close', () => {
      console.log('Zip created:', zipPath, '-', archive.pointer(), 'bytes');
      resolve();
    });
    archive.on('error', (err) => reject(err));
    archive.pipe(output);
    archive.file(outfile, { name: 'index.js' });
    archive.finalize();
  });
}

build().catch((err) => {
  console.error(err);
  process.exit(1);
});
