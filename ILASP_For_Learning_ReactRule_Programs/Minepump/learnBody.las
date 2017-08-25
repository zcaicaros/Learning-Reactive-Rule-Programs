% Learn Body Using ILASP
% Background

time(1..6).
water_level(18,1).methane_level(66,1).
water_level(21,2).methane_level(101,2).
water_level(19,3).methane_level(66,3).   
water_level(22,4).methane_level(98,4).  
water_level(15,5).methane_level(66,5).   
water_level(6,6).methane_level(66,6).   

crit_methane(100).
high_water(20).
low_water(10).
water_too_high(T):- high_water(HW),water_level(W,T),W>HW.
water_too_low(T):- low_water(LW),water_level(W,T),W<=LW.
methane_too_high(T):- crit_methane(CM),methane_level(M,T),M>=CM.
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
higher_rule(Priority,T):- time(T),
    ruleapp(Priority,T),
    ruleapp(Priority1,T),
    Priority1<Priority.

do(alarm,T):- time(T),ruleapp(1,T),not higher_rule(1,T).
do(pump,T):- time(T),ruleapp(2,T),not higher_rule(2,T).
do(pump,T):- time(T),ruleapp(3,T),not higher_rule(3,T).
do(null,T):- time(T),ruleapp(4,T),not higher_rule(4,T).

% S_M
#modeh(ruleapp(1,var(time)),(positive)).
#modeh(ruleapp(2,var(time)),(positive)).
#modeh(ruleapp(3,var(time)),(positive)).
#modeh(ruleapp(4,var(time)),(positive)).
#modeb(1,methane_too_high(var(time))).
#modeb(1,water_too_high(var(time))).
#modeb(1,water_too_low(var(time))).
#modeb(1,pump_running(var(time)-1)).
#modeb(1,time(var(time))).
#maxv(1).

% Pos and Negs Examples


#pos(p, { pump_off(1),pump_off(2),pump_off(3),pump_running(4),pump_running(5),pump_off(6),
	  alarm_off(1),alarm_running(2),alarm_off(3),alarm_off(4),alarm_off(5),alarm_off(6),
          donothing(1),donothing(6),donothing(3)}, {}).


