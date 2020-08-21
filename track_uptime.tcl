::cisco::eem::event_register_syslog occurs 1 pattern ".*LINEPROTO-5-UPDOWN.*GigabitEthernet1.*down.*"

namespace import ::cisco::eem::*
namespace import ::cisco::lib::*

proc TimeToSeconds t {
	set result 0
    foreach val [split $t :] mul {3600 60 1} {
        if {$val == {}} break
        incr result [expr {[scan $val %d] * $mul}]
    }
    return $result
}

proc get_track_uptime {} {
	if [catch {cli_open} result] {
    error $result $errorInfo
	} else {
    array set cli1 $result
}
	if [catch {cli_exec $cli1(fd) "show track 10  | inc last"} result] {
    error $result $errorInfo
	} else { set track_out [string trim $result]}
	puts "Index 4 : [lindex $result 4] "
	set uptime [lindex $result 4]
	#regexp {\d+:\d+:\d+$} $track_out uptime
	set elasped_time [TimeToSeconds $uptime]
	if {$elasped_time >= 14400} {
		puts "Link is stable for 4 hrs"
		} else {puts "[expr {14400 - $elasped_time}] seconds to go"}
	}

get_track_uptime
