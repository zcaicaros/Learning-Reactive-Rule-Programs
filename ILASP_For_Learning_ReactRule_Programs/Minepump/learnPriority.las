% Using this example we get that the priority is 1,2,3
% Learn Priority Using ILASP
% Background

time(1..5).
water_level(18,1).methane_level(66,1).
water_level(21,2).methane_level(101,2).
water_level(22,3).methane_level(98,3).  
water_level(15,4).methane_level(66,4).   
water_level(6,5).methane_level(66,5).   
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

:- ruleapp(P,T1,ID1),ruleapp(P,T2,ID2),ID1!=ID2.

ruleapp(P,T,a):- methane_too_high(T,M),priority(P,a).
ruleapp(P,T,b):- water_too_high(T,W),priority(P,b).
ruleapp(P,T,c):- water_level(W,T),pump_running(T-1),not water_too_low(T,W),priority(P,c).
ruleapp(P,T,d):- priority(P,d),time(T).
do(alarm,T):- ruleapp(P,T,a),not higher_rule(P,T).
do(pump,T):- ruleapp(P,T,b),not higher_rule(P,T).
do(pump,T):- ruleapp(P,T,c),not higher_rule(P,T).
do(null,T):- ruleapp(P,T,d),not higher_rule(P,T).

% S_M
#modeh(priority(const(priority),a)).
#modeh(priority(const(priority),b)).
#modeh(priority(const(priority),c)).
#modeh(priority(const(priority),d)).
#constant(priority,1).
#constant(priority,2).
#constant(priority,3).
#constant(priority,4).

#pos(p, { pump_off(1),pump_off(2),pump_running(3),pump_running(4),pump_off(5),
	  alarm_off(1),alarm_running(2),alarm_off(3),alarm_off(4),alarm_off(5),
          donothing(1),donothing(5)}, {}).

