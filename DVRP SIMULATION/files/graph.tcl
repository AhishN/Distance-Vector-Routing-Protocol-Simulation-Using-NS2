set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nr [open c.tr w]
#set nr1 [open c1.tr w]
#set nr2 [open c2.tr w]

$ns trace-all $nr
set nf [open c.nam w]


$ns namtrace-all $nf

        proc finish { } {
        global ns nr nf
        $ns flush-trace
        close $nf
        close $nr
 exec xgraph dv1.tr dv2.tr DV1.tr DV2.tr -geometry 800x400 &
	exit 0
        
}



for { set i 0 } { $i < 13} { incr i 1 } {
	set n($i) [$ns node]}

for {set i 0} {$i < 6} {incr i} {
$ns duplex-link $n($i) $n([expr $i+1]) 1Mb 10ms DropTail }
$ns duplex-link $n(0) $n(2) 0.1Mb 10ms DropTail
$ns duplex-link $n(0) $n(3) 0.1Mb 10ms DropTail
$ns duplex-link $n(0) $n(5) 0.1Mb 10ms DropTail
$ns duplex-link $n(0) $n(6) 0.1Mb 10ms DropTail
$ns duplex-link $n(0) $n(4) 0.1Mb 10ms DropTail
$ns duplex-link $n(1) $n(7) 0.1Mb 10ms DropTail
$ns duplex-link $n(2) $n(8) 0.1Mb 10ms DropTail
$ns duplex-link $n(3) $n(9) 0.1Mb 10ms DropTail
$ns duplex-link $n(4) $n(10) 0.1Mb 10ms DropTail
$ns duplex-link $n(5) $n(11) 0.1Mb 10ms DropTail
$ns duplex-link $n(6) $n(12) 0.1Mb 10ms DropTail
$ns duplex-link $n(6) $n(1) 0.1Mb 10ms DropTail
$ns duplex-link $n(7) $n(12) 0.1Mb 10ms DropTail

for {set i 7} {$i < 12} {incr i} {
$ns duplex-link $n($i) $n([expr $i+1]) 1Mb 10ms DropTail }



set tcp0 [new Agent/TCP]
$tcp0 set class_ 2
$ns attach-agent $n(12) $tcp0
set sink0 [new Agent/TCPSink]
$ns attach-agent $n(0) $sink0
$ns connect $tcp0 $sink0

#Attach FTP Application over TCP
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set type_ FTP
$ftp0 set packetSize_ 20

set tcp1 [new Agent/TCP]
$tcp1 set class_ 1
$ns attach-agent $n(9) $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n(0) $sink1
$ns connect $tcp1 $sink1

#Attach FTP Application over TCP
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set type_ FTP
$ftp1 set packetSize_ 200





$ns at 0.2 "$ftp0 start"
#$ns at 10.0 "$ftp0 stop"

$ns at 1.0 "$ftp1 start"
#$ns at 10.0 "$ftp1 stop"

$ns at 10.0 "finish"
$ns run
