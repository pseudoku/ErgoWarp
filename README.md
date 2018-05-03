# -Warped-
Design Log and Code Repo for Customizable Split Keyboard

![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/Proto2TopView.jpg "Working Prototype Version 2.0")

## Index
 * Design Goal
 * Todo
 * Design
  * Finger placement design
  * Thumb cluster design
  * Tracking Device design
  * Palm Rest
 * Observation
 * Alternate Layout
 * How to Generate
   * _would it be easier build Clojure based build?_

### Design Goal:
* Customizable Parametric
* Minimize finger movement
* Dense and Comfortable Thumb Cluster
* Built-in Palm rest
* Adjustable tenting
* Tracking device
  * _in progress_
* Alternate Layout

### Hardware Development Todo (05/02/2018)
* Test Trackpoint Implementation
  * Integration to key switch
* Test Knocker Keys (R4s)
* Micro Adjustments on C1 Origin
* Implement C6R0 and C6R1
* Adjustment on Ts
  * Bring outer cluster closer
* Generalize the arc function by fitting "effort" parameters to ad hoc parametric functions

### Design


#### Finger Placement
![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/ "Working Prototype Version 2.0")

Simplification of finger flexion:
 Define 2D two arcs of a finger tip during finger flexion: inner (distal and intermediate flexion) and outer(distal, intermediate, proximal flexion) with metacarpal phalangeal joint as the origin. They simulate trigger motion and grab motion respectively and it is assumed that optimal placement of key switches will be between two such functions.  

 Using a CAD program I developed following ad hoc generalization that will accomodate MX switches in the arcs.

	a. Define R0 as a natural trigger, orientated tangential to the inner arc at θ=~ 90°  to simulate full adbuction
	b. Define R2 as a natural tap, orientated normal to the outer arc at θ= ~60°
	c. Define R1 as a neutral position (a combination of the former two)
		i.  Define secondary origin, an intermediate joint of a finer.
        ii. An angle bisected by vectors pointing to the secondary origin R0 and R2 position.
		iii. Intersection of such vector to the outer path orientated normal to the path.
	d. Define R3 a mirror of R1 across vector defined by intermediate joint and R2
	e. _Define R4 as a Knock|Flick (not currently implemented in the prototypes)_

Finger does not fold ortholinearly and such deviation is simulated by introducing rotation transformation along the normal plane of the arc.

Ad hoc nature of the current version leads to increased design iteration if one attempt to repeat the fitting process. Feedbacks from testers are appreciated to improve the function and further generalize the rule. Neutral positioning and rotation of hand is measured to determine the origin of each column arcs.

Note on some of the observations made during the design iteration on each columns.

* Column 0: (Ternary Index) though feasible, difficult to press and infrequently used key set not recommended (see Prototype 1) R0 is somewhat acceessible, if you must.
* Column 1: (Secondary Index) Roll Rotation of 8°,  R2+ press needs to be improved. remap to inner arc or implement knocker.
* Column 2: (Primary Index) not rolled. There is natural Yaw of ~12°, but in order to accommodate C0 & C1 it is ignored.
* Column 3: (Middle) 7° roll. ideally more buckling is desirable, but will collide with C2. Use of thinner profiled switches is something to consider.  
* Column 4: (Ring) 12° switch roll with additional 4° path roll.
* Column 5: (Pinky) neutral position has great enough yaw to split the column from the rest, as observed in top view.
Compact column was tested, but results required continual effort to keep finger on column, countering the intention of the design.
* Column 6: (Secondary Pinky) R0 and R1 is good candidate for shift and mod coming from a traditional keyboard. It's an attractive option if you wish to support such tradition rather than using the thumb cluster.

#### Thumb Cluster Design

During the iterative loop of columner design, I've tried to create basis for thumb cluster and early design for palm rests. Most natural thumb flexion seem to collide with index path, therefore I've initially built an arbitrary packed clusters (minor modification of ergodox thumb clusters) and attempted to find a working orientation for such cluster. One of my poor attempts seen below.
![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/Dummy1BackView.jpg "")
Even earlier design considered placing keys under the columnar plate… Obviously these design process does not give one any comparable result, no reasoning behind the iteration and leads you into frivolous attempts and results.  

Obviously, the solution was to model my thumb and key placement function to experiment with natural angle and motion of the thumb.
  I've come with the following List

  |Switch ID| Index Color| Type of Actuation| Press Surface| Distal| Proximal|	Meta Abduction| Meta Apposition|
  |:-------:|:-----------:|:-----------------:|:-------------:|:------:|:--------:|:--------------:|:--------------:|
	|T0| Blue| proximal abduction| distal Face| slightly abducted| neutral | neutral| abducted|
	|T1| Green|	apposition|	proximal Face| adducted| neutral | neutral| abducted|  
	|T2| Red|proximal abduction|	distal Face| slightly abducted| neutral | neutral| neutral|
	|T3| Olive| apposition|	proximal Face| adducted| neutral | neutral| neutral|
	|T4| Pink| extension | distal tip| adducted| slightly adducted | neutral| neutral|
	|T5| Khaki|	apposition|	distal Side| adducted| abducted | abducted| slight adducted|
	|T6| Yellow|apposition|	distal Side| adducted| abducted | abducted| slight adducted|
	|T7| White| apposition|	distal Side| adducted| abducted | abducted| slight adducted|
	|T8| Grey| apposition|	distal Side| adducted| abducted | abducted| slight adducted|
![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/ThumbExampl.png "")

### Tracking Device

#### Trackpoint
Prototype 1 used T4 position as Trackpoint. Though not fully tested the design is not stiff enough and require some modification
![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/ThumbTrackPoint.png "")

#### Trackpoint (Switch integration)
make an adapter for MX key stubs to trackpoint stub. need to test keycap instability and trackpoint response is tolerable. This will move architecture away from Mitosis.

#### Trackball (not in dev at this point)
Attempted hacking M570 and strapping it on the device. unable to find orientation that will work with the current implementation of palm rest/battery casing unless sacrificing portion of thumb cluster.

### Alternate Layout
Warpman:
The buckled bottom row changes the effort map:
A valid excuse to make my own layout.
![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/EffortMap.png "")
Also vertical flow especially transition to R0 is fast, thus Workman layout philosophy jived well on initial trial. Furthermore mitosis default layer imitating maltron layout game me the starting point. As a personal preference emphasis on rolling and same hand typing were also considered.

Version 1.0

![alt text](https://raw.githubusercontent.com/seudoku/Warped-keyboard/Photo/WarpmanLayout.png "")

## _Under Construction_

### Palm Rest
### Observation
### Build Guide
