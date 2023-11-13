rgbgfx.exe -o tiles.bin tiles.png
rgbasm.exe -L -o main.o main.asm
rgblink.exe -o breakout.gb main.o
rgbfix.exe -v -p 0xFF breakout.gb