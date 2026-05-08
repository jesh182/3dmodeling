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

// Saddle grip length along X — how much bar length the bracket wraps
GRIP_X         = BAR_Y * 2;  // 2× bar width gives solid press-fit grip

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

// Outer saddle dimensions
SADDLE_X  = GRIP_X;
SADDLE_Y  = BORE_Y + WALL * 2;   // walls on ±Y faces
// Z: side walls reach down to bar bottom, roof sits on top of bar
SADDLE_Z  = BORE_Z + WALL;       // WALL roof + bar height (open at bottom)

SOCKET_OD = TUBE_BORE + WALL * 2;

// Socket centre sits at middle of saddle in X and Y
CX = SADDLE_X / 2;
CY = SADDLE_Y / 2;

// ── Body — hull from rectangular saddle top face to socket cylinder ────────────
module body() {
    hull() {
        // saddle block
        cube([SADDLE_X, SADDLE_Y, SADDLE_Z]);
        // socket cylinder rises from top centre
        translate([CX, CY, SADDLE_Z])
            cylinder(d = SOCKET_OD, h = SOCKET_DEPTH);
    }
}

// ── Bar channel — U-slot open at bottom AND both X ends (bar passes through) ───
module bar_channel() {
    // no X walls — bar runs straight through the full saddle width
    // Y walls (WALL thick each side) grip the bar depth
    // Z: open at bottom, closed by WALL roof at top
    translate([-0.01, WALL, -0.01])
        cube([SADDLE_X + 0.02, BORE_Y, BORE_Z + 0.01]);
}

// ── Front tube opening — slot on +Y face only, open at bottom ─────────────────
// Round-bottom slot centred in X, goes from Z=0 up through the bar channel.
// Depth = WALL so it only removes the front wall, not the full body.
module front_tube_opening() {
    tube_r = (TUBE_OD + 0.3) / 2;
    translate([CX, SADDLE_Y - WALL - 0.01, 0]) {
        // rectangular part from bottom up to tube centre
        translate([-tube_r, 0, 0])
            cube([tube_r * 2, WALL + 0.02, tube_r]);
        // semicircle top — rounds off the slot top
        translate([0, 0, tube_r])
            rotate([270, 0, 0])
                cylinder(r = tube_r, h = WALL + 0.02);
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
