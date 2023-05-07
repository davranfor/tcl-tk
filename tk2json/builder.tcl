# To call an internal method inside the class use 'my method'
oo::class create Table {
    variable labels
    variable hrules
    variable rows

    constructor {} {
        set labels 0
        set hrules 0
        set rows 0

        frame .table -borderwidth 1 -relief raised -padx 4 -pady 4
        pack .table -padx 8 -pady 8
    }

    method label {field} {
        set caption [lindex $field $Field::Name]
        set widget .table.label_$labels

        grid [label $widget -text $caption] \
            -row $rows -column 0 -sticky w -padx 4 -pady 2
        incr labels
    }

    method hrule {{field 0}} {
        set widget .table.hrule_$hrules

        grid [ttk::separator $widget] \
            -row $rows -columnspan 2 -sticky ew -padx 4 -pady 4
        incr hrules
        incr rows
    }

    method justify {} {
        set flags [lindex $::flags end]

        if {$flags & $Flags::JustifyCenter} {
            return "center"
        }
        if {$flags & $Flags::JustifyRight} {
            return "right"
        }
        return ""
    }

    method widget {field type} {
        set name    [lindex $field $Field::Name]
        set widget  .table.field_$name

        switch $type {
            entry {
                $type $widget -highlightthickness 0 -validate key \
                    -validatecommand {validateEntry %W %P %i}
                if {[set justify [my justify]] ne ""} {
                    $widget configure -justify $justify
                }
            }
            text {
                set height [lindex $field $Field::Height]

                $type $widget -highlightthickness 0 -height $height   
            }
        }
        if {[set width [lindex $field $Field::Width]] != 0} {
            $widget configure -width [expr {$width + 1}]
            grid $widget -row $rows -column 1 -sticky w -padx 4 -pady 2
        } else {
            grid $widget -row $rows -column 1 -sticky ew -padx 4 -pady 2
        }
        incr rows
        return $widget
    }

    method buttons {form} {
        frame .table.buttons -padx 0 -pady 0
        button .table.buttons.accept \
            -text [lindex $form $Form::Accept] -command onAccept
        button .table.buttons.cancel \
            -text [lindex $form $Form::Cancel] -command onCancel
        pack .table.buttons.accept -side left -padx 4 -pady 4
        pack .table.buttons.cancel -side left -padx 4 -pady 4
        grid .table.buttons -row $rows -columnspan 2 -sticky e
        incr rows
    }
}

proc validateEntry {name text length} {
    set index [lsearch -exact $::widgets $name]
    set field [lindex $::fields $index]

    if {$length >= [lindex $field $Field::MaxLength]} {
        return 0
    }

    set flags [lindex $::flags $index]

    if {$flags & $Flags::ValidateKeyTrue} {
        set regExp [lindex $field $Field::RegExp]

        if {($regExp ne "") && ([regexp $regExp $text] != 1)} {
            return 0
        }
    }
    return 1
}

