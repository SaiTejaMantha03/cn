# Create a new simulator instance
set ns [new Simulator]

# Set color codes for different data flows (for NAM visualization)
$ns color 1 Blue
$ns color 2 Red

# Open the NAM (Network Animator) output file
set file1 [open out.nam w]

# Record all simulation events to the NAM file
$ns namtrace-all $file1

# Define a procedure to end the simulation
proc finish {} {
    global ns file1
    # Flush trace data to file
    $ns flush-trace
    # Close the NAM trace file
    close $file1
    # Execute NAM animation to visualize the simulation
    exec nam out.nam &
    # Exit the simulation
    exit 0
}

# Create three nodes: n0, n1, and n2
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

# Create duplex links between nodes with 10 Mbps bandwidth and 10 ms delay
# Using DropTail queue management
$ns duplex-link $n0 $n2 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail

# Create two TCP agents using the NewReno variant
set tcp [new Agent/TCP/Newreno]
$ns attach-agent $n0 $tcp

set tcp1 [new Agent/TCP/Newreno]
$ns attach-agent $n1 $tcp1

# Connect TCP agents (n0 to n1) through n2
$ns connect $tcp $tcp1

# Assign flow IDs and window sizes for TCP agents
$tcp set fid_ 1
$tcp set window_ 2

$tcp1 set fid_ 2
$tcp1 set window_ 2

# Create FTP applications and attach them to TCP agents
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ftp set type_ FTP

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP

# Schedule the start and stop times for FTP applications
$ns at 0.1 "$ftp start"      ;# FTP1 starts at 0.1s
$ns at 1.0 "$ftp1 start"     ;# FTP2 starts at 1.0s
$ns at 12.0 "$ftp stop"      ;# FTP1 stops at 12.0s
$ns at 12.5 "$ftp1 stop"     ;# FTP2 stops at 12.5s

# Call finish procedure at 13.0s (end of simulation)
$ns at 13.0 "finish"

# Run the simulation
$ns run

