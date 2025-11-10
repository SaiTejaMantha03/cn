# Minimal UDP/CBR NS2 Script

set ns [new Simulator]

# Open trace and NAM files
set tracefile [open udp_out.tr w]
set namfile [open udp_out.nam w]
$ns trace-all $tracefile
$ns namtrace-all $namfile

# Finish procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam udp_out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create duplex links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 1.7Mb 20ms DropTail
$ns duplex-link $n3 $n4 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail

# Set queue limit
$ns queue-limit $n2 $n3 10

# First UDP/CBR flow (n0 → n4)
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n4 $null0
$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 512
$cbr0 set rate_ 1Mb
$cbr0 set random_ false

# Second UDP/CBR flow (n1 → n5)
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n5 $null1
$ns connect $udp1 $null1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 512
$cbr1 set rate_ 0.8Mb
$cbr1 set random_ false

# Schedule events
$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$cbr1 start"
$ns at 4.5 "$cbr0 stop"
$ns at 4.5 "$cbr1 stop"
$ns at 5.0 "finish"

# Run simulation
$ns run
