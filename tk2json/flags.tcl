namespace eval Flags {
    set Items {
        justify:left
        justify:center
        justify:right
        validateKey:0
        validateKey:1
    }
    set JustifyLeft         1
    set JustifyCenter       2
    set JustifyRight        4
    set ValidateKeyFalse    8
    set ValidateKeyTrue     16
}

# Replace existing flags from the group
proc setFlag {flags flag} {
    switch $flag {
        # Justify
        1 -
        2 -
        4  { return [expr ($flags & ~(1 | 2 | 4)) | $flag] }
        # ValidateKey
        8 -
        16 { return [expr ($flags & ~(8 | 16)) | $flag] }
    }
    return 0
}

proc setFlags {field} {
    set name  [lindex $field $Field::Name]
    set items [lindex $field $Field::Flags]
    set flags [expr $Flags::JustifyLeft | $Flags::ValidateKeyTrue]

    foreach item $items {
        set index [lsearch -exact $Flags::Items $item]

        if {$index != -1} {
            set flags [setFlag $flags [expr 1 << $index]]
        } else {
            puts stderr "'$name': '$item' is not a valid flag"
        }
    }
    return $flags
}

