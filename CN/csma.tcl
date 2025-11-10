# --- CSMA/CD Access Control Protocol Simulation using NS2 ---

# Create Simulator and output files
set ns [new Simulator]
set nf [open out.nam w]
set f [open out.tr w]
$ns namtrace-all $nf
$ns trace-all $f

# Assign flow colors for NAM visualization
$ns color 1 green
$ns color 2 blue

# Finish procedure
proc finish {} {
    global ns nf f
    $ns flush-trace
    close $nf
    close $f
    exec nam out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]   ;# TCP Sender
set n1 [$ns node]   ;# UDP Sender
set n2 [$ns node]   ;# Router / Gateway
set n3 [$ns node]   ;# LAN Interface node
set n4 [$ns node]   ;# TCP Receiver (on LAN)
set n5 [$ns node]   ;# UDP Receiver (on LAN)

# Point-to-point links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

# Router connects to CSMA/CD LAN
$ns duplex-link $n2 $n3 1Mb 1ms DropTail
$ns newLan "$n3 $n4 $n5" 1Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel

# --- TCP over FTP setup ---
Agent/TCP set nam_tracevar_ true
set tcp [new Agent/TCP/Newreno]
set sink [new Agent/TCPSink]
$ns attach-agent $n0 $tcp
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1

set ftp [new Application/FTP]
$ftp attach-agent $tcp

# --- UDP over CBR setup ---
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n1 $udp
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set packet_size_ 1000
$cbr set rate_ 0.01mb
$cbr set random_ false

# --- Start and Stop times ---
$ns at 0.5 "$ftp start"
$ns at 1.0 "$cbr start"
$ns at 9.0 "$ftp stop"
$ns at 9.5 "$cbr stop"
$ns at 10.0 "finish"

# Run simulation
$ns run

