% Background
time(1..10).
water_level(18,1).methane_level(66,1).
water_level(20,2).methane_level(77,2).
water_level(22,3).methane_level(88,3).
water_level(21,4).methane_level(101,4).
water_level(15,5).methane_level(99,5).
water_level(12,6).methane_level(99,6).
water_level(18,7).methane_level(110,7).
water_level(13,8).methane_level(104,8).
water_level(21,9).methane_level(98,9).
water_level(15,10).methane_level(98,10).    
crit_methane(100).
high_water(20).
low_water(10).
water_too_high(T,W):- high_water(HW),water_level(W,T),W>HW.
water_too_low(T,W):- low_water(LW),water_level(W,T),W<=LW.
methane_too_high(T,M):- crit_methane(CM),methane_level(M,T),M>=CM.
pump_running(T):-
    do(pump,T).
pump_off(T):-
    time(T),
    not do(pump,T).
alarm_running(T):-
    do(alarm,T).
alarm_off(T):-             
    time(T),
    not do(alarm,T).
donothing(T):-
    time(T),
    do(null,T).

higher_rule(Priority,T):-
    ruleapp(Priority,T,ID),
    ruleapp(Priority1,T,ID1),
    ID!=ID1,
    Priority1<Priority.

ruleapp(P,T,a):- methane_too_high(T,M),priority(P,a).
ruleapp(P,T,b):- water_too_high(T,W),priority(P,b).
ruleapp(P,T,c):- water_level(W,T),pump_running(T-1),not water_too_low(T,W),priority(P,c).
ruleapp(P,T,d):- time(T),priority(P,d).
do(alarm,T):- ruleapp(P,T,a),not higher_rule(P,T).
do(pump,T):- ruleapp(P,T,b),not higher_rule(P,T).
do(pump,T):- ruleapp(P,T,c),not higher_rule(P,T).
do(null,T):- ruleapp(P,T,d),not higher_rule(P,T).

% S_M

1{priority(1..4,a)}1.
1{priority(1..4,b)}1.
1{priority(1..4,c)}1.
1{priority(1..4,d)}1.
    
goal:-  pump_off(1),pump_off(2),pump_running(3),pump_off(4),
        pump_off(5),pump_off(6),pump_off(7),pump_off(8),pump_running(9),
        pump_running(10),alarm_off(1),alarm_off(2),alarm_off(3),alarm_running(4),
        alarm_off(5),alarm_off(6),alarm_running(7),alarm_running(8),alarm_off(9),alarm_off(10),
        donothing(1),donothing(2),donothing(5),donothing(6).
:- not goal.


:- priority(P,ID1),priority(P,ID2),ID1!=ID2.

#hide.
#show priority/2.
%#show do/2.
%#show rule/1.
%#show alarm/1.
%#show pump/1.
%#show ruleapp/3.
%#show pump_running/1.
%#show pump_off/1.
%#show alarm_running/1.
%#show alarm_off/1.
%#show higher_rule/2.
%#show rID/2.
