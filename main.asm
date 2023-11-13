SECTION "Header", ROM0[$100]
    jp EntryPoint

    ds $150 - @, 0 ; room for header

EntryPoint:
    jp @