# Resume

Two LaTeX formats live in this folder. Both write `Balbir_Singh_SRE.pdf`.

## resume_v2.tex (current)

Classic single column serif layout with the content kept in a YAML file.

| File | Purpose |
|---|---|
| `resume.yaml` | All resume content. Edit this file. |
| `resume_v2.tex` | Layout and section order |
| `resume_v2.lua` | Reads `resume.yaml` and fills in the layout |
| `tinyyaml.lua` | YAML parser (vendored lua-tinyyaml, MIT license) |
| `logos/` | Certification badges shown in the header |

### Build

Local (needs LuaLaTeX, included in BasicTeX and TeX Live):

```
lualatex -jobname=Balbir_Singh_SRE resume_v2.tex; rm -v Balbir_Singh_SRE.aux Balbir_Singh_SRE.log Balbir_Singh_SRE.out
```

Docker:

```
docker run --rm -v $(pwd):/workdir -w /workdir --entrypoint lualatex fs/xetex-texlive-full -jobname=Balbir_Singh_SRE resume_v2.tex; rm -v Balbir_Singh_SRE.aux Balbir_Singh_SRE.log Balbir_Singh_SRE.out
```

### Editing resume.yaml

- `**text**` is printed in bold. Use it for numbers and metrics, for example `**99.99%**`.
- LaTeX special characters (`& % $ # _ { } ~ ^ \`) are escaped automatically, so write them as plain text.
- Each job has `start` and `end`, printed as `start – end`.
- Badges are listed under `logos`, for example `logos/cka.png` or `logos/aws.png`.
- Contact fields that are left out are skipped. `github` is also supported.
- Quote a value if it starts with `*` or contains `: `.

## resume.tex (original)

Uses the `russell.cls` class with Roboto fonts and the content in `sections/`.

```
docker run --rm -v $(pwd):/workdir -w /workdir fs/xetex-texlive-full -jobname=Balbir_Singh_SRE resume.tex; rm -v Balbir_Singh_SRE.aux; rm -v Balbir_Singh_SRE.log
```
