# ============================
# WIRELESS NETWORK SIMULATION
# Using TCP and FTP traffic
# ============================

# ----- Simulation parameters -----
set val(chan)   Channel/WirelessChannel    ;# Type of channel used for communication
set val(prop)   Propagation/TwoRayGround   ;# Radio propagation model
set val(netif)  Phy/WirelessPhy            ;# Physical layer type
set val(mac)    Mac/802_11                 ;# MAC protocol (Wi-Fi)
set val(ifq)    Queue/DropTail/PriQueue    ;# Interface queue type
set val(ll)     LL                         ;# Link layer type
set val(ant)    Antenna/OmniAntenna        ;# Antenna type
set val(ifqlen) 50                         ;# Maximum packets in queue
set val(nn)     4                          ;# Number of nodes
set val(rp)     DSDV                       ;# Routing protocol (table-driven)

# ----- Create a new Simulator object -----
set ns [new Simulator]

# ----- Trace and NAM (Network Animator) files -----
set tracefd [open simple.tr w]
set namtrace [open simple-out.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace 500 500

# ----- Define Topography (500x500 area) -----
set topo [new Topography]
$topo load_flatgrid 500 500

# ----- Create the wireless channel -----
set chan_1_ [new $val(chan)]

# ----- Create the God object (IMPORTANT) -----
create-god $val(nn)

# ----- Configure wireless nodes -----
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channel $chan_1_ \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF

# ----- Create nodes -----
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) random-motion 0 ;# Disable random motion for now
}

# ----- Set initial positions of nodes -----
$node_(0) set X_ 2.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 390.0
$node_(1) set Y_ 385.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 20.0
$node_(2) set Y_ 15.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 480.0
$node_(3) set Y_ 15.0
$node_(3) set Z_ 0.0

# ----- Define node movements -----
$ns at 100.0 "$node_(0) setdest 25.0 20.0 15.0"
$ns at 100.0 "$node_(1) setdest 20.0 18.0 11.0"
$ns at 100.0 "$node_(2) setdest 490.0 480.0 15.0"

# ----- Create TCP agent (sender) -----
set tcp [new Agent/TCP]
$tcp set class_ 2
set sink [new Agent/TCPSink]

# Attach TCP sender to node 0 and sink to node 1
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink

# ----- Create FTP application over TCP -----
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Start FTP traffic at 10 seconds
$ns at 10.0 "$ftp start"

# Stop simulation after 150 seconds
$ns at 150.0 "$ftp stop"
$ns at 150.01 "puts \"NS EXITING...\"; $ns halt"

# ----- Define finish procedure -----
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    puts "running nam..."
    exec nam simple-out.nam &
    exit 0
}

puts "Starting Simulation..."
$ns run

