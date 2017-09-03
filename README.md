# Mean escape times

This is the code connected to a Master thesis at the University of Oxford. The project
centered around an experiment with e-puck robots, and this repository contains some
of the connected code and instruction to replicate the experiment.

## Summary
The basic idea of this project was to have a robot follow a random process and track the time its needs to escape from a circle. The setup was based on the [arena](auxiliary files/arena.pdf
), which was printed on a 1.2x1.2m poster.
The code above contains routines for several use cases. The most important function has the robots
follow a velocity jump process, while reading the data from the ground sensors and transmit it via the uart2 channel. The second experimental relevant function, only allows the robots to the velocity jump process, with their velocity dependent on the selector position.
The remaining functions only have calibration and testing purposes.  


## Getting Started

The file structure of this repository is as follows. The folders  ``matlab-files`` and
``auxilary`` files contain files not directly relevant for the programming of the robots,
while everything else just concerns the robots programming.
The former folder contains some files regarding data retrieval and calibration,
while the latter contains miscellaneous.  

### Prerequisites

Most of the relevant knowledge to setup the e-puck robots may be found in the
[GCtronic Wiki](http://www.gctronic.com/doc/index.php/E-Puck).

Specifically, in addition to the project file above the following is needed:
* [MPLAB X IDE](http://www.microchip.com/mplab/mplab-x-ide): This integrated developer environment (IDE)
  combines the necessary libraries and compiles the firmware for the robots.
* [MPLAB C30 compiler](http://www.gctronic.com/files/MPLAB_C30_v3_00-StudentEdition.exe)
  The compiler necessary for the e-puck code. Theoretically, it should be added to the MPLAB install automatically. If that does not work, it needs to be linked in the settings.
* [Standard library](http://projects.gctronic.com/E-Puck/e-puck-gna-svn-rev116.zip) This library
  needs to be placed in the same folder as the folder containing the files above.














<!-- ## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc -->
