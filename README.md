# Parser HSM TOIT

The application demonstrates the work of a lexical parser based on a __hierarchical state machine__.

## Introduction
A hierarchical state machine allows one to simplify the number of operations on text during lexical parsing of an arithmetic expression and replace the logic of lexeme detection by transitions from state to state under the action of events.

## State Machine
Below is the parser's hierarchical state machine, implement the processing of the source arithmetic expression and extract lexemes (tokens).

![hsm](https://github.com/user-attachments/assets/6e142156-34e8-4bea-9267-674a1c6b6659)

## Implementation HSM
__ParserHelper__ is a set of transfer functions of the hierarchical state machine shown in the diagram above. This class is generated automatically by the HSM editor and developer only needs to comment out unnecessary transitions and add links to the parser functions inside the significant functions. The new version of the HSM graphical editor now generates code with "extra" transfer functions already commented out. This reduces the effort required to further modify the code.

## Description of application
The application is a __Toit__ app with a predefined set of arithmetic expressions. They can be selected using a combo box and parsed by pressing the parse button. The result of parsing is a list of tokens indicating the type and classification.

## Transformation of an infix expression into a postfix one

Actually, parsing, implemented using __HSM__, represented by threaded code, was the purpose of the application. But now I decided to supplement parsing with the operation of transforming an infix expression into a postfix one, or into "Polish" notation. This is not the pure __Shunting Yard Algorithm__ [https://en.m.wikipedia.org/wiki/Shunting_yard_algorithm#:~:text=In%20computer%20science%2C%20the%20shunting,abstract%20syntax%20tree%20(AST)], but some modified version of it that allows detecting some errors.

## Asynchronous processing of events.

Application uses of asynchronous processing of threaded code inside __Runner__ class. This allowed solving the problem of hidden recursion when calling functions. The custom __Queue__ class, builtin __Semaphore__ implements the mechanism of posting of events via the add event operation and processing this event in the __subscribe__ method, which listens for changes of __Semaphore__.

## Run app

The application can be run on a desktop in simulation mode, as shown below:

<img width="1600" height="900" alt="screen" src="https://github.com/user-attachments/assets/013005f8-c3be-42c0-ae7b-cef0c329e38e" />

or on the __ESP32-S3__ chip:

![esp32s3](https://github.com/user-attachments/assets/1273b005-937e-4791-9534-28623f75ae4d)

```
micrcx@micrcx-desktop:~/toit/parser$ jag -d mini run parser_test.toit
Scanning for device with name: 'mini'
Running 'parser_test.toit' on 'mini' ...
Success: Sent 49KB code to 'mini' in 1.45s
micrcx@micrcx-desktop:~/toit/parser$ 

micrcx@micrcx-desktop:~/toit/parser_hsm$ jag monitor -p /dev/ttyACM1
Starting serial monitor of port '/dev/ttyACM1' ...
ESP-ROM:esp32s3-20210327
Build:Mar 27 2021
rst:0x15 (USB_UART_CHIP_RESET),boot:0x8 (SPI_FAST_FLASH_BOOT)
Saved PC:0x40385b12
SPIWP:0xee
mode:DIO, clock div:1
load:0x3fce2810,len:0xdc
load:0x403c8700,len:0x4
load:0x403c8704,len:0xa08
load:0x403cb700,len:0x257c
entry 0x403c8854
E (325) quad_psram: PSRAM ID read error: 0x00ffffff, PSRAM chip not found or not supported, or wrong PSRAM line mode
E (325) esp_psram: PSRAM enabled but initialization failed. Bailing out.
[toit] INFO: starting <v2.0.0-alpha.184>
[toit] DEBUG: clearing RTC memory: powered on by hardware source
[toit] INFO: running on ESP32S3 - revision 0.2
[wifi] DEBUG: connecting
E (3713) wifi:Association refused too many times, max allowed 1
[wifi] WARN: connect failed {reason: unknown reason (208)}
[wifi] DEBUG: closing
[jaguar] WARN: running Jaguar failed due to 'CONNECT_FAILED: unknown reason (208)' (1/3)
[wifi] DEBUG: connecting
E (6533) wifi:Association refused too many times, max allowed 1
[wifi] WARN: connect failed {reason: unknown reason (208)}
[wifi] DEBUG: closing
[jaguar] WARN: running Jaguar failed due to 'CONNECT_FAILED: unknown reason (208)' (2/3)
[wifi] DEBUG: connecting
[wifi] DEBUG: connected
[wifi] INFO: network address dynamically assigned through dhcp {ip: 192.168.1.33}
[wifi] INFO: dns server address dynamically assigned through dhcp {ip: [192.168.1.1]}
[jaguar.http] INFO: running Jaguar device 'mini' (id: '7c05fb93-287a-49d7-8059-e36da56693ce') on 'http://192.168.1.33:9000'
[jaguar] INFO: program 96e3b93f-8725-d4c8-b8a1-761779b3000f started
Test in progress...

Infix:    ZwLight.Brightness >= 50
Postfix:  ZwLight.Brightness 50 >=

Infix:    ZwLight.Brightness * ( Z1 + 2 )
Postfix:  ZwLight.Brightness Z1 2 + *

Infix:    ZwLight.Brightness * (( Z1 + 2 ) *
Exception: FormatException: Mismatched closing parenthesis
*** Failed to convert infix expression to Polish notation ***

Infix:    ZwLight.Brightness >= ( 50 + 4 * 8 - BLE.Light.Brightness )
Postfix:  ZwLight.Brightness 50 4 + 8 * BLE.Light.Brightness - >=
[jaguar] INFO: program 96e3b93f-8725-d4c8-b8a1-761779b3000f stopped

```

## Note
Please pay attention to the handling of exceptions.



