# Create a new simulator instance
set ns [new Simulator]
set file1 [open out.nam w]

$ns namtrace-all $file1

proc finish {} {
    global ns file1
    $ns flush-trace
    close $file1
    exec nam out.nam &
    exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail

set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp

set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $n1 $tcp1
$ns connect $tcp $tcp1


$tcp set fid_ 1
$tcp set window_ 2

$tcp1 set fid_ 2
$tcp1 set window_ 2

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

# Schedule the start and stop times for FTP applications
$ns at 0.1 "$ftp start"      ;# FTP1 starts at 0.1s
$ns at 1.0 "$ftp1 start"     ;# FTP2 starts at 1.0s
$ns at 12.0 "$ftp stop"      ;# FTP1 stops at 12.0s
$ns at 12.5 "$ftp1 stop"     ;# FTP2 stops at 12.5s

# Call finish procedure at 13.0s (end of simulation)
$ns at 13.0 "finish"

# Run the simulation
$ns run

