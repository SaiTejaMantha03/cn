set ns [new Simulator]
set nf [open SR.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 1Mb 20ms DropTail
$ns duplex-link $n2 $n3 1Mb 20ms DropTail
$ns duplex-link $n3 $n1 1Mb 20ms DropTail

set tcp [new Agent/TCP]
$tcp set windowInit_ 10
$ns attach-agent $n0 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $n1 $sink
$ns connect $tcp $sink

set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 0.1 "$ftp start"
$ns at 5.68 "$ftp stop"
$ns at 7.0 "finish"

proc finish {} {
    global ns
    $ns flush-trace
    exec nam SR.nam &
    exit 0
}

$ns run
