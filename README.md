# Ergo-Warped
When you require that extra curvature.
![Prototype Ver 6](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Proto6.jpg)

## Index
 * Design Goal
 * Todo
 * Designs
  * Finger Placement
  * Thumb Cluster
  * Tracking Device
 * Warpman a layout to consider
 * Unholy Acts

## Design Goal:
* Parametric design
* Minimize finger movement
* Attain optimal thumb cluster position
* Adjustable tenting
* Tracking device  _in progress_
* Adjustable palm rest
* Alternate Layout

## Todo (12/XX/2019)
* Test Trackpoint Module
* Generalize the Path function (volunteers?)

## Design
### Finger Placement
![Prototype 7 Mockup](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Proto7.jpg)

Reconsidering the arcs and finger flexion:
 Define two arcs: inner (distal and intermediate flexion) and outer(distal, intermediate, proximal flexion) with metacarpal phalangeal joint as the origin. They simulate trigger motion and grab motion respectively and it is assumed that optimal placement of key switches will reside somewhere between two functions.

* Define R0 as a natural trigger, orientated tangential to the inner arc at θ=~ 90°  to simulate full adbuction
* Define R2 as a natural tap, orientated normal to the outer arc at θ= ~60°
* Define R1 as a neutral position (a combination of the former two)
 * Define secondary origin, an intermediate joint of a finer.
 * An angle bisected by vectors pointing to the secondary origin R0 and R2 position.
 * Intersection of such vector to the outer path orientated normal to the path.
Given my hand size, R2 must be compromised in order to make R3 and on work properly, which counters the design. Refer older commits for your amusement.

These placement and orientation minimizes the finger travel and simplify presses away from home rows into singular motion. This takes care of the translation, but not orientation completely. There is a natural buckling in finger tips motion and they do not move in plane with metacarpal tangential plane. This is addressed by introducing a columnar roll angle and separately from the arc's orientation at origin.  

Note on some of the observations made during the design iteration on each columns with heavy curvature.

* Column 0: (Ternary Index) though feasible, difficult to press and infrequently used key set not recommended (see Prototype 1) R0 is somewhat accessible, if you must.
* Column 1: (Secondary Index) Rolled by 20°, at this angle R0 caps(DSA) must be clipped.
* Column 2: (Primary Index) Rolled by 5°, though ideally 15° is desirable, but this would cause collision with C3. There is also natural yaw of ~12°, but in order to accommodate C0 & C1 it is ignored.
* Column 3: (Middle) 9° roll. ideally more is desirable, but again will collide with C2 and C4.   
* Column 4: (Ring) 12° switch roll. yawed by 10°
* Column 5: (Pinky) neutral position has great enough yaw ~42° to split the column from the rest, as observed in top view.
Compact column was tested, but results required continual effort to keep finger on column.
* Column 6: (Secondary Pinky) R0 and R1 is good candidate. It's an attractive option if you wish to support such tradition rather than using the thumb cluster.
Note: these are my thoughts on non-clipped boards from old protos.

###Cutting Corners: Clipping Switches and Keycaps
Okham hath spake. entia non sunt multiplicanda praeter necessitatem. "LED compartment is useless and wasted space." and I will follow his adage.

As noted above, C0, C1, and C6 is a reach for my stubby finger and something had to give.
Perhaps out of frustration, Something transpired in me to amputate switches and the result was Amazing! ~~(it will wobble unless glued, it will not seat properly on a plate requiring a PCB, but that's no problem)~~
![I dare you to do this on a holy panda.](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Clipped1.jpg)
![Now Kisssssssss!](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Clippedl2.jpg)
now let's revisit
* Column 0: Applied vertically clipped. More plausible for R1 and R2
* Column 1: Applied vertically. Removed R0 to improve thumb cluster position.  
* Column 2: Applied vertically.
* Column 5: Applied to R1 to bring R2 closer to optimal location.
* Column 6: Applied vertically.

placing horizontally clipped and compact R2 and R3 were attempted, but typo became more prominent.

### Thumb Cluster Design
Initial attempts sought to pack as many switches near the ideal thumb motion without considering column orientation.
![](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/asht.jpg)
They were comfortable by themselves, but collision with index columns deviated the placement too greatly from optimal and render them useless at best. This threw the next design iterations into spiral of bad compromises, which was fruitless.

This changed with clipped columns. Index columns were compact enough that sacrificing C1R0 will result in optimal thumb position.    



## Tracking Device
* Trackpoint
Prototype 1 used T4 position as Trackpoint. Though not fully tested the design is not stiff enough and require some modification
![TrackPoint](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/ThumbTrackPoint.png)

* Trackpoint with Switch integration
An adapter for MX key stubs to trackpoint stub. compounding with navigation layer was attractive. Tried with prototypes 4 and 5. produced mushy feel and noise.
![Proto 5](https://raw.githubusercontent.com/pseudoku/Warped-keyboard/master/Photo/Proto5.jpg)

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


## version history

working proto ver 1.
  6x4 8 thumb cluster. plate and backplate design with static tenting. Single hand build to get use to QMK and type testing. Key placement were not bad
working proto ver 2.
  5x4 9 thumb cluster. plate only with wooden palm rest. Added roll angles to improve approach angle. Thumb cluster where designed at optimal flexions, but due to collision with index column it was move proximal, which proved to be disastrous. ternary index column was removed as it was a stretch to push and was there to provide structure to unimplemented trackpoint module.  
working proto ver 3.
  6x3 6 thumb cluster. Tried to build with low profile switches to improve thumb cluster placement. In retrospect I should avoided drastic change to thumb design and worked on placement, but I attempted to reduce travel distance by implementing cluster that ended up looking akin to DataHand. Added secondary pinkie column to compensate key counts. Removed R1 rows as extension required to actuate a switch was strenuous. shattered to pieces prior to being fully tested.
working proto ver 4.
  I don't want to talk about it.
working proto ver 5.  
  5x3 6 thumb cluster. Flat keycap profile increased travel distance on R4, R2 and clusters. Attempted printing custom keycap, but material was too fragile for choc style legs. Further exaggerated thumb cluster, which only aggravated my distaste for short keypress of low profile.
working proto ver 6.
  6x3 5 thumb cluster. Moved back to full switches. Integrated palm/wrist rest. Implemented some palm switches half-heartedly as my thirst for navigation cluster grew.

proto ver 7. <- we are here
  6x3? n thumb cluster. unapologetically warped. Implemented clipped switches. with compact inner index R4 and removed outer index R4. Thumb cluster is retuned.
