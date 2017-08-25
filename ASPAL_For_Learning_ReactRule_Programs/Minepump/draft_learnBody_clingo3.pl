% This example tell the agent how many rules in the blackbox and what
% these rules are. Given some examples, the agent tells which action to take

% Background
time(1..11).
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
water_level(6,11).methane_level(66,11).   
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

do(alarm,T):- ruleapp(1,T),not higher_rule(1,T).
do(pump,T):- ruleapp(2,T),not higher_rule(2,T).
do(pump,T):- ruleapp(3,T),not higher_rule(3,T).
do(null,T):- ruleapp(4,T),not higher_rule(4,T).
   
% S_M ruleapp is the target to learn, here is the maximum hypothesis space
ruleapp(P,T):- time(T),rID(1,P).
ruleapp(P,T):- pump_running(T-1),time(T),rID(2,P).
ruleapp(P,T):- water_too_high(T,W),rID(3,P).
ruleapp(P,T):- water_too_low(T,W),rID(4,P).
ruleapp(P,T):- not water_too_low(T,W),water_level(W,T),rID(5,P).
ruleapp(P,T):- methane_too_high(T,M),rID(6,P).
ruleapp(P,T):- methane_too_high(T,M),water_too_high(T,W),rID(7,P).
ruleapp(P,T):- methane_too_high(T,M),water_too_low(T,W),rID(8,P).
ruleapp(P,T):- methane_too_high(T,M),pump_running(T-1),rID(9,P).
ruleapp(P,T):- methane_too_high(T,M),not water_too_low(T,W),water_level(W,T),rID(10,P).
ruleapp(P,T):- water_too_high(T,W1),water_too_low(T,W2),rID(11,P).
ruleapp(P,T):- water_too_high(T,W1),pump_running(T-1),rID(12,P).
ruleapp(P,T):- water_too_high(T,W1),not water_too_low(T,W),water_level(W,T),rID(13,P).
ruleapp(P,T):- water_too_low(T,W2),pump_running(T-1),rID(14,P).
ruleapp(P,T):- water_too_low(T,W2),not water_too_low(T,W),water_level(W,T),rID(15,P).
ruleapp(P,T):- not water_too_low(T,W),water_level(W,T),pump_running(T-1),rID(16,P).
ruleapp(P,T):- pump_running(T-1),water_too_high(T,W),water_too_low(T,W),rID(17,P).
ruleapp(P,T):- pump_running(T-1),water_too_high(T,W),not water_too_low(T,W),water_level(W,T),rID(18,P).
ruleapp(P,T):- pump_running(T-1),water_too_high(T,W),methane_too_high(T,M),rID(19,P).
ruleapp(P,T):- pump_running(T-1),water_too_low(T,W),not water_too_low(T,W),water_level(W,T),rID(20,P).
ruleapp(P,T):- pump_running(T-1),water_too_low(T,W),methane_too_high(T,M),rID(21,P).
ruleapp(P,T):- water_too_high(T,W),water_too_low(T,W),not water_too_low(T,W),water_level(W,T),rID(22,P).
ruleapp(P,T):- water_too_high(T,W),water_too_low(T,W),methane_too_high(T,M),rID(23,P).
ruleapp(P,T):- not water_too_low(T,W),water_level(W,T),water_too_low(T,W),methane_too_high(T,M),rID(24,P).

4{rID(1..24,1..4)}4.
:- rID(ID1,P),rID(ID2,P),ID1!=ID2.
    
goal:-  pump_off(1),pump_off(2),pump_running(3),
	pump_off(4),pump_off(5),pump_off(6),
	pump_off(7),pump_off(8),pump_running(9),
	pump_running(10),pump_off(11),alarm_off(1),
	alarm_off(2),alarm_off(3),alarm_running(4),
        alarm_off(5),alarm_off(6),alarm_running(7),
	alarm_running(8),alarm_off(9),alarm_off(10),
	alarm_off(11),donothing(1),donothing(2),
	donothing(5),donothing(6),donothing(11).
:- not goal.


#hide.
%#show rule/1.
%#show alarm/1.
%#show pump/1.
%#show  ruleapp/2.
#show  rID/2.
%#show  do/2.
%#show pump_running/1.
%#show pump_off/1.
%#show alarm_running/1.
%#show alarm_off/1.


