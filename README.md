# Résumé

This repository builds one balanced résumé in two education variants:

- bachelor's-only
- bachelor's plus anticipated Columbia MS in Computer Science

The shared content represents AI/ML systems, agentic security evaluation,
security engineering, and software/product work.

Build and verify both PDFs:

```sh
make verify
```

The generated PDFs are dated with the UTC build date and written to `build/`:

- `nicholas-assaderaghi-resume-YYYY-MM-DD.pdf` — bachelor's-only
- `nicholas-assaderaghi-resume-masters-YYYY-MM-DD.pdf` — master's version

Create the GitHub Pages artifact locally:

```sh
make pages
```

This writes the site artifact to `pages-dist/`. Its `index.pdf`, and therefore
the deployed page, is the bachelor's-only résumé.

Before the first deployment, enable GitHub Pages at **Settings → Pages → Build
and deployment → Source: GitHub Actions**. Pushes to `main` then publish the
Pages artifact.
