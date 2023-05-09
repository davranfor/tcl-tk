#!/usr/bin/wish

source builder.tcl
source convert.tcl
source flags.tcl
source data.tcl

namespace eval Field {
    set Widget      0
    set Text        1
    set Name        1
    set Type        2
    set Command     2
    set Width       3
    set Height      4
    set MinLength   5
    set MaxLength   6
    set RegExp      7
    set Flags       end
}

set widgets {}
set fields {}
set flags {}

set table [Table new]

# Pack labels and widgets
foreach field $form {
    set type [lindex $field $Field::Widget]

    switch $type {
        title -
        pack  -
        label -
        hrule -
        button {
            $table $type $field
        }
        default {
            lappend flags   [setFlags $field]
            lappend widgets [$table $type $field]
            lappend fields  $field
        }
    }
}

Table destroy

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
    set result [readForm $::formName errors]

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

