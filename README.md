# Mean first escape times

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
``auxilary`` files contain files relevant for the communication with a computer via bluetooth,
while everything else concerns the robots programming.
The former folder contains some files regarding data retrieval and calibration,
while the latter contains windows scripts affecting the COM-ports via the device manager.  

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


## Experimental setup

The experimental setup was as follows, with measurements as shown in subfigure **A**. The robots, as seen in subfigure **B** were modified with white belts to ensure that they are uniformly detected by fellow robots from all angles. Only the highlighted robot runs the code version that allows it to communicate with the computer via the ``uart2`` bluetooth interface.

<img src="https://crown421.github.io/rep_hosting/Robots/setup.png" width="750">

<!-- ### Sensors  -->

The sensors used in this project were the IR-proximity sensors and the ground brightness sensors as shown in the following subfigure **A**.

<img src="https://crown421.github.io/rep_hosting/Robots/Sensor_setup.png" width="750">

The ground sensor output is very noisy and differs by sensor position, robot, paper/ink quality and color profile of both the printer and the printing software. This is partially exemplified by subfigure **A**, which required smoothing as shown in subfigure **B**. The classification of each data point by the colored circle it originates from was based on calibration data for the specific robot and printout. This is shown in subfigure **C**, along with the first exit times for each circle.

<img src="https://crown421.github.io/rep_hosting/Robots/sample_exp.png" width="750">

## Modell Verification
The robot's behaviour was compared to both the numerical results from an analytic model, and a kinetic Monte-Carlo (KMC) method. This yielded  very good agreement overall, especially compared to a common and simple diffusion model. Further details and results are kept for future  publication.

<img src="https://crown421.github.io/rep_hosting/Robots/BndC_and_onePartResults.png" width="750">

<!-- <img src="https://crown421.github.io/rep_hosting/Robots/error_discussion.png" width="750"> -->






















<!-- ## Acknowledgments

* Hat tip to anyone who's code was used
* Inspiration
* etc -->
