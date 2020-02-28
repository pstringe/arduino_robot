// Quick-and-dirty parametric LEGO-compatible
// bricks in OpenSCAD.
// LEGO(R) is a trademark of the LEGO Group.
// References:
// * http://www.robertcailliau.eu/Lego/Dimensions/zMeasurements-en.xhtml
// * http://nicjasno.com/forum/viewtopic.php?t=653



module two_by_two(w,l){
  // size constants
  DETAIL_SCALE=0.1; // all measurements below are in units of "0.1mm"
  WALL_THICKNESS=16; // 1.6mm thick walls - obviates need for tiny inner wall towers
  SQUARE_WIDTH=80; // 8mm
  SQUARE_HEIGHT=96; // 9.6mm - std. LEGO height
  PLATE_HEIGHT=32; // 3.2mm - std. flat plate height
  PEG_RADIUS=24; // 2.4mm
  PEG_HEIGHT=18; // 1.8mm
  ANTI_PEG_RADIUS=32; // 3.2mm

  my_height = PLATE_HEIGHT; // PLATE_HEIGHT or SQUARE_HEIGHT. DECIDE!

  scale(DETAIL_SCALE){
    // main outer rectangle shell
    difference(){
      cube([w*(SQUARE_WIDTH*2),l*(SQUARE_WIDTH*2),my_height]);
      translate([WALL_THICKNESS,WALL_THICKNESS,-WALL_THICKNESS]){
        cube([w*(2*SQUARE_WIDTH) - (2*WALL_THICKNESS), l*(2*SQUARE_WIDTH) - (2*WALL_THICKNESS), my_height]);
      }
    }

    // create 2x2 peg grid for each block "wide"x"long"
    for(i=[0:w-1]){ // for each 2x block wide
      for(j=[0:l-1]){ // for each 2x block long
        for(x=[SQUARE_WIDTH*0.5,SQUARE_WIDTH*1.5]) {
          for(y=[SQUARE_WIDTH*0.5, SQUARE_WIDTH*1.5]) {
            translate([(i * SQUARE_WIDTH * 2) + x, (j * SQUARE_WIDTH * 2) + y,my_height]){
              difference(){
                cylinder(h=PEG_HEIGHT, r=PEG_RADIUS);
				 cylinder(h=PEG_HEIGHT+0.1, r=(PEG_RADIUS - WALL_THICKNESS/2));
              }
            }
          }
        }
      }
    }

    // create 1x1 anti-peg grid for each block ((wide-1)*2)x(long-1)*2))
    for(i=[0:(w-1)*2]){
      for(j=[0:(l-1)*2]){
        translate([SQUARE_WIDTH + (SQUARE_WIDTH * i), SQUARE_WIDTH + (SQUARE_WIDTH * j), 0]){
          difference(){
            cylinder(r=ANTI_PEG_RADIUS, h=my_height);
            translate([0,0,-1]){
              cylinder(r=(ANTI_PEG_RADIUS - (WALL_THICKNESS/2)), h=my_height+0.5);
            }
          }
        }
      }
    }
  }
}

// size constants
DETAIL_SCALE=0.1; // all measurements below are in units of "0.1mm"
WALL_THICKNESS=16; // 1.6mm thick walls - obviates need for tiny inner wall towers
SQUARE_WIDTH=80; // 8mm
SQUARE_HEIGHT=96; // 9.6mm - std. LEGO height
PLATE_HEIGHT=32; // 3.2mm - std. flat plate height
PEG_RADIUS=24; // 2.4mm
PEG_HEIGHT=18; // 1.8mm
ANTI_PEG_RADIUS=32; // 3.2mm

//base dimensions for interior/exterior prisms in mm
exterior_width = SQUARE_WIDTH * 4; // brick width
interior_width = exterior_width - 1.5 * SQUARE_WIDTH;
exterior_length = SQUARE_WIDTH * 8; // brick length
interior_height = SQUARE_WIDTH * 9;
interior_length = exterior_length;
exterior_height = SQUARE_HEIGHT * 2;

dist_top_to_bottom_front_peg = 15.2;
dist_top_to_bottom_side_peg = 15;
dist_front_to_front_side_peg = 8.6;

//motor sleeve
difference(){
    difference(){
        union(){
            // Create (w*2,h*2) LEGO-compatible blocks.
            two_by_two(2,4);

            // create exterior prism
            scale (DETAIL_SCALE){
                translate([0, 0, PLATE_HEIGHT])
                    cube([exterior_width, exterior_length, exterior_height], center=false);
            }
            
            // create male connectors for top of exterior prism
            translate([0,0, (PLATE_HEIGHT + exterior_height) * DETAIL_SCALE])
                two_by_two(2, 4);
        }
           
        // create interior prism (negative space)
        scale (DETAIL_SCALE){
            translate([SQUARE_WIDTH * 0.75, SQUARE_WIDTH, PLATE_HEIGHT])
                cube([interior_width, interior_length, interior_height], center=false);
        }
    }
    
    
    union(){
   
        //side holes (negative space)
        scale(DETAIL_SCALE){
            translate([SQUARE_WIDTH/-2, exterior_height, PLATE_HEIGHT + (exterior_height / 2)])
                rotate([0,90,0])
                    cylinder(h=exterior_width + SQUARE_WIDTH, r1=70, r2=70);
        }
      
       
        //front holes (negative space)
        scale(DETAIL_SCALE){
            translate([exterior_width / 2, SQUARE_WIDTH * 2, PLATE_HEIGHT + (exterior_height / 2)])
                rotate([90,0,0])
                    cylinder(h=exterior_width + SQUARE_WIDTH, r1=30, r2=30);
        }

        //side slits
        scale(DETAIL_SCALE){
            translate([-SQUARE_WIDTH,SQUARE_WIDTH * 2, exterior_height/2])
                rotate([0,0,0])
                    cube([SQUARE_WIDTH * 6, SQUARE_WIDTH, SQUARE_WIDTH * 3]);
        }

        //front slits
        scale(DETAIL_SCALE){
            translate([exterior_width / 2, 0, PLATE_HEIGHT + exterior_height])
                rotate([90,0,0])
                    cube([SQUARE_WIDTH * 0.5, SQUARE_WIDTH * 2, SQUARE_WIDTH * 2], center=true);
        }
        
   }

}
