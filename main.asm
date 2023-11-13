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
    ld hl, $8000 ; tile data start for signed addressing, start late to leave first tile empty
    ld bc, TilesEnd - Tiles
.copyTiles:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, .copyTiles

    ; empty tilemap
    ld hl, $9800
    ld bc, $400
.emptyTilemap
    ld a, 0
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jp nz, .emptyTilemap

    ; fill blocks
    ld hl, $9840
    ld bc, $80
.fillTiles
    ld a, c
    and a, 1
    add a, 1
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jp nz, .fillTiles

    ; enable display
    ld a, $91
    ld [$ff40], a

    ; load palette
    ld a, %01101100
    ld [$ff47], a

    jp @

SECTION "Tile data", ROM0

Tiles:
INCBIN "tiles.bin"
TilesEnd:
