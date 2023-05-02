#!/usr/bin/wish

bind .      <Escape>   {onCancel}
bind Entry  <Return>   {event generate %W <Tab>}
bind Entry  <KP_Enter> {event generate %W <Tab>}
bind Button <Return>   {event generate %W <space>}
bind Button <KP_Enter> {event generate %W <space>}

set mapOfSpecialChars {
    "\\" "\\\\" "\"" "\\\"" "\b" "\\b" "\f" "\\f" "\n" "\\n" "\r" "\\r" "\t" "\\t"
}

proc escapeSpecialChars {text} {
    global mapOfSpecialChars

    return [string map $mapOfSpecialChars [string trim $text]]
}

proc getFormValues {_errors} {
    global formName fields
    upvar $_errors errors
    set errors 0
    set result ""

    append result "\{\n  \"form\": \"" $formName "\",\n  \"fields\": \{\n"
    foreach field $fields {
        set name        [lindex $field 0]
        set value       [escapeSpecialChars [.fr.entry$name get]]
        set newline     [expr {[lindex $fields end] != $field ? ",\n" : "\n"}]

        set valueLength [string length $value]
        set minLength   [lindex $field 3]
        set maxLength   [lindex $field 4]

        if {$valueLength < $minLength} {
            puts stderr [format "Error: Testing minLength '%s' on field '%s'" $minLength $name]
            incr errors
        } elseif {$valueLength > $maxLength} {
            puts stderr [format "Error: Testing maxLength '%s' on field '%s'" $maxLength $name]
            incr errors
        }
        append result "    \"" $name "\": \"" $value "\"" $newline
    }
    append result "  \}\n\}"
    return $result
}

proc onAccept {} {
    set errors 0
    set result [getFormValues errors]

    if {$errors > 0} {
        puts stderr [format "%d errors found\n\nInvalid data:\n%s" $errors $result]
        exit 1
    } else {
        puts stdout $result
        exit 0
    }
}

proc onCancel {} {
    exit 0
}

source data.tcl
set row 0

frame .fr -borderwidth 1 -relief raised -padx 4 -pady 4

# Pack label and entry
foreach field $fields {
    set name  [lindex $field 0]
    set title [lindex $field 1]
    set width [lindex $field 2]

    grid [label .fr.label$name -text $title] \
        -row $row -column 0 -sticky w -padx 4 -pady 2
    grid [entry .fr.entry$name -width $width -highlightthickness 0] \
        -row $row -column 1 -sticky w -padx 4 -pady 2
    incr row
}

grid [ttk::separator .fr.hrule] -row $row -columnspan 2 -sticky ew -padx 4 -pady 4
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

