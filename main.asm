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

    ; load tilemap
    ld de, Tilemap
    ld hl, $9800 ; tilemap start
    ld bc, TilemapEnd - Tilemap
.copyTilemap:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, .copyTilemap

    ; clear oam
    ld hl, $fe00
    ld bc, $100
.clearOAM
    ld a, 0
    ld [hli], a
    dec bc
    ld a, b
    or a, c
    jp nz, .clearOAM

    ; enable display
    ld a, $93
    ld [$ff40], a

    ; load palette
    ld a, %01101100
    ld [$ff47], a ; bgp
    ld [$ff48], a ; obp

    jp @

SECTION "Tile data", ROM0

Tiles:
INCBIN "tiles.bin"
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
INCBIN "tilemap.bin"
TilemapEnd:
