# Set debug level
LanRouter set debug_ 0

# Create simulator instance
set ns [new Simulator]

# Define colors for NAM visualization
$ns color 1 Green
$ns color 2 Yellow

# Open trace files
set file1 [open out.tr w]
set winfile [open WinFile w]
$ns trace-all $file1

set file2 [open out.nam w]
$ns namtrace-all $file2

# Define finish procedure
proc finish {} {
    global ns file1 file2
    $ns flush-trace
    close $file1
    close $file2
    exec nam out.nam &
    exit 0
}

# Create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Set node colors and shapes
$n0 color red
$n0 shape box
$n1 color black
$n1 shape box
$n2 color blue
$n3 color violet
$n4 color orange
$n4 shape box
$n5 color brown
$n5 shape box

# Create duplex links
$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 2Mb 10ms DropTail

# Create LAN with CSMA/CD protocol
set lan [$ns newLan "$n3 $n4 $n5" 1Mb 40ms LL Queue/DropTail MAC/Csma/Cd Channel]

# Setup TCP connection
set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink/DelAck]
$ns attach-agent $n4 $sink
$ns connect $tcp $sink
$tcp set fid_ 1
$tcp set window_ 8000
$tcp set packetSize_ 1000

# Setup FTP over TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

# Setup UDP connection
set udp [new Agent/UDP]
$ns attach-agent $n1 $udp
set null [new Agent/Null]
$ns attach-agent $n5 $null
$ns connect $udp $null
$udp set fid_ 2

# Setup CBR over UDP connection
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp
$cbr set type_ CBR
$cbr set packet_size_ 1110
$cbr set rate_ 0.1mb
$cbr set random_ false

# Schedule events
$ns at 0.1 "$cbr start"
$ns at 1.5 "$ftp start"
$ns at 25.0 "$ftp stop"
$ns at 27.0 "$cbr stop"
$ns at 30.0 "finish"

# Run simulation
$ns run
