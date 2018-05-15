breed [lights light]
breed [zebras zebra]
breed [lines line]
breed [persons person]
breed [pedestrians pedestrian]
breed [cars car]
breed [houses house]
breed [factories factory]
breed [schools school]
extensions [array]
cars-own [speed]
houses-own
[
  category
  temporary
]

globals
[
  counter
  temp
  temp2
  temp3
  temp4
  temp5
  temp6
  x_count
  y_count
  RLstart
]

to setup

  clear-all
  setup-patches          ;; Creating Patches
  setup-traffic_lights
  setup-zebra_crossing
  setup-roadlines
  setup-pedestrians      ;; Creating Pedestrians
  setup-cars
  setup-houses
  ;;setup-persons        ;; Creating Persons
  reset-ticks

end

to go

  move-pedestrians    ;; Make the Pedestrian Move on the pavement
  move-cars
  blink-traffic_lights

  if (temp4 = count houses)
  [
    finished-house-construction

    if (temp5 = temp6)
    [
      set temp4 -1
    ]
  ]

  if (ticks mod 20 = 0 and temp5 != temp6)
  [
    construct-houses
  ]

  construct-factories
  construct-schools
  tick

end

to setup-patches

  if (corruption = 0)
  [
    ask patches [set pcolor green - random-float 0.5]    ;; Creating Grass with different shades of green

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

to setup-persons

  create-persons 50
  ask persons
  [
  ;;  setxy random-xcor random-ycor
    set shape "person"    ;; Setting shape of turtles to person
    set size 1.7
  ]

end

to setup-traffic_lights

  create-lights 16

  ask lights
  [
    set color red
    set shape "rectangle"
    set size 4
  ]

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

  create-zebras 16

  ask zebras
  [
    set shape "zebra crossing"
    set size 3
  ]

  ask zebra count lights [ setxy -30 15   set heading 0  ]

  ask zebra (count lights + 1) [ setxy -28 17   set heading 90 ]

  ask zebra (count lights + 2) [ setxy -25.9 15   set heading 0  ]

  ask zebra (count lights + 3) [ setxy -28 12.9   set heading 90 ]

  ask zebra (count lights + 4) [ setxy 26 15    set heading 0  ]

  ask zebra (count lights + 5) [ setxy 28 17    set heading 90 ]

  ask zebra (count lights + 6) [ setxy 30.1 15    set heading 0  ]

  ask zebra (count lights + 7) [ setxy 28 12.9    set heading 90 ]

  ask zebra (count lights + 8) [ setxy -30 -15  set heading 0  ]

  ask zebra (count lights + 9) [ setxy -28 -13  set heading 90 ]

  ask zebra (count lights + 10) [ setxy -25.9 -15  set heading 0  ]

  ask zebra (count lights + 11) [ setxy -28 -17.1  set heading 90 ]

  ask zebra (count lights + 12) [ setxy 26 -15   set heading 0  ]

  ask zebra (count lights + 13) [ setxy 28 -13   set heading 90 ]

  ask zebra (count lights + 14) [ setxy 30.1 -15   set heading 0  ]

  ask zebra (count lights + 15) [ setxy 28 -17.1   set heading 90 ]

end

to setup-roadlines

  create-lines 174

  ask lines
  [
    set shape "road line"
    set color white
  ]

    set x_count -55
    set y_count 30
    set counter (count lights + count zebras)
    set RLstart (count lights + count zebras)

    loop
    [
        ifelse (counter <= RLstart + 55)
        [
          ask line counter
          [
            setxy x_count 15
            set x_count x_count + 2
            set heading 0
          ]
        ]

        [
          ifelse (counter <= RLstart + 55 + 56)
          [
            ask line counter
            [
              set x_count x_count - 2
              setxy x_count -15
              set heading 0
            ]
          ]

          [
            ifelse (counter <= RLstart + 55 + 56 + 31)
            [
              ask line counter
              [
                setxy -28 y_count
                set y_count y_count - 2
                set heading 90
              ]
            ]

            [
              ifelse (counter <= RLstart + 55 + 56 + 31 + 31)
              [
                ask line counter
                [
                  set y_count y_count + 2
                  setxy 28 y_count
                  set heading 90
                ]
              ]

              [
                stop
              ]
            ]
          ]
        ]

      set counter counter + 1
    ]

end

to setup-pedestrians

   create-pedestrians No_of_Pedestrians    ;; Creating Pedestrians

    let x array:from-list [26 -26 30 -30]    ;; Array of specific x axis
    let y array:from-list [14 -12 18 -16]    ;; Array of specific y axis

    set x array:from-list [26 -26 30 -30]

     set counter (count lights + count zebras + count lines)      ;; Making counter to identify pedestrians (using counter as who number)

  ask pedestrians
  [
    set shape "person"
    set size 2
    set color brown + 1
  ]

   loop
   [
      ifelse (counter < (count lights + count zebras + count lines + No_of_Pedestrians))    ;; Only dealing with pedestrians
      [
        ask pedestrian counter
        [
          ifelse (random 2 = 0)
          [
            setxy array:item x random 4 random-ycor   ;; setting value of x and y cordinate for specific pedestrians
            facexy xcor random-ycor          ;; making pedestrians to face specific location for directed movement
            set ycor precision ycor 1

            loop
            [
              ifelse ((ycor <= 20 and ycor >= 10) or (ycor <= -10 and ycor >= -20))
              [
                setxy xcor random-ycor
              ]

              [
                stop
              ]
            ]
          ]

          [
            setxy random-xcor array:item y random 4
            facexy random-xcor ycor
            set xcor precision xcor 1

            loop
            [
              ifelse ((xcor <= 33 and xcor >= 23) or (xcor <= -23 and xcor >= -33))
              [
                setxy random-xcor ycor
              ]

              [
                stop
              ]
            ]
          ]
        ]
      ]

      [
        stop
      ]

      set counter counter + 1
   ]

end

to setup-cars

  create-cars No_of_Cars

    let x1 array:from-list [-28.8 27.3]    ;; Array of specific x axis
    let x2 array:from-list [-27.3 28.8]    ;; Array of specific x axis
    let y1 array:from-list [-14.3 15.8]    ;; Array of specific y axis
    let y2 array:from-list [-15.8 14.3]    ;; Array of specific y axis

     set counter (count lights + count zebras + count lines + count pedestrians)

 ask cars
  [
    set shape "car top"
    set size 2.6
    set color blue
    setxy random-xcor random-ycor
    set heading 0
    set speed (random-float 0.5) + 0.1
  ]

   loop
   [
      ifelse (counter < (count lights + count zebras + count pedestrians + count lines + No_of_Cars))
      [
        ask car counter
        [
          ifelse (random 2 = 0)
          [
              ifelse (random 2 = 0)
              [
                 setxy array:item x1 random 2 random-ycor
                 set heading 0
                 set ycor precision ycor 1

                 loop
                 [
                   ifelse ((ycor <= 25 and ycor >= 5) or (ycor >= -25 and ycor <= -5))
                   [
                     setxy xcor random-ycor
                   ]

                   [
                     stop
                   ]
                 ]
              ]

              [
                 setxy array:item x2 random 2 random-ycor
                 set heading 180
                 set ycor precision ycor 1

                 loop
                 [
                   ifelse ((ycor <= 25 and ycor >= 5) or (ycor >= -25 and ycor <= -5))
                   [
                     setxy xcor random-ycor
                   ]

                   [
                     stop
                   ]
                 ]
              ]
          ]

          [
             ifelse (random 2 = 0)
             [
                setxy random-xcor array:item y1 random 2
                set heading 90
                set xcor precision xcor 1

                loop
                 [
                   ifelse ((xcor <= 38 and xcor >= 18) or (xcor >= -38 and xcor <= -18))
                   [
                     setxy random-xcor ycor
                   ]

                   [
                     stop
                   ]
                ]
             ]


             [
                setxy random-xcor array:item y2 random 2
                set heading 270
                set xcor precision xcor 1

                loop
                 [
                   ifelse ((xcor <= 38 and xcor >= 18) or (xcor >= -38 and xcor <= -18))
                   [
                     setxy random-xcor ycor
                   ]

                   [
                     stop
                   ]
                 ]
             ]
          ]
        ]
      ]

      [
        stop
      ]

      set counter counter + 1
   ]

end

to setup-houses

  create-houses 132
  [
    set size 5
    set hidden? true
    set color one-of [red orange brown yellow lime turquoise cyan sky blue violet magenta pink]

    if (corruption = 0)
    [
      set category one-of [3 4 5 6]
    ]
  ]

  housing-scheme
  set temp6 -1

end

to housing-scheme

  let x_pos array:from-list [21 15 9 3 -3 -9 -15 -21 -34 -40 -46 -52]
  let y_pos array:from-list [30 25 20 10 5 0 -5 -10 -19 -24 -29]
  let X_positions array:from-list n-values 132[0]
  let Y_positions array:from-list n-values 132[0]
  let Checker array:from-list n-values 132[-1]

  set temp 0
  set temp2 0
  set counter 0

  while [temp < 12]
  [
    set temp2 0

    while [temp2 < 11]
    [
;     array:set positions counter (word array:item x_pos temp array:item y_pos temp2)
      array:set X_positions counter array:item x_pos temp
      array:set Y_positions counter array:item y_pos temp2
      set counter counter + 1
      set temp2 temp2 + 1
    ]

    set temp temp + 1
  ]

  set counter (count lights + count zebras + count lines + count pedestrians + count cars)
  set temp 0
  let values count houses

  while [counter < (count lights + count zebras + count lines + count pedestrians + count cars + count houses)]
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

to move-pedestrians

  ask pedestrians
  [
     forward 0.1  ;; move in steps not pixels not patches
  ]

  set counter (count lights + count zebras + count lines)

  let xran array:from-list [90 180 -90 -180]

  loop
  [
    ifelse (counter < (count lights + count zebras + count lines + count pedestrians))
    [
      ask pedestrian counter
      [
        set xcor precision xcor 1
        set ycor precision ycor 1

        if
        (
              (xcor = -30.0 and ycor = 18.0 ) or (xcor = -26.0 and ycor =  18.0) or (xcor = -30.0 and ycor =  14.0) or (xcor = -26.0 and ycor =  14.0)
           or (xcor = -30.0 and ycor = -12.0) or (xcor = -26.0 and ycor = -12.0) or (xcor = -30.0 and ycor = -16.0) or (xcor = -26.0 and ycor = -16.0)
           or (xcor =  26.0 and ycor =  18.0) or (xcor =  30.0 and ycor =  18.0) or (xcor =  26.0 and ycor =  14.0) or (xcor =  30.0 and ycor =  14.0)
           or (xcor =  26.0 and ycor = -12.0) or (xcor =  30.0 and ycor = -12.0) or (xcor =  26.0 and ycor = -16.0) or (xcor =  30.0 and ycor = -16.0)

        )

        [
          set heading array:item xran random 4
        ]

      ]
    ]

    [
      stop
    ]

    set counter counter + 1
  ]

end

to move-cars

  set counter (count lights + count zebras + count lines + count pedestrians)

  loop
  [
    ifelse (counter < (count lights + count zebras + count lines + count pedestrians + count cars))
    [
      ask car counter
      [
        ifelse (heading = 0 and (int ycor = 10 or int ycor = -19))
        [
          ifelse (signal 1)
          [
            forward speed
          ]

          [
            forward 0
            set speed (random-float 0.5) + 0.1
          ]

          set temp2 1
        ]

        [
          ifelse (heading = 180 and (int ycor = -10 or int ycor = 19))
          [
            ifelse (signal 2)
            [
              forward speed
            ]

            [
              forward 0
              set speed (random-float 0.5) + 0.1
            ]

            set temp2 2
          ]

          [
            ifelse (heading = 90 and (int xcor = 23 or int xcor = -32))
            [
              ifelse (signal 3)
              [
                forward speed
              ]

              [
                forward 0
                set speed (random-float 0.5) + 0.1
              ]

              set temp2 3
            ]

            [
              ifelse (heading = 270 and (int xcor = 32 or int xcor = -23))
              [
                ifelse (signal 4)
                [
                  forward speed
                ]

                [
                  forward 0
                  set speed (random-float 0.5) + 0.1
                ]

                set temp2 4
              ]

              [
                ifelse (patience counter)
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
            ((heading =  0 or heading = 180) and (int ycor = -14 or int ycor = -15 or int ycor = 14 or int ycor = 15) and (temp2 = 1 or temp2 = 2)) or
            ((heading = 90 or heading = 270) and (int xcor = -28 or int xcor = -27 or int xcor = 28 or int xcor = 27) and (temp2 = 3 or temp2 = 4))
        )

        [
          turn-car (counter)
        ]
      ]
    ]

    [
        stop
    ]

    set counter counter + 1
  ]

end

to turn-car [carwho]

  let direction1 array:from-list [0 90 270]
  let direction2 array:from-list [0 90 180]
  let direction3 array:from-list [90 180 270]
  let direction4 array:from-list [0 180 270]

  ask car carwho
  [
    ifelse (heading = 0 and temp2 = 1)
    [
      set temp array:item direction1 random 3

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
      ifelse (heading = 90 and temp2 = 3)
      [
        set temp array:item direction2 random 3

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
        ifelse (heading = 180 and temp2 = 2)
        [
          set temp array:item direction3 random 3

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
          if (heading = 270 and temp2 = 4)
          [
            set temp array:item direction4 random 3

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

    set temp2 0
  ]

end

to blink-traffic_lights

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

        if (temp3 >= 297)
        [
          ask lights
          [
            set color red
          ]
        ]

        set temp3 temp3 + 1
      ]

      [
        ifelse (temp3 / 100 <= 4)
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
          set temp3 1
        ]
      ]
    ]
  ]

end

to-report signal [special]

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

    ifelse (special = 0)
    [
      report false
    ]

    [
      report true
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

    ifelse (special = 0)
    [
      report false
    ]

    [
      report true
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

    ifelse (special = 0)
    [
      report false
    ]

    [
      report true
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

    ifelse (special = 0)
    [
      report false
    ]

    [
      report true
    ]
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

  loop
  [
     ifelse (counter <= (count lights + count zebras + count lines + count pedestrians + count cars + temp4))
     [
        ask house counter
        [
          if (category = 1 and temporary <= 1)
          [
            set shape array:item category1 temporary
            set temp5 temp5 + 1
          ]

          if (category = 2 and temporary <= 2)
          [
            set shape array:item category2 temporary
            set temp5 temp5 + 1
          ]

          if (category = 3 and temporary <= 3)
          [
            set shape array:item category3 temporary
            set temp5 temp5 + 1
          ]

          if (category = 4 and temporary <= 2)
          [
            set shape array:item category4 temporary
            set temp5 temp5 + 1
          ]

          if (category = 5 and temporary <= 2)
          [
            set shape array:item category5 temporary
            set temp5 temp5 + 1
          ]

          if (category = 6 and temporary <= 4)
          [
            set shape array:item category6 temporary
            set temp5 temp5 + 1
          ]

          set hidden? false
          set temporary temporary + 1

       ]
     ]

     [
       if (temp4 < count houses - 1)
       [
          set temp4 temp4 + 1
       ]

       stop
     ]

     set counter counter + 1
  ]

end

to finished-house-construction

  set counter (count lights + count zebras + count lines + count pedestrians + count cars)
  set temp6 0

  loop
  [
     ifelse (counter < (count lights + count zebras + count lines + count pedestrians + count cars + temp4))
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
     ]

     [
       stop
     ]

     set counter counter + 1
  ]

end

to construct-factories

  let factoryBuilding ["factory part 1" "factory part 2" "factory part 3" "factory"]

end

to construct-schools



end
@#$#@#$#@
GRAPHICS-WINDOW
384
10
1461
626
-1
-1
9.635
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
55
104
118
137
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

SLIDER
67
164
239
197
corruption
corruption
0
5
0.0
1
1
NIL
HORIZONTAL

SLIDER
69
216
241
249
No_of_Cars
No_of_Cars
5
20
9.0
1
1
NIL
HORIZONTAL

SLIDER
67
270
239
303
No_of_Pedestrians
No_of_Pedestrians
5
20
20.0
1
1
NIL
HORIZONTAL

BUTTON
159
106
222
139
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

factory
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
@#$#@#$#@
NetLogo 6.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
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
