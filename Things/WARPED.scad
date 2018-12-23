use <Switch.scad> //modules for mx switch and key holes 
use <Keycaps.scad>
use <PalmRest.scad>
 
//TODOs
  //Add keycaps Build
    //Array calls
  //clean thumb to column hulls
  //
$fn = 10;  
//-----  Alias

R0 = 0; //bottom row
R1 = 1;
R2 = 2;
R3 = 3;
R4 = 4;
R5 = 5;

C0 = 0; //Column
C1 = 1;
C2 = 2;
C3 = 3;
C4 = 4;
C5 = 5;
C6 = 6;
T0 = 7; //Thumb

IN     = 0; //inner path 
OUT    = 1; //outter path
PATH   = 0; //path function 
NORMAL = 1; //path normal

//Modulation Reference
FRONT  =  1;
RIGHT  = -1;
BACK   = -1;
LEFT   =  1; 
TOP    =  1;
BOTTOM = -1;

//------   physical parameters
Tol            = 0.001;  // tolance
HullThickness  = 0.0001; // modulation hull thickness
TopHeight      = 0;      // Reference Origin of the keyswitch 
BottomHeight   = 3.6;    // height adjustment used for R0 keys for cherry types

SwitchWidth    = 15.6;   // switch width 
PlateOffsets   = 2.5;    // additional pading on width of plates
PlateOffsetsY  = 2.5;    // additional padding on lenght of plates
PlateThickness = 3.5;    // switch plate thickness  H_1st
PlateDimension = [SwitchWidth+PlateOffsets, SwitchWidth+PlateOffsetsY, PlateThickness];
PlateHeight    = 6.6;    //
SwitchBottom   = 4.8;    // from plate 

WebThickness   = 2;      // inter column hull inward offsets, 0 thickness results in poor plate thickness
dMount         = 5.1054; // mounting bore size
dChamfer       = 6;      // chamfer diameter
  
//-------  finger parametes and rule
FingerLength = [ //proxial, intermediate, distal carpal length in mm
                [26.5,  0,  0], //index 1
                [26.5,  0,  0], //index 2
                [26.5,  0,  0], //index 3
                [26.6,  0,  0], //Middle
                [22.5,  0,  0], //Ring
                [19.4,  0,  0], //pinky
                [19.4,  0,  0], //pinky
                [  52, 35, 25]  //thumb
               ];

//structure to hold column origin transformation
ColumnOrigin = [//[translation vec] [rotation vec1] [rotation vec2]
                [[  -49,  42,  11], [0, 0,   0], [ 0, 90,  0]], //INDEX 1 knuckle
                [[  -33,  40,   4], [0, 0,   0], [ 0, 90,  0]], //INDEX 2 knuckle
                [[-19.5,  41,   3], [0, 0,   0], [ 0, 90,  0]], //INDEX 3 knuckle
                [[    0,  36,   0], [0, 0,   0], [ 0, 90,  0]], //MIDDLE knuckle
                [[   20,  37,  -7], [0, 0, -10], [ 0, 90,  0]], //RING knuckle
                [[ 43.5,  24,  -5], [0, 0, -42], [ 0, 90,  9]], //PINKY 1 knuckle
                [[ 57.5,10.5,-7.5], [0, 0, -43], [ 0, 90,  9]], //PINKY 2 knuckle
                [[   -5, -72,  14], [0, 0,   0], [90,  0,  0]]  //Thumb wrist origin
               ];

// structure to pass to thumbplacement module
ThumbPosition = 
 [//[[thetaDist, thetaMed, thetaProx, phiProx][rotation angle][rotation angle2][translation vec], clipLen, clip orientation]
    [[15, 30, 31,   0], [ 0, -90, 0], [ 0, 0,  0], [  0,    -4, -PlateHeight-11]], //T0 neutral face flextion 
    [[15, 35, 31, -11], [ 0, -90, 0], [ 0, 0,  0], [  0,    -1, -PlateHeight-12]], //T1 neutral face abducted flextion 
    [[15, 40, 39.5, 2], [ 0,   0, 0], [ 0, 0,  0], [  0,    -3, -PlateHeight-15]], //T2 neutral tip adduction  minor extention
    [[15, 18, 41,   0], [ 0,  15, 0], [ 0, 0,  0], [  0,     0, -PlateHeight-11]], //T3 major Extention  adduction  
    [[ 5, 18, 25,   0], [ 8,   0, 0], [ 0, 0,  0], [  0,    12, -PlateHeight-16]], //T4 neutral tip adduction
    [[ 5, 20, 37,   0], [20,  15, 0], [ 0, 0,  0], [  0,    14, -PlateHeight-14]], //T5 major Extention  adduction
    [[ 5, 20, 25,   0], [ 0, -20, 0], [ 0, 0,  0], [  0,     5, -PlateHeight-13]], //unused
    [[15, 30, 35,   0], [ 0,  80, 0], [ 0, 0,  0], [ -6,    10, -PlateHeight-41]], //T7 RotarySwitch test placement 1
    [[15, 30, 35,   0], [ 0,  20, 0], [ 0, 90, 0], [-31, -30.5, -PlateHeight-22]], //T7 RotarySwitch test placement 2
    [[15, 30, 35,   0], [ 0, -25, 0], [ 0, 0,  0], [-13,  -5.5, -PlateHeight-13]], //T2 Tertiary palm when clipped T1
    [[15, 30, 35,   0], [ 0,  50, 0], [ 0, 0,  0], [-15, -11.5, -PlateHeight-25]] //mount 
 ];

//-------  design and adjustment parameters 
//Angles used in the pathfunction  
//               i1   i2   i3    m     r    p1   p2
ThetaR0      = [ 90,  90,  90,  90,   90,   90,  90]; //set Row 0 Angle for path function input
ThetaR2      = [ 70,  58,  63,  66, 60.5,   61,  50]; //set Row 2 Angle for path function input
Phi2Shift    = [180,   0, 180, 180,    0,    0,   0]; //ad hoc solution when solver return phase shifted
ThetaR1Shift = [ -1,  -1,  -1,   0, -1.5, -3.5,  -2];  //set adjustment angle calculated R1 Angle
ThetaR3Shift = [-12, -10, -11, -10,  -10,  -18, -24];  //set adjustment angle calculated R3 Angle
ThetaR4Shift = [  0,   0,   0,   0,    0,    0,   0];  //set adjustment angle calculated R4 Angle
ThetaRoll    = [ 40,  20,  10,   9,   12,   7,  -20];  //column rolling angle for the keysz

//Manual Adjustment of Pitches post Calculation for minor adjustment
ThetaKnock   =[[  0,   0,   0,  -5,    0,   0,    0],  //R0s 
               [  0,   0,   0,   0,    0,   0,    0],  //R1s
               [  0,   0,  -5,   0,  -10,   5,    2],  //R2s   right p1&2 = 5  left p1&2 = 10 
               [  0,   0,  -5,   0,  -10,   5,    5],  //R3
               [  0,   0,   0,   0,    0,   0,    0]   //R4
              ];

KeycapOffset = [  0,   0,   0,   0,    5,   2,    2]; //adjust path radius 
Pathlist     = [  0,   0,   0,   1,    2,   3,    3]; //Path function to apply on column

//Manual Adjustment of Pitches post Calculation for minor adjustment               
Clipped      =[[  4,   4,  -4,   0,    0,   0,   -4,  0],  //R0
               [  4,   4,  -4,   0,    0,  -4,   -4,  4],  //R1s
               [  4,   4,  -4,   0,    0,   0,   -4,  0],  //R2s 
               [  4,   4,  -4,   4,    4,   4,   -4,  0],  //R3
               [  4,   4,   4,   4,    4,   4,   -4,  0],  //R4
               [  4,   4,   4,   4,    4,   4,   -4,  0]   //R5
              ];

//Orientation of the clippede switches

ClippedOrientation = //if lengt-wise true 
              [[false, false, false, true, true, true, false, true],  
               [true, false, false, true, true, true, false, false],
               [false, false, false, true, true, true, false, true],
               [false, false, false, true, true, true, false, true],
               [false, false, false, true, true, true, false, true],
               [false, false, false, true, true, true, false, true]
              ]; 
               
//              R0,  R1,  R2,  R3,  R4
ThetaOffset  = [90,   0,   0,   0,  90]; // initial switch pitch angle 
PathSideRm   = [IN, OUT, OUT, OUT, OUT]; // switch placement Path 

//structure to hold height of keyswitches relative to the path functions 
//R0 is set at switch bottom while the rest is neutral  

KeyOriginCnRm = [for( i= [C0:C6])[[0,BottomHeight+KeycapOffset[i],0], for(j = [R1:R4])[0,TopHeight+KeycapOffset[i],0]]];
//row and column loop setter
RMAX         = R2;  // Set max rows on columns
CStart       = C1;  // Set column to begin looping for the build
CEnd         = C6;  // Set column to end for the build
ThetaFlick   = 90;   
  
//------ SOLVER  FUNCTIONS
  //structure to hold path functions deceimal points are obnoxious I know.... not efficient either but will do
  function PathStruct(theta) = //PathStruct(theta)[column][path][side] 
  10*[[//index
        [(-0.0970856749679*theta*PI/180+4.99998284136*pow(theta*PI/180,2)+-2.61181119129*pow(theta*PI/180,3)+0.285208750084*pow(theta*PI/180,4))*-1+6.05,
         (-0.0970856749679+4.99998284136*2*theta*PI/180+-2.61181119129*3*pow(theta*PI/180,2)+0.285208750084*4*pow(theta*PI/180,3))*-1],
        [(0.728370710170*theta*PI/180+-0.352102136033*theta*PI/180+-0.727326795753*pow(theta*PI/180,3)+2.46608365244*pow(theta*PI/180,4)+-1.81245120990*pow(theta*PI/180,5)+0.475640948226*pow(theta*PI/180,6))*-1+6.15,
         (0.728370710170+-0.352102136033*2*theta*PI/180+-0.727326795753*3*pow(theta*PI/180,2)+2.46608365244*4*pow(theta*PI/180,3)+-1.81245120990*5*pow(theta*PI/180,4)+0.475640948226*6*pow(theta*PI/180,5))*-1]
      ], 
      [//middle
        [(3.37546426127*theta*PI/180+-1.73407355112*pow(theta*PI/180,2)+1.05640460595*pow(theta*PI/180,3)+-0.207308712916*pow(theta*PI/180,4))*-1+7.05,
         (3.37546426127+-1.73407355112*2*theta*PI/180+1.05640460595*3*pow(theta*PI/180,2)+-0.207308712916*4*pow(theta*PI/180,3))*-1],
        [(0.607448069824*theta*PI/180+-6.03466707142*pow(theta*PI/180,2)+17.2974166723*pow(theta*PI/180,3)+-16.7955019591*pow(theta*PI/180,4)+6.24233180595*pow(theta*PI/180,5)+-0.52694982208*pow(theta*PI/180,6))*-1+7.05,
         (0.607448069824+-6.03466707142364*2*theta*PI/180+17.2974166723*3*pow(theta*PI/180,2)+-16.7955019591*4*pow(theta*PI/180,3)+6.24233180595*5*pow(theta*PI/180,4)+-0.52694982208*6*pow(theta*PI/180,5))*-1]
      ],
      [//Ring 
        [(3.7823025670934*theta*PI/180+-0.501527054996156*pow(theta*PI/180,2)+-0.643611490515308*pow(theta*PI/180,3)+0.284350638669325*pow(theta*PI/180,4))*-1+7.1,
         (3.7823025670934+-0.501527054996156*2*theta*PI/180+-0.643611490515308*3*pow(theta*PI/180,2)+0.284350638669325*4*pow(theta*PI/180,3))*-1],
        [(2.64824226949886*theta*PI/180+-1.75765298787184*pow(theta*PI/180,2)+1.58186165679158*pow(theta*PI/180,3)+-0.447633354249964*pow(theta*PI/180,4))*-1+7.1,
         (2.64824226949886+-1.75765298787184*theta*PI/180*2+1.58186165679158*3*pow(theta*PI/180,2)+-0.447633354249964*4*pow(theta*PI/180,3))*-1]
      ],
      [//Pinky
        [(0.891366580134508*theta*PI/180+1.39458123721462*pow(theta*PI/180,2)+0.0356280814612978*pow(theta*PI/180,3)+-0.306858074306139*pow(theta*PI/180,4))*-1+4.97,
         (0.891366580134508+1.39458123721462*2*theta*PI/180+0.0356280814612978*3*pow(theta*PI/180,2)+-0.306858074306139*4*pow(theta*PI/180,3))*-1], 
        [(-0.362824642312139*theta*PI/180+3.33009581755908*pow(theta*PI/180,2)+-3.46170300668225*pow(theta*PI/180,3)+1.31299949357683*pow(theta*PI/180,4))*-1+4.97,
         (-0.362824642312139+3.33009581755908*2*theta*PI/180+-3.46170300668225*3*pow(theta*PI/180,2)+1.31299949357683*4*pow(theta*PI/180,3))*-1]
      ]
  ];

  //-------   phi is angle from shifted origin to the target
  // derived transform from polar to cartesian with chain rule: for legiblity 
  function derPathX(theta,column, side) =  //x chain rule transform from polar to cartesian
      PathStruct(theta)[column][side][NORMAL]*cos(theta) - PathStruct(theta)[column][side][PATH]*sin(theta);
  function derPathY(theta,column,side) = //y chain rule transform from polar to cartesian
      PathStruct(theta)[column][side][NORMAL]*sin(theta) + PathStruct(theta)[column][side][PATH]*cos(theta);
  function rotateVecZ(vector, angle) = [
      [cos(angle), -sin(angle),0]*vector, [sin(angle), cos(angle),0]*vector, [0,0,1]*vector
  ];

  //--------   determine R1, R3, R4 angles
  function VectorTransformOrigin(theta, ShapeOrigin,column, side, angleOffset) = [//V1)
      //X
      PathStruct(theta)[column][side][PATH]*cos(theta)+ // switch location vector
      rotateVecZ(ShapeOrigin, atan(derPathY(theta, column, side)/derPathX(theta, column, side))+angleOffset)[0], //shape origin shifted normal to the 
      //Y
      PathStruct(theta)[column][side][PATH]*sin(theta)+ // switch location vector
      rotateVecZ(ShapeOrigin, atan(derPathY(theta, column, side)/derPathX(theta, column, side))+angleOffset)[1], //shape origin shifted normal to the 
      0//shape origin shifted normal to the 
  ];

  //---------Apply Rules can't generaize function so I have to make each calls such a BS!
  //Solve For knows coordinate  R0 and R2 
  VecTranR0 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR0[col], KeyOriginCnRm[col][R0], Pathlist[col], PathSideRm[R0], ThetaOffset[R0])]; //V1)
  VecTranR2 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR2[col], KeyOriginCnRm[col][R2], Pathlist[col], PathSideRm[R2], ThetaOffset[R2])]; //V1)
  VecRotR0 =  [for (col = [C0:C6])
                [0,0,atan(derPathY(ThetaR0[col], Pathlist[col], PathSideRm[R0])/derPathX(ThetaR0[col], Pathlist[col],PathSideRm[R0]))+ThetaOffset[R0]]
              ];
  VecRotR2 =  [for (col = [C0:C6]) 
                [0,0,atan(derPathY(ThetaR2[col], Pathlist[col], PathSideRm[R2])/derPathX(ThetaR2[col], Pathlist[col],PathSideRm[R2]))+ThetaOffset[R2]]
              ];

  // angle with respect to intermediate joint
  phiR0 = [for (col = [C0:C6]) atan((VecTranR0[col][1])/(VecTranR0[col][0]-FingerLength[col][0]))+180];  //TODO fix the FingerLength calls so that it wont affect this solvers
  phiR2 = [for (col = [C0:C6]) atan((VecTranR2[col][1])/(VecTranR2[col][0]-FingerLength[col][0]))+Phi2Shift[col]];
  phiR1 =  (phiR0 - phiR2)/2+phiR2;
  phiR3 = -(phiR0 - phiR2)/2+phiR2;
  phiR4 =  (phiR0 - phiR2)/2+phiR3;

  // recur solver check tol condition else repeat.  parm: x = init guess Tol = solution tolarence, col = column to be solved
  function Newton_Raphson1(x, Tol, col) = 
    PathStruct(x)[Pathlist[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR1[col])/sin(phiR1[col]-x) < Tol ? x :  Newton_Raphson1(x - (PathStruct(x)[Pathlist[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR1[col])/sin(phiR1[col]-x))/(PathStruct(x)[Pathlist[col]][OUT][NORMAL] - FingerLength[col][0]*sin(phiR1[col])/tan(phiR1[col]-x)/cos(phiR1[col]-x)), Tol,col);

  function Newton_Raphson3(x, Tol, col) = 
    PathStruct(x)[Pathlist[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR3[col])/sin(phiR3[col]-x) < Tol ? x :  Newton_Raphson3(x - (PathStruct(x)[Pathlist[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR3[col])/sin(phiR3[col]-x))/(PathStruct(x)[Pathlist[col]][OUT][NORMAL] - FingerLength[col][0]*sin(phiR3[col])/tan(phiR3[col]-x)/cos(phiR3[col]-x)), Tol,col);

  function Newton_Raphson4(x, Tol, col) = 
    PathStruct(x)[Pathlist[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR4[col])/sin(phiR4[col]-x) < Tol ? x :  Newton_Raphson4(x - (PathStruct(x)[Pathlist[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR4[col])/sin(phiR4[col]-x))/(PathStruct(x)[Pathlist[col]][OUT][NORMAL] - FingerLength[col][0]*sin(phiR4[col])/tan(phiR4[col]-x)/cos(phiR4[col]-x)), Tol,col);
  
  // hold solved struct
  ThetaR1 = [for( col = [C0:C6]) Newton_Raphson1(60, Tol, col)+ThetaR1Shift[col]];
//  ThetaR3 = [for( col = [C0:C6]) Newton_Raphson3(30, Tol, col)+ThetaR3Shift[col]];
  ThetaR3 = [for( col = [C0:C6]) Newton_Raphson3(50, Tol, col)+ThetaR3Shift[col]];
  ThetaR4 = [for( col = [C0:C6]) Newton_Raphson4(50, Tol, col)+ThetaR4Shift[col]];

  ThetaRn = [
    ThetaR0,
    [for(col = [C0:C6]) Newton_Raphson1(60, Tol, col)+ThetaR1Shift[col]],
    ThetaR2,
    [for(col = [C0:C6]) Newton_Raphson3(60, Tol, col)+ThetaR1Shift[col]],
    [for(col = [C0:C6]) Newton_Raphson4(60, Tol, col)+ThetaR1Shift[col]]
  ];

  //----- Map the angle with origin no origin offsets
  VecTranR1 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[R1][col], KeyOriginCnRm[col][R1], Pathlist[col], PathSideRm[R1], ThetaOffset[R2])]; //V1)
  VecTranR3 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[R3][col], KeyOriginCnRm[col][R3], Pathlist[col], PathSideRm[R3], ThetaOffset[R2])]; //V1)
  VecTranR4 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[R4][col], KeyOriginCnRm[col][R4], Pathlist[col], PathSideRm[R4], ThetaOffset[R2])]; //V1)
    
//  VecTransRnTest  = [for (row = [R0:R4]) for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[row][col], [0,0,0], Pathlist[col], PathSideRm[row], ThetaOffset[row])];
  
  VecTranR0c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR0[col], [0,0,0], Pathlist[col], PathSideRm[R0], ThetaOffset[R0])]; 
  VecTranR1c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR1[col], [0,0,0], Pathlist[col], PathSideRm[R1], ThetaOffset[R1])]; 
  VecTranR2c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR2[col], [0,0,0], Pathlist[col], PathSideRm[R2], ThetaOffset[R2])]; 
  VecTranR3c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR3[col], [0,0,0], Pathlist[col], PathSideRm[R3], ThetaOffset[R3])]; 
  VecTranR4c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR4[col], [0,0,0], Pathlist[col], PathSideRm[R4], ThetaOffset[R4])]; 
                  
  VecRotR1 = [for (col = [C0:C6]) [0,0,atan(derPathY(ThetaR1[col], Pathlist[col], PathSideRm[R1])/derPathX(ThetaR1[col], Pathlist[col],PathSideRm[R1]))+ThetaOffset[R1]]];
  VecRotR3 = [for (col = [C0:C6]) [0,0,atan(derPathY(ThetaR3[col], Pathlist[col], PathSideRm[R3])/derPathX(ThetaR3[col], Pathlist[col],PathSideRm[R3]))+ThetaOffset[R3]]];
  VecRotR4 = [for (col = [C0:C6]) [0,0,atan(derPathY(ThetaR4[col], Pathlist[col], PathSideRm[R4])/derPathX(ThetaR4[col], Pathlist[col],PathSideRm[R4]))+ThetaOffset[R4]]];

  VecTransRmCnO = [VecTranR0,VecTranR1,VecTranR2,VecTranR3,VecTranR4]; // for locating between plates
  VecTransRmCn  = [VecTranR0c,VecTranR1c,VecTranR2c,VecTranR3c,VecTranR4c]; // oring set to [0,0,0] for general placement 
  RotTransRmCn  = [VecRotR0,VecRotR1,VecRotR2,VecRotR3,VecRotR4];
  
//  echo (VecTranRnTest == VecTransRmCn);
//-------  END SOLVER
  

//#########  Supporting Modules for Main Builder Modules
function hadamard(a, b) = !(len(a) > 0) ? a*b : [ for (i = [0:len(a) - 1]) hadamard(a[i], b[i])]; // elementwise mult

//Convinient notation for hulling a cube by face/edge/point
module hullPlate(referenceDimensions = [0,0,0], offsets = [0,0,0])
{ 
  x = offsets[0] == 0 ?  referenceDimensions[0]:HullThickness;
  y = offsets[1] == 0 ?  referenceDimensions[1]:HullThickness;
  z = offsets[2] == 0 ?  referenceDimensions[2]:HullThickness;
  hullDimension = [x, y, z];
  
  translate(hadamard(referenceDimensions, offsets/2))translate(hadamard(hullDimension, -offsets/2))cube(hullDimension, center = true);
} 

//Convinient cube transferomation and hulling 
module modulate(referenceDimension = [0,0,0], referenceSide = [0,0,0], objectDimension = [0,0,0], objectSide = [0,0,0], Hull = false, hullSide = [0,0,0]){
  if(Hull == false){
    translate(hadamard(referenceDimension, referenceSide/2))translate(hadamard(objectDimension,objectSide / 2))cube(objectDimension, center = true);
  }else{
    color("red")translate(hadamard(referenceDimension, referenceSide/2))translate(hadamard(objectDimension, objectSide/2))hullPlate(objectDimension, hullSide);
  }
}  

module PlaceColumnOrigin(Cn = C0) {
 translate(ColumnOrigin[Cn][0])rotate(ColumnOrigin[Cn][1])rotate([90,0,0])mirror([0,1,0])rotate(ColumnOrigin[Cn][2])children();
}

module OnPlateOrigin(Rm = R0, Cn = C0){
  translate((KeyOriginCnRm[Cn][Rm]+[0,PlateHeight+PlateThickness/2,0]))children();
}

module PlaceOnRoll(rollAngle =0 , offsets = -1){ // set rotation origin on the plate top edge
  function RollOrigin() = offsets*[0,-PlateThickness/2,PlateOffsets/2+SwitchWidth/2];
  translate(-RollOrigin())rotate([-rollAngle,0,0])translate(RollOrigin())children();
}

//angle adjustment
module PlaceOnKnock(KnockAngle =0 , offsets = -1){ // set rotation origin on the plate top edge
  function KnockOrigin() = offsets*[-10,-PlateOffsets/2-SwitchWidth/2-2,0];
  translate(-KnockOrigin())rotate([0,0,KnockAngle])translate(KnockOrigin())children();
}

module PlaceOnFlick(Angle =0 , offsets = -1){ // set rotation origin on the plate top edge
 function RollOrigin() = offsets*[-18,0,24];
 translate(-offsets*[0,0,0])rotate([0,-Angle,0])translate(RollOrigin())children();
}

//place child object on the target position with all transforms
module BuildRmCn(row, col) {
  PlaceColumnOrigin(col)
    translate(VecTransRmCn[row][col])
      rotate(RotTransRmCn[row][col])
        OnPlateOrigin(row,col)
          PlaceOnRoll(ThetaRoll[col], -sign(ThetaRoll[col]))
            PlaceOnKnock(ThetaKnock[row][col])
            rotate([90,90,0])
              children();
}

module OnThumb(thetaDist, thetaMed, thetaProx, phiProx, stick = false, stickDia = 2){ //stick = true to show stick representation of thumb placement
  phiMed = 20; // medial rotation 
  rotate([-90,0,0])rotate([-phiProx,-thetaProx,0]){
    if(stick == true)color("red")cylinder(d=stickDia, FingerLength[T0][0]);// base
    translate([0,0,FingerLength[T0][0]]){
      rotate([0,thetaMed,0])rotate([0,0,phiMed]){
        if(stick == true)color("blue")cylinder(d=stickDia,FingerLength[T0][1]);
        translate([0,0,FingerLength[T0][1]]){ //tip
          rotate([0,thetaDist ,0]){
            if(stick == true)color("green")cylinder(d=stickDia,FingerLength[T0][2]);
            rotate([90,0,0])translate([0,FingerLength[T0][2]/2,0]){
              children();
            }
          }
        }
      }
    }
  }
}

module PlaceOnThumb(Rn = R0, stick = false){ //for thumb 
  translate(ColumnOrigin[T0][0])rotate(ColumnOrigin[T0][1])OnThumb(ThumbPosition[Rn][0][0],ThumbPosition[Rn][0][1],ThumbPosition[Rn][0][2],ThumbPosition[Rn][0][3], stick)rotate(ThumbPosition[Rn][1])translate(ThumbPosition[Rn][3])rotate(ThumbPosition[Rn][2])children(); 
}    


// not too accurate... but place object between Rms 
module PlaceBetween(Rm = R0,Cn = C0){   
 function rotX(vec1, rot1) =  [[1,0,0]*vec1, 
                              [0, cos(rot1),-sin(rot1)]*vec1,
                              [0, sin(rot1),cos(rot1)]*vec1];
  
  vecRm = [0,0,PlateDimension[1]/2];  
  Vec1  = VecTransRmCn[Rm][Cn] + rotateVecZ([(KeyOriginCnRm[Cn][Rm]+[0,PlateHeight,0])[1],-PlateDimension[1]/2,0],RotTransRmCn[Rm][Cn][2]+90);
  Vec2 = VecTransRmCn[Rm+1][Cn] + rotateVecZ([(KeyOriginCnRm[Cn][Rm+1]+[0,PlateHeight,0])[1],PlateDimension[1]/2,0],RotTransRmCn[Rm+1][Cn][2]+90);

  function RollOrigin2() = 1*[0,0,PlateDimension[1]/2];

  PlaceColumnOrigin(Cn)
    translate((Vec2+Vec1)/2)rotate([0,0,atan((Vec2-Vec1)[1]/(Vec2-Vec1)[0])+90])
     translate(RollOrigin2())rotate([0,ThetaRoll[Cn],0])translate(-RollOrigin2())
        rotate([0,90,0])children();
}

module BuildSetBetween() // optional mount hole between switched
{
  for(Cn = [C1:C3]){
    for(Rm = [R0,RMAX-1]){
      PlaceBetween(Rm,Cn)children();
    }
  }
}

module BuildColumn(plateThickness, offsets, sides =TOP, col=0, rowInit = R0, rowEnd = RMAX){
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [PlateDimension[0], PlateDimension[1], plateThickness];
  
  module modPlateLen(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for length-wise clipping 
    modulate(refDim,[0,sign(Clipped[rows][cols]),sides], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    //use clip length sign to direct transform sides and adjust platle length rather than if else statement for more compact call 
  }
  
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    modulate(refDim,[sign(Clipped[rows][cols]), 0, sides], buildDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  
  for (row = [rowInit:rowEnd]){// Plate
    if (ClippedOrientation[row][col] == true){ //for length-wise Clip
      BuildRmCn(row, col)modPlateLen(Hulls = false, rows =row, cols = col);  
      if (row < RMAX){//Support struct
        hull(){
          BuildRmCn(row, col)modPlateLen(Hulls = true, hullSides = [0,FRONT,0], rows = row, cols = col);
          BuildRmCn(row+1, col)modPlateLen(Hulls = true, hullSides = [0,BACK,0], rows = row+1, cols = col);
        }
      }
    }else { // for Width-wise Clip
      BuildRmCn(row, col)modPlateWid(Hulls = false, rows =row, cols = col);  
      if (row < RMAX){//Support struct
        hull(){
          BuildRmCn(row, col)modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows = row, cols = col);
          BuildRmCn(row+1, col)modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows = row+1, cols = col);
        }
      }
    }
  }
}

module refWeb (plateThickness, webWidth, offsets, sides =TOP, rows , cols, corner = RIGHT, direction = true, Hulls = false, hullSides = [0,0,0]) {
  
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [webWidth, PlateDimension[1], plateThickness];
  
  BuildRmCn(rows, cols){
    if (ClippedOrientation[rows][cols] == true){ //for length-wise Clip
      modulate(refDim,[corner ,sign(Clipped[rows][cols]),sides], buildDim-[0,abs(Clipped[rows][cols]),0], [ -corner, -sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if (direction == true ) {
      translate([max(Clipped[rows][cols]/2,0),0,0])modulate(refDim,[corner,sign(Clipped[rows][cols]),sides], buildDim, [-corner,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      translate([min(-abs(Clipped[rows][cols])/2,0),0,0])modulate(refDim,[corner,sign(Clipped[rows][cols]),sides], buildDim, [-corner,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }
}

//called to generate hull between columns, rather than surface hull, offsetted cube is used to create thicker support
module BuildWebs(plateThickness, webWidth, offsets, sides =TOP, col=0, rowInit = R0, rowEnd = RMAX)
{
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [webWidth, PlateDimension[1], plateThickness];
  
  module buildWeb(rows , cols, corner = RIGHT, direction = true, Hulls = false, hullSides = [0,0,0]) { 
    if (ClippedOrientation[rows][cols] == true){ //for length-wise Clip
      BuildRmCn(rows, cols)modulate(refDim,[corner ,sign(Clipped[rows][cols]),sides], buildDim-[0,abs(Clipped[rows][cols]),0], [ -corner, -sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if (direction == true ) {
      BuildRmCn(rows, cols)translate([max(Clipped[rows][cols]/2,0),0,0])modulate(refDim,[corner,sign(Clipped[rows][cols]),sides], buildDim, [-corner,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      BuildRmCn(rows, cols)translate([min(-abs(Clipped[rows][cols])/2,0),0,0])modulate(refDim,[corner,sign(Clipped[rows][cols]),sides], buildDim, [-corner,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }
  
  for (row = [rowInit:rowEnd]){//Hull intra Column between plates 
    hull(){
      buildWeb(row, col,   RIGHT, direction = true); //Hull Face 1
      buildWeb(row, col+1, LEFT,  direction = false); //Hull Face 2
    }
    if (row < rowEnd) {//Hull intra Column between four corners 
      hull(){
        buildWeb(row,   col,   RIGHT, direction = true,  Hulls = true, hullSides = [0,FRONT,0]);
        buildWeb(row+1, col,   RIGHT, direction = true,  Hulls = true, hullSides = [0,BACK,0]);
        buildWeb(row,   col+1, LEFT,  direction = false, Hulls = true, hullSides = [0,FRONT,0]);
        buildWeb(row+1, col+1, LEFT,  direction = false, Hulls = true, hullSides = [0,BACK,0]);
      }
    }
  }
}

//build surfaces used to cut top surface of plates and web. 
// !TODO utilize Hull rather than innerWebDim.incorrect behavior at C0
module BuildInnerWebs(col, sides = RIGHT)
{
  innnerWebDim = [HullThickness,PlateDimension[1],HullThickness];
  refDim       = PlateDimension;
  function ClipRef(rows,cols) = sides == RIGHT ? [-sides*max((Clipped[rows][cols]),0),0,0] : [min((Clipped[rows][cols])/2,0),0,0];
  hull()
  {
    for(row = [R0:RMAX]) 
    {
      if (ClippedOrientation[row][col] == true){ //for length-wise Clip
        BuildRmCn(row, col)modulate(refDim,[sides,sign(Clipped[row][col]),TOP], innnerWebDim-[0,abs(Clipped[row][col]),0], [-sides,-sign(Clipped[row][col]),TOP]);
      }else { 
        BuildRmCn(row, col)translate(ClipRef(row,col))modulate(refDim,[sides,sign(Clipped[row][col]),TOP], innnerWebDim, [-sides, -sign(Clipped[row][col]),TOP]);
      }
    }
    
    if (ClippedOrientation[R0][col] == true){
      BuildRmCn(R0, col)modulate(refDim,[sides,BACK,TOP], innnerWebDim-[0,abs(Clipped[R0][col]),0], [-sides,0,TOP]);
    }else {
      BuildRmCn(R0, col)translate(ClipRef(R0,col))modulate(refDim,[sides,BACK,TOP], innnerWebDim, [-sides,0,TOP]);
    }
    if (ClippedOrientation[R3][col] == true){
      BuildRmCn(R3, col)modulate(refDim,[sides,FRONT,TOP], innnerWebDim-[0,abs(Clipped[R3][col]),0], [-sides,0,TOP]);
    }else {
//      BuildRmCn(R3, col)translate(ClipRef(R3,col))modulate(refDim,[sides,FRONT,TOP], innnerWebDim, [-sides,0,TOP]);
    }
  }
}

//################ Main Builder ############################
module BuildThumbCluster(sides = 0,  offsets = 0, frameThickness = PlateDimension[2], Mount = false, track = true, Rotary = false)
{
  refDim      = PlateDimension +[0,0,offsets];
  frameDim    = [PlateDimension[0], PlateDimension[1], frameThickness];
  plateDim    = PlateDimension +[0,0,3];
  plateDimLow = PlateDimension +[0,0,2];
  cutDim      = PlateDimension+[0,0,5];
  trackDim    = [26.5, 28, 1];
  TMAX        = 5;

  module modPlate(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call 
    if(Clipped[rows][cols] == 0){
      modulate(PlateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if( ClippedOrientation[rows][cols] == false) {
      modulate(refDim,[sign(Clipped[rows][cols]), 0, TOP], plateDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      modulate(refDim,[0,sign(Clipped[rows][cols]),TOP], plateDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]), BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }
  
  difference(){ //R0~R3 hull 
    union(){
      //upper keyplates
      for(i = [R0:TMAX]){PlaceOnThumb(i)modPlate(Hulls = false, rows = i, cols = T0);} //main plate      
      //<-inter plate hulls
        hull(){      
          PlaceOnThumb(R1)modPlate(Hull = true, hullSides = [BOTTOM,0,0], rows = R1, cols = T0);
          PlaceOnThumb(R0)modPlate(Hull = true, hullSides = [TOP,0,0], rows = R0, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R1)modPlate(Hull = true, hullSides = [0,BACK,0], rows = R1, cols = T0);
          PlaceOnThumb(R0)modPlate(Hull = true, hullSides = [TOP,BACK,0], rows = R0, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R1)modPlate(Hull = true, hullSides = [BOTTOM,RIGHT,0], rows = R1, cols = T0);
          PlaceOnThumb(R0)modPlate(Hull = true, hullSides = [0,BOTTOM,0], rows = R0, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R0)modPlate(Hull = true, hullSides = [BOTTOM,0,0], rows = R0, cols = T0);
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [LEFT,0,0], rows = R2, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R3)modPlate(Hull = true, hullSides = [LEFT,0,0], rows = R3, cols = T0);
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [RIGHT,0,0], rows = R2, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R3)modPlate(Hull = true, hullSides = [LEFT,BACK,0], rows = R3, cols = T0);
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [0,BACK,0], rows = R2, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R3)modPlate(Hull = true, hullSides = [LEFT,BACK,0], rows = R3, cols = T0);
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [0,BACK,0], rows = R2, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R2, cols = T0);
          PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [0,BACK,0], rows = R4, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R3)modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R3, cols = T0);
          PlaceOnThumb(R5)modPlate(Hull = true, hullSides = [0,BACK,0], rows = R5, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R5)modPlate(Hull = true, hullSides = [LEFT,0,0], rows = R5, cols = T0);
          PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [RIGHT,0,0], rows = R4, cols = T0);
        }
        hull(){      
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [RIGHT,FRONT,0], rows = R2, cols = T0);
          PlaceOnThumb(R3)modPlate(Hull = true, hullSides = [LEFT,FRONT,0], rows = R3, cols = T0);
          PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [RIGHT,BACK,0], rows = R4, cols = T0);
          PlaceOnThumb(R5)modPlate(Hull = true, hullSides = [LEFT,BACK,0], rows = R5, cols = T0);
        }
      //<-End inner hull

      //attachement to finger columns TODO refactor into separate module?
      if(Mount == false){ 
       // right side C2  joint 
       hull(){      
         PlaceOnThumb(R0)modPlate(Hull = true, hullSides = [0,LEFT,0], rows = R0, cols = T0);
         PlaceOnThumb(R1)modPlate(Hull = true, hullSides = [BOTTOM,LEFT,0], rows = R1, cols = T0);
         ShiftTrans()refWeb(PlateDimension[2]+2, WebThickness, 0, TOP, rows =  R0 , cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [RIGHT,0,0]);
        }
       hull(){      
         PlaceOnThumb(R1)modPlate(Hull = true, hullSides = [0,LEFT,0], rows = R1, cols = T0);         
         ShiftTrans()refWeb(PlateDimension[2]+2, WebThickness, 0, TOP, rows =  R0 , cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [RIGHT,BACK,0]);
        }
        hull(){      
         PlaceOnThumb(R1)modPlate(Hull = true, hullSides = [0,LEFT,BOTTOM], rows = R1, cols = T0);
         ShiftTrans()BuildRmCn(R0, C2)modPlate(Hull = true, hullSides = [RIGHT,0,TOP], rows = R0, cols =C2);
        }
        //left side C1 and C2 joints 
        hull(){      
         PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R4, cols = T0);
         ShiftTrans()BuildRmCn(R1, C1)modPlate(Hull = true, hullSides = [0,BACK,0], rows =  R1, cols =C1);
        }
        hull(){
          PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [LEFT,FRONT,0], rows = R4, cols = T0);
          ShiftTrans()refWeb(PlateDimension[2]+2, WebThickness, 0, TOP, rows =  R1 , cols = C2, corner = LEFT, direction = false, Hulls = true, hullSides = [0,BACK,0]);
          ShiftTrans()refWeb(PlateDimension[2]+2, WebThickness, 0, TOP, rows =  R1 , cols = C1, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,BACK,0]);
        } 
        hull(){
          PlaceOnThumb(R0)modPlate(Hull = true, hullSides = [RIGHT,FRONT,0], rows = R2, cols = T0);      
          PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [LEFT,BACK,0], rows = R4, cols = T0);
          PlaceOnThumb(R2)modPlate(Hull = true, hullSides = [LEFT,FRONT,0], rows = R2, cols = T0);
          ShiftTrans()refWeb(PlateDimension[2]+2, WebThickness, 0, TOP, rows =  R0 , cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [RIGHT,FRONT,BOTTOM]);  
        }
//        #hull(){
//          PlaceOnThumb(R2)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], plateDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [FRONT,0,TOP]);
//          PlaceOnThumb(R0)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], plateDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [BACK,0,TOP]);
//        }
          //left side  C0 C1 joint
        hull(){      
         PlaceOnThumb(R5)modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R5, cols = T0);
         ShiftTrans()BuildRmCn(R2, C0)modPlate(Hull = true, hullSides = [0,BACK,0], rows =  R2, cols =C0);
        }    
        hull(){     
          PlaceOnThumb(R5)modPlate(Hull = true, hullSides = [LEFT,FRONT,0], rows = R5, cols = T0);
          PlaceOnThumb(R4)modPlate(Hull = true, hullSides = [RIGHT,FRONT,0], rows = R4, cols = T0);
          ShiftTrans()BuildRmCn(R1, C1)modPlate(Hulls = true, hullSides = [LEFT,BACK,0], rows = R1, cols = C1);
          ShiftTrans()BuildRmCn(R2, C0)modPlate(Hulls = true, hullSides = [RIGHT,BACK,0], rows = R2, cols = C0);
        }        
      }           
    }
    union(){//cuts
    //Column Cuts
      for(Cn = [C2:C6]) hull(){// intra cut C1
        ShiftTrans()BuildInnerWebs(Cn, sides = RIGHT);
        ShiftTrans()BuildInnerWebs(Cn, sides = LEFT);
      }
    //bottom plate cuts
      for (i = [R0:TMAX]){//keyholes
        if(ClippedOrientation[i][T0] == true){
          PlaceOnThumb(i)Keyhole(clipLength = Clipped[i][T0]);
          PlaceOnThumb(i)modulate(PlateDimension,[0,sign(Clipped[i][T0]),TOP],plateDim+[0,-abs(Clipped[i][T0]),5], [0,-sign(Clipped[i][T0]),TOP], Hull = false); //cut to prevent key caps snagging
        }else {
          PlaceOnThumb(i)rotate([0,0,-90])Keyhole(clipLength = Clipped[i][T0]);
          PlaceOnThumb(i)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[i][T0]),TOP],plateDim+[0,-abs(Clipped[i][T0]),5], [0,-sign(Clipped[i][T0]),TOP], Hull = false); //cut to prevent key caps snagging PlaceOnThumb(i)Keyhole(clipLength = clipLen);
        }
      }     
      
      ShiftTrans()BuildRmCn(R0, C2)Keyhole(cutThickness = 3.5);
      
      //trackpoint 
      if(Mount == true){
        PlaceOnThumb(10)translate([0,0,8])cylinder(d1 =dMount, d2= dChamfer, 2.5, center = true);
        PlaceOnThumb(10)cylinder(d= dMount, 90, center = true);
      }
//        translate([-50,24,8])rotate([16,100,0])cylinder(d= dMount, 13, center = true);
      if(Rotary == true){PlaceOnThumb(7)RotaryEncoder(stemLength= 0, Wheel = 0);;}
    }
  } // end cut
}

module BuildTopPlate(keyhole = false, Mount = true, channel = false, platethickness = 0)
{
  plateDim = PlateDimension +[0,0,1];
  module modPlate(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand
    modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  difference(){
    union(){//SwitchPlate
      for(cols = [CStart:CEnd]){
        if (cols == C1) {
          BuildColumn(PlateDimension[2]+platethickness, 0, TOP, cols, rowInit = R1, rowEnd = RMAX);
        } else if (cols == C0){
          BuildColumn(PlateDimension[2]+platethickness, 0, TOP, cols, rowInit = R1, rowEnd = R1);
        } else {
          BuildColumn(PlateDimension[2]+platethickness, 0, TOP, cols);
        }
        if (cols < CEnd){
          if( cols == C1) {
            BuildWebs(PlateDimension[2]+platethickness, WebThickness, 0, TOP, cols, rowInit = R1, rowEnd = RMAX);
          }  else if (cols == C0){
            BuildWebs(PlateDimension[2]+platethickness, WebThickness, 0, TOP, cols, rowInit = R1, rowEnd = R1);
        } else {
            BuildWebs(PlateDimension[2]+platethickness, WebThickness, 0, TOP, cols);
          }
        }
        
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R0 , cols = C2, corner = LEFT, direction = false);
        //Prettyborader
        hull(){
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C1, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C2, corner = LEFT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
        }
        hull(){
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C3, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C3, corner = LEFT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C4, corner = LEFT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
        }
        hull(){
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C6, corner = LEFT, direction = false, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C5, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R2 , cols = C5, corner = LEFT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
        }
        hull(){
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R0 , cols = C2, corner = LEFT, direction = false, Hulls = true, hullSides = [0,FRONT,0]);
          refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows =  R1 , cols = C2, corner = LEFT, direction = false, Hulls = true, hullSides = [0,BACK,0]);
        }
      }
    }
    union(){// cuts
      for(cols = [CStart:CEnd]){//SwitchPlate
        hull(){//intra column internal cuts
          BuildInnerWebs(cols, sides = RIGHT);
          BuildInnerWebs(cols, sides = LEFT);
        }
        if (cols < CEnd && cols != C4){
          hull(){//inter column internal cuts
            BuildInnerWebs(cols,   sides = RIGHT);
            BuildInnerWebs(cols+1, sides = LEFT);
          }
        }
      }  
      //note special cuts for C4/5 Webbing
      hull(){
        BuildRmCn(R0, C4)modPlate(Hulls = true, hullSides = [RIGHT,0,TOP],    rows =R0, cols = C4);
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides = [RIGHT,BACK,TOP], rows =R1, cols = C4);
        BuildRmCn(R0, C5)modPlate(Hulls = true, hullSides = [LEFT,0,TOP],     rows =R0, cols = C5);
        BuildRmCn(R1, C5)modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP],  rows =R1, cols = C5);
      }
      hull(){
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides = [0,0,TOP],        rows =R1, cols = C4);
        BuildRmCn(R1, C5)modPlate(Hulls = true, hullSides = [LEFT,0,TOP],     rows =R1, cols = C5);
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides = [0,FRONT,TOP],    rows =R1, cols = C4);
        BuildRmCn(R0, C4)modPlate(Hulls = true, hullSides = [LEFT,FRONT,TOP],    rows =R1, cols = C4);
        BuildRmCn(R2, C4)modPlate(Hulls = true, hullSides = [0,BACK,TOP],     rows =R2, cols = C4);
        BuildRmCn(R1, C5)modPlate(Hulls = true, hullSides = [LEFT,FRONT,TOP], rows =R1, cols = C5);
        BuildRmCn(R2, C5)modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP],  rows =R2, cols = C5);
      }
      hull(){
        BuildRmCn(R2, C4)modPlate(Hulls = true, hullSides = [0,0,TOP],    rows = R2, cols = C4);
        BuildRmCn(R2, C5)modPlate(Hulls = true, hullSides = [LEFT,0,TOP], rows = R2, cols = C5);
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides = [0,FRONT,TOP], rows = R2, cols = C5);
      }
          
      if(Mount == true){
       BuildSetBetween()cylinder(d2 =dMount, d1= dChamfer, 2.5, center = true);
       BuildSetBetween()cylinder(d= dMount, 70);
       cylinder(d= dMount, 70);
      }
        
      if(keyhole == true){
        for(cols = [CStart:CEnd]){
          for(rows = [R0:RMAX]){
            BuildRmCn(rows, cols){
              if(ClippedOrientation[rows][cols] == true){
                Keyhole(clipLength = Clipped[rows][cols]);
                modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = false); //cut to prevent key caps snagging
              }else {
                rotate([0,0,-90])Keyhole(clipLength = Clipped[rows][cols]);
                rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = false); //cut to prevent key caps snagging
              }
            }
          }
        }  
      }
      translate([10,0,-20])rotate([0,0,0])cylinder(d = 5.1054, 20);
      translate([10,-12,-20])rotate([0,0,0])cylinder(d = 5.1054, 20);
      translate([10,-8,-1])rotate([0,0,0])cube([20,25,15],center = true);
      translate([-10,-4,-12])cube([25,20.80,12],center = true); //BLE case
    }
  }
}

//------------------  Section D:: PCB output for kicad and cuts 
//fix modules callsS
module PCBOUT(plateThickness, offsets, sides =TOP, col=0, row = 0) // Wire Channel
{
  refDim =PlateDimension +[0,0,offsets];
  buildDim =[PlateDimension[0]-3.9, PlateDimension[1], plateThickness];
  //left then right 
//  hull(){
    BuildRmCn(row,   col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,TOP]);
    BuildRmCn(row+1, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,TOP]);
    BuildRmCn(row,   col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,TOP]);
    BuildRmCn(row+1, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,TOP]);
//  }
//   BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);
}

module BuildPCBColumn(plateThickness, offsets, sides =TOP, col = 0) // Wire Channel
{
   refDim =PlateDimension +[0,0,offsets];
   buildDim =[PlateDimension[0]-3.9, PlateDimension[1], plateThickness];

  for (row = [R0:RMAX-1]){//ADJUSTMENT ROW SIZE
    if ( ((col != C1 && col != C5) || row != R0) ){
      if (row < RMAX){//ADJUSTMENT ROW SIZE
        hull(){
          BuildRmCn(row,   col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
          BuildRmCn(row+1, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
        }
      }
    }
  }
  
  if (col != C1){ BuildRmCn(R0, col)modulate(refDim,[0,FRONT,sides], buildDim-[0,1.5,0], [0,BACK,BOTTOM]); }
  
  for (row = [R1:RMAX-1]){BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);}
  
  BuildRmCn(RMAX, col)modulate(refDim,[0,BACK,sides], buildDim-[0,1.5,0], [0,FRONT,BOTTOM]);
}

module BuildPCBInter(plateThickness, offsets, offsetx, jogDirection, sides =TOP, row1 = R0, row2 = R0, col= C0, specialHull1 = 0,specialHull2 = 0, ) // Wire Channel
{ 
  module buildWeb (rows, cols, corner = RIGHT, direction = true, Hulls = false, hullSides = [0,0,0]) {
  
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [2, PlateDimension[1]- offsetx, plateThickness];

  BuildRmCn(rows, cols){
    if (ClippedOrientation[rows][cols] == true){ //for length-wise Clip
      modulate(refDim,[corner ,jogDirection,sides], buildDim, [-corner, -jogDirection,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if (direction == true ) {
      translate([max(Clipped[rows][cols]/2,0),0,0])modulate(refDim,[corner,jogDirection,sides], buildDim, [-corner,-jogDirection,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      translate([min(-abs(Clipped[rows][cols])/2,0),0,0])modulate(refDim,[corner,jogDirection,sides], buildDim, [-corner,-jogDirection,BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }
}
  hull(){      
    buildWeb(rows = row1, cols = col,   corner = RIGHT, direction = true,  Hulls = true, hullSides = [specialHull1,FRONT,0]);
    buildWeb(rows = row2, cols = col,   corner = RIGHT, direction = true,  Hulls = true, hullSides = [specialHull1,BACK,0]);
    buildWeb(rows = row1, cols = col+1, corner = LEFT,  direction = false, Hulls = true, hullSides = [specialHull2,FRONT,0]);
    buildWeb(rows = row2, cols = col+1, corner = LEFT,  direction = false, Hulls = true, hullSides = [specialHull2,BACK,0]);
  } 
}

module BuildPCBThumb(plateThickness, offsets, sides = TOP) // Wire Channel
{
   refDim = PlateDimension +[0,0,offsets];
   buildDim = [PlateDimension[0], PlateDimension[1]-3.9, plateThickness];
   buildDim2 = [PlateDimension[0]-3.9, PlateDimension[1], plateThickness];
  
  
  for (i = [R0:R5]){//ADJUSTMENT ROW SIZE
    PlaceOnThumb(i)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM]);
  }
  hull(){
     PlaceOnThumb(R2)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], buildDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [FRONT,0,0]);
     PlaceOnThumb(R0)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], buildDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [BACK,0,0]);
  }
  hull(){
     PlaceOnThumb(R3)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
     PlaceOnThumb(R5)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
  hull(){
     PlaceOnThumb(R2)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
     PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
  hull(){
     PlaceOnThumb(R5)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [FRONT,0,0]);
     PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [BACK,0,0]);
  }
  hull(){
     PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
     ShiftTrans()BuildRmCn(R1, C1)modulate(refDim, [0,0,sides], buildDim2, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
  
}

module BuildPCBC0(plateThickness, offsets, sides = TOP) // Wire Channel
{
   refDim =PlateDimension +[0,0,offsets];
   buildDim =[PlateDimension[0], PlateDimension[1], plateThickness];
  
  module modPlate(Hulls = true, hullSides = [0,0,0],rows = 0, cols = 0 ){ //shorthand call 
    BuildRmCn(rows, cols){
      if(Clipped[rows][cols] == 0){
        modulate(refDim, [0,0,TOP], buildDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
      } else if( ClippedOrientation[rows][cols] == false) {
        modulate(refDim,[sign(Clipped[rows][cols]), 0, BOTTOM], buildDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides); 
      } else {
        modulate(refDim,[0,sign(Clipped[rows][cols]),BOTTOM], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]), BOTTOM], Hull = Hulls, hullSide = hullSides);
      }
    }
  }
  modPlate(Hulls = false,rows = R2, cols = C0);  
  hull(){
      refWeb(5, WebThickness, 3.8, BOTTOM, R2,   C0,   RIGHT, direction = true,  Hulls = true, hullSides = [0,0,0]);
      refWeb(5, WebThickness, 3.8, BOTTOM, R1,   C0+1, LEFT,  direction = false, Hulls = true, hullSides = [LEFT,FRONT,0]);
      refWeb(5, WebThickness, 3.8, BOTTOM, R1+1, C0+1, LEFT,  direction = false, Hulls = true, hullSides = [LEFT,BACK,0]);
   } 
}

module BuildPCBExrta(plateThickness, offsets, sides = TOP)
{
  refDim = PlateDimension +[0,0,offsets];
  buildDim = [PlateDimension[0], PlateDimension[1]-3.9, plateThickness];
  buildDim2 = [PlateDimension[0]-3.9, PlateDimension[1], plateThickness];
  
  module modPlate(Hulls = true, hullSides = [0,0,0],rows = 0, cols = 0 ){ //shorthand call 
    BuildRmCn(rows, cols){
    if(Clipped[rows][cols] == 0){
      modulate(refDim, [0,0,TOP], buildDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if( ClippedOrientation[rows][cols] == false) {
      modulate(refDim,[sign(Clipped[rows][cols]), 0, BOTTOM], buildDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      modulate(refDim,[0,sign(Clipped[rows][cols]),BOTTOM], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]), BOTTOM], Hull = Hulls, hullSide = hullSides);
      }
    }
  }
//   ShiftTrans(){ //C0R2
//      refWeb(plateThickness, WebThickness, offsets, BOTTOM, R2,   C0,   RIGHT, direction = true,  Hulls = true, hullSides = [RIGHT,BACK,BOTTOM]);
//      refWeb(plateThickness, WebThickness, offsets, BOTTOM, R2,   C0,   RIGHT, direction = true,  Hulls = true, hullSides = [RIGHT,FRONT,BOTTOM]);
//      refWeb(plateThickness, WebThickness, offsets, BOTTOM, R1,   C0+1, LEFT,  direction = false, Hulls = true, hullSides = [LEFT,FRONT,BOTTOM]);
//      refWeb(plateThickness, WebThickness, offsets, BOTTOM, R1+1, C0+1, LEFT,  direction = false, Hulls = true, hullSides = [LEFT,BACK,BOTTOM]);
//   } 
////  #hull(){ //T2R3  <-> T0R3
//    PlaceOnThumb(R5)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [FRONT,RIGHT,BOTTOM]);
//    PlaceOnThumb(R5)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [FRONT,LEFT,BOTTOM]);
//    PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [BACK,RIGHT,BOTTOM]);
//    PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [BACK,LEFT,BOTTOM]);
////  }
   //  #hull(){ //T2R3  <-> T0R3
//    PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,BOTTOM]);
//    ShiftTrans()BuildRmCn(R1, C1)modulate(refDim, [0,0,sides], buildDim2, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,BOTTOM]);
//    PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,BOTTOM]);
//    ShiftTrans()BuildRmCn(R1, C1)modulate(refDim, [0,0,sides], buildDim2, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,BOTTOM]);
//  }
//   
////  #hull(){ //T2R3  <-> T0R3
//    PlaceOnThumb(R2)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], buildDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [FRONT,RIGHT,BOTTOM]);
//    PlaceOnThumb(R2)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], buildDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [FRONT,LEFT,BOTTOM]);
//    PlaceOnThumb(R0)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], buildDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [BACK,RIGHT,BOTTOM]);
//    PlaceOnThumb(R0)modulate(refDim-[0,3.9,0], [0,RIGHT,sides], buildDim+[0,10,0], [0,LEFT,BOTTOM],Hull = true, hullSide = [BACK,LEFT,BOTTOM]);
////  }
////  #hull(){ //T3R3  <-> T5R3
//    PlaceOnThumb(R3)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,BOTTOM]);
//    PlaceOnThumb(R5)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,BOTTOM]);
//    PlaceOnThumb(R3)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,BOTTOM]);
//    PlaceOnThumb(R5)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,BOTTOM]);
////  }
//  { //T4R3  <-> T2R3
//    PlaceOnThumb(R2)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,BOTTOM]);
//    PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,BOTTOM]);
//    PlaceOnThumb(R2)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,BOTTOM]);
//    PlaceOnThumb(R4)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,BOTTOM]);
//  }
}

//-----------------   Experimental shenanigans
module BuildFlick(plateThickness, offsets, sides = TOP, rows = 0, cols = 0){
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [PlateDimension[0], PlateDimension[1], plateThickness];

  module modPlate(Hulls = true, hullSides = [0,0,0]){//shorthand call 
    if(Clipped[rows][cols] == 0){
      modulate(refDim, [0,0,TOP], buildDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if( ClippedOrientation[rows][cols] == false) {
      modulate(refDim,[sign(Clipped[rows][cols]), 0, TOP], buildDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      modulate(refDim,[0,sign(Clipped[rows][cols]),TOP], buildDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]), BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }
  BuildRmCn(rows, cols-1)modPlate(Hulls = false);  
  hull(){
    BuildRmCn(rows-1, cols)modPlate(Hulls = true, hullSides = [LEFT,0,0]);
    BuildRmCn(rows, cols-1)modPlate(Hulls = true, hullSides = [RIGHT,BACK,0]);
  }
  hull(){
    BuildRmCn(rows, cols)modPlate(Hulls = true, hullSides = [LEFT,BACK,0]);
    BuildRmCn(rows-1, cols)modPlate(Hulls = true, hullSides = [LEFT,FRONT,0]);
    BuildRmCn(rows, cols-1)modPlate(Hulls = true, hullSides = [BACK,0,0]);
  }
  hull(){
    BuildRmCn(rows, cols)modPlate(Hulls = true, hullSides = [LEFT,0,0]);
    BuildRmCn(rows, cols-1)modPlate(Hulls = true, hullSides = [BACK,FRONT,0]);
  }  
  hull(){
    BuildRmCn(rows, cols)modPlate(Hulls = true, hullSides = [LEFT,FRONT,0]);
    BuildRmCn(rows, cols-1)modPlate(Hulls = true, hullSides = [0,FRONT,0]);
  }
}

//##################   Section E:: Main Calls    ##################
module BaseTrans() {translate([0,0,35])rotate([0,0,0])children();} //Transform to 
module ShiftTrans() {translate([0,0,0])rotate([45,0,0])children();}

BaseTrans()difference(){
  union(){
    ShiftTrans()BuildTopPlate(keyhole = false, Mount = false, channel = false, platethickness = 3);
    BuildThumbCluster(keyhole = false, track = false, Mount = false, Rotary = false);
    for(cols = C1){
      ShiftTrans(){
//    BuildRmCn(R2,cols-1)rotate([0,0,-90])Switch(colors = "Steelblue",clipLength = 4);
      difference(){
        BuildFlick(PlateDimension[2]+3, 0, TOP, R2, cols);
        BuildRmCn(R2, cols-1)rotate([0,0,-90])Keyhole(clipLength = Clipped[RMAX][cols]);
    }
  }
}
  }
  //<- PCB cuts
  for(cols = [CStart:CEnd]){ShiftTrans()BuildPCBColumn(1.6, 3.8, BOTTOM, cols);} // columnar cuts 
  ShiftTrans()BuildPCBC0(5, 3.8, BOTTOM, R2, cols = C1);    //cuts for C1 and C2 transition
 
  for(cols = [CStart:C3]){ShiftTrans()BuildPCBInter(5, 3.8, 0, 0, BOTTOM, R1, R2, cols);} // cut CnB0 -> CnB0
  ShiftTrans()BuildPCBInter(5, 3.8, 1.5, FRONT, BOTTOM, R0, R0, C5); // cut C5R0 -> C6R0
  ShiftTrans()BuildPCBInter(5, 3.8, 0, 0, BOTTOM, R1, R1, C5); // cut C5R0 -> C6R0
  //special cuts for C4 to C5 trans 
    ShiftTrans()BuildPCBInter(5, 3.8, 0, 0, BOTTOM, R1, R2, C4, RIGHT, RIGHT);
    hull(){
      ShiftTrans()refWeb(5, 2, 3.8, BOTTOM, R1, C4, RIGHT, true, true, [0,FRONT,0]);
      ShiftTrans()refWeb(5, 2, 3.8, BOTTOM, R2, C4, RIGHT, true, true, [0,BACK,0]);
    }
  //<-
  BuildPCBThumb(5, 3.8, BOTTOM);
}

//// for GintsugiColumnar.py output
//color("blue"){
//  for(col = [CStart:CEnd]){
//    for(row = [0:1]){
//      BaseTrans()ShiftTrans()PCBOUT(1.6, 3.8, BOTTOM, col,row);
//    }
//  }
//}
//// for GintsugiInterCol.py output
////color("blue"){
////  for(col = [CStart:CEnd]){
////    for(row = [0:1]){
////      BaseTrans()ShiftTrans()#PCBOUT(1.6, 3.8, BOTTOM, col,row);
////    }
////  }
////}
BaseTrans()BuildPCBExrta(1.6, 3.8, BOTTOM);
          
//##################   Section F:: Key Switches and Caps   ##################  
module BuildSet2()
{
  for(cols = [CStart:CEnd])
  {
    for(rows = [R0:RMAX])
    {
      if ( (rows != R0 || cols != C1) ){
        BuildRmCn(rows, cols)
        if(ClippedOrientation[rows][cols] == true){Switch(colors = "Steelblue", clipLength = Clipped[rows][cols]);}
        else {rotate([0,0,-90])Switch(colors = "Steelblue", clipLength = Clipped[rows][cols]);}
      }
    }
  }
}

module BuildSetCaps()
{
  for(cols = [CStart:CEnd])
  {
    for(rows = [R0:RMAX])
    {
      color()BuildRmCn(rows, cols)
        {translate([0,0,8.9])keycap(rows+cols*(RMAX+1), ClippedOrientation[rows][cols], Clipped[rows][cols]);}
    }
  }
}
//module BuildCap( cols = C1, rows= R0){keycap(rows+cols*(RMAX+1), ClippedOrientation[rows][cols], Clipped[rows][cols]);}

//BaseTrans()ShiftTrans()BuildSet2();
//BaseTrans()ShiftTrans()BuildSetCaps();

//BuildCap(cols = C1, rows= R0);
//BaseTrans()for(i = [0])PlaceOnThumb(Rn = i)Switch([1,1,1],"Steelblue",clipLength = 0);
//BaseTrans()for(i = [1])PlaceOnThumb(Rn = i)rotate([0,0,-90])Switch([1,1,1],"Steelblue",clipLength = 4);
//BaseTrans()for(i = [2])PlaceOnThumb(Rn = i)Switch([1,1,1],"Steelblue");
//BaseTrans()for(i = [3])PlaceOnThumb(Rn = i)Switch([1,1,1],"Steelblue");
//BaseTrans()for(i = [4])PlaceOnThumb(Rn = i)Switch([1,1,1],"Steelblue",clipLength = 0);
//BaseTrans()for(i = [5])PlaceOnThumb(Rn = i)Switch([1,1,1],"Steelblue",clipLength = 0);
//BaseTrans()for(i = [7])PlaceOnThumb(Rn = i)RotaryEncoder(stemLength= 7, Wheel = 20);

//BaseTrans()for(i = [0,2,4])PlaceOnThumb(Rn = i, stick =true);
////
//translate([0,15,70])rotate([20,0,0])rotate([-90,40,0]){
//  %blob();
//  color("gold")pinkie_palm_ring();
//  color("gold")thumb_ring2();
////
//  color("gold")palm_ring1();
////  color("gold")palm_ring2();
//}