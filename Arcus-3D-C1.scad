// Arcus-3D-C1 - Cable printer OpenSCAD source
// https://hackaday.io/project/26938
//
// darenschwenke@gmail.com

$fn=120; // circle complexity.  Turn down while editing, up while rendering.
//$fn=60;
roswell_constant=19.47; // there is a geometric reason this angle works, but I'm too lazy to find it.

effector_offset=2.0; // holes for cable axis, offset from colinear.
effector_spacing=63.5; // distance between lines on end effector.
effector_hinge_thickness=3.0;
effector_ring_dia=effector_spacing/1.75;
effector_ring_height=effector_spacing/5;
effector_bearing_dia=1.8; // pin for U joint, aka, some printer filament.
effector_fitting_dia=8; // fits the flange on a push fitting
effector_fitting_flange_height=2; // fits the flange on a push fitting

cable_hole_dia=1.0; // holes for lines

// corners supports
wall_thickness=2.0; // supports are 1x this, motor flanges are 2x, a few are 3x.
support_rod_dia=8.2;
support_rod_depth=20;
pulley_thickness=4.5; // 4mm really, but cleanup here is a pita.
pulley_outer_dia=14.5; // 13mm really, but bridge can droop..
pulley_inner_dia=11; // center for spooling
pulley_bolt_dia=4;
pulley_offset=0; // move pulley location in or out a bit from center.  Wasn't needed.
pulley_skew=1.2; // this is a wierd one.  Since the upper pulley doesn't rotate to face the effector, this tries to compensate by skewing the size of the inverted pulley on the effector.

push_rod_dia=7.75;
push_rod_depth=20;
push_rod_slide=25;

// rollerblade bearing, 8mm id
spool_bearing_thickness=7;
spool_bearing_dia=22;

// steppers
stepper_size=43; 
stepper_oversize=7; // flange is embiggend this much for clearance.
stepper_flange_dia=22.5;
stepper_bolt_spacing=31;
stepper_bolt_dia=3;
stepper_damper_dia=7; // for no vibration isolators, set to 3.1;

// shaft coupler from stepper to AL rod.
coupler_length=25;  
coupler_d_shaft_dia=5; // stepper shaft dia.
coupler_shaft_dia=7.79; // 5/16 in AL rod in mm.

clearance=.20; // all holes are this much larger than setting.  I over-extrude a bit for strength on structural parts.
extra=.02; // for differencing

// Uncomment each part here, render, then export.

//top_corner();
//bottom_corner();
//stepper_mount();
//spool_bearing();
//shaft_coupler();
//extruder_mount();
//extruder_top();
//dampener();
end_effector_body();
//end_effector_joint();
//push_rod_joint();
//push_rod_top();
// Drilling template for the AL spool rod
//spool_rod_template();
// Assembled end effector
//end_effector_assembly();


module end_effector_assembly() {
	end_effector_body();
	translate([0,0,effector_ring_height+effector_bearing_dia/2-effector_bearing_dia*2]) end_effector_joint();
	translate([0,0,push_rod_depth*2+effector_ring_height+effector_bearing_dia/2]) rotate([180,0,0]) push_rod_joint();
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
					rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,0]) rotate([0,0,j]) translate([effector_offset,0,0]) cylinder(r=pulley_inner_dia/2,h=wall_thickness,center=true);
				}
				// corners
				translate([0,0,wall_thickness]) for (i=[-120,0,120]) for (j=[-60,60]) {
					rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,0]) rotate([0,0,j]) translate([effector_offset,0,0]) intersection() {	
						inverted_pulley();
						rotate([0,0,j/2]) translate([effector_offset*2,0,0]) cube([pulley_inner_dia,pulley_inner_dia,pulley_inner_dia],center=true);
					}	
				}
				// ribs
				for (i=[-120,0,120]) hull() {
					rotate([0,0,i]) translate([effector_ring_dia/2+wall_thickness/2,0,effector_ring_height/2-effector_bearing_dia/2]) cylinder(r=wall_thickness/2,h=effector_ring_height-effector_bearing_dia,center=true);
					rotate([0,0,i]) translate([effector_spacing/sqrt(3)+pulley_inner_dia/2,0,pulley_inner_dia/4+wall_thickness/2]) cylinder(r=wall_thickness/2,h=pulley_inner_dia/2+wall_thickness,center=true);
				}
				// ring
				translate([0,0,effector_ring_height/2]) cylinder(r=effector_ring_dia/2+wall_thickness,h=effector_ring_height,center=true);
			}
			// base center hole
			translate([0,0,effector_ring_height/2+effector_fitting_flange_height/2]) cylinder(r=effector_ring_dia/2,h=effector_ring_height-effector_fitting_flange_height+extra,center=true);
			// cable holes
			for (i=[-120,0,120]) for (j=[-60,60]) {
				rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,wall_thickness/2]) rotate([0,0,j]) translate([effector_offset,0,wall_thickness/2]) cylinder(r=cable_hole_dia/2,h=wall_thickness*2+extra,center=true);
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
	intersection() {
		translate([0,0,pulley_inner_dia/2]) cylinder(r=pulley_inner_dia/2,h=pulley_inner_dia,center=true);
		scale([1,pulley_skew,1]) rotate_extrude(convexity = 10) translate([pulley_inner_dia/2+cable_hole_dia/2,0,0]) circle(r=pulley_inner_dia/2);
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
				translate([0,0,push_rod_depth*2]) rotate([90,0,0]) cylinder(r=effector_ring_height/3,h=jwidth,center=true);
				translate([0,0,push_rod_depth*2-wall_thickness*3]) rotate([90,0,0]) cylinder(r=effector_ring_height/3,h=jwidth,center=true);
				translate([0,0,push_rod_depth-wall_thickness*4]) cylinder(r=effector_ring_height/3,h=clearance,center=true);
			}
			translate([0,0,push_rod_depth/2+wall_thickness]) cylinder(r1=push_rod_dia/2+wall_thickness,r2=effector_bearing_dia/2+wall_thickness*1.50,h=push_rod_depth+wall_thickness*2,center=true);
		}
		hull() {
			translate([0,0,push_rod_depth*2]) cube([push_rod_dia+wall_thickness*2,jwidth-effector_hinge_thickness*2,push_rod_dia+wall_thickness*2],center=true);
			translate([0,0,push_rod_depth+wall_thickness*2]) cube([push_rod_dia+wall_thickness*3,push_rod_dia,clearance],center=true);
		}
		translate([0,0,push_rod_depth/2]) cylinder(r=push_rod_dia/2+clearance,h=push_rod_depth+extra,center=true);
		translate([0,0,push_rod_depth*2]) rotate([90,0,0]) cylinder(r=effector_bearing_dia/2,h=effector_ring_dia-wall_thickness/1.5-wall_thickness*2-wall_thickness/1.2-clearance*2+extra,center=true);
		translate([0,0,push_rod_depth]) cylinder(r=push_rod_dia/2-wall_thickness/2,h=push_rod_depth*2,center=true);	
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

module extruder_top() {
	difference() {
		union() {
			translate([0,0,support_rod_dia/2+wall_thickness]) union() {
				rotate([0,0,60]) translate([0,stepper_size/1.44,0]) cylinder(r=support_rod_dia/2+clearance/2,h=stepper_size,center=true);
				rotate([0,0,-60]) translate([0,stepper_size/1.44,0]) cylinder(r=support_rod_dia/2+clearance/2,h=stepper_size,center=true);
				rotate([0,0,180]) translate([0,stepper_size/1.44,0]) cylinder(r=support_rod_dia/2+clearance/2,h=stepper_size,center=true);
				//rotate([0,0,210]) translate([0,stepper_size/1.44,0]) cylinder(r=support_rod_dia/2+clearance/2,h=stepper_size,center=true);
			}
			rotate([0,0,30]) translate([0,0,-wall_thickness/2]) cylinder(r=stepper_size/2*sqrt(3),$fn=3,h=wall_thickness,center=true);
		}
	}
}

module extruder_mount() {
	difference() {
		union() {
			translate([0,0,wall_thickness/2]) cube([stepper_size+stepper_oversize,stepper_size,wall_thickness],center=true);
			translate([-stepper_size/2-stepper_oversize/2,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia,h=stepper_size,center=true);
			translate([stepper_size/2+stepper_oversize/2,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia,h=stepper_size,center=true);
		}
		translate([stepper_size/2+stepper_oversize/2,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2,h=stepper_size+extra,center=true);
		translate([-stepper_size/2-stepper_oversize/2,0,pulley_bolt_dia/1.2]) rotate([90,0,0]) cylinder(r=pulley_bolt_dia/2,h=stepper_size+extra,center=true);
		translate([0,0,-50]) cube([100,100,100],center=true);
		translate([0,0,wall_thickness]) cylinder(r=stepper_flange_dia/2+clearance/2,h=wall_thickness*2+extra,center=true);
		for (i=[-1,1]) for (j=[-1,1]) translate([i*stepper_bolt_spacing/2,j*stepper_bolt_spacing/2,0]) cylinder(r=stepper_bolt_dia/2+clearance/2,h=support_rod_depth,center=true);
	}
}

module shaft_coupler() {
	translate([0,0,coupler_length/2]) difference() {
		cylinder(r=coupler_shaft_dia/2+wall_thickness*1.5+clearance/2,h=coupler_length,center=true);
		intersection() {
			cylinder(r=coupler_d_shaft_dia/2+clearance,h=coupler_length+extra,center=true);
			translate([0,coupler_d_shaft_dia*1/10-clearance,0]) cube([coupler_d_shaft_dia+clearance,coupler_d_shaft_dia*9/10+clearance,coupler_length+extra],center=true);
		}
		translate([0,0,coupler_length/4]) cylinder(r=coupler_shaft_dia/2+clearance,h=coupler_length/2+extra,center=true);
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
				translate([-stepper_bolt_spacing/2,stepper_bolt_spacing/2,0]) cylinder(r=stepper_damper_dia/2+clearance/2,h=support_rod_depth,center=true);
				translate([stepper_bolt_spacing/2,stepper_bolt_spacing/2,0]) cylinder(r=stepper_damper_dia/2+clearance/2,h=support_rod_depth,center=true);
				translate([-stepper_bolt_spacing/2,-stepper_bolt_spacing/2,0]) cylinder(r=stepper_damper_dia/2+clearance/2,h=support_rod_depth,center=true);
				translate([stepper_bolt_spacing/2,-stepper_bolt_spacing/2,0]) cylinder(r=stepper_damper_dia/2+clearance/2,h=support_rod_depth,center=true);
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
				//%rotate([60,15,0]) translate([0,0,support_rod_depth*1.44]) rotate([0,90,0]) cylinder(r=support_rod_depth,$fn=3,h=wall_thickness,center=true);
				rotate([60,-roswell_constant,60]) translate([0,0,support_rod_depth]) rotate([0,90,0]) cylinder(r=support_rod_depth/1.47,$fn=3,h=wall_thickness,center=true);
				//rotate([60,-roswell_constant,60]) translate([0,0,support_rod_depth]) rotate([0,90,0]) cylinder(r=support_rod_depth/1.5,$fn=3,h=wall_thickness,center=true);
				rotate([60,roswell_constant,120]) translate([0,0,support_rod_depth]) rotate([0,90,0]) cylinder(r=support_rod_depth/1.47,$fn=3,h=wall_thickness,center=true);
				rotate([30,roswell_constant,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
				rotate([-30,roswell_constant,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
				rotate([30,90,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
				rotate([-30,90,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+wall_thickness,h=support_rod_depth,center=true);
				sphere(r=support_rod_depth/2+wall_thickness,center=true);
				if (bottom != 1) {
					translate([pulley_offset,0,-support_rod_dia/2-wall_thickness+pulley_inner_dia/2.5]) rotate([90,0,0]) cylinder(r=pulley_inner_dia/2.2,h=effector_spacing-pulley_thickness,center=true);
				} else {
					translate([0,0,-support_rod_dia/2]) rotate([90,0,0]) cylinder(r=wall_thickness*1.3,h=effector_spacing-pulley_thickness,center=true);
				}
			}
			translate([0,0,support_rod_dia/2+wall_thickness]) union() {
				rotate([30,roswell_constant,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+clearance/2,h=support_rod_depth+extra,center=true);
				rotate([-30,roswell_constant,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+clearance/2,h=support_rod_depth+extra,center=true);
				rotate([30,90,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+clearance/2,h=support_rod_depth+extra,center=true);
				rotate([-30,90,0]) translate([0,0,support_rod_depth]) cylinder(r=support_rod_dia/2+clearance/2,h=support_rod_depth+extra,center=true);
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
		if (bottom == 1) {
			rotate([0,0,0]) translate([support_rod_depth,0,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
			rotate([0,0,60]) translate([support_rod_depth,0,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
			rotate([0,0,-60]) translate([support_rod_depth,0,0]) cylinder(r=pulley_bolt_dia/2,h=20,center=true);
		}
		translate([0,0,(-support_rod_dia-wall_thickness)/2]) cube([100,100,support_rod_dia+wall_thickness],center=true);
	}
}
		

