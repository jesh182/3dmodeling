# OpenSCAD Project Guidelines

Every `.scad` file I generate must follow these rules.

## Code structure

- All tunable values go at the top of the file as named constants in SCREAMING_SNAKE_CASE.
- Include `include <../lib/common.scad>` at the top of every model file.
- Decompose complex shapes into named `module` blocks — never write monolithic geometry.
- One file per logical part; compose assemblies via `include` or `use`.

## Performance

- Set `$fn` globally in `lib/common.scad` (already 64). Override locally only when a specific feature needs more or fewer segments, e.g. `cylinder(r=1, h=1, $fn=6)` for a hex.
- Prefer `hull()` and `minkowski()` sparingly — they are expensive on complex children. Favour direct CSG (union/difference/intersection) where possible.
- Avoid deeply nested `for` loops generating hundreds of children; use `linear_extrude` + 2D geometry instead where applicable.
- Never place geometry directly in a `for` loop without wrapping in `union()` when the intent is a single merged solid — naked loops create separate objects that slow preview.
- Use `render()` around repeated-use sub-shapes that are expensive and don't change, to cache their mesh.
- Keep boolean trees shallow: prefer binary trees of two operands over one `difference()` with 20 children.

## Printability best practices

- Default wall thickness ≥ 1.5 mm (ideally 2 × nozzle diameter = 0.8 mm for 0.4 mm nozzle).
- Minimum feature size ≥ 1 mm; smaller details won't print reliably on FDM.
- Add chamfers or fillets (r ≥ 0.5 mm) to all sharp bottom edges to reduce elephant foot and improve bed adhesion.
- Orient models so the largest flat face is on the Z = 0 plane — minimises supports.
- Avoid overhangs > 45° without built-in support geometry or a deliberate bridging surface.
- Tolerances for press-fit parts: 0.1–0.2 mm clearance on radius for snug fit, 0.3–0.4 mm for sliding fit.
- Through-holes: add 0.2 mm to the nominal diameter to compensate for FDM shrinkage.

## Commenting

- Only comment WHY, never WHAT (the module name and parameter names already say what).
- Document non-obvious tolerances or print-orientation assumptions in a single line above the relevant constant.

## lib/common.scad additions

When a new reusable primitive is needed (e.g. threads, living hinges, dovetails), add it to `lib/common.scad` with a clear module name and parameters — don't inline it in a model file.
