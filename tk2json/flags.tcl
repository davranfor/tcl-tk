namespace eval Flags {
    set Items {
        align:left
        align:center
        align:right
        justify:left
        justify:center
        justify:right
        justify:right
        validateKey:0
        validateKey:1
    }
    set AlignLeft           1
    set AlignCenter         2
    set AlignRight          4
    set JustifyLeft         8
    set JustifyCenter       16
    set JustifyRight        32
    set ValidateKeyFalse    64
    set ValidateKeyTrue     128
}

# Replace existing flags from the group
proc setFlag {flags flag} {
    switch $flag {
        # Align
        1 -
        2 -
        4   {return [expr ($flags & ~(1 | 2 | 4)) | $flag]}
        # Justify
        8 -
        16 -
        32  {return [expr ($flags & ~(8 | 16 | 32)) | $flag]}
        # ValidateKey
        64 -
        128 {return [expr ($flags & ~(64 | 128)) | $flag]}
    }
    return 0
}

proc setFlags {field} {
    set items [lindex $field $Field::Flags]
    set flags [expr $Flags::AlignLeft | $Flags::JustifyLeft | $Flags::ValidateKeyTrue]

    foreach item $items {
        set index [lsearch -exact $Flags::Items $item]

        if {$index != -1} {
            set flags [setFlag $flags [expr 1 << $index]]
        } else {
            puts stderr \
                "[lindex $field $Field::Name]: '$item' is not a valid flag"
        }
    }
    return $flags
}

