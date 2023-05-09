set mapOfSpecialChars {
    "\\" "\\\\" "\"" "\\\"" "\b" "\\b" "\f" "\\f" "\n" "\\n" "\r" "\\r" "\t" "\\t"
}

proc escapeSpecialChars {text} {
    return [string map $::mapOfSpecialChars $text]
}

proc getValue {widget type} {
    switch $type {
        entry {set value [$widget get]}
        text  {set value [$widget get 1.0 end]}
    }
    return [escapeSpecialChars [string trim $value]]
}

proc readForm {form _errors} {
    global fields widgets
    upvar $_errors errors

    set errors ""
    set result ""

    append result "\{\n  \"form\": \"$form\",\n  \"fields\": \{\n"
    foreach field $fields widget $widgets {
        set name        [lindex $field $Field::Name]
        set value       [getValue $widget [lindex $field $Field::Widget]]

        set length      [string length $value]
        set minLength   [lindex $field $Field::MinLength]
        set maxLength   [lindex $field $Field::MaxLength]

        if {($length < $minLength) || ($length > $maxLength)} {
            append errors "$name: Length not in range ($minLength, $maxLength)\n"
        }

        set regExp [lindex $field $Field::RegExp]

        if {($regExp ne "") && ([regexp $regExp $value] != 1)} {
            append errors "$name: RegExp $regExp doesn't match\n"
        }

        set quote [expr {[lindex $field $Field::Type] == "string" ? "\"" : ""}]
        set delim [expr {[lindex $fields end] != $field ? ",\n" : "\n"}]

        append result "    \"$name\": $quote$value$quote$delim"
    }
    append result "  \}\n\}"
    return $result
}

