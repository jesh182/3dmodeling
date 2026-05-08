// ─── example_box.scad ────────────────────────────────────────────────────────
// A parametric snap-lid enclosure — good starting template.
// Render: press F6 in OpenSCAD  |  Export STL: File → Export → Export as STL
// ─────────────────────────────────────────────────────────────────────────────

include <../lib/common.scad>

// ── Parameters (edit these) ───────────────────────────────────────────────────
BOX_W    = 60;   // outer width  (mm)
BOX_D    = 40;   // outer depth  (mm)
BOX_H    = 25;   // outer height (mm)
WALL     = 2;    // wall thickness
CORNER_R = 3;    // corner radius
LID_H    = 6;    // lid height (slices off top of box)

// ── Body ──────────────────────────────────────────────────────────────────────
module body() {
    difference() {
        box_shell(BOX_W, BOX_D, BOX_H - LID_H, CORNER_R, WALL);

        // four M3 screw holes on bottom floor
        for (x = [8, BOX_W - 8])
        for (y = [8, BOX_D - 8])
            translate([x, y, 0])
                countersink(d_shaft = 3.2, d_head = 5.5, depth = 2, h_total = WALL + 1);
    }
}

// ── Lid ───────────────────────────────────────────────────────────────────────
module lid() {
    difference() {
        union() {
            // top plate
            rounded_box(BOX_W, BOX_D, WALL, CORNER_R);
            // inner lip that seats into body
            translate([WALL, WALL, WALL])
                rounded_box(BOX_W - WALL*2, BOX_D - WALL*2, LID_H - WALL, max(CORNER_R - WALL, 0.5));
        }
        // label recess centred on top face
        translate([BOX_W/2, BOX_D/2, WALL - 0.4])
            label("MY BOX", s = 7, depth = 0.5);
    }
}

// ── Layout: body left, lid right ──────────────────────────────────────────────
body();
translate([BOX_W + 10, 0, 0]) lid();
