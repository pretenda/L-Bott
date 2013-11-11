// This is because i was a noob and didn't order the right size bore for the hobbed gear.
// Converts an 8mm bore to 5mm bore with a bit of luck.

$fa = 0.01;
$fs = 0.5;

difference()
{
	circle(8/2);
	circle(5/2);
	translate([0,5]) #square([3,10], true);
}
