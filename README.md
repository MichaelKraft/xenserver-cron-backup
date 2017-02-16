# xenserver-cron-backup
Bash script for backing up VM's from a XenServer.

* Tested on a single-host personal environment.
* Designed to be run as a cron by the Xen hosts' root user.

#### Files
* `vm-backup.sh` - Performs backups on the VM host machine. Written and tested with XenServer 6.5, 7.0
* `compose-vm-report#### Files
* `vm-backup.sh` - Performs backups on the VM host machine. Written and tested with XenServer 6.5, 7.0
* `compose-vm-report.php` - Converts the log from this cron to a viewable success/fail report with durations.` - Converts the log from this cron to a viewable success/fail report with durations.

#### Settings

* `BACKUP_USING_NAMES` If set to 1 will save the backups as the Name of the virtual machine. If 0 will save as the machine's UUID.
* `MAX_WAIT_TIME` Number of seconds the script will wait to verify the machine is in the halted/running state before and after backup.
* `BACKUPROOT` Directory in which to deposit .xva files.
* `machine_uuids` Array of UUID's targeting the Virtual Machines to be backed up. Use `xe vm-list` to see them.

#### To Do

- [ ] Add a setting to indicate number of backups kept (currently locked at 3 per VM)
- [ ] Include output able to be parsed by a Nagios check.

#### Copyright (c) 2015 Michael Kraft

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
