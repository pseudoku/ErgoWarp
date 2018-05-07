//WARPED
//4x6 8 thumb cluster +trackpoint 


use <Switch.scad>
use <BatteryHolder.scad>


$fn = 60;  

R0 = 0; //row 0 ...
R1 = 1;
R2 = 2;
R3 = 3;
R4 = 4;

C0 = 0;
C1 = 1;
C2 = 2;
C3 = 3;
C4 = 4;
C5 = 5;
C6 = 6;
T0 = 7; //Thumb

IN = 0; //inner path 
OUT = 1; //outter path

PATH = 0; //path function 
NORMAL = 1; //path normal 

INDEX1 = 0;
INDEX2 = 1;
INDEX3 = 2;
MIDDLE = 3;
RING = 4;
PINKY1 = 5;
PINKY2 = 6;

FRONT = 1;
RIGHT = -1;
BACK = -1;
LEFT = 1; 
TOP = 1;
BOTTOM = -1;
finger = 1;
RMAX = R3;
//-------------------------------------   physical parameters
tol = 0.001;
hullThickness = 0.0001; 

switchButtonTopHeight = 0; // Reference Origin 
switchButtonBottomHeight = 3.6; 

switchWidth = 15.6;  // switch width 
switchPlateOffsets = 2.5; //additional pading on width of plates
switchPlateOffsetsY= 2.5;  // additional padding on length to accomodate mounting hole

switchPlateHeight = 6.6;     
switchBottom = 4.8; //from plate 
switchPlateThickness = 3.5; //switch plate thickness  H_1st

//-------------------------------------   finger parametes and rule
fingerLength = [ //proxial, intermediate, distal carpal length
    [26.5,0,0],//index 1
    [26.5,0,0],//index 2
    [26.5,0,0],//index 3
    [26.6,0,0], //Middle
    [22.5, 0,0], //Ring
    [19.4,0,0], //pinky
    [19.4,0,0], //pinky
    [0,0,0] //thumb
];

//-------------------------------------   design and adjustment parameters 
//Angles to the pathfunction 
thetaR0 = 90; //degree defined rule const 90 deg
thetaR2 = [62.5, 62.5, 65, 66, 60.5, 56, 60]; 
//manual adjustment if needed
thetaR1Shift = [-.8,-.8,-1,0,-1.5, -2, -1.5]; // i1 i2 i3 m r p1 p2
thetaR3Shift = [.4,.4,.8,1,1,1,0]; // i1 i2 i3 m r p1 p2
thetaR4Shift = [0,0,0,0,0,0,0]; 

//object Orientation
thetaOffsetR0 = 90; //tangent to path 
thetaOffsetR1 = 0; //normal to path 
thetaOffsetR2 = 0; //normal to path 
thetaOffsetR3 = 0; //normal to path 
thetaOffsetR4 = 0; //normal to path 
rowThetaOffset = [thetaOffsetR0, thetaOffsetR1, thetaOffsetR2, thetaOffsetR3, thetaOffsetR4];

//rolling the key
thetaRoll = [8,8,0,7,12,7,7]; // i1 i2 i3 m r p1 p2

//Manual adjutment of the offsets to from the path 
keycapOffsetHeight = [0,0,0,0, 5, 2, 3]; // i1 i2 m r p 

//-------------------------------------   set Parameters //dooooo not touch unless 
plateDimension = [switchWidth+switchPlateOffsets,
                     switchWidth+switchPlateOffsetsY,
                     switchPlateThickness];
                     
webThickness = 2;
caseSpacing = 3.7;
  //mounting holes
dMount = 3;
dChamfer = 6; 
  
//shapeOrigin for 
phi2Shift = [180,180,180,180,0,0,0];
phi_R0 = [0,0,0,0,0,0,0];
pathlist = [0,0,0,1,2,3,3]; 
PathSideRm = [IN, OUT, OUT, OUT, OUT];

ColumnOrigin =
[ //[Column][[transition vec], [rotation vec1], [rotation vec1], ]
    [[-57,40,-8],[0,0,0],[0,90,0]], //INDEX 1 
    [[-38,38,-9],[0,0,0],[0,90,0]], //INDEX 2 
    [[-18.7,36,-7],[0,0,0],[0,90,0]], //INDEX3
    [[0,36,0],[0,0,0],[0,90,0]],    //MIDDLE
    [[19.2,37,-7],[0,0,0],[0,90,0]], //RING
    [[43,21,-5],[0,0,-25],[0,90,4]], //PINKY1
//     [[37.8,25,-7],[0,0,-12],[0,90,-3]], //PINKY1 previous 
    [[37.8,25,-7],[0,0,-12],[0,90,-3]], //PINKY2
    [[-5,-68,-3],[0,0,0],[90,0,0]] //Thumb
];

OriginCnRm = 
[
  [ //C0
    [0,switchButtonBottomHeight+keycapOffsetHeight[C0] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C0],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C0],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C0],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C0],0]  //R4
  ], 
  [ //C1
    [0,switchButtonBottomHeight+keycapOffsetHeight[C1] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C1],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C1],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C1],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C1],0]  //R4
  ], 
  [ //C2
    [0,switchButtonBottomHeight+keycapOffsetHeight[C2] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C2],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C2],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C2],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C2],0]  //R4
  ], 
  [ //C3
    [0,switchButtonBottomHeight+keycapOffsetHeight[C3] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C3],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C3],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C3],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C3],0]  //R4
  ], 
  [ //C4
    [0,switchButtonBottomHeight+keycapOffsetHeight[C4] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C4],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C4],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C4],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C4],0]  //R4
  ], 
  [ //C5
    [0,switchButtonBottomHeight+keycapOffsetHeight[C5] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C5],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C5],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C5],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C5],0]  //R4
  ], 
  [ //C6
    [0,switchButtonBottomHeight+keycapOffsetHeight[C6] ,0], //R0
    [0,switchButtonTopHeight+keycapOffsetHeight[C6],0], //R1
    [0,switchButtonTopHeight+keycapOffsetHeight[C6],0], //R2
    [0,switchButtonTopHeight+keycapOffsetHeight[C6],0], //R3
    [0,switchButtonTopHeight+keycapOffsetHeight[C6],0]  //R4
  ]
];

ThumbPosition = [//[[thetaDist, thetaMed, thetaProx, phiProx][rotation angle][rotation angle][translation vec]]
  [//tip 1 R0  
    [15,30,35,0], //angles
    [0,-90,0],   //key orientation
    [0,0,0],   //key orientation
    [0,-4,-switchPlateHeight-5] //offset vector
  ], 
  [//tip without 
    [15,15,37,12],
    [0,-90,0],
    [0,0,0],   //key orientation
    [0,-8,-switchPlateHeight-8] //tip 2  R1
  ],
  [
    [0,30,35,0],
    [0,-90,0],
    [0,0,0],   //key orientation
    [0,-27,-switchPlateHeight-5] //palm1 U1.5 R2
  ],
  [
    [0,15,37,12],
    [0,-90,0],
    [0,0,0],   //key orientation
    [-4,-28.5,-switchPlateHeight-5] //[0,0,-12]), //palm2 U1.25 R3
  ],
  [
    [0,0,52.7,19],
    [90,0,0],
    [-25,0,0],   //key orientation
    [0,14,-switchPlateHeight-11] //push 2 R4
//    [0,0,35,0],
//    [0,-90,0],
//    [10,0,0],   //key orientation
//    [-8,-55,-switchPlateHeight-15]//palm3 R4
  ],
  [
    [5,0,44,23],
    [90,0,0],
    [-25,0,0],   //key orientation
    [0,14,-switchPlateHeight-11] //push 2 R5
  ], 
  [
    [5,0,39,18],
    [0,0,0],
    [0,0,0],   //key orientation
    [0,-7,-switchPlateHeight-5] //push3 R6
  ],
  [
    [5,0,51.5,13],
    [0,0,0],
    [0,0,0],   //key orientation
    [0,-5,-switchPlateHeight-5] //push4 R7
  ],
  [// Mount Point 
    [0,0,44,13],
    [29,0,0],
    [0,0,0],   //key orientation
    [0,0,-switchPlateHeight-15] //push4 R7
  ],
  [// traackpoooint
    [16.,15,41,12],
    [90,0,0],
    [0,0,11],   //key orientation
    [0,0,-switchPlateHeight-15] //push 2 R5
  ],
  [// Mount 2 
    [7.5,30,35,0],
    [0,-90,0],
    [0,0,0],   //key orientation
    [0,-15.5,-switchPlateHeight-12.] //palm1 U1.5 R2
  ],
];

function PathStruct(theta) = //PathStruct(theta)[column][path][side]  //fun in cm
10*[ 
    [//index
        //path function 
        [  
            (-0.0970856749679008*theta*PI/180+4.99998284136066*pow(theta*PI/180,2)+-2.61181119129906*pow(theta*PI/180,3)+0.285208750084739*pow(theta*PI/180,4))*-1+6.05,
            (-0.0970856749679008+4.99998284136066*2*theta*PI/180+-2.61181119129906*3*pow(theta*PI/180,2)+0.285208750084739*4*pow(theta*PI/180,3))*-1
        ],
        //derivative 
        [  (0.728370710170023*theta*PI/180+-0.352102136033845*theta*PI/180+-0.727326795753133*pow(theta*PI/180,3)+2.46608365244902*pow(theta*PI/180,4)+-1.81245120990112*pow(theta*PI/180,5)+0.475640948226809*pow(theta*PI/180,6))*-1+6.15,
           (0.728370710170023+-0.352102136033845*2*theta*PI/180+-0.727326795753133*3*pow(theta*PI/180,2)+2.46608365244902*4*pow(theta*PI/180,3)+-1.81245120990112*5*pow(theta*PI/180,4)+0.475640948226809*6*pow(theta*PI/180,5))*-1
        ]
    ],
    
    [//middle
        [ (3.37546426127455*theta*PI/180+-1.73407355112284*pow(theta*PI/180,2)+1.05640460595701*pow(theta*PI/180,3)+-0.207308712916685*pow(theta*PI/180,4))*-1+7.05,
          (3.37546426127455+-1.73407355112284*2*theta*PI/180+1.05640460595701*3*pow(theta*PI/180,2)+-0.207308712916685*4*pow(theta*PI/180,3))*-1
        ],

        [ (0.607448069824603*theta*PI/180+-6.03466707142364*pow(theta*PI/180,2)+17.2974166723035*pow(theta*PI/180,3)+-16.7955019591768*pow(theta*PI/180,4)+6.24233180595108*pow(theta*PI/180,5)+-0.526949822080887*pow(theta*PI/180,6))*-1+7.05,
          (0.607448069824603+-6.03466707142364*2*theta*PI/180+17.2974166723035*3*pow(theta*PI/180,2)+-16.7955019591768*4*pow(theta*PI/180,3)+6.24233180595108*5*pow(theta*PI/180,4)+-0.526949822080887*6*pow(theta*PI/180,5))*-1
        ]
    ],

    [//Ring 
        //path function    
        [ (3.7823025670934*theta*PI/180+-0.501527054996156*pow(theta*PI/180,2)+-0.643611490515308*pow(theta*PI/180,3)+0.284350638669325*pow(theta*PI/180,4))*-1+7.1,
          (3.7823025670934+-0.501527054996156*2*theta*PI/180+-0.643611490515308*3*pow(theta*PI/180,2)+0.284350638669325*4*pow(theta*PI/180,3))*-1
        ],
       
        [ (2.64824226949886*theta*PI/180+-1.75765298787184*pow(theta*PI/180,2)+1.58186165679158*pow(theta*PI/180,3)+-0.447633354249964*pow(theta*PI/180,4))*-1+7.1,
          (2.64824226949886+-1.75765298787184*theta*PI/180*2+1.58186165679158*3*pow(theta*PI/180,2)+-0.447633354249964*4*pow(theta*PI/180,3))*-1
        ]
    ],

    [//Pinky
        [ (0.891366580134508*theta*PI/180+1.39458123721462*pow(theta*PI/180,2)+0.0356280814612978*pow(theta*PI/180,3)+-0.306858074306139*pow(theta*PI/180,4))*-1+4.97,
          (0.891366580134508+1.39458123721462*2*theta*PI/180+0.0356280814612978*3*pow(theta*PI/180,2)+-0.306858074306139*4*pow(theta*PI/180,3))*-1
        ], 
        [ (-0.362824642312139*theta*PI/180+3.33009581755908*pow(theta*PI/180,2)+-3.46170300668225*pow(theta*PI/180,3)+1.31299949357683*pow(theta*PI/180,4))*-1+4.97,
          (-0.362824642312139+3.33009581755908*2*theta*PI/180+-3.46170300668225*3*pow(theta*PI/180,2)+1.31299949357683*4*pow(theta*PI/180,3))*-1
        ]
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
function VectorTransformOrigin(theta, ShapeOrigin,column, side, angleOffset) = //V1)
[  
    //X
    PathStruct(theta)[column][side][PATH]*cos(theta)+ // switch location vector
    rotateVecZ(ShapeOrigin, atan(derPathY(theta,column,side)/derPathX(theta,column,side))+angleOffset)[0], //shape origin shifted normal to the 
    //Y
    PathStruct(theta)[column][side][PATH]*sin(theta)+ // switch location vector
    rotateVecZ(ShapeOrigin, atan(derPathY(theta, column,side)/derPathX(theta,column,side))+angleOffset)[1], //shape origin shifted normal to the 
    //Z
    0//shape origin shifted normal to the 
];

//---------Apply Rules
//Solve For knows coordinate  R0 and R2 
VecTranR0 = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR0, OriginCnRm[col][R0], pathlist[col], PathSideRm[R0], thetaOffsetR0)]; //V1)

VecTranR2 = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR2[col], OriginCnRm[col][R2], pathlist[col], PathSideRm[R2], thetaOffsetR2)]; //V1)

VecRotR0 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR0, pathlist[col], PathSideRm[R0])/derPathX(thetaR0, pathlist[col],PathSideRm[R0]))+rowThetaOffset[R0]]];
    
VecRotR2 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR2[col], pathlist[col], PathSideRm[R2])/derPathX(thetaR2[col], pathlist[col],PathSideRm[R2]))+rowThetaOffset[R2]]];

// angle with respect to intermediate joint
phiR0 = [for (col = [C0:C6]) atan((VecTranR0[col][1]- fingerLength[col][1])/(VecTranR0[col][0]-fingerLength[col][0]))+180];
phiR2 = [for (col = [C0:C6]) atan((VecTranR2[col][1]- fingerLength[col][1])/(VecTranR2[col][0]-fingerLength[col][0]))+phi2Shift[col]];
phiR1 = (phiR0 - phiR2)/2 + phiR2;
phiR3 = -(phiR0 - phiR2)/2+phiR2;
phiR4 = (phiR0 - phiR2)/2+phiR3;


function Newton_Raphson1(x, tol, col) = 
  PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR1[col])/sin(phiR1[col]-x) < tol ? x :  Newton_Raphson1(x - (PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR1[col])/sin(phiR1[col]-x))/(PathStruct(x)[pathlist[col]][OUT][NORMAL] - norm(fingerLength[col])*sin(phiR1[col])/tan(phiR1[col]-x)/cos(phiR1[col]-x)), tol,col);

function Newton_Raphson3(x, tol, col) = 
  PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR3[col])/sin(phiR3[col]-x) < tol ? x :  Newton_Raphson3(x - (PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR3[col])/sin(phiR3[col]-x))/(PathStruct(x)[pathlist[col]][OUT][NORMAL] - norm(fingerLength[col])*sin(phiR3[col])/tan(phiR3[col]-x)/cos(phiR3[col]-x)), tol,col);

function Newton_Raphson4(x, tol, col) = 
  PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR4[col])/sin(phiR4[col]-x) < tol ? x :  Newton_Raphson4(x - (PathStruct(x)[pathlist[col]][OUT][PATH] - norm(fingerLength[col])*sin(phiR4[col])/sin(phiR4[col]-x))/(PathStruct(x)[pathlist[col]][OUT][NORMAL] - norm(fingerLength[col])*sin(phiR4[col])/tan(phiR4[col]-x)/cos(phiR4[col]-x)), tol,col);
  
thetaR1 = [for( col = [C0:C6]) Newton_Raphson1(60, tol, col)+thetaR1Shift[col]];
thetaR3 = [for( col = [C0:C6]) Newton_Raphson3(30, tol, col)+thetaR3Shift[col]];
thetaR4 = [for( col = [C0:C6]) Newton_Raphson4(50, tol, col)+thetaR4Shift[col]];
echo(thetaR4,thetaR3);

//----- Map the angle with origin no origin offsets
VecTranR1 = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR1[col], OriginCnRm[col][R1], pathlist[col], PathSideRm[R1], thetaOffsetR2)]; //V1)
VecTranR3 = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR3[col], OriginCnRm[col][R3], pathlist[col], PathSideRm[R3], thetaOffsetR2)]; //V1)
VecTranR4 = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR4[col], OriginCnRm[col][R4], pathlist[col], PathSideRm[R4], thetaOffsetR2)]; //V1)
  
VecTranR0c = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR0, [0,0,0], pathlist[col], PathSideRm[R0], thetaOffsetR0)]; 
VecTranR1c = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR1[col], [0,0,0], pathlist[col], PathSideRm[R1], thetaOffsetR1)]; 
VecTranR2c = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR2[col], [0,0,0], pathlist[col], PathSideRm[R2], thetaOffsetR2)]; 
VecTranR3c = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR3[col], [0,0,0], pathlist[col], PathSideRm[R3], thetaOffsetR3)]; 
VecTranR4c = [ for (col = [C0:C6]) VectorTransformOrigin(thetaR4[col], [0,0,0], pathlist[col], PathSideRm[R4], thetaOffsetR4)]; 
  
VecRotR1 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR1[col], pathlist[col], PathSideRm[R1])/derPathX(thetaR1[col], pathlist[col],PathSideRm[R1]))+rowThetaOffset[R1]]];
VecRotR3 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR3[col], pathlist[col], PathSideRm[R3])/derPathX(thetaR3[col], pathlist[col],PathSideRm[R3]))+rowThetaOffset[R3]]];
VecRotR4 = [for (col = [C0:C6]) [0,0,atan(derPathY(thetaR4[col], pathlist[col], PathSideRm[R4])/derPathX(thetaR4[col], pathlist[col],PathSideRm[R4]))+rowThetaOffset[R4]]];

VecTransRmCnO = [VecTranR0,VecTranR1,VecTranR2,VecTranR3,VecTranR4]; // for be used for locating between plates
VecTransRmCn = [VecTranR0c,VecTranR1c,VecTranR2c,VecTranR3c,VecTranR4c]; // oring set to [0,0,0] for general placement 
RotTransRmCn = [VecRotR0,VecRotR1,VecRotR2,VecRotR3,VecRotR4];

//########################################################### END SOLVER
//###########################################################
function hadamard(a,b) = !(len(a)>0) ? a*b : [ for(i = [0:len(a)-1]) hadamard(a[i],b[i]) ]; // elementwise mult
  
module hullPlate(referenceDimensions = [0,0,0], offsets = [0,0,0])
{ 
  x = offsets[0] == 0 ?  referenceDimensions[0]:hullThickness;
  y = offsets[1] == 0 ?  referenceDimensions[1]:hullThickness;
  z = offsets[2] == 0 ?  referenceDimensions[2]:hullThickness;
  hullDimension = [x,y,z];
  translate(hadamard(referenceDimensions,offsets/2))translate(hadamard(hullDimension,-offsets/2))cube(hullDimension, center = true);
} //Convinient notation for hulling a cube by face/edge/point

module modulate(referenceDimension = [0,0,0], referenceSide = [0,0,0], objectDimension = [0,0,0], objectSide = [0,0,0], Hull = false, hullSide = [0,0,0])
{
  if(Hull == false)
  {
    translate(hadamard(referenceDimension,referenceSide/2))translate(hadamard(objectDimension,objectSide/2))cube(objectDimension, center = true);
  }
  else
    {
    color("red")translate(hadamard(referenceDimension,referenceSide/2))translate(hadamard(objectDimension,objectSide/2))hullPlate(objectDimension, hullSide);
    }
} //Convinient cube transfer 

module PlaceColumnOrigin(Cn = C0) 
{
   translate(ColumnOrigin[Cn][0])rotate(ColumnOrigin[Cn][1])rotate([90,0,0])mirror([0,1,0])rotate(ColumnOrigin[Cn][2])children();
}

module OnPlateOrigin(Rm = R0,Cn = C0)
{
    translate((OriginCnRm[Cn][Rm]+[0,switchPlateHeight+switchPlateThickness/2,0]))children();
}

module PlaceOnRoll(rollAngle =0 , offsets = -1,) // set rotation origin on the plate top edge
{
    function RollOrigin() = offsets*[0,-switchPlateThickness/2,switchPlateOffsets/2+switchWidth/2];
    translate(-RollOrigin())rotate([-rollAngle,0,0])translate(RollOrigin())children();
}

module OnThumb(thetaDist, thetaMed, thetaProx, phiProx, stick = false )
{
  radius_meta = 52; //metacarpals
  radius_proximal = 35;// proximal phalanges
  radius_distal = 25;// distal phalanges
  phiMed = 20;
    
  rotate([-90,0,0])rotate([-phiProx,-thetaProx,0])
  {
    if(stick == true)color("red")cylinder(d=2, radius_meta);// base
    translate([0,0,radius_meta])
    {
      rotate([0,thetaMed,0])rotate([0,0,phiMed])
      {
        if(stick == true)color("blue")cylinder(d=2,radius_proximal);
        translate([0,0,radius_proximal])
        { //tip
          rotate([0,thetaDist ,0])
          {
            if(stick == true)color("green")cylinder(d=2,radius_distal);
            rotate([90,0,0])translate([0,radius_distal/2,0])
            {
              children();
            }
          }
        }
      }
    }
  }
}

module PlaceOnThumb(Rn = R0, stick = false) //for thumb 
{
  translate(ColumnOrigin[T0][0])OnThumb(ThumbPosition[Rn][0][0],ThumbPosition[Rn][0][1],ThumbPosition[Rn][0][2],ThumbPosition[Rn][0][3], stick)rotate(ThumbPosition[Rn][1])translate(ThumbPosition[Rn][3])rotate(ThumbPosition[Rn][2])children(); 
}    

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
module PlaceBetween(Rm = R0,Cn = C0) 
{   
 function rotX(vec1, rot1) = 
  [[1,0,0]*vec1, 
  [0, cos(rot1),-sin(rot1)]*vec1,
  [0, sin(rot1),cos(rot1)]*vec1];
  
  vecRm = [0,0,plateDimension[1]/2];  
  Vec1 = VecTransRmCn[Rm][Cn] + rotateVecZ([(OriginCnRm[Cn][Rm]+[0,switchPlateHeight,0])[1],-plateDimension[1]/2,0],RotTransRmCn[Rm][Cn][2]+90);
  Vec2 = VecTransRmCn[Rm+1][Cn] + rotateVecZ([(OriginCnRm[Cn][Rm+1]+[0,switchPlateHeight,0])[1],plateDimension[1]/2,0],RotTransRmCn[Rm+1][Cn][2]+90);

   function RollOrigin2() = 1*[0,0,plateDimension[1]/2];

  PlaceColumnOrigin(Cn)
    translate((Vec2+Vec1)/2)rotate([0,0,atan((Vec2-Vec1)[1]/(Vec2-Vec1)[0])+90])
     translate(RollOrigin2())rotate([0,thetaRoll[Cn],0])translate(-RollOrigin2())
        rotate([0,90,0])children();
}
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

//***************************************************************************
module BuildRmCn(row, col) 
{
  PlaceColumnOrigin(col)
    translate(VecTransRmCn[row][col])
      rotate(RotTransRmCn[row][col])
        OnPlateOrigin(row,col)
          PlaceOnRoll(thetaRoll[col])
            rotate([90,90,0])
              children();
}

module BuildSets()
{
  for(cols = [C1:C5])
  {
    for(rows = [R0:RMAX])
    {
      BuildRmCn(rows, cols)children();
    }
  }
}

module BuildColumn(plateThickness, offsets, sides =TOP, col=0)
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[plateDimension[0], plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX]){//ADJUSTMENT ROW SIZE
    BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
}

module BuildPlate(plateThickness, offsets, sides =TOP, col=0) //Cuts and build for back Plate
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[(plateDimension[0]-2.50)*.96, plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX-1])
  {//ADJUSTMENT ROW SIZE
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
  
  BuildRmCn(R0, col)modulate(refDim,[0,FRONT,sides], buildDim-[0,2.5/2,0], [0,BACK,BOTTOM]);
  for (row = [R1:RMAX-1]){BuildRmCn(row, col)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM]);}
  BuildRmCn(RMAX, col)modulate(refDim,[0,BACK,sides], buildDim-[0,2.5/2,0], [0,FRONT,BOTTOM]);
}

module BuildChannel(plateThickness, offsets, sides =TOP, col=0) // Wire Channel
{
   refDim =plateDimension +[-10,0,offsets];
   buildDim =[2, plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX-1])
  {//ADJUSTMENT ROW SIZE
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
  
  BuildRmCn(R0, col)modulate(refDim,[LEFT,FRONT,sides], buildDim-[0,2.5,0], [RIGHT,BACK,BOTTOM]);
  for (row = [R1:RMAX-1]){BuildRmCn(row, col)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM]);}
  BuildRmCn(RMAX, col)modulate(refDim,[LEFT,BACK,sides], buildDim-[0,2.5,0], [RIGHT,FRONT,BOTTOM]);
  
  BuildRmCn(R0, col)modulate(refDim,[RIGHT,FRONT,sides], buildDim-[0,2.5,0], [LEFT,BACK,BOTTOM]);
  for (row = [R1:RMAX-1]){BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);}
  BuildRmCn(RMAX, col)modulate(refDim,[RIGHT,BACK,sides], buildDim-[0,2.5,0], [LEFT,FRONT,BOTTOM]);
}

module BuildColumnChannel(plateThickness, offsets, sides =TOP, row = R0) // Wire Channel
{
   refDim2 =plateDimension +[0,-8,offsets];
   buildDim2 =[plateDimension[0]-5,3, plateThickness];
  
  for (col = [C1:C4])
  {//ADJUSTMENT ROW SIZE
    hull()
    {
      BuildRmCn(row, col)modulate(refDim2,[0,FRONT,sides], buildDim2, [0,BACK,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
      BuildRmCn(row, col+1)modulate(refDim2,[0,FRONT,sides], buildDim2, [0,BACK,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
    }
  }
}
module BuildThumbPlate(plateThickness, offsets, sides =TOP)
{
  refDim = plateDimension +[0,0,offsets];
  buildDim = [plateDimension[0]-2.5, plateDimension[1], plateThickness];
  postDim  = [2.5/2, 2.5/2, plateThickness];
  
  hull()
  {
    PlaceOnThumb(7)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    PlaceOnThumb(4)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
 
  hull()
  {
    PlaceOnThumb(6)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    PlaceOnThumb(5)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
  
  hull()
  {
    PlaceOnThumb(9)modulate(refDim,[0,0,sides], buildDim-[-2.5,0,0], [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    PlaceOnThumb(9)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    PlaceOnThumb(5)modulate(refDim,[0,0,sides], buildDim-[-2.5,0,0], [0,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
    PlaceOnThumb(5)modulate(refDim,[0,0,sides], buildDim, [0,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
  }
  
  hull()
  { 
    PlaceOnThumb(5)modulate(refDim,[LEFT,FRONT,sides], postDim, [RIGHT,BACK,BOTTOM]);
    PlaceOnThumb(9)modulate(refDim,[0,0,sides], buildDim-[-2.5,0,0], [0,0,BOTTOM],Hull = true, hullSide = [0,0,0]);
  }
  
  hull()
  {
    PlaceOnThumb(4)modulate(refDim,[0,0,sides], buildDim-[0,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
    PlaceOnThumb(5)modulate(refDim,[0,0,sides], buildDim-[0,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
    PlaceOnThumb(4)modulate(refDim,[0,0,sides], buildDim-[-2.5,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
    PlaceOnThumb(5)modulate(refDim,[0,0,sides], buildDim-[-2.5,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
  }
  hull()
  {
    PlaceOnThumb(7)modulate(refDim,[0,0,sides], buildDim-[0,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
    PlaceOnThumb(6)modulate(refDim,[0,0,sides], buildDim-[0,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
    PlaceOnThumb(7)modulate(refDim,[0,0,sides], buildDim-[-2.5,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
    PlaceOnThumb(6)modulate(refDim,[0,0,sides], buildDim-[-2.5,2.5,0], [0,0,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
  }
  
  hull()
  {
  PlaceOnThumb(4)modulate(refDim,[LEFT,BACK,sides], postDim, [RIGHT,FRONT,BOTTOM]);
  PlaceOnThumb(5)modulate(refDim,[RIGHT,BACK,sides], postDim, [LEFT,FRONT,BOTTOM]);
  PlaceOnThumb(6)modulate(refDim,[RIGHT,FRONT,sides], postDim, [LEFT,BACK,BOTTOM]);
  PlaceOnThumb(7)modulate(refDim,[LEFT,FRONT,sides], postDim, [RIGHT,BACK,BOTTOM]);
  }
  
  PlaceOnThumb(4)modulate(refDim,[0,BACK,sides], buildDim-[0,2.5/2,0], [0,FRONT,BOTTOM]);
  PlaceOnThumb(5)modulate(refDim,[0,BACK,sides], buildDim-[0,2.5/2,0], [0,FRONT,BOTTOM]);
  PlaceOnThumb(6)modulate(refDim,[0,FRONT,sides], buildDim-[0,2.5/2,0], [0,BACK,BOTTOM]);
  PlaceOnThumb(7)modulate(refDim,[0,FRONT,sides], buildDim-[0,2.5/2,0], [0,BACK,BOTTOM]);
  PlaceOnThumb(9)modulate(refDim,[0,BACK,sides], buildDim-[0,2.5/2,0], [0,FRONT,BOTTOM]);

  hull()
  {
    PlaceOnThumb(9)modulate(refDim,[0,0,sides],buildDim-[-2.5,0,0], [0,0,BOTTOM], Hull = true, hullSide = [0,0,BOTTOM]);
    PlaceOnThumb(5)modulate(refDim, [0,0,sides],buildDim-[-2.5,0,0], [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,BOTTOM]);
  } 
  
}

module BuildThumbChannel(plateThickness, offsets, sides =TOP) // Wire Channel
{
   refDim =plateDimension +[-10,0,offsets];
   buildDim =[4, plateDimension[1], plateThickness];
  
   refDim2 =plateDimension +[0,-8,offsets];
   buildDim2 =[plateDimension[0]-5,4, plateThickness];
  
  for (row = [R0:RMAX-1])
  {//ADJUSTMENT ROW SIZE
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        PlaceOnThumb(7)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        PlaceOnThumb(4)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
      hull()
      {
        PlaceOnThumb(6)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        PlaceOnThumb(5)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
      
      hull()
      {
        PlaceOnThumb(6)modulate(refDim2,[0,BACK,sides], buildDim2, [0,FRONT,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
        PlaceOnThumb(7)modulate(refDim2,[0,BACK,sides], buildDim2, [0,FRONT,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
      }
      hull()
      {
        PlaceOnThumb(3)modulate(refDim2,[0,BACK,sides], buildDim2, [0,FRONT,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
        PlaceOnThumb(6)modulate(refDim2,[0,BACK,sides], buildDim2, [0,FRONT,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
      }
      hull()
      {
        PlaceOnThumb(5)modulate(refDim2,[0,FRONT,sides], buildDim2, [0,BACK,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
        PlaceOnThumb(9)modulate(refDim, [RIGHT,0,sides], buildDim-[0,4,0], [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
       
      PlaceOnThumb(5)modulate(refDim,[LEFT,BACK,sides], buildDim-[0,2.5,0], [RIGHT,FRONT,BOTTOM]);
      PlaceOnThumb(4)modulate(refDim,[LEFT,BACK,sides], buildDim-[0,2.5,0], [RIGHT,FRONT,BOTTOM]);
      PlaceOnThumb(6)modulate(refDim,[LEFT,FRONT,sides], buildDim-[0,2.5,0], [RIGHT,BACK,BOTTOM]);
      PlaceOnThumb(7)modulate(refDim,[LEFT,FRONT,sides], buildDim-[0,2.5,0], [RIGHT,BACK,BOTTOM]);
    }
  }
}


module BuildWebs(plateThickness, webWidth, offsets, sides =TOP, col=0)//hull between plates
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[webWidth, plateDimension[1], plateThickness];
  
  for (row = [R0:RMAX]){ //ADJUSTMENT ROW SIZE
    hull()
    {
      BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
      BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM]);
    }
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
        BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
}


module BuildWebsCase(plateThickness, webWidth, offsets, sides =TOP, col= C4, cuts = false)//hull between plates
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[webWidth, plateDimension[1], plateThickness];
  
  //top cuts
  {
    hull() 
      {
        BuildRmCn(RMAX, col)modulate(refDim,[RIGHT,BACK,sides], buildDim-[0,2.5/2,0], [LEFT,FRONT,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
        BuildRmCn(RMAX, col+1)modulate(refDim,[LEFT,BACK,sides], buildDim-[0,2.5/2,0], [RIGHT,FRONT,BOTTOM],Hull = true, hullSide = [0,0,BOTTOM]);
      }
    for (row = [R2]){ //ADJUSTMENT ROW SIZE
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
        BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,0,BOTTOM]);
      }
      
      if (row < RMAX)//ADJUSTMENT ROW SIZE
      {
        hull()
        {
          BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,0]);
          BuildRmCn(row+1, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,0]);
          BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,BOTTOM]);
          BuildRmCn(row+1, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,BOTTOM]);
        }
      }
    }
  }
  
  //internal cuts 
  
   if(cuts == false){
    hull() 
      {
        BuildRmCn(RMAX, col)modulate(refDim,[RIGHT,BACK,sides], buildDim-[0,2.5/2,0], [LEFT,FRONT,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
        BuildRmCn(RMAX, col+1)modulate(refDim,[LEFT,BACK,sides], buildDim-[0,2.5/2,0], [RIGHT,FRONT,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
      }
    for (row = [R2]){ //ADJUSTMENT ROW SIZE
      hull()
      {
        BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [RIGHT,0,0]);
        BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [LEFT,0,0]);
      }
      
      if (row < RMAX)//ADJUSTMENT ROW SIZE
      {
        hull()
        {
          BuildRmCn(row, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [RIGHT,FRONT,0]);
          BuildRmCn(row+1, col)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [RIGHT,BACK,0]);
          BuildRmCn(row, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [LEFT,FRONT,0]);
          BuildRmCn(row+1, col+1)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [LEFT,BACK,0]);
        }
      }
    }
  }
}

module BuildWebsMod(plateThickness, webWidth, offsets, sides =TOP)//hull between plates
{
   refDim =plateDimension +[0,0,offsets];
   buildDim =[webWidth, plateDimension[1], plateThickness];
  
  
  // C2 -> C3  
  for (row = [R0:RMAX])  //ADJUSTMENT ROW SIZE
  {
    hull()
    {
      BuildRmCn(row, C2)modulate(refDim,[RIGHT,0,sides], buildDim, [RIGHT,0,BOTTOM]);
      BuildRmCn(row, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
    }
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, C2)modulate(refDim,[RIGHT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, C2)modulate(refDim,[RIGHT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
        BuildRmCn(row, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
  // C3 -> C4 
  for (row = [R1:RMAX])  //ADJUSTMENT ROW SIZE
  {
    hull()
    {
      BuildRmCn(row, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
      BuildRmCn(row, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
    }
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
        BuildRmCn(row, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }
  
  // C4 -> C5 
  hull()
  {
    BuildRmCn(R0, C3)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
    BuildRmCn(R0, C5)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM]);
  }
  
  for (row = [R1:RMAX])  //ADJUSTMENT ROW SIZE
  {
    if (row > R1)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
        BuildRmCn(row, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM]);
      }
    }
    if (row < RMAX)//ADJUSTMENT ROW SIZE
    {
      hull()
      {
        BuildRmCn(row, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
        BuildRmCn(row, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
        BuildRmCn(row+1, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
      }
    }
  }  
  
  hull()
  {
    BuildRmCn(R1, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    BuildRmCn(R1, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    BuildRmCn(R1, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    BuildRmCn(R2, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
 
  hull()
  {
    BuildRmCn(R1, C5)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    BuildRmCn(R1, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    BuildRmCn(R1, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    BuildRmCn(R1, C5)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
   
  hull()
  {
    BuildRmCn(R0, C5)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    BuildRmCn(R1, C5)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    BuildRmCn(R0, C3)modulate(refDim + [0,0,3],[RIGHT,0,sides], buildDim - [0,0,1.5], [LEFT,0,BOTTOM],Hull = true, hullSide = [0,FRONT,0]);
    BuildRmCn(R1, C3)modulate(refDim+ [0,0,3],[RIGHT,0,sides], buildDim- [0,0,1.5], [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
  }
  
  hull()
  {
    BuildRmCn(R1, C5)modulate(refDim,[LEFT,0,sides], buildDim, [RIGHT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    BuildRmCn(R1, C4)modulate(refDim,[RIGHT,0,sides], buildDim, [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
    BuildRmCn(R1, C3)modulate(refDim+ [0,0,3],[RIGHT,0,sides], buildDim- [0,0,1.5], [LEFT,0,BOTTOM],Hull = true, hullSide = [0,BACK,0]);
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
module BuildThumbB(sides = 0,  offsets = 0, frameThickness = plateDimension[2], key = false, SwitchMount = false)
{
  
  refDim =plateDimension +[0,0,offsets];
  frameDim = [plateDimension[0], plateDimension[1], frameThickness];
  plateDim = plateDimension +[0,0,4.5];
  cutDim = plateDimension+[0,0,5];
  trackDim = [26.5, 28, 1];
  trackRef = [-trackDim[0]/2+plateDimension[0]/2, -plateDimension[1]/2+7, -(plateDimension[2]+1.4+caseSpacing+1)];
  
  
  if(key == true){BuildKeys_Thumb()translate([0,0,1])Switch();}
  difference() //R0~R3 hull 
  {
    union()
    {
      hull() //upper keyplates
      { 
        for(i = [0:3]){PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM]);}
     //   #PlaceOnThumb(1)translate([-12.99,-7,-10])cube([.01,28,1], center = true);
      }  
      
      for(i = [4:7]){PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP], plateDim,[0,0,BOTTOM] );}
      PlaceOnThumb(9)modulate(plateDimension,[0,0,TOP], plateDim,[0,0,BOTTOM] );
      
      hull() //lower keyplates
      {      
        PlaceOnThumb(1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [BACK,0,0]);
        PlaceOnThumb(3)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [BACK,0,0]);
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [FRONT,0,0]);
        BuildRmCn(R0, C1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,0]);
      }
      
      hull()
      {
        PlaceOnThumb(1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [BACK,0,0]);
        PlaceOnThumb(3)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [BACK,0,0]); 
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [FRONT,0,0]);
        PlaceOnThumb(1)translate([-13.99,-7,-10])cube([.01,28,1], center = true);
      }
      hull()
      {
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,0]);
        PlaceOnThumb(9)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,BACK,0]);
        BuildRmCn(R0, C1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,0]);
      }       
      
      hull()
      {
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
        BuildRmCn(R0, C1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,0]);
      }   
//      
      hull()
      {
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [RIGHT,0,0]);
        PlaceOnThumb(7)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
      }
      
      hull()
      {
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [RIGHT,0,0]);
        PlaceOnThumb(4)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
      }

      //////        //extra hulls
       
      hull()
      {
        PlaceOnThumb(9)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
        BuildRmCn(R0, C1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
      } 
      
      hull()
      {
        PlaceOnThumb(1)modulate(refDim,[0,0,sides],frameDim, [0,0,0], Hull = true, hullSide = [0,FRONT,0]);
        PlaceOnThumb(0)modulate(refDim,[0,0,sides],frameDim, [0,0,0], Hull = true, hullSide = [BOTTOM,FRONT,TOP]);
        BuildRmCn(R0, C1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,BOTTOM]);
        
      }           
      
      hull()
      {
        PlaceOnThumb(9)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0,BOTTOM,0]);
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
      } 
      
       hull()
      {
        PlaceOnThumb(9)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0,BOTTOM,0]);
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,BOTTOM,0]);
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,0]);
      } 
      hull()
      {
        PlaceOnThumb(9)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [RIGHT,0,0]);
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,0]);
      } 
      hull()
      {
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [RIGHT,0,0]);
        PlaceOnThumb(4)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,0,0]);
      }  
      hull()
      {
        PlaceOnThumb(4)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0, BACK, 0]);
        PlaceOnThumb(7)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0, FRONT, 0]);
      }
      hull()
      {
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0, BACK, 0]);
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0, FRONT, 0]);
      }
      hull()
      {
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [RIGHT, BACK, 0]);
        PlaceOnThumb(7)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0, BACK, 0]);
      }
      
      hull()
      {
        PlaceOnThumb(4)modulate(plateDimension,[0,0,TOP],plateDim-[0,0,1], [0,0,BOTTOM], Hull = true, hullSide = [LEFT, BACK, 0]);
        PlaceOnThumb(7)modulate(plateDimension,[0,0,TOP],plateDim-[0,0,1], [0,0,BOTTOM], Hull = true, hullSide = [LEFT, FRONT, 0]);
        PlaceOnThumb(5)modulate(plateDimension,[0,0,TOP],plateDim-[0,0,1], [0,0,BOTTOM], Hull = true, hullSide = [RIGHT, BACK, 0]);
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim-[0,0,1], [0,0,BOTTOM], Hull = true, hullSide = [RIGHT, FRONT, 0]);
      }
    }

    union() //cuts
    { 
      //keytops
      for(i = [0:3]){PlaceOnThumb(i)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP]);}
      PlaceOnThumb(9)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [0,0,0]);
      
      hull() //inner 
      {
        for(i = [0:3])
        {
          PlaceOnThumb(i)modulate(refDim+[0,0,6],[0,0,BOTTOM],cutDim-[3.9,3.9,5], [0,0,BOTTOM]);
        }
      }
      BuildColumn(plateDimension[2]+4.5, 0, TOP, C1);
      BuildColumn(plateDimension[2]+4.5, 0, TOP, C2);
      hull()// intra cut C1
      {
        BuildInnerWebs(C1, sides = RIGHT);
        BuildInnerWebs(C1, sides = LEFT);
      }
      
      hull()
      {    
        PlaceOnThumb(0)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [0,RIGHT,0]);
        PlaceOnThumb(2)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [0,LEFT,0]);
      }
      hull()
      {
        PlaceOnThumb(1)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [0,RIGHT,0]);
        PlaceOnThumb(3)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [0,LEFT,0]);
      }
      hull()
      {
        PlaceOnThumb(0)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [BOTTOM,0,0]);
        PlaceOnThumb(1)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [TOP,0,0]);
      }
      hull()
      {
        PlaceOnThumb(2)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [BOTTOM,0,0]);
        PlaceOnThumb(3)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [TOP,0,0]);
      }  
      hull(){
        PlaceOnThumb(0)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [BOTTOM,RIGHT,0]);
        PlaceOnThumb(1)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [TOP,RIGHT,0]);
        PlaceOnThumb(2)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [BOTTOM,LEFT,0]);
        PlaceOnThumb(3)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [TOP,LEFT,0]);
      }
      hull()
      {
        BuildRmCn(R0, C1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,FRONT,BOTTOM]);
        PlaceOnThumb(1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [LEFT,BOTTOM,TOP]);
        PlaceOnThumb(1)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [BOTTOM,0,0]);
        PlaceOnThumb(6)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [TOP,0,0]);
      }
      
      hull()
      {
        PlaceOnThumb(3)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [BOTTOM,0,0]);
        PlaceOnThumb(6)modulate(refDim,[0,0,TOP],cutDim, [0,0,TOP], Hull = true, hullSide = [TOP,0,0]);
      }
      
      //bottom plate cuts
      BuildThumbPlate(1, plateDimension[2]+3.6, BOTTOM);
      BuildThumbChannel(2, plateDimension[2]+3.6-2, BOTTOM);
      
//        if(SwitchMount == true)
      for (i = [0:9])//keyholes
      {
        if ( i != 8)
        {
          PlaceOnThumb(i)Keyhole();
         // PlaceOnThumb(i)modulate([switchWidth,switchWidth,3.5], [0,0,BOTTOM], [switchWidth,switchWidth,15], [0,0,BOTTOM]);
        }
      }
      
       //mounts
      PlaceOnThumb(8)translate([0,0,8])cylinder(d1 =dMount, d2= dChamfer, 2.5, center = true);
      PlaceOnThumb(8)cylinder(d= dMount, 90, center = true);
      
      PlaceOnThumb(10)translate([0,0,8])cylinder(d1 =dMount, d2= dChamfer, 2.5, center = true);
      PlaceOnThumb(10)cylinder(d= dMount, 90, center = true);
      
      //if(SwitchMount == true) {BuildSets()translate([0,0,1])Switch();}
    }
  } // end cut

}



module BuildThumbC(plateThickness = 2, offsets = caseSpacing+1, web = 1, Mount = false, SwitchMount = false)
{
  refDim =plateDimension +[0,0,offsets];
  buildDim = [plateDimension[0], plateDimension[1], plateThickness];
  buildDim2 = [plateDimension[0],plateDimension[1] , plateDimension[2]+plateThickness];
  plateDim = plateDimension +[0,0,4.5];
  webDim =[web, plateDimension[1], plateThickness];
  height = -7.5;
  
  difference()
  {
    BaseTrans()
    {
      hull()
      {
        for (i = [0:3]) {PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP], plateDim, [0,0,BOTTOM], Hull= true, hullSide = [0,0,BOTTOM]);}
        BuildRmCn(R0, C2)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], Hull = true, hullSide = [0,0,BOTTOM]);
        PlaceOnThumb(1)translate([0,-7,-10])cube([28,28,1], center = true);
        rotate([0,0,-30])translate([-14.99,0, height])cube([.01,30,10], center = true);    
      }
      
      ///TOPs
      rotate([0,0,-30])translate([11,0, height])cube([52,30,10], center = true);  //top box

      hull()
      {
        BuildRmCn(R0,C5)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], true, [0,0,BOTTOM]);
        rotate([0,0,-30])translate([28.5,0, height-5])cube([17,30,.1], center = true);
        rotate([0,0,-30])translate([28.5,14.99, height])cube([17,.01,10], center = true);
//        rotate([0,0,-30])translate([30,14.99, height])cube([17,.01,10], center = true);
      }
      
      hull()
      {
        BuildRmCn(R0,C5)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], true, [0,FRONT,BOTTOM]);
        BuildRmCn(R1,C5)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], true, [0,BACK,BOTTOM]);
        rotate([0,0,-30])translate([28.5,0, height-5])cube([17,30,.1], center = true);
      }

//      hull()
//      {        
//        PlaceOnThumb(0)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [TOP,0,0]);  
//        PlaceOnThumb(2)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [TOP,0,0]);  
//        rotate([0,0,-30])translate([-14.99,0, height])cube([.01,30,10], center = true);
//      } 
//      
//      hull()
//      {        
//        PlaceOnThumb(2)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [TOP,BACK,0]);  
//       // PlaceOnThumb(3)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [0,BACK,0]);   
//        rotate([0,0,-30])translate([11,-14.99, height])cube([52,.01,10], center = true);  
//      } 
    }
    
    BaseTrans()
    {//cuts
      hull()
      {
        for ( i = [R0:R3])
        {
         PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP],buildDim+[0,0,1.5], [0,0,BOTTOM]);
        }    
      }
      PlaceOnThumb(1)translate([0,-7,-5])cube([26,28,10], center = true);
        //BuildRmCn(R0, C2)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], Hull = true, hullSide = [0,0,BOTTOM]);
        //BuildRmCn(R1, C2)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], Hull = true, hullSide = [0,BACK,BOTTOM]);
     
      hull()
      {
        PlaceOnThumb(1)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [BACK,0,0]);
        PlaceOnThumb(3)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [BACK,0,0]); 
        PlaceOnThumb(6)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM], Hull = true, hullSide = [FRONT,0,0]);
        PlaceOnThumb(1)translate([-13.99,-7,-10])cube([.01,28,1], center = true);
      }
      
      hull()
      {
        for (i = [0:3]) 
          {PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP], plateDim, [0,0,BOTTOM], Hull= true, hullSide = [0,0,0]);}
      }

      hull()
      {
        for (i = [0:3]) 
          {PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP], plateDim-[3,3,0], [0,0,BOTTOM], Hull= true, hullSide = [0,0,0]);}
        BuildRmCn(R0,C2)translate([0,0,-6])cylinder(d= 5, 1, center = true);
      }
      
      for(j  = [C1:C2]) // back plate cuts
      {
        hull()
        {
          for ( i = [R0:R3])
          {
            BuildRmCn(i, j)modulate(refDim,[0,0,BOTTOM], buildDim-[0,0,0], [0,0,BOTTOM]); 
            
          }
        }
      }
      
      hull(){BuildWebs(plateThickness, web, offsets, BOTTOM, C1);}
      hull(){BuildWebs(plateThickness, web, offsets, BOTTOM, C2);}          
            
      hull() //Front plate
      {
        for ( i = [R0:R3])
        {
          PlaceOnThumb(i)modulate(refDim,[0,0,sides], buildDim);
        }
      }
      
      BuildBetweenB()translate([0,0,0])cylinder(d= dMount, 15,center = false); // thead func here
      BuildBetweenA()translate([0,0,0])cylinder(d= dMount, 10,center = false); // thead func here
      
      PlaceOnThumb(10)translate([0,0,8])cylinder(d1 =dMount, d2= dChamfer, 2.5, center = true);
      PlaceOnThumb(10)cylinder(d= dMount, 80, center = true);
      
      BuildRmCn(R0,C2)cylinder(d= 5, 20, center = true);
      
      //TOPS
      
     // rotate([0,0,-30])translate([10,0, height+4.5])cube([50,30,1], center = true);  // topplate
      rotate([0,0,-30])translate([25.01,0, height+2.51])cube([24,27.5,5], center = true);  //battery chamber
      rotate([0,0,-30])translate([-1.0,0, height+2.71])cube([25,26,7], center = true);  //NRF chamber
      rotate([0,0,-30])translate([13,13.5, -9])mirror([0,1,0])Battery_holder(); 
      
      hull(){
        for ( i = [R0:R3])//thumb plate
        {
          PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP],plateDim, [0,0,BOTTOM]);
        }    
      }
      
      PlaceOnThumb(3)modulate(refDim+[0,-3,-8.3],[0,BACK,BOTTOM], buildDim+[-10,-15,5], [0,FRONT,BOTTOM]); //though hole
      
    //## cuts for C5 and web 
      BuildColumn(plateDimension[2]+4.5, 0, TOP, C5);
      BuildWebs(plateDimension[2]+4.5, webThickness, 0, TOP, C4);  
      BuildColumn(plateDimension[2]+4.5, 0, TOP, C3);
      BuildWebs(plateDimension[2]+4.5, webThickness, 0, TOP, C3); 
      BuildWebs(plateDimension[2]+4.5, webThickness, 0, TOP, C2); 
      
      rotate([0,0,-30])translate([3.2, 0, -20])  cylinder(d = 5.1054, 20); //center hole for mounting 
    }
  }
 
}


module BuildBetweenA() 
{
  for(Cn = [C1:C5])
  {
    for(Rm = [R0,RMAX-1])
    {
      PlaceBetween(Rm,Cn)children();
    }
  }
  PlaceOnThumb(8, keys = false)children();
}

module BuildBetweenB() 
{
  PlaceBetween(R0,C3)children();
  PlaceBetween(R2,C3)children(); 
  PlaceBetween(R0,C5)children();
  PlaceBetween(R1,C5)children();
  PlaceBetween(R2,C5)children();
}

module BuildTopPlate(keyhole = false, Mount = true, channel = false)
{
  difference(){
    union()
    {//SwitchPlate
      for(cols = [C1:C5])
      {
        BuildColumn(plateDimension[2]+4.5, 0, TOP, cols);
       // BuildRmCn(R0, cols)modulate(plateDimension,[0,BACK,BOTTOM],[plateDimension[0],2, 2], [0,FRONT,BOTTOM]);
        if (cols < C5) 
        {
          BuildWebs(plateDimension[2]+4.5, webThickness, 0, TOP, cols);
        }
      }
    }
    
    
    union() // cuts
    {
      for(cols = [C1:C5])//SwitchPlate
      {
        BuildPlate(10, plateDimension[2]+3.6, BOTTOM, cols);
        BuildChannel(2, plateDimension[2]+3.6-2, BOTTOM, cols);
        hull()//intra column internal cuts
        {
          BuildInnerWebs(cols, sides = RIGHT);
          BuildInnerWebs(cols, sides = LEFT);
        }
        if (cols < C5)
        {
         hull()//inter column internal cuts
          {
            BuildInnerWebs(cols, sides = RIGHT);
            BuildInnerWebs(cols+1, sides = LEFT);
          }
        }
        
        if(Mount == true)
        {
         BuildBetweenA()cylinder(d2 =dMount, d1= dChamfer, 2.5, center = true);
         BuildBetweenA()cylinder(d= dMount, 70);
        }
        
        hull() //upper keyplates
        { 
          for(i = [0:3]){PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP],plateDimension, [0,0,BOTTOM]);}
        }  
      }
      
      if(channel == true)
      {
        BuildColumnChannel(2, plateDimension[2]+3.5-2, BOTTOM,R0);
        BuildColumnChannel(2, plateDimension[2]+3.5-2, BOTTOM,R2);
        BuildColumnChannel(2, plateDimension[2]+3.5-2, BOTTOM,R3);
      }
      
      if(keyhole == true)
      {
        BuildSets()Keyhole();
      }
      
      //channel plate
      BuildWebsCase(5, webThickness,plateDimension[2]+3.6-8, BOTTOM);
    }
  }
}


module TrackBall()
{
  difference(){
  linear_extrude(10)polygon(points = [ 
                  [0,0], //A
                  [0,-8], //B
                  [4.5, -8], //C
                  [4.5, -8 - 13.4], //D
                  [0, -8 - 13.4], //E
                  [0, -8 - 13.4 -11], //F
                  [15,-8 - 13.4 -11], //G
                  [15,-8 - 13.4 -11 -11.3], //H
                  [15 + 5.6,-8 - 13.4 -11 -11.3], //I
                  [15 + 5.6,-8 - 13.4 -11 -11.3 -12.7], //J
                  [15 + 5.6 + 12.1, -8 - 13.4 -11 -11.3 -12.7], //K
                  [15 + 5.6 + 12.1, -8 - 13.4 -11 -11.3 -12.7 + 7.4], //L
                  [15 + 5.6 + 12.1 + 25.75, -8 - 13.4 -11 -11.3 -12.7 + 7.4], //M
                  [15 + 5.6 + 12.1 + 25.75, -8 - 13.4 -11 -11.3 -12.7 + 7.4], //N
                  [15 + 5.6 + 12.1 + 25.75, -8 - 13.4 -11 -11.3 -12.7 + 7.4 + 12], //N
                  [13.2 +20, -8],  //P
                  [13.2, -8],  //P
                  [13.2, 0] //Q
                 ]
          );
          
    //cut rotary 
    translate([4.5, -8, 0]+[18, -2.5,0]-[0,19.4,1])cube([9,19.4,15]);
  }
}
module PalmMold(plateThickness = 2, offsets = caseSpacing+1, web = 1, Mount = false, SwitchMount = false)
{
  refDim =plateDimension +[0,0,offsets];
  buildDim = [plateDimension[0], plateDimension[1], plateThickness];
  buildDim2 = [plateDimension[0],plateDimension[1] , plateDimension[2]+plateThickness];
  plateDim = plateDimension +[0,0,4.5];
  webDim =[web, plateDimension[1], plateThickness];
  height = -1.5;


  difference()
  {
    
    rotate([0,0,-30])translate([11,0, height+2.5])cube([85,50,15], center = true);  //top box
    
    //cuts
    rotate([0,0,-30])translate([11,0, height])cube([52,30,10], center = true);  //top box
    
    hull()
    {
      for (i = [0:3]) {PlaceOnThumb(i)modulate(plateDimension,[0,0,TOP], plateDim, [0,0,BOTTOM], Hull= true, hullSide = [0,0,0]);}
      BuildRmCn(R0, C2)modulate(refDim,[0,0,BOTTOM], buildDim, [0,0,BOTTOM], Hull = true, hullSide = [0,0,BOTTOM]);
      PlaceOnThumb(1)translate([0,-7,-10])cube([28,28,1], center = true);
      rotate([0,0,-30])translate([-14.99,0, height])cube([.01,30,10], center = true);    
    }
  }
}


//Section A+D:: C0->C2: R0->R3 + T:R0 -> R7 and Trackpoint + 
//Section B:: C3->C5: R0->R3
//Section C:: Palm and Cases for MCU
//Section E:: Bases

MasterLogic = false;
module BaseTrans() {translate([0,0,65])rotate([0,0,0])children();}
    //translate([0,0,67.6])rotate([10,20,0])children();

//  #BaseTrans()BuildTopPlate(keyhole = false, Mount = false, channel = false);
// BuildPalm_Mount();
// %BaseTrans()BuildThumbB(keyhole = false);
  BuildThumbC(keyhole = false);
//  BaseTrans()PalmMold(keyhole = false);

//##################   Section E:: Bases    ##################
//color("silver")BaseTrans()translate([0,-32,-20])sphere(d = 40 );
//#BaseTrans()translate([20,0,-10])rotate([0,90,0])TrackBall();

//#BaseTrans()rotate([0,0,-30])translate([3.2, 0, -20])  cylinder(d = 30, 20);
//translate([-21,-10,-22])cube([75,40,25]);

//##################   Section F:: ETC    ##################


//  BaseTrans()BuildColumn(plateDimension[2], 0, TOP, C2);














