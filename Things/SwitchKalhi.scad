plate_thickness = 1;
plate_size = 15.6;
edge_offset = 1;
bottom_size = plate_size - 2;

top_height = 11.6;

switch_height = 3.6;
switch_thick = 1;
switch_width = 5;
switch_length = 3;

cap_height = .38*25.4;
cap_heightShift = 10;
cap_width = 18.3;
cap_h = 7.5;

module SwitchLow(colors = "teal") 
{
  translate([0,0,1.75]){
    difference(){
      translate([0,0,0.5])cube([15,15,1], center = true);
      //cuts
  //    translate([15/2-1/2,0,.5])cube([1,10.5,2], center = true);
  //    translate([-15/2+1/2,0,.5])cube([1,10.5,2], center = true);
    }

    translate([0,0,1.5])cube([13,13,2], center = true);
    color("springGreen")translate([0,0,4])cube([11.4,4,3], center = true);
    color("springGreen")translate([0,1,4])cube([3,5,3], center = true);
    color("DarkSlateGray")translate([0,0,-1])cube([13,14,2,],center = true);
    color("DarkSlateGray")translate([0,0,-2-2.5])cylinder(d=3.3, 2.5);
    color("DarkSlateGray")translate([5,0,-2-2.5])cylinder(d=1.6, 2.5); 
    color("DarkSlateGray")translate([-5,0,-2-2.5])cylinder(d=1.6, 2.5); 

    //cap
    color("ivory")hull(){
      translate([0,0,4.5+1])cube([17.5,16.8,2],center = true);
      translate([0,1.25,4.5+1+1.5])cube([14.5,12.5,1.5],center = true);
    }
  }
}

module Cutter()
{
  bottom_height = 4.5;
  bottom_chamfer_width = 3;
  bottom_chamfer_height =  1;
  bottom_chamfer_thickness = .6;

  bottom_peg_diameter = 4;
  bottom_peg_height =  3;
  bottom_peg_chamfer = 1;
  bottom_peg_side_scale = 1.7/4;
  
  translate([-bottom_size/2, -bottom_size/2 ,0])cube([bottom_size,bottom_size,bottom_height]);

  translate([0,0, -(bottom_peg_height -bottom_peg_chamfer)]){
    cylinder(d=bottom_peg_diameter, h= bottom_peg_height -bottom_peg_chamfer);
    translate([5,0,0])scale(v=[bottom_peg_side_scale,bottom_peg_side_scale,1])cylinder(d=bottom_peg_diameter, h= bottom_peg_height -bottom_peg_chamfer);
    translate([-5,0,0])scale(v=[bottom_peg_side_scale,bottom_peg_side_scale,1])cylinder(d=bottom_peg_diameter, h= bottom_peg_height -bottom_peg_chamfer);
    
    translate([0,0, -bottom_peg_chamfer]){
      cylinder(d2=bottom_peg_diameter , d1 = bottom_peg_diameter -2*bottom_peg_chamfer, h= bottom_peg_chamfer);
      translate([5,0,0])scale(v=[bottom_peg_side_scale,bottom_peg_side_scale,1])cylinder(d2=bottom_peg_diameter , d1 = bottom_peg_diameter -2*bottom_peg_chamfer, h= bottom_peg_chamfer);
      translate([-5,0,0])scale(v=[bottom_peg_side_scale,bottom_peg_side_scale,1])cylinder(d2=bottom_peg_diameter , d1 = bottom_peg_diameter -2*bottom_peg_chamfer, h= bottom_peg_chamfer);
    }
  }
}


module Keyhole(tol = .1, cutThickness = 3){
  $fn = 40;
  bottom_length = 13.9+tol;
  plate_thickness = 1; //mm
  holeLength = bottom_length;
  //latch nibs
  nib_radius= .5;
  nib_length = 11; 

  translate([0,0,1.25])cube([holeLength, holeLength, plate_thickness+tol], center =true);
  translate([0,0,.25-cutThickness/2])cube([holeLength+1, holeLength+1, plate_thickness+cutThickness], center =true);  
}

module TrackToKahli(tol = 0){
  ad_height = 7;
  difference(){
    translate([-7,-3,0])cube([14,6,ad_height]);
    #translate([0,0,0])cylinder(d=3.3, 2.5, $fn=60);
    translate([5,0,0])cylinder(d=1.6, 2.5,$fn=60); 
    translate([-5,0,0])cylinder(d=1.6, 2.5,$fn=60); 
    #translate([-2.5/2,-2.5/2,ad_height -2.2])cube([2.5,2.5,2.2]);
    }
}

//TrackToKahli();
//translate([0,0,0])SwitchLow();
Keyhole(.1);


module TrackPoint(nibLength = 20){
  color("silver")translate([0,28.5/2-6,-1/2])cube([26.46, 28.5, 1], center = true);
  color("red")translate([0,0,2.5/2])cube([2.5,2.5,2.5], center= true); //nib
  //    color("gold")cylinder(d = 2, nibLength); //nib
  //    color("gold")translate([0,0,nibLength])sphere(2); //nib

}
//Switch([1,1.5,1]);
//Stabilizer();
//TrackPoint();

































