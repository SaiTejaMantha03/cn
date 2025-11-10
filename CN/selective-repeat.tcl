# Selective-Repeat-ARQ.tcl

# Create simulator and trace file
set ns [new Simulator]
set nf [open Selective-Repeat.nam w]
$ns namtrace-all $nf

# Finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    close $nf
    exec nam Selective-Repeat.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]    ;# Sender
set n1 [$ns node]    ;# Router 1
set n2 [$ns node]    ;# Router 2
set n3 [$ns node]    ;# Receiver

# Create links
$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail

# Configure TCP (Selective Repeat behavior)
Agent/TCP set nam_tracevar_ true
set tcp [new Agent/TCP]
$tcp set windowInit_ 10
$tcp set maxcwnd_ 10
$ns attach-agent $n0 $tcp

# TCP Sink
set sink [new Agent/TCPSink]
$ns attach-agent $n3 $sink
$ns connect $tcp $sink

# FTP Application
set ftp [new Application/FTP]
$ftp attach-agent $tcp

# Start and stop FTP
$ns at 0.1 "$ftp start"
$ns at 4.0 "$ftp stop"

# End simulation
$ns at 5.0 "finish"

# Run simulation
$ns run

