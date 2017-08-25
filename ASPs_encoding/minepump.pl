time(1..10).
%data
water_level(18,1).methane_level(66,1).
water_level(20,2).methane_level(77,2).
water_level(22,3).methane_level(88,3).
water_level(21,4).methane_level(101,4).
water_level(15,5).methane_level(99,5).
water_level(12,6).methane_level(99,6).
water_level(18,7).methane_level(110,7).
water_level(19,8).methane_level(104,8).
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

higher_rule(Priority,T):- time(T),
    ruleapp(Priority,T),
    ruleapp(Priority1,T),
    Priority1<Priority.

ruleapp(1,T):- methane_too_high(T,M).
ruleapp(2,T):- water_too_high(T,W).
ruleapp(3,T):- water_level(W,T),pump_running(T-1),not water_too_low(T,W).
ruleapp(4,T):- time(T).

do(alarm,T):- ruleapp(1,T), not higher_rule(1,T).
do(pump,T):- ruleapp(2,T), not higher_rule(2,T).
do(pump,T):- ruleapp(3,T), not higher_rule(3,T).
do(null,T):- ruleapp(4,T), not higher_rule(4,T).

#hide.
%#show pump_running/1.
%#show pump_off/1.
%#show alarm_running/1.
%#show alarm_off/1.
#show do/2.











    

