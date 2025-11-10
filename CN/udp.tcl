# Create simulator
set ns [new Simulator]

# Set colors for NAM visualization
$ns color 1 Blue
$ns color 2 Red

# Open NAM trace file
set nf [open udpout1.nam w]
$ns namtrace-all $nf

# Define finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    puts "running nam"
    exec nam udpout1.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Create duplex links (2Mb, 10ms)
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n1 $n3 2Mb 10ms DropTail
$ns duplex-link $n0 $n4 2Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail

# UDP connection 1: n0 → n1
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0
$ns connect $udp0 $null0

# UDP connection 2: n3 → n4
set udp1 [new Agent/UDP]
$ns attach-agent $n3 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n4 $null1
$ns connect $udp1 $null1

# Set flow IDs
$udp0 set fid_ 1
$udp1 set fid_ 2

# CBR traffic sources
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packet_size_ 500
$cbr0 set interval_ 0.005

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packet_size_ 500
$cbr1 set interval_ 0.005

# Schedule events
$ns at 0.1 "$cbr0 start"
$ns at 0.5 "$cbr1 start"
$ns at 0.5 "$cbr0 stop"
$ns at 0.9 "$cbr1 stop"
$ns at 1.05 "finish"

# Run simulation
$ns run

