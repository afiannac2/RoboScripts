RoboScripts
===========

In order to setup your new shiny copy of Ubuntu 12.04, run the following command in the terminal (`Ctrl + Shift + t`):

	wget --no-check-certificate 'https://github.com/afiannac2/RoboScripts/archive/master.zip' && unzip master.zip -d ~/ && . ${HOME}/RoboScripts-master/RoboSetup.sh && rm -r ~/RoboScripts-master/ master.zip

Notes:
------

- **DON'T TYPE OUT THE COMMAND ABOVE**: *Copy/Paste* to save time and prevent errors!
- You may receive a prompt asking you if `hddtemp` should be started at runtime. If you are installing this on a VM, select No.
- You will probably be prompted by the OS to update to Ubuntu 14.xx at some point. Just say no...