# peterzsigmondOS

A very basic x86 OS. It includes some images, and a terminal, where the users can write their own hex coded x86 instructions, which then the OS can run. Theoretically, with this terminal, any task can be done on a computer.


## Screenshots
<img src="img/peterzsigmondOS-1.png" alt="peterzsigmondOS" width="600" />
<img src="img/peterzsigmondOS-2.png" alt="peterzsigmondOS" width="600" />


## Build

Install NASM:
```
apt/brew install nasm
```

Then build with:
```
nasm -f bin src/os.asm -o build/os.bin
```


## Run

#### With Qemu:

Install on Linux:
```
apt install qemu-system
```

Install on Mac:
```
brew install qemu
```

Then run:
```
qemu-system-x86_64 -drive format=raw,file=build/os.bin
```

#### On bare-metal:
Copy it on a flash drive:
```
dd if=build/os.bin of=</dev/disk>
```
...then boot from it.


## Terminal
Write hex coded x86 instructions in the Terminal, and press enter to run them. To call a function, that prints out the processor brand, type in:
```
B8 00 84 FF E0
```
...which actually is:
```
mov ax, 0x8400
jmp ax
```


## Binary maps
#### build/os.bin:
<pre><code>0x00000 - 0x001ff = Bootloader       (512 byte,     1 sector)
0x00200 - 0x005ff = OS               (1.024 byte,   2 sector)
0x00600 - 0x007ff = String consts    (512 byte,     1 sector)
0x00800 - 0x009ff = CPU info printer (512 byte,     1 sector)
0x00a00 - 0xc03ff = Images           (784.896 byte, 1533 sector)</code></pre>
```
Total: 769 kB
```

#### Memory map:
<pre><code>0x07c00 - 0x07dff = Bootloader       (512 byte,     1 sector)
0x07e00 - 0x081ff = OS               (1.024 byte,   2 sector)
0x08200 - 0x083ff = String consts    (512 byte,     1 sector)
0x08400 - 0x085ff = CPU info printer (512 byte,     1 sector)
0x08600 - 0x087ff = General memory   (512 byte,     1 sector)
0x08800 - 0x0af0f = Stack            (10.240 byte,  20 sector)
0x0af10 - 0x2650f = Image            (112.128 byte, 219 sector)</code></pre>
```
Total: 122.5 kB
```
