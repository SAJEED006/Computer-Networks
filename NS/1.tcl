set ns [new Simulator]
set f [open lab1.tr w]
set nf [open lab1.nam w]
$ns trace-all $f
$ns namtrace-all $nf

proc finish {} {
      global f nf ns
      $ns flush-trace
      close $f
      close $nf
      exec nam lab1.nam &
      exit 0
}
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
$n0 label "TCP Source"
$n1 label "UDP Source"
$n2 label "Sink"
$ns color 1 red
$ns color 2 yellow

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 20ms DropTail
$ns queue-limit $n1 $n2 10

$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
set null0 [new Agent/Null]
$ns attach-agent $n2 $null0
$ns connect $udp0 $null0
set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0
			
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $sink
$ftp0 set maxPkts_ 1000
$ns connect $tcp0 $sink

$udp0 set class_ 1
$tcp0 set class_ 2

$ns at 0.1 "$cbr0 start"
$ns at 1.0 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"
$ns run
