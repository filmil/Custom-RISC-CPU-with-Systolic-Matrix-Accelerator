# Instructions

Read README.md first. It describes the RISC CPU with systolic matrix accelerator architecture.

This repository contains the synthesizable SoC integrating a custom pipelined
RISC CPU core with a 2D 4x4 systolic array coprocessor.
The build system uses Bazel 9 with `rules_openxc7` to synthesize and place-and-route
the Arty A7-100T (`xc7a100tcsg324-1`) FPGA implementation.

# Layout rules

* `AGENTS.md` is the canonical instruction file.
  `CLAUDE.md` and `GEMINI.md` are symlinks to it.
  Keep them symlinks; never replace one with a copy.
* `rtl/` contains the Verilog HDL implementation of the RISC CPU, memories, FIFOs, and systolic coprocessor.
  `rtl/BUILD.bazel` exposes `sources`.
* `fpga/arty_a7_100t/` contains the board top-level wrapper (`arty_top.v`) and constraint files (`arty_a7_100t.xdc`).
  `fpga/arty_a7_100t/BUILD.bazel` exposes the Vivado project, synthesis, and place-and-route rules.
* Root `BUILD.bazel` defines top-level aliases for synthesis, place-and-route, and bitstream programming.

# Build targets

Run Bazel commands from the repository root:

* Synthesize the design for Arty A7-100T:
  ```sh
  bazel build //:top_synth
  ```
  This invokes Yosys to synthesize the Verilog RTL.

* Place and route, and produce the FPGA bitstream:
  ```sh
  bazel build //:top_pnr
  ```
  This runs `nextpnr-xilinx` on the synthesized JSON netlist and generates `top_pnr.bit`.

* Program the connected Arty A7-100T board:
  ```sh
  bazel run //:top_prog
  ```
  This runs `openFPGALoader` to write the bitstream to the device.

# Git and workflow rules

Follow the instructions in `github.com/filmil/ai-coding-sop`:
* Use Conventional Commits v1.0.0 for commit titles.
* No interactive editor may be invoked during git commands (`GIT_EDITOR=true`).
* Append the automated assistant note and the generating prompt to commit and PR descriptions.
* Keep `CLAUDE.md` and `GEMINI.md` symlinked to `AGENTS.md`.
