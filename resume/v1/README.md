# Resume v1

Original layout using the `russell.cls` class with Roboto fonts.

| File | Purpose |
|---|---|
| `resume.tex` | Main file, sets colors and section order |
| `sections/` | Resume content, one file per section |
| `russell.cls` | Layout class |
| `fonts/` | Roboto and FontAwesome fonts |
| `logos/` | Certification badges shown in the header |
| `Balbir_Singh_SRE.pdf` | Built resume |

## Build

Run from this folder:

```
docker run --rm -v $(pwd):/workdir -w /workdir fs/xetex-texlive-full -jobname=Balbir_Singh_SRE resume.tex; rm -v Balbir_Singh_SRE.aux; rm -v Balbir_Singh_SRE.log
```
