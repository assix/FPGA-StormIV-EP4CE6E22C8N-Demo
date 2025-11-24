# Storm IV V2.0 (Altera Cyclone IV) FPGA Project

This repository contains Verilog code and pin assignments for the **Storm IV XX V2.0** FPGA development board. It includes a complete pin mapping correction for the V2.0 board variant, which differs significantly from the standard documentation.

## Hardware Gallery

| **Storm IV V2.0 Board Layout** | **EP4CE6E22C8N Chip Detail** |
|:---:|:---:|
| <img src="images/storm_iv_v2_ep4ce6_board_layout.jpg" width="400"> | <img src="images/storm_iv_v2_fpga_chip_ep4ce6e22c8n.jpg" width="400"> |
| *Top view of the Storm IV V2.0 dev board (Cyclone IV)* | *Macro shot of the specific EP4CE6E22C8N FPGA silicon* |

### Action Shot
Running the `anthony_test_fpga_pins` project:
![Active LEDs](images/storm_iv_v2_demo_active_leds_7seg.jpg)
*Status: 7-Segment counting (0-9999), binary LEDs toggling, and button inputs active.*

## Board Specifications
* **Board Model:** Storm_IV_XX_V2.0
* **FPGA Chip:** Intel (Altera) Cyclone IV EP4CE6E22C8N
* **Clock:** 50MHz Oscillator (PIN_91)
* **Logic Elements:** 6,272
* **Memory:** 270 Kbits embedded memory
* **Features:**
  * 4x Push Buttons (Active Low)
  * 4x DIP Switches
  * 8x LEDs (Active Low)
  * 4-Digit 7-Segment Display
  * Buzzer (Active Low)
  * VGA, PS/2, and UART interfaces

## Verified Pin Mapping (V2.0)
*Crucial: These pins differ from the standard Storm IV V1 manuals.*

| Component | Signal | Pin Number |
| :--- | :--- | :--- |
| **System** | Clock (50MHz) | `PIN_91` |
| **Buttons** | KEY1..KEY4 | `PIN_34`, `PIN_33`, `PIN_88`, `PIN_89` |
| **DIPs** | SW1..SW4 | `PIN_11`, `PIN_25`, `PIN_24`, `PIN_23` |
| **LEDs** | D1..D8 | `PIN_39`, `PIN_31`, `PIN_3`, `PIN_2`, `PIN_1`, `PIN_144`, `PIN_143`, `PIN_142` |
| **7-Seg Sel** | Digit 1..4 | `PIN_98`, `PIN_99`, `PIN_86`, `PIN_87` |
| **7-Seg Data**| A,B,C,D,E,F,G,DP | `100`, `111`, `104`, `110`, `106`, `101`, `103`, `105` |
| **Audio** | Buzzer | `PIN_7` |

## How to Run
1. Open the project `anthony_test_fpga_pins` in **Intel Quartus Prime Lite**.
2. Assign pins using the `.qsf` file provided in this repo.
3. Compile the design.
4. Flash the `.sof` file using the USB-Blaster.

## Troubleshooting
* **Error:** "Device family is not valid" -> Ensure you select **Cyclone IV E** (EP4CE6E22C8) in Device Settings.
* **Error:** Board lights up but doesn't react -> Check that you are using the V2.0 pin assignments listed above, not the V1.0 ones found online.
