# Résumé

This repository builds four content editions, each as a bachelor's-only and a
master's version:

- **AI security / agent evaluation** (default): agentic reverse engineering,
  security evaluation infrastructure, and the Claude Code security challenge.
- **AI/ML research**: evaluation methodology, agent systems, and ML research.
- **Security engineering**: reverse engineering, cryptography, and security
  benchmark construction.
- **Software/ML engineering**: production ML systems, evaluation infrastructure,
  and the memorAIs project.

Build and verify all eight PDFs:

```sh
make verify
```

The generated PDFs are dated with the UTC build date and written to `build/`:

- `nicholas-assaderaghi-resume-YYYY-MM-DD.pdf` — default AI-security, bachelor's
- `nicholas-assaderaghi-resume-masters-YYYY-MM-DD.pdf` — default AI-security, master's
- `nicholas-assaderaghi-resume-ai-ml-research[-masters]-YYYY-MM-DD.pdf`
- `nicholas-assaderaghi-resume-security-engineering[-masters]-YYYY-MM-DD.pdf`
- `nicholas-assaderaghi-resume-software-ml-engineering[-masters]-YYYY-MM-DD.pdf`

To build a single edition, run its corresponding target; for example:

```sh
make security-engineering-bachelors
make software-ml-engineering-masters
```

Create the GitHub Pages artifact locally:

```sh
make pages
```

This writes the site artifact to `pages-dist/`. Its `index.pdf`, and therefore
the deployed page, is the default AI-security bachelor's-only résumé. The other
editions are generated locally and are not published by GitHub Pages.

Before the first deployment, enable GitHub Pages at **Settings → Pages → Build
and deployment → Source: GitHub Actions**. Pushes to `main` then publish the
Pages artifact.
