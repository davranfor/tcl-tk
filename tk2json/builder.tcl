# To call an internal method inside the class use 'my method'
oo::class create Table {
    variable frame

    variable packs
    variable labels
    variable hrules
    variable buttons
    variable entries
    variable texts

    variable packing
    variable row
    variable column

    constructor {} {
        set frame .table

        set packs 0
        set labels 0
        set hrules 0
        set buttons 0
        set entries 0
        set texts 0

        set packing 0
        set row 0
        set column 0

        frame $frame -borderwidth 1 -relief raised -padx 4 -pady 4
        pack $frame -padx 8 -pady 8
    }

    method add {widget sticky} {
        switch $packing {
            1 {
                if {$sticky eq "ew"} {
                    pack $widget -side left -padx 2 -pady 2 -fill x -expand 1
                } else {
                    pack $widget -side left -padx 2 -pady 2
                }
            }
            0 {
                grid $widget -row $row -column $column \
                    -sticky $sticky -padx 4 -pady 2
                if {$column == 0} {
                    set column 1
                } else {
                    set column 0
                    incr row
                }
            }
            -1 {
                if {$column == 1} {
                    grid $widget -row $row -column $column \
                        -sticky $sticky -padx 2 -pady 0
                } else {
                    grid $widget -row $row -columnspan 2  \
                        -sticky $sticky -padx 2 -pady 0
                }
                set column 0
                incr row
            }
        }
    }

    method pack {field} {
        if {$packing == 0} {
            set frame .table.pack$packs
            set flags [setFlags $field]
            set packing -1

            frame $frame -padx 0 -pady 0
            if {$flags & $Flags::AlignRight} {
                my add $frame e
            } else {
                my add $frame ew
            }

            set packing 1
        } else {
            set frame .table
            set packing 0

            incr packs
        }
    }

    method title {field} {
        wm title . [lindex $field $Field::Text]
    }

    method label {field} {
        set widget $frame.label$labels

        label $widget -text [lindex $field $Field::Text]
        my add $widget w
        incr labels
    }

    method hrule {field} {
        if {$packing != 0} {
            puts stderr "hrules can't be packed"
            return
        }

        set widget $frame.hrule$hrules

        ttk::separator $widget
        if {$column == 0} {
            grid $widget -row $row -columnspan 2 -sticky ew -padx 4 -pady 4
        } else {
            grid $widget -row $row -column 1 -sticky ew -padx 4 -pady 4
        }
        incr hrules
        incr row
        set column 0
    }

    method button {field} {
        set widget $frame.button$buttons

        button $widget -text [lindex $field $Field::Text] \
            -command [lindex $field $Field::Command]
        my add $widget w
        incr buttons
    }

    method justify {} {
        set flags [lindex $::flags end]

        if {$flags & $Flags::JustifyCenter} {
            return center
        }
        if {$flags & $Flags::JustifyRight} {
            return right
        }
        return ""
    }

    method entry {field} {
        set widget $frame.entry$entries
        set sticky w

        entry $widget -highlightthickness 0 -validate key \
            -validatecommand {validateEntry %W %P %i}
        if {[set width [lindex $field $Field::Width]] != 0} {
            $widget configure -width [expr {$width + 1}]
        } else {
            $widget configure -width 1
            set sticky ew
        }
        if {[set justify [my justify]] ne ""} {
            $widget configure -justify $justify
        }
        my add $widget $sticky
        incr entries
        return $widget
    }

    method text {field} {
        set widget $frame.text$texts
        set sticky w

        text $widget -highlightthickness 0 \
            -height [lindex $field $Field::Height]
        if {[set width [lindex $field $Field::Width]] != 0} {
            $widget configure -width [expr {$width + 1}]
        } else {
            $widget configure -width 1
            set sticky ew
        }
        my add $widget $sticky
        incr texts
        return $widget
    }
}

proc validateEntry {name text length} {
    set index [lsearch -exact $::widgets $name]
    set field [lindex $::fields $index]

    if {$length >= [lindex $field $Field::MaxLength]} {
        return 0
    }
    if {[lindex $::flags $index] & $Flags::ValidateKeyTrue} {
        set regExp [lindex $field $Field::RegExp]

        if {($regExp ne "") && ([regexp $regExp $text] != 1)} {
            return 0
        }
    }
    return 1
}

