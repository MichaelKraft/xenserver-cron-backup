<?php

// Settings
$loglocation = 'backup.log';
$outputlocation = 'backup.report';

class VM {
        public $name;
        public $exported = false;
        public $duration;
}

$vmlogs = array_diff(explode('---', file_get_contents($loglocation)), array(''));

$vmrecords = array();

foreach ($vmlogs as $key => $vmlog) {
        $logitems = array_diff(explode(PHP_EOL, $vmlog), array(''));
        $logitems = array_values($logitems);
        if(count($logitems) > 0) {
                $vm = new VM;

                $vm->name = str_replace('Snapshotting ', '', str_replace('...', '', $logitems[0]));
                $vm->exported = strpos($logitems[4], 'Completed') !== false;

                if($vm->exported) {
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
                if($vm->exported) {
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
