use <Switch.scad> //modules for mx switch and key holes o
//use <Keycaps.scad>
use <PalmRest.scad>

//TODOs
/* 

*/

$fn = 32;  //cyl res
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
                [22.5,  0,  0], //Ring Mod
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
                [[  -48,  42,  11], [0, 0,   0], [ 0, 90,  0]], //INDEX 1 
                [[  -32,  40,   4], [0, 0,   0], [ 0, 90,  0]], //INDEX 2 knuckle
                [[  -19,  41,   3], [0, 0,   0], [ 0, 90,  0]], //INDEX 3 knuckle
                [[   -4,  36,   2], [0, 0,   0], [ 0, 90,  0]], //MIDDLE knuckle
                [[   13,  37,  -5], [0, 0, -10], [ 0, 90,  0]], //RING knuckle
                [[   38,  20,   2], [0, 0, -42], [ 0, 90,  9]], //PINKY 1 knuckle   [ 38.5,  24,  -5]
                [[   51, 5.5,  -0], [0, 0, -43], [ 0, 90,  9]], //PINKY 2 knuckle
                [[   -6, -68,  14], [0, 0,   0], [90,  0,  0]]  //Thumb wrist origin
               ];

// structure to pass to thumbplacement module
ThumbPosition = 
 [//[[thetaDist, thetaMed, thetaProx, phiProx][rotation angle][rotation angle2][translation vec], clipLen, clip orientation] 
   //[15, 30, 35,   0] nutral position
    [[ 5,  5, 25,  7], [ 0, -90, 0], [  0,  0, 0], [   0,   -2, -PlateHeight-11]], //T0 neutral face flextion 
    [[ 5,  5, 25,  7], [ 0, -90, 0], [ 25,  0, 0], [   0,   16, -PlateHeight-6 ]], //T1 neutral tip flextion 
    [[ 5,  5, 25, 12], [ 0, -90, 0], [ 25,  5, 0], [-5.5, 19.5, -PlateHeight   ]], //T2 neutral tip adduction flextion
    [[ 5,  5, 25, 10], [ 0, -90, 0], [  0,  0, 0], [-4.7,   -2, -PlateHeight-9 ]], //T3 nuetral Extention  adduction  
    [[ 5,  5, 25,  7], [ 0, -90, 0], [-10,  0, 0], [   0,  -18, -PlateHeight-9 ]], //T4 nuetral midial flextion
    [[ 0,  5, 25,  0], [ 0, -90, 0], [ 15,-32, 0], [   6,    9, -PlateHeight-8 ]], //T5 nuetral face abduction flextion
    
    [[ 0,  0, 27,  3], [ 0, -80, 0], [ 55,  0, 0], [   0,   29, -PlateHeight-6 ]],   //T6 
    [[ 5,  5, 25,  0], [ 0, -90, 0], [  0,  0, 0], [   5,  -15, -PlateHeight-13]], //T7 
    [[15, 30, 35,  0], [ 0,  20, 0], [  0, 90, 0], [ -31,-30.5, -PlateHeight-22]], //T7 RotarySwitch test placement 2
    [[15, 30, 35,  0], [ 0, -25, 0], [  0,  0, 0], [ -13, -5.5, -PlateHeight-13]], //T2 Tertiary palm when clipped T1
    [[ 5,  5, 25,  7], [ 0, -90, 0], [-10,  0, 0], [ -20,  -18, -PlateHeight-10]], //mount 
 ];

//-------  design and adjustment parameters 
//Angles used in the pathfunction  
//               C0   C1   C2   C3    C4    C5   C6
//               i1   i2   i3    m     r    p1   p2
//ThetaR0    = [ 90,  90,  90,  92,   90,  100,  90]; //set Row 0 Angle for path function input
ThetaR0      = [ 90,  90,  95,  95,   95,  100,  90]; //set Row 0 Angle for path function input
ThetaR2      = [ 65,  58,  63,  66, 61.5,   61,  50]; //set Row 2 Angle for path function input
Phi2Shift    = [180,   0, 180, 180,    0,    0,   0]; //ad hoc solution when solver return phase shifted
ThetaR1Shift = [ -1,  -1,  -1,-1.5, -4.7, -3.5,  -2];  //set adjustment angle calculated R1 Angle
ThetaR3Shift = [-12, -10, -11,  -0,   -5,  -18, -24];  //set adjustment angle calculated R3 Angle
ThetaR4Shift = [  0,   0,   0,   0,    0,    0,   0];  //set adjustment angle calculated R4 Angle
ThetaRoll    = [ 40,  20,  10,   9,   10,    7, -20];  //column rolling angle for the keysz

RowInits     = [ R2,  R1,  R0,  R0,    R0,  R1,  R1];
RowEnds      = [ R2,  R2,  R2,  R2,    R2,  R2,  R1];

      
//Manual Adjustment of Pitches post Calculation for minor adjustment
ThetaKnock   =[[  0,   0,  -5, -30,  -25,  -5,  -40],  //R0s 
               [  0,   0,   0,   0,    0,   0,    0],  //R1s
               [  0,   0,  -5,   0,  -15,   5,    2],  //R2s  
               [  0,   0,  -5,   0,   -5,   5,    5],  //R3
               [  0,   0,   0,   0,    0,   0,    0]   //R4
              ]; 

KeycapOffset = [  0,   0,   0,   0,    5,   2,    2]; //adjust path radius 
PathList     = [  0,   0,   0,   1,    2,   3,    3]; //Path function to apply on column

//Manual Adjustment of Pitches post Calculation for minor adjustment               
Clipped      =[[  4,   4,  -4,  -4,  -4,  -4,   -4,  0],  //R0
               [  4,   4,  -4,  -4,  -4,  -4,   -4,  4],  //R1s
               [  4,   4,  -4,  -4,   0,   0,   -4, -4],  //R2s 
               [  4,   4,   4,   4,   4,   4,   -4, -4],  //R3
               [  0,   0,   0,   0,   0,   0,   -4, -4],  //R4
               [  0,   0,   0,   0,   0,   0,   -4,  4],  //R5
               [  0,   0,   0,   0,   0,   0,   -4,  4],  //R6
               [  0,   0,   0,   0,   0,   0,   -4,  4]   //R7
              ];

//Orientation of the clippede switches

SwitchOrientation = //if length-wise true 
              [[false, false, false, false, false, false, false, false],  
               [true,  false, false, false, false, true,  false, true],
               [false, false, false, false, true,  true,  false, false],
               [false, false, false, true,  true,  true,  false, false],
               [false, false, false, false, false, true,  false, true],
               [false, false, false, false, false, true,  false, false],
               [false, false, false, false, false, true,  false, true],
               [false, false, false, false, false, true,  false, false]
              ]; 
               
//              R0,  R1,  R2,  R3,  R4
ThetaOffset  = [90,   0,   0,   0,  90]; // initial switch pitch angle 
PathSideRm   = [IN, OUT, OUT, OUT, OUT]; // switch placement Path 

//structure to hold height of keyswitches relative to the path functions 
//R0 is set at switch bottom while the rest is neutral  

KeyOriginCnRm = [for( i= [C0:C6])[[0,BottomHeight+KeycapOffset[i],0], for(j = [R1:R4])[0,TopHeight+KeycapOffset[i],0]]];
//row and column loop setter
RMAX         = R2;  // Set max rows on columns
CStart       = C0;  // Set column to begin looping for the build
CEnd         = C6;  // Set column to end for the build
ThetaFlick   = 90;   
C3R3         = false;
C4R3         = false;
  
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
  VecTranR0 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR0[col], KeyOriginCnRm[col][R0], PathList[col], PathSideRm[R0], ThetaOffset[R0])]; //V1)
  VecTranR2 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR2[col], KeyOriginCnRm[col][R2], PathList[col], PathSideRm[R2], ThetaOffset[R2])]; //V1)
  VecRotR0 =  [for (col = [C0:C6])
                [0,0,atan(derPathY(ThetaR0[col], PathList[col], PathSideRm[R0])/derPathX(ThetaR0[col], PathList[col],PathSideRm[R0]))+ThetaOffset[R0]]
              ];
  VecRotR2 =  [for (col = [C0:C6]) 
                [0,0,atan(derPathY(ThetaR2[col], PathList[col], PathSideRm[R2])/derPathX(ThetaR2[col], PathList[col],PathSideRm[R2]))+ThetaOffset[R2]]
              ];

  // angle with respect to intermediate joint
  phiR0 = [for (col = [C0:C6]) atan((VecTranR0[col][1])/(VecTranR0[col][0]-FingerLength[col][0]))+180];  //TODO fix the FingerLength calls so that it wont affect this solvers
  phiR2 = [for (col = [C0:C6]) atan((VecTranR2[col][1])/(VecTranR2[col][0]-FingerLength[col][0]))+Phi2Shift[col]];
  phiR1 =  (phiR0 - phiR2)/2+phiR2;
  phiR3 = -(phiR0 - phiR2)/2+phiR2;
  phiR4 =  (phiR0 - phiR2)/2+phiR3;

  // recur solver check tol condition else repeat.  parm: x = init guess Tol = solution tolarence, col = column to be solved
  function Newton_Raphson1(x, Tol, col) = 
    PathStruct(x)[PathList[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR1[col])/sin(phiR1[col]-x) < Tol ? x :  Newton_Raphson1(x - (PathStruct(x)[PathList[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR1[col])/sin(phiR1[col]-x))/(PathStruct(x)[PathList[col]][OUT][NORMAL] - FingerLength[col][0]*sin(phiR1[col])/tan(phiR1[col]-x)/cos(phiR1[col]-x)), Tol,col);

  function Newton_Raphson3(x, Tol, col) = 
    PathStruct(x)[PathList[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR3[col])/sin(phiR3[col]-x) < Tol ? x :  Newton_Raphson3(x - (PathStruct(x)[PathList[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR3[col])/sin(phiR3[col]-x))/(PathStruct(x)[PathList[col]][OUT][NORMAL] - FingerLength[col][0]*sin(phiR3[col])/tan(phiR3[col]-x)/cos(phiR3[col]-x)), Tol,col);

  function Newton_Raphson4(x, Tol, col) = 
    PathStruct(x)[PathList[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR4[col])/sin(phiR4[col]-x) < Tol ? x :  Newton_Raphson4(x - (PathStruct(x)[PathList[col]][OUT][PATH] - FingerLength[col][0]*sin(phiR4[col])/sin(phiR4[col]-x))/(PathStruct(x)[PathList[col]][OUT][NORMAL] - FingerLength[col][0]*sin(phiR4[col])/tan(phiR4[col]-x)/cos(phiR4[col]-x)), Tol,col);
  
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
  VecTranR1 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[R1][col], KeyOriginCnRm[col][R1], PathList[col], PathSideRm[R1], ThetaOffset[R2])]; //V1)
  VecTranR3 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[R3][col], KeyOriginCnRm[col][R3], PathList[col], PathSideRm[R3], ThetaOffset[R2])]; //V1)
  VecTranR4 = [for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[R4][col], KeyOriginCnRm[col][R4], PathList[col], PathSideRm[R4], ThetaOffset[R2])]; //V1)
    
//  VecTransRnTest  = [for (row = [R0:R4]) for (col = [C0:C6]) VectorTransformOrigin(ThetaRn[row][col], [0,0,0], PathList[col], PathSideRm[row], ThetaOffset[row])];
  
  VecTranR0c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR0[col], [0,0,0], PathList[col], PathSideRm[R0], ThetaOffset[R0])]; 
  VecTranR1c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR1[col], [0,0,0], PathList[col], PathSideRm[R1], ThetaOffset[R1])]; 
  VecTranR2c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR2[col], [0,0,0], PathList[col], PathSideRm[R2], ThetaOffset[R2])]; 
  VecTranR3c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR3[col], [0,0,0], PathList[col], PathSideRm[R3], ThetaOffset[R3])]; 
  VecTranR4c = [for (col = [C0:C6]) VectorTransformOrigin(ThetaR4[col], [0,0,0], PathList[col], PathSideRm[R4], ThetaOffset[R4])]; 
                  
  VecRotR1 = [for (col = [C0:C6]) [0,0,atan(derPathY(ThetaR1[col], PathList[col], PathSideRm[R1])/derPathX(ThetaR1[col], PathList[col],PathSideRm[R1]))+ThetaOffset[R1]]];
  VecRotR3 = [for (col = [C0:C6]) [0,0,atan(derPathY(ThetaR3[col], PathList[col], PathSideRm[R3])/derPathX(ThetaR3[col], PathList[col],PathSideRm[R3]))+ThetaOffset[R3]]];
  VecRotR4 = [for (col = [C0:C6]) [0,0,atan(derPathY(ThetaR4[col], PathList[col], PathSideRm[R4])/derPathX(ThetaR4[col], PathList[col],PathSideRm[R4]))+ThetaOffset[R4]]];

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
    translate(hadamard(referenceDimension, referenceSide/2))
      translate(hadamard(objectDimension,objectSide / 2))
        cube(objectDimension, center = true);
  }else{
    color("red")translate(hadamard(referenceDimension, referenceSide/2))
      translate(hadamard(objectDimension, objectSide/2))
      hullPlate(objectDimension, hullSide);
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
  translate(ColumnOrigin[T0][0])
    rotate(ColumnOrigin[T0][1])
      OnThumb(
        ThumbPosition[Rn][0][0],
        ThumbPosition[Rn][0][1],
        ThumbPosition[Rn][0][2],
        ThumbPosition[Rn][0][3], 
        stick
      )
        rotate(ThumbPosition[Rn][1])
          translate(ThumbPosition[Rn][3])
            rotate(ThumbPosition[Rn][2])
              children(); 
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

module BuildColumn(plateThickness, offsets, sides =TOP, col=0, rowInit = R0, rowEnd = RMAX){
  
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [PlateDimension[0], PlateDimension[1], plateThickness];
  
  //sub modules to simplify the modulate calls for this build
  module modPlateLen(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for length-wise clipping 
    modulate(
      refDim,
      [0,sign(Clipped[rows][cols]),sides], 
      buildDim-[0,abs(Clipped[rows][cols]),0], 
      [0,-sign(Clipped[rows][cols]),BOTTOM], 
      Hull = Hulls, 
      hullSide = hullSides);
  } //use clip length sign to direct transform sides and adjust platle length rather than if else statement for more compact call 
  
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    modulate(
      refDim,
      [sign(Clipped[rows][cols]), 0, sides], 
      buildDim-[abs(Clipped[rows][cols]),0,0], 
      [-sign(Clipped[rows][cols]), 0, BOTTOM], 
      Hull = Hulls,
      hullSide = hullSides);
  }
  
  //Actual Builds
  for (row = [rowInit:rowEnd]){// Plate
    if (SwitchOrientation[row][col] == true){ //for length-wise Clip
      BuildRmCn(row, col)modPlateLen(Hulls = false, rows =row, cols = col);  
      if (row < rowEnd){//Support struct
        hull(){
          BuildRmCn(row,   col)modPlateLen(Hulls = true, hullSides = [0,FRONT,0], rows = row,   cols = col);
          BuildRmCn(row+1, col)modPlateLen(Hulls = true, hullSides = [0,BACK,0],  rows = row+1, cols = col);
        }
      }
    }else { // for Width-wise Clip
      BuildRmCn(row, col)modPlateWid(Hulls = false, rows =row, cols = col);  
      if (row < rowEnd){//Support struct
        hull(){
          BuildRmCn(row,   col)modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows = row,   cols = col);
          BuildRmCn(row+1, col)modPlateWid(Hulls = true, hullSides = [0,BACK,0],  rows = row+1, cols = col);
        }
      }
    }
  }
}

module refWeb (plateThickness, webWidth, offsets, sides =TOP, rows , cols, corner = RIGHT, direction = true, Hulls = false, hullSides = [0,0,0]) {
  
  //Variables
  refDim   = PlateDimension + [0,0,offsets];
  buildDim = [webWidth, PlateDimension[1], plateThickness];
  
  BuildRmCn(rows, cols){
    if (SwitchOrientation[rows][cols] == true){ //for length-wise Clip
      modulate(
        refDim,
        [ corner,  sign(Clipped[rows][cols]),sides], 
        buildDim-[0,abs(Clipped[rows][cols]),0], 
        [-corner, -sign(Clipped[rows][cols]), BOTTOM],
        Hull = Hulls,
        hullSide = hullSides
      );
      
    } else if (direction == true) {
      translate([max(Clipped[rows][cols]/2,0), 0, 0])
        modulate(
          refDim,
          [ corner, sign(Clipped[rows][cols]),sides], 
          buildDim,
          [-corner,-sign(Clipped[rows][cols]),BOTTOM],
          Hull = Hulls,
          hullSide = hullSides
      );
      
    } else {
      translate([min(-abs(Clipped[rows][cols])/2,0), 0, 0])
        modulate(
          refDim,
          [ corner, sign(Clipped[rows][cols]),sides],
          buildDim,
          [-corner,-sign(Clipped[rows][cols]),BOTTOM],
          Hull = Hulls,
          hullSide = hullSides
      );
      
    }
  }
}

//called to generate hull between columns, rather than surface hull, offsetted cube is used to create thicker support
module BuildWebs(plateThickness, webWidth, offsets, sides =TOP, col=C0, rowInit = R0, rowEnd = RMAX){
  
  //Variables
  refDim   = PlateDimension +[0,0,offsets];
  buildDim = [webWidth, PlateDimension[1], plateThickness];
  
  //submodule to simplify module() calls
  module buildWeb(rows , cols, corner = RIGHT, direction = true, Hulls = false, hullSides = [0,0,0]) { 
    if (SwitchOrientation[rows][cols] == true){ //for length-wise Clip
      BuildRmCn(rows, cols)
        modulate(
          refDim,
          [ corner, sign(Clipped[rows][cols]),sides], 
          buildDim-[0,abs(Clipped[rows][cols]),0], 
          [-corner,-sign(Clipped[rows][cols]),BOTTOM], 
          Hull = Hulls, 
          hullSide = hullSides
      );
    } else if (direction == true ){
      BuildRmCn(rows, cols)
        translate([max(Clipped[rows][cols]/2,0),0,0])
          modulate(
            refDim,
            [ corner, sign(Clipped[rows][cols]),sides],
            buildDim, 
            [-corner,-sign(Clipped[rows][cols]),BOTTOM], 
            Hull = Hulls, 
            hullSide = hullSides
     );
    } else {
      BuildRmCn(rows, cols)
        translate([min(-abs(Clipped[rows][cols])/2,0),0,0])
          modulate(
            refDim,
            [ corner, sign(Clipped[rows][cols]),sides],
            buildDim,
            [-corner,-sign(Clipped[rows][cols]),BOTTOM], 
            Hull = Hulls, 
            hullSide = hullSides
       );
    }
  }

  //Actual Builds 
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

module BuildChannels(plateThickness){// cut away for wirings
  //row-wise channels
  //offset the web call to center rather then sides
  
  //submodule to simplify build
  module ModChan(rows = R0,  cols = C0, adjust = [0,0,0], side = [0,0,0]){
    //Variables
    cWidth   = 2; //channel cut width
    cDepth   = 4; //channel cut depth
    refDim   = PlateDimension +[0,0,plateThickness+3];
    buildDim = [cWidth, cWidth, cDepth];
    
    BuildRmCn(rows, cols)
      modulate(
        refDim+adjust,
        [side[0],side[1],BOTTOM], 
        buildDim, 
        [side[0],-side[1],0],
        Hull = false
      );
  }
  
  // build inter-row channel
  for(col = [C1:C4]){
    for(row =  [RowInits[col]:RowEnds[col]]){

      if(row != RowEnds[col]){
        hull(){
          ModChan(rows = row,   cols = col, adjust = [-15,0,0], side = [RIGHT,FRONT, 0]);
          ModChan(rows = row+1, cols = col, adjust = [-15,0,0], side = [RIGHT,BACK,0]);
        }
      }
    }
  }
  // C5 
  hull(){
    ModChan(rows = R0, cols = C5, adjust = [-10,0,0], side = [RIGHT,FRONT, 0]);
    ModChan(rows = R1, cols = C5, adjust = [-10,0,0], side = [RIGHT,BACK,0]);
  }
  hull(){
    ModChan(rows = R1, cols = C5, adjust = [-14,-8,0], side = [LEFT,FRONT, 0]);
    ModChan(rows = R2, cols = C5, adjust = [-14, 0,0], side = [LEFT,BACK,0]);
  }
  
  // build inter-column channel
  //C0
   hull(){
    ModChan(rows = R2, cols = C0, adjust = [-10,-8,1], side = [RIGHT,FRONT,0]);
    ModChan(rows = R2, cols = C1, adjust = [-4,-8,1], side = [LEFT,BACK,0]);
  }
  hull(){
    ModChan(rows = R2, cols = C0, adjust = [-10,-5,0], side = [RIGHT,BACK,0]);
    ModChan(rows = R1, cols = C1, adjust = [-4,-8,0], side = [LEFT,FRONT,0]);
  }
  //C1
  hull(){
    ModChan(rows = R2, cols = C1, adjust = [-10,-8,0], side = [RIGHT,BACK,0]);
    ModChan(rows = R2, cols = C2, adjust = [-12,-8,0], side = [LEFT,BACK,0]);
  }
  //C2
  hull(){
    ModChan(rows = R0, cols = C2, adjust = [-6,-8,0], side = [RIGHT,BACK,0]);
    ModChan(rows = R0, cols = C3, adjust = [-8,-8,0], side = [LEFT,BACK,0]);
  }
   hull(){
    ModChan(rows = R2, cols = C2, adjust = [-6,-8,0], side = [RIGHT,BACK,0]);
    ModChan(rows = R2, cols = C3, adjust = [-8,-8,0], side = [LEFT,BACK,0]);
  } 
  //C3
  for(rows = [R0:R1]){
    hull(){
      ModChan(rows = rows, cols = C3, adjust = [-8,-8,0], side = [RIGHT,BACK,0]);
      ModChan(rows = rows, cols = C4, adjust = [-12,-8,0], side = [LEFT,BACK,0]);
    }
  }
  hull(){
      ModChan(rows = R2, cols = C3, adjust = [-8,-8,0], side = [RIGHT,BACK,0]);
      ModChan(rows = R2, cols = C4, adjust = [-8,-8,0], side = [LEFT,BACK,0]);
  }
  //C4
  hull(){
    ModChan(rows = R0, cols = C4, adjust = [-6,-8,0], side = [RIGHT,BACK,0]);
    ModChan(rows = R0, cols = C5, adjust = [-12,-8,0], side = [LEFT,BACK,0]);
  }
  ModChan(rows = R1, cols = C4, adjust = [-2,-8,0], side = [RIGHT,FRONT,0]);
  //C5
  hull(){
    ModChan(rows = R2, cols = C4, adjust = [-6,-8,1], side = [RIGHT,FRONT,0]);
    ModChan(rows = R2, cols = C5, adjust = [-12,-8,1], side = [LEFT,FRONT,0]);
  }
  //C6
  hull(){
    ModChan(rows = R0, cols = C5, adjust = [-4,-8,1], side = [RIGHT,BACK,0]);
    translate([5,-1,-8])ModChan(rows = R0, cols = C6, adjust = [-3,0,10], side = [LEFT,BACK,0]);
  }
  hull(){
    ModChan(rows = R1, cols = C5, adjust = [-6,-8,1], side = [RIGHT,FRONT,0]);
    ModChan(rows = R1, cols = C6, adjust = [-12,-8,1], side = [LEFT,FRONT,0]);
  }
}

module BuildChannelsThumb(plateThickness){// cut away for wirings
  //row-wise channels
  //offset the web call to center rather then sides
 
  //submodule to simplify build
  module ModChan(rows = R0, adjust = [0,0,0], side = [0,0,0]){
    //Variables
    cWidth   = 2; //channel cut width
    cDepth   = 2; //channel cut depth
    refDim   = PlateDimension +[0,0,plateThickness+3];
    buildDim = [cWidth, cWidth+4, cDepth];
    
    PlaceOnThumb(rows)
      modulate(
        refDim+adjust,
        [side[0],side[1],BOTTOM], 
        buildDim, 
        [side[0],-side[1],0],
        Hull = false
      );
  }
  
  //Builds
  hull(){
    ModChan(rows = 5, adjust = [-11,-16,-3], side = [RIGHT,FRONT,0]);
    ModChan(rows = 1, adjust = [-12,-16,4], side = [LEFT,FRONT,0]);
  }
}
//build surfaces used to cut top surface of plates and web. 
// !TODO utilize Hull rather than innerWebDim.incorrect behavior at C0
module BuildInnerWebs(col, sides = RIGHT){
  innnerWebDim = [HullThickness,PlateDimension[1],HullThickness];
  refDim       = PlateDimension;
  function ClipRef(rows,cols) = sides == RIGHT ? [-sides*max((Clipped[rows][cols]),0),0,0] : [min((Clipped[rows][cols])/2,0),0,0];
  hull()
  {
    for(row = [R0:RMAX]) 
    {
      if (SwitchOrientation[row][col] == true){ //for length-wise Clip
        BuildRmCn(row, col)modulate(refDim,[sides,sign(Clipped[row][col]),TOP], innnerWebDim-[0,abs(Clipped[row][col]),0], [-sides,-sign(Clipped[row][col]),TOP]);
      }else { 
        BuildRmCn(row, col)translate(ClipRef(row,col))modulate(refDim,[sides,sign(Clipped[row][col]),TOP], innnerWebDim, [-sides, -sign(Clipped[row][col]),TOP]);
      }
    }
    
    if (SwitchOrientation[R0][col] == true){
      BuildRmCn(R0, col)modulate(refDim,[sides,BACK,TOP], innnerWebDim-[0,abs(Clipped[R0][col]),0], [-sides,0,TOP]);
    }else {
      BuildRmCn(R0, col)translate(ClipRef(R0,col))modulate(refDim,[sides,BACK,TOP], innnerWebDim, [-sides,0,TOP]);
    }
    if (SwitchOrientation[R3][col] == true){
      BuildRmCn(R3, col)modulate(refDim,[sides,FRONT,TOP], innnerWebDim-[0,abs(Clipped[R3][col]),0], [-sides,0,TOP]);
    }else {
//      BuildRmCn(R3, col)translate(ClipRef(R3,col))modulate(refDim,[sides,FRONT,TOP], innnerWebDim, [-sides,0,TOP]);
    }
  }
}

//################ Main Builder ############################
module BuildThumbCluster(sides = 0,  offsets = 0, frameThickness = PlateDimension[2], Mount = false, track = true, Rotary = false){
  refDim      = PlateDimension + [0,0,offsets];
  frameDim    = [PlateDimension[0], PlateDimension[1], frameThickness];
  plateDim    = PlateDimension + [0,0,3];
  plateDimLow = PlateDimension + [0,0,2];
  cutDim      = PlateDimension + [0,0,5];
  trackDim    = [26.5, 28, 1];
  TMAX        = 5;

  module modPlate(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call 
    if(Clipped[rows][cols] == 0){
      PlaceOnThumb(rows)modulate(PlateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if( SwitchOrientation[rows][cols] == false) {
      PlaceOnThumb(rows)modulate(refDim,[sign(Clipped[rows][cols]), 0, TOP], plateDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      PlaceOnThumb(rows)modulate(refDim,[0,sign(Clipped[rows][cols]),TOP], plateDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]), BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }
  
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    BuildRmCn(rows, cols)modulate(PlateDimension,[sign(Clipped[rows][cols]), 0, TOP], plateDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  
  difference(){ //R0~R3 hull 
    union(){
      //upper keyplates
      for(i = [R0,R1,R4,R5,6,7]){modPlate(Hulls = false, rows = i, cols = T0);} //main plate    
      
      //<-inter plate hulls
        hull(){      
          modPlate(Hull = true, hullSides = [0,BOTTOM,0], rows = R1, cols = T0);
          modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R0, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [0,BOTTOM,0], rows = R0, cols = T0);
          modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R4, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [TOP,BOTTOM,0], rows = R0, cols = T0);
          modPlate(Hull = true, hullSides = [TOP,0,0], rows = R4, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [TOP,0,0], rows = R1, cols = T0);
          modPlate(Hull = true, hullSides = [BOTTOM,0,0], rows = R5, cols = T0);
        }
        hull(){               
          modPlate(Hull = true, hullSides = [BOTTOM,FRONT,0], rows = R0, cols = T0);
          modPlate(Hull = true, hullSides = [BOTTOM,BACK,0], rows = R1, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [0,BOTTOM,0], rows = 6, cols = T0);
          modPlate(Hull = true, hullSides = [0,FRONT,0], rows = R1, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [0,BACK,0], rows = 7, cols = T0);
          modPlate(Hull = true, hullSides = [TOP,BACK,0], rows = R4, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [BOTTOM,0,0], rows = 7, cols = T0);
          modPlate(Hull = true, hullSides = [TOP,0,0], rows = R4, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [0,FRONT,0], rows = 7, cols = T0);
          modPlate(Hull = true, hullSides = [0,BACK,0], rows = R5, cols = T0);
        }
        hull(){      
          modPlate(Hull = true, hullSides = [0,FRONT,0], rows = 7, cols = T0);
          modPlate(Hull = true, hullSides = [TOP,0,0], rows = R0, cols = T0);
          modPlate(Hull = true, hullSides = [BOTTOM,BACK,0], rows = R5, cols = T0);
        }
      //<-End inner hull

      //attachement to main columns 
        hull(){               
          modPlate(Hull = true, hullSides = [TOP,BACK,0], rows = R1, cols = T0);
          modPlate(Hull = true, hullSides = [TOP,FRONT,0], rows = R0, cols = T0);
          modPlate(Hull = true, hullSides = [BOTTOM,BACK,0], rows = R5, cols = T0);
        }
        
        hull(){
          ShiftTrans()modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows =R2, cols = C0);  
          ShiftTrans()refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R1, cols = C1, corner = LEFT, direction = true, Hulls = true, hullSides = [LEFT,FRONT,0]);
          ShiftTrans()refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R1, cols = C1, corner = LEFT, direction = true, Hulls = true, hullSides = [LEFT,BACK,0]);  
          modPlate(Hull = true, hullSides = [TOP,0,0], rows = 6, cols = T0); 
        }
        
      if(Mount == true){ 
        hull(){
          modPlate(Hull = false, hullSides = [BOTTOM,0,0], rows = R4, cols = T0);
          modPlate(Hull = false, hullSides = [BOTTOM,0,0], rows = R0, cols = T0);
          PlaceOnThumb(10)translate([0,0,-1])cylinder(d = 10, 7, center = true);
        }
      }         

    }
    union(){//cuts
    //Column Cuts
    //bottom plate cuts
      for (i = [R0,R1,R4,R5,6,7]){//keyholes
        if(SwitchOrientation[i][T0] == true){
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
//      if(Rotary == true){PlaceOnThumb(7)scale(1.02)RotaryEncoder(stemLength= 0, Wheel = 0);}
    }
  } // end cut
}

module BuildTopPlate(keyhole = false, Mount = true, channel = false, , Promicro =true, platethickness = 0){
  plateDim = PlateDimension +[0,0,1];
  
  //submodules 
  module modPlate(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand
    BuildRmCn(rows, cols)modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim-[0,abs(Clipped[rows][cols]),-platethickness+1], [0,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    BuildRmCn(rows, cols)modulate(PlateDimension,[sign(Clipped[rows][cols]), 0, TOP], plateDim-[abs(Clipped[rows][cols]),0,-platethickness+1], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  module refWebs(row, col, corn, dir =true, Hull = false, hullSide = [0,0,0]) {// shorthand for s
    refWeb(PlateDimension[2]+platethickness, WebThickness, 0, TOP, rows = row, cols = col, corner = corn, direction = dir, Hulls = Hull, hullSides = hullSide);
  }
  
  //Builds 
  difference(){
    union(){
      for(cols = [CStart:CEnd]){
        // build columns 
        BuildColumn(PlateDimension[2]+platethickness, 0, TOP, col = cols, rowInit = RowInits[cols], rowEnd = RowEnds[cols]); //build columns 
        if (cols < C5){ // build Webbing
          if (cols == C0){ 
            hull(){
              refWebs(R2, C0, RIGHT, true, true, [0,BACK,0]);
              refWebs(R1, C1, LEFT,  true);          
            }
            hull(){
              refWebs(R2, C0, RIGHT, true, true, [0,0,0]);
              refWebs(R1, C1, LEFT,  true, true, [0,FRONT,0]);          
              refWebs(R2, C1, LEFT,  true, true, [0,BACK,0]);  
            }
            hull(){
              refWebs(R2, C0, RIGHT, true, true, [0,FRONT,0]);
              refWebs(R2, C1, LEFT,  true);  
            } 
            
          }else if (cols == C1){
            BuildWebs(PlateDimension[2]+platethickness, WebThickness, 0, TOP, cols, rowInit = R1, rowEnd = R2);
            
          }else if (cols == C3){
            //Extra bridge for R3
            if(C3R3 == true) {
              translate([4,0,0])modPlate(Hulls = false, hullSides = [0,0,0], rows =R3, cols = C3);
              hull(){
                modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows =R2, cols = C3);
                translate([4,0,0])modPlate(Hulls = true, hullSides = [0,BACK,0], rows =R3, cols = C3);
              }
              hull(){
                refWebs(R2, C2, RIGHT, true, true, [0,FRONT,0]);
//              refWebs(R2, C3, LEFT, false, true, [0,FRONT,0]);
                translate([4,0,0])refWebs(R3, C3, LEFT, true);  
              }
              hull(){
                refWebs(R2, C2, RIGHT, true, true, [0,FRONT,0]);
                refWebs(R2, C3, LEFT, false, true, [0,FRONT,0]);
                translate([4,0,0])refWebs(R3, C3, LEFT, true, true, [0,BACK,0]);  
              }
            }
            //web
            BuildWebs(PlateDimension[2]+platethickness, WebThickness, 0, TOP, cols); 
            
          }else if (cols == C4){//special build for tron mod
            if(C4R3 == true) {
              //Extra bridge for R3
              modPlate(Hulls = false, hullSides = [0,0,0], rows =R3, cols = C4);
              hull(){
                modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows =R2, cols = C4);
                modPlate(Hulls = true, hullSides = [0,BACK,0], rows =R3, cols = C4);
              }
              hull(){
                translate([4,0,0])refWebs(R3, C3, RIGHT, true); 
                refWebs(R3, C4, LEFT, false);   
              }
              hull(){
                refWebs(R2, C3, RIGHT, true, true, [0,FRONT,0]);
                refWebs(R2, C4, LEFT, false, true, [0,FRONT,0]);
                translate([4,0,0])refWebs(R3, C3, RIGHT, true, true, [0,BACK,0]); 
                refWebs(R3, C4, LEFT, false, true, [0,BACK,0]);   
              } 
              hull(){//R2 R3 bridge web  
                refWebs(R2, C4, RIGHT, true, true, [0,FRONT,0]);
                refWebs(R2, C5, LEFT,  true, true, [0,FRONT,0]);  
                refWebs(R3, C4, RIGHT, true, true, [0,BACK,0]);      
              }  
            }
            //Web
            hull(){//R0 web
              refWebs(R0, C4, RIGHT,true, false);
              refWebs(R0, C5, LEFT, false, false);          
            }
            hull(){//R0 R1 bridge web 
              refWebs(R0, C4, RIGHT,true, true, [0,FRONT,0]);
              refWebs(R0, C5, LEFT, false, true, [0,FRONT,0]);  
              refWebs(R1, C4, RIGHT,true, true, [0,BACK,0]);
              refWebs(R1, C5, LEFT, true, true, [0,BACK,0]);               
            }     
            hull(){//R1 web
              refWebs(R1, C4, RIGHT, true, false);
              refWebs(R1, C5, LEFT, true, false);          
            }            
            hull(){//R1 R2 bridge web 
              refWebs(R1, C4, RIGHT, true, true, [0,FRONT,0]);
              refWebs(R1, C5, LEFT,  true, true, [0,FRONT,0]);  
              refWebs(R2, C4, RIGHT, true, true, [0,BACK,0]);
              refWebs(R2, C5, LEFT,  true, true, [0,BACK,0]);          
            }  
            hull(){//R3  bridge web 
              refWebs(R2, C4, RIGHT, true, false);
              refWebs(R2, C5, LEFT,  true, false);          
            }    
          
          }else {
            BuildWebs(PlateDimension[2]+platethickness, WebThickness, 0, TOP, cols);
          }
        }
      }
      //C1 
      refWebs(R0, C2, LEFT, false);
      hull(){
        refWebs(R0, C2, LEFT, false, true, [0,FRONT,0]);
        refWebs(R1, C2, LEFT, false, true, [0,BACK,0]);
      }
      
      //C5 and C6
      BuildRmCn(R0,C5)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C5]),TOP],plateDim+[0,-abs(Clipped[R0][C5]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = false); 
      
      BuildRmCn(R0,C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = false); 

      hull(){
        BuildRmCn(R0,C5)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C5]),TOP],plateDim+[0,-abs(Clipped[R0][C5]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = true, hullSide = [BACK,0,0]); 
         BuildRmCn(R1,C5)rotate([0,0,0])modulate(PlateDimension,[0,sign(Clipped[R0][C5]),TOP],plateDim+[0,-abs(Clipped[R0][C5]),platethickness-1], [0,-sign(Clipped[R0][C5]),BOTTOM], Hull = true, hullSide = [0,BACK,0]); 
      }
      
      hull(){
        BuildRmCn(R0,C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = true, hullSide = [BACK,0,0]); 
         BuildRmCn(R1,C6)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = true, hullSide = [FRONT,0,0]); 
      }
      hull(){
        BuildRmCn(R0,C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = true, hullSide = [BACK,LEFT,0]); 
        BuildRmCn(R1,C6)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = true, hullSide = [FRONT,LEFT,0]); 
        refWebs(R0, C5, RIGHT, false, true, [0,FRONT,0]);
        refWebs(R1, C5, RIGHT, false, true, [0,BACK,0]);
      }
      hull(){
        BuildRmCn(R0,C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),platethickness-1], [0,-sign(Clipped[R0][C6]),BOTTOM], Hull = true, hullSide = [0,LEFT,0]); 
        refWebs(R0, C5, RIGHT, false, true, [0,0,0]);
      }
      hull(){
        refWebs(R1, C5, RIGHT, false, true, [0,0,0]);
        refWebs(R1, C6, LEFT, false, true, [0,0,0]);
      }
      hull(){
        refWebs(R1, C5, RIGHT, false, true, [0,FRONT,0]);
        refWebs(R2, C5, RIGHT, false, true, [0,BACK,0]);
        refWebs(R1, C6, LEFT, false, true, [0,FRONT,0]);
      }
      hull(){
        refWebs(R2, C5, RIGHT, false, true, [0,BACK,0]);
        modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows =R1, cols = C6);
      }
      
      //Prettyborader
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows =R2, cols = C0);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R2, cols = C1, corner = LEFT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
      }      
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows =R0, cols = C3);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,BACK,0]);
      }
      
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows =R2, cols = C2);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R2, cols = C1, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,FRONT,0]);
      }
      
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows =R1, cols = C1);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C2, corner = LEFT, direction = false, Hulls = true, hullSides = [0,FRONT,0]);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R1, cols = C2, corner = LEFT, direction = false, Hulls = true, hullSides = [0,BACK,0]);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R1, cols = C1, corner = LEFT, direction = true, Hulls = true, hullSides = [0,BACK,0]);
      }  
      
      hull(){       
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R2, cols = C5, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,0,0]);
        modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows =R1, cols = C6);
      }  

      //Base Mount point
      BuildRmCn(R0, C6)translate([-2, 9, -12])rotate([-10,0,0])cylinder(d = 15, 15,center = true); //base mount 
      
      hull(){ //palm mount
        BuildRmCn(R0, C6)translate([8,-4,-23+9])rotate([0,90,0])cube([5,18,6], center = true);
        BuildRmCn(R0, C6)translate([8,-7,-23])rotate([0,90,0])cylinder(d = 12, 5,center = true);
      }
      // Track Ball mount 
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows =R0, cols = C4);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C3, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,BACK,0]);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C5, corner = LEFT, direction = false, Hulls = true, hullSides = [0,BACK,0]);
      }
      hull(){
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C2, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,BACK,0]);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C3, corner = RIGHT, direction = true, Hulls = true, hullSides = [0,BACK,0]);
        refWeb(PlateDimension[2]+3, WebThickness, 0, TOP, rows = R0, cols = C5, corner = LEFT, direction = false, Hulls = true, hullSides = [0,BACK,0]);
      }
      
      if(Promicro == true) {
        BuildRmCn(R1, C2){ //micro mount 
          translate([-6.5,   6+9,-3.5])cube([3, 12, 8], center = true);
          translate([-6.5+15,  6,-3.5])cube([3, 30, 8], center = true);
        }
        //trrs mount
        hull(){
          PlaceBetween(R1, C1)translate([3,0,9])cube([14, 10, 5], center = true);
          modPlateWid(Hulls = true, hullSides = [0,FRONT,0], rows = R1, cols =C1);
          modPlateWid(Hulls = true, hullSides = [0,BACK,0], rows = R2, cols = C1);
        }
      }
    }
    
    // !!!CUTS
    union(){
      for(cols = [C5:C6]){//SwitchPlate
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
      //special cuts for C3 and C4 webbing
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,FRONT,TOP], rows =R1, cols = C3);
        modPlateWid(Hulls = true, hullSides = [0,BACK,TOP], rows =R2, cols = C3);
        modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP],  rows =R2, cols = C4);
      }
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,0,TOP], rows =R2, cols = C3);
        modPlate(Hulls = true, hullSides = [LEFT,0,TOP],  rows =R2, cols = C4);
      }
      //special cuts for C4/5 Webbing
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,FRONT,TOP],rows =R0, cols = C4);
        modPlateWid(Hulls = true, hullSides = [0,BACK,TOP], rows =R1, cols = C4);
      }
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,0,TOP],    rows =R0, cols = C4);
        modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP], rows =R1, cols = C5);
      }
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,FRONT,TOP], rows =R0, cols = C4);
        modPlateWid(Hulls = true, hullSides = [0,BACK,TOP],  rows =R1, cols = C4);
        modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP],  rows =R1, cols = C5);
      }
      hull(){
        modPlate(Hulls = true, hullSides = [0,0,TOP],    rows =R2, cols = C4);
        modPlate(Hulls = true, hullSides = [LEFT,0,TOP], rows =R2, cols = C5);
      }
      hull(){
        modPlateWid(Hulls = true, hullSides = [0,0,TOP],     rows =R1, cols = C4);
        modPlateWid(Hulls = true, hullSides = [0,FRONT,TOP], rows =R1, cols = C4);
        modPlateWid(Hulls = true, hullSides = [0,BACK,TOP],  rows =R2, cols = C4);
        modPlate(Hulls = true, hullSides = [LEFT,0,TOP],     rows =R1, cols = C5);
        modPlate(Hulls = true, hullSides = [LEFT,FRONT,TOP], rows =R1, cols = C5);
        modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP],  rows =R2, cols = C5);
      }

      BuildRmCn(R2, C0)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R2][C0]),TOP],plateDim+[0,-abs(Clipped[R2][C0]),5], [0,-sign(Clipped[R2][C0]),TOP], Hull = false); 
      
      BuildRmCn(R3, C3)rotate([0,0,0])translate([-4,0,0])modulate(PlateDimension,[0,sign(Clipped[R2][C0]),TOP],plateDim+[0,-abs(Clipped[R3][C3]),5], [0,-sign(Clipped[R3][C3]),TOP], Hull = false); 
      
      BuildRmCn(R3, C4)rotate([0,0,0])modulate(PlateDimension,[0,sign(Clipped[R3][C4]),TOP],plateDim+[0,-abs(Clipped[R3][C4]),5], [0,-sign(Clipped[R3][C4]),TOP], Hull = false); 
      
      BuildRmCn(R0, C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = false);         
      
      //for cleaning mount point artifacct 
      hull(){
        BuildRmCn(R0, C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [BACK,0,0]);   
        BuildRmCn(R1, C6)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [FRONT,0,0]); 
      }
      hull(){
        BuildRmCn(R0, C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [0,LEFT,0]);   
        BuildRmCn(R0, C5)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [0,RIGHT,0]); 
      }
      hull(){
        BuildRmCn(R0, C6)rotate([0,0,-90])translate([5,-1,-8])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [BACK,LEFT,0]);   
        BuildRmCn(R1, C6)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [FRONT,LEFT,0]); 
        BuildRmCn(R0, C5)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [BACK,RIGHT,0]); 
        BuildRmCn(R1, C5)modulate(PlateDimension,[0,sign(Clipped[R0][C6]),TOP],plateDim+[0,-abs(Clipped[R0][C6]),5], [0,-sign(Clipped[R0][C6]),TOP], Hull = true, hullSide = [RIGHT,BACK,0]); 
        refWebs(R1, C6, LEFT, false, true, [0,BACK,TOP]);
      }  
      
      for(cols = [C2:C3]){//cleaning web artifacts
        for(rows = [R0:R1]){
          hull() {
            BuildRmCn(rows, cols)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = true, hullSide = [BACK,0,0]);                
            BuildRmCn(rows+1, cols)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows+1][cols]),TOP],plateDim+[0,-abs(Clipped[rows+1][cols]),5],[0,-sign(Clipped[rows+1][cols]),TOP], Hull = true, hullSide = [FRONT,0,0]);     
          }
          if (rows != R0 && cols != C2)
            hull() {
              BuildRmCn(rows, cols)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = true, hullSide = [0,RIGHT,0]);                
              BuildRmCn(rows, cols+1)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols+1]),TOP],plateDim+[0,-abs(Clipped[rows][cols+1]),5],[0,-sign(Clipped[rows][cols+1]),TOP], Hull = true, hullSide = [0,LEFT,0]);     
            }
          if (cols != C2)
          hull() {
            BuildRmCn(rows, cols)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = true, hullSide = [BACK,RIGHT,0]);     
            BuildRmCn(rows+1, cols)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows+1][cols]),TOP],plateDim+[0,-abs(Clipped[rows+1][cols]),5], [0,-sign(Clipped[rows+1][cols]),TOP], Hull = true, hullSide = [FRONT,RIGHT,0]);                
            BuildRmCn(rows, cols+1)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols+1]),TOP],plateDim+[0,-abs(Clipped[rows][cols+1]),5],[0,-sign(Clipped[rows][cols+1]),TOP], Hull = true, hullSide = [BACK,LEFT,0]);         
            BuildRmCn(rows+1, cols+1)rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows+1][cols+1]),TOP],plateDim+[0,-abs(Clipped[rows+1][cols+1]),5],[0,-sign(Clipped[rows+1][cols+1]),TOP], Hull = true, hullSide = [FRONT,LEFT,0]);     
          }
        }
      }
      
      if(keyhole == true){
        for(cols = [C1:C5]){
          for(rows = [R0:RMAX]){
            BuildRmCn(rows, cols){
              if(SwitchOrientation[rows][cols] == true){
                Keyhole(clipLength = Clipped[rows][cols]);
              }else {
                rotate([0,0,-90])Keyhole(clipLength = Clipped[rows][cols]);
              }
            }
          }     
        }   
          BuildRmCn(R2, C0)rotate([0,0,-90])Keyhole(clipLength = Clipped[R2][C0]);
          if(C3R3 == true)BuildRmCn(R3, C3)rotate([0,0,0])translate([-4,0,0])Keyhole(clipLength = Clipped[R3][C3]);
          if(C4R3 == true)BuildRmCn(R3, C4)rotate([0,0,0])Keyhole(clipLength = Clipped[R3][C4]);
          BuildRmCn(R1, C6)rotate([0,0,-90])Keyhole(clipLength = Clipped[R1][C6]);    
          BuildRmCn(R0, C6)rotate([0,0,-90])translate([5,-1,-8])Keyhole(clipLength = Clipped[R0][C6]);    
      }
      //Mount point bore
      BuildRmCn(R0, C6)translate([-2, 9, -12])rotate([-10,0,0])cylinder(d = dMount, 20,center = true); 
      BuildRmCn(R0, C6)translate([8,-7,-23])rotate([0,90,0])cylinder(d = 5, 25, center= true );
      
      if(Promicro == true) {
        BuildRmCn(R1, C2){
          for(i = [0:11]){
            translate([-6.5,   -7.5+i*2.5,-5.5])cube([.7, .7, 5], center = true);
            translate([-6.5+15,-7.5+i*2.5,-5.5])cube([.7, .7, 5], center = true);
          }
        }
        PlaceBetween(R1, C1)translate([4,0,11])cube([13, 6.5, 9], center = true);
      }
    }
  }
}

module PalmMount(platethickness = 0, rail = true){
  // shorthands
  plateDim = PlateDimension +[0,0,1];
  
  module modPlateT(Hulls = true, hullSides = [0,0,0], rows, cols = T0){//shorthand call 
    if(Clipped[rows][cols] == 0){
      PlaceOnThumb(rows)modulate(PlateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else if( SwitchOrientation[rows][cols] == false) {
      PlaceOnThumb(rows)modulate(PlateDimension,[sign(Clipped[rows][cols]), 0, TOP], plateDim-[abs(Clipped[rows][cols]),0,0], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
    } else {
      PlaceOnThumb(rows)modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP], plateDim-[0,abs(Clipped[rows][cols]),0], [0,-sign(Clipped[rows][cols]), BOTTOM], Hull = Hulls, hullSide = hullSides);
    }
  }

  module modPlate(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand
    ShiftTrans()BuildRmCn(rows, cols)modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],plateDim-[0,abs(Clipped[rows][cols]),-platethickness+1], [0,-sign(Clipped[rows][cols]),BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  module modPlateWid(Hulls = true, hullSides = [0,0,0], rows, cols){//shorthand call for Width-wise clipping
    ShiftTrans()BuildRmCn(rows, cols)modulate(PlateDimension,[sign(Clipped[rows][cols]), 0, TOP], plateDim-[abs(Clipped[rows][cols]),0,-platethickness+1], [-sign(Clipped[rows][cols]), 0, BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  module refWebs(row, col, corn, dir =true, Hull = false, hullSide = [0,0,0]) {// shorthand for s
    ShiftTrans()refWeb(PlateDimension[2]+platethickness, WebThickness, 0, TOP, rows = row, cols = col, corner = corn, direction = dir, Hulls = Hull, hullSides = hullSide);
  }
  
  module PalmMount1() {PalmTrans()translate([-0,-10,51])rotate([0,40,-10])translate([-22,-5,2])rotate([0,0,0])children();}
  module PalmMount2() {PalmTrans()translate([-0,-10,51])rotate([0,40,-10])translate([12,-25,-5.5])rotate([0,0,0])children();} 
  module CenterCyl() {translate([-2,-10,-15])rotate([0,0,0])cylinder(d= 10, 5, center = true);} 

  // end of shorthands
  
  //mounting rod support
  //pinkie side mount
  difference(){
    union(){ 
      hull(){
        CenterCyl();
        ShiftTrans()BuildRmCn(R0, C6)translate([14.7,-7,-23])rotate([0,90,0])cylinder(d = 12, 8, center= true );
      }
      hull(){
        CenterCyl();
        PalmMount2()cylinder(d= 10, 7, center = true);
      }
    }
    //cuts 
    ShiftTrans()BuildRmCn(R0, C6)translate([12.5,-7,-23])rotate([0,90,0])cylinder(d = 5, 20, center= true );
    ShiftTrans()BuildRmCn(R0, C6)translate([24,-7,-23])rotate([0,90,0])cylinder(d = 10.8, 15, $fn =6,  center= true );
    PalmMount2()cylinder(d= 5, 15, center = true);
    PalmMount2()translate([0,0,-6])cylinder(d= 11, 5, center = true);
    }
  
  difference(){
    union(){
      hull(){
        CenterCyl();
        PlaceOnThumb(10)translate([0,0,-9.5])cylinder(d1= 15, d2 = 10, 10, center = true);
      }
      hull(){
        PalmMount1()translate([0,0,-1])cylinder(d= 10, 7, center = true);
        CenterCyl();
      } 
    }
    // cuts       
    PlaceOnThumb(10)translate([0,0,-7])cylinder(d= 5, 25, center = true);
    PlaceOnThumb(10)translate([0,0,-18])cylinder(d = 10.8, 11, $fn =6,  center= true );
    PalmMount1()cylinder(d= 5, 25, center = true);
    PalmMount1()translate([0,0,-7])cylinder(d= 10, 5, center = true);
  }
}

//##################   Section E:: Main Calls    ##################
module BaseTrans() {translate([0,0,35])rotate([0,0,0])children();} // to fine tune Base
module ShiftTrans() {translate([0,0,0])rotate([45,0,0])children();} // to fine tune Column orientation 
module PalmTrans() {translate([0,0,-35])translate([43,19,-11])rotate([25,-15,-27])children();} // to fine tune Palm orientation
//prev itt translate([0,0,-35])translate([22,35,-18])rotate([12,-15,5])children()
module PalmTrans2() {translate([0,0,-35])translate([43,19,-11])rotate([25,-15,-27])children();}
//BaseTrans()for(i = [6,7])PlaceOnThumb(Rn = i, stick =true);
//BaseTrans()ShiftTrans()BuildSet2();

//Main Build 
mirror([0,0,0])difference(){
  BaseTrans()union(){
    ShiftTrans()BuildTopPlate(keyhole = false, Mount = false, channel = false, TrackBall = true, platethickness = 3);
    BuildThumbCluster(keyhole = false, track = false, Mount = true, Rotary = true);    
 /*   
    PalmMount(platethickness = 3, rail = false);
    PalmTrans2() import("/STL/PalmSmooth.stl");
    
    translate([3,14,44-35])rotate([-45,0,0])difference(){
      sphere(d=37);
      translate([0,0,15])cube([45,45,45], center=true);
    }
*/
    
//    for(cols = C1){  // ternary Index
      ShiftTrans(){
//        BuildRmCn(R0,C2)rotate([0,0,-90])translate([0,0,-8])cylinder(d = 4, 20);
//        BuildRmCn(R3,C3)rotate([0,0,0])translate([-4,0,0])Switch(colors = "Steelblue",clipLength = 4);
//        BuildRmCn(R3,C4)rotate([0,0,0])Switch(colors = "Steelblue",clipLength = 4);
//        BuildRmCn(R1,C6)rotate([0,0,-90])Switch(colors = "Steelblue",clipLength = -4);
//        BuildRmCn(R0,C6)rotate([0,0,-90])translate([5,-1,-8])Switch(colors = "Steelblue",clipLength = -4);
//        BuildRmCn(R0,C6)rotate([0,0,0])translate([5,-1,-8])translate([0,0,8.9]) keycap(R0+C6*(RMAX+1), SwitchOrientation[R0][C6], Clipped[R0][C6]);
//        BuildFlick(PlateDimension[2]+3, 0, TOP, R2, cols);
//        BuildRmCn(R2, cols-1)rotate([0,0,-90])Keyhole(clipLength = Clipped[RMAX][cols]);
      }
      PlaceOnThumb(0)rotate([0,0,-90])Switch([1,1,1],"Green",clipLength = 0);
      PlaceOnThumb(1)rotate([0,0,-0])Switch([1,1,1],"blue",clipLength = 4);
//      PlaceOnThumb(2)rotate([0,0,-90])Switch([1,1,1],"Steelblue",clipLength =-4);
//      PlaceOnThumb(3)rotate([0,0,-90])Switch([1,1,1],"Steelblue", clipLength =-4);
      PlaceOnThumb(4)rotate([0,0,0])Switch([1,1,1],"Gold",clipLength = -4);
      PlaceOnThumb(5)rotate([0,0,-90])Switch([1,1,1],"Crimson",clipLength = 4);
      PlaceOnThumb(6)rotate([0,0, 0])Switch([1,1,1],"Indigo",clipLength = 4);
      PlaceOnThumb(7)rotate([0,0,-90])Switch([1,1,1],"Ivory",clipLength = 4);
//    }
//  }
}

  translate([5,14,44])sphere(d = 34.1, $fn = 128);

  BaseTrans()ShiftTrans()BuildRmCn(R0,C2)rotate([0,0,-90])translate([0,0,-7])cylinder(d = 5, 20);
    
  for(cols = [C1:CEnd]){//cut to prevent key caps snagging
    for(rows = [R0:RMAX]){
      if (cols != C1 || rows != R0){
         BaseTrans()ShiftTrans()BuildRmCn(rows, cols){
          if(SwitchOrientation[rows][cols] == true){
            modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],PlateDimension+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = false); //cut to prevent key caps snagging
          }else {
            rotate([0,0,-90])modulate(PlateDimension,[0,sign(Clipped[rows][cols]),TOP],PlateDimension+[0,-abs(Clipped[rows][cols]),5], [0,-sign(Clipped[rows][cols]),TOP], Hull = false); 
          }
        }
      }
    }
  }
  
  // cut for thumb channels
  BaseTrans()BuildChannelsThumb(3);
  BaseTrans()ShiftTrans()BuildChannels(3);
  BaseTrans()PlaceOnThumb(1)rotate([0,0,-0])Keyhole(clipLength = Clipped[1][T0]);
}

//integrated palm and trackball
//mirror([0,0,0])
//  difference(){   
//    BaseTrans()union(){
//      PalmMount(platethickness = 3, rail = false);
//      PalmTrans2() import("/STL/PalmSmooth.stl");
//      hull(){
//        translate([5-12,14,-10])cylinder(d=6, 5);
//        translate([5+12,14,-10])cylinder(d=6, 5);
//      }
//      translate([5,14,44-35])rotate([-45,0,0])difference(){
//        sphere(d=41);
//        translate([0,0,15])cube([45,45,45], center=true);
//      }
//    }
//
//    BaseTrans()translate([5,14,-10])cube([32,21,3], center=true);
//    #translate([5,14,44])sphere(d = 34.1, $fn = 128);
//    translate([5,14,20])cylinder(d=5, 10);
//    #translate([5-12,14,19])cylinder(d=2.5, 10);
//    #translate([5+12,14,19])cylinder(d=2.5, 10);
//  }

//##################   Section F:: Key Switches and Caps   ##################  
module BuildSet2()
{
  for(cols = [C1:C5])
  {
    for(rows = [R0:RMAX])
    {
      if ( (rows != R0 || cols != C1) ){
        BuildRmCn(rows, cols)
        if(SwitchOrientation[rows][cols] == true){Switch(colors = "Steelblue", clipLength = Clipped[rows][cols]);}
        else {rotate([0,0,-90])Switch(colors = "Steelblue", clipLength = Clipped[rows][cols]);}
      }
    }
  }
}

module BuildSetCaps()
{
  for(cols = [C1:C5])
  {
    for(rows = [R0:RMAX])
    {
      color()BuildRmCn(rows, cols)
        {translate([0,0,8.9])keycap(rows+cols*(RMAX+1), SwitchOrientation[rows][cols], Clipped[rows][cols]);}
    }
  }
}

//color("Steelblue")BaseTrans()ShiftTrans()BuildSetCaps();
//color("Steelblue")BaseTrans()ShiftTrans()BuildRmCn(R2,C0)translate([0,0,8.9])keycap(R2+C0*(RMAX+1), SwitchOrientation[R2][C0], Clipped[R2][C0]);

//color("Steelblue")BaseTrans()ShiftTrans()BuildRmCn(R1,C6)rotate([0,0,0])translate([0,0,8.9])keycap(R1+C6*(RMAX+1), SwitchOrientation[R1][C6], Clipped[R1][C6]);
//color("grey")BaseTrans()ShiftTrans()BuildRmCn(R0, C4)translate([-10,-22,-32])rotate([0,20,0]){
//  sphere(d = 25.4);
//  rotate([0,0,0])cylinder(d1 = 16.5, d2 =10 , 20);
//  rotate([90,0,0])palmball();
//}

//BuildCap(cols = C1, rows= R0);
//color("Steelblue"){
//BaseTrans()PlaceOnThumb(0)translate([0,0,8.9])keycap(21,false, 4);
//BaseTrans()PlaceOnThumb(1)rotate([0,0,90])translate[0,0,8.9])keycap(22,false, 4);
//BaseTrans()PlaceOnThumb(2)translate([0,0,8.9])keycap(23,false, -4);
//BaseTrans()PlaceOnThumb(3)translate([0,0,8.9])keycap(24,false, -4);
//BaseTrans()PlaceOnThumb(4)rotate([0,0,90])translate([0,0,8.9])keycap(25,false, -4);
//BaseTrans()PlaceOnThumb(5)translate([0,0,8.9])keycap(26,false, 4);
//}


//#translate([3,14,44])sphere(d = 32, $fn = 32);
//#translate([3,14,24])cube([21,28,3],center = true);

//BaseTrans()ShiftTrans()BuildRmCn(R0, C5)translate([-3,18,-28])rotate([0,-90,90])BallMount();
//#BaseTrans()PalmTrans() import("/STL/PalmSmooth.stl");
//#BaseTrans()PalmTrans() Mount();

