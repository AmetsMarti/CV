#set page(
  paper: "a4",
  margin: (x: 1.6cm, y: 1.7cm),
  fill: rgb("F8F5F2")
)

#set text(
  font: "Libron H",
  size: 10pt,
  fill: rgb("35271F")
)

#import "@preview/fontawesome:0.6.0": fa-icon

#let green-color = rgb("2C4C3B")
#let skill-bg = rgb("EAEAEA")

// Estilos auxiliares
#let section-title(title) = {
  v(0.45cm)
  text(fill: green-color, weight: "bold", size: 1.15em)[#title]
  v(-0.3em)
  line(length: 100%, stroke: 0.5pt + green-color)
  v(0.2cm)
}


// Icono de herramienta (SVG monocromo de Simple Icons, teñido de verde)
#let ico(nombre) = "logos/tools/" + nombre + ".svg"
#let tool-icon(path) = box(
  height: 1em, baseline: 12%,
  image(
    bytes(read(path).replace("<svg ", "<svg fill=\"#2C4C3B\" ")),
    format: "svg", height: 100%,
  ),
)

// Chip de herramienta: acepta "Nombre" o ("Nombre", ruta-del-icono)
#let skill-pill(item) = {
  let name = if type(item) == array { item.at(0) } else { item }
  let icon = if type(item) == array { item.at(1) } else { none }
  box(
    fill: skill-bg,
    stroke: none,
    inset: (x: 5pt, y: 3pt),
    radius: 3pt,
    baseline: 10%,
    text(size: 8.5pt)[#if icon != none [#tool-icon(icon)#h(0.35em)]#name]
  )
}

// Entrada de experiencia: título, fecha, descripción y palabras clave
// last: true => no añade espacio final (para la última entrada de la sección)
#let exp-entry(title, date, desc, keywords, last: false) = {
  grid(
    columns: (1fr, auto),
    align: (left, right + bottom),
    text(weight: "bold")[#title],
    text(fill: luma(100), size: 8.5pt)[#date],
  )
  if desc != none [#text(size: 9pt)[#desc]]
  if keywords.len() > 0 {
    v(0.15cm)
    keywords.map(skill-pill).join(h(4pt))
  }
  if not last { v(0.3cm) }
}

// Entrada de contacto (estilo modern-cv): icono + texto, alineado a la derecha
#let contact-row(icon, label) = [
  #fa-icon(icon) #h(0.4em) #label
]

// ============================================================
//  IKASKETAK — logotipoekin
// ============================================================

// Unibertsitateetako logoak (logos/ karpetan)
#let logos = (
  ehu: "logos/ehu.svg",
  upna: "logos/upna.svg",
  sapienza: "logos/sapienza.svg",
)

// Marra: logoa, edo siglaren monograma fall-back gisa.
#let marca(logo, sigla, sub: false) = {
  let s = if sub { 0.55cm } else { 0.75cm }
  if logo != none {
    box(width: if sub { 0.9cm } else { 0.75cm } + 0pt, height: s, image(logo, height: s, fit: "contain"))
  } else {
    box(
      width: 0.75cm, height: s, radius: 3pt,
      fill: green-color.lighten(85%), stroke: 0.6pt + green-color.lighten(40%),
      align(center + horizon, text(size: 7.5pt, weight: "bold", fill: green-color, sigla)),
    )
  }
}

// Xehetasun-etiketa txikia
#let etiqueta(estud-icono, texto) = box(
  stroke: none,
  inset: (x: 4pt, y: 3pt), baseline: 1pt,
  text(size: 7pt, [#text(fill: green-color, weight: "bold", [#fa-icon(estud-icono)]) #h(0.25em) #texto]),
)

// Ikasketen sarrera: logo/sigla + izenburua + xehetasuna + txipak.
// sub: true => sarrera alaba (indentatuta, marca txikiagoarekin)
// Ikasketen taldeak banatzeko lerro dashaduna
#let separator-estudios() = block(
  above: 0.1cm, below: 0.25cm,
  line(length: 100%, stroke: (paint: rgb("C9D6CF"), thickness: 0.5pt, dash: "dashed")),
)

// Ikasketetako sarrera bat: logo/sigla + izenburua + xehetasuna + chips.
// sub: true => sarrera umea (dendratua eta marka txikiagoarekin)
// grupo: true => markarik gabeko sarrera taldekatua (batxilergoa, lehen hezkuntza)
#let estudio(logo, sigla, titulo, detalle: none, en-curso: false, chips: (), sub: false, grupo: false) = {
  let content = {
    text(weight: "bold", size: if sub { 9.5pt } else { 10pt }, titulo)
    if detalle != none or en-curso {
      text(size: 9pt, fill: luma(100))[
        #linebreak()
        #if detalle != none [#detalle]
        #if en-curso [#if detalle != none [#h(4pt)·#h(4pt)] Bukatu gabe]
      ]
    }
    if chips.len() > 0 {
      v(0.06cm)
      chips.map(d => etiqueta(d.at(0), d.at(1))).join(h(5pt))
    }
  }
  if grupo {
    block(breakable: false, below: 0.3cm, box(inset: (left: 0.85cm), content))
  } else {
    block(
      breakable: false, below: if sub { 0.5cm } else { 0.4cm },
      box(
        inset: (left: if sub { 1.35cm } else { 0pt }),
        stroke: none,
        grid(
          columns: (0.75cm, 1fr),
          column-gutter: 10pt,
          align: (center + horizon, left + top),
          marca(logo, sigla, sub: sub),
          content,
        ),
      ),
    )
  }
}

// Cabecera: Foto + Nombre + Contacto (estilo modern-cv)
#grid(
  columns: (18%, 1fr, 34%),
  gutter: 0.6cm,
  align: (center + horizon, center + horizon, right + horizon),
  rotate(
    2deg,
    rect(
      stroke: 2pt + black,
      fill: white,
      inset: 4pt,
      image("amets4.jpg", width: 2.4cm)
    )
  ),
  align(
    center,
    text(size: 1.45em, weight: "bold")[Amets Martiarena Elosegi]
  ),
  stack(
    dir: ttb,
    spacing: 0.55em,
    contact-row("phone", [688 73 63 86]),
    contact-row("envelope", [amartiarena017\@gmail.com]),
    contact-row("house", [Azkue Kalea 3, 1-D. Ibarra. Gipuzkoa]),
    contact-row("calendar", [2004/07/20]),
    contact-row("github", [github.com/AmetsMarti]),
  ),
)

// Idiomas
#section-title("Hizkuntzak")

#grid(
  columns: (auto, 1fr, auto, 1fr),
  column-gutter: 0.8cm,
  row-gutter: 0.35em,
  [*Euskara*], [Ama hizkuntza],
  [*Gaztelania*], [Ama hizkuntza],
  [*Ingelesa*], [B2 maila],
  [*Italiera*], [A1 maila],
)

// Experiencia
#section-title("Lan experientzia")

#exp-entry(
  "Praktikak Developair Technologies-en",
  "2025 - 2 Hilabete",
  [Software garapen ingeniari bezala, Developair empresak garatzen duen zerbitzuaren erabilpenaren ikusketarako _Dashboard_ baten diseinua eta implementazioa. Eskala handiko proiektu batean esku sartzea eta garatzaileekin lankidetza.],
  (("React", ico("react")), ("Redux", ico("redux")), ("GitHub", ico("github"))),
)
#exp-entry(
  "Gradu amaierako lana Lortek-en",
  "2026 - 5 Hilabete",
  [Arku soldadurako denbora errealeko akatsen detekzio automatizaturako sistema baten diseinua, _Machine Learning_ eta software garapenaren ikuspegitik. Mlops tekniken aplikazioa, ereduen diseinu eta konparaketak, eta benetazko denbora errealeko soldadurekin frogak.],
  (("PyTorch", ico("pytorch")), ("MQTT", ico("mqtt")), ("Mlflow", ico("mlflow")), ("Gradio", ico("gradio"))),
  last: true,
)

// Formación académica
#section-title("Ikasketak")

#estudio(
  logos.upna, "UP", "Unibertsitate masterra Machine Learning-ean",
  detalle: "UPNA · 2026-2027", en-curso: true,
)
#separator-estudios()

#estudio(
  logos.ehu, "EH", "Informatika Ingeniaritzako Gradua",
  detalle: "EHU · 2022-2026",
  chips: (("code", "Konputazio zientzietan espezializatua"),),
)

#estudio(
  logos.sapienza, "SU", "Unibertsitate trukea",
  detalle: "Sapienza Università di Roma - 5 Hilabete",
  sub: true,
)
#separator-estudios()

#estudio(
  none, none, "Batxilergoa",
  detalle: "Zientzia adarra · Orixe BHI, Tolosa",
  grupo: true,
)

#estudio(
  none, none, "Lehen Hezkuntza",
  detalle: "Uzturpe Ikastola, Ibarra",
  grupo: true,
)
