% Learn Action Using ILASP
% Background
time(1..10).
water_level(18,1).methane_level(66,1).
water_level(20,2).methane_level(77,2).
water_level(22,3).methane_level(88,3).
water_level(21,4).methane_level(100,4).
water_level(22,5).methane_level(99,5).
water_level(12,6).methane_level(99,6).
water_level(6,7).methane_level(68,7).
water_level(16,8).methane_level(88,8).
water_level(21,9).methane_level(98,9).
water_level(15,10).methane_level(100,10).    
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

higher_rule(Priority,T):- time(T),
    ruleapp(Priority,T),
    ruleapp(Priority1,T),
    Priority1<Priority.

% Know priority and body of ruleapp.
ruleapp(1,T):- methane_too_high(T,M).
ruleapp(2,T):- water_level(W,T),pump_running(T-1),not water_too_low(T,W).
ruleapp(3,T):- water_too_high(T,W).
ruleapp(4,T):- time(T).

% S_M

#modeh(do(const(action),var(time)),(positive)).
#modeb(1,ruleapp(const(priority),var(time)),(positive)).
#modeb(1,higher_rule(const(priority),var(time))).
#constant(priority,1).
#constant(priority,2).
#constant(priority,3).
#constant(priority,4).
#constant(action,alarm).
#constant(action,pump).
#constant(action,null).

% Pos and Negs Examples
#pos(p, { donothing(1),donothing(2),donothing(7),donothing(8),
	  pump_off(1),pump_off(2),pump_running(3),pump_off(4),
	  pump_running(5),pump_running(6),pump_off(7),pump_off(8),
	  pump_running(9),pump_off(10),alarm_off(1),alarm_off(2),
	  alarm_off(3),alarm_running(4),alarm_off(5),alarm_off(6),
	  alarm_off(7),alarm_off(8),alarm_off(9),alarm_running(10) }, {}).
#neg(n1, {}, {pump_running(6)}).
#neg(n2, {donothing(6)}, {}).
