Car Server
==========

This is the software the runs on the Linksys WRT54GL router (running DD-WRT or OpenWRT).

The compiled ipk file can be installed using the ipkg package manager on DD-WRT or OpenWRT.
(DD-WRT is recommended for ease of use)

It listens on a network socket (port 1500) for commands sent from the pc_client software
and then send commands to the serial port which are then decoded by the microcontroller
(see "embedded" folder) to drive the car.