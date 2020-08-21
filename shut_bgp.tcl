::cisco::eem::event_register_track 10 state down

namespace import ::cisco::eem::*
namespace import ::cisco::lib::*


proc shut_bgp {} {

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
	if [catch {cli_exec $cli1(fd) "neighbor 10.10.10.2 shutdown"} result] {
	    error $result $errorInfo
	}	
	if [catch {cli_exec $cli1(fd) "end"} result] {
	    error $result $errorInfo
	}
	if [catch {cli_exec $cli1(fd) "wr"} result] {
	    error $result $errorInfo
	}
	if [catch {cli_close $cli1(fd) $cli1(tty_id)} result] {
    	error $result $errorInfo 
    }
}


shut_bgp

