breed [persons person]
breed [pedestrians pedestrian]
breed [cars car]
breed [lights light]
breed [zebras zebra]
breed [lines line]
extensions [array]
globals
[
  counter
  temp
  temp2
  temp3
  x_count
  y_count
]

to setup
  clear-all
  setup-persons        ;; Creating Persons
  setup-pedestrians    ;; Creating Pedestrians
  setup-cars
  setup-traffic_lights
  setup-patches        ;; Creating Patches
  setup-zebra_crossing
  setup-roadlines
  reset-ticks
end

to go

  move-pedestrians    ;; Make the Pedestrian Move on the pavement
  move-cars
  blink-traffic_lights
  tick

end

to setup-patches

if (corruption = 0)
[
  ask patches [set pcolor green - random-float 0.5]    ;; Creating Grass with different shades of green

  ask patches with [pycor = 13] [set pcolor grey - 1]    ;; Creating Pavement
  ask patches with [pycor = 17] [set pcolor grey - 1]    ;; Creating Pavement
  ask patches with [pycor = -13] [set pcolor grey - 1]    ;; Creating Pavement
  ask patches with [pycor = -17] [set pcolor grey - 1]    ;; Creating Pavement

  ask patches with [pxcor = 26] [set pcolor grey - 1]    ;; Creating Pavement
  ask patches with [pxcor = 30] [set pcolor grey - 1]    ;; Creating Pavement
  ask patches with [pxcor = -26] [set pcolor grey - 1]    ;; Creating Pavement
  ask patches with [pxcor = -30] [set pcolor grey - 1]    ;; Creating Pavement

  ask patches with [pycor = 15] [set pcolor grey + 1]    ;; Creating Road
  ask patches with [pycor = 16] [set pcolor grey + 1]    ;; Creating Road
  ask patches with [pycor = 14] [set pcolor grey + 1]    ;; Creating Road

  ask patches with [pycor = -15] [set pcolor grey + 1]    ;; Creating Road
  ask patches with [pycor = -16] [set pcolor grey + 1]    ;; Creating Road
  ask patches with [pycor = -14] [set pcolor grey + 1]    ;; Creating Road

  ask patches with [pxcor = 27] [set pcolor grey + 1]    ;; Creating Road
  ask patches with [pxcor = 28] [set pcolor grey + 1]    ;; Creating Road
  ask patches with [pxcor = 29] [set pcolor grey + 1]    ;; Creating Road

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
  ;;ask patches with [pycor = 14 and pxcor = 31] [set pcolor red]
  create-lights 16

  ask lights
  [
    set color red
    set shape "rectangle"
    set size 4
  ]

  ask light 59 [ setxy -31 15.8   set heading 0  ]

  ask light 60 [ setxy -27.2 18   set heading 90 ]

  ask light 61 [ setxy -25 14.2   set heading 0  ]

  ask light 62 [ setxy -28.8 12   set heading 90 ]

  ask light 63 [ setxy 25 15.8    set heading 0  ]

  ask light 64 [ setxy 28.8 18    set heading 90 ]

  ask light 65 [ setxy 31 14.2    set heading 0  ]

  ask light 66 [ setxy 27.2 12    set heading 90 ]

  ask light 67 [ setxy -31 -14.2  set heading 0  ]

  ask light 68 [ setxy -27.2 -12  set heading 90 ]

  ask light 69 [ setxy -25 -15.8  set heading 0  ]

  ask light 70 [ setxy -28.8 -18  set heading 90 ]

  ask light 71 [ setxy 25 -14.2   set heading 0  ]

  ask light 72 [ setxy 28.8 -12   set heading 90 ]

  ask light 73 [ setxy 31 -15.8   set heading 0  ]

  ask light 74 [ setxy 27.2 -18   set heading 90 ]

end

to setup-pedestrians

   create-pedestrians 4    ;; Creating Pedestrians

    let x array:from-list [26 -26 30 -30]    ;; Array of specific x axis
    let y array:from-list [14 -12 18 -16]    ;; Array of specific y axis

    set x array:from-list [26 -26 30 -30]

     set counter 50      ;; Making counter to identify pedestrians (using counter as who number)

 ask pedestrians
  [
    set shape "person"
    set size 2
    set color white
  ]

   loop
   [
      ifelse counter >= 50 and counter < 54    ;; Only dealing with pedestrians
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

to move-pedestrians

 ask pedestrians
 [

    forward 0.1  ;; move in steps not pixels not patches
 ]

 set counter 50

 let xran array:from-list [90 180 -90 -180]

 loop
   [
      ifelse (counter >= 50 and counter < 54)
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

to setup-cars

  create-cars 5

    let x1 array:from-list [-28.8 27.3]    ;; Array of specific x axis
    let x2 array:from-list [-27.3 28.8]    ;; Array of specific x axis
    let y1 array:from-list [-14.3 15.8]    ;; Array of specific y axis
    let y2 array:from-list [-15.8 14.3]    ;; Array of specific y axis

     set counter 54

 ask cars
  [
    set shape "car top"
    set size 2.6
    set color blue
    setxy random-xcor random-ycor
    set heading 0
  ]

   loop
   [
      ifelse counter >= 54 and counter <= 58
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

to move-cars

  set counter 54

  loop
  [
    ifelse (counter >= 54 and counter <= 58)
    [
      ask car counter
      [
        ifelse (heading = 0 and (int ycor = 10 or int ycor = -19))
        [
          ifelse (signal 1)
          [
            forward 0.5
          ]

          [
            forward 0
          ]

          set temp2 1
        ]

        [
          ifelse (heading = 180 and (int ycor = -10 or int ycor = 19))
          [
            ifelse (signal 2)
            [
              forward 0.5
            ]

            [
              forward 0
            ]

            set temp2 2
          ]

          [
            ifelse (heading = 90 and (int xcor = 23 or int xcor = -32))
            [
              ifelse (signal 3)
              [
                forward 0.5
              ]

              [
                forward 0
              ]

              set temp2 3
            ]

            [
              ifelse (heading = 270 and (int xcor = 32 or int xcor = -23))
              [
                ifelse (signal 4)
                [
                  forward 0.5
                ]

                [
                  forward 0
                ]

                set temp2 4
              ]

              [
                ifELSE (patience counter)
                [
                  forward 0
                ]

                [
                  forward 0.5
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
    ask light 59
    [
      set color lime
    ]

    ask light 63
    [
      set color lime
    ]

    ask light 67
    [
      set color lime
    ]

    ask light 71
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
      ask light 60
      [
        set color lime
      ]

      ask light 64
      [
        set color lime
      ]

      ask light 68
      [
        set color lime
      ]

      ask light 72
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
        ask light 61
        [
          set color lime
        ]

        ask light 65
        [
          set color lime
        ]

        ask light 69
        [
          set color lime
        ]

        ask light 73
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
          ask light 62
          [
            set color lime
          ]

          ask light 66
          [
            set color lime
          ]

          ask light 70
          [
            set color lime
          ]

          ask light 74
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

to setup-zebra_crossing

  create-zebras 16

  ask zebras
  [
    set shape "zebra crossing"
    set size 3
  ]

  ask zebra 75 [ setxy -30 15   set heading 0  ]

  ask zebra 76 [ setxy -28 17   set heading 90 ]

  ask zebra 77 [ setxy -26 15   set heading 0  ]

  ask zebra 78 [ setxy -28 13   set heading 90 ]

  ask zebra 79 [ setxy 26 15    set heading 0  ]

  ask zebra 80 [ setxy 28 17    set heading 90 ]

  ask zebra 81 [ setxy 30 15    set heading 0  ]

  ask zebra 82 [ setxy 28 13    set heading 90 ]

  ask zebra 83 [ setxy -30 -15  set heading 0  ]

  ask zebra 84 [ setxy -28 -13  set heading 90 ]

  ask zebra 85 [ setxy -26 -15  set heading 0  ]

  ask zebra 86 [ setxy -28 -17  set heading 90 ]

  ask zebra 87 [ setxy 26 -15   set heading 0  ]

  ask zebra 88 [ setxy 28 -13   set heading 90 ]

  ask zebra 89 [ setxy 30 -15   set heading 0  ]

  ask zebra 90 [ setxy 28 -17   set heading 90 ]

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
    set counter 91

    loop
    [
        ifelse (counter <= 91 + 55)
        [
          ask line counter
          [
            setxy x_count 15
            set x_count x_count + 2
            set heading 0
          ]
        ]

        [
          ifelse (counter <= 91 + 55 + 56)
          [
            ask line counter
            [
              set x_count x_count - 2
              setxy x_count -15
              set heading 0
            ]
          ]

          [
            ifelse (counter <= 91 + 55 + 56 + 31)
            [
              ask line counter
              [
                setxy -28 y_count
                set y_count y_count - 2
                set heading 90
              ]
            ]

            [
              ifelse (counter <= 91 + 55 + 56 + 31 + 31)
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

to-report signal [special]

  let rand array:from-list [62 60 59 61]

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
@#$#@#$#@
GRAPHICS-WINDOW
373
10
1471
618
-1
-1
9.82
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
-30
30
1
1
1
ticks
30.0

BUTTON
148
103
211
136
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

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

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
