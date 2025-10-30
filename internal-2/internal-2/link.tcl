# ==============================
# Network Simulation in NS2
# ==============================

# Create a new simulator object
set ns [new Simulator]

# Open a NAM (Network Animator) trace file named "thro.nam" for writing
set nf [open thro.nam w]
$ns namtrace-all $nf

# Define a 'finish' procedure to end simulation properly
proc finish {} {
    global ns nf
    $ns flush-trace         ;# Flush any remaining trace data
    close $nf               ;# Close the NAM file
    puts "Running Nam..."   ;# Print message
    exec nam thro.nam &     ;# Launch Network Animator (NAM) to visualize the simulation
    exit 0
}

# ==============================
# Node Creation
# ==============================
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# ==============================
# Link Configuration
# ==============================
# Create duplex (two-way) links between nodes with bandwidth = 1Mb, delay = 10ms, and DropTail queue
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n4 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n3 $n2 1Mb 10ms DropTail
$ns duplex-link $n4 $n0 1Mb 10ms DropTail
$ns duplex-link $n4 $n3 1Mb 10ms DropTail

# ==============================
# Agent and Application Setup
# ==============================

# Create a UDP agent at node n0
set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

# Create a Null agent (receiver) at node n1
set null0 [new Agent/Null]
$ns attach-agent $n1 $null0

# Connect sender and receiver agents
$ns connect $udp0 $null0

# Create a CBR (Constant Bit Rate) traffic source attached to the UDP agent
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

# Configure traffic parameters
set packetSize_ 500           ;# Packet size = 500 bytes
$cbr0 set interval_ 0.005     ;# Time interval between packets = 0.005s (i.e., 200 packets/sec)

# ==============================
# Routing Configuration
# ==============================
$ns rtproto LS                ;# Use Link State (LS) routing protocol

# ==============================
# Link Failure and Recovery Events
# ==============================
# Schedule link failures and recoveries during simulation
$ns rtmodel-at 1.5 down $n0 $n1    ;# At 1.5s, link between n0 and n1 goes down
$ns rtmodel-at 2.0 down $n4 $n1    ;# At 2.0s, link between n4 and n1 goes down
$ns rtmodel-at 2.5 up $n1 $n4      ;# At 2.5s, link between n1 and n4 is restored
$ns rtmodel-at 2.9 up $n1 $n0      ;# At 2.9s, link between n1 and n0 is restored

# ==============================
# Flow and Simulation Timing
# ==============================
$udp0 set fid_ 1                ;# Set flow ID for tracing
$ns at 1.0 "$cbr0 start"        ;# Start CBR traffic at 1.0s
$ns at 3.2 "finish"             ;# Stop simulation and call 'finish' procedure at 3.2s

# ==============================
# Run Simulation
# ==============================
$ns run

