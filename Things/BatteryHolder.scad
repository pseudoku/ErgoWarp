module Battery_holder(){

color("Grey")cube([24, 27.5,6]);
translate([-4,1.75,3-2/2])cube([4,1, 2]); // contact cathode
translate([-4,13.5,6-1])cube([4, 2,1]); // contact anode

translate([-4,6.75,6/2-3.6/2])cube([4, 1.5, 3.6]); // peg 1
translate([-4,7-2.2+1,6/2-.75])cube([4, 2.2, 1.5]); // peg 1 

translate([-4,7+14.5+.75,6/2-3.6/2])cube([4, 1.5, 3.6]); // peg 1
translate([-4,7+14.5+1,6/2-.75])cube([4, 2.2, 1.5]); // peg 1 
}

Battery_holder(); 