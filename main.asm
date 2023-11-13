SECTION "Header", ROM0[$100]
    jp EntryPoint

    ds $150 - @, 0 ; room for header

EntryPoint:
    ; disable audio
    ld a, 0
    ld [$ff26], a ; NR52

    ; wait for vblank
    ld hl, $ff41 ; STAT register
.wait:
    bit 1, [hl]
    jr nz, .wait

    ; disable display
    ld a, 0
    ld [$ff40], a ; LCD control

    ; load tile data
    ld de, Tiles
    ld hl, $9000 ; tile data start for signed addressing
    ld bc, TilesEnd - Tiles
.copyTiles:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, .copyTiles

    jp @

SECTION "Tile data", ROM0

Tiles:
INCBIN "tiles.bin"
TilesEnd:
