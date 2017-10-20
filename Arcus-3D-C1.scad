// Arcus-3D-C1 - Cable printer OpenSCAD source

// Licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License
// http://creativecommons.org/licenses/by-sa/3.0/

// Project home
// https://hackaday.io/project/26938
//

// The parts for rendering
// Uncomment each part here, save, render, then export to STL.

//top_corner();
//bottom_corner();
//stepper_mount();
//spool_bearing();
//shaft_coupler();
//extruder_mount();
//extruder_top();
//extruder_bottom();
//extruder_spacer();
extruder_knob();
//dampener();
//end_effector_body();
//end_effector_joint();
//push_rod_joint();
//push_rod_top();
// push_rod_stop();
//push_rod_clamp();
//push_rod_knob();
// Drilling template for the AL spool rod
//spool_rod_template();

// Assembled top corner for visualization
//top_corner_assembly();

// Assembled extruder for visualization
//extruder_assembly();

// Assembled end effector for visualization
//end_effector_assembly();

// Assembled clamp for visualization
//push_rod_clamp_assembly();


// Extrusion compensation
// All the holes are this much larger than the actual setting.
// I tend to over-extrude a bit for strength on structural parts and this compensates.
// Print the shaft coupler first and if it fits the stepper shaft loosely, decrease this number. 
clearance=.20; 

// Unless you need to change something about the design, nothing below here needs editing.

// Rendering
$fn=90; // circle complexity.  Turn down while editing, up while rendering.
//$fn=30;

// General
roswell_constant=19.47; // Angle from vertical which makes an octahedron. 
// There is a geometric reason this angle works, but I'm too lazy to find it.
wall_thickness=2.0; // Everything is a multiple of this general wall thickness.

// End effector
effector_offset=wall_thickness; // Offset from colinear of neighboring axis cable holes.
effector_spacing=63.5; // Distance between parallel lines on the end effector.
effector_hinge_thickness=wall_thickness*1.75; // Hinge thickness at contact point.
effector_ring_dia=effector_spacing/1.75; // Support ring dia.
effector_ring_height=effector_spacing/5; //Support ring height.
effector_bearing_dia=1.78; // Pin for U joint, aka, some printer filament.
effector_fitting_dia=8; // Fits the flange on a push fitting.
effector_fitting_flange_height=2; // Fits the flange on a push fitting.

cable_hole_dia=1.0; // Holes for lines.

// Corners supports
support_rod_dia=8.2; // Driveway marker diameter.
support_rod_depth=20; // Depth of the pockets for support rods.
pulley_thickness=4.5; // 4mm really, but cleanup here is a pita.
pulley_outer_dia=14.5; // 13mm really, but bridge can droop.
pulley_inner_dia=11; // Center dia for spooling.
pulley_bolt_dia=4; // Pulley bolt dia.
pulley_offset=0; // Move pulley location in or out a bit from center of machine.  Wasn't needed.
pulley_skew=1.2; // This tries to compensate for horizontal offset from the pulley by skewing the size of the virtual pulley on the effector.

// Push rod
push_rod_dia=7.75; // Garden stake was this dia.
push_rod_stop_bolt=3.1;
push_rod_depth=20; // Depth of pocket for stake.
push_rod_slide=25; // How tall to make the sliding portion.

// Rollerblade bearing, 8mm id
spool_bearing_thickness=7; // Depth of pocket for bearing.
spool_bearing_dia=22; // Pocket dia for bearing.

// Steppers
stepper_size=43; // Square size of stepper.
stepper_oversize=7; // Flange is embiggend this much for clearance.
stepper_flange_dia=22.5; // Raised flange on stepper dia.
stepper_bolt_spacing=31; // Bolt spacing on stepper.
stepper_bolt_dia=3; // Inner hole size for dampeners
stepper_damper_dia=7; // Outer size for dampeners.  For no dampeners, set to 3.1.
// Extruder
extruder_bolt=4.75;
// Shaft coupler from stepper to AL spooling rod.
coupler_length=18; // Overall length for coupler.  Each shaft gets half.
coupler_d_shaft_dia=5; // Stepper shaft dia.
coupler_shaft_dia=7.79; // 5/16in AL rod in mm.

// Limit switches
limit_switch_thickness=6.5;


extra=.02; // for differencing

module top_corner_assembly() {
	%top_corner();
	translate([0,0,support_rod_dia/2+.4]) rotate([90,0,0]) cylinder(r=13/2+clearance,h=4,center=true);
	translate([-22,0,13.5]) rotate([0,90+roswell_constant,0]) limit_switch();
}

module extruder_assembly() {
	translate([0,0,stepper_size+2]) extruder_top();
	translate([0,12,stepper_size/2]) rotate([90,0,180]) extruder_mount();
	translate([0,-31,0]) extruder_spacer();
	translate([0,0,-2]) rotate([0,180,0]) extruder_bottom();
	translate([0,-7.5,42/2]) cube([42,38,42],center=true);
}

module end_effector_assembly() {
	end_effector_body();
	translate([0,0,effector_ring_height+effector_bearing_dia/2-effector_bearing_dia*2]) end_effector_joint();
	translate([0,0,push_rod_depth*2+effector_ring_height+effector_bearing_dia/2]) rotate([180,0,0]) push_rod_joint();
}

module push_rod_clamp_assembly() {
	push_rod_clamp();
	translate([0,-15,0]) push_rod_knob();
}

module limit_switch_cutout() {
	union() {
		hull() {
			translate([0,0,16.5/2+clearance]) cube([25+clearance*2,6.5+clearance*2,12.5+clearance*2],center=true);
			translate([2,0,2.5/2+clearance]) cube([27+clearance*2,5.5+clearance*2,3.5+clearance*2],center=true);
			translate([10,0,18]) rotate([90,0,0]) cylinder(r=5/2,h=5.5+clearance*2,center=true);
		}
		translate([9.5/2,0,13.5/2]) rotate([90,0,0]) cylinder(r=1+clearance,h=20,center=true);
		translate([-9.5/2,0,13.5/2]) rotate([90,0,0]) cylinder(r=1+clearance,h=20,center=true);
	}
}
module limit_switch() {
	difference() {
		union() {
			translate([0,0,15.5/2+clearance]) cube([20+clearance*2,6.5+clearance*2,9.5+clearance*2],center=true);
			translate([8.2,0,1.5]) cube([1,3,3],center=true);
			translate([1,0,1.5]) cube([1,3,3],center=true);
			translate([-8,0,1.5]) cube([1,3,3],center=true);
			translate([2,0,28/2+clearance]) rotate([0,-10,0]) {
				cube([17.5,4,.5],center=true);
				translate([17.5/2-1,0,5/2]) rotate([90,0,0]) cylinder(r=5/2,h=3.1,center=true);
			}
			
		}
	}
}

module spool_rod_template() {
	difference() {
		translate([0,spool_bearing_thickness+wall_thickness,coupler_shaft_dia/6+wall_thickness/2]) cube([coupler_shaft_dia+wall_thickness,effector_spacing*2+spool_bearing_thickness+wall_thickness*2+coupler_length/2+wall_thickness*2,coupler_shaft_dia/3+wall_thickness],center=true);
		translate([0,spool_bearing_thickness,coupler_shaft_dia/2+wall_thickness]) rotate([90,0,0]) cylinder(r=coupler_shaft_dia/2+clearance,h=effector_spacing*2+spool_bearing_thickness+wall_thickness*2+coupler_length/2+extra,center=true);		
		translate([0,-effector_spacing/2,0]) cylinder(r=cable_hole_dia/2,h=coupler_shaft_dia,center=true);		
		translate([0,effector_spacing/2,0]) cylinder(r=cable_hole_dia/2,h=coupler_shaft_dia,center=true);		
		translate([0,0,0]) cylinder(r=cable_hole_dia/2,h=coupler_shaft_dia,center=true);		
		translate([0,-effector_spacing,coupler_shaft_dia/3+wall_thickness]) rotate([45,0,0]) cube([coupler_shaft_dia+wall_thickness+extra,wall_thickness,wall_thickness],center=true);		
		translate([0,effector_spacing,coupler_shaft_dia/3+wall_thickness]) rotate([45,0,0]) cube([coupler_shaft_dia+wall_thickness+extra,wall_thickness,wall_thickness],center=true);		
	}
}

module end_effector_body() {
	union() {
		difference() {
			union() {
				// base
				translate([0,0,wall_thickness/2]) hull() for (i=[-120,0,120]) for (j=[-60,60]) {
					rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,0]) rotate([0,0,j]) translate([effector_offset,0,0]) cylinder(r=pulley_inner_dia/2-wall_thickness/2,h=wall_thickness,center=true);
				}
				// corners
				for (i=[-120,0,120]) hull() for (j=[-60,60]) {
					rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,pulley_inner_dia/4-extra]) rotate([0,0,j]) translate([effector_offset,0,0]) scale([1,pulley_skew,1]) cylinder(r=pulley_inner_dia/2+wall_thickness/2,h=pulley_inner_dia/2-extra*2,center=true);
				}
				// ribs
				for (i=[-120,0,120]) for(j=[-pulley_inner_dia/2-effector_offset,pulley_inner_dia/2+effector_offset]) hull() {
					rotate([0,0,i]) translate([effector_ring_dia/2,j,effector_ring_height/2-wall_thickness/2]) cylinder(r=wall_thickness/2,h=effector_ring_height-wall_thickness,center=true);
					rotate([0,0,i]) translate([effector_spacing/sqrt(3)-wall_thickness,j,pulley_inner_dia/4-wall_thickness/3]) cylinder(r=wall_thickness/2,h=pulley_inner_dia/2-wall_thickness/1.5,center=true);
				}
				// ring
				translate([0,0,effector_ring_height/2]) cylinder(r=effector_ring_dia/2+wall_thickness*1.25,h=effector_ring_height,center=true);
			}
			// base center hole
			translate([0,0,effector_ring_height/2+effector_fitting_flange_height/2]) cylinder(r=effector_ring_dia/2,h=effector_ring_height-effector_fitting_flange_height+extra,center=true);
			// cable holes/virtual pulleys
			for (i=[-120,0,120]) for (j=[-60,60]) {
				rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,]) rotate([0,0,j]) translate([effector_offset,0,0]) inverted_pulley();
			}
			// wire holes
			for (i=[0,180]) rotate([0,0,i]) hull() for (j=[15,-15]) {
				rotate([0,0,j]) translate([effector_ring_dia/3.5,0,0]) cylinder(r=effector_fitting_dia/2.5,h=effector_ring_height,center=true);
			}
			// ring
			cylinder(r=effector_fitting_dia/2,h=effector_ring_height,center=true);
			// clearance check
			// for (i=[-30,30]) translate([0,0,effector_ring_height+effector_bearing_dia/2-effector_bearing_dia*2]) rotate([i,0,0]) end_effector_joint();
		}
		// hinges
		difference() {
			for (i=[0,180]) hull() {
				rotate([0,0,i]) translate([effector_ring_dia/2+effector_hinge_thickness/2-wall_thickness/2-clearance/2,0,effector_ring_height+effector_bearing_dia/2]) rotate([0,90,0]) cylinder(r=effector_ring_height/3,h=effector_hinge_thickness+clearance,center=true);
				rotate([0,0,i]) translate([effector_ring_dia/2+effector_hinge_thickness/2-wall_thickness/2-clearance/2,0,wall_thickness/2]) cube([effector_hinge_thickness+clearance,effector_ring_height,wall_thickness],center=true);
			}
			translate([0,0,effector_ring_height+effector_bearing_dia/2]) rotate([0,90,0]) cylinder(r=effector_bearing_dia/2,h=effector_ring_dia*2,center=true);
		}
	}
	
}
module inverted_pulley() {
	scale([1,pulley_skew,1]) union() {
		difference() {
			translate([0,0,pulley_inner_dia/2]) cylinder(r=pulley_inner_dia/2+cable_hole_dia,h=pulley_inner_dia,center=true);
			intersection() {
				rotate_extrude(convexity = 10) translate([pulley_inner_dia/2+cable_hole_dia/2,0,0]) circle(r=pulley_inner_dia/2);
				translate([0,0,pulley_inner_dia/2]) cylinder(r=pulley_inner_dia/2+cable_hole_dia,h=pulley_inner_dia+extra,center=true);
			}
		}
		cylinder(r=cable_hole_dia/2,h=wall_thickness,center=true);
	}
}
module end_effector_joint() {
	difference() {
		union() {
			difference() {
				translate([0,0,effector_bearing_dia*2]) intersection() {
					sphere(r=effector_ring_dia/2-effector_hinge_thickness/2,center=true);
					cylinder(r=effector_ring_dia/2-effector_hinge_thickness/2,h=effector_bearing_dia*4,center=true);
				}
				translate([0,0,effector_ring_height/2]) cylinder(r=effector_ring_dia/2-effector_hinge_thickness*1.5,h=effector_ring_height+extra,center=true);
			}
			translate([0,0,effector_bearing_dia*2]) intersection() {
				cylinder(r=effector_ring_dia/2,h=effector_bearing_dia*4,center=true);
				for (i=[0,90,180,270]) rotate([0,0,i]) translate([effector_ring_dia/2-effector_hinge_thickness*.75-wall_thickness/2-clearance*2,0,0]) rotate([0,90,0]) cylinder(r1=effector_ring_height/1.5,r2=effector_ring_height/3,h=effector_hinge_thickness*1.5-clearance,center=true);
			}
		}
		for (i=[0,90]) rotate([0,0,i]) translate([0,0,effector_bearing_dia*2]) rotate([0,90,0]) cylinder(r=effector_bearing_dia/2,h=effector_ring_dia*2,center=true);
	}
}

module push_rod_joint() {
	jwidth=effector_ring_dia-effector_hinge_thickness*3.5-wall_thickness/2-clearance*3;
	difference() {
		union() {
			hull() {
				translate([effector_ring_height/4,0,push_rod_depth*3]) rotate([90,0,0]) cylinder(r=effector_ring_height/3,h=jwidth,center=true);
				translate([effector_ring_height/4,0,push_rod_depth*2]) rotate([90,0,0]) cylinder(r=effector_ring_height/3,h=jwidth,center=true);
			}
			hull() {
				translate([effector_ring_height/4,0,push_rod_depth*2]) rotate([90,0,0]) cylinder(r=effector_ring_height/3,h=jwidth,center=true);
				translate([0,0,push_rod_depth/1.5-extra]) cylinder(r=effector_ring_height/3+wall_thickness,h=extra,center=true);
			}
			translate([0,0,push_rod_depth/3]) cylinder(r=effector_ring_height/3+wall_thickness,h=push_rod_depth/1.5,center=true);
			hull() {
				translate([-effector_ring_height/1.5-wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_ring_height/2.5,h=wall_thickness*2,center=true);
				translate([effector_ring_height/2+wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_ring_height/3,h=wall_thickness*2,center=true);
			}
		}
		hull() {
			translate([0,0,push_rod_depth*3]) cube([push_rod_dia*5,jwidth-effector_hinge_thickness*2,push_rod_dia*5],center=true);
			translate([0,0,push_rod_depth+wall_thickness]) rotate([0,90,0]) scale([1.25,.75,1]) cylinder(r=push_rod_dia/2,h=push_rod_dia*2,center=true);
			//translate([0,0,push_rod_depth*1+wall_thickness*1.5]) rotate([90,0,0]) cube([push_rod_dia+wall_thickness*3,push_rod_dia-wall_thickness,clearance],center=true);
		}
		translate([0,0,push_rod_depth/2]) cylinder(r=push_rod_dia/2+clearance,h=push_rod_depth+extra,center=true);
		translate([effector_ring_height/4,0,push_rod_depth*3]) rotate([90,0,0]) {
			cylinder(r=effector_bearing_dia/2,h=effector_ring_dia-wall_thickness/1.5-wall_thickness*2-wall_thickness/1.2-clearance*2+extra,center=true);
			translate([0,0,effector_ring_dia/2-wall_thickness/3-wall_thickness*4-wall_thickness/2.4-clearance*4]) cylinder(r2=effector_bearing_dia/2,r1=effector_bearing_dia,h=effector_bearing_dia,center=true);
			translate([0,0,-effector_ring_dia/2+wall_thickness/3+wall_thickness*4+wall_thickness/2.4+clearance*4]) cylinder(r1=effector_bearing_dia/2,r2=effector_bearing_dia,h=effector_bearing_dia,center=true);
		}
			
		translate([push_rod_dia/2+wall_thickness/1.25,0,push_rod_depth*1.25]) rotate([0,-12.5,0]) cylinder(r=push_rod_dia/2-wall_thickness/2,h=push_rod_depth*2,center=true);	
		translate([-push_rod_dia/2-wall_thickness/1.25,0,push_rod_depth*1.25]) rotate([0,12.5,0]) cylinder(r=push_rod_dia/2-wall_thickness/2,h=push_rod_depth*2,center=true);	
		translate([-effector_ring_height/1.5-wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_ring_height/2.5-wall_thickness/2,h=wall_thickness*2+extra,center=true);
		translate([effector_ring_height/2+wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_ring_height/3-wall_thickness/2,h=wall_thickness*2+extra,center=true);
	}
}

module push_rod_top() {
	//cylinder(r=push_rod_dia/2,h=50,center=true);
	difference() {
		union() {
			translate([0,0,push_rod_slide/2]) cylinder(r=push_rod_dia/2+wall_thickness*1.5,h=push_rod_slide,center=true);
			translate([0,0,wall_thickness-wall_thickness/5]) hull() {
				rotate_extrude() {
					translate([push_rod_dia/2+wall_thickness*2.5,0]) circle(r=wall_thickness*1.5,center=true);
				}
			}
		}
		translate([0,0,push_rod_slide/2]) rotate([0,0,30]) cylinder(r=(push_rod_dia/2+2*clearance)*1.11,$fn=6,h=push_rod_slide+extra,center=true);
		for (i=[-120,0,120]) rotate([0,0,i]) translate([push_rod_dia/2+wall_thickness*2,0,wall_thickness*1.5]) cylinder(r=cable_hole_dia/2,h=wall_thickness*3+extra,center=true);
		translate([0,0,-25]) cylinder(r=50,h=50,center=true);
	}
}

module push_rod_clamp() {
	difference() {
		hull() {
			translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_dia/2+wall_thickness*1.25,h=push_rod_slide/2,center=true);
			//translate([push_rod_dia/2+push_rod_stop_bolt/2+wall_thickness*1.25,0,push_rod_slide/4]) cylinder([wall_thickness*4,push_rod_dia+wall_thickness*2.5,push_rod_slide/2],center=true);
			translate([push_rod_dia/2+push_rod_stop_bolt/2+wall_thickness/2,0,push_rod_slide/4]) rotate([90,0,0]) rotate([0,0,30]) cylinder(r=push_rod_slide/4,h=push_rod_dia+wall_thickness*2.5,center=true);
		}
		translate([push_rod_dia/2+push_rod_stop_bolt/2+wall_thickness*1.25,0,push_rod_slide/4]) cube([wall_thickness*5+extra,wall_thickness/2,push_rod_slide/2+extra],center=true);
		translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_dia/2+clearance/2,h=push_rod_slide/2+extra,center=true);
		translate([push_rod_dia/2+push_rod_stop_bolt/2+wall_thickness/2,0,push_rod_slide/4]) {
			rotate([0,90,90]) cylinder(r=push_rod_stop_bolt/2,h=push_rod_dia+wall_thickness*4,center=true);
			rotate([90,90,0]) translate([0,0,wall_thickness*3]) cylinder(r=push_rod_stop_bolt+clearance,$fn=6,h=wall_thickness*1.5,center=true);
		}
	}
}

module push_rod_knob() {
	difference() {
		union() {
			hull() {
				translate([-push_rod_dia,0,push_rod_slide/8]) cylinder(r=wall_thickness*1.25,h=push_rod_slide/4,center=true);
				translate([push_rod_dia,0,push_rod_slide/8]) cylinder(r=wall_thickness*1.25,h=push_rod_slide/4,center=true);
			}
			translate([0,0,push_rod_slide/8]) cylinder(r=push_rod_stop_bolt+clearance+wall_thickness,h=push_rod_slide/4,center=true);
		
		}
		translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_stop_bolt/2+clearance/2,h=push_rod_slide/2+extra,center=true);
		translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_stop_bolt+clearance,$fn=6,h=push_rod_slide/5,center=true);
	}
}

module dampener() {
	difference() {
		union() {
			translate([0,0,wall_thickness]) hull() {
				rotate_extrude() {
					translate([stepper_damper_dia/2,0,0]) circle(r=wall_thickness,center=true);
				}
			}
			translate([0,0,wall_thickness*6-wall_thickness]) hull() {
				rotate_extrude() {
					translate([stepper_damper_dia/2,0,0]) circle(r=wall_thickness,center=true);
				}
			}
			translate([0,0,wall_thickness*3]) cylinder(r=stepper_damper_dia/2,h=wall_thickness*6,center=true);
		}
		translate([0,0,wall_thickness*3]) cylinder(r=stepper_bolt_dia/2+clearance/2,h=wall_thickness*6+extra,center=true);
	}
}

module extruder_bottom() {
	extruder_top(1);
}

module extruder_top(bottom) {
	difference() {
		union() {
			translate([0,0,wall_thickness*1.5/2]) hull() {
				for(i=[60,-60,180]) rotate([0,0,i]) translate([0,(stepper_size+stepper_oversize)/sqrt(3)+wall_thickness,0]) cylinder(r=support_rod_dia/2+wall_thickness,h=wall_thickness*1.5,center=true);
			}
			if (bottom != 1 ) {
				translate([4.5,(stepper_size/2+stepper_oversize/2)/sqrt(3)+5,wall_thickness*1.5]) cylinder(r=support_rod_dia/1.5,h=wall_thickness*3,center=true);
				translate([-13.3,(stepper_size/2+stepper_oversize/2)/sqrt(3)+5,wall_thickness]) hull() {
					cylinder(r=6.8,h=wall_thickness*2+extra,center=true);
					translate([-1,0,0]) cylinder(r=6.8,h=wall_thickness*2+extra,center=true);
				}
			} else {
				translate([-4.5,(stepper_size/2+stepper_oversize/2)/sqrt(3)+5,wall_thickness*2]) {
					cylinder(r=6.4,h=wall_thickness*4,center=true);
					hull() {
						translate([24,0,-wall_thickness]) cylinder(r=wall_thickness/1.5,h=wall_thickness,center=true);
						translate([4,0,0]) cylinder(r=wall_thickness/1.5,h=wall_thickness*4,center=true);
					}
					hull() {
						translate([-15,0,-wall_thickness]) cylinder(r=wall_thickness/1.5,h=wall_thickness,center=true);
						translate([-4,0,0]) cylinder(r=wall_thickness/1.5,h=wall_thickness*4,center=true);
					}
					hull() {
						translate([4.5,-(stepper_size/2+stepper_oversize/2)/sqrt(3)-5,wall_thickness*4]) cylinder(r=wall_thickness/1.5,h=wall_thickness*8,center=true);
						translate([1.5,-6.3,0]) cylinder(r=wall_thickness/1.5,h=wall_thickness*4,center=true);
					}
				}
				
			}
			translate([0,0,push_rod_depth+wall_thickness]) cylinder(r=push_rod_dia/2+wall_thickness+clearance,h=push_rod_depth*2,center=true);
			for(i=[60,-60,180]) rotate([0,0,i]) hull() {
				translate([0,stepper_size/1.44-support_rod_dia/2-wall_thickness/2,wall_thickness]) cylinder(r=wall_thickness/2,h=wall_thickness*2+extra,center=true);
				translate([0,support_rod_dia/2,push_rod_depth+wall_thickness]) cylinder(r=wall_thickness/2,h=push_rod_depth*2,center=true);
			}
		}
		if (bottom != 1 ) {
			translate([4.5,(stepper_size/2+stepper_oversize/2)/sqrt(3)+5,wall_thickness]) cylinder(r=4/2,h=wall_thickness*4+extra,center=true);
			translate([-13.3,(stepper_size/2+stepper_oversize/2)/sqrt(3)+5,wall_thickness]) hull() {
				cylinder(r=5.8/2,h=wall_thickness*2+extra*2,center=true);
				translate([-1,0,0]) cylinder(r=5.8/2,h=wall_thickness*2+extra*2,center=true);
			}
		} else {
			translate([-4.5,(stepper_size/2+stepper_oversize/2)/sqrt(3)+5,wall_thickness*3]) {
				cylinder(r=5.4/2,h=wall_thickness*2.5+extra,center=true);
				cylinder(r=4/2,h=wall_thickness*6+extra,center=true);
				translate([0,0,wall_thickness]) cylinder(r1=5.4/2,r2=7.4/2,h=wall_thickness+extra,center=true);
			}
		}
		translate([0,0,wall_thickness]) for(i=[60,-60,180]) rotate([0,0,i]) translate([0,(stepper_size+stepper_oversize)/sqrt(3)+wall_thickness,0]) cylinder(r=pulley_bolt_dia/2+clearance/2,h=wall_thickness*2+extra,center=true);
		translate([0,0,push_rod_depth+wall_thickness*2]) cylinder(r=push_rod_dia/2+clearance/2,h=push_rod_depth*2+extra,center=true);
	}
}

module extruder_mount() {
	difference() {
		union() {
			translate([0,0,wall_thickness/2]) cube([stepper_size+stepper_oversize+wall_thickness*2,stepper_size,wall_thickness],center=true);
			translate([stepper_size/2+stepper_oversize/2+wall_thickness,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2+wall_thickness+clearance,h=stepper_size,center=true);
			translate([-stepper_size/2-stepper_oversize/2-wall_thickness,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2+wall_thickness+clearance,h=stepper_size,center=true);
			translate([-4.5,-(stepper_size/2+stepper_oversize/2)/sqrt(3)-wall_thickness,0]) hull() {
				translate([0,0,wall_thickness+5.4]) rotate([90,0,0]) cylinder(r=5.4,h=10+extra,center=true);
				translate([0,0,wall_thickness/2]) cube([5.4*2,10,wall_thickness],center=true);
			}
			
		}
		translate([-4.5,-(stepper_size/2+stepper_oversize/2)/sqrt(3)-wall_thickness,wall_thickness+5.4]) rotate([90,0,0]) cylinder(r=4/2,h=10+extra*2,center=true);
		translate([stepper_size/2+stepper_oversize/2+wall_thickness,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2+clearance/2,h=stepper_size+extra,center=true);
		translate([-stepper_size/2-stepper_oversize/2-wall_thickness,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2+clearance/2,h=stepper_size+extra,center=true);
		translate([0,0,-50]) cube([100,100,100],center=true);
		translate([0,0,wall_thickness]) cylinder(r=stepper_flange_dia/2+clearance/2,h=wall_thickness*2+extra,center=true);
		for (i=[-1,1]) for (j=[-1,1]) translate([i*stepper_bolt_spacing/2,j*stepper_bolt_spacing/2,0]) cylinder(r=stepper_bolt_dia/2+clearance/2,h=support_rod_depth,center=true);
	}
}
module extruder_spacer() {
	translate([0,0,stepper_size/2]) difference() {
		cylinder(r=pulley_bolt_dia/2+wall_thickness+clearance,h=stepper_size,center=true);
		cylinder(r=pulley_bolt_dia/2+clearance/2,h=stepper_size+extra,center=true);
	}
}

module extruder_knob() {
	difference() {
		union() {
			for (i=[0,60,120,180,240,300]) rotate([0,0,i]) hull() {
				translate([-(extruder_bolt+wall_thickness),0,push_rod_slide/6]) cylinder(r=wall_thickness/3,h=push_rod_slide/3,center=true);
				translate([0,0,push_rod_slide/6]) cylinder(r=wall_thickness/3,h=push_rod_slide/3,center=true);
			}
			translate([0,0,push_rod_slide/4]) cylinder(r=extruder_bolt/1.4,h=push_rod_slide/2,center=true);
			translate([0,0,push_rod_slide/6]) cylinder(r=extruder_bolt+clearance+wall_thickness/2,h=push_rod_slide/3,center=true);
		
		}
		translate([0,0,push_rod_slide/2]) cylinder(r=extruder_bolt/2+clearance/2,h=push_rod_slide+extra,center=true);
		translate([0,0,push_rod_slide/12-extra]) cylinder(r=extruder_bolt+clearance,$fn=6,h=push_rod_slide/6,center=true);
	}
}


module shaft_coupler() {
	translate([0,0,coupler_length/2]) difference() {
		cylinder(r=coupler_shaft_dia/2+wall_thickness*1.5+clearance/2,h=coupler_length,center=true);
		intersection() {
			cylinder(r=coupler_d_shaft_dia/2+clearance,h=coupler_length+extra,center=true);
			translate([0,coupler_d_shaft_dia/10,-coupler_length/4+extra*3]) rotate([-0,0,0]) cube([coupler_d_shaft_dia+clearance*2,coupler_d_shaft_dia+clearance*2,coupler_length/2+extra*4],center=true);
			translate([0,0,-coupler_length/4+extra*3]) cube([coupler_d_shaft_dia+clearance*1.5,coupler_d_shaft_dia+clearance*1.5,coupler_length/2+extra*4],center=true);
		}
		translate([0,0,-coupler_length/2+wall_thickness/2-extra]) cylinder(r1=coupler_d_shaft_dia/2+wall_thickness/3,r2=coupler_d_shaft_dia/2-wall_thickness/2,h=wall_thickness,center=true);
		translate([0,0,coupler_length/2-wall_thickness/2+extra]) cylinder(r2=coupler_shaft_dia/2+wall_thickness/3,r1=coupler_shaft_dia/2-wall_thickness/2,h=wall_thickness,center=true);
		intersection() {
			translate([0,0,coupler_length/4]) cylinder(r=coupler_shaft_dia/2+clearance,h=coupler_length/2+extra,center=true);
			translate([0,0,coupler_length/4+extra]) cube([coupler_shaft_dia+clearance,coupler_shaft_dia+clearance,coupler_length/2+extra*2],center=true);
		}
	}
}
				
module stepper_mount() {
	translate([-support_rod_dia/4-(stepper_size+stepper_oversize)/2,0,0]) difference() {
		translate([0,0,-.4]) difference() {
			union() {
				translate([support_rod_dia/2+(stepper_size+stepper_oversize)/2+wall_thickness,0,wall_thickness/2]) {
					translate([0,support_rod_depth/2-wall_thickness,(stepper_size+stepper_oversize)/2]) cube([(stepper_size+stepper_oversize)+support_rod_dia,wall_thickness*2,(stepper_size+stepper_oversize)],center=true);
					translate([0,0,wall_thickness/2]) cube([(stepper_size+stepper_oversize)+support_rod_dia,support_rod_depth,wall_thickness*2],center=true);
					translate([spool_bearing_dia+wall_thickness+clearance,(stepper_size+stepper_oversize)/6+wall_thickness,(stepper_size+stepper_oversize)/2.4]) rotate([-19,0,0]) cube([wall_thickness*3,(stepper_size+stepper_oversize)/2,(stepper_size+stepper_oversize)],center=true);
					translate([-spool_bearing_dia-wall_thickness-clearance,(stepper_size+stepper_oversize)/6+wall_thickness,(stepper_size+stepper_oversize)/2.4]) rotate([-19,0,0]) cube([wall_thickness*3,(stepper_size+stepper_oversize)/2,(stepper_size+stepper_oversize)],center=true);
				}
				translate([0,0,support_rod_dia/2+wall_thickness]) rotate([90,90,0]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
			}
			translate([support_rod_dia/2+(stepper_size+stepper_oversize)/2+wall_thickness,support_rod_depth/2-(spool_bearing_thickness-wall_thickness)/2,wall_thickness/2]) {
				translate([0,wall_thickness-wall_thickness/2,(stepper_size+stepper_oversize)/2+wall_thickness]) rotate([90,0,0]) {
					cylinder(r=stepper_flange_dia/2+clearance/2,h=support_rod_depth,center=true);
					for (i=[-stepper_bolt_spacing/2,stepper_bolt_spacing/2]) for (j=[-stepper_bolt_spacing/2,stepper_bolt_spacing/2]) {
						translate([i,j,0]) cylinder(r=stepper_damper_dia/2+clearance/2,h=support_rod_depth,center=true);
					}
				}
				translate([(stepper_size+stepper_oversize)/3,-3*wall_thickness,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
				translate([0,-wall_thickness*3-spool_bearing_thickness,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
				translate([-(stepper_size+stepper_oversize)/3,-3*wall_thickness,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
			}
			translate([0,0,support_rod_dia/2+wall_thickness]) rotate([90,90,0]) cylinder(r=support_rod_dia/2,h=effector_spacing+wall_thickness+spool_bearing_thickness+support_rod_depth*2+extra,center=true);
			translate([support_rod_dia/2+(stepper_size+stepper_oversize)/2+wall_thickness,support_rod_depth/2+wall_thickness-wall_thickness+(stepper_size+stepper_oversize)-extra,wall_thickness/2+(stepper_size+stepper_oversize)/2]) cube([(stepper_size+stepper_oversize)*2,(stepper_size+stepper_oversize)*2,(stepper_size+stepper_oversize)*2],center=true);
		}
		translate([0,0,-50]) cube([200,200,100],center=true);
	}
}

module spool_bearing() {
	translate([-support_rod_dia/4-(stepper_size+stepper_oversize)/2,0,0]) difference() {
		translate([0,0,-.4]) difference() {
			union() {
				translate([support_rod_dia/2+(stepper_size+stepper_oversize)/2+wall_thickness,0,wall_thickness/2]) {
					translate([0,-support_rod_depth/2+(spool_bearing_thickness+wall_thickness)/2,0]) hull() {
						translate([0,0,(stepper_size+stepper_oversize)/2+wall_thickness]) rotate([90,0,0]) cylinder(r=spool_bearing_dia/2+wall_thickness+clearance,h=spool_bearing_thickness+wall_thickness,center=true);
						translate([0,0,0]) rotate([90,0,0]) cylinder(r=spool_bearing_dia/2+wall_thickness+clearance,h=spool_bearing_thickness+wall_thickness,center=true);
					}
					translate([0,0,0]) cube([(stepper_size+stepper_oversize)+support_rod_dia,support_rod_depth,wall_thickness],center=true);
					translate([spool_bearing_dia/2+wall_thickness/2+clearance,(stepper_size+stepper_oversize)/20-wall_thickness,wall_thickness]) rotate([30,0,0]) cube([wall_thickness,(stepper_size+stepper_oversize)/5,(stepper_size+stepper_oversize)/2],center=true);
					translate([-spool_bearing_dia/2-wall_thickness/2-clearance,(stepper_size+stepper_oversize)/20-wall_thickness,wall_thickness]) rotate([30,0,0]) cube([wall_thickness,(stepper_size+stepper_oversize)/5,(stepper_size+stepper_oversize)/2],center=true);
					translate([0,-support_rod_depth/2+wall_thickness/2,(support_rod_dia+wall_thickness)/2]) cube([(stepper_size+stepper_oversize)+support_rod_dia,wall_thickness,support_rod_dia+wall_thickness],center=true);
				}
				translate([0,0,support_rod_dia/2+wall_thickness]) rotate([90,90,0]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
			}
			translate([support_rod_dia/2+(stepper_size+stepper_oversize)/2+wall_thickness,-support_rod_depth/2+(spool_bearing_thickness+wall_thickness)/2,wall_thickness/2]) {
				translate([0,0,(stepper_size+stepper_oversize)/2+wall_thickness]) rotate([90,0,0]) cylinder(r=spool_bearing_dia/2-clearance/2-wall_thickness,h=spool_bearing_thickness+wall_thickness+extra,center=true);
				translate([0,wall_thickness-wall_thickness/2,(stepper_size+stepper_oversize)/2+wall_thickness]) rotate([90,0,0]) cylinder(r=spool_bearing_dia/2+clearance/2,h=spool_bearing_thickness+extra,center=true);
				translate([(stepper_size+stepper_oversize)/3,wall_thickness,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
				translate([0,wall_thickness*2+spool_bearing_thickness,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
				translate([-(stepper_size+stepper_oversize)/3,wall_thickness,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
			}
			translate([0,0,support_rod_dia/2+wall_thickness]) rotate([90,90,0]) cylinder(r=support_rod_dia/2,h=effector_spacing+wall_thickness+spool_bearing_thickness+support_rod_depth*2+extra,center=true);
		}
		translate([(stepper_size+stepper_oversize)+15,0,15]) rotate([0,-45,0]) cube([26,30,30],center=true);
		translate([0,0,-50]) cube([200,200,100],center=true);
	}
}

module bottom_corner() {
	top_corner(1);
}

module top_corner(bottom) {
	difference() {
		translate([0,0,-.4]) difference() { // flat bottoms print better
			translate([0,0,support_rod_dia/2+wall_thickness]) union() {
				difference() {
					translate([0,0,-support_rod_dia/2-wall_thickness/2+.4]) rotate([0,0,30]) cylinder(r=support_rod_depth*1.47,$fn=6, h=wall_thickness*2+extra,center=true);
					translate([-50-pulley_inner_dia/6,0,0]) cube([100,100,100],center=true);
				}
				rotate([0,-90+roswell_constant,0]) difference() {
					rotate([0,0,30]) cylinder(r=support_rod_depth*1.47,h=wall_thickness,$fn=6,center=true);
					translate([-50,0,0]) cube([90,100,100],center=true);
				}
				rotate([60,-roswell_constant,60]) translate([0,0,support_rod_depth]) rotate([0,90,0]) cylinder(r=support_rod_depth/1.47,$fn=3,h=wall_thickness,center=true);
				rotate([60,roswell_constant,120]) translate([0,0,support_rod_depth]) rotate([0,90,0]) cylinder(r=support_rod_depth/1.47,$fn=3,h=wall_thickness,center=true);
				for (i=[-30,30]) {
					rotate([i,roswell_constant,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
					rotate([i,90,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
				}
				sphere(r=support_rod_depth/2+wall_thickness,center=true);
				if (bottom != 1) {
					translate([pulley_offset,0,-support_rod_dia/2-wall_thickness+pulley_inner_dia/2.5]) rotate([90,0,0]) {
						cylinder(r=pulley_inner_dia/2.2,h=effector_spacing-pulley_thickness,center=true);
						hull() {
							translate([0,0,0]) cylinder(r=pulley_inner_dia/2.2,h=limit_switch_thickness+clearance+wall_thickness*2,center=true);
							translate([0,-7,0]) rotate([0,0,-roswell_constant]) {
								translate([-21.75-wall_thickness,14,0]) cylinder(r=pulley_inner_dia/2.2+wall_thickness/2,h=limit_switch_thickness+clearance+wall_thickness*2,center=true);
								translate([-21.75-wall_thickness,-1,0]) cylinder(r=pulley_inner_dia/2.2+wall_thickness/2,h=limit_switch_thickness+clearance+wall_thickness*2,center=true);
							}
							translate([0,9.0,0]) cylinder(r=pulley_inner_dia/2.2,h=limit_switch_thickness+clearance+wall_thickness*2,center=true);
						}
					}
				} else {
					translate([0,0,-support_rod_dia/2]) rotate([90,0,0]) cylinder(r=wall_thickness*1.3,h=effector_spacing-pulley_thickness,center=true);
				}
			}
			if (bottom != 1) translate([-21.75,0,13.5]) rotate([0,90+roswell_constant,0]) {
				limit_switch_cutout();
			}
			translate([0,0,support_rod_dia/2+wall_thickness]) union() {
				for (i=[-30,30] ) {
					rotate([i,roswell_constant,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+clearance/2,h=support_rod_depth+extra,center=true);
					rotate([i,90,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+clearance/2,h=support_rod_depth+extra,center=true);
				}
			}
			//translate([(-support_rod_dia-wall_thickness)/2-support_rod_dia/2-wall_thickness,0,0]) cube([support_rod_dia+wall_thickness,100,100],center=true);
			if (bottom != 1) {
				translate([pulley_offset,0,pulley_inner_dia/2.5]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2+clearance/2,h=effector_spacing+pulley_thickness+extra*2,center=true);
				hull() {
					translate([pulley_offset,0,0]) rotate([90,0,0]) cylinder(r=(pulley_outer_dia+clearance)/2,h=pulley_thickness+clearance,center=true);
					translate([pulley_offset,0,pulley_inner_dia/2.5]) rotate([90,0,0]) cylinder(r=(pulley_outer_dia+clearance)/2,h=pulley_thickness+clearance,center=true);
				}
				translate([pulley_offset-pulley_inner_dia/2,0,pulley_inner_dia/4]) rotate([0,135,0]) translate([0,0,support_rod_depth/2]) cylinder(r1=pulley_thickness/2,r2=pulley_thickness*3,h=support_rod_depth*.95,center=true);
				rotate([0,14.5,0]) translate([pulley_offset-(pulley_inner_dia+pulley_outer_dia)/4+clearance,0,pulley_inner_dia/2.5+support_rod_depth]) scale([.80,1.0,1]) cylinder(r1=pulley_thickness/2,r2=pulley_thickness*1.8,h=support_rod_depth*2,center=true);
			}
		}
		for (i=[-60,0,60]) rotate([0,0,i]) translate([support_rod_depth,0,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
		translate([0,0,(-support_rod_dia-wall_thickness)/2]) cube([100,100,support_rod_dia+wall_thickness],center=true);
	}
}
		

