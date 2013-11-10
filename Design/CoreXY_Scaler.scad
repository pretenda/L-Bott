// Licence : CC-BY-SA : CoreXY Scaler by Michael E. Sheldrake, Copyright 2012 This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/ or send a letter to: Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA


// Requires OpenSCAD version 2011.12 or greater


use <MCAD/boxes.scad>;

// also requires "corexy_lasercutpattern_subset_mm.dxf"
// for import()s below, for a few unchanged acrylic parts

pi=3.1415926535897932384626433832795;
inchToMM = 25.4; // all dimensions in millimeters
display_resolution = 48; // arc resolution ($fn) for visual render
dxf_resolution     = 48; // higher resolution used for DXF render

////////////////////////////////////////////////
////////////////////////////////////////////////
///  #                                    #  ///
///  #                                    #  ///
///  #                                    #  ///
/// //////////////////////////////////////// ///
/// ///===========////////////===========/// ///
/// ///           // CoreXY //           /// ///
/// ///           // Scaler //           /// ///
/// ///===========////////////===========/// ///
/// //////////////////////////////////////// ///
///  #                                    #  ///
///  #                                    #  ///
///  #                                    #  ///
////////////////////////////////////////////////
////////////////////////////////////////////////


xtravel = 80; // original is 6" (in mm)
ytravel = 75; // original is 4" (in mm) 

// in theory, i dont need the belt holders, so that should gain me approx an extra 30 mm, meaning i can take out 30mm of width and have enough to still have a 100x100 bed
ouside_only = true;
fingers = true;
fingerWidth = 15;
fingerDepth = 6;
as_DXF = false;

kerf= 0.635; // for tool that will cut the nested aluminum parts
             // 0.635mm is for Omax waterjet


// The purpose of this script is to scale the reference implementation of
// Ilan E. Moyer's CoreXY system to your desired printing or cutting envelope.
// The reference implementation claims a 6 inch by 4 inch envelope.
// (See http://corexy.com/ and http://www.thingiverse.com/thing:22005)

// Change xtravel and ytravel above to set your own envelope.
// Then render (F5) to make sure everything looks right at that scale.
// Some key dimensions for scaled components, like belts and shafts, will
// be reported in the console.

// To get 2D cut patterns for the scaled parts, as well as all the other
// aluminum and acrylic parts, set as_DXF above to true, and render with CGAL (F6).
// Then choose "export as DXF" from the Design menu.

// If you plan to actually cut these parts, you should set the kerf of your
// cutting tool above. This will NOT make offset patterns. The kerf is used 
// here to alter dimensions, when necessary, to make sure the aluminum parts 
// can be nested when using a tool with a kerf larger than 2mm.

// The dimensions for the "belt buckles" in the acrylic part patterns
// are guessed - file or shim to suit.







// screw hole dims
tSlotScrewDrillDiameter      = 3.15; // M3 - sized to let screws pass through
plateScrewDrillToTapDiameter = 2.5;  // M3 - sized to tap
bearingScrewDrillDiameter    = 3.3;  // M4 - sized to tap for shoulder screw pulley axles

beltWidth         = 1;

// these pulley dimensions are specific to SDP/SI part A 6M16M018DF6006
pulleyDiam        = 11.6;
pulleyTotalDiam   = 16;
pulleyBoreDiam    = 5;
pulleyHubDiam     = 13;
pulleyHeight      = 10.2;
pulleyTotalHeight = 17.5;
pulleyRadius      = pulleyDiam/2;

// the two key scaling calculations, relative to reference implementation
xPulleyDist       = 247.5 + (xtravel - 152.4); // 247.5 mm in ref imp gives 6in. (152.4 mm) travel
yPulleyDist       = 261.9 + (ytravel - 101.6); // 261.9 mm in ref imp gives 4in. (101.6 mm) travel

// couple fixed pulley location dims
xPulleySep        = 36.6;
yPulleyDistMinor  = yPulleyDist - pulleyDiam;

// derived and fixed dimensions for aluminum plates
plateWidth       = xPulleyDist + 2*pulleyDiam + 2*38.65 + 2*((kerf<2)?0:(-2 + kerf));
plateHeight      = yPulleyDist + 26.0 + 10;
plateDepth       = 6;
plateHoleWidth   = plateWidth - 2*30.3;
plateHoleHeight  = plateHeight - 94.7;

yPlateWidth      = xPulleyDist + 2*17.95;
yPlateHeight     = 86.55;
yPlateHoleWidth  = yPlateWidth  - 2*32.95 ;
yPlateHoleHeight = yPlateHeight - 2* 9.525;

xPlateWidth      = 2.5*inchToMM;
xPlateHeight     = 2.5*inchToMM;

// derived and fixed shaft dimensions
shaftDiameterY   = (3/8) * inchToMM;
shaftLengthY     = plateHoleHeight + 1 * inchToMM;
YShaftSep        = yPlateWidth + (-2.0*0.502461 + 2.0*(0.252460))*inchToMM; //~270.7mm in ref imp
shaftDiameterX   = (3/8) * inchToMM;
shaftLengthX     = YShaftSep - 0.657480*inchToMM;
XShaftSep        = 51.624992; // just what it is in the ref impl

// bushings, 3/8"ID, 1/2"OD, 1/2"L
bushingOD        = (1/2)*inchToMM;
bushingID        = (3/8)*inchToMM;
yBearingOffsetZ  = (bushingOD - bushingID)/2;
xBearingOffsetZ  = yBearingOffsetZ;

// calc motor shaft length required
motorShaftLength = pulleyTotalHeight + // assuming pulley and drive gear are pretty much the same dimensions
                   yBearingOffsetZ +
                   plateDepth;

// belt length calc - total of the two belts
beltsTotalLength = 3 * pi * pulleyDiam + 
                   2 * (xPulleyDist - xPlateWidth) + 
                   2 * yPulleyDist + 
                   2 * (yPulleyDistMinor - xPulleySep) + 
                   2 * sqrt(pow(yPulleyDist - yPulleyDistMinor,2) + pow(xPulleyDist+pulleyDiam,2))
                   ;

// acrylic plate dimensions
clampPlatesDepth = 4.5; // thickness of the acrylic parts in  ref impl
buckleHoleHeight = (clampPlatesDepth > beltWidth ? (clampPlatesDepth + 1) : beltWidth );

// color pallet
aluminum_color   = [130/255, 142/255, 154/255, 1.0];
rod_color        = [    0.7,     0.7,     0.7, 1.0];
acrylic_color    = [ 65/255,  78/255,  96/255, 0.7];
acrylic_color2   = [ 85/255, 156/255, 200/255, 0.8];

// report key dimensions to console
mmToIn_dpf=100;
function mmToIn(mm) = round((mm/inchToMM)*(mmToIn_dpf))/(mmToIn_dpf);
function rndmm2(mm) = round((mm)*(mmToIn_dpf))/(mmToIn_dpf);
// funny spacing is attempt to get nice formatting
// despite console's poportional font
echo(
str("\r\r",
"TOTAL BELT LENGTH    : ",  rndmm2(beltsTotalLength)  , " mm  (", mmToIn(beltsTotalLength)," in.)\r",
"SHAFT LENGTH FOR Y :   ",  rndmm2(shaftLengthY)      , " mm  (", mmToIn(shaftLengthY)    ," in.)\r",
"SHAFT LENGTH FOR X :   ",  rndmm2(shaftLengthX)      , " mm  (", mmToIn(shaftLengthX)    ," in.)\r",
"BASE PLATE WIDTH     :   ",rndmm2(plateWidth)        , " mm  (", mmToIn(plateWidth)      ," in.)\r",
"BASE PLATE HEIGHT    :   ",rndmm2(plateHeight)       , " mm  (", mmToIn(plateHeight)     ," in.)\r",
"    Y    PLATE WIDTH    :   ",rndmm2(yPlateWidth)    , " mm  (", mmToIn(yPlateWidth)     ," in.)\r",
"MOTOR SHAFT LENGTH SHOULD BE >= ", rndmm2(motorShaftLength) , " mm\r\r",
""));



// DISPLAY

$fn=display_resolution;

if (as_DXF) { // use with CGAL render to prepare DXF layout of all sheet parts, both aluminum and acrylic
	projection(cut=true, $fn=dxf_resolution) {
		translate([0,0,0.01]) {

			// ALUMINUM PARTS
			base_plate();
			if (kerf < 2.0001) { // then next X carriage can nest within Y carriage
				translate([-2 + kerf,0,0]) {
					translate([0,plateHoleHeight/2 - (yPlateHeight/2 + kerf),0]) y_plate();
					translate([-yPlateHoleWidth/2 + (xPlateWidth/2 + kerf),plateHoleHeight/2 - (yPlateHeight/2 + kerf) + (2.0 - kerf),0]) x_plate();
					}
				}
			else { // X carriage won't fit inside Y carriage - put it below
				translate([0,plateHoleHeight/2 - (yPlateHeight/2 + kerf),0]) y_plate();
				translate([-plateHoleWidth/2 + (xPlateWidth/2 + kerf),plateHoleHeight/2 - (yPlateHeight + 2*kerf  +  xPlateHeight/2),0]) x_plate();
				}
			
			// ACRYLIC PARTS 
			translate([0,plateHoleHeight/2 + 60,0]) {

				//two Y rail alignment blocks
				y_rail_block();
				translate([0,25,0]) y_rail_block();

				//two X rail alignment blocks
				translate([-(YShaftSep + 2*19.7624954)/2,50,0]) {
					translate([   (XShaftSep + 2*17.4625)/2     , 0, 0]) x_rail_block();
					translate([ 3*(XShaftSep + 2*17.4625)/2 + 5 , 0, 0]) x_rail_block();
					}

				// three bushing clamps
				translate([-(YShaftSep + 2*19.7624954)/2 + 4*(XShaftSep + 2*17.4625)/2,50,0]) {
					translate([ 22.65 + 10, 0,0]) bushing_clamp();
					translate([ 52.65 + 15, 0,0]) bushing_clamp();
					translate([ 82.65 + 20, 0,0]) bushing_clamp();
					}
	
				// three X carriage layers
				translate([-(YShaftSep + 2*19.7624954)/2,55 + xPlateHeight/2,0]) {
					translate([ 1 * (xPlateWidth + 32)/2      , 0, 0]) x_carriage_clip();
					translate([ 3 * (xPlateWidth + 32)/2 - 15 , 0, 0]) x_carriage_clip();
					translate([ 4 * (xPlateWidth + 32)/2 + 18 , 0, 0]) x_carriage_spacer();
					}
/*
				// four buckles
				translate([-(YShaftSep + 2*19.7624954)/2 + 4*(xPlateWidth + 32)/2 + 18 + xPlateWidth/2 + 10,55,0]) {
					translate([0, 1 * (buckleHoleHeight/2+3.5) +  0, 0]) buckle();
					translate([0, 3 * (buckleHoleHeight/2+3.5) +  2, 0]) buckle();
					translate([0, 5 * (buckleHoleHeight/2+3.5) +  4, 0]) buckle();
					translate([0, 7 * (buckleHoleHeight/2+3.5) +  6, 0]) buckle();
					}*/
				}
			}
		}
	}
else { // display assembly

	if (ouside_only == false)
	{
		translate([0,$t*ytravel-ytravel/2,yBearingOffsetZ  ]) y_plate();
		translate([0,$t*ytravel-ytravel/2,yBearingOffsetZ  ]) x_shafts();
		#translate([$t*xtravel-xtravel/2,$t*ytravel-ytravel/2,yBearingOffsetZ*2]) x_plate();



	translate([$t*xtravel-xtravel/2,$t*ytravel-ytravel/2,yBearingOffsetZ*2]) x_carriage_clips();
	%translate([$t*xtravel-xtravel/2,$t*ytravel-ytravel/2,yBearingOffsetZ*2]) cube([xtravel,ytravel,2], true);
	translate([0,$t*ytravel-ytravel/2,yBearingOffsetZ - plateDepth]) bushing_clamps();
	translate([0,0,0                ]) y_rail_blocks();
	translate([0,$t*ytravel-ytravel/2,yBearingOffsetZ  ]) x_rail_blocks();
	translate([0,0,0                ]) y_shafts();
	translate([0,0,yBearingOffsetZ  ]) drivers();
	translate([0,$t*ytravel-ytravel/2,yBearingOffsetZ  ]) yIdlers();
	translate([0,0,yBearingOffsetZ  ]) frameIdlers();
	}

	//translate([$t*50*2-50,$t*57*2-57,yBearingOffsetZ +15 ]) cube([100,100,2],true);

	cylinder(100,1,1);
	base_plate();
	}




// MODULES



// Aluminum Plates

module base_plate() {
	//color(aluminum_color)
	difference() {
		union() {
		//translate([0,-8 - 0.25*inchToMM,-plateDepth/2]) roundedBox([plateWidth, plateHeight, plateDepth], 11.3137, true);
		translate([0,-8 - 0.25*inchToMM,-plateDepth/2]) cube([plateWidth, plateHeight, plateDepth], true);


		difference()
		{
		for ( i = [0 : fingerWidth * 2 : plateWidth] )
			{
				translate([- plateWidth/2 + fingerWidth/2 + i,-8 - 0.25*inchToMM + plateHeight/2+fingerDepth/2,-plateDepth/2]) cube([fingerWidth, fingerDepth, plateDepth], true);
				translate([- plateWidth/2 + fingerWidth/2 + i,-8 - 0.25*inchToMM - plateHeight/2-fingerDepth/2,-plateDepth/2]) cube([fingerWidth, fingerDepth, plateDepth], true);
			}

				translate([- plateWidth/2 + fingerWidth/2 + plateWidth,-8 - 0.25*inchToMM + plateHeight/2+fingerDepth/2,-plateDepth/2]) cube([fingerWidth, fingerDepth+2, plateDepth+2], true);
				translate([- plateWidth/2 + fingerWidth/2 + plateWidth,-8 - 0.25*inchToMM - plateHeight/2-fingerDepth/2,-plateDepth/2]) cube([fingerWidth, fingerDepth+2, plateDepth+2], true);
		}

		difference()
		{
		for (i = [0 : fingerWidth * 2 : plateHeight] )
			{
				translate([plateWidth/2+fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-i,-plateDepth/2]) cube([fingerDepth, fingerWidth, plateDepth], true);
				translate([-plateWidth/2-fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-i,-plateDepth/2]) cube([fingerDepth, fingerWidth, plateDepth], true);
			}

				translate([plateWidth/2+fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-plateWidth,-plateDepth/2]) cube([fingerDepth+2, fingerWidth-0.7, plateDepth+2], true);
				translate([-plateWidth/2-fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-plateWidth,-plateDepth/2]) cube([fingerDepth+2, fingerWidth-0.7, plateDepth+2], true);
		}
		}	
union() {
			translate([0,0,0]) roundedBox([plateHoleWidth, plateHoleHeight, plateDepth*4], kerf/2, true);
			idler_holes_base();

			if (ouside_only == false)
			{
				driver_holes();
			}
			base_holes();
			}
		}
	}

module y_plate() {
	color(aluminum_color)
	difference() {
		translate([0,0,-plateDepth/2]) roundedBox([yPlateWidth, yPlateHeight, plateDepth], kerf/2, true);
		union() {

///////////////
			roundedBox([yPlateHoleWidth, yPlateHoleHeight, plateDepth*4], kerf/2, true);

			idler_holes_y();
			y_holes();
			}
		}
	}

module x_plate() {
	color(aluminum_color)
	difference() {
		translate([0,0,-plateDepth/2]) roundedBox([xPlateWidth, xPlateHeight, plateDepth], kerf/2, true);
		union() {
			difference() {
				union() {
					cube([1.5*inchToMM + 2*1.2, 1.5*inchToMM, plateDepth*4], true);
					translate([  0.75*inchToMM+1.2 , 10, 0]) cylinder(r=3.5,h=plateDepth*4,center=true);
					translate([  0.75*inchToMM+1.2 ,-10, 0]) cylinder(r=3.5,h=plateDepth*4,center=true);
					translate([-(0.75*inchToMM+1.2), 10, 0]) cylinder(r=3.5,h=plateDepth*4,center=true);
					translate([-(0.75*inchToMM+1.2),-10, 0]) cylinder(r=3.5,h=plateDepth*4,center=true);
					}
				difference() {
					cube([1.5*inchToMM, 1.5*inchToMM, plateDepth*4], true);
					roundedBox([1.5*inchToMM, 1.5*inchToMM, plateDepth*4.1], kerf/2, true);
					}
				translate([1.5+0.75*inchToMM,0,0]) roundedBox([3,13.0126232,plateDepth*4],1.5,true);
				translate([-(1.5+0.75*inchToMM),0,0]) roundedBox([3,13.0126232,plateDepth*4],1.5,true);
				translate([  1.5+0.75*inchToMM ,  13.0126232+2*3.5 ,0]) roundedBox([3,13.0126232,plateDepth*4],1.5,true);
				translate([  1.5+0.75*inchToMM ,-(13.0126232+2*3.5),0]) roundedBox([3,13.0126232,plateDepth*4],1.5,true);
				translate([-(1.5+0.75*inchToMM),  13.0126232+2*3.5 ,0]) roundedBox([3,13.0126232,plateDepth*4],1.5,true);
				translate([-(1.5+0.75*inchToMM),-(13.0126232+2*3.5),0]) roundedBox([3,13.0126232,plateDepth*4],1.5,true);
				}
			x_holes();
			}
		}
	}


// Acrylic Plates

module y_rail_blocks() {
	translate([0, (plateHoleHeight/2 + 5.5),-plateDepth]) rotate([90,0,0]) y_rail_block();
	translate([0,-(plateHoleHeight/2 + 5.5),-plateDepth]) rotate([90,0,0]) y_rail_block();
	}

module x_rail_blocks() {
	translate([ (yPlateWidth/2-32.95 + 4.5),0,-plateDepth]) rotate([90,0,90]) x_rail_block();
	translate([-(yPlateWidth/2-32.952 + 4.5),0,-plateDepth]) rotate([90,0,90]) x_rail_block();
	}

module y_rail_block(m=3) {
	color(acrylic_color) {
	translate([0,-10,0]) {
	difference() {
		cube([YShaftSep + 2*19.7624954,20,clampPlatesDepth],center=true);

		// rod clamp space
		translate([-YShaftSep/2,10 - shaftDiameterY/2,0]) cylinder(r=shaftDiameterY/2,h=clampPlatesDepth*4,center=true);
		translate([-YShaftSep/2,20 - shaftDiameterY/2,0]) cube([shaftDiameterY,20,clampPlatesDepth*4],center=true);
		translate([ YShaftSep/2,10 - shaftDiameterY/2,0]) cylinder(r=shaftDiameterY/2,h=clampPlatesDepth*4,center=true);
		translate([ YShaftSep/2,20 - shaftDiameterY/2,0]) cube([shaftDiameterY,20,clampPlatesDepth*4],center=true);
		
		// for idler mount screw poke-through clearance
		translate([-xPulleyDist/2,10,0]) roundedBox([m+0.2,2,clampPlatesDepth*4],0.5,true);
		translate([ xPulleyDist/2,10,0]) roundedBox([m+0.2,2,clampPlatesDepth*4],0.5,true);

		// t slots
		translate([-(yPlateWidth/2 + 6.4791844)     ,10,0]) t_slot(m=m);
		translate([-(yPlateWidth/2 + 6.4791844) + 41,10,0]) t_slot(m=m);
		translate([ 0                               ,10,0]) t_slot(m=m);
		translate([ (yPlateWidth/2 + 6.4791844) - 41,10,0]) t_slot(m=m);
		translate([ (yPlateWidth/2 + 6.4791844)     ,10,0]) t_slot(m=m);

		// clip corners		
		translate([-(YShaftSep/2 + 19.7624954) - 0.01,-1.3397538,0]) rotate([0,0,-30]) translate([0,-2*20,-clampPlatesDepth*2]) cube([2*20,2*20,clampPlatesDepth*4],center=false);
		translate([ (YShaftSep/2 + 19.7624954) + 0.01,-1.3397538,0]) rotate([0,0,-60]) translate([0,-2*20,-clampPlatesDepth*2]) cube([2*20,2*20,clampPlatesDepth*4],center=false);

		}
	}
	}
	}

module x_rail_block(m=3) {
	color(acrylic_color) {
	translate([0,-10,0]) {
	difference() {
		cube([XShaftSep + 2*17.4625,20,clampPlatesDepth],center=true);

		// rod clamp space
		translate([-XShaftSep/2,10 - shaftDiameterX/2,0]) cylinder(r=shaftDiameterY/2,h=clampPlatesDepth*4,center=true);
		translate([-XShaftSep/2,20 - shaftDiameterX/2,0]) cube([shaftDiameterY,20,clampPlatesDepth*4],center=true);
		translate([ XShaftSep/2,10 - shaftDiameterX/2,0]) cylinder(r=shaftDiameterY/2,h=clampPlatesDepth*4,center=true);
		translate([ XShaftSep/2,20 - shaftDiameterX/2,0]) cube([shaftDiameterY,20,clampPlatesDepth*4],center=true);

		// t slots
		translate([-(35.8125014), 10, 0]) t_slot(m=m);
		translate([ 0           , 10, 0]) t_slot(m=m);
		translate([ (35.8125014), 10, 0]) t_slot(m=m);

		// clip corners		
		translate([-(XShaftSep/2 + 17.4625) - 0.01,-4.2264892,0]) rotate([0,0,-30]) translate([0,-2*20,-clampPlatesDepth*2]) cube([2*20,2*20,clampPlatesDepth*4],center=false);
		translate([ (XShaftSep/2 + 17.4625) + 0.01,-4.2264892,0]) rotate([0,0,-60]) translate([0,-2*20,-clampPlatesDepth*2]) cube([2*20,2*20,clampPlatesDepth*4],center=false);

		}
	}
	}
	}


module bushing_clamps(m=3) {
	translate([-(yPlateWidth/2 - 32.95 + 15.0 ), 36.925, 0]) rotate([90,0,0])   bushing_clamp(clampPlatesDepth);
	translate([-(yPlateWidth/2 - 32.95 + 15.0 ),-36.925, 0]) rotate([90,0,0])   bushing_clamp(clampPlatesDepth);
	translate([ (yPlateWidth/2 - 32.95 + 15.0),       0, 0]) rotate([90,0,180]) bushing_clamp(clampPlatesDepth);
	}

module bushing_clamp(h=1) {
	color(acrylic_color) linear_extrude(height=h, center=true) import("corexy_lasercutpattern_subset_mm.dxf",layer="bushing_clamp",convexity=5);
	}

module x_carriage_clips(m=3) {
	translate([0,0,clampPlatesDepth/2]) mirror([1,0,0])      x_carriage_clip(clampPlatesDepth);
	translate([0,0,clampPlatesDepth/2 + clampPlatesDepth])   x_carriage_spacer(clampPlatesDepth);
	translate([0,0,clampPlatesDepth/2 + 2*clampPlatesDepth]) x_carriage_clip(clampPlatesDepth);
	}

module x_carriage_clip(h=1) {
	color(acrylic_color) linear_extrude(height=h, center=true) import("corexy_lasercutpattern_subset_mm.dxf",layer="x_carriage_clip",convexity=5);
	}

module x_carriage_spacer(h=1) {
	color(acrylic_color2) linear_extrude(height=h, center=true) import("corexy_lasercutpattern_subset_mm.dxf",layer="x_carriage_spacer",convexity=5);
	}

module buckle() { // no drawing for this - guessing on tight-fit dimensions
	color(acrylic_color)	
	difference() {
		roundedBox([9.21 - 0.11 + 2*3.5, buckleHoleHeight + 2*3.5,clampPlatesDepth  ],1,true);
		roundedBox([9.21 - 0.11        , buckleHoleHeight        ,clampPlatesDepth*3],0.5,true);
		}
	}

module t_slot(m=3,len=12) {
	translate ([0,-((len - plateDepth) + 0.7625)/2,0]) 
	union() {
		// screw space
		roundedBox([m+0.2,(len - plateDepth) + 0.7625 + 0.01,clampPlatesDepth*4],0.5,true);
		translate([0,1,0]) cube([m+0.2,(len - plateDepth) + 0.7625 + 0.01,clampPlatesDepth*4],center=true);
		// nut space - tried to make scalable, but not verified - should work with M3 though
		translate([0,-(1/6)*m,0]) cube([m*1.91,(5/6)*m + (1/12)*m,clampPlatesDepth*4],center=true);
		}
	}


// Precision Shafts

module y_shafts() {
	color(rod_color) {
	translate([-YShaftSep/2,0,-shaftDiameterY/2 - plateDepth]) rotate([90,0,0]) cylinder(r=shaftDiameterY/2,h=shaftLengthY,center=true);
	translate([ YShaftSep/2,0,-shaftDiameterY/2 - plateDepth]) rotate([90,0,0]) cylinder(r=shaftDiameterY/2,h=shaftLengthY,center=true);
	}
	}

module x_shafts() {
	color(rod_color) {
	translate([0,-XShaftSep/2,-shaftDiameterY/2 - plateDepth]) rotate([90,0,90]) cylinder(r=shaftDiameterX/2,h=shaftLengthX,center=true);
	translate([0, XShaftSep/2,-shaftDiameterY/2 - plateDepth]) rotate([90,0,90]) cylinder(r=shaftDiameterX/2,h=shaftLengthX,center=true);
	}
	}


// Belt Pulleys

module drivers() {
	translate([ xPulleyDist/2 + pulleyDiam, -plateHoleHeight/2 - 35.7, 0.1]) pulley(-1);
	translate([-xPulleyDist/2 - pulleyDiam, -plateHoleHeight/2 - 35.7, 0.1]) pulley( 1);
	}

module frameIdlers() {
	translate([ xPulleyDist/2 + pulleyDiam,  (plateHoleHeight/2 + 23), 0.1]) pulley(-1);
	translate([-xPulleyDist/2 - pulleyDiam,  (plateHoleHeight/2 + 23), 0.1]) pulley( 1);
	
	translate([ xPulleyDist/2,  (plateHoleHeight/2 + 23) - pulleyTotalDiam, 0.1]) pulley( 1);
	translate([-xPulleyDist/2,  (plateHoleHeight/2 + 23) - pulleyTotalDiam, 0.1]) pulley(-1);
	
	}



module yIdlers() {
	
	translate([ xPulleyDist/2,  xPulleySep/2,              0.1]) pulley( 1);
	translate([ xPulleyDist/2, -xPulleySep/2,              0.1]) pulley(-1);
	translate([-xPulleyDist/2,  xPulleySep/2,              0.1]) pulley(-1);
	translate([-xPulleyDist/2, -xPulleySep/2,              0.1]) pulley( 1);
	}

// Holes

module idler_holes_base() {
	translate([ xPulleyDist/2 + pulleyDiam, plateHoleHeight/2 + 23, 0])        bearingScrewDrillHole();
	translate([ xPulleyDist/2, (plateHoleHeight/2 + 23) - pulleyTotalDiam, 0]) bearingScrewDrillHole();
	translate([-xPulleyDist/2 - pulleyDiam, plateHoleHeight/2 + 23, 0])        bearingScrewDrillHole();
	translate([-xPulleyDist/2, (plateHoleHeight/2 + 23) - pulleyTotalDiam, 0]) bearingScrewDrillHole();
	}

module idler_holes_y() {
	translate([ xPulleyDist/2,  xPulleySep/2, 0]) bearingScrewDrillHole();
	translate([ xPulleyDist/2, -xPulleySep/2, 0]) bearingScrewDrillHole();
	translate([-xPulleyDist/2,  xPulleySep/2, 0]) bearingScrewDrillHole();
	translate([-xPulleyDist/2, -xPulleySep/2, 0]) bearingScrewDrillHole();
	}

module driver_holes() {
	translate([ xPulleyDist/2 + pulleyDiam, -plateHoleHeight/2 - 35.7, 0]) driver_hole();
	translate([-xPulleyDist/2 - pulleyDiam, -plateHoleHeight/2 - 35.7, 0]) driver_hole();
	}

module driver_hole(nema=17,slide=4) {
	translate([0,-(0.25*24)/2,0]) {
		roundedBox([24,24 + slide,(pulleyHeight+plateDepth)*4],24/2,true);
		translate([ 15.5, 15.5,0]) roundedBox([3.75,3.75 + slide,(pulleyHeight+plateDepth)*4],3.75/2,true);
		translate([ 15.5,-15.5,0]) roundedBox([3.75,3.75 + slide,(pulleyHeight+plateDepth)*4],3.75/2,true);
		translate([-15.5, 15.5,0]) roundedBox([3.75,3.75 + slide,(pulleyHeight+plateDepth)*4],3.75/2,true);
		translate([-15.5,-15.5,0]) roundedBox([3.75,3.75 + slide,(pulleyHeight+plateDepth)*4],3.75/2,true);
		}
	}

module base_holes() {
	translate([-(yPlateWidth/2 + 6.4791844),0,0]) {
		translate([  0, (plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		translate([  0,-(plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		translate([ 41, (plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		translate([ 41,-(plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		}
	translate([   0     , (plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
	translate([   0     ,-(plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
	translate([ (yPlateWidth/2 + 6.4791844),0,0]) {
		translate([-41, (plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		translate([-41,-(plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		translate([  0, (plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		translate([  0,-(plateHoleHeight/2 + 5.5), 0]) tSlotScrewDrillHole();
		}
	}

module x_holes() {
	translate([inchToMM,0,0]) {
		translate([ 0,     inchToMM+0.412496 , 0]) plateScrewDrillToTapHole();
		translate([ 2.35,                  10, 0]) plateScrewDrillToTapHole();
		translate([ 2.35,                 -10, 0]) plateScrewDrillToTapHole();
		translate([    0,-(inchToMM+0.412496), 0]) plateScrewDrillToTapHole();
		}

	translate([-inchToMM,0,0]) {
		translate([    0,   inchToMM+0.412496, 0]) plateScrewDrillToTapHole();
		translate([-2.35,                  10, 0]) plateScrewDrillToTapHole();
		translate([-2.35,                 -10, 0]) plateScrewDrillToTapHole();
		translate([    0,-(inchToMM+0.412496), 0]) plateScrewDrillToTapHole();
		}
	}

module y_holes() {
	translate([yPlateWidth/2 - 32.95,0,0]) {
		translate([ 4.5,  35.8125 , 0]) tSlotScrewDrillHole();
		translate([ 4.5,   0      , 0]) tSlotScrewDrillHole();
		translate([ 4.5, -35.8125 , 0]) tSlotScrewDrillHole();
		translate([15.0,   0      , 0]) tSlotScrewDrillHole();
		}
	translate([-(yPlateWidth/2 - 32.95),0,0]) {
		translate([ -4.5,  35.8125 , 0]) tSlotScrewDrillHole();
		translate([ -4.5,   0      , 0]) tSlotScrewDrillHole();
		translate([ -4.5, -35.8125 , 0]) tSlotScrewDrillHole();
		translate([-15.0,  36.925  , 0]) tSlotScrewDrillHole();
		translate([-15.0, -36.925  , 0]) tSlotScrewDrillHole();
		}
	}

module bearingScrewDrillHole() {
	cylinder(h=(pulleyHeight+plateDepth)*4, center=true, r=bearingScrewDrillDiameter/2);
	}

module tSlotScrewDrillHole() {
	cylinder(h=plateDepth*4,                center=true, r=tSlotScrewDrillDiameter/2);
	}

module plateScrewDrillToTapHole() {
	cylinder(h=plateDepth*4,                center=true, r=plateScrewDrillToTapDiameter/2);
	}

module pulley(orient=1) { // orient is 1 or -1
	translate([0, 0, orient * -pulleyTotalHeight/2 + pulleyTotalHeight/2])
	scale([ 1, 1, orient ]) 
	SDP_SI_A6M16M018DF6006(); 

	}

module SDP_SI_A6M16M018DF6006() {
	difference() {
		union() {
			// toothed pulley
			color([0.2,0.2,0.2,1]) 
			translate([0,0,pulleyTotalHeight-(pulleyHeight)]) 
			cylinder(r=pulleyTotalDiam/2,h=pulleyHeight,center=false);
			// hub
			color([0.7,0.7,0.7,1]) 
			cylinder(r=pulleyHubDiam/2,h=pulleyTotalHeight-(pulleyHeight),center=false);
			}
		//bore
		color([0.2,0.2,0.2,1]) 
		cylinder(h=(pulleyTotalHeight+1)*4,r=pulleyBoreDiam/2,center=true);
		}
	}
