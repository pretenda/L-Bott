// 378 x 311 x 107 mm 18v LBoxx
lBoxxH = 107;
lBoxxW = 378;
lBoxxD = 311;


include <CoreXY_Scaler.scad>;



//translate([98,0,-44]) color("red") cube([6,200,50]);

// translate([46-3,-27+3,-9]) rotate([0,0,0])  %cube([lBoxxW, lBoxxD, lBoxxH], true);

//translate([33,0,0]) #cube(16);

//cube([300,200,1], true);


module lBase(motorCutout = true)
{
	difference() { 
	union() {
	translate([0,-14-.35,0]) cube([275.6,276.3-1.4/2,6],true);
	
	
		difference()
		{
		for ( i = [0 : fingerWidth * 2 : plateWidth] )
			{
				translate([- plateWidth/2 + fingerWidth/2 + i,-8 - 0.25*inchToMM + plateWidth/2+fingerDepth/2,0]) cube([fingerWidth, fingerDepth, plateDepth], true);
				translate([- plateWidth/2 + fingerWidth/2 + i,-8 - 0.25*inchToMM - plateWidth/2-fingerDepth/2,0]) cube([fingerWidth, fingerDepth, plateDepth], true);
			}

				translate([- plateWidth/2 + fingerWidth/2 + plateWidth,-8 - 0.25*inchToMM + plateWidth/2+fingerDepth/2,0]) cube([fingerWidth, fingerDepth+2, plateDepth+2], true);
				translate([- plateWidth/2 + fingerWidth/2 + plateWidth,-8 - 0.25*inchToMM - plateWidth/2-fingerDepth/2,0]) cube([fingerWidth, fingerDepth+2, plateDepth+2], true);
		}

		difference()
		{
		for (i = [0 : fingerWidth * 2 : plateHeight] )
			{
				translate([plateWidth/2+fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-i,0]) cube([fingerDepth, fingerWidth, plateDepth], true);
				translate([-plateWidth/2-fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-i,0]) cube([fingerDepth, fingerWidth, plateDepth], true);
			}

				translate([plateWidth/2+fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-plateWidth,0]) cube([fingerDepth+2, fingerWidth-0.7, plateDepth+2], true);
				translate([-plateWidth/2-fingerDepth/2,-8 - 0.25*inchToMM + plateWidth/2-fingerWidth/2-plateWidth,0]) cube([fingerDepth+2, fingerWidth-0.7, plateDepth+2], true);
		}
		}
		
		
		if (motorCutout == true)
		{
translate([99,-126.5,-10]) nema17Cube(true);
translate([-99.2,-126.5,-10]) nema17Cube(true);
}
translate ([0, -50, 0]) 
{
	translate ([0, 0, -5]) rotate([0,0,90]) arduinoMega();
	translate ([20, 85, -5]) rotate([0,0,-90]) raspi();
}
		}
	
}

translate([0,0,-3-50-6]) lBase();


module nema17Cube(cutout = false)
{
if (cutout == true)
{

color("blue") cube([49.2, 70, 48 + 1.9], true);
}
else { 
color("blue") cube([42.2, 42.2, 48 + 1.9], true);
color("blue") cylinder((39+1.9)/2+18, 5/2, 5/2);
}
}

translate([99,-126.5,-31]) nema17Cube();
translate([-99.2,-126.5,-31]) nema17Cube();


//translate([-99.2,-126.5-40,-31]) nema17Cube();


module raspi()
{
	
	%translate ([0,0,15]) cube (size = [85, 56, 3]);
	%translate([85-10,(56-15)/2,15]) cube (size = [20, 15,15]);
	
	// corner pegs
	difference() { 
		
		translate ([0,0,0]) cube (size = [85, 56, 15]);
		translate ([0.5,0.5,0]) cube (size = [85-1, 56-1, 15]);
		translate ([-5,5,-1]) cube (size = [85+10, 56-10, 15]);
		translate ([5,-5,-1]) cube (size = [85-10, 56+10, 15]);
	}
	translate ([85-5, 56-12.5, 0]) cylinder (h = 15, r1 = 2.5/2, r2 = 2.5/2);
	translate ([25.5, 18, 0]) cylinder (h = 15, r1 = 2.5/2, r2 = 2.5/2);
}

module arduinoMega()
{
	%translate([0,0,15]) cube (size = [101.6, 53.3,3]);
	
	
	// corner pegs
	difference() { 
		translate([0,0,0]) cube (size = [101.6, 53.3,15]);
		translate([0.5,0.5,-1]) cube (size = [101.6-1, 53.3-1,17]);
		translate([-5,5,-1]) cube (size = [101.6+10, 53.3-10,17]);
		translate([5,-5,-1]) cube (size = [101.6-10, 53.3+10,17]);
	}
	
	%translate([-5,10,15]) cube (size = [20, 15,15]);
	
	
	translate ([13.97, 02.54, 0]) cylinder (h = 15, r1 = 3.2/2, r2 = 3.2/2);
	translate ([15.24, 50.80, 0]) cylinder (h = 15, r1 = 3.2/2, r2 = 3.2/2);
	translate ([66.04, 35.56, 0]) cylinder (h = 15, r1 = 3.2/2, r2 = 3.2/2);
	translate ([66.04, 07.62, 0]) cylinder (h = 15, r1 = 3.2/2, r2 = 3.2/2);
	translate ([90.17, 50.80, 0]) cylinder (h = 15, r1 = 3.2/2, r2 = 3.2/2);
	translate ([96.52, 02.54, 0]) cylinder (h = 15, r1 = 3.2/2, r2 = 3.2/2);
	
	
}
