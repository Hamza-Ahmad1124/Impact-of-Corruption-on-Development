# Impact-of-Corruption-on-Development

## Introduction
Governance is defined the way that a country or company is controlled by the people who runs it. It can also be defined as the actions or manner of governing a state or organization. Dishonest or illegal behavior or conduct especially by powerful people is called corruption.
Development is the act or method of advancing / growing or causing something to grow or become more advance. The model shows that when any form of government is corrupt the people stop following the rules and the development gets reduced proportional to the rate of corruption. 


## Objective
The main objective of this model is to show the effects on development of an area being governed by governing system with varying corruption and also to show how the people follow or violate rules under varying corruption.  

## Object Design Document (ODD)

### Overview
The main purpose of creating this model is to examine the connection between governance and corruption in contrast with development of a city. This model is designed for semester project model. Model contains 8 different entities which are houses, industries, cars, pedestrians, lines (road lines), lights (Traffic Lights), zebras (zebra crossing) and checks_xes (pedestrian crossing lights). Each entity contains various state variables. There are 3 scales in the model which are corruption, no_of_pedestrians and no_of_cars. There is also a chooser in the model, show_progress.

### Design Concepts
The names of entities are self-explanatory. It is experienced in general that corruption always has a negative effect on governing systems and development of the country. The model will show that how corruption will effect the development of the city and the rate at which the pedestrians and cars are following rules. This model shows visual representation of an imaginary city. The city will be developed under different states of a single governing body. Any explicit form of governance is absent in this model. This is a general representation of how a city should be developed under different values of corruption in the governing body.

### Detail
There is a chooser in the model that changes what the model shows and how the model works initially at time = 0. Some values like number of pedestrians and number of cars are set by the scales and changing their values don’t effect the overall working of the model. Changing the values of the corruption scale and the show_progress chooser, changes the working and progress of how the model proceeds. Changing the corruption scale results in how much development occurs in the city and how many pedestrians and cars follow and violate the rules.  
- If corruption is set to 0 then city gets developed to its extreme level and all the pedestrians and cars follow the rules.
- If corruption is set to 25 then city gets almost 75% developed and 75% of the pedestrians and cars follow the rules.
- If corruption is set to 50 then city gets almost 50% developed and 50% of the pedestrians and cars follow the rules.
- If corruption is set to 75 then city gets almost 25% developed and 25% of the pedestrians and cars follow the rules.
 
The model does not use data from external sources. There are no sub models in this model.

## Conclusion
From the results generated, it is concluded that by increasing the corruption in any type of governing system whatsoever, development of the country or city gets seized and citizens stop following the rules.
