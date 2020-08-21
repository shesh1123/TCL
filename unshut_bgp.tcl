::cisco::eem::event_register_track 10 tag unshut_bgp state up maxrun 60

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
	} else { set track_out [string trim $result]
	}
	set uptime [lindex $result 4]
	set elasped_time [TimeToSeconds $uptime]
	if [catch {cli_close $cli1(fd) $cli1(tty_id)} result] {
    	error $result $errorInfo }
	return $elasped_time	
	}

proc unshut_bgp {} {
	if [catch {cli_open} result] {
    error $result $errorInfo
	} else {
    array set cli1 $result
	}
	if [catch {cli_exec $cli1(fd) "en"} result] {
    error $result $errorInfo
	}	
	if [catch {cli_exec $cli1(fd) "conf t"} result] {
    error $result $errorInfo
	}
	if [catch {cli_exec $cli1(fd) "router bgp 10"} result] {
	    error $result $errorInfo
	}	
	if [catch {cli_exec $cli1(fd) "no neighbor 10.10.10.2 shutdown"} result] {
	    error $result $errorInfo
	}	
	if [catch {cli_exec $cli1(fd) "end"} result] {
	    error $result $errorInfo
	}
	if [catch {cli_exec $cli1(fd) "wr"} result] {
	    error $result $errorInfo
	}
	if [catch {cli_close $cli1(fd) $cli1(tty_id)} result] {
    	error $result $errorInfo }
	}

set stable_time 0
while {$stable_time <= 10 } { 
	set stable_time [get_track_uptime]
	puts "Link is stable for $stable_time seconds"
	after 10000
}
unshut_bgp

