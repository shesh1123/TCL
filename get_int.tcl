proc get_int {} {
 set check ""
 set int_out [exec "show interfaces"]
 foreach int [regexp -all -line -inline "(^GigabitEthernet\[0-9])" $int_out] {
 if {![string equal $check $int]} {
 if {[info exists bri_out]} {
 append bri_out "," $int
 } else {
 
 set bri_out $int
 }
 set check $int
 }
 }
 return $bri_out
}

get_int