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
extruder_mount();
//extruder_top();
//extruder_bottom();
//extruder_spacer();
//extruder_knob();
//extruder_spring_washer();
//dampener();
//end_effector_body();
//end_effector_joint();
//end_effector_blower_nozzle();
//push_rod_joint();
//push_rod_top();
//push_rod_stop();
//push_rod_clamp();
//push_rod_knob();
// Drilling template for the AL spool rod
//spool_rod_template();

// Assembled top corner for visualization
//top_corner_assembly();

// Assembled end effector for visualization
//end_effector_assembly();

// Assembled clamp for visualization
//push_rod_clamp_assembly();

// Extrusion compensation
// All the holes are this much larger than the actual setting.
// I tend to over-extrude a bit for strength on structural parts and this compensates.
// Print the shaft coupler first and if it fits the stepper shaft loosely, decrease this number. 
clearance=.20;

// First layer of end effector is flat and solid for better FFF printing.  
// If you want the holes all the way through, set to -.02 
first_layer_height=.26;
// Nozzle size for parts only a few layers thick.  Prints better.
nozzle_dia=.4;

// Unless you need to change something about the design, nothing below here needs editing.

// Rendering
$fn=90; // circle complexity.  Turn down while editing, up while rendering.
//$fn=30;
// The virtual pulleys bring the interface to a crawl.
render_pulley=1;

// General
roswell_constant=19.47; // Angle from vertical which makes an octahedron. 
// There is a geometric reason this angle works, but I'm too lazy to find it.
wall_thickness=2.0; // Everything is a multiple of this general wall thickness.

// End effector
effector_offset=wall_thickness; // Offset from colinear of neighboring axis cable holes.
effector_spacing=63.5; // Distance between parallel lines on the end effector.
effector_hinge_thickness=wall_thickness*1.80; // Hinge thickness at contact point.
effector_bearing_dia=1.78; // Pin for U joint, aka, some printer filament.
effector_hinge_dia=effector_bearing_dia+wall_thickness*3;
effector_ring_dia=effector_spacing/1.45; // Support ring dia.
effector_ring_height=effector_spacing/5.0; //Support ring height.
effector_hotend_flange_dia=16; // Fits the flange on the hotend.
effector_hotend_flange_height=2.95; // Fits the flange on the hotend.
effector_wire_hole_dia=8; // Holes fore wires.
effector_level_bolt_dia=2.65; // Bolt dia for leveling bolts. 3mm bolt threaded in.
effector_blower_bolt_dia=4.2; // Bolt dia for blower bolt. 
effector_blower_height=19.7; // Blower output height.
effector_blower_width=15.25; // Blower output width.
effector_blower_nozzle_height=45; // Nozzle from back of fan to tip.
effector_blower_mount_dia=7; // Screw mount dia on blower.
effector_blower_arc_dia=effector_blower_height*7.5; // Adjust curve of the nozzle.

cable_hole_dia=1.0; // Holes for lines.

// Corners supports
support_rod_dia=8.25; // Driveway marker diameter.
support_rod_depth=20; // Depth of the pockets for support rods.
pulley_thickness=4.5; // 4mm really, but cleanup here is a pita.
pulley_outer_dia=14.5; // 13mm really, but bridge can droop.
pulley_inner_dia=11; // Center dia for spooling.
pulley_bolt_dia=4; // Pulley bolt dia.
pulley_offset=0; // Move pulley location in or out a bit from center of machine.  Wasn't needed.
pulley_skew=1.2; // This tries to compensate for horizontal offset from the pulley by skewing the size of the virtual pulley on the effector.

// Push rod
push_rod_dia=7.75; // Garden stake was this dia.
push_rod_stop_bolt_dia=3.1;
push_rod_depth=20; // Depth of pocket for push-rod.
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
extruder_bolt_dia=4.75; // Extruder tension bolt size
extruder_drive_offset=4.5; //Offset from center line of extruder drive gear to center of filament
extruder_drive_depth=5.6; // Offset from stepper flange to center of filament.
bowden_tube_dia=4; //Outer dia of bowden tube.
extruder_knob_height=7; // Height of ribbed portion of knob.

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

module end_effector_assembly() {
	end_effector_body();
	translate([0,0,effector_ring_height+effector_bearing_dia/2]) rotate([28,0,0]) {
		translate([0,0,-effector_bearing_dia*2]) end_effector_joint();
		rotate([0,28,0]) translate([-effector_ring_height/4,0,push_rod_depth*3]) rotate([180,0,0]) push_rod_joint();
	}
	//rotate([180,0,0]) translate([-effector_spacing/sqrt(3)-wall_thickness/4,0,-wall_thickness*1.5]) rotate([0,20,0]) end_effector_blower_nozzle();
	%translate([0,0,16.5/2]) cylinder(r=16/2,h=16.5,center=true); // groove mount visualization
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
				// blower_mount
				translate([-effector_ring_dia/2-wall_thickness*.75-effector_hinge_thickness/2-effector_blower_mount_dia/2,0,effector_blower_mount_dia/2+wall_thickness*1.25]) hull() {
					rotate([90,0,0]) cylinder(h=effector_blower_width+wall_thickness*3+clearance,r=effector_blower_bolt_dia/2+wall_thickness*1.5+clearance,center=true);
					translate([-wall_thickness/4,0,-effector_blower_mount_dia/4-wall_thickness*1.25/2]) cube([effector_blower_mount_dia+wall_thickness/2,effector_blower_width+wall_thickness*3+clearance,effector_blower_mount_dia/2+wall_thickness*1.25],center=true);
					translate([effector_blower_mount_dia/2,0,wall_thickness/4]) cube([effector_blower_mount_dia,effector_blower_width+wall_thickness*3+clearance,effector_blower_mount_dia+wall_thickness/2],center=true);
				}
				// corners/virtual pulleys
				difference() {
					union() {
						// base
						translate([0,0,wall_thickness/2*1.25]) hull() for (i=[-120,0,120]) for (j=[-60,60]) {
							rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,0]) rotate([0,0,j]) translate([effector_offset,0,0]) cylinder(r=pulley_inner_dia/2,h=wall_thickness*1.25,center=true);
						}
						// corners
						for (i=[-120,0,120]) hull() for (j=[-60,60]) {
							rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,pulley_inner_dia/4+wall_thickness/4-extra]) rotate([0,0,j]) translate([effector_offset,0,0]) scale([1,pulley_skew,1]) cylinder(r=pulley_inner_dia/2+wall_thickness/2,h=pulley_inner_dia/2+wall_thickness/2-extra*2,center=true);
						}
					}
					// virtual pulleys
					for (i=[-120,0,120]) for (j=[-60,60]) {
						if (render_pulley) rotate([0,0,i]) translate([effector_spacing/sqrt(3),0,wall_thickness/2]) rotate([0,0,j]) translate([effector_offset,0,0]) inverted_pulley();
					}
				}
				// ribs
				for (i=[-120,0,120]) for(j=[-pulley_inner_dia/2.5-effector_offset,pulley_inner_dia/2.5+effector_offset]) hull() {
					rotate([0,0,i]) translate([effector_ring_dia/2,j,effector_ring_height/2-wall_thickness/4]) cylinder(r=wall_thickness/1.4,h=effector_ring_height-wall_thickness/2,center=true);
					rotate([0,0,i]) translate([effector_spacing/sqrt(3)-wall_thickness,j,pulley_inner_dia/4]) cylinder(r=wall_thickness/1.4,h=pulley_inner_dia/2,center=true);
				}
				// ring
				translate([0,0,effector_ring_height/2]) cylinder(r=effector_ring_dia/2+wall_thickness*1.5,h=effector_ring_height,center=true);
			}
			// blower mount
			translate([-effector_ring_dia/2-wall_thickness*.75-effector_hinge_thickness/2-effector_blower_mount_dia/2,0,effector_blower_mount_dia/2+wall_thickness*1.25]) {
				rotate([90,0,0]) cylinder(h=effector_blower_width+wall_thickness*3+clearance*2+extra,r=effector_blower_bolt_dia/2,center=true);
				hull() {
					rotate([90,0,0]) cylinder(h=effector_blower_width+clearance,r=effector_blower_mount_dia/2+extra,center=true);
					translate([-effector_blower_mount_dia/2-extra,0,]) cube([effector_blower_mount_dia+extra,effector_blower_width+clearance,effector_blower_mount_dia],center=true);
					translate([-wall_thickness,0,effector_blower_mount_dia/2]) cube([effector_blower_mount_dia+wall_thickness*2,effector_blower_width+clearance,effector_blower_mount_dia],center=true);
				}
			}
			// leveling bolts
			for (i=[-120,0,120]) rotate([0,0,i+180]) translate([effector_ring_dia/2-effector_level_bolt_dia/2-clearance,0,wall_thickness*3+first_layer_height]) cylinder(r=effector_level_bolt_dia/2,h=wall_thickness*6,center=true);
			// base center hole
			translate([0,0,effector_ring_height/2+effector_hotend_flange_height]) cylinder(r=effector_ring_dia/2,h=effector_ring_height+extra,center=true);
			// wire holes
			for (i=[0,180]) rotate([0,-10,i]) hull() for (j=[15,-15]) {
				rotate([0,0,j]) translate([effector_ring_dia/2.4-effector_wire_hole_dia/2,0,0]) cylinder(r=effector_wire_hole_dia/2.5,h=effector_ring_height,center=true);
			}
			// ring
			cylinder(r=effector_hotend_flange_dia/2+clearance,h=effector_ring_height,center=true);
			// clearance check
			// for (i=[-30,30]) translate([0,0,effector_ring_height+effector_bearing_dia/2-effector_bearing_dia*2]) rotate([i,0,0]) end_effector_joint();
			// effector_joint cutouts
			translate([0,0,effector_ring_height+effector_bearing_dia/2]) for (i=[-28,28]) rotate([i,0,0]) cylinder(r=effector_ring_dia/2-effector_hinge_thickness/4+clearance*2,h=effector_hinge_dia,center=true);
		}
		// hinges
		difference() {
			for (i=[0,180]) hull() {
				rotate([0,0,i]) translate([effector_ring_dia/2+effector_hinge_thickness/2-wall_thickness/2,0,effector_ring_height+effector_bearing_dia/2]) scale([1,1,.70]) rotate([0,90,0]) cylinder(r=effector_hinge_dia/2/.60,h=effector_hinge_thickness+clearance,center=true);
				rotate([0,0,i]) translate([effector_ring_dia/2+effector_hinge_thickness/2-wall_thickness/2,0,wall_thickness/2]) cube([effector_hinge_thickness+clearance,effector_ring_height,wall_thickness],center=true);
			}
			translate([-effector_ring_dia/2+effector_level_bolt_dia/2-clearance,0,wall_thickness*2+first_layer_height]) cylinder(r=effector_level_bolt_dia/2,h=wall_thickness*4+extra,center=true);
			translate([0,0,effector_ring_height+effector_bearing_dia/2]) rotate([0,90,0]) cylinder(r=effector_bearing_dia/2,h=effector_ring_dia*2,center=true);
		}
	}
	
}

module end_effector_blower_nozzle() {
	difference() {
		union() {
			intersection() {
				difference() {
					union() {
						minkowski() { // expand blower arc nozzle_dia*3 in XY
							end_effector_blower_nozzle_arc(effector_blower_arc_dia);
							cube([nozzle_dia*6,nozzle_dia*6,.000001],center=true);
						}
						translate([effector_blower_arc_dia/2+effector_blower_height-nozzle_dia*1.4,0,-effector_blower_height/4.5]) rotate([0,25,0]) translate([-effector_blower_arc_dia/2-effector_blower_height/2+wall_thickness,0,0]) difference() {
							translate([0,0,-effector_blower_height/4]) cube([nozzle_dia*8,effector_blower_width+nozzle_dia*4,effector_blower_height*2],center=true);
							cube([nozzle_dia*2.5,effector_blower_width-nozzle_dia*2,effector_blower_height*2+nozzle_dia*4],center=true);
						}
					}
					end_effector_blower_nozzle_arc(effector_blower_arc_dia); // subtract arc
					translate([effector_blower_height/6,0,effector_blower_height/1.75]) rotate([90,0,0]) cylinder(r=effector_bearing_dia/2,h=effector_blower_width*2,center=true); // TPU hole
				}
				translate([0,0,effector_blower_height]) cube([effector_blower_arc_dia*2,effector_blower_width*2,effector_blower_height*2],center=true); // constrain height
				translate([-effector_blower_height/2-nozzle_dia*4,0,0]) rotate([0,45,0]) translate([0,0,effector_blower_nozzle_height/2]) cube([effector_blower_arc_dia*2,effector_blower_width*2,effector_blower_nozzle_height],center=true); // constrain height
			}
		}
		translate([0,0,wall_thickness/2]) cube([effector_blower_height+clearance,effector_blower_width+clearance,wall_thickness+extra*8],center=true); // blower output cutout
	}
}

module end_effector_blower_nozzle_arc() {
	difference() {
		translate([effector_blower_arc_dia/2-effector_blower_height-nozzle_dia/2,0,-effector_blower_height/1.5]) rotate([90,0,0]) cylinder(r=effector_blower_arc_dia/2+nozzle_dia*3.5-effector_blower_height/2,h=effector_blower_width-nozzle_dia*2,center=true);
		translate([effector_blower_arc_dia/2+effector_blower_height-nozzle_dia/2,0,-effector_blower_height/8]) rotate([90,0,0]) cylinder(r=effector_blower_arc_dia/2+effector_blower_height/2-nozzle_dia/2,h=effector_blower_width-nozzle_dia*2+extra,center=true);
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
		cylinder(r=cable_hole_dia/2,h=wall_thickness-first_layer_height*2,center=true);
	}
}

module end_effector_joint() {
	difference() {
		union() {
			difference() {
				translate([0,0,effector_hinge_dia/2]) intersection() {
					sphere(r=effector_ring_dia/2-effector_hinge_thickness/3-clearance,center=true);
					cylinder(r=effector_ring_dia/2-effector_hinge_thickness/3-clearance,h=effector_hinge_dia,center=true);
				}
				translate([0,0,effector_ring_height/2]) cylinder(r=effector_ring_dia/2-effector_hinge_thickness*1.3,h=effector_ring_height+extra,center=true);
			}
			translate([0,0,effector_hinge_dia/2]) intersection() {
				cylinder(r=effector_ring_dia/2,h=effector_hinge_dia,center=true);
				union() {
					for (i=[0,180]) rotate([0,0,i]) translate([effector_ring_dia/2-effector_hinge_thickness/4-wall_thickness/2-clearance,0,0]) rotate([0,90,0]) cylinder(r1=effector_hinge_dia/1.5,r2=effector_hinge_dia/2,h=effector_hinge_thickness/2-clearance,center=true);
					for (i=[90,270]) rotate([0,0,i]) translate([effector_ring_dia/2-effector_hinge_thickness*1.3-wall_thickness/2+clearance,0,0]) rotate([0,90,0]) cylinder(r2=effector_hinge_dia/1.5,r1=effector_hinge_dia/2,h=effector_hinge_thickness/2-clearance,center=true);
				}
			}
		}
		for (i=[0,90]) rotate([0,0,i]) translate([0,0,effector_hinge_dia/2]) rotate([0,90,0]) cylinder(r=effector_bearing_dia/2,h=effector_ring_dia*2,center=true);
	}
}

module push_rod_joint() {
	jwidth=effector_ring_dia-effector_hinge_thickness*3.1-wall_thickness/2-clearance*3;
	difference() {
		union() {
			hull() {
				translate([effector_ring_height/4,0,push_rod_depth*3]) rotate([90,0,0]) cylinder(r=effector_hinge_dia/1.75,h=jwidth,center=true);
				translate([effector_ring_height/4,0,push_rod_depth*2]) rotate([90,0,0]) cylinder(r=effector_hinge_dia/1.5,h=jwidth,center=true);
			}
			hull() {
				translate([effector_ring_height/4,0,push_rod_depth*2]) rotate([90,0,0]) cylinder(r=effector_hinge_dia/1.5,h=jwidth,center=true);
				translate([0,0,push_rod_depth/1.5-extra]) cylinder(r=push_rod_dia/2+wall_thickness*1.2,h=extra,center=true);
			}
			translate([0,0,push_rod_depth/3]) cylinder(r=push_rod_dia/2+wall_thickness*1.2,h=push_rod_depth/1.5,center=true);
			hull() {
				translate([-effector_ring_height/1.5-wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_ring_height/2.5,h=wall_thickness*2,center=true);
				translate([effector_ring_height/2+wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_hinge_dia/1.8,h=wall_thickness*2,center=true);
			}
		}
		hull() {
			translate([0,0,push_rod_depth*3]) cube([push_rod_dia*5,jwidth-effector_hinge_thickness*1.85,push_rod_dia*5],center=true);
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
		translate([effector_ring_height/2+wall_thickness*1.5,0,wall_thickness]) cylinder(r=effector_hinge_dia/2-wall_thickness/2,h=wall_thickness*2+extra,center=true);
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
			//translate([push_rod_dia/2+push_rod_stop_bolt_dia/2+wall_thickness*1.25,0,push_rod_slide/4]) cylinder([wall_thickness*4,push_rod_dia+wall_thickness*2.5,push_rod_slide/2],center=true);
			translate([push_rod_dia/2+push_rod_stop_bolt_dia/2+wall_thickness/2,0,push_rod_slide/4]) rotate([90,0,0]) rotate([0,0,30]) cylinder(r=push_rod_slide/4,h=push_rod_dia+wall_thickness*2.5,center=true);
		}
		translate([push_rod_dia/2+push_rod_stop_bolt_dia/2+wall_thickness*1.25,0,push_rod_slide/4]) cube([wall_thickness*5+extra,wall_thickness/2,push_rod_slide/2+extra],center=true);
		translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_dia/2+clearance/2,h=push_rod_slide/2+extra,center=true);
		translate([push_rod_dia/2+push_rod_stop_bolt_dia/2+wall_thickness/2,0,push_rod_slide/4]) {
			rotate([0,90,90]) cylinder(r=push_rod_stop_bolt_dia/2,h=push_rod_dia+wall_thickness*4,center=true);
			rotate([90,90,0]) translate([0,0,wall_thickness*3]) cylinder(r=push_rod_stop_bolt_dia+clearance,$fn=6,h=wall_thickness*1.5,center=true);
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
			translate([0,0,push_rod_slide/8]) cylinder(r=push_rod_stop_bolt_dia+clearance+wall_thickness,h=push_rod_slide/4,center=true);
		
		}
		translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_stop_bolt_dia/2+clearance/2,h=push_rod_slide/2+extra,center=true);
		translate([0,0,push_rod_slide/4]) cylinder(r=push_rod_stop_bolt_dia+clearance,$fn=6,h=push_rod_slide/5,center=true);
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

module extruder_mount() {
	difference() {
		union() {
			hull() {
				for (i=[-1,1]) {
					translate([i*(stepper_size+stepper_oversize/2+wall_thickness)/2,wall_thickness/2,(stepper_size+stepper_oversize/2)/2]) cylinder(r=wall_thickness/2,h=stepper_size+stepper_oversize/2,center=true);
				}
				translate([0,-stepper_size/2+wall_thickness*2,(stepper_size+stepper_oversize/2)/2]) rotate([0,90,0]) cylinder(r=wall_thickness*2+effector_bearing_dia,h=stepper_size+stepper_oversize/2+wall_thickness*2,center=true);
			}
			translate([0,-stepper_size/2+wall_thickness*2,(stepper_size+stepper_oversize/2)/2]) rotate([0,90,0]) cylinder(r=wall_thickness*2+effector_bearing_dia,h=stepper_size+stepper_oversize/2+wall_thickness*3,center=true);
			//translate([-extruder_drive_offset,0,-(stepper_size/2+stepper_oversize/2)/sqrt(3)-wall_thickness]) hull() {
			translate([-extruder_drive_offset,0,(stepper_size+stepper_oversize/2)-wall_thickness*5/2]) hull() {
				translate([0,wall_thickness+extruder_drive_depth,wall_thickness*5/2]) cylinder(r=extruder_drive_depth+wall_thickness/2,h=wall_thickness*4,center=true);
				translate([extruder_drive_offset,wall_thickness/2,0]) cube([stepper_flange_dia,wall_thickness,wall_thickness*5],center=true);
			}
			for (i=[-1,1]) {
				translate([i*(stepper_size+stepper_oversize/2+wall_thickness)/2,wall_thickness/3,stepper_size/2]) hull() {
					cylinder(r=wall_thickness/2,h=stepper_size,center=true);
					translate([0,wall_thickness*4-wall_thickness/2,-stepper_size/2+wall_thickness]) cylinder(r=wall_thickness/1.8,h=wall_thickness*2,center=true);
				}
			}
			hull() { 
				for (i=[-1,1]) {
					translate([i*(stepper_size+stepper_oversize/2+wall_thickness)/2,wall_thickness/2,wall_thickness]) cylinder(r=wall_thickness/2,h=wall_thickness*2,center=true);
					translate([i*(stepper_size/2-wall_thickness*2),wall_thickness*2+wall_thickness,wall_thickness]) cylinder(r=wall_thickness*4,h=wall_thickness*2,center=true);
				}
			}
			translate([-extruder_drive_offset,wall_thickness+extruder_drive_depth,wall_thickness*3]) cylinder(r1=wall_thickness*3,r2=wall_thickness*1.5,h=wall_thickness*6,center=true);
			
		}
		translate([0,wall_thickness+wall_thickness*1.5/2,stepper_size/4+wall_thickness*2+extra]) cube([stepper_size,wall_thickness*1.5,stepper_size/2],center=true);
		translate([stepper_bolt_spacing/2-1.5,wall_thickness+extruder_drive_depth,wall_thickness]) hull() {
			cylinder(r=extruder_bolt_dia/2+clearance*2,h=wall_thickness*2.5+extra,center=true);
			translate([3,0,0]) cylinder(r=extruder_bolt_dia/2+clearance*2,h=wall_thickness*2.5+extra,center=true);
		}
			
		translate([-extruder_drive_offset,wall_thickness+extruder_drive_depth,stepper_size+stepper_oversize/2+wall_thickness]) {
			cylinder(r=extruder_drive_depth/2,h=wall_thickness*2.5+extra,center=true);
			translate([0,0,wall_thickness]) cylinder(r1=extruder_drive_depth/2,r2=(extruder_drive_depth+wall_thickness)/2,h=wall_thickness+extra,center=true);
		}
		translate([-extruder_drive_offset,wall_thickness+extruder_drive_depth,(stepper_size+stepper_oversize/2)/2]) cylinder(r=bowden_tube_dia/2+clearance/2,h=stepper_size+stepper_oversize/2+wall_thickness*2,center=true);
		translate([0,-stepper_size/2+wall_thickness*2,(stepper_size+stepper_oversize/2)/2]) rotate([0,90,0]) cylinder(r=effector_bearing_dia/2+clearance,h=stepper_size+stepper_oversize/2+wall_thickness*3+extra,center=true);
		translate([0,-stepper_size/2-wall_thickness*2,(stepper_size+stepper_oversize/2)/2]) cube([stepper_size+stepper_oversize/2,stepper_size+stepper_oversize/2+wall_thickness*2,stepper_size+stepper_oversize/2+extra],center=true);
		translate([-extruder_drive_offset,-(stepper_size/2+stepper_oversize/2)/sqrt(3)-wall_thickness,wall_thickness+extruder_drive_depth]) rotate([90,0,0]) cylinder(r=bowden_tube_dia/2+clearance/2,h=wall_thickness*5+extra*2,center=true);
		translate([0,0,(stepper_size+stepper_oversize/2)/2+wall_thickness]) rotate([90,0,0]) cylinder(r=stepper_flange_dia/2+clearance,h=wall_thickness*2.5+extra,center=true);
		translate([0,0,(stepper_size+stepper_oversize/2)/2+wall_thickness]) for (i=[-1,1]) for (j=[-1,1]) translate([i*stepper_bolt_spacing/2,0,j*stepper_bolt_spacing/2]) rotate([90,0,0]) cylinder(r=stepper_bolt_dia/2+clearance/2,h=support_rod_depth,center=true);
		translate([0,wall_thickness/1.25,(stepper_size+stepper_oversize/2)/2+wall_thickness]) translate([stepper_bolt_spacing/2,0,-stepper_bolt_spacing/2]) rotate([90,0,0]) cylinder(r1=stepper_bolt_dia+clearance/2,r2=stepper_bolt_dia/2+clearance/2,h=wall_thickness/1.4,center=true);
	}
}

module extruder_knob() {
	intersection() {
		difference() {
			union() {
				for (i=[0,60,120,180,240,300]) rotate([0,0,i]) hull() {
					translate([-(extruder_bolt_dia+wall_thickness),0,extruder_knob_height/2]) cylinder(r=wall_thickness,h=extruder_knob_height,center=true);
					translate([0,0,extruder_knob_height/2]) cylinder(r=wall_thickness*2.75,h=extruder_knob_height,center=true);
				}
				translate([0,0,extruder_knob_height/2+wall_thickness/2]) cylinder(r=extruder_bolt_dia/1.25,h=extruder_knob_height,center=true);
				translate([0,0,extruder_knob_height/2]) cylinder(r=extruder_bolt_dia+clearance+wall_thickness/1.25,h=extruder_knob_height,center=true);
			
			}
			translate([0,0,extruder_knob_height/2+extruder_bolt_dia*.85+.11]) cylinder(r=extruder_bolt_dia/2+clearance,h=extruder_knob_height,center=true); // the .11 closes off the hole for 1 layer to make a bridge
			translate([0,0,extruder_bolt_dia*.85/2]) cylinder(r=extruder_bolt_dia+clearance,$fn=6,h=extruder_bolt_dia*.85+extra,center=true);
		}
		translate([0,0,extruder_knob_height/2]) scale([1,1,.70]) sphere(r=extruder_bolt_dia+wall_thickness*2,center=true);
	}
}

module extruder_spring_washer() {
	difference() {
		union() {
			translate([0,0,wall_thickness/2]) cylinder(r=extruder_bolt_dia/1.25,h=wall_thickness,center=true);
			translate([0,0,wall_thickness/4]) cylinder(r=extruder_bolt_dia+wall_thickness,h=wall_thickness/2,center=true);
		}
		translate([0,0,wall_thickness/2]) cylinder(r=extruder_bolt_dia/2+clearance*2.5,h=wall_thickness+extra,center=true);
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
		translate([0,0,-.4]) difference() { //flat bottoms print better.
			union() {
				translate([support_rod_dia/2+(stepper_size+stepper_oversize)/2+wall_thickness,0,wall_thickness/2]) {
					translate([0,support_rod_depth/2-wall_thickness,(stepper_size+stepper_oversize)/2]) cube([(stepper_size+stepper_oversize)+support_rod_dia,wall_thickness*2,(stepper_size+stepper_oversize)],center=true);
					translate([0,0,wall_thickness/2]) cube([(stepper_size+stepper_oversize)+support_rod_dia,support_rod_depth,wall_thickness*2],center=true);
					for (i=[-1,1]) translate([i*(spool_bearing_dia+wall_thickness+clearance),(stepper_size+stepper_oversize)/6+wall_thickness,(stepper_size+stepper_oversize)/2.4]) rotate([-19,0,0]) cube([wall_thickness*3,(stepper_size+stepper_oversize)/2,(stepper_size+stepper_oversize)],center=true);
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
		

