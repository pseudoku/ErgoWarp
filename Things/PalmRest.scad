//Palm rest 
use <sweep.scad>
use <scad-utils/transformations.scad>
//define origin as index knuckle palm side.
// y axis lies along from origin to the midpoint of wrist
// there exist a oval of pinkie offset

//--- parametrization of hand model
$fn = 48;
step = 5;

len_ind   = 68; 
len_mid   = 88; //from mid knuckle to base of wrist 
wid_pin   = 23;
len_wrist = len_mid + 12; // from mid knuckle to base of wrist band
len_thumb = len_mid - 12.5;
hei_thumb = 4;

ang_pin   = [0,12,0];
ang_thumb =  [-25,-30,0];
ang_ind   =  [55,-70,0];

//--- shorthard transform to blob center
module origin_pinkie() {translate([wid_pin,0,-len_mid])rotate(ang_pin)rotate([0,90,30])translate([-30,0,0])children();}
module origin_ring() {
  translate([wid_pin,0,-len_mid])rotate(ang_pin)translate([0,18,34])rotate(ang_ind)translate([10,25,20])children();
  }
module origin_thumb() {translate([0,hei_thumb,-len_thumb])rotate(ang_thumb)translate([0,0,35])children();}
module origin_palm(){translate([wid_pin,0,-len_mid])rotate(ang_pin)children();}

//Path function. 
  function oval_path(theta, phi, a, b, c, deform = 0) = [
   a*cos(theta)*cos(phi), //x
   c*sin(theta)*(1+deform*cos(theta)) , // 
   b*sin(phi),
  ];

  //oval path with linear angle offset 
  function oval_path2(theta, phi_init, a, b, c, d = 0, p = 1, deform = 0) = [
   a*cos(theta)*cos(phi_init), //x
   b*sin(theta)*(1+deform*cos(theta))*cos(phi_init + d * sin(theta*p)), // 
   c*sin(phi_init + d * sin(theta*p))
  ];

  //oval path with angle offset with hypersine 
  function oval_path3(theta, phi_init, a, b, c, d = 0, p = 1, deform = 0) = [
   a*cos(theta)*cos(phi_init), //x
   b*sin(theta)*(1+deform*cos(theta))*cos(phi_init + d * pow(sin(theta*p), 1)), // 
   c*sin(phi_init + d * pow(sin(theta*p), 3))
  ];

//shape functions 
function ellipse(a, b, d = 0) = [for (t = [0:step:360]) [a*cos(t), b*sin(t)*(1+d*cos(t))]]; //shape to 
  

// sweep generators 
// pinkie palm ring 
module pinkie_palm_ring() {
  function shape() = ellipse(1.5, 4);
  function shape2() = ellipse(1.5, 10);
  path_transforms =  [for (t=[0:step:180])   translation(oval_path(t,40,32,12,15,.1))*rotation([90,-65,t])];
  path_transforms2 = [for (t=[180:step:360]) translation(oval_path(t,40,32,12,15,0.1))*rotation([90,-65,t])];  
  path_transforms3 = [for (t=[90:step:120])  translation(oval_path(t,50,13,11,19,-.2))*rotation([90,-5,t])];  
      
    
  origin_pinkie()sweep(shape(), path_transforms);
  origin_pinkie()sweep(shape(), path_transforms2);
//  origin_pinkie()rotate([0,90,0])sweep(shape2(), path_transforms3);
}

// wrist ring
module wrist_ring() {
  function shape2() = ellipse(2, 7);
  path_transforms2 = [for (t=[30:step:120]) translation(oval_path(t,0,34,9,18,0))*rotation([90,0,t])];  

  translate([0,0,-len_wrist])rotate([0,0,0])sweep(shape2(), path_transforms2);
}

module palm_ring1() {
  a = 28;
  b = 25; 
  c = 28;
  //Ellipsoid([20*2,25*2,60],[30*2,25*2,60], center = true);
  function shape() = ellipse(1.5, 3);
  path_transforms =  [for (t=[0:step:90]) translation(oval_path3(t,20,a,c,b,0,1,0))*rotation([90,-20,t])]; 
  path_transforms2 =  [for (t=[0:step:180]) translation(oval_path3(t,70,b,a,c,-5,1,0))*rotation([90,-70+5*sin(t),t])];  
  path_transforms3 =  [for (t=[0:step:90]) translation(oval_path3(t,-5,a,c,b,-15,1,0))*rotation([90,20,t])];   
    
  origin_ring()rotate([90,0,0])sweep(shape(), path_transforms);
  origin_ring()rotate([0,0,90])sweep(shape(), path_transforms2);
  origin_ring()rotate([90,0,0])sweep(shape(), path_transforms3); 
}
module palm_ring2() {
  a = 28;
  b = 25; 
  c = 10;

  function shape() = ellipse(1.5, 3);
  path_transforms =  [for (t=[0:step:90]) translation(oval_path3(t,5,a,c,b,15,1,0))*rotation([90,-20+60*sin(t),t])];   
  path_transforms2 =  [for (t=[90:step:180]) translation(oval_path3(t,70,b,10,c,-70,1,0))*rotation([90,50+5*sin(t),t])]; 
//  path_transforms2 =  [for (t=[90:step:110]) translation(oval_path3(t,-5,a,20,b,-55,1,.8))*rotation([90,-20,t])*scaling([1,1+1.2*(-90/105+t/105),1])]; 
  path_transforms3 =  [for (t=[0:step:80]) translation(oval_path3(t,-20,a,50,b,-54,1,0))*rotation([90,20-50*sin(t/2),t])*scaling([1,1+t/130/2,1])];   
    
  origin_ring()rotate([-90,0,0])sweep(shape(), path_transforms);
  origin_ring()translate([0,0,0])rotate([180,0,-90])sweep(shape(), path_transforms2);
  origin_ring()rotate([-90,0,0])sweep(shape(), path_transforms3); 
}

module thumb_ring() {
  function shape()  = ellipse(2, 4);
  function shape2() = ellipse(4, 2);

//  path_transforms =   [for (t=[0:step:185]) translation(oval_path2(t,0,21,10,24,0,1,0))*rotation([90,20*sin(t),t])]; 
  path_transforms =   [for (t=[  0:step:180]) translation(oval_path3(t,-40,30,21,24,30,1,-0))*rotation([90,0-40*sin(t),t])];
  path_transforms2 =  [for (t=[180:step:360]) translation(oval_path2(t,-40,30,21,24,0,1,.2))*rotation([90,20*sin(t),t])];  
  path_transforms3 =  [for (t=[  0:step:180]) translation(oval_path3(t,-40,30,21,24,30,1,-0))*rotation([90,0-40*sin(t),t])];  
  
//  origin_thumb()rotate([110,90,0])translate([0,42,0])rotate([90,0,180])sweep(shape2(), path_transforms);
  origin_thumb()rotate([110,90,0])sweep(shape2(), path_transforms2);
  origin_thumb()rotate([110,90,0])sweep(shape2(), path_transforms3);
}

translate([10,20,65])rotate([0,0,0])rotate([-90,40,0])
{
  color("blue")palm_ring1();
  color("silver")palm_ring2();
//  color("gold")thumb_ring();
  color("gold")thumb_ring();
  color("gold")pinkie_palm_ring();
//  color("red")wrist_ring();

//  pinkie_wirst_joint();
  %blob();  
}



//////////////////////////// trash code 
//generate oval blob to estimate hand structure 
module ovalEllipsoid(quad1= [0,0,0], quad2= [0,0,0], quad3 = [0,0,0], quad4= [0,0,0], center = true) {
  trans = center ==true ? [0,0,0] : [quad1[0]/2,0,0];
  
  rotate([0,-90,0])translate(trans){
    scale(quad1)difference(){
      sphere(d =1, $fn = 48);
      translate([0,-1/2,-1/2])cube(1);
    }
    scale(quad2)difference(){
      sphere(d =1, $fn = 48);
      translate([-1,-1/2,-1/2])cube(1);
    }
  }
}

module blob() {  // mock up of hand structures 
  translate([0,0,-len_mid])cylinder(d = 1, len_mid);
  translate([wid_pin,0,-len_mid])rotate(ang_pin)ovalEllipsoid([34*2,36,21],[25*2,36,21], center = false); //pinkie blob
//  translate([0,0,-len_mid])ovalEllipsoid([21,39,59],[21,39,59], center = true); //wrist blob
  translate([0,hei_thumb,-len_thumb])rotate(ang_thumb)ovalEllipsoid([36*2,28*2,41],[30*2,28*2,41], center = false); //thumb blob
 translate([wid_pin,0,-len_mid])rotate(ang_pin)translate([0,18,34])rotate(ang_ind)translate([10,30,-5])ovalEllipsoid([0,0,0],[55*2,40*2,70], center = true); // palm blob
  translate([wid_pin,0,-len_mid])rotate(ang_pin)translate([0,18,34])rotate(ang_ind)translate([10,25,20])ovalEllipsoid([20*2,25*2,60],[30*2,25*2,60], center = true); // ring fingers blob
}


// ---------------------- Old experiment
//module thumb_ring() {
//  function shape() = ellipse(2, 7);
//  path_transforms =  [for (t=[-20:step:30]) translation(oval_path(t,7,18,28,30,0))*rotation([90,0,t])];  
//    
//  function shape2() = ellipse(4, 2);
//  path_transforms2 =  [for (t=[180:step:360]) translation(oval_path(t,-40,30,25,14,.2))*rotation([90,-30,t])];  
//  path_transforms3 =  [for (t=[0:step:180]) translation(oval_path(t,-40,30,25,16,.1))*rotation([90,-30+10*sin(t),t])];  
//  
////  origin_thumb()sweep(shape(), path_transforms);
//  origin_thumb()rotate([80,80,0])sweep(shape2(), path_transforms2);
//  origin_thumb()rotate([80,80,0])sweep(shape2(), path_transforms3);
//}


module pinkie_wirst_joint() {
  function shape() = ellipse(2, 3);
  function shape2() = ellipse(2, 7);
  
  path_transforms =  [for (t=[0:step:20]) translation(oval_path(t,40,34,9,18,.2))*rotation([90,-65,t])];  
  path_transforms2 = [for (t=[20:step:30]) translation(oval_path(t,0,34,9,18,0))*rotation([90,0,t])];  
    
  hull(){
    origin_pinkie()sweep(shape(), path_transforms);
    translate([0,0,-len_wrist])rotate([0,0,0])sweep(shape2(), path_transforms2);
  }
}


