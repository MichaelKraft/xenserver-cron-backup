<?php

// Settings
$loglocation = '/home/michael/scripts/backup.log';
$outputlocation = '/home/michael/scripts/backup.report';

class VM {
        public $name;
        public $stopped = false;
        public $exported = false;
        public $started = false;
        public $duration;
}

$vmlogs = array_diff(explode('---', file_get_contents($loglocation)), array(''));

$vmrecords = array();

foreach ($vmlogs as $key => $vmlog) {
        $logitems = array_diff(explode(PHP_EOL, $vmlog), array(''));
        $logitems = array_values($logitems);
        if(count($logitems) > 0) {
                $vm = new VM;

                $vm->name = str_replace('Stopping ', '', str_replace('...', '', $logitems[0]));
                $vm->stopped = strpos($logitems[1], 'Stopped.') !== false;
                $vm->exported = strpos($logitems[3], 'succeeded') !== false;
                $vm->started = strpos($logitems[6], 'started.') !== false;

                if($vm->stopped && $vm->exported && $vm->started) {
                        date_default_timezone_set('America/Chicago');
                        $start = strtotime($logitems[2]);
                        $end = strtotime($logitems[5]);
                        $diff = $end - $start;
                        $hours = floor($diff / 3600);
                        $mins = floor($diff / 60 % 60);
                        $secs = floor($diff % 60);

                        $vm->duration = sprintf('%02d:%02d:%02d', $hours, $mins, $secs);
                }
                array_push($vmrecords, $vm);
        }
}

$output = '';

if(count($vmrecords) > 0) {
        $output = $output . "<table><tr><td><b>Machine</b></td><td><b>Success</b></td><td><b>Duration</b></td></tr>";
        foreach ($vmrecords as $vm) {
                $output = $output . "<tr>";
                $output = $output . "<td>$vm->name</td>";
                if($vm->stopped && $vm->exported && $vm->started) {
                        $output = $output . '<td><span style="color:#008f13;"><center>✓</center></span></td>';
                        $output = $output . '<td>' . $vm->duration . '</td>';
                } else {
                        $output = $output . '<td><span style="color:#6b0000;"><center>✖</center></span></td>';
                        $output = $output . '<td></td>';
                }
                $output = $output . '</tr>';
        }
        $output = $output . '</table>';
} else {
        $output = $output . "<h1>No records.</h1>";
}

file_put_contents($outputlocation,$output);
