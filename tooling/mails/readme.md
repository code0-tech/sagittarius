# Transactional email templates

A live preview right in your browser so you don't need to keep sending real emails during development.

## Getting Started

First, install the dependencies:

```sh
npm install
# or
yarn
```

Then, run the development server:

```sh
npm run dev
# or
yarn dev
```

Open [localhost:3000](http://localhost:3000) with your browser to see the result.

## Exporting Rails views (`.html.erb`)

```sh
npm run export:erb
```

This renders every template straight into `app/views/<folder>/<template>.html.erb`,
mirroring the folder layout under `emails/`, with each prop emitted as an ERB tag
(`<%= @verification_url %>`, `<%= @user_name %>`, ...). So `emails/user_mailer/`
exports to `app/views/user_mailer/`; add another folder under `emails/` and it
is exported the same way. Supply the matching instance variables from the mailer.

Only the generated `.html.erb` files are overwritten — every other file in
`app/views` (e.g. the hand-written `.text.erb` companions) is left untouched.

How it works (`export-erb.mjs`):

- Each template declares its ERB tags as **default prop values** (e.g.
  `verificationUrl = "<%= @verification_url %>"`). React Email's `email export`
  renders components with no props, so the defaults become the output, while
  `PreviewProps` still drive the dev preview with sample data.
- `email export` renders every template with esbuild using the *lowest common
  ancestor* of the entry points as the output base, which flattens the folder
  names when all templates live under one folder. So the script runs the export
  **once per folder** under `emails/`, preserving the layout regardless of how
  many folders exist.
- Templates are rendered into a throwaway staging directory first (react-email
  wipes its own `--outDir` on every run, which would otherwise clobber sibling
  files in `app/views`), then the generated views are copied over.
- `--extension html.erb` writes `.html.erb` directly.
- React HTML-escapes the tags to `&lt;%= ... %&gt;`; the script restores the
  `<%` / `%>` delimiters before copying.

Notes:

- Folders named `static` or prefixed with `_` under `emails/` are not exported
  as mailer views. The `emails/static/` assets are **not** copied into
  `app/views` — serve those through the Rails asset pipeline instead.
- The footer year comes from `new Date().getFullYear()` (not a prop), so it is
  baked in at export time. Turn it into a prop if you need it dynamic in Rails.
