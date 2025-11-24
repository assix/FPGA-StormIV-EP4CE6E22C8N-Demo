# FPGA Storm IV (V2.0) - Cyclone IV EP4CE6E22C8N Demo

A complete, verified "Golden Template" project for the **ALINX/Storm IV V2.0** FPGA Development Board. 

**The Problem:** Many "Storm IV" boards sold online (AliExpress/eBay) have different pin layouts than the standard documentation claims. For example, standard tutorials say the Clock is `PIN_23`, but on the V2.0 board, it is actually **`PIN_91`**.

**The Solution:** This repository contains the **Corrected Pin Mapping (.qsf)** and a comprehensive demo that tests every major component on the board simultaneously.

## 🛠 Hardware Specs
* **Board:** Storm IV (Model AX301 / V2.0)
* **FPGA Chip:** Intel/Altera Cyclone IV `EP4CE6E22C8N`
* **Clock:** 50MHz Oscillator on **PIN_91**
* **Interfaces Tested:**
    * 4x Push Buttons (Active Low)
    * 4x DIP Switches
    * 8x LEDs (Active Low)
    * 4-Digit 7-Segment Display (Multiplexed)
    * Passive Buzzer

## 🚀 Quick Start (Flash & Go)
If you just want to test if your board works without installing Quartus:
1.  Download the **`fpga_storm_iv_demo.sof`** file from this repo.
2.  Plug in your USB Blaster and Board Power.
3.  Open **Quartus Programmer**.
4.  Click **Add File** -> Select the `.sof` file.
5.  Click **Start**.

## 🎮 Demo Features
Once flashed, the board will perform the following:

1.  **7-Segment Screen:** Automatically counts up from `0000` to `9999` (increments every second).
2.  **Push Buttons (Key 1-4):**
    * Pressing **Key 1** toggles **LED 1** (On/Off).
    * Pressing **Key 2** toggles **LED 2**, and so on.
    * *Feedback:* Every press triggers a short **Beep**.
3.  **DIP Switches:**
    * **Switch ON (Down):** Disables light control.
    * **Switch OFF (Up):** Triggers a **Double Beep**.
    * *Logic:* Used to demonstrate distinct input handling separate from the buttons.
4.  **Reset Button (Top Key):**
    * Instantly resets the counter screen to `0000`.

## 📍 Verified Pin Map (The "Golden" List)
If you are writing your own Verilog, copy these assignments into your `.qsf` file:

```tcl
# --- SYSTEM ---
set_location_assignment PIN_91 -to clk
set_location_assignment PIN_90 -to rst_n

# --- LEDS (D1-D8) ---
set_location_assignment PIN_39 -to leds[0]
set_location_assignment PIN_31 -to leds[1]
set_location_assignment PIN_3  -to leds[2]
set_location_assignment PIN_2  -to leds[3]
set_location_assignment PIN_1  -to leds[4]
set_location_assignment PIN_144 -to leds[5]
set_location_assignment PIN_143 -to leds[6]
set_location_assignment PIN_142 -to leds[7]

# --- KEYS (Push Buttons 1-4) ---
set_location_assignment PIN_11 -to keys[0]
set_location_assignment PIN_25 -to keys[1]
set_location_assignment PIN_24 -to keys[2]
set_location_assignment PIN_23 -to keys[3]

# --- DIP SWITCHES ---
set_location_assignment PIN_34 -to dips[0]
set_location_assignment PIN_33 -to dips[1]
set_location_assignment PIN_88 -to dips[2]
set_location_assignment PIN_89 -to dips[3]

# --- 7-SEGMENT DISPLAY ---
set_location_assignment PIN_98 -to seg_sel[0]
set_location_assignment PIN_99 -to seg_sel[1]
set_location_assignment PIN_86 -to seg_sel[2]
set_location_assignment PIN_87 -to seg_sel[3]

set_location_assignment PIN_100 -to seg_data[0] # A
set_location_assignment PIN_111 -to seg_data[1] # B
set_location_assignment PIN_104 -to seg_data[2] # C
set_location_assignment PIN_110 -to seg_data[3] # D
set_location_assignment PIN_106 -to seg_data[4] # E
set_location_assignment PIN_101 -to seg_data[5] # F
set_location_assignment PIN_103 -to seg_data[6] # G
set_location_assignment PIN_105 -to seg_data[7] # DP

# --- BUZZER ---
set_location_assignment PIN_7 -to beep

# --- REQUIRED FIX FOR DISPLAY PIN 101 ---
set_global_assignment -name CYCLONEII_RESERVE_NCEO_AFTER_CONFIGURATION "USE AS REGULAR IO"
