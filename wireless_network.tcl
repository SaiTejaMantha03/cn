# Define wireless parameters
set val(chan)    Channel/WirelessChannel
set val(prop)    Propagation/TwoRayGround
set val(netif)   Phy/WirelessPhy
set val(mac)     Mac/802_11
set val(ifq)     Queue/DropTail/PriQueue
set val(ll)      LL
set val(ant)     Antenna/OmniAntenna
set val(ifqlen)  50
set val(nn)      2
set val(rp)      DSDV

# Create simulator instance
set ns [new Simulator]

# Open trace files
set tracefd [open simple.tr w]
set namtrace [open simple-out.nam w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 500 500

# Create topography
set topo [new Topography]
$topo load_flatgrid 500 500

# Create God (General Operations Director)
create-god $val(nn)

# Configure nodes
$ns node-config -adhocRouting $val(rp) \\
    -llType $val(ll) \\
    -macType $val(mac) \\
    -ifqType $val(ifq) \\
    -ifqLen $val(ifqlen) \\
    -antType $val(ant) \\
    -propType $val(prop) \\
    -phyType $val(netif) \\
    -channelType $val(chan) \\
    -topoInstance $topo \\
    -agentTrace ON \\
    -routerTrace ON \\
    -macTrace OFF \\
    -movementTrace OFF

# Create nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) random-motion 0
}

# Set initial positions
$node_(0) set X_ 5.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 390.0
$node_(1) set Y_ 385.0
$node_(1) set Z_ 0.0

# Define node movements
$ns at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
$ns at 10.0 "$node_(0) setdest 20.0 18.0 1.0"
$ns at 100.0 "$node_(1) setdest 490.0 480.0 15.0"

# Setup TCP connection
set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink

# Setup FTP application
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 10.0 "$ftp start"

# Reset nodes at end
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 150.0 "$node_($i) reset"
}

# Define finish procedure
proc stop {} {
    global ns tracefd
    $ns flush-trace
    close $tracefd
    puts "Running nam..."
    exec nam simple-out.nam &
    exit 0
}

# Schedule finish
$ns at 150.0 "stop"
$ns at 150.01 "puts \\"NS EXITING...\\"; $ns halt"

# Start simulation
puts "Starting Simulation..."
$ns run
