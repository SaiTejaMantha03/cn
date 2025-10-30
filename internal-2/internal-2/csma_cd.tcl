# ==============================
# CSMA/CD Network Simulation in NS2
# ==============================

# Disable debug messages for the LAN Router
LanRouter set debug_ 0

# Create a new Simulator object
set ns [new Simulator]

# ==============================
# Coloring and Tracing
# ==============================

# Assign colors to different flow IDs for better visualization in NAM
$ns color 1 Green
$ns color 2 Yellow

# Open trace files to record simulation data
set file1 [open out.tr w]   ;# Text trace file for analysis
set file2 [open out.nam w]  ;# NAM file for animation

# Enable tracing for both files
$ns trace-all $file1
$ns namtrace-all $file2

# ==============================
# Define 'finish' procedure
# ==============================
# This procedure runs at the end of the simulation
proc finish {} {
    global ns file1 file2
    $ns flush-trace          ;# Write all remaining trace data to file
    close $file1             ;# Close trace file
    close $file2             ;# Close NAM file
    exec nam out.nam &       ;# Open Network Animator to view results
    exit 0                   ;# End the simulation
}

# ==============================
# Node Creation
# ==============================

# Create 6 nodes (computers/routers)
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# ==============================
# Node Color and Shape Settings
# ==============================

# Assign colors and shapes to identify nodes easily in NAM
$ns color 1 red
$ns color 2 blue
$n0 shape box
$n1 color black
$n2 color blue
$n3 color violet
$n4 color orange
$n5 shape box
$n5 color brown

# ==============================
# Link Configuration
# ==============================

# Connect nodes using duplex (two-way) links
# Format: $ns duplex-link <node1> <node2> <bandwidth> <delay> <queue_type>
$ns duplex-link $n0 $n2 2Mb 10ns DropTail
$ns duplex-link $n1 $n2 2Mb 10ns DropTail
$ns duplex-link $n2 $n3 2Mb 10ns DropTail
$ns duplex-link $n3 $n4 2Mb 10ns DropTail
$ns duplex-link $n3 $n5 2Mb 10ns DropTail

# ==============================
# CSMA/CD LAN Creation
# ==============================

# Create a LAN using CSMA/CD (Carrier Sense Multiple Access with Collision Detection)
# LAN connects nodes n3, n4, and n5
# Bandwidth = 1Mb, Delay = 40ms
set lan [$ns newLan "$n3 $n4 $n5" 1Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

# ==============================
# TCP Connection Setup
# ==============================

# Create a TCP sender agent using NewReno variant
set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2            ;# Assign color ID (for tracing)

# Create a TCP receiver agent (sink)
set sink [new Agent/TCPSink/DelAck]

# Attach sender and receiver agents to nodes
$ns attach-agent $n4 $tcp
$ns attach-agent $n5 $sink

# Connect TCP sender and receiver
$ns connect $tcp $sink
$tcp set window_ 1000        ;# Set TCP window size (controls flow of packets)

# Create an FTP application running over TCP
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

# Start and stop FTP traffic at specific times
$ns at 0.5 "$ftp start"
$ns at 2.0 "$ftp stop"

# ==============================
# UDP Connection Setup
# ==============================

# Create a UDP sender and a Null receiver
set udp [new Agent/UDP]
set null [new Agent/Null]

# Attach agents to nodes
$ns attach-agent $n0 $udp
$ns attach-agent $n1 $null

# Connect UDP sender and receiver
$ns connect $udp $null

# Create a CBR (Constant Bit Rate) traffic source over UDP
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1110   ;# Each packet = 1110 bytes
$cbr set rate_ 0.5Mb         ;# Sending rate = 0.5 Mbps

# Start and stop UDP traffic
$ns at 0.5 "$cbr start"
$ns at 2.0 "$cbr stop"

# ==============================
# Simulation End
# ==============================

# Stop simulation at 2.5 seconds and run the finish procedure
$ns at 2.5 "finish"

# Run the simulation
$ns run

