# 3D Model Workshop

Parametric mechanical models written in OpenSCAD, generated via chat.

## Setup

1. **Install OpenSCAD** — [openscad.org/downloads](https://openscad.org/downloads.html)
   - macOS: `brew install --cask openscad`
2. Open any `.scad` file in `models/` with OpenSCAD.
3. Press **F5** to preview, **F6** to render (slower, but exact geometry).
4. Export STL: **File → Export → Export as STL** → save into `exports/`.

## Project layout

```
3dModel/
├── lib/
│   └── common.scad        # shared modules (rounded_box, slots, snap clips…)
├── models/
│   └── example_box.scad   # parametric snap-lid enclosure (start here)
├── exports/               # put your STL files here
└── README.md
```

## How to request a new model

Just describe what you want in chat. Example prompts:

- "Create a wall-mount bracket for a 40mm fan with two M4 holes"
- "Make a parametric hex grid tile, 30mm flat-to-flat, 3mm thick"
- "Design a cable clip for 5mm wire that snaps onto a 20×20 extrusion"

Each model gets its own file in `models/`. Parameters are always at the top of
the file so you can tweak dimensions without touching the geometry logic.

## lib/common.scad reference

| Module | Description |
|---|---|
| `rounded_box(w,d,h,r)` | Solid box with rounded vertical corners |
| `box_shell(w,d,h,r,wall)` | Hollow box open at the top |
| `countersink(d_shaft,d_head,depth,h_total)` | Countersunk bolt hole |
| `slot(len,w,h)` | Oblong slot hole |
| `snap_clip(arm_l,arm_w,arm_h,tip_h)` | Cantilever snap-fit arm |
| `label(t,s,depth)` | Recessed text (use inside `difference()`) |
