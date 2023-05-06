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

    method widget {field type} {
        set name    [lindex $field $Field::Name]
        set width   [lindex $field $Field::Width]
        set height  [lindex $field $Field::Height]
        set widget  .table.field_$name

        switch $type {
            entry {
                $type $widget -highlightthickness 0 \
                    -width [expr {$width + 1}] \
                    -validate key \
                    -validatecommand {validateEntry %W %P %i}
            }
            text {
                $type $widget -highlightthickness 0 \
                    -width [expr {$width + 1}] -height $height   
            }
        }
        grid $widget -row $rows -column 1 -sticky w -padx 4 -pady 2
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
    if {$text eq ""} {
        return 1
    }

    set field [lindex $::fields [lsearch -exact $::widgets $name]]

    if {$length >= [lindex $field $Field::MaxLength]} {
        return 0
    }
    switch [lindex $field $Field::Type] {
        real    {set mask "0123456789"}
        integer {set mask "0123456789-"}
        number  {set mask "0123456789-."}
        default {return 1}
    }
    return [expr {[string first [string index $text end] $mask] != -1}]
}

