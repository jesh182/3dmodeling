// ─── common.scad ─────────────────────────────────────────────────────────────
// Shared utility modules for the 3D model project.
// Include with:  include <../lib/common.scad>
// ─────────────────────────────────────────────────────────────────────────────

$fn = 64; // global circle/sphere smoothness

// ── Rounded box ──────────────────────────────────────────────────────────────
// w/d/h = outer dimensions, r = corner radius
module rounded_box(w, d, h, r = 2) {
    hull() {
        for (x = [r, w - r])
        for (y = [r, d - r])
            translate([x, y, 0])
                cylinder(r = r, h = h);
    }
}

// ── Rounded box with optional hollow interior ─────────────────────────────────
// wall = wall thickness; set to 0 for a solid block
module box_shell(w, d, h, r = 2, wall = 1.5) {
    if (wall <= 0) {
        rounded_box(w, d, h, r);
    } else {
        difference() {
            rounded_box(w, d, h, r);
            translate([wall, wall, wall])
                rounded_box(w - wall*2, d - wall*2, h, max(r - wall, 0.1));
        }
    }
}

// ── Countersunk hole (for M-series screws) ────────────────────────────────────
// d_shaft = shaft diameter, d_head = countersink diameter, depth = head depth
module countersink(d_shaft, d_head, depth, h_total) {
    union() {
        cylinder(d = d_shaft, h = h_total);
        cylinder(d1 = d_head, d2 = d_shaft, h = depth);
    }
}

// ── Slot (oblong hole) ────────────────────────────────────────────────────────
// len = total length along X, w = width, h = depth
module slot(len, w, h) {
    r = w / 2;
    hull() {
        translate([r, 0, 0]) cylinder(r = r, h = h);
        translate([len - r, 0, 0]) cylinder(r = r, h = h);
    }
}

// ── Snap-fit clip (cantilever, +X direction) ─────────────────────────────────
// arm_l/w/h = arm dimensions, tip_h = tip protrusion
module snap_clip(arm_l = 10, arm_w = 4, arm_h = 1.5, tip_h = 1) {
    cube([arm_l, arm_w, arm_h]);
    translate([arm_l - tip_h, 0, arm_h])
        cube([tip_h, arm_w, tip_h]);
}

// ── Text label (recessed) ─────────────────────────────────────────────────────
// Use inside a difference(). t = text string, s = font size, depth = recess
module label(t, s = 5, depth = 0.5) {
    linear_extrude(depth)
        text(t, size = s, halign = "center", valign = "center");
}
