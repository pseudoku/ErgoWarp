# Ergo-Warped
Design Log and Code Repo for Customizable Split Keyboard

![Prototype Ver 6](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Proto6.jpg)

## _Under Construction_
## Index
 * Design Goal
 * Todo
 * Design
  * Finger Placement
  * Thumb Cluster
  * Tracking Device
 * Alternate Layout
 * How to Generate
   * _Clojure based build?_

## Design Goal:
* Customizable Parametric Function
* Minimize finger movement
* Dense and Comfortable Thumb Cluster
* Adjustable tenting
* Tracking device
  * _in progress_
* Alternate Layout

## Todo (11/06/2018)
* Test Trackpoint Module
* Generalize the Path function
* Clean up code

## Design
### Finger Placement
![Prototype2](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/)

Simplification of finger flexion:
 Define two arcs: inner (distal and intermediate flexion) and outer(distal, intermediate, proximal flexion) with metacarpal phalangeal joint as the origin. They simulate trigger motion and grab motion respectively and it is assumed that optimal placement of key switches will reside somewhere between two functions.  

	a. Define R0 as a natural trigger, orientated tangential to the inner arc at θ=~ 90°  to simulate full adbuction
	b. Define R2 as a natural tap, orientated normal to the outer arc at θ= ~60°
	c. Define R1 as a neutral position (a combination of the former two)
		i.  Define secondary origin, an intermediate joint of a finer.
    ii. An angle bisected by vectors pointing to the secondary origin R0 and R2 position.
		iii. Intersection of such vector to the outer path orientated normal to the path.

TODO add description on roll

Note on some of the observations made during the design iteration on each columns.

* Column 0: (Ternary Index) though feasible, difficult to press and infrequently used key set not recommended (see Prototype 1) R0 is somewhat acceessible, if you must.
* Column 1: (Secondary Index) Rolled by 20°, at this angle R0 caps(DSA) must be clipped.
* Column 2: (Primary Index) not rolled, though ideally 15° is desirable, but it would collide with C3. There is also natural yaw of ~12°, but in order to accommodate C0 & C1 it is ignored.
* Column 3: (Middle) 9° roll. ideally more is desirable, but again will collide with C2 and C4.   
* Column 4: (Ring) 12° switch roll.
* Column 5: (Pinky) neutral position has great enough yaw ~42° to split the column from the rest, as observed in top view.
Compact column was tested, but results required continual effort to keep finger on column.
* Column 6: (Secondary Pinky) R0 and R1 is good candidate. It's an attractive option if you wish to support such tradition rather than using the thumb cluster.

### Thumb Cluster Design
Initial attempts sought to pack as many switches near the ideal thumb motion without considering column orientation. while accessible they did not produce efficient press and produced strain because thumb position was restricted to this 'ideal' position.
![](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/asht.jpg)

* design that allowed comfortable press even if wrist position and orientation deviates. should not constrict wrist motion and placement
* simple and compact motion to actuate is desirable. Avoid long abducted position which produce excessive motion especially given C1 collision.
* do not overburden thumb with keys.
* enforcing thumb tip to press is unnecessarily restriction. use proxiamal phalagenes.
* if possible make chording easy.

These design restrictions and compromises resulted in 4 key design. while I would've liked 5 keys and attempted numerous times, they produced awkward press or restricted wrist position. Palm press broke 1st rule. down shifted C0 or C1 key produced awkward keypress. any button on C2 and on produced restraint on wrist position.

![Initial Mock UP ](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Dummy1BackView.jpg)

![Proto  1](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Proto1FrontView.jpg)

![Proto 2](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Proto2FrontView.jpg)

## Tracking Device
* Trackpoint
Prototype 1 used T4 position as Trackpoint. Though not fully tested the design is not stiff enough and require some modification
![TrackPoint](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/ThumbTrackPoint.png)

* Trackpoint with Switch integration
An adapter for MX key stubs to trackpoint stub. compounding with navigation layer was attractive. Tried with prototypes 4 and 5. produced mushy feel and noise.

* Trackball (not in dev at this point)
hacking and modding M570 maybe feasible, but will reduce portability and further reduce thumb cluster.  

Moving to nRF51882 platform made one unit solution difficult. Next attempt is module unit with it's own batterie and MCU. (work in progress)

## Alternate Layout
Warpman:
The buckled bottom row changes the effort map:
![Layout Effort](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/EffortMap.png)

A valid excuse to make my own layout.
vertical transition, especially to R0 is fast, thus Workman layout philosophy jived well on initial trial. Furthermore, mitosis default layer imitating maltron layout gave me the starting point for the thumb cluster. As a personal preference, emphasis on rolling and same hand typing were also considered.

![Layout warpman](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/WarpmanLayout.jpg)

### Build Guide
Are you serious?  
