use <Switch.scad>

//Ideal Call format
// module BuildOnceH(FingerDims, KeyBoardMap, keyswitchType, PlatformType) 
/*
MCUType = {nrf, arduinopico, blue}
BatteryType = {AAA, coin, lipo(size) }
PlatforType = {ModelView, TestPlatePrint, Handwire, PCBOnly, PCBAndPlate}
*/ 

//TODO finger Mapping
//TODO Edit Thumb
$fn = 60;  
//Alias

R0 = 0; //bottom row
R1 = 1;
R2 = 2;
R3 = 3;
R4 = 4;

C0 = 0; //Column
C1 = 1;
C2 = 2;
C3 = 3;
C4 = 4;
C5 = 5;
C6 = 6;
T0 = 7; //Thumb

IN  = 0; //inner path 
OUT = 1; //outter path
PATH   = 0; //path function 
NORMAL = 1; //path normal

//Modulation Reference
FRONT = 1;
RIGHT = -1;
BACK  = -1;
LEFT  = 1; 
TOP   = 1;
BOTTOM = -1;

finger = 1;
RMAX   = R2;
CStart = C1;
CEnd = C6; 

//-------------------------------------   physical parameters
tol = 0.001; //tolance
hullThickness = 0.0001; //modulation hull thickness
TopHeight = 0; // Reference Origin 
BottomHeight = 3.6; 

switchWidth = 15.6;  // switch width 
PlateOffsets = 2.5; //additional pading on width of plates
PlateOffsetsY= 2.5;  // additional padding on length to accomodate mounting hole

PlateHeight = 6.6;     
switchBottom = 4.8; //from plate 
PlateThickness = 3.5; //switch plate thickness  H_1st

plateDimension = [switchWidth+PlateOffsets,
                  switchWidth+PlateOffsetsY,
                  PlateThickness];

webThickness = 2;
caseSpacing = 3.7;
dMount = 5.1054;  // mounting bore size
dChamfer = 6;     // chamfer diameter
  
//-------------------------------------   finger parametes and rule
fingerLength = [ //proxial, intermediate, distal carpal length
                [26.5,  0,  0],//index 1
                [26.5,  0,  0],//index 2
                [26.5,  0,  0],//index 3
                [26.6,  0,  0], //Middle
                [22.5,  0,  0], //Ring
                [19.4,  0,  0], //pinky
                [19.4,  0,  0], //pinky
                [  52, 35, 25] //thumb
                ];

//-------------------------------------   design and adjustment parameters 
//Angles to the pathfunction 
//               i1   i2   i3    m     r   p1 p2
thetaR0 =      [ 90,  90,  90,  90,   90, 90, 90]; //degree defined rule const 90 deg 
thetaR2 =      [62.5, 59,  65,  66, 60.5, 56, 56]; 
thetaR1Shift = [-.8,  -1,  -1,   0, -1.5, -2, -2]; 
thetaR3Shift = [ .4,  .4,  .8,   1,    1,  1,  1]; 
thetaR4Shift = [  0,   0,   0,   0,    0,  0,  0]; 
thetaRoll =    [  8,  20,   0,   9,   12,  7,  9];  // column rolling angle
thetaKnock =  [[  0,   0,   0,  -5,    0,  0,  0], //R0s
               [  0,   0,   0,   0,    0,  0,  0], //R1s
               [  0, -10, -10,   0,  -10,  5,  5], //R2s right p1&2 = 5  left p1&2 = 10 
               [  0,   0,   0,   0,    0,  0,  0]]; // R3
               
keycapOffset = [  0,   0,   0,   0,    5,  2,  2]; // i1 i2 m r p 
phi2Shift =    [180,   0, 180, 180,    0,  0,  0]; //for soltion wank 
phi_R0    =    [  0,   0,   0,   0,    0,  0,  0];
pathlist  =    [  0,   0,   0,   1,    2,  3,  3];             
               
rowThetaOffset = [90, 0, 0, 0, 0]; //R0, R1, R2, R3, R4
PathSideRm =     [IN, OUT, OUT, OUT, OUT]; 

//-------------------------------------   set Parameters 
//shapeOrigin for 
ColumnOrigin = [//[transition vec][rotation vec1]  [rotation vec2]
                [[  -57,  37,   2], [0 ,0,  0],    [ 0, 90,  0]], //INDEX 1 
                [[-39.5,  36,   6], [0, 0,  0],    [ 0, 90,  0]], //INDEX 2 
                [[  -18,  36,   4], [0, 0,  0],    [ 0, 90,  0]], //INDEX3
                [[    0,  36,   0], [0, 0,  0],    [ 0, 90,  0]],    //MIDDLE
                [[ 18.3,  37,  -7], [0, 0,  0],    [ 0, 90,  0]], //RING
                [[ 43.5,  24,  -5], [0, 0,-42],    [ 0, 90,  7]], //PINKY1 holder
                [[ 55,    9,  -9], [0, 0,-43],    [ 0, 90,  7]], //PINKY2 holder
//              [[ 60,     9,  -5], [0, 0,-50],    [ 0, 90,  7]], //PINKY2 holder
                [[   48, -63,  30], [10, -27, 15], [90,  0, -3]] //Thumb
            ];
            
OriginCnRm = [for( i= [C0:C6])[[0,BottomHeight+keycapOffset[i],0], for(j = [R1:R4])[0,TopHeight+keycapOffset[i],0]]];
            
shiftAngle = 4;
ThumbPosition =  // structure to pass to thumbplacement module
  [//[[thetaDist, thetaMed, thetaProx, phiProx][rotation angle][rotation angle][translation vec]]
    [[15, 30,   35,  0], [ 0,  80, 0], [ 90,0,0], [ -6, -20, -PlateHeight-51]], //R5 quantary palm
    [[15, 30,   35,  0], [ 0, -25, 0], [  0,0,0], [-13,-5.5, -PlateHeight-13]], //R1 Secondary tip low prof
    [[15, 30,   35,  0], [ 0,  20, 0], [ 90,0,0], [-19, -20, -PlateHeight-36]], //R6 Tertiary palm
    [[ 0, 30,   35,  0], [ 0, -25, 0], [  0,0,0], [-13.5, -23.5, -PlateHeight-13]], //R3 Secondary  butt
    [[ 0, 30,   35,  0], [ 0,  20, 0], [  0,0,0], [-18, -31, -PlateHeight-25]], //R4 Was Primary ext
    [[15, 30,   35,  0], [ 0,  80, 0], [  0,0,0], [ -6,-11.5, -PlateHeight-39.5]], //R5 quantary tip
    [[15, 30,   35,  0], [ 0,  20, 0], [  0,0,0], [-19,-11.5, -PlateHeight-25]], //R6 Tertiary tip
    [[ 5,  0, 46.5,  3], [ 0,  45, 0], [  0,0,0], [  0,   -5, -PlateHeight-5]],
    [[ 0,  0,   44, 13], [29,   0, 0], [  0,0,0], [  0,    0, -PlateHeight-15]],
    [[16, 15,   39,  3], [32,   0, 0], [ 0,0,11], [  0,    6, -PlateHeight-16]],
    [[15, 30,   35,  0], [ 0,  50, 0], [  0,0,0], [-15,-11.5, -PlateHeight-25]], //mount 
//    [[15, 30,   35,  0], [ 0,  50, 0], [  0,0,0], [-15, -11.5, -PlateHeight-25]], //mount 
  ];
           
//structure to hold path functions deceimal points are obnoxious I know
function PathStruct(theta) = //PathStruct(theta)[column][path][side]  Colmn Placement Function
10*[[//index
      [(-0.0970856749679008*theta*PI/180+4.99998284136066*pow(theta*PI/180,2)+-2.61181119129906*pow(theta*PI/180,3)+0.285208750084739*pow(theta*PI/180,4))*-1+6.05,
       (-0.0970856749679008+4.99998284136066*2*theta*PI/180+-2.61181119129906*3*pow(theta*PI/180,2)+0.285208750084739*4*pow(theta*PI/180,3))*-1],
      [(0.728370710170023*theta*PI/180+-0.352102136033845*theta*PI/180+-0.727326795753133*pow(theta*PI/180,3)+2.46608365244902*pow(theta*PI/180,4)+-1.81245120990112*pow(theta*PI/180,5)+0.475640948226809*pow(theta*PI/180,6))*-1+6.15,
       (0.728370710170023+-0.352102136033845*2*theta*PI/180+-0.727326795753133*3*pow(theta*PI/180,2)+2.46608365244902*4*pow(theta*PI/180,3)+-1.81245120990112*5*pow(theta*PI/180,4)+0.475640948226809*6*pow(theta*PI/180,5))*-1]
    ], 
    [//middle
      [(3.37546426127455*theta*PI/180+-1.73407355112284*pow(theta*PI/180,2)+1.05640460595701*pow(theta*PI/180,3)+-0.207308712916685*pow(theta*PI/180,4))*-1+7.05,
       (3.37546426127455+-1.73407355112284*2*theta*PI/180+1.05640460595701*3*pow(theta*PI/180,2)+-0.207308712916685*4*pow(theta*PI/180,3))*-1],
      [(0.607448069824603*theta*PI/180+-6.03466707142364*pow(theta*PI/180,2)+17.2974166723035*pow(theta*PI/180,3)+-16.7955019591768*pow(theta*PI/180,4)+6.24233180595108*pow(theta*PI/180,5)+-0.526949822080887*pow(theta*PI/180,6))*-1+7.05,
       (0.607448069824603+-6.03466707142364*2*theta*PI/180+17.2974166723035*3*pow(theta*PI/180,2)+-16.7955019591768*4*pow(theta*PI/180,3)+6.24233180595108*5*pow(theta*PI/180,4)+-0.526949822080887*6*pow(theta*PI/180,5))*-1]
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

//--------------------------------------    phi is angle from shifted origin to the target
// derived transform from polar to cartesian with chain rule: for legiblity 
function derPathX(theta,column, side) =  //x chain rule transform from polar to cartesian
    PathStruct(theta)[column][side][NORMAL]*cos(theta) - PathStruct(theta)[column][side][PATH]*sin(theta);
function derPathY(theta,column,side) = //y chain rule transform from polar to cartesian
    PathStruct(theta)[column][side][NORMAL]*sin(theta) + PathStruct(theta)[column][side][PATH]*cos(theta);
function rotateVecZ(vector, angle) = [
    [cos(angle), -sin(angle),0]*vector, [sin(angle), cos(angle),0]*vector, [0,0,1]*vector
];

//-------------------------------------   determine R1, R3, R4 angles
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
VecTranR0 = [for (col = [C0:C6]) VectorTransformOrigin(thetaR0[col], OriginCnRm[col][R0], pathlist[col], PathSideRm[R0], rowThetaOffset[R0])]; //V1)
VecTranR2 = [for (col = [C0:C6]) VectorTransformOrigin(thetaR2[col], OriginCnRm[col][R2], pathlist[col], PathSideRm[R2], rowThetaOffset[R2])]; //V1)
VecRotR0 =  [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR0[col], pathlist[col], PathSideRm[R0])/derPathX(thetaR0[col], pathlist[col],PathSideRm[R0]))+rowThetaOffset[R0]]];
VecRotR2 =  [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR2[col], pathlist[col], PathSideRm[R2])/derPathX(thetaR2[col], pathlist[col],PathSideRm[R2]))+rowThetaOffset[R2]]];

// angle with respect to intermediate joint
phiR0 = [for (col = [C0:C6]) atan((VecTranR0[col][1]- fingerLength[col][1])/(VecTranR0[col][0]-fingerLength[col][0]))+180];
phiR2 = [for (col = [C0:C6]) atan((VecTranR2[col][1]- fingerLength[col][1])/(VecTranR2[col][0]-fingerLength[col][0]))+phi2Shift[col]];
phiR1 =  (phiR0 - phiR2)/2+phiR2;
phiR3 = -(phiR0 - phiR2)/2+phiR2;
phiR4 =  (phiR0 - phiR2)/2+phiR3;

function Newton_Raphson1(x, tol, col) = 
  PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR1[col])/sin(phiR1[col]-x) < tol ? x :  Newton_Raphson1(x - (PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR1[col])/sin(phiR1[col]-x))/(PathStruct(x)[pathlist[col]][OUT][NORMAL] - norm(fingerLength[col])*sin(phiR1[col])/tan(phiR1[col]-x)/cos(phiR1[col]-x)), tol,col);

function Newton_Raphson3(x, tol, col) = 
  PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR3[col])/sin(phiR3[col]-x) < tol ? x :  Newton_Raphson3(x - (PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR3[col])/sin(phiR3[col]-x))/(PathStruct(x)[pathlist[col]][OUT][NORMAL] - norm(fingerLength[col])*sin(phiR3[col])/tan(phiR3[col]-x)/cos(phiR3[col]-x)), tol,col);

function Newton_Raphson4(x, tol, col) = 
  PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR4[col])/sin(phiR4[col]-x) < tol ? x :  Newton_Raphson4(x - (PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR4[col])/sin(phiR4[col]-x))/(PathStruct(x)[pathlist[col]][OUT][NORMAL] - norm(fingerLength[col])*sin(phiR4[col])/tan(phiR4[col]-x)/cos(phiR4[col]-x)), tol,col);
  
thetaR1 = [for( col = [C0:C6]) Newton_Raphson1(60, tol, col)+thetaR1Shift[col]];
thetaR3 = [for( col = [C0:C6]) Newton_Raphson3(30, tol, col)+thetaR3Shift[col]];
thetaR4 = [for( col = [C0:C6]) Newton_Raphson4(50, tol, col)+thetaR4Shift[col]];

//----- Map the angle with origin no origin offsets
VecTranR1 = [for (col = [C0:C6]) VectorTransformOrigin(thetaR1[col], OriginCnRm[col][R1], pathlist[col], PathSideRm[R1], rowThetaOffset[R2])]; //V1)
VecTranR3 = [for (col = [C0:C6]) VectorTransformOrigin(thetaR3[col], OriginCnRm[col][R3], pathlist[col], PathSideRm[R3], rowThetaOffset[R2])]; //V1)
VecTranR4 = [for (col = [C0:C6]) VectorTransformOrigin(thetaR4[col], OriginCnRm[col][R4], pathlist[col], PathSideRm[R4], rowThetaOffset[R2])]; //V1)
  
VecTranR0c = [for (col = [C0:C6]) VectorTransformOrigin(thetaR0[col], [0,0,0], pathlist[col], PathSideRm[R0], rowThetaOffset[R0])]; 
VecTranR1c = [for (col = [C0:C6]) VectorTransformOrigin(thetaR1[col], [0,0,0], pathlist[col], PathSideRm[R1], rowThetaOffset[R1])]; 
VecTranR2c = [for (col = [C0:C6]) VectorTransformOrigin(thetaR2[col], [0,0,0], pathlist[col], PathSideRm[R2], rowThetaOffset[R2])]; 
VecTranR3c = [for (col = [C0:C6]) VectorTransformOrigin(thetaR3[col], [0,0,0], pathlist[col], PathSideRm[R3], rowThetaOffset[R3])]; 
VecTranR4c = [for (col = [C0:C6]) VectorTransformOrigin(thetaR4[col], [0,0,0], pathlist[col], PathSideRm[R4], rowThetaOffset[R4])]; 
  
VecRotR1 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR1[col], pathlist[col], PathSideRm[R1])/derPathX(thetaR1[col], pathlist[col],PathSideRm[R1]))+rowThetaOffset[R1]]];
VecRotR3 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR3[col], pathlist[col], PathSideRm[R3])/derPathX(thetaR3[col], pathlist[col],PathSideRm[R3]))+rowThetaOffset[R3]]];
VecRotR4 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR4[col], pathlist[col], PathSideRm[R4])/derPathX(thetaR4[col], pathlist[col],PathSideRm[R4]))+rowThetaOffset[R4]]];

VecTransRmCnO = [VecTranR0,VecTranR1,VecTranR2,VecTranR3,VecTranR4]; // for be used for locating between plates
VecTransRmCn = [VecTranR0c,VecTranR1c,VecTranR2c,VecTranR3c,VecTranR4c]; // oring set to [0,0,0] for general placement 
RotTransRmCn = [VecRotR0,VecRotR1,VecRotR2,VecRotR3,VecRotR4];

//##########  END SOLVER
//##########  Supporting Modules for Main Builder Modules
function hadamard(a,b) = !(len(a)>0) ? a*b : [ for(i = [0:len(a)-1]) hadamard(a[i],b[i]) ]; // elementwise mult
  
// for simplifying hulling operation since they don't support 2d to 3d hull use small cube to emulate
module hullPlate(referenceDimensions = [0,0,0], offsets = [0,0,0]) 
{ 
  x = offsets[0] == 0 ?  referenceDimensions[0]:hullThickness;
  y = offsets[1] == 0 ?  referenceDimensions[1]:hullThickness;
  z = offsets[2] == 0 ?  referenceDimensions[2]:hullThickness;
  hullDimension = [x,y,z];
  translate(hadamard(referenceDimensions,offsets/2))translate(hadamard(hullDimension,-offsets/2))cube(hullDimension, center = true);
} //Convinient notation for hulling a cube by face/edge/point

//Convinient cube transferomation
module modulate(referenceDimension = [0,0,0], referenceSide = [0,0,0], objectDimension = [0,0,0], objectSide = [0,0,0], Hull = false, hullSide = [0,0,0]){
  if(Hull == false){
    translate(hadamard(referenceDimension,referenceSide/2))translate(hadamard(objectDimension,objectSide/2))cube(objectDimension, center = true);
  }
  else{
    color("red")translate(hadamard(referenceDimension,referenceSide/2))translate(hadamard(objectDimension,objectSide/2))hullPlate(objectDimension, hullSide);
    }
}  

module PlaceColumnOrigin(Cn = C0) {
 translate(ColumnOrigin[Cn][0])rotate(ColumnOrigin[Cn][1])rotate([90,0,0])mirror([0,1,0])rotate(ColumnOrigin[Cn][2])children();
}

module OnPlateOrigin(Rm = R0,Cn = C0){
  translate((OriginCnRm[Cn][Rm]+[0,PlateHeight+PlateThickness/2,0]))children();
}

module PlaceOnRoll(rollAngle =0 , offsets = -1){ // set rotation origin on the plate top edge
  function RollOrigin() = offsets*[0,-PlateThickness/2,PlateOffsets/2+switchWidth/2];
  translate(-RollOrigin())rotate([-rollAngle,0,0])translate(RollOrigin())children();
}

//angle adjustment
module PlaceOnKnock(rollAngle =0 , offsets = -1){ // set rotation origin on the plate top edge
  function KnockOrigin() = offsets*[-10,-PlateOffsets/2-switchWidth/2-2,0];
  translate(-KnockOrigin())rotate([0,0,rollAngle])translate(KnockOrigin())children();
}
//place child object on the target position with all transforms
module BuildRmCn(row, col) {
  PlaceColumnOrigin(col)
    translate(VecTransRmCn[row][col])
      rotate(RotTransRmCn[row][col])
        OnPlateOrigin(row,col)
          PlaceOnRoll(thetaRoll[col], -sign(thetaRoll[col]))
            PlaceOnKnock(thetaKnock[row][col])
            rotate([90,90,0])
              children();
}

module OnThumb(thetaDist, thetaMed, thetaProx, phiProx, stick = false){
  phiMed = 20; // medial rotation 
  rotate([-90,0,0])rotate([-phiProx,-thetaProx,0]){
    if(stick == true)color("red")cylinder(d=2, fingerLength[T0][0]);// base
    translate([0,0,fingerLength[T0][0]]){
      rotate([0,thetaMed,0])rotate([0,0,phiMed]){
        if(stick == true)color("blue")cylinder(d=2,fingerLength[T0][1]);
        translate([0,0,fingerLength[T0][1]]){ //tip
          rotate([0,thetaDist ,0]){
            if(stick == true)color("green")cylinder(d=2,fingerLength[T0][2]);
            rotate([90,0,0])translate([0,fingerLength[T0][2]/2,0]){
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

module BuildSet(){
  for(cols = [CStart:CEnd]){
    for(rows = [R0:RMAX]){
      BuildRmCn(rows, cols)children();
    }
  }
}

// not too accurate... but place object between Rms 
module PlaceBetween(Rm = R0,Cn = C0){   
 function rotX(vec1, rot1) =  [[1,0,0]*vec1, 
                              [0, cos(rot1),-sin(rot1)]*vec1,
                              [0, sin(rot1),cos(rot1)]*vec1];
  
  vecRm = [0,0,plateDimension[1]/2];  
  Vec1 = VecTransRmCn[Rm][Cn] + rotateVecZ([(OriginCnRm[Cn][Rm]+[0,PlateHeight,0])[1],-plateDimension[1]/2,0],RotTransRmCn[Rm][Cn][2]+90);
  Vec2 = VecTransRmCn[Rm+1][Cn] + rotateVecZ([(OriginCnRm[Cn][Rm+1]+[0,PlateHeight,0])[1],plateDimension[1]/2,0],RotTransRmCn[Rm+1][Cn][2]+90);

  function RollOrigin2() = 1*[0,0,plateDimension[1]/2];

  PlaceColumnOrigin(Cn)
    translate((Vec2+Vec1)/2)rotate([0,0,atan((Vec2-Vec1)[1]/(Vec2-Vec1)[0])+90])
     translate(RollOrigin2())rotate([0,thetaRoll[Cn],0])translate(-RollOrigin2())
        rotate([0,90,0])children();
}

module BuildBetweenA() // optional mount hole between switched
{
  for(Cn = [C1:C3]){
    for(Rm = [R0,RMAX-1]){
      PlaceBetween(Rm,Cn)children();
    }
  }
  PlaceOnThumb(8, keys = false)children();
}

module BuildColumn(plateThickness, offsets, sides =TOP, col=0){
  refDim =plateDimension +[0,0,offsets];
  buildDim =[plateDimension[0], plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX]){//ADJUSTMENT ROW SIZE
    BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);
    if (row < RMAX){ //ADJUSTMENT ROW SIZE
      hull(){
        BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
}

module BuildWebs(plateThickness, webWidth, offsets, sides =TOP, col=0)//hull between plates
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[webWidth, plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX]){ //ADJUSTMENT ROW SIZE
    hull(){
      BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
      BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM]);
    }
    if (row < RMAX) {//ADJUSTMENT ROW SIZE
      hull(){
        BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
        BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
}

module BuildInnerWebs(col, sides = RIGHT)
{
  innnerWebDim =  [hullThickness,plateDimension[1],hullThickness];
  hull()
  {
    for(Rm = [R0:RMAX]) 
    {
      BuildRmCn(Rm, col)modulate(plateDimension,[sides,0,TOP],  innnerWebDim, [-sides,0,TOP]);
    }
    
    BuildRmCn(R0, col)modulate(plateDimension,[sides,BACK,TOP],  innnerWebDim, [-sides,0,TOP]);
    BuildRmCn(R3, col)modulate(plateDimension,[sides,FRONT,TOP],  innnerWebDim, [-sides,0,TOP]);
  }
}

//################ Main Builder ############################
module BuildThumbCluster(sides = 0,  offsets = 0, frameThickness = plateDimension[2], Mount = false, track = true)
{
  refDim =plateDimension +[0,0,offsets];
  frameDim = [plateDimension[0], plateDimension[1], frameThickness];
  plateDim = plateDimension +[0,0,3];
  plateDimLow = plateDimension +[0,0,2];
  cutDim = plateDimension+[0,0,5];
  trackDim = [26.5, 28, 1];
  
  module modPlate(Hulls = true, hullSides = [0,0,0]){//shorthand call 
    modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  module modPlateLow(Hulls = true, hullSides = [0,0,0]){ //for low profiles switches
    modulate(plateDimension,[0,0,TOP],plateDimLow, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
  }
  
  difference(){ //R0~R3 hull 
    union(){
      //upper keyplates
      //track point ver
      if( track == true){
       //past implementation depreciated
      }
      //normal version
      else{
        for(i = [1,3,5,6]){PlaceOnThumb(i)modPlate(false);} //for 
        hull(){      
          PlaceOnThumb(1)modPlate(hullSides = [0,RIGHT,0]);
          PlaceOnThumb(3)modPlate(hullSides = [0,LEFT,0]);
        }
        hull(){      
          PlaceOnThumb(1)modPlate(hullSides = [BACK,RIGHT,0]);
          PlaceOnThumb(6)modPlate(hullSides = [FRONT,RIGHT,0]);
          PlaceOnThumb(3)modPlate(hullSides = [BACK,0,0]);
        }
        hull(){      
          PlaceOnThumb(3)modPlate(hullSides = [BACK,0,0]);
        }
        hull(){ //lower keyplates     
          PlaceOnThumb(1)modPlate(hullSides = [BACK,0,0]);
          PlaceOnThumb(6)modPlate(hullSides = [FRONT,0,0]);
        }
        hull(){ //lower keyplates     
          PlaceOnThumb(6)modPlate(hullSides = [BACK,0,0]);
          PlaceOnThumb(5)modPlate(hullSides = [FRONT,0,0]);
        }
       if(Mount == true){
//attachement to finger columns
         hull(){      
            PlaceOnThumb(1)modPlate(hullSides = [0,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C2)modPlate(hullSides = [0,BACK,0]);
  //          ShiftTrans()BuildRmCn(R0, C1)modPlate(hullSides = [RIGHT,BACK,0]);
          }
         hull(){      
            PlaceOnThumb(1)modPlate(hullSides = [RIGHT,LEFT,0]);
            PlaceOnThumb(6)modPlate(hullSides = [LEFT,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C2)modPlate(hullSides = [LEFT,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C1)modPlate(hullSides = [RIGHT,BACK,0]);
          }
          hull(){      
            PlaceOnThumb(6)modPlate(hullSides = [0,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C1)modPlate(hullSides = [0,BACK,0]);
  //          ShiftTrans()BuildRmCn(R0, C1)modPlate(hullSides = [RIGHT,BACK,0]);
          }
          hull(){      
            PlaceOnThumb(6)modPlate(hullSides = [RIGHT,LEFT,0]);
            PlaceOnThumb(5)modPlate(hullSides = [LEFT,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C1)modPlate(hullSides = [LEFT,0,BOTTOM]);
            ShiftTrans()BuildRmCn(R0, C1)modulate(plateDimension-[0,5,0],[0,0,TOP],plateDim-[0,5,5], [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,BOTTOM]);
          }
          hull(){      
            PlaceOnThumb(5)modPlate(hullSides = [0,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C1)modPlate(hullSides = [LEFT,BACK,BOTTOM]);
          }
          hull(){
            PlaceOnThumb(R1)modPlate(hullSides = [LEFT,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C3)modPlate(hullSides = [0,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C2)modPlate(hullSides = [RIGHT,BACK,0]);
          }
          hull(){
            PlaceOnThumb(R1)modPlate(hullSides = [LEFT,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C2)modPlate(hullSides = [RIGHT,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C3)modPlate(hullSides = [RIGHT,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C5)modPlate(hullSides = [LEFT,BACK,0]);
          }   
          hull(){
            ShiftTrans()BuildRmCn(R0, C4)modPlate(hullSides = [0,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C3)modPlate(hullSides = [RIGHT,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C5)modPlate(hullSides = [LEFT,BACK,0]);
          } 
          hull(){
            PlaceOnThumb(R1)modPlate(hullSides = [LEFT,0,0]);
            ShiftTrans()BuildRmCn(R0, C5)modPlate(hullSides = [0,BACK,0]);
          }
          hull(){
            PlaceOnThumb(R1)modPlate(hullSides = [LEFT,RIGHT,0]);         
            PlaceOnThumb(R3)modPlate(hullSides = [LEFT,LEFT,0]);
            ShiftTrans()BuildRmCn(R0, C5)modPlate(hullSides = [0,BACK,0]);
            ShiftTrans()BuildRmCn(R0, C6)modPlate(hullSides = [LEFT,BACK,0]);
          }          
          hull(){
            PlaceOnThumb(R3)modPlate(hullSides = [LEFT,0,0]);
            ShiftTrans()BuildRmCn(R0, C6)modPlate(hullSides = [0,BACK,0]);
          }          
          //hopeful trackpoint mount
          PlaceOnThumb(6)translate([0,12.5,-7.25-.3]){ 
              translate([19/2,0,1])cylinder(d =5, 8);  //mount 
              translate([-19/2,0,1])cylinder(d =5, 8); //mount 
          }
        }      
      }       
    }

    union(){//cuts
    //Column Cuts
      for(Cn = [C1:C6]) hull(){// intra cut C1
        ShiftTrans()BuildInnerWebs(Cn, sides = RIGHT);
        ShiftTrans()BuildInnerWebs(Cn, sides = LEFT);
      }
    //bottom plate cuts
      for (i = [1,3,4,5,6]){//keyholes
          PlaceOnThumb(i)Keyhole();
      }
      //additional cuts to clean up press
      PlaceOnThumb(R1)modulate(plateDimension,[0,0,TOP],plateDim+[1,1,5], [0,0,TOP], Hull = false);
      PlaceOnThumb(R3)modulate(plateDimension,[0,0,TOP],plateDim+[1,1,5], [0,0,TOP], Hull = false);
      PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim+[1,10,5], [0,0,TOP], Hull = false);
      
      ShiftTrans()BuildRmCn(R0, C1)Keyhole(cutThickness = 2);
      ShiftTrans()BuildRmCn(R0, C2)Keyhole(cutThickness = 2);  
      
      // PCB Mounts
//      #rotate([32,15,20])translate([5,-20,3])cube([35,25,3.5]);
//      #rotate([25,10,30])translate([12,-20,0])cube([15,38,3.5]);
//      rotate([40,-10,20])translate([15,-10,-8.5])cylinder(d= 3, 6);
//      rotate([40,-10,20])translate([15,15,-8.5])cylinder(d= 3, 6);
//      
      //trackpoint 
      if(track == true){
      }
      else{
        PlaceOnThumb(6)translate([0,12.5,-7.25-.3]){
          translate([19/2,0,0])cylinder(d =2, 8);  //mount 
          translate([-19/2,0,0])cylinder(d =2, 8); //mount 
          cylinder(d =3, 10); // for stud
        }
      }
      if(Mount == true){
        PlaceOnThumb(10)translate([0,0,8])cylinder(d1 =dMount, d2= dChamfer, 2.5, center = true);
        PlaceOnThumb(10)cylinder(d= dMount, 90, center = true);

      }
//        translate([-50,24,8])rotate([16,100,0])cylinder(d= dMount, 13, center = true);
    }
  } // end cut
}

module BuildTopPlate(keyhole = false, Mount = true, channel = false, platethickness = 0)
{
  plateDim = plateDimension +[0,0,1];
  module modPlate(Hulls = true, hullSides = [0,0,0]){//shorthand
    modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = Hulls, hullSide = hullSides);
  }

  difference(){
    union(){//SwitchPlate
      for(cols = [CStart:CEnd]){
        BuildColumn(plateDimension[2]+platethickness, 0, TOP, cols);
        if (cols < CEnd){
          BuildWebs(plateDimension[2]+platethickness, webThickness, 0, TOP, cols);
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
            BuildInnerWebs(cols, sides = RIGHT);
            BuildInnerWebs(cols+1, sides = LEFT);
          }
        }
      }  
      //note special cuts for C4/5 Webbing
      hull(){
        BuildRmCn(R0, C4)modPlate(Hulls = true, hullSides = [RIGHT,0,TOP]);
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides = [RIGHT,BACK,TOP]);
        BuildRmCn(R0, C5)modPlate(Hulls = true, hullSides =[LEFT,0,TOP]);
        BuildRmCn(R1, C5)modPlate(Hulls = true, hullSides = [LEFT,BACK,TOP]);
      }
      hull(){
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides =[0,0,TOP]);
        BuildRmCn(R1, C5)modPlate(Hulls = true, hullSides =[LEFT,0,TOP]);
        BuildRmCn(R1, C4)modPlate(Hulls = true, hullSides =[0,FRONT,TOP]);
        BuildRmCn(R2, C4)modPlate(Hulls = true, hullSides =[0,BACK,TOP]);
        BuildRmCn(R1, C5)modPlate(Hulls = true, hullSides = [LEFT,FRONT,TOP]);
        BuildRmCn(R2, C5)modPlate(Hulls = true, hullSides =[LEFT,BACK,TOP]);
      }
      hull(){
        BuildRmCn(R2, C4)modPlate(Hulls = true, hullSides =[0,0,TOP]);
        BuildRmCn(R2, C5)modPlate(Hulls = true, hullSides =[LEFT,0,TOP]);
      }
      //eton 
      
      if(Mount == true){
       BuildBetweenA()cylinder(d2 =dMount, d1= dChamfer, 2.5, center = true);
       BuildBetweenA()cylinder(d= dMount, 70);
       cylinder(d= dMount, 70);
      }
        
      if(keyhole == true){
        BuildSet()Keyhole();
      }
      translate([10,0,-20])rotate([0,0,0])cylinder(d = 5.1054, 20);
      translate([10,-12,-20])rotate([0,0,0])cylinder(d = 5.1054, 20);
      translate([10,-8,-1])rotate([0,0,0])cube([20,25,15],center = true);
      translate([-10,-4,-12])cube([25,20.80,12],center = true); //BLE case
    }
  }
}


//##################   Section D:: PCB output for kicad and cuts   ##################
module PCBOUT(plateThickness, offsets, sides =TOP, col=0, row = 0) // Wire Channel
{
  refDim =plateDimension +[0,0,offsets];
  buildDim =[plateDimension[0]-3, plateDimension[1], plateThickness];
//left then right 
hull(){
  BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,TOP]);
  BuildRmCn(row+1, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,TOP]);
  BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,TOP]);
  BuildRmCn(row+1, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,TOP]);
}
//   BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);
}

module PCBOUT2(plateThickness, offsets, sides =TOP, col=0, row = 0) // Wire Channel
{
  refDim =plateDimension +[0,0,offsets];
  buildDim =[plateDimension[0]-3, plateDimension[1], plateThickness];
//left then right 
hull(){
  BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,TOP]);
  BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,TOP]);
  BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,TOP]);
  BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,TOP]);
}
//   BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);
}

module PCBOUTT(plateThickness, offsets, sides =TOP, TR1=0, TR2 = 1, track = false) // Wire Channel
{
  refDim =plateDimension +[0,0,offsets];
  buildDim =[plateDimension[0]-3, plateDimension[1], plateThickness];
//left then right 
  hull(){
    PlaceOnThumb(TR1)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,TOP]);
    PlaceOnThumb(TR1)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,TOP]);
    PlaceOnThumb(TR2)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,TOP]);
    PlaceOnThumb(TR2)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,TOP]);
  }
}

module BuildPCB(plateThickness, offsets, sides =TOP, col=0) // Wire Channel
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[plateDimension[0]-3, plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX-1]){//ADJUSTMENT ROW SIZE
    if (row < RMAX){//ADJUSTMENT ROW SIZE
      hull(){
        BuildRmCn(row, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim, [0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
  BuildRmCn(R0, col)modulate(refDim,[0,FRONT,sides], buildDim-[0,1.5,0], [0,BACK,BOTTOM]);
  for (row = [R1:RMAX-1]){BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);}
  BuildRmCn(RMAX, col)modulate(refDim,[0,BACK,sides], buildDim-[0,1.5,0], [0,FRONT,BOTTOM]);
}
/* for out put only
color("blue")
for(col = [1:5]){
  for(row = [0:1]){
    BaseTrans()PCBOUT(1, -2.9, BOTTOM, col,row);
    BaseTrans()PCBOUT2(1, -2.9, BOTTOM, col,row);
  }
}
*/

//###################################################################################################################
//##################   Section E:: Main Calls    ##################
MasterLogic = false;
module BaseTrans() {translate([0,0,35])rotate([0,0,0])children();}
module ShiftTrans() {translate([0,0,0])rotate([45,0,0])children();} //TODO ad hoc bullshit 

color("white"){
BaseTrans()ShiftTrans()BuildTopPlate(keyhole = true, Mount = false, channel = false, platethickness = 3);
BaseTrans()BuildThumbCluster(keyhole = false, track = false, Mount = true);
//#for(cols = [CStart:CEnd]){color("blue")BaseTrans()ShiftTrans()BuildPCB(1.6, 3.8, BOTTOM, cols);}//PCB
}
//##################   Section F:: ETC   ##################  
module BuildSet2()
{
  for(cols = [C1:CEnd])
  {
    for(rows = [R0:RMAX])
    {
      BuildRmCn(rows, cols)children();
    }
  }
}

//BaseTrans()ShiftTrans()BuildSet2()Switch(colors = "Steelblue");
//BaseTrans()for(i = [10])PlaceOnThumb(Rn = i)translate([0,0,-10])cylinder(r=5, 20);
//BaseTrans()for(i = [1])PlaceOnThumb(Rn = i)Switch([1,1,1],"Steelblue");
//BaseTrans()for(i = [10])PlaceOnThumb(Rn = i, stick = true);
//BaseTrans()for(i = [2])PlaceOnThumb(Rn = i)Switch([1,1.5,1],"silver");
//BaseTrans()for(i = [5])PlaceOnThumb(Rn = i)Switch([1,1.5,1],"blue");
//BaseTrans()for(i = [3])PlaceOnThumb(Rn = i)Switch([1,1,1],"blue");
//BaseTrans()for(i = [6])PlaceOnThumb(Rn = i)Switch([1,1,1],"red");
//BaseTrans(){
//BuildRmCn(R0, C3)rotate([120,0,0])translate([1,-11,12])Switch();




