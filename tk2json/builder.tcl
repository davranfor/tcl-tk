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

proc buildLabel {frame index caption} {
    set widget $frame.label_$index

    label $widget -text $caption
    return $widget
}

proc buildField {frame field type name} {
    set width   [lindex $field $Field::Width]
    set height  [lindex $field $Field::Height]
    set widget  $frame.field_$name

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
    return $widget
}

