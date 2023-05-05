#!/usr/bin/wish

bind .      <Escape>    {onCancel}
bind Text   <Tab>       {continue}
bind Text   <KP_Enter>  {event generate %W <Return>}
bind Button <Return>    {event generate %W <space>}
bind Button <KP_Enter>  {event generate %W <space>}

#bind Entry  <Return>    {event generate %W <Tab>}
#bind Entry  <KP_Enter>  {event generate %W <Tab>}

source builder.tcl
source convert.tcl
source data.tcl

namespace eval Form {
    set Name    0
    set Title   1
    set Accept  2
    set Cancel  3
}

namespace eval Field {
    set Widget      0
    set Name        1
    set Type        2
    set Width       3
    set Height      4
    set MinLength   5
    set MaxLength   6
    set RegExp      7
}

set widgets {}
set labels 0
set row 0

frame .fr -borderwidth 1 -relief raised -padx 4 -pady 4

# Pack labels and widgets
foreach field $fields {
    set type [lindex $field $Field::Widget]
    set name [lindex $field $Field::Name]

    if {$type eq "label"} {
        set widget [buildLabel .fr $labels $name]
        set length [llength $widgets]
        set fields [lreplace $fields $length $length]

        grid $widget -row $row -column 0 -sticky w -padx 4 -pady 2
        incr labels
    } else {
        set widget [buildField .fr $field $type $name]

        lappend widgets $widget
        grid $widget -row $row -column 1 -sticky w -padx 4 -pady 2
        incr row
    }
}

grid [ttk::separator .fr.hrule] \
    -row $row -columnspan 2 -sticky ew -padx 4 -pady 4
incr row

frame .fr.button -padx 0 -pady 0
button .fr.button.accept -text [lindex $form $Form::Accept] -command onAccept
button .fr.button.cancel -text [lindex $form $Form::Cancel] -command onCancel
pack .fr.button.accept -side left -padx 4 -pady 4
pack .fr.button.cancel -side left -padx 4 -pady 4
grid .fr.button -row $row -columnspan 2 -sticky e

pack .fr -padx 8 -pady 8

wm title . [lindex $form $Form::Title]
# not resizable
wm resizable . 0 0
# position
wm geometry . +450+200

after idle focus -force [lindex $widgets 0]

proc onAccept {} {
    set errors ""
    set result [readForm [lindex $::form $Form::Name] errors]

    if {$errors ne ""} {
        puts stderr "$errors\n\"invalid-data\": $result"
        exit 1
    } else {
        puts stdout $result
        exit 0
    }
}

proc onCancel {} {
    exit 0
}

