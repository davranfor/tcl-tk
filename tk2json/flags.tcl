namespace eval Flags {
    set flags {
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
proc setFlag {result flag} {
    switch $flag {
        # Justify
        1 -
        2 -
        4  { return [expr ($result & ~(1 | 2 | 4)) | $flag] }
        # ValidateKey
        8 -
        16 { return [expr ($result & ~(8 | 16)) | $flag] }
    }
    return 0
}

proc setFlags {field} {
    set values [lindex $field $Field::Flags]
    set result [expr $Flags::JustifyLeft | $Flags::ValidateKeyTrue]

    foreach item $values {
        set found 0
        set count 0

        foreach flag $Flags::flags {
            if {$item eq $flag} {
                set result [setFlag $result [expr 1 << $count]]
                set found 1
            }
            incr count
        }
        if {$found == 0} {
            set name [lindex $field $Field::Name]

            puts stderr "'$name': '$item' is not a valid flag"
        }
    }
    return $result
}

