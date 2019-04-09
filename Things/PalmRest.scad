//Palm rest 
use <sweep.scad>
use <scad-utils/transformations.scad>
use <scad-utils/morphology.scad> //for cheaper minwoski 
use <scad-utils/lists.scad>
use <scad-utils/shapes.scad>
use <scad-utils/trajectory.scad>
use <scad-utils/trajectory_path.scad>
use <skin.scad>  

//--- parametrization of hand model
$fn = 48;
step = 5;
dMount = 5.1054; // mounting bore size
dMountMM = 5;
dBall    = 18; //for ball mount  

len_ind   = 68; 
len_mid   = 88; //from mid knuckle to base of wrist 
wid_pin   = 23;
len_wrist = len_mid + 12; // from mid knuckle to base of wrist band
len_thumb = len_mid - 0;
hei_thumb = 4;

ang_pin   = [5,10,10];
ang_ring  = [0,12,20];
ang_thumb = [-15,-65,0];
ang_ind   = [70,-75,0];

//--- shorthard transform to blob center
module origin_pinkie() {translate([wid_pin,0,-len_mid])rotate(ang_pin)rotate([0,90,30])translate([-16,5,-10])children();}
module origin_ring() {
  translate([wid_pin,0,-len_mid])rotate(ang_ring)translate([0,30,33])rotate(ang_ind)translate([10,30,12])children();
  }
module origin_thumb() {translate([0,hei_thumb,-len_thumb])rotate(ang_thumb)translate([0,-6,35])children();}
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
function ellipse2(a1, b1, a2, b2, d1 = 0, d2 = 0 ) = [for (t = [0:step:360]) t>180 ? [a1*cos(t), b1*sin(t)*(1+d1*cos(t))] : [a2*cos(t), b2*sin(t)*(1+d2*cos(t))] ]; //shape to 
  
function ellipse3(a1, b1, a2, b2, d1 = 0, d2 = 0 ) = [for (t = [0:step:360]) (t>90 && t<270) ? [a1*cos(t), b1*sin(t)*(1+d1*cos(t))] : [a2*cos(t), b2*sin(t)*(1+d2*cos(t))] ]; //shape to 
  
// sweep generators 
// pinkie palm ring 
module pinkie_ring() {
  a = 26;
  b = 18; 
  c = 15;
  function shape() = ellipse(1.5, 4);
  function shape2() = // ellipse(1.5, 10);
    ellipse3(
    a1 = 1.5,
    b1 = 4,
    a2 = 3, 
    b2 = 4, 
    d1 = 0, 
    d2 = 0);
  
  path_transforms =  [for (t=[0:step:180])   translation(oval_path3(t,40,a,b,c,0,1,-0.1))*rotation([90,-90+10*sin(t/2),t])];
  path_transforms2 = [for (t=[180:step:270]) translation(oval_path3(t,40,a,b,c,15,1,-.1))*rotation([90,-80-30*sin(t),t])];  
  path_transforms3 = [for (t=[270:step:360]) translation(oval_path3(t,40,a,b,c,15,1,-.1))*rotation([90,-90-40*sin(t),t])];  
      
  origin_pinkie()sweep(shape2(), path_transforms);
  origin_pinkie()sweep(shape2(), path_transforms2);
  origin_pinkie()sweep(shape2(), path_transforms3);
}

module thumb_ring() {
  function shape()  = ellipse(4, 2);
  function shape2() = // ellipse(1.5, 10);
    ellipse2(
    a1 = 4,
    b1 = 3,
    a2 = 4, 
    b2 = 2, 
    d1 = 0, 
    d2 = 0);

//  path_transforms =   [for (t=[0:step:185]) translation(oval_path2(t,0,21,10,24,0,1,0))*rotation([90,20*sin(t),t])]; 
  path_transforms  =  [for (t=[  0:step:180]) translation(oval_path3(t,-40,26,22,24,30,1,-0))*rotation([90,0-50*sin(t),t])]; 
  path_transforms2 =  [for (t=[180:step:360]) translation(oval_path2(t,-40,26,21,24,0,1,.2))*rotation([90,20*sin(t),t])];  
  path_transforms3 =  [for (t=[  0:step:180]) translation(oval_path3(t,-40,26,28.5,24,45,1,.2))*rotation([90,0-50*sin(t),t])];  
  
//  origin_thumb()rotate([110,90,0])translate([0,42,0])rotate([90,0,180])sweep(shape2(), path_transforms);
  origin_thumb()rotate([80,90,0])sweep(shape(), path_transforms);// lipped
  origin_thumb()rotate([80,90,0])sweep(shape2(), path_transforms2);// front 
  origin_thumb()rotate([80,90,0])sweep(shape2(), path_transforms3);// Support

}

module palm_track() {
  a = 20;
  b = 20; 
  c = 20;
  //Ellipsoid([20*2,25*2,60],[30*2,25*2,60], center = true);
  function shape() = ellipse(4, 4);
  path_transforms =  [for (t=[0:step:180]) translation(oval_path3(t,20,a,c,b,30,1,0))*rotation([90,-20-20*sin(t),t])]; 
  path_transforms2 =  [for (t=[0:step:180]) translation(oval_path3(t,70,b,a,c,-10,1,0))*rotation([90,-70+5*sin(t),t])];  
//  path_transforms3 =  [for (t=[0:step:360]) translation(oval_path3(t,-5,a,c,b,-15,1,0))*rotation([90,20+15*cos(t),t])];   
  path_transforms3 =  [for (t=[0:step:180]) translation(oval_path3(t,-20,a,c,b,-30,1,0))*rotation([90,20+20*sin(t),t])];   
  path_transforms4 =  [for (t=[0:step:360]) translation(oval_path3(t,10,a,c,b,0,1,0))*rotation([90,-20+sin(t),t])];   
  rotate([-90,0,0])sweep(shape(), path_transforms);
  rotate([90,0,-90])sweep(shape(), path_transforms2);
  rotate([90,0,90])sweep(shape(), path_transforms2);
  rotate([-90,0,0])sweep(shape(), path_transforms3); 
//  rotate([0,0,0])sweep(shape(), path_transforms4); 
}

module pinkie_joint() {
  function shape() = ellipse(1.5, 4);
  path_transforms =  [for (t=[70:step:145])   translation(oval_path3(t,40,28,18,15,0,1,-0.1))*rotation([90,-90+25*sin(t/2),t])];  
      
  origin_pinkie()sweep(shape(), path_transforms);
} 

// Palm Section
steps  = 100; 
Length = 90;
radius = 64; 
theta  = 61; 
theta0 = 20;
function arcPath(dist) =  0.11858892889724*dist+-0.00950842013031634*pow(dist,2)+0.00050907432957908*pow(dist,3)+-3.04498262564168E-06*pow(dist,4)+-6.98665888934242E-08*pow(dist,5)+6.31588918303338E-10*pow(dist,6)+-0.00519577930333526;

function arcScale(dist) = (0.0312718203578395*dist+-0.00324416785860623*pow(dist,2)+0.000178485812677843*pow(dist,3)+-3.73935353737613E-06*pow(dist,4)+3.39032119124653E-08*pow(dist,5)+-1.14731790495239E-10*pow(dist,6)+1.00309198846833)*10;

function arcA(x) = 0.466157140933998*x+-0.0305388845787073*pow(x,2)+0.00217295863467009*pow(x,3)+-6.21175274075925E-05*pow(x,4)+7.44922151927002E-07*pow(x,5)+-3.17841492050627E-09*pow(x,6)+13.8451591429169;

function arcLength(phi) =  radius*(90-phi)/180*PI;

function translateEllipse(x) = [
    radius*sin(x),  //height
    arcPath(arcLength(x)),
    1.3*radius*cos(x) 
];

function scaleEllipse(x) =[
    arcScale(arcLength(x)),
    1,
    1
];

//path2 = [for (t=[19:20]) translation(translateEllipse(t))*rotation([90+t,0,90])*scaling(scaleEllipse(t))];
//path3 = [for (t=[0:theta/steps:theta]) translation(translateEllipse(t))*rotation([90+t,0,90])*scaling(scaleEllipse(t))];
//clip = [for (i=[0:len(path3)-1]) transform(path3[i], ellipse(1, 5, d = .1))];   // skin for main palm structure 
//clip2 = [for (i=[0:len(path2)-1]) transform(path2[i], ellipse(1, 5, d = .1))];  // skin for hulling with pinkie ring

path4 = [for (t=[theta0:theta/steps:theta]) translation(translateEllipse(t))*rotation([90+t,0,90])];
path5 = [for (t=[theta0:theta/steps:theta0+theta/steps]) translation(translateEllipse(t))*rotation([90+t,0,90])];
  
clip3 = [for (i=[0:len(path4)-1]) transform(path4[i], 
  ellipse2(
    a1 = arcA(arcLength(i*theta/steps+theta0)), 
    b1 = 8-6*sin(i*theta/steps),
    a2 = arcA(arcLength(i*theta/steps+theta0)), 
    b2 = 5+4*sin(i*theta/steps), 
    d1 = -.3, 
    d2 = -.4)
)];   // skin for main palm structure 
clip4 = [for (i=[0:len(path5)-1]) transform(path5[i], 
   ellipse2(
    a1 = arcA(arcLength(i*theta/steps+theta0)), 
    b1 = 8-6*sin(i*theta/steps),
    a2 = arcA(arcLength(i*theta/steps+theta0)), 
    b2 = 5+4*sin(i*theta/steps), 
    d1 = -.3, 
    d2 = -.4)
)];   // skin for main palm structure  // skin for main palm structure 

MountTran = [-18,-6,-7];
//Palm Rest Build
difference(){
  union(){
//    #translate([-7,-23,65])rotate([0,40,0])cylinder(d1 = 16.5, d2 = 17, 8, center = true);
    translate([-60,-5,24])rotate([0,-90,165])skin(clip3);
      
    translate([-0,-10,51])rotate([0,40,-10]){ // mounts
      translate([-22,-5,8])rotate([0,0,0]) cylinder(d= 10, 7, $fn = 64, center = true); 
      translate([12,-25,3])rotate([0,0,0]) cylinder(d= 10, 10, $fn = 64, center = true); 
    } 
//      hull(){
//        translate(MountTran)rotate([0,90,0]) cylinder(d= dBall-5, 5, $fn = 64, center = true); // Ball Moun
//        translate([-18,-6,6.5])rotate([0,90,0]) cube([dBall-10,dBall-4,5], center = true); //Mount
//      }
//      translate(MountTran)rotate([0,90,0]) cylinder(d= 8, 10, $fn = 64, center = true); // Ball Moun
      
//      hull(){
//        translate([6,-20,-0])rotate([0,0,0]) cylinder(d= 10, 12, $fn = 64, center = true); // Ball Mount
////        translate([6,-20,4])rotate([0,90,0])  cube([5,dBall,5], center = true); //Mount
//      } 
    hull(){
      translate([-60,-5,24])rotate([0,-90,165])skin(clip4); 
      translate([10,20,65])rotate([0,0,0])rotate([-90,40,0])pinkie_joint();
    }
  }
//  #translate([-8,-23,63])rotate([0,40,0])cylinder(d = dMount, 15, center = true);
  translate([10,20,65])rotate([0,0,0])rotate([-90,40,0])translate([0,hei_thumb,-len_thumb])rotate(ang_thumb)ovalEllipsoid([43*2,35*2,53],[40*2,35*2,53], center = false); //thumb blob
  
    translate([-0,-10,51])rotate([0,40,-10]) {
      translate([-22,-5,0])rotate([0,0,0])cylinder(d= 5, 20, $fn = 64, center = true);
      translate([12,-25,-5])rotate([0,0,0])cylinder(d= 5, 20, $fn = 64, center = true); 
    }
//// # translate([10,20,65])rotate([0,0,0])rotate([-90,40,0])origin_ring()translate([3,5,5])sphere(d= 40.5, $fn = 64); // trackbaaaaaall?
// translate([-0,-25,52])rotate([0,40,-30]){
//  sphere(d= dBall, $fn = 64); // Ball Mount
//  translate([ 18, 0,0])cylinder(d= 4, 15, $fn = 64, center = true); // Ball Mount
//  translate([-18,-0,0])cylinder(d= 4, 20, $fn = 64, center = true); // Ball Mount
//  } 
}

//Main
translate([10,20,65])rotate([0,0,0])rotate([-90,40,0])
{
 color("gold")thumb_ring();
 color("gold")pinkie_ring();
//  %blob();  
//  origin_ring()translate([3,5,5])trackball();
//  origin_ring()translate([0,5,5])sphere(d= 40.5, $fn = 32); 
}

//#translate([-60,-5,24])rotate([0,-90,165])skin(clip3); 
//////////////////////////// trash code 
//generate oval blob to estimate hand structure 
module ovalEllipsoid(quad1= [0,0,0], quad2= [0,0,0], quad3 = [0,0,0], quad4= [0,0,0], center = true) {
  trans = center ==true ? [0,0,0] : [quad1[0]/2,0,0];
  
  rotate([0,-90,0])translate(trans){
    scale(quad1)difference(){
      sphere(d =1, $fn = 48);
      translate([.00001,-1/2,-1/2])cube(1);
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
  translate([0,hei_thumb,-len_thumb])rotate(ang_thumb)ovalEllipsoid([43*2,30*2,53],[40*2,30*2,53], center = false); //thumb blob
// translate([wid_pin,0,-len_mid])rotate(ang_pin)translate([0,18,34])rotate(ang_ind)translate([10,30,-5])ovalEllipsoid([0,0,0],[55*2,40*2,70], center = true); // palm blob
  translate([wid_pin,0,-len_mid])rotate(ang_ring)translate([0,30,30])rotate(ang_ind)translate([10,25,20])ovalEllipsoid([20*2,25*2,60],[30*2,25*2,60], center = true); // ring fingers blob
}
 
module Mount() {
  difference(){
    union(){
      translate([-0,-10,51])rotate([0,40,-10]){ // mounts
        translate([-22,-5,8])rotate([0,0,0]) cylinder(d= 10, 7, $fn = 64, center = true); 
        translate([12,-25,3])rotate([0,0,0]) cylinder(d= 10, 10, $fn = 64, center = true); 
      } 
    }
    //CUTS
    translate([-0,-10,51])rotate([0,40,-10]) {
      translate([-22,-5,0])rotate([0,0,0])cylinder(d= 5, 20, $fn = 64, center = true);
      translate([12,-25,-5])rotate([0,0,0])cylinder(d= 5, 10, $fn = 64, center = true); 
    }
  }
}
//Mount();
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

module trackball() {
  {
    difference(){
      palm_track();
      sphere(d= 40.5, $fn = 64); 
    }
    difference(){
      rotate([-45,0,-90])translate([0,0,-42.5/2])cube([30,16,2],center=true);
      rotate([-45,0,-90])translate([0,0,-42.5/2])cylinder(d= 14,10,center=true);
    }
    rotate([-45,0,-90])translate([0,0,-42/2-3.5])cube([52,17,1],center=true); // PCB
//        rotate([-45,0,-90])translate([45/2-17.25,0,-42.5/2+1.5-5.8/2])cube([1,5.5,5.8], center = true); //prism edge
  }  
}