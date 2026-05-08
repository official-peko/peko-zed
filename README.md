# Pekoscript for Zed

[Pekoscript](https://pekoui.com) language support for the [Zed](https://zed.dev) editor.

---

## Features

- Syntax highlighting via Tree-sitter
- Full LSP support via the [Pekoscript Language Server](https://github.com/official-peko/pekols)
  - Diagnostics
  - Hover
  - Completions with snippet support
  - Signature help
  - Go to definition
  - Find references
  - Document symbols
  - Workspace symbols
  - Formatting
- Custom file icons for `.peko` files

---

## Installation

Search for **Pekoscript** in the Zed extension marketplace (`cmd+shift+x`) and click Install. The language server binary is downloaded automatically for your platform.

---

## Recommended Settings

Add the following to your Zed `settings.json` for the best experience:

```json
{
  "languages": {
    "Pekoscript": {
      "document_symbols": "on"
    }
  },
  "auto_signature_help": true,
  "show_signature_help_after_edits": true
}
```

`document_symbols: "on"` enables LSP-powered outline and breadcrumb navigation. `auto_signature_help` shows parameter hints automatically when typing `(` or `,`.

---

## Requirements

- Zed 0.150.0 or later
- The language server binary is downloaded automatically — no manual installation required
