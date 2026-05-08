// ─── tube_support_clamp.scad ──────────────────────────────────────────────────
// Saddle bracket that presses DOWN onto a square bar (lying flat, running in X).
// Round tube socket rises from the top centre.
// Coordinate convention matches the bar:
//   X = along bar length (bracket straddles this)
//   Y = bar depth  (20.7 mm)
//   Z = bar height (20.7 mm) — bracket presses down over this
//
// Print orientation: upside-down (socket pointing at build plate).
// ─────────────────────────────────────────────────────────────────────────────

include <../lib/common.scad>

// ── Parameters ────────────────────────────────────────────────────────────────

WALL = 4;                    // wall thickness (mm)

// Square bar cross-section  — -0.2 mm interference on each bore dimension
BAR_Y          = 20.7;       // bar depth  (Y)
BAR_Z          = 20.7;       // bar height (Z)
BORE_Y         = BAR_Y - 0.2;
BORE_Z         = BAR_Z - 0.2;

// Central hull width (socket diameter + walls each side)
GRIP_X         = BAR_Y * 2;  // core width around socket
// Wing extensions — extra grip length on each X side beyond the core
WING_X         = 30;

// Round vertical tube — -0.2 mm interference press fit
TUBE_OD        = 19.5;
TUBE_BORE      = TUBE_OD - 0.2;
SOCKET_DEPTH   = 30;         // insertion depth of round tube

// Squared nut (inside round socket, locks tube)
NUT_W          = 10.3;
NUT_THICK      = 5;
NUT_FROM_FLOOR = 20;         // distance from socket floor to nut centre
NUT_SLOT_W     = NUT_W + 0.6;
NUT_SLOT_T     = NUT_THICK + 0.4;

// Wing screw shaft clearance
SCREW_D        = 5;

// ── Derived ───────────────────────────────────────────────────────────────────

// Core saddle (around socket)
SADDLE_X  = GRIP_X;
SADDLE_Y  = BORE_Y + WALL * 2;
SADDLE_Z  = BORE_Z + WALL;       // WALL roof + bar height (open at bottom)

// Full width including wings
TOTAL_X   = SADDLE_X + WING_X * 2;

SOCKET_OD = TUBE_BORE + WALL * 2;

// Socket centre — offset by WING_X so it stays centred on TOTAL_X
CX = WING_X + SADDLE_X / 2;
CY = SADDLE_Y / 2;

// ── Body — central hull + flat wings on each X side ───────────────────────────
module body() {
    union() {
        // central hull: tapers from core saddle block up to socket cylinder
        translate([WING_X, 0, 0])
            hull() {
                cube([SADDLE_X, SADDLE_Y, SADDLE_Z]);
                translate([SADDLE_X / 2, CY, SADDLE_Z])
                    cylinder(d = SOCKET_OD, h = SOCKET_DEPTH);
            }
        // left wing — flat saddle slab, same Y and Z as core
        cube([WING_X, SADDLE_Y, SADDLE_Z]);
        // right wing
        translate([WING_X + SADDLE_X, 0, 0])
            cube([WING_X, SADDLE_Y, SADDLE_Z]);
    }
}

// ── Bar channel — U-slot spanning full width including wings ──────────────────
module bar_channel() {
    translate([-0.01, WALL, -0.01])
        cube([TOTAL_X + 0.02, BORE_Y, BORE_Z + 0.01]);
}

// ── Front tube opening — arch slot through front wall only ────────────────────
// Starts at Y=WALL (inner face of front wall) and exits at Y=SADDLE_Y (outer face).
// Leaves the back wall (Y=0 to Y=WALL) intact.
// Open at Z=0 so the tube slides in from below.
module front_tube_opening() {
    tube_r = (TUBE_OD + 0.3) / 2;
    // cut depth = from inner face of front wall to outside
    cut_depth = SADDLE_Y - WALL + 0.02;
    translate([CX, WALL - 0.01, -0.01]) {
        // rectangular stem from bottom up to arch start
        translate([-tube_r, 0, 0])
            cube([tube_r * 2, cut_depth, tube_r + 0.01]);
        // arched top
        translate([0, 0, tube_r])
            rotate([-90, 0, 0])
                cylinder(r = tube_r, h = cut_depth);
    }
}

// ── Round tube socket bore ────────────────────────────────────────────────────
module round_bore() {
    translate([CX, CY, SADDLE_Z - 0.01])
        cylinder(d = TUBE_BORE, h = SOCKET_DEPTH + 0.02);
}

// ── Nut slot — faces +Y (front), from socket floor up to nut top ──────────────
module nut_slot() {
    translate([CX - NUT_SLOT_W / 2, CY - NUT_SLOT_T / 2, SADDLE_Z])
        cube([NUT_SLOT_W, SOCKET_OD, NUT_FROM_FLOOR + NUT_SLOT_W / 2]);
}

// ── Wing screw bore — only through socket cylinder walls at nut height ─────────
module screw_bore() {
    // limited to SOCKET_OD width so it doesn't exit through the taper
    translate([CX - SOCKET_OD / 2 - 0.01, CY, SADDLE_Z + NUT_FROM_FLOOR])
        rotate([0, 90, 0])
            cylinder(d = SCREW_D, h = SOCKET_OD + 0.02);
}

// ── Assembly ──────────────────────────────────────────────────────────────────
difference() {
    body();
    bar_channel();
    front_tube_opening();
    round_bore();
    nut_slot();
    screw_bore();
}
