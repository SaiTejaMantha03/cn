# Create simulator object
set ns [new Simulator]

# Open trace files (both .tr for simulation data and .nam for NAM visualization)
set nf [open out.nam w]
$ns namtrace-all $nf

# Define nodes in the ring topology
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create duplex links between nodes with specific bandwidth, delay, and queue management
$ns duplex-link $n0 $n1 10Mbps 10ms DropTail
$ns duplex-link $n1 $n2 10Mbps 10ms DropTail
$ns duplex-link $n2 $n3 10Mbps 10ms DropTail
$ns duplex-link $n3 $n4 10Mbps 10ms DropTail
$ns duplex-link $n4 $n5 10Mbps 10ms DropTail
$ns duplex-link $n5 $n0 10Mbps 10ms DropTail

# Set link orientations (for visualization in NAM)
$ns duplex-link-op $n0 $n1 orient up
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n3 $n4 orient down
$ns duplex-link-op $n4 $n5 orient left-down
$ns duplex-link-op $n5 $n0 orient left-up

# Finish procedure to flush and close the simulation, then open the NAM file for visualization
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam out.nam &
    exit 0
}


# Schedule the finish procedure to run at 5.00 seconds
$ns at 5.00 "finish"

# Run the simulation
$ns run


