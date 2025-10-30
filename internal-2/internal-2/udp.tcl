# ============================
# UDP + CBR Network Simulation
# ============================

# Create a new simulator instance
set ns [new Simulator]

# Set colors for data flows (for NAM visualization)
$ns color 1 Blue
$ns color 2 Red

# Open the NAM trace file for writing
set file1 [open udpout1.nam w]

# Record all events in the NAM file
$ns namtrace-all $file1

# Define the finish procedure to end simulation
proc finish {} {
    global ns file1 
    # Write all trace data and close the file
    $ns flush-trace
    close $file1
    puts "running nam"
    # Open the NAM animator to view simulation
    exec nam udpout1.nam &
    exit 0
}

# Create five network nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Create duplex (two-way) links between nodes
# Bandwidth = 2 Mbps, Delay = 10 ms, Queue = DropTail (FIFO)
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n0 $n3 2Mb 10ms DropTail
$ns duplex-link $n1 $n3 2Mb 10ms DropTail
$ns duplex-link $n0 $n4 2Mb 10ms DropTail
$ns duplex-link $n1 $n4 2Mb 10ms DropTail

# -----------------------------------
# First UDP connection: n0 → n1
# -----------------------------------

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set null [new Agent/Null]
$ns attach-agent $n1 $null

$ns connect $udp0 $null

# -----------------------------------
# Second UDP connection: n3 → n4
# -----------------------------------

set udp1 [new Agent/UDP]
$ns attach-agent $n3 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n4 $null1

$ns connect $udp1 $null1

# Set flow IDs for identification in NAM
$udp0 set fid_ 1
$udp1 set fid_ 2

# -----------------------------------
# Create CBR (Constant Bit Rate) traffic sources
# -----------------------------------

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp0
$cbr set type_ CBR   ;# Type of traffic = CBR

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set type_ CBR  ;# Type of traffic = CBR

# -----------------------------------
# Schedule simulation events (start & stop times)
# -----------------------------------

$ns at 0.1 "$cbr start"
$ns at 0.5 "$cbr1 start"
$ns at 0.5 "$cbr stop"
$ns at 0.9 "$cbr1 stop"
$ns at 1.05 "finish"

# -----------------------------------
# Run the simulation
# -----------------------------------
$ns run

