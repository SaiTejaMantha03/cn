set ns [new Simulator]

# Open NAM trace file
set nf [open thro.nam w]
$ns namtrace-all $nf

# Define finish procedure
proc finish { } {
    global ns nf
    $ns flush-trace
    close $nf
    puts "Running Nam..."
    exec nam thro.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Create duplex links forming a mesh topology
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n4 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms DropTail
$ns duplex-link $n4 $n0 1Mb 10ms DropTail
$ns duplex-link $n4 $n3 1Mb 10ms DropTail

# Create UDP agent and attach to n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create Null agent (sink) and attach to n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

# Connect UDP to Null
$ns connect $udp0 $null0

# Create CBR traffic source
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

# Enable Link State routing protocol
$ns rtproto LS

# Simulate link failures and recoveries
$ns rtmodel-at 1.5 down $n0 $n1
$ns rtmodel-at 2.0 down $n4 $n1
$ns rtmodel-at 2.5 up $n1 $n4
$ns rtmodel-at 2.9 up $n1 $n0

# Set flow ID
$udp0 set fid_ 1

# Schedule events
$ns at 1.0 "$cbr0 start"
$ns at 3.2 "finish"

# Run simulation
$ns run
