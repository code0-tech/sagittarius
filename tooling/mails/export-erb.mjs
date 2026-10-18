/**
 * Exports every mailer folder under `emails/` straight into the matching Rails
 * view folder as `<template>.html.erb`, mirroring the folder layout:
 *
 *   emails/<mailer>/                     -> app/views/<mailer>/
 *   emails/extensions/<ext>/<mailer>/    -> extensions/<ext>/app/views/<mailer>/
 *
 * Only the `.html.erb` files this script generates are overwritten — every other
 * file in the view folders (e.g. the hand-written `.text.erb` companions) is left
 * untouched. To guarantee that, templates are rendered into a throwaway staging
 * directory first (react-email wipes its own `--outDir` on every run, which would
 * otherwise clobber sibling files), and only the generated views are copied over.
 *
 * Why the per-folder export: react-email's `email export` renders all templates
 * with esbuild using the *lowest common ancestor* of the entry points as the
 * output base. When every template lives under a single folder (e.g.
 * `emails/invoice_mailer/`), that folder is the common ancestor and gets
 * stripped, flattening the output. Running the export once per mailer folder
 * keeps each folder as its own output directory, so
 * `emails/invoice_mailer/finalized.tsx` lands at
 * `app/views/invoice_mailer/finalized.html.erb`, and new folders are handled
 * automatically.
 *
 * The templates carry ERB tags (`<%= ... %>`) as default prop values, which
 * React HTML-escapes to `&lt;%= ... %&gt;` while rendering. We restore the
 * `<%` / `%>` delimiters before copying (those escaped sequences never occur
 * naturally, so the replacement is safe).
 */
import { spawnSync } from "node:child_process"
import { mkdir, mkdtemp, readdir, readFile, rm, writeFile } from "node:fs/promises"
import { tmpdir } from "node:os"
import { fileURLToPath } from "node:url"
import { dirname, join, relative, resolve } from "node:path"

const projectDir = dirname(fileURLToPath(import.meta.url))
const emailsDir = resolve(projectDir, "emails")
const railsRoot = resolve(projectDir, "../..")
const emailBin = resolve(projectDir, "node_modules/react-email/dist/cli/index.mjs")

// `static` holds shared assets and `_`-prefixed folders are private to
// react-email, so neither maps to a Rails mailer view folder.
const isMailerDir = (entry) => entry.isDirectory() && entry.name !== "static" && !entry.name.startsWith("_")

async function mailerDirsIn(dir) {
    return (await readdir(dir, { withFileTypes: true })).filter(isMailerDir).map((entry) => entry.name)
}

// Every mailer folder paired with the Rails view folder it exports to. Folders
// directly under `emails/` are core mailers; those under `emails/extensions/`
// belong to an extension and export into that extension's own view path.
const mailers = []

for (const name of await mailerDirsIn(emailsDir)) {
    if (name === "extensions") {
        const extensionsDir = join(emailsDir, name)
        for (const extension of await mailerDirsIn(extensionsDir)) {
            for (const mailer of await mailerDirsIn(join(extensionsDir, extension))) {
                mailers.push({
                    source: join("extensions", extension, mailer),
                    target: join(railsRoot, "extensions", extension, "app/views", mailer),
                })
            }
        }
        continue
    }

    mailers.push({ source: name, target: join(railsRoot, "app/views", name) })
}

if (mailers.length === 0) {
    console.error(`No mailer folders found under ${emailsDir}`)
    process.exit(1)
}

// Collect every generated `.html.erb` under `dir`, keeping its path relative to `dir`.
async function collectViews(dir, base = dir) {
    const views = []
    for (const entry of await readdir(dir, { withFileTypes: true })) {
        const path = join(dir, entry.name)
        if (entry.isDirectory()) {
            views.push(...(await collectViews(path, base)))
        } else if (entry.name.endsWith(".html.erb")) {
            views.push(relative(base, path))
        }
    }
    return views
}

// Stage into a throwaway dir so react-email's outDir wipe never touches the views.
const stagingDir = await mkdtemp(join(tmpdir(), "mails-"))
const written = []

try {
    for (const { source, target } of mailers) {
        const stageSub = join(stagingDir, source)
        const result = spawnSync(
            process.execPath,
            // Posix separators: `--dir` is interpreted relative to the react-email project.
            [emailBin, "export", "--pretty", "--extension", "html.erb", "--dir", `emails/${source.split(/[\\/]/).join("/")}`, "--outDir", stageSub],
            { cwd: projectDir, stdio: "inherit" },
        )
        if (result.status !== 0) process.exit(result.status ?? 1)

        for (const view of await collectViews(stageSub)) {
            const restored = (await readFile(join(stageSub, view), "utf8"))
                .replaceAll("&lt;%", "<%")
                .replaceAll("%&gt;", "%>")
            const targetPath = join(target, view)
            await mkdir(dirname(targetPath), { recursive: true })
            await writeFile(targetPath, restored, "utf8")
            written.push(relative(railsRoot, targetPath))
        }
    }
} finally {
    await rm(stagingDir, { recursive: true, force: true })
}

console.log(`Wrote ${written.length} view(s):`)
for (const path of written) console.log(`  ${path}`)
