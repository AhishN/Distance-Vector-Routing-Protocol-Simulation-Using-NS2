set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nr [open dv.tr w]
set nr1 [open dv1.tr w]
set nr2 [open dv2.tr w]

$ns trace-all $nr
set nf [open dvProgram1.nam w]


$ns namtrace-all $nf

        proc finish { } {
        global ns nr nf
        $ns flush-trace
        close $nf
        close $nr
        exec nam dvProgram1.nam &
 exec xgraph dv1.tr dv2.tr -geometry 800x400 &
	exit 0
        }

proc record {} {
        global sink0 sink1 nr1 nr2
 #Get an instance of the simulator
 set ns [Simulator instance]
 #Set the time after which the procedure should be called again
        set time 0.5
 #How many bytes have been received by the traffic sinks?
        set bw0 [$sink0 set bytes_]
        set bw1 [$sink1 set bytes_]
     #   set bw2 [$sink2 set bytes_]
 #Get the current time
        set now [$ns now]
 #Calculate the bandwidth (in MBit/s) and write it to the files
        puts $nr1 "$now [expr $bw0/$time*8/1000000]"
        puts $nr2 "$now [expr $bw1/$time*8/1000000]"
       # puts $f2 "$now [expr $bw2/$time*8/1000000]"
 #Reset the bytes_ values on the traffic sinks
        $sink0 set bytes_ 0
        $sink1 set bytes_ 0
        #$sink2 set bytes_ 0
 #Re-schedule the procedure
        $ns at [expr $now+$time] "record"
}


for { set i 0 } { $i < 13} { incr i 1 } {
	set n($i) [$ns node]}

for {set i 0} {$i < 6} {incr i} {
$ns duplex-link $n($i) $n([expr $i+1]) 1Mb 10ms DropTail }
$ns duplex-link $n(0) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(3) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(5) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(6) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(4) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(7) 1Mb 10ms DropTail
$ns duplex-link $n(2) $n(8) 1Mb 10ms DropTail
$ns duplex-link $n(3) $n(9) 1Mb 10ms DropTail
$ns duplex-link $n(4) $n(10) 1Mb 10ms DropTail
$ns duplex-link $n(5) $n(11) 1Mb 10ms DropTail
$ns duplex-link $n(6) $n(12) 1Mb 10ms DropTail
$ns duplex-link $n(6) $n(1) 1Mb 10ms DropTail
$ns duplex-link $n(7) $n(12) 1Mb 10ms DropTail

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
$ftp0 set packetSize_ 200

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


$ns rtproto DV 

$ns rtmodel-at 2.0 down $n(0) $n(6)
$ns rtmodel-at 3.0 down $n(0) $n(5)
$ns rtmodel-at 2.0 down $n(0) $n(1)
$ns rtmodel-at 20.0 up $n(0) $n(6)
$ns rtmodel-at 2.0 down $n(3) $n(9)
$ns rtmodel-at 2.0 down $n(6) $n(12)
$ns rtmodel-at 10.0 up $n(6) $n(12)
$ns rtmodel-at 15.0 up $n(3) $n(9)
$ns rtmodel-at 18.0 up $n(0) $n(1)
$ns rtmodel-at 25.0 up $n(0) $n(5)

$ns at 0.0 "record"

$ns at 0.2 "$ftp0 start"
#$ns at 30.0 "$ftp0 stop"

$ns at 1.0 "$ftp1 start"
#$ns at 30.0 "$ftp1 stop"

$ns at 30.0 "finish"
$ns run
