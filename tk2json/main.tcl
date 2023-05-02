#!/usr/bin/wish

bind .      <Escape>   {onCancel}
bind Entry  <Return>   {event generate %W <Tab>}
bind Entry  <KP_Enter> {event generate %W <Tab>}
bind Button <Return>   {event generate %W <space>}
bind Button <KP_Enter> {event generate %W <space>}

source data.tcl

namespace eval Field {
    set Name        0
    set Title       1
    set Width       2
    set MinLength   3
    set MaxLength   4
}

set row 0

frame .fr -borderwidth 1 -relief raised -padx 4 -pady 4

# Pack label and entry
foreach field $fields {
    set name  [lindex $field $Field::Name]
    set title [lindex $field $Field::Title]
    set width [lindex $field $Field::Width]

    grid [label .fr.label$name -text $title] \
        -row $row -column 0 -sticky w -padx 4 -pady 2
    grid [entry .fr.entry$name -width $width -highlightthickness 0] \
        -row $row -column 1 -sticky w -padx 4 -pady 2
    incr row
}

grid [ttk::separator .fr.hrule] \
    -row $row -columnspan 2 -sticky ew -padx 4 -pady 4
incr row

frame .fr.button -padx 0 -pady 0
button .fr.button.accept -text $acceptTitle -command onAccept
button .fr.button.cancel -text $cancelTitle -command onCancel
pack .fr.button.accept -side left -padx 4 -pady 4
pack .fr.button.cancel -side left -padx 4 -pady 4
grid .fr.button -row $row -columnspan 2 -sticky e

pack .fr -padx 8 -pady 8

wm title . $formTitle
# not resizable
wm resizable . 0 0
# position
wm geometry . +450+200

after idle focus -force .fr.entry[lindex [lindex $fields 0] 0]

set mapOfSpecialChars {
    "\\" "\\\\" "\"" "\\\"" "\b" "\\b" "\f" "\\f" "\n" "\\n" "\r" "\\r" "\t" "\\t"
}

proc escapeSpecialChars {text} {
    return [string map $::mapOfSpecialChars $text]
}

proc readForm {_errors} {
    upvar $_errors errors
    set errors 0

    global fields
    set result ""

    append result "\{\n  \"form\": \"$::formName\",\n  \"fields\": \{\n"
    foreach field $fields {
        set name        [lindex $field $Field::Name]
        set value       [escapeSpecialChars [string trim [.fr.entry$name get]]]
        set newline     [expr {[lindex $fields end] != $field ? ",\n" : "\n"}]

        set length      [string length $value]
        set minLength   [lindex $field $Field::MinLength]
        set maxLength   [lindex $field $Field::MaxLength]

        if {$length < $minLength} {
            puts stderr "Error testing minLength '$minLength' on field '$name'"
            incr errors
        } elseif {$length > $maxLength} {
            puts stderr "Error testing maxLength '$maxLength' on field '$name'"
            incr errors
        }
        append result "    \"$name\": \"$value\"$newline"
    }
    append result "  \}\n\}"
    return $result
}

proc onAccept {} {
    set errors 0
    set result [readForm errors]

    if {$errors > 0} {
        puts stderr "$errors errors found\n\nInvalid data:\n$result"
        exit 1
    } else {
        puts stdout $result
        exit 0
    }
}

proc onCancel {} {
    exit 0
}

