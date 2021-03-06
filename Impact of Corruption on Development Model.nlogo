extensions [array] ;; including the array extension into netlogo

breed [lights light]           ;; Breeds for traffic lights
breed [zebras zebra]           ;; Breeds for zebra crossing
breed [lines line]             ;; Breeds for road lines
breed [checks_xes check_x]     ;; Breeds for pedestrian crossing
breed [houses house]           ;; Breeds for houses
breed [cars car]               ;; Breeds for cars
breed [industries industry]    ;; Breeds for industries
breed [pedestrians pedestrian] ;; Breeds for pedestrians

industries-own       ;; only industry breed variable
[
  temporary
]

cars-own             ;; only cars breed variable
[
  speed
  turn_value
  car_exception
  car_exception2
  car_exception3
]

pedestrians-own      ;; only pedestrian breed variable
[
  turn_value
  limit_crossing
  pedestrian_exception
  pedestrian_exception2
  pedestrian_exception3
]

houses-own           ;; only house breed variable
[
  category
  temporary
]

globals              ;; global variables
[
  counter            ;; used incase of loops.

  temp               ;; variable used in the housing-scheme method
  temp2              ;; variable used in the housing-scheme method

  temp3
  temp4
  temp5
  temp6              ;; Variable used in the setup-houses method

  temp7
  temp8

  xpos
  ypos
  rprog

  zllprog

  x_count               ;; Variable used in setup-roadlines method.
  y_count               ;; Variable used in setup-roadlines method.
  RLstart               ;; Variable used in setup-roadlines method.

  no-of-houses          ;; Varible for Monitor
  no-of-industries      ;; Varible for Monitor

  car_violation         ;; Varible for Monitor
  car_follow            ;; Varible for Monitor

  pedestrian_violation  ;; Varible for Monitor
  pedestrian_follow     ;; Varible for Monitor

]

to setup

  clear-all              ;; Clearing the screen
  setup-patches          ;; Creating Patches. setting up grass.

  setup-traffic_lights   ;; setting up Traffic lights

  if (corruption = 0 or corruption = 25)   ;; Setting up zebra crossing only when value of corruption is 0, 25
  [
    setup-zebra_crossing                   ;; Setting up zebra crossing
  ]

  if (corruption != 75)        ;; Road lines will only be created when value of corruption is 0, 25, 50
  [
    setup-roadlines            ;; Setting up road lines
  ]

  setup-pedestrians           ;; Creating Pedestrians
  setup-cars                  ;; Creating Cars
  setup-houses                ;; Creating houses
  setup-pedestrian_crossing   ;; Creating Pedestrian Crossings (breed checks_xes)
  setup-industries            ;; Creating Industries
  setup-positions             ;; Placing fixed positions into arrays for road network progress animation
  set pedestrian_follow 1     ;; setting value to 1 so plot doesn't gives an error
  set car_follow 1            ;; setting value to 1 so plot doesn't gives an error
  reset-ticks                 ;; resetting the value of ticks

end

to go

  ifelse ((show_progress = "road network" or show_progress = "all") and rprog != 167)
  [
    building-roads-pavements          ;; Building (animating) the roads and pavements step by step
  ]

  [
    setting-up-zebras-lights-lines    ;; Building (animating) the zebra crossing, road lights and road lines after roads and pavements are built
  ]

  blink-traffic_lights_crossing       ;; Blinking / changing the traffic lights and pedestrian crossing

  if (temp4 = count houses)
  [
    finished-house-construction       ;; Checking if houses construction is finished

    if (temp5 = temp6)
    [
      set temp4 -1
    ]
  ]

  if (ticks mod 20 = 0 and temp5 != temp6 and (show_progress = "only houses" or show_progress = "houses and industries" or show_progress = "all"))
  [
    construct-houses                 ;; Starting the construction of the houses
  ]

  if (ticks mod 30 = 0 and (temp8 != (count industries * 3)) and (show_progress = "only industries" or show_progress = "houses and industries" or show_progress = "all"))
  [
    construct-industries             ;; Starting the construction of the industries
  ]

  if (ticks mod 5 = 0)
  [
    working-industries              ;; Showing the working / functioning industries
  ]

  tick        ;; incrementing tick variable. adding 1 into ticks variable.

end

to go-pedestrians

  move-pedestrians    ;; Making the Pedestrian Move on the pavement

end

to go-cars

  move-cars           ;; Making the Cars move on the road

end

to setup-patches

  ask patches [set pcolor green - random-float 0.5]          ;; Creating Grass with different shades of green

  if (show_progress = "none" or show_progress = "only houses" or show_progress = "only industries" or show_progress = "houses and industries")
  [
     ask patches with [pycor = 13 ] [set pcolor grey - 1]    ;; Creating Pavement
     ask patches with [pycor = 17 ] [set pcolor grey - 1]    ;; Creating Pavement
     ask patches with [pycor = -13] [set pcolor grey - 1]    ;; Creating Pavement
     ask patches with [pycor = -17] [set pcolor grey - 1]    ;; Creating Pavement

     ask patches with [pxcor = 26 ] [set pcolor grey - 1]    ;; Creating Pavement
     ask patches with [pxcor = 30 ] [set pcolor grey - 1]    ;; Creating Pavement
     ask patches with [pxcor = -26] [set pcolor grey - 1]    ;; Creating Pavement
     ask patches with [pxcor = -30] [set pcolor grey - 1]    ;; Creating Pavement

     ask patches with [pycor = 15 ] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pycor = 16 ] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pycor = 14 ] [set pcolor grey + 1]    ;; Creating Road

     ask patches with [pycor = -15] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pycor = -16] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pycor = -14] [set pcolor grey + 1]    ;; Creating Road

     ask patches with [pxcor = 27 ] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pxcor = 28 ] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pxcor = 29 ] [set pcolor grey + 1]    ;; Creating Road

     ask patches with [pxcor = -27] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pxcor = -28] [set pcolor grey + 1]    ;; Creating Road
     ask patches with [pxcor = -29] [set pcolor grey + 1]    ;; Creating Road
  ]

end

to setup-traffic_lights

  create-lights 16    ;; Method to Create 16 traffic lights

  ask lights
  [
    set color red
    set shape "rectangle"
    set size 4

    if (show_progress = "road network" or show_progress = "all")
    [
      set hidden? true    ;; value of hidden will be true if building or animation of traffic lights is required
    ]
  ]

  ;; Placing 16 Traffic lights at specific locations with specific headings (orientation)

  ask light 0  [ setxy -31 15.8   set heading 0  ]

  ask light 1  [ setxy -27.2 18   set heading 90 ]

  ask light 2  [ setxy -25 14.2   set heading 0  ]

  ask light 3  [ setxy -28.8 12   set heading 90 ]

  ask light 4  [ setxy 25 15.8    set heading 0  ]

  ask light 5  [ setxy 28.8 18    set heading 90 ]

  ask light 6  [ setxy 31 14.2    set heading 0  ]

  ask light 7  [ setxy 27.2 12    set heading 90 ]

  ask light 8  [ setxy -31 -14.2  set heading 0  ]

  ask light 9  [ setxy -27.2 -12  set heading 90 ]

  ask light 10 [ setxy -25 -15.8  set heading 0  ]

  ask light 11 [ setxy -28.8 -18  set heading 90 ]

  ask light 12 [ setxy 25 -14.2   set heading 0  ]

  ask light 13 [ setxy 28.8 -12   set heading 90 ]

  ask light 14 [ setxy 31 -15.8   set heading 0  ]

  ask light 15 [ setxy 27.2 -18   set heading 90 ]

end

to setup-zebra_crossing

  create-zebras 16   ;; Creating 16 zebra crossing

  ask zebras
  [
    set shape "zebra crossing"
    set size 3

    if (show_progress = "road network" or show_progress = "all")
    [
      set hidden? true    ;; value of hidden will be true if building or animation of zebra crossing is required
    ]
  ]

  ;; Placing 16 zebra crossings at specific locations with specific headings (orientation)


  ask zebra count lights        [ setxy -30 15     set heading 0  ]

  ask zebra (count lights + 1)  [ setxy -28 17     set heading 90 ]

  ask zebra (count lights + 2)  [ setxy -25.9 15   set heading 0  ]

  ask zebra (count lights + 3)  [ setxy -28 12.9   set heading 90 ]

  ask zebra (count lights + 4)  [ setxy 26 15      set heading 0  ]

  ask zebra (count lights + 5)  [ setxy 28 17      set heading 90 ]

  ask zebra (count lights + 6)  [ setxy 30.1 15    set heading 0  ]

  ask zebra (count lights + 7)  [ setxy 28 12.9    set heading 90 ]

  ask zebra (count lights + 8)  [ setxy -30 -15    set heading 0  ]

  ask zebra (count lights + 9)  [ setxy -28 -13    set heading 90 ]

  ask zebra (count lights + 10) [ setxy -25.9 -15  set heading 0  ]

  ask zebra (count lights + 11) [ setxy -28 -17.1  set heading 90 ]

  ask zebra (count lights + 12) [ setxy 26 -15     set heading 0  ]

  ask zebra (count lights + 13) [ setxy 28 -13     set heading 90 ]

  ask zebra (count lights + 14) [ setxy 30.1 -15   set heading 0  ]

  ask zebra (count lights + 15) [ setxy 28 -17.1   set heading 90 ]

end

to setup-roadlines

  create-lines 174  ;; creating 174 road lines. Road lines are the lines that appear in the middle of the road working as a partition.

  ask lines
  [
    set shape "road line"
    set color white

    if (show_progress = "road network" or show_progress = "all")
    [
      set hidden? true  ;; value of hidden will be true if building or animation of road lines is required
    ]
  ]

  set x_count -55                                     ;; global variable
  set y_count 30                                      ;; global variable
  set counter (count lights + count zebras)           ;; global variable
  set RLstart (count lights + count zebras)           ;; global variable

  ;; Horizontal road must have a total of 56 road lines and vertical roads must have a total of 31 road lines

  while [counter <= RLstart + 55]     ;; loop for creating the road lines for the upper horizontal road
  [
    ask line counter
    [
      setxy x_count 15
      set x_count x_count + 2
      set heading 0
    ]

    set counter counter + 1
  ]


  while [counter <= RLstart + 55 + 56]    ;; loop for creating the road lines for the lower horizontal road
  [
    ask line counter
    [
      set x_count x_count - 2
      setxy x_count -15
      set heading 0
    ]

    set counter counter + 1
  ]


  while [counter <= RLstart + 55 + 56 + 31]    ;; loop for creating the road lines for the left vertical road
  [
    ask line counter
    [
      setxy -28 y_count
      set y_count y_count - 2
      set heading 90
    ]

    set counter counter + 1
  ]


  while [counter <= RLstart + 55 + 56 + 31 + 31]      ;; loop for creating the road lines for the right vertical road
  [
    ask line counter
    [
      set y_count y_count + 2
      setxy 28 y_count
      set heading 90
    ]

    set counter counter + 1
  ]

end

to setup-pedestrians

  create-pedestrians no_of_pedestrians      ;; Creating Pedestrians

  let x array:from-list [26 -26 30 -30]     ;; Array of specific x axis
  let y array:from-list [14 -12 18 -16]     ;; Array of specific y axis

  set counter (count lights + count zebras + count lines)      ;; Making counter to identify pedestrians (using counter as who number)

  ask pedestrians
  [
    set shape "person"
    set size 2
    set color yellow - 1
  ]

  while [counter < (count lights + count zebras + count lines + No_of_Pedestrians)]    ;; Only dealing with pedestrians
  [
    ask pedestrian counter
    [
      ifelse (random 2 = 0)
      [
        setxy array:item x random 4 random-ycor   ;; setting value of x and y cordinate for specific pedestrians
        set heading one-of [0 180]
        set ycor precision ycor 1

        while [(ycor <= 20 and ycor >= 10) or (ycor <= -10 and ycor >= -20)]   ;; Loop that makes sure that the pedestrians initially dont appear very near to pedestrian crossings
        [
          setxy xcor random-ycor
        ]
      ]

      [
        setxy random-xcor array:item y random 4   ;; setting value of x and y cordinate for specific pedestrians
        set heading one-of [90 270]
        set xcor precision xcor 1

        while [(xcor <= 33 and xcor >= 23) or (xcor <= -23 and xcor >= -33)]
        [
          setxy random-xcor ycor
        ]
      ]
    ]

    set counter counter + 1
  ]

end

to setup-cars

  create-cars no_of_cars

  let x1 array:from-list [-28.8 27.3]    ;; Array of specific values x axis
  let x2 array:from-list [-27.3 28.8]    ;; Array of specific values x axis
  let y1 array:from-list [-14.3 15.8]    ;; Array of specific values y axis
  let y2 array:from-list [-15.8 14.3]    ;; Array of specific values y axis

  set counter (count lights + count zebras + count lines + count pedestrians)   ;; Making counter to identify only cars (using counter as who number)

  ask cars
  [
    set shape "car top"
    set size 2.6
    set color one-of [red orange brown yellow lime turquoise cyan sky blue violet magenta pink]
    set speed 0.3
  ]

  while [counter < (count lights + count zebras + count pedestrians + count lines + No_of_Cars)]   ;; only dealing with cars
  [
    ask car counter
    [
      ifelse (random 2 = 0)       ;; placing random cars at specific places using 50 % probability / chance
      [
          ifelse (random 2 = 0)
          [
             setxy array:item x1 random 2 random-ycor
             set heading 0
             set ycor precision ycor 1

             while [(ycor <= 25 and ycor >= 5) or (ycor >= -25 and ycor <= -5)]
             [
               setxy xcor random-ycor
             ]
          ]

          [
             setxy array:item x2 random 2 random-ycor
             set heading 180
             set ycor precision ycor 1

             while [(ycor <= 25 and ycor >= 5) or (ycor >= -25 and ycor <= -5)]
             [
               setxy xcor random-ycor
             ]
          ]
      ]

      [
         ifelse (random 2 = 0)
         [
            setxy random-xcor array:item y1 random 2
            set heading 90
            set xcor precision xcor 1

            while [(xcor <= 38 and xcor >= 18) or (xcor >= -38 and xcor <= -18)]
            [
              setxy random-xcor ycor
            ]
         ]

         [
            setxy random-xcor array:item y2 random 2
            set heading 270
            set xcor precision xcor 1

            while [(xcor <= 38 and xcor >= 18) or (xcor >= -38 and xcor <= -18)]
            [
              setxy random-xcor ycor
            ]
         ]
      ]
    ]

    set counter counter + 1
  ]

end

to setup-houses

  let No_of_Houses 1
  set counter  1

  ;; creating different number of houses depending upon different value of corruption

  if (corruption = 0)
  [
    set No_of_Houses 132
  ]

  if (corruption = 25)
  [
    while [counter <= 132]
    [
      if (random 4 = 0 or random 4 = 1 or random 4 = 2)   ;; Using Probability. if corruption is 25 then almost there are 75% of the houses which are probable to be built
      [
        set No_of_Houses No_of_Houses + 1
      ]

      set counter counter + 1
    ]
  ]

  if (corruption = 50)
  [
    while [counter <= 132]
    [
      if (random 4 = 0 or random 4 = 1)                 ;; Using Probability. if corruption is 50 then almost there are 50% of the houses which are probable to be built
      [
        set No_of_Houses No_of_Houses + 1
      ]

      set counter counter + 1
    ]
  ]

  if (corruption = 75)
  [
    while [counter <= 132]
    [
      if (random 4 = 0)                              ;; Using Probability. if corruption is 75 then almost there are 25% of the houses which are probable to be built
      [
        set No_of_Houses No_of_Houses + 1
      ]

      set counter counter + 1
    ]
  ]

  create-houses No_of_Houses
  [
    set size 5
    set color one-of [red orange brown yellow lime turquoise cyan sky blue violet magenta pink]

    ;; Selecting Different categories of houses depending upon different corruption level

    if (corruption = 0)
    [
      set category one-of [4 5 6]
    ]

    if (corruption = 25)
    [
      set category one-of [3 4 5 6]
    ]

    if (corruption = 50)
    [
      set category one-of [2 3 4 5 6]
    ]

    if (corruption = 75)
    [
      set category one-of [1 2 3 4 5 6]
      if (category = 1) [ set size 3 ]
    ]

    set hidden? true  ;; Making the houses invisible to show their construction.
  ]

  housing-scheme

  if (show_progress = "none" or show_progress = "only industries" or show_progress = "road network")
  [
    set no-of-houses count houses

    ask houses
    [
      set hidden? false   ;; Making the houses visible and not showing their construction

      ;; Different qualities or types of houses

      if (category = 1)
      [
        set shape "house"
      ]

      if (category = 2)
      [
        set shape "house efficiency"
      ]

      if (category = 3)
      [
        set shape "house bungalow"
      ]

      if (category = 4)
      [
        set shape "house ranch"
      ]

      if (category = 5)
      [
        set shape "house colonial"
      ]

      if (category = 6)
      [
        set shape "house two story"
      ]
    ]
  ]

  set temp6 -1

end

to housing-scheme

  let x_pos array:from-list [21 15 9 3 -3 -9 -15 -21 -34 -40 -46 -52]    ;; fixed x-cordinates for placing the houses in an orderly manner
  let y_pos array:from-list [30 25 20 10 5 0 -5 -10 -19 -24 -29]         ;; fixed y-cordinates for placing the houses in an orderly manner
  let X_positions array:from-list n-values 132[0]                        ;; placing x-cordinates in an array to be paired with is corresponding y-cordinates pair
  let Y_positions array:from-list n-values 132[0]                        ;; placing y-cordinates in an array to be paired with is corresponding x-cordinates pair
  let Checker array:from-list n-values 132[-1]                           ;; Checker is to make sure that no index get selected twice so no houses overlap eachother

  set temp 0
  set temp2 0
  set counter 0

  while [temp < 12]              ;; using inner loops to create all possible combinations od fixed x and y cordinates for an equal and ordered placement of houses
  [
    set temp2 0

    while [temp2 < 11]
    [
      array:set X_positions counter array:item x_pos temp
      array:set Y_positions counter array:item y_pos temp2
      set temp2 temp2 + 1
      set counter counter + 1
    ]

    set temp temp + 1
  ]

  set counter (count lights + count zebras + count lines + count pedestrians + count cars)   ;; Making counter to identify only houses (using counter as who number)
  set temp 0
  let values 132

  while [counter < (count lights + count zebras + count lines + count pedestrians + count cars + count houses)]  ;; only dealing with houses
  [
    let checker_counter1 (count lights + count zebras + count lines + count pedestrians + count cars)
    let checker_counter2 0
    let checker_counter3 counter

    set temp random values

    if (temp = (values - 1))
    [
      set values values - 1
    ]

    while [checker_counter1 <= checker_counter3]
    [
       ifelse ((array:item Checker checker_counter2) != temp)
       [
         if ((array:item Checker checker_counter2) = -1)
         [
           array:set Checker checker_counter2 temp

           ask house counter
           [
             setxy array:item X_positions temp array:item Y_positions temp
             set counter counter + 1
           ]
         ]

         set checker_counter1 checker_counter1 + 1
         set checker_counter2 checker_counter2 + 1
       ]

       [
         set checker_counter1 checker_counter3 + 1
       ]
    ]
  ]

end

to setup-pedestrian_crossing

  let total (count lights + count zebras + count lines + count pedestrians + count cars + count houses)  ;; calculating the who number from where pedestrian crossing will start

  create-checks_xes 16   ;; Creating 16 checks_xes (breed used for pedestrian crossing)
  [
    set shape "x"
    set color black

    if (show_progress = "road network" or show_progress = "all")
    [
      set hidden? true
    ]
  ]

  ;; Placing all pedestrian crossing at specific positions

  ask check_x (total     ) [setxy  -31 18]
  ask check_x (total +  1) [setxy  -25 18]
  ask check_x (total +  2) [setxy  -31 12]
  ask check_x (total +  3) [setxy  -25 12]

  ask check_x (total +  4) [setxy   25 18]
  ask check_x (total +  5) [setxy   31 18]
  ask check_x (total +  6) [setxy   25 12]
  ask check_x (total +  7) [setxy   31 12]

  ask check_x (total +  8) [setxy -31 -12]
  ask check_x (total +  9) [setxy -25 -12]
  ask check_x (total + 10) [setxy -31 -18]
  ask check_x (total + 11) [setxy -25 -18]

  ask check_x (total + 12) [setxy  25 -12]
  ask check_x (total + 13) [setxy  31 -12]
  ask check_x (total + 14) [setxy  25 -18]
  ask check_x (total + 15) [setxy  31 -18]

end

to move-pedestrians

  set counter (count lights + count zebras + count lines)    ;; Making counter to identify only pedestrians (using counter as who number)

  while [counter < (count lights + count zebras + count lines + count pedestrians)]    ;; only dealing with pedestrains. Making pedestrians move on the pavements.
  [
    ask pedestrian counter
    [
      set xcor precision xcor 1    ;; Rounding off value of xcor to 1 deciamal place for accuracy
      set ycor precision ycor 1    ;; Rounding off value of ycor to 1 deciamal place for accuracy

      ifelse
      (
         (xcor = -30 and ycor =  18) or (xcor = -26 and ycor =  18) or (xcor = -30 and ycor =  14) or (xcor = -26 and ycor =  14) or
         (xcor = -30 and ycor = -12) or (xcor = -26 and ycor = -12) or (xcor = -30 and ycor = -16) or (xcor = -26 and ycor = -16) or
         (xcor =  26 and ycor =  18) or (xcor =  30 and ycor =  18) or (xcor =  26 and ycor =  14) or (xcor =  30 and ycor =  14) or
         (xcor =  26 and ycor = -12) or (xcor =  30 and ycor = -12) or (xcor =  26 and ycor = -16) or (xcor =  30 and ycor = -16)
      )

      [
        if ((xcor = -30 and ycor =  18) or (xcor = -30 and ycor = -12) or (xcor =  26 and ycor =  18) or (xcor =  26 and ycor = -12))
        [
          set turn_value 1
        ]

        if ((xcor = -26 and ycor =  18) or (xcor = -26 and ycor = -12) or (xcor =  30 and ycor =  18) or (xcor =  30 and ycor = -12))
        [
          set turn_value 2
        ]

        if ((xcor = -30 and ycor =  14) or (xcor = -30 and ycor = -16) or (xcor =  26 and ycor =  14) or (xcor =  26 and ycor = -16))
        [
          set turn_value 3
        ]

        if ((xcor = -26 and ycor =  14) or (xcor = -26 and ycor = -16) or (xcor =  30 and ycor =  14) or (xcor =  30 and ycor = -16))
        [
          set turn_value 4
        ]

        ifelse (pedestrian_signal counter)   ;; Checking the signal (traffic lights) ;; Move if the reporter returns True
        [
          if (limit_crossing = 0)
          [
            turn_pedestrian counter
            set limit_crossing 2
          ]

          forward 0.1
        ]

        [                                   ;; Stopping the car if reporter return false
          if (limit_crossing = 0)
          [
            turn_pedestrian counter
            set limit_crossing 1
            forward 0
          ]

          if (limit_crossing = 2)
          [
            forward 0.1
          ]
        ]
      ]

      [
        ifelse (pedestrian_patience counter)   ;; Checking if the pedestrian walking ahead stops walking the pedestrain behind should stop as well
        [
          forward 0.1
        ]

        [
          forward 0
        ]

        reset-values counter              ;; Resetting values of different variables
      ]
    ]

    set counter counter + 1
  ]

end

to turn_pedestrian [pedes_who]           ;; Turning the car

  ask pedestrian pedes_who
  [
    let new_heading heading

    if (turn_value = 1)
    [
      ifelse (heading = 90)
      [
        set new_heading one-of [0 90 180]
      ]

      [
        if (heading = 180)
        [
          set new_heading one-of [90 180 270]
        ]
      ]

      if ((new_heading = 0 and heading = 90) or (new_heading = 270 and heading = 180))
      [
        set heading new_heading
        forward 0.1
      ]
    ]

    if (turn_value = 2)
    [
      ifelse (heading = 180)
      [
        set new_heading one-of [90 180 270]
      ]

      [
        if (heading = 270)
        [
          set new_heading one-of [0 180 270]
        ]
      ]

      if ((new_heading = 0 and heading = 270) or (new_heading = 90 and heading = 180))
      [
        set heading new_heading
        forward 0.1
      ]
    ]

    if (turn_value = 3)
    [
      ifelse (heading = 90)
      [
        set new_heading one-of [0 90 180]
      ]

      [
        if (heading = 0)
        [
          set new_heading one-of [0 90 270]
        ]
      ]

      if ((new_heading = 270 and heading = 0) or (new_heading = 180 and heading = 90))
      [
        set heading new_heading
        forward 0.1
      ]
    ]

    if (turn_value = 4)
    [
      ifelse (heading = 0)
      [
        set new_heading one-of [0 90 270]
      ]

      [
        if (heading = 270)
        [
          set new_heading one-of [0 180 270]
        ]
      ]

      if ((new_heading = 180 and heading = 270) or (new_heading = 90 and heading = 0))
      [
        set heading new_heading
        forward 0.1
      ]
    ]

    set heading new_heading
  ]

end

to reset-values [pedes_who]

  ask pedestrian pedes_who
  [
    if
    (
      (ycor = 18 and (xcor = -50   or xcor = 0)) or (ycor = 14 and (xcor = -50  or xcor = 0)) or (ycor = -12 and (xcor = -50  or xcor = 0)) or (ycor = -16 and (xcor = -50  or xcor = 0)) or
      (xcor = -30 and (ycor = 30 or ycor = 0)) or (xcor = -26 and (ycor = 30 or ycor = 0)) or (xcor = 26 and (ycor = 30 or ycor = 0)) or (xcor = 30 and (ycor = 30 or ycor = 0))
    )

    [
      set limit_crossing 0

      set pedestrian_exception 0
      set pedestrian_exception2 0
      set pedestrian_exception3 0
    ]
  ]

end

to-report pedestrian_signal [pedes_who]

  let temp_value 0

  ask checks_xes
  [
    ifelse (shape = "x")
    [
      set temp_value 1
    ]

    [
      set temp_value 2
    ]
  ]

  if (temp_value = 1)                                     ;; The following code makes the pedestrians not follow the rules depending upon probability and value of corruption
  [
    ask pedestrian pedes_who
    [
      ifelse (pedestrian_exception = 0)
      [
        if (corruption = 25)
        [
          ifelse (random 4 = 0)                        ;; 25 % probability of pedestrains not following the pedestrain crossing
          [
            set temp_value -1
            set pedestrian_exception 1
          ]

          [
            set pedestrian_exception 2
          ]
        ]

        if (corruption = 50)
        [
          ifelse (random 4 = 0 or random 4 = 1)        ;; 50 % probability of pedestrains not following the pedestrain crossing
          [
            set temp_value -1
            set pedestrian_exception 1
          ]

          [
            set pedestrian_exception 2
          ]
        ]

        if (corruption = 75)
        [
          ifelse (random 4 = 0 or random 4 = 1 or random 4 = 2)             ;; 75 % probability of pedestrains not following the pedestrain crossing
          [
            set temp_value -1
            set pedestrian_exception 1
          ]

          [
            set pedestrian_exception 2
          ]
        ]
      ]

      [
        if (pedestrian_exception = 1)
        [
          set temp_value -1
        ]
      ]
    ]

    if (temp_value = -1)
    [
      ask pedestrian pedes_who
      [
        if (pedestrian_exception3 = 0)
        [
          set pedestrian_violation pedestrian_violation + 1
          set pedestrian_exception3 1
        ]
      ]

      report true
    ]

    ask pedestrian pedes_who
    [
      if (pedestrian_exception2 = 0)
      [
        set pedestrian_follow pedestrian_follow + 1
        set pedestrian_exception2 1
      ]
    ]

    report false
  ]

  if (temp_value = 2)
  [
    ask pedestrian pedes_who
    [
      if (pedestrian_exception2 = 0)
      [
        set pedestrian_follow pedestrian_follow + 1
        set pedestrian_exception2 1
      ]
    ]

    report true
  ]

end

to-report pedestrian_patience [pedes_who]

  let temp_value 0
  let temporary_heading -1

  if any? pedestrians-on patch-ahead 1
  [
    ask pedestrians-on patch-ahead 1
    [
      set temporary_heading heading
    ]

    ask pedestrian pedes_who
    [
      ifelse
      (
        (heading = temporary_heading) or
        ((temporary_heading  = 0 or temporary_heading  = 90) and (heading = 0 or heading = 90)) or
        ((temporary_heading  = 0 or temporary_heading  = 270) and (heading = 0 or heading = 270)) or
        ((temporary_heading  = 90 or temporary_heading  = 180) and (heading = 90 or heading = 180)) or
        ((temporary_heading  = 180 or temporary_heading  = 270) and (heading = 180 or heading = 270))
      )

      [
        set temp_value 1
      ]

      [
        set temp_value 2
      ]
    ]

    if (temp_value = 1)
    [
      report false
    ]

    if (temp_value = 2)
    [
      report true
    ]
  ]

  report true

end

to move-cars

  set counter (count lights + count zebras + count lines + count pedestrians)

  while [counter < (count lights + count zebras + count lines + count pedestrians + count cars)]
  [
    ask car counter
    [
      reset-variables counter

      ifelse (heading = 0 and (int ycor = 10 or int ycor = -19))
      [
        ifelse (signal 1 counter)
        [
          forward speed
        ]

        [
          forward 0
          ;set speed (random-float 0.5) + 0.1
        ]

        if (turn_value = 0)
        [
          set turn_value 1
        ]
      ]

      [
        ifelse (heading = 180 and (int ycor = -10 or int ycor = 19))
        [
          ifelse (signal 2 counter)
          [
            forward speed
          ]

          [
            forward 0
           ; set speed (random-float 0.5) + 0.1
          ]

          if (turn_value = 0)
          [
            set turn_value 2
          ]
        ]

        [
          ifelse (heading = 90 and (int xcor = 23 or int xcor = -32))
          [
            ifelse (signal 3 counter)
            [
              forward speed
            ]

            [
              forward 0
              ;set speed (random-float 0.5) + 0.1
            ]

            if (turn_value = 0)
            [
              set turn_value 3
            ]
          ]

          [
            ifelse (heading = 270 and (int xcor = 32 or int xcor = -23))
            [
              ifelse (signal 4 counter)
              [
                forward speed
              ]

              [
                forward 0
               ; set speed (random-float 0.5) + 0.1
              ]

              if (turn_value = 0)
              [
                set turn_value 4
              ]
            ]

            [
              ifelse (patience counter or cars-pedestrians-patience counter)
              [
                forward 0
              ]

              [
                forward speed
              ]
            ]
          ]
        ]
      ]

      set xcor precision xcor 1
      set ycor precision ycor 1

      if
      (
          ((heading =  0 or heading = 180) and (int ycor = -14 or int ycor = -15 or int ycor = 14 or int ycor = 15)) or
          ((heading = 90 or heading = 270) and (int xcor = -28 or int xcor = -27 or int xcor = 28 or int xcor = 27))
      )

      [
        turn-car (counter)
      ]
    ]

    set counter counter + 1
  ]

end

to reset-variables [car_who]

  ask car car_who
  [
    if ((ycor = -14.3 or ycor = 15.8 or ycor = -15.8 or ycor = 14.3) and (int xcor = 0 or int xcor = -52))
    [
      set turn_value 0
      set car_exception 0
      set car_exception2 0
      set car_exception3 0
    ]

    if ((xcor = -28.8 or xcor = 27.3 or xcor = -27.3 or xcor = 28.8) and (int ycor = 0 or int ycor = 28))
    [
      set turn_value 0
      set car_exception 0
      set car_exception2 0
      set car_exception3 0
    ]
  ]

end

to turn-car [carwho]

  let direction1 array:from-list [0 90 270]
  let direction2 array:from-list [90 180 270]
  let direction3 array:from-list [0 90 180]
  let direction4 array:from-list [0 180 270]

  ask car carwho
  [
    ifelse (heading = 0)
    [
      if (turn_value = 1)
      [
        set temp array:item direction1 random 3
        set turn_value -1
      ]

      if (temp = 90 and int ycor = -14)
      [
        set heading temp
        set ycor -14.3
      ]

      if (temp = 90 and int ycor = 15)
      [
        set heading temp
        set ycor 15.8
      ]

      if (temp = 270 and int ycor = 14)
      [
        set heading temp
        set ycor 14.3
      ]

      if (temp = 270 and int ycor = -15)
      [
        set heading temp
        set ycor -15.8
      ]
    ]

    [
      ifelse (heading = 90)
      [
        if (turn_value = 3)
        [
          set temp array:item direction3 random 3
          set turn_value -1
        ]

        if (temp = 0 and int xcor = -28)
        [
          set heading temp
          set xcor -28.8
        ]

        if (temp = 0 and int xcor = 27)
        [
          set heading temp
          set xcor 27.3
        ]

        if (temp = 180 and int xcor = -27)
        [
          set heading temp
          set xcor -27.3
        ]

        if (temp = 180 and int xcor = 28)
        [
          set heading temp
          set xcor 28.8
        ]
      ]

      [
        ifelse (heading = 180)
        [
          if (turn_value = 2)
          [
            set temp array:item direction2 random 3
            set turn_value -1
          ]

          if (temp = 90 and int ycor = -14)
          [
            set heading temp
            set ycor -14.3
          ]

          if (temp = 90 and int ycor = 15)
          [
            set heading temp
            set ycor 15.8
          ]

          if (temp = 270 and int ycor = 14)
          [
            set heading temp
            set ycor 14.3
          ]

          if (temp = 270 and int ycor = -15)
          [
            set heading temp
            set ycor -15.8
          ]
        ]

        [
          if (heading = 270)
          [
            if (turn_value = 4)
            [
              set temp array:item direction4 random 3
              set turn_value -1
            ]

            if (temp = 0 and int xcor = -28)
            [
              set heading temp
              set xcor -28.8
            ]

            if (temp = 0 and int xcor = 27)
            [
              set heading temp
              set xcor 27.3
            ]

            if (temp = 180 and int xcor = -27)
            [
              set heading temp
              set xcor -27.3
            ]

            if (temp = 180 and int xcor = 28)
            [
              set heading temp
              set xcor 28.8
            ]
          ]
        ]
      ]
    ]
  ]

end

to blink-traffic_lights_crossing

  ifelse (temp3 / 100 <= 1)
  [
    ask light 0
    [
      set color lime
    ]

    ask light 4
    [
      set color lime
    ]

    ask light 8
    [
      set color lime
    ]

    ask light 12
    [
      set color lime
    ]

    if (temp3 >= 97)
    [
      ask lights
      [
        set color red
      ]
    ]

    set temp3 temp3 + 1
  ]

  [
    ifelse (temp3 / 100 <= 2)
    [
      ask light 1
      [
        set color lime
      ]

      ask light 5
      [
        set color lime
      ]

      ask light 9
      [
        set color lime
      ]

      ask light 13
      [
        set color lime
      ]

      set temp3 temp3 + 1

      if (temp3 >= 197)
      [
        ask lights
        [
          set color red
        ]
      ]
    ]

    [
      ifelse (temp3 / 100 <= 3)
      [
        ask checks_xes
        [
          set shape "check"
        ]

        if (temp3 >= 297)
        [
          ask checks_xes
          [
            set shape "x"
          ]
        ]

        set temp3 temp3 + 1
      ]

      [
        ifelse (temp3 / 100 <= 4)
        [
          ask light 2
          [
            set color lime
          ]

          ask light 6
          [
            set color lime
          ]

          ask light 10
          [
            set color lime
          ]

          ask light 14
          [
            set color lime
          ]

          if (temp3 >= 397)
          [
            ask lights
            [
              set color red
            ]
          ]

          set temp3 temp3 + 1
        ]

        [
           ifelse (temp3 / 100 <= 5)
           [
             ask light 3
             [
               set color lime
             ]

             ask light 7
             [
               set color lime
             ]

             ask light 11
             [
               set color lime
             ]

             ask light 15
             [
               set color lime
             ]

             if (temp3 >= 497)
             [
               ask lights
               [
                 set color red
               ]
             ]

             set temp3 temp3 + 1
           ]

           [
             ifelse (temp3 / 100 <= 6)
             [
               ask checks_xes
               [
                 set shape "check"
               ]

               if (temp3 >= 597)
               [
                 ask checks_xes
                 [
                   set shape "x"
                 ]
               ]

               set temp3 temp3 + 1
             ]

             [
               set temp3 1
             ]
           ]
        ]
      ]
    ]
  ]

end

to-report signal [special car_who]

  let rand array:from-list [3 1 0 2]

  if (special = 1)
  [
    ask light array:item rand 0
    [
      if (color = red)
      [
        set special 0
      ]
    ]
  ]

  if (special = 2)
  [
    ask light array:item rand 1
    [
      if (color = red)
      [
        set special 0
      ]
    ]
  ]

  if (special = 3)
  [
    ask light array:item rand 2
    [
      if (color = red)
      [
        set special 0
      ]
    ]
  ]

  if (special = 4)
  [
    ask light array:item rand 3
    [
      if (color = red)
      [
        set special 0
      ]
    ]
  ]

  ifelse (special = 0)
  [
    ask car car_who
    [
      ifelse (car_exception = 0)
      [
        if (corruption = 25)
        [
          ifelse (random 4 = 0)
          [
            set special -1
            set car_exception 1
          ]

          [
            set car_exception 2
          ]
        ]

        if (corruption = 50)
        [
          ifelse (random 4 = 0 or random 4 = 1)
          [
            set special -1
            set car_exception 1
          ]

          [
            set car_exception 2
          ]
        ]

        if (corruption = 75)
        [
          ifelse (random 4 = 0 or random 4 = 1 or random 4 = 2)
          [
            set special -1
            set car_exception 1
          ]

          [
            set car_exception 2
          ]
        ]
      ]

      [
        if (car_exception = 1)
        [
          set special -1
        ]
      ]
    ]

    if (special = -1)
    [
      ask car car_who
      [
        if (car_exception3 = 0)
        [
          set car_violation car_violation + 1
          set car_exception3 1
        ]
      ]

      report true
    ]

    ask car car_who
    [
      if (car_exception2 = 0)
      [
        set car_follow car_follow + 1
        set car_exception2 1
      ]
    ]

    report false
  ]

  [
    ask car car_who
    [
      if (car_exception2 = 0)
      [
        set car_follow car_follow + 1
        set car_exception2 1
      ]
    ]

    report true
  ]

end

to-report patience [counter2]

  ask car counter2
  [
    ifelse any? cars-on patch-ahead 2.5
    [
      set counter2 0
    ]

    [
      set counter2 1
    ]
  ]

  if (counter2 = 0)
  [
    report true
  ]

  if (counter2 = 1)
  [
    report false
  ]

end

to construct-houses

  set counter (count lights + count zebras + count lines + count pedestrians + count cars)

  let category1 array:from-list ["house part 1" "house"]
  let category2 array:from-list ["house efficiency part 1" "house efficiency part 2" "house efficiency"]
  let category3 array:from-list ["house bungalow part 1" "house bungalow part 2" "house bungalow part 3" "house bungalow"]
  let category4 array:from-list ["house ranch part 1" "house ranch part 2" "house ranch"]
  let category5 array:from-list ["house colonial part 1" "house colonial part 2" "house colonial"]
  let category6 array:from-list ["house two story part 1" "house two story part 2" "house two story part 3" "house two story part 4" "house two story"]

   while [counter <= (count lights + count zebras + count lines + count pedestrians + count cars + temp4)]
   [
      ask house counter
      [
        if (category = 1 and temporary <= 1)
        [
          set shape array:item category1 temporary
          set temp5 temp5 + 1

          if (temporary = 1)
          [
            set no-of-houses no-of-houses + 1
          ]
        ]

        if (category = 2 and temporary <= 2)
        [
          set shape array:item category2 temporary
          set temp5 temp5 + 1

          if (temporary = 2)
          [
            set no-of-houses no-of-houses + 1
          ]
        ]

        if (category = 3 and temporary <= 3)
        [
          set shape array:item category3 temporary
          set temp5 temp5 + 1

          if (temporary = 3)
          [
            set no-of-houses no-of-houses + 1
          ]
        ]

        if (category = 4 and temporary <= 2)
        [
          set shape array:item category4 temporary
          set temp5 temp5 + 1

          if (temporary = 2)
          [
            set no-of-houses no-of-houses + 1
          ]
        ]

        if (category = 5 and temporary <= 2)
        [
          set shape array:item category5 temporary
          set temp5 temp5 + 1

          if (temporary = 2)
          [
            set no-of-houses no-of-houses + 1
          ]
        ]

        if (category = 6 and temporary <= 4)
        [
          set shape array:item category6 temporary
          set temp5 temp5 + 1

          if (temporary = 4)
          [
            set no-of-houses no-of-houses + 1
          ]
        ]

        set hidden? false
        set temporary temporary + 1
     ]

     set counter counter + 1
   ]

   if (temp4 < count houses - 1)
   [
      set temp4 temp4 + 1
   ]

end

to finished-house-construction

  set counter (count lights + count zebras + count lines + count pedestrians + count cars)
  set temp6 0

   while [counter < (count lights + count zebras + count lines + count pedestrians + count cars + temp4)]
   [
      ask house counter
      [
        if (category = 1)
        [
          set temp6 temp6 + 2
        ]

        if (category = 2)
        [
          set temp6 temp6 + 3
        ]

        if (category = 3)
        [
          set temp6 temp6 + 4
        ]

        if (category = 4)
        [
          set temp6 temp6 + 3
        ]

        if (category = 5)
        [
          set temp6 temp6 + 3
        ]

        if (category = 6)
        [
          set temp6 temp6 + 5
        ]
     ]

     set counter counter + 1
   ]

end

to setup-industries

  let No_of_Industries 1
  set counter  1

  if (corruption = 0)
  [
    set No_of_Industries 24
  ]

  if (corruption = 25)
  [
    while [counter <= 24]
    [
      if (random 4 = 0 or random 4 = 1 or random 4 = 2)
      [
        set No_of_Industries No_of_Industries + 1
      ]

      set counter counter + 1
    ]
  ]

  if (corruption = 50)
  [
    while [counter <= 24]
    [
      if (random 4 = 0 or random 4 = 1)
      [
        set No_of_Industries No_of_Industries + 1
      ]

      set counter counter + 1
    ]
  ]

  if (corruption = 75)
  [
    while [counter <= 24]
    [
      if (random 4 = 0)
      [
        set No_of_Industries No_of_Industries + 1
      ]

      set counter counter + 1
    ]
  ]

  create-industries No_of_Industries
  [
    set hidden? true
    set size 7
    set color one-of [red orange brown yellow lime turquoise cyan sky blue violet magenta pink]
  ]

  industrying-scheme

  if (show_progress = "none" or show_progress = "only houses" or show_progress = "road network")
  [
    set no-of-industries count industries

    ask industries
    [
      set hidden? false
      set temporary 3
      set shape "factory part 3"
    ]
  ]

end

to industrying-scheme

  let x_pos array:from-list [35.5 43 50.5]
  let y_pos array:from-list [28 22 9 3 -3 -9 -21 -27]
  let X_positions array:from-list n-values 24 [0]
  let Y_positions array:from-list n-values 24 [0]
  let Checker array:from-list n-values 24 [-1]

  set temp 0
  set temp2 0
  set counter 0

  while [temp < 3]
  [
    set temp2 0

    while [temp2 < 8]
    [
      array:set X_positions counter array:item x_pos temp
      array:set Y_positions counter array:item y_pos temp2
      set temp2 temp2 + 1
      set counter counter + 1
    ]

    set temp temp + 1
  ]

  set counter (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes)
  set temp 0

  let values 24

  while [counter < (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes + count industries)]
  [
    let checker_counter1 (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes)
    let checker_counter2 0
    let checker_counter3 counter

    set temp random values

    if (temp = (values - 1))
    [
      set values values - 1
    ]

    while [checker_counter1 <= checker_counter3]
    [
       ifelse ((array:item Checker checker_counter2) != temp)
       [
         if ((array:item Checker checker_counter2) = -1)
         [
           array:set Checker checker_counter2 temp

           ask industry counter
           [
             setxy array:item X_positions temp array:item Y_positions temp
             set counter counter + 1
           ]
         ]

         set checker_counter1 checker_counter1 + 1
         set checker_counter2 checker_counter2 + 1
       ]

       [
         set checker_counter1 checker_counter3 + 1
       ]
    ]
  ]

end

to construct-industries

  let industryBuilding array:from-list ["factory part 1" "factory part 2" "factory part 3"]

  set counter (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes)

  while [counter <= (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes + temp7)]
  [
    ask industry counter
    [
       if (temporary <= 2)
       [
         set shape array:item industryBuilding temporary
         set temp8 temp8 + 1

         if (temporary = 2)
         [
           set no-of-industries no-of-industries + 1
         ]
       ]

       set hidden? false
       set temporary temporary + 1
    ]

    set counter counter + 1
  ]

  if (temp7 < count industries - 1)
  [
    set temp7 temp7 + 1
  ]

end

to working-industries

  let workingBuilding array:from-list ["factory smoke 0" "factory smoke 1" "factory smoke 2" "factory smoke 3" "factory smoke 4"]

  set counter (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes)

  while [counter < (count lights + count zebras + count lines + count pedestrians + count cars + count houses + count checks_xes + count industries)]
  [
    ask industry counter
    [
       if (temporary >= 3 and temporary <= 7)
       [
         set shape array:item workingBuilding (temporary - 3)
         set temporary temporary + 1
       ]

       if (temporary > 7)
       [
         set temporary 3
       ]
    ]

    set counter counter + 1
  ]

end

to setup-positions

  set xpos array:from-list n-values 111 [-100]
  set ypos array:from-list n-values 63  [-100]
  let xpositions -55
  let ypositions -31
  let xindex 0
  let yindex 0

  while [xpositions <= 55]
  [
    array:set xpos xindex xpositions
    set xindex xindex + 1
    set xpositions xpositions + 1
  ]

  while [ypositions <= 31]
  [
    array:set ypos yindex ypositions
    set yindex yindex + 1
    set ypositions ypositions + 1
  ]

end

to building-roads-pavements

  if (rprog < 111)
  [
    ask patches with [(pycor = 15 or pycor = 16 or pycor = 14) and pxcor = array:item xpos rprog ]
    [
      set pcolor grey + 1
    ]

    ask patches with [(pycor = -15 or pycor = -16 or pycor = -14) and pxcor = array:item xpos rprog ]
    [
      set pcolor grey + 1
    ]
  ]

  if (rprog > 55 and rprog < 167)
  [
    ask patches with [(pycor = 13 or pycor = 17 or pycor = -13 or pycor = -17) and pxcor = array:item xpos (rprog - 56) ]
    [
      if ((pxcor <= 26 or pxcor >= 30) and (pxcor <= -30 or pxcor >= -26))
      [
        set pcolor grey - 1
      ]
    ]
  ]

  if (rprog < 63)
  [
    ask patches with [(pxcor = 27 or pxcor = 28 or pxcor = 29) and pycor = array:item ypos rprog ]
    [
      set pcolor grey + 1
    ]

    ask patches with [(pxcor = -27 or pxcor = -28 or pxcor = -29) and pycor = array:item ypos rprog ]
    [
      set pcolor grey + 1
    ]
  ]

  if (rprog > 31 and rprog < 95)
  [
    ask patches with [(pxcor = 26 or pxcor = 30 or pxcor = -26 or pxcor = -30) and pycor = array:item ypos (rprog - 32)]
    [
      if ((pycor <= 13 or pycor >= 17) and (pycor <= -17 or pycor >= -13))
      [
        set pcolor grey - 1
      ]
    ]
  ]

  set rprog rprog + 1

end

to setting-up-zebras-lights-lines

  if (zllprog >= 0 and zllprog < count lights)
  [
    ask light zllprog
    [
      set hidden? false
    ]
  ]

  if ((zllprog >= count lights) and (zllprog < count lights + count zebras))
  [
    ask zebra zllprog
    [
      set hidden? false
    ]
  ]

  if ((zllprog >= (count lights + count zebras)) and (zllprog < count lights + count zebras + count lines))
  [
    ask line zllprog
    [
      set hidden? false
    ]
  ]

  if ((zllprog >= count lights + count zebras + count lines) and (zllprog < count lights + count zebras + count lines + count checks_xes))
  [
    ask check_x (zllprog + count cars + count pedestrians + count houses)
    [
      set hidden? false
    ]
  ]

  set zllprog zllprog + 1

end

to-report cars-pedestrians-patience [car_who]

  let tempp 0
  ask car car_who
  [
    if any? pedestrians-on neighbors4;patch-ahead 2
    [
      ask pedestrians-on neighbors4
      [
        if ((ycor = 14 or ycor = -12 or ycor = 18 or ycor = -16) and ((xcor < 30 and xcor > 26) or (xcor > -30 and xcor < -26)))
        [
          set tempp 1
        ]

        if ((xcor = 26 or xcor = -26 or xcor = 30 or xcor = -30) and ((ycor < 18 and ycor > 14) or (ycor > -16 and ycor < -12)))
        [
          set tempp 1
        ]
      ]
    ]
  ]

  ifelse (tempp = 1)
  [
    report true
  ]

  [
    report false
  ]

end
@#$#@#$#@
GRAPHICS-WINDOW
443
10
1494
611
-1
-1
9.4
1
10
1
1
1
0
1
1
1
-55
55
-31
31
1
1
1
ticks
30.0

BUTTON
35
21
98
54
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
125
22
188
55
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
17
72
131
105
NIL
go-pedestrians
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
146
73
219
106
NIL
go-cars
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

CHOOSER
26
119
195
164
show_progress
show_progress
"none" "only houses" "only industries" "houses and industries" "road network" "all"
0

SLIDER
246
26
418
59
corruption
corruption
0
75
75.0
25
1
NIL
HORIZONTAL

SLIDER
247
68
419
101
no_of_pedestrians
no_of_pedestrians
4
30
26.0
1
1
NIL
HORIZONTAL

SLIDER
247
113
419
146
no_of_cars
no_of_cars
4
30
10.0
1
1
NIL
HORIZONTAL

MONITOR
57
435
145
480
NIL
no-of-houses
17
1
11

MONITOR
280
439
381
484
NIL
no-of-industries
17
1
11

MONITOR
21
215
104
260
NIL
car_violation
17
1
11

MONITOR
117
214
187
259
NIL
car_follow
17
1
11

MONITOR
269
212
394
257
NIL
pedestrian_violation
17
1
11

MONITOR
276
162
387
207
NIL
pedestrian_follow
17
1
11

PLOT
17
265
198
390
% of cars violating rules
time
% of cars violating rules
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (car_violation * 100) / car_follow"

PLOT
237
264
422
389
% of pedestrians violating rules
time
pedestrian violation of rules in %
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (pedestrian_violation * 100) / pedestrian_follow"

PLOT
13
492
194
622
% of houses being built
time
% houses
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (no-of-houses * 100) / 132"

PLOT
237
493
419
623
% of industries being built
time
% of industries
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot (no-of-industries * 100) / 24"

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

building institution
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

car top
true
0
Polygon -7500403 true true 151 8 119 10 98 25 86 48 82 225 90 270 105 289 150 294 195 291 210 270 219 225 214 47 201 24 181 11
Polygon -16777216 true false 210 195 195 210 195 135 210 105
Polygon -16777216 true false 105 255 120 270 180 270 195 255 195 225 105 225
Polygon -16777216 true false 90 195 105 210 105 135 90 105
Polygon -1 true false 205 29 180 30 181 11
Line -7500403 false 210 165 195 165
Line -7500403 false 90 165 105 165
Polygon -16777216 true false 121 135 180 134 204 97 182 89 153 85 120 89 98 97
Line -16777216 false 210 90 195 30
Line -16777216 false 90 90 105 30
Polygon -1 true false 95 29 120 30 119 11

check
false
0
Polygon -7500403 true true 55 138 22 155 53 196 72 232 91 288 111 272 136 258 147 220 167 174 208 113 280 24 257 7 192 78 151 138 106 213 87 182

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

factory part 1
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225

factory part 2
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Rectangle -7500403 true true 14 228 78 270

factory part 3
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Rectangle -7500403 true true 14 228 78 270

factory smoke 0
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Rectangle -7500403 true true 14 228 78 270

factory smoke 1
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Rectangle -7500403 true true 14 228 78 270

factory smoke 2
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Rectangle -7500403 true true 14 228 78 270

factory smoke 3
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Rectangle -7500403 true true 14 228 78 270

factory smoke 4
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

flower budding
false
0
Polygon -7500403 true true 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Polygon -7500403 true true 189 233 219 188 249 173 279 188 234 218
Polygon -7500403 true true 180 255 150 210 105 210 75 240 135 240
Polygon -7500403 true true 180 150 180 120 165 97 135 84 128 121 147 148 165 165
Polygon -7500403 true true 170 155 131 163 175 167 196 136

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

house bungalow
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 150 75 150 150 75
Line -16777216 false 75 150 225 150
Line -16777216 false 195 120 225 150
Polygon -16777216 false false 165 195 150 195 180 165 210 195
Rectangle -16777216 true false 135 105 165 135

house bungalow part 1
false
0
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240

house bungalow part 2
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240

house bungalow part 3
false
0
Rectangle -7500403 true true 210 75 225 255
Rectangle -7500403 true true 90 135 210 255
Rectangle -16777216 true false 165 195 195 255
Line -16777216 false 210 135 210 255
Rectangle -16777216 true false 105 202 135 240
Polygon -16777216 false false 165 195 150 195 180 165 210 195

house colonial
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Polygon -7500403 true true 30 135 285 135 240 90 75 90
Line -16777216 false 30 135 285 135
Line -16777216 false 255 105 285 135
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house colonial part 1
false
0
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house colonial part 2
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 45 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 60 195 105 240
Rectangle -16777216 true false 60 150 105 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Line -7500403 true 154 195 154 255
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 135 150 180 180

house efficiency
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Polygon -7500403 true true 225 165 75 165 150 90
Line -16777216 false 75 165 225 165

house efficiency part 1
false
0
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240

house efficiency part 2
false
0
Rectangle -7500403 true true 180 90 195 195
Rectangle -7500403 true true 90 165 210 255
Rectangle -16777216 true false 165 195 195 255
Rectangle -16777216 true false 105 202 135 240
Line -16777216 false 90 165 210 165

house part 1
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285

house ranch
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Polygon -7500403 true true 0 180 300 180 240 135 60 135 0 180
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255
Line -16777216 false 0 180 300 180

house ranch part 1
false
0
Rectangle -7500403 true true 15 180 270 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255

house ranch part 2
false
0
Rectangle -7500403 true true 270 120 285 255
Rectangle -7500403 true true 15 180 270 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 45 195 105 240
Rectangle -16777216 true false 195 195 255 240
Line -7500403 true 75 195 75 240
Line -7500403 true 225 195 225 240
Line -16777216 false 270 180 270 255

house two story
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Polygon -7500403 true true 60 135 285 135 240 90 105 90
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 60 135 285 135
Line -16777216 false 255 105 285 135
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

house two story part 1
false
0
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Line -7500403 true 154 195 154 255

house two story part 2
false
0
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Rectangle -16777216 true false 30 195 93 240
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

house two story part 3
false
0
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

house two story part 4
false
0
Polygon -7500403 true true 2 180 227 180 152 150 32 150
Rectangle -7500403 true true 270 75 285 255
Rectangle -7500403 true true 75 135 270 255
Rectangle -16777216 true false 124 195 187 256
Rectangle -16777216 true false 210 195 255 240
Rectangle -16777216 true false 90 150 135 180
Rectangle -16777216 true false 210 150 255 180
Line -16777216 false 270 135 270 255
Rectangle -7500403 true true 15 180 75 255
Line -16777216 false 75 135 75 180
Rectangle -16777216 true false 30 195 93 240
Line -16777216 false 0 180 75 180
Line -7500403 true 60 195 60 240
Line -7500403 true 154 195 154 255

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

petals
false
0
Circle -7500403 true true 117 12 66
Circle -7500403 true true 116 221 67
Circle -7500403 true true 41 41 67
Circle -7500403 true true 11 116 67
Circle -7500403 true true 41 191 67
Circle -7500403 true true 191 191 67
Circle -7500403 true true 221 116 67
Circle -7500403 true true 191 41 67
Circle -7500403 true true 60 60 180

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

plant medium
false
0
Rectangle -7500403 true true 135 165 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 165 120 120 150 90 180 120 165 165

plant small
false
0
Rectangle -7500403 true true 135 240 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 240 120 195 150 165 180 195 165 240

rectangle
true
0
Rectangle -7500403 true true 120 90 180 210

road line
true
0
Rectangle -7500403 true true 0 135 300 165

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

traffic light green
true
0
Rectangle -7500403 true true 150 15 165 300
Rectangle -7500403 true true 120 15 195 165
Circle -13840069 false false 120 90 58
Circle -2674135 false false 120 30 58
Circle -13840069 true false 120 90 58

traffic light red
true
0
Rectangle -7500403 true true 150 15 165 300
Rectangle -7500403 true true 120 15 195 165
Circle -13840069 false false 120 90 58
Circle -2674135 false false 120 30 58
Circle -2674135 true false 120 30 58

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

tree pine
false
0
Rectangle -6459832 true false 120 225 180 300
Polygon -7500403 true true 150 240 240 270 150 135 60 270
Polygon -7500403 true true 150 75 75 210 150 195 225 210
Polygon -7500403 true true 150 7 90 157 150 142 210 157 150 7

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

zebra crossing
true
0
Rectangle -1 true false 90 270 195 300
Rectangle -16777216 true false 90 0 195 30
Rectangle -1 true false 90 30 195 60
Rectangle -16777216 true false 90 60 195 90
Rectangle -1 true false 90 90 195 120
Rectangle -16777216 true false 90 120 195 150
Rectangle -1 true false 90 150 195 180
Rectangle -16777216 true false 90 180 195 210
Rectangle -1 true false 90 210 195 240
Rectangle -16777216 true false 90 240 195 270

zebra crossing2
true
0
Rectangle -1 true false 90 270 195 300
Rectangle -1 true false 90 30 195 60
Rectangle -1 true false 90 90 195 120
Rectangle -1 true false 90 150 195 180
Rectangle -1 true false 90 210 195 240

zebra crossing3
true
0
Rectangle -16777216 true false 90 0 195 30
Rectangle -16777216 true false 90 60 195 90
Rectangle -16777216 true false 90 120 195 150
Rectangle -16777216 true false 90 180 195 210
Rectangle -16777216 true false 90 240 195 270
@#$#@#$#@
NetLogo 6.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2800"/>
    <metric>((car_violation * 100) / car_follow)</metric>
    <metric>((pedestrian_violation * 100) / pedestrian_follow)</metric>
    <metric>((no-of-houses * 100) / 132)</metric>
    <metric>((no-of-industries * 100) / 24)</metric>
    <enumeratedValueSet variable="no_of_cars">
      <value value="10"/>
    </enumeratedValueSet>
    <steppedValueSet variable="corruption" first="0" step="25" last="75"/>
    <enumeratedValueSet variable="show_progress">
      <value value="&quot;houses and industries&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_of_pedestrians">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2800"/>
    <metric>((car_violation * 100) / car_follow)</metric>
    <metric>((pedestrian_violation * 100) / pedestrian_follow)</metric>
    <metric>((no-of-houses * 100) / 132)</metric>
    <metric>((no-of-industries * 100) / 24)</metric>
    <enumeratedValueSet variable="no_of_cars">
      <value value="20"/>
    </enumeratedValueSet>
    <steppedValueSet variable="corruption" first="0" step="25" last="75"/>
    <enumeratedValueSet variable="show_progress">
      <value value="&quot;houses and industries&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_of_pedestrians">
      <value value="20"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="2800"/>
    <metric>((car_violation * 100) / car_follow)</metric>
    <metric>((pedestrian_violation * 100) / pedestrian_follow)</metric>
    <metric>((no-of-houses * 100) / 132)</metric>
    <metric>((no-of-industries * 100) / 24)</metric>
    <enumeratedValueSet variable="no_of_cars">
      <value value="30"/>
    </enumeratedValueSet>
    <steppedValueSet variable="corruption" first="0" step="25" last="75"/>
    <enumeratedValueSet variable="show_progress">
      <value value="&quot;houses and industries&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="no_of_pedestrians">
      <value value="30"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
