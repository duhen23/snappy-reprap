include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <acme_screw.scad>


$fa = 2;
$fs = 2;

module z_sled()
{
	offcenter = platform_thick;
	cantlen = cantilever_length - platform_thick - groove_height/2;

	color("MediumSlateBlue")
	prerender(convexity=10)
	yrot(90)
	zrot(90)
	down(offcenter+groove_height/2)
	union() {
		back(platform_length/2) {
			difference() {
				union() {
					// Back
					up(platform_thick/2)
						zrot(90) yrot(90)
							sparse_strut(l=rail_spacing-joiner_width+5, h=platform_length, thick=platform_thick, strut=8, maxang=45, max_bridge=999);

					// Slider support
					up(5/2) {
						cube(size=[lifter_rod_diam+2*3, platform_length, 5], center=true);
					}

					// Side aupports
					yspread(platform_length-platform_thick) {
						up((offcenter+groove_height+5)/2) {
							cube(size=[rail_spacing-joiner_width+5, platform_thick, offcenter+groove_height+5], center=true);
						}
					}

					// sliders
					xspread(rail_spacing+joiner_width) {
						up((groove_height+offcenter)/2) {
							difference() {
								// Slider block
								up(6/2) {
									cube(size=[joiner_width+2*5, platform_length, groove_height+offcenter+6], center=true);
								}

								// Slider groove
								up(printer_slop-0.05) {
									cube(size=[joiner_width, platform_length+1, groove_height+offcenter+2*printer_slop], center=true);
								}
							}
						}
						// Slider ridge
						up(groove_height/2+offcenter) {
							zring(n=2, r=joiner_width/2+printer_slop) {
								scale([tan(groove_angle),1,1]) {
									yrot(45) {
										chamfcube(size=[groove_height/sqrt(2), platform_length, groove_height/sqrt(2)], chamfer=2, chamfaxes=[1,0,1], center=true);
									}
								}
							}
						}
					}

					// Lifter block
					yspread(platform_length*5/8) {
						up((offcenter+lifter_rod_diam+4)/2) {
							difference() {
								cube(size=[lifter_rod_diam+2*3, platform_length/8, offcenter+lifter_rod_diam+4], center=true);
								up(5) cube(size=[lifter_rod_diam/2, platform_length/8+1, offcenter+lifter_rod_diam+4.05], center=true);
							}
						}
					}
				}

				// Lifter threading
				yspread(floor((platform_length*5/8)/lifter_thread_size)*lifter_thread_size) {
					up(offcenter+groove_height/2) {
						yspread(printer_slop) {
							xrot(90) zrot(90) {
								acme_threaded_rod(
									d=lifter_rod_diam+2*printer_slop,
									l=platform_length/8+0.5+2*lifter_thread_size,
									threading=lifter_thread_size,
									thread_depth=1.5
								);
							}
						}
					}
				}

				// Lifter rod access
				yspread(platform_length-platform_thick) {
					up(offcenter+groove_height/2) {
						xrot(90) cylinder(d=lifter_rod_diam+4, h=platform_thick+0.05, center=true);
					}
				}
			}
		}

		// Side joiners
		xflip_copy() {
			up(rail_height/2/2) {
				back(joiner_width/2) {
					right((platform_width-5)/2) {
						zrot(-90) half_joiner2(h=rail_height/2, w=joiner_width, clearance=5, a=joiner_angle, slop=printer_slop);
					}
				}
			}
		}

		up(offcenter+groove_height+platform_thick-2) {
			difference() {
				union() {
					up(cantlen/2) {
						// Bottom.
						back(platform_thick/2) {
							zrot(90) sparse_strut(l=rail_width, h=cantlen+4, thick=platform_thick, strut=7);
						}

						// Walls.
						xflip_copy() {
							back(rail_height/2) {
								right((rail_spacing+joiner_width)/2) {
									if (wall_style == "crossbeams")
										sparse_strut(l=rail_height, h=cantlen, thick=joiner_width, strut=5);
									if (wall_style == "thinwall")
										thinning_wall(l=rail_height, h=cantlen, thick=joiner_width, strut=5, bracing=false);
									if (wall_style == "corrugated")
										corrugated_wall(l=rail_height, h=cantlen, thick=joiner_width, strut=5);
								}
							}
						}
					}
				}

				// Clear space for joiners.
				up(cantlen+2.05) {
					back(rail_height/2) {
						xrot(90) joiner_pair_clear(spacing=rail_spacing+joiner_width, h=rail_height+0.001, w=joiner_width, clearance=5, a=joiner_angle);
					}
				}
			}

			// Snap-tab joiners.
			up(cantlen+2) {
				back(rail_height/2) {
					xrot(90) joiner_pair(spacing=rail_spacing+joiner_width, h=rail_height, w=joiner_width, l=5, a=joiner_angle);
				}
			}
		}
	}
}
//!z_sled();



module z_sled_parts() { // make me
	offcenter = platform_thick;
	up(offcenter+groove_height/2)
		zrot(-90) yrot(-90) z_sled();
}


z_sled_parts();


// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap