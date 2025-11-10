# Create a new Simulator instance
set ns [new Simulator]

# Set color codes for NAM visualization
$ns color 1 Blue
$ns color 2 Red

# Open NAM output file
set nf [open out.nam w]
$ns namtrace-all $nf

# Finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Create duplex links between nodes
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail

# Create TCP agents
set tcp0 [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp0

set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $n1 $tcp1

# Connect TCP agents
$ns connect $tcp0 $tcp1

# Flow IDs and window sizes
$tcp0 set fid_ 1
$tcp0 set window_ 2

$tcp1 set fid_ 2
$tcp1 set window_ 2

# Create FTP applications
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

# Start and stop events
$ns at 0.1 "$ftp0 start"
$ns at 1.0 "$ftp1 start"
$ns at 12.0 "$ftp0 stop"
$ns at 12.5 "$ftp1 stop"
$ns at 13.0 "finish"

# Run simulation
$ns run

