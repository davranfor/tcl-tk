#!/usr/bin/wish

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

set table [Table new]
set widgets {}

# Pack labels and widgets
foreach field $fields {
    set type [lindex $field $Field::Widget]

    switch $type {
        label -
        hrule {
            set length [llength $widgets]
            set fields [lreplace $fields $length $length]

            $table $type $field
        }
        default {
            lappend widgets [$table widget $field $type]
        }
    }
}
$table hrule
$table buttons $form

wm title . [lindex $form $Form::Title]
# not resizable
wm resizable . 0 0
# position
wm geometry . +450+200

after idle focus -force [lindex $widgets 0]

bind .      <Escape>    {onCancel}
bind Text   <Tab>       {continue}
bind Text   <KP_Enter>  {event generate %W <Return>}
bind Button <Return>    {event generate %W <space>}
bind Button <KP_Enter>  {event generate %W <space>}

# Uncomment the following lines to bind Return as Tab  
#bind Entry  <Return>    {event generate %W <Tab>}
#bind Entry  <KP_Enter>  {event generate %W <Tab>}

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

