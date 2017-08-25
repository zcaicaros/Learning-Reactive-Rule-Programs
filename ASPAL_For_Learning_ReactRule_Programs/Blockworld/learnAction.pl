% In this program we assume only one action will be taken at a time.

block(a).
block(b).
block(c).
block(d).
block(e).
block(f).
block(g).
block(h).
block(i).
time(1..10).

% data, each situation S default fluents on/3
% we give the initial fluents and use frame problem code to generate fluents for time forward 
on(g,h,1).on(h,a,1).on(a,t,1).
on(d,e,1).on(e,b,1).on(b,t,1).
on(i,f,1).on(f,c,1).on(c,t,1).

% Define what means a block is clear at time T.
% The idea is to generate clear/2 based on fluent on/3 at each time.
clear(B,T):- not not_clear(B,T),on(B,O,T). % on/3 here is only for safe rule.
not_clear(B,T):-on(AB,B,T),block(B).

% Code solve the frame axiom problem.
on(B,O,T):- move_on(B,O,T-1),time(T).
on(B,O,T):- on(B,O,T-1),move_on(B1,O1,T-1),B!=B1,time(T).% This rule restrict one action at a time.
on(B,O,T):- not action(T-1),time(T),on(B,O,T-1).
action(T):- move_on(B,O,T).

% Helper functions of 'make_clear/2'.
make_clear_h(B,T):- make_clear(B,T). % for generate atom make_clear_h/2
make_clear_h(B,T+1):- make_clear_h(B,T),not clear(B,T+1),time(T+1). % If block B is not clear after doing 
                                                                  % make_clear at time T, then we would
                                                                  % like to continually clear it in the 
                                                                  % future until it is clear.


% Because we have 2 different ruleapp/3 so we have 2 different higher_rule_s and higher_rule_m.
% We don not want two ruleapps generate 'higher_rule/2' for the other TR procedure, so we give them
% different name.
higher_rule_m(T,Priority):- time(T),
    ruleapp(T,Priority,m),
    ruleapp(T,Priority1,m),
    Priority1<Priority.
higher_rule_s(T,Priority):- time(T),
    ruleapp(T,B,Priority,s),
    ruleapp(T,B,Priority1,s),
    Priority1<Priority.

goal(T):- on(a,b,T),on(b,c,T),on(c,t,T),clear(a,T).

ruleapp(T,1,m):- goal(T).
ruleapp(T,2,m):- on(b,c,T),on(c,t,T),clear(a,T),clear(b,T).
ruleapp(T,3,m):- on(b,c,T),on(c,t,T),clear(a,T).
ruleapp(T,4,m):- on(b,c,T),on(c,t,T).
ruleapp(T,5,m):- on(c,t,T),clear(b,T),clear(c,T).
ruleapp(T,6,m):- on(c,t,T),clear(b,T).
ruleapp(T,7,m):- on(c,t,T).
ruleapp(T,8,m):- clear(c,T).
ruleapp(T,9,m):- time(T).

ruleapp(T,B,10,s):- make_clear_h(B,T),clear(B,T).
ruleapp(T,AB,11,s):- make_clear_h(B,T),on(AB,B,T),clear(AB,T).
ruleapp(T,AB,12,s):- make_clear_h(B,T),on(AB,B,T),not clear(AB,T).

% S_M

already_clear(B,T):- ruleapp(T,B,P,s),not higher_rule_s(T,P),rule(1,P).
move_on(B,t,T):- ruleapp(T,B,P,s),not higher_rule_s(T,P),rule(2,P).
make_clear_h(B,T):- ruleapp(T,B,P,s),not higher_rule_s(T,P),rule(3,P).
donothing(T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(4,P).
move_on(a,b,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(5,P).
make_clear(b,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(6,P). 
make_clear(a,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(7,P).
move_on(b,c,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(8,P).
make_clear(c,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(9,P).
make_clear(b,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(10,P).
move_on(c,t,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(11,P).
make_clear(c,T):- ruleapp(T,P,m),not higher_rule_m(T,P),rule(12,P).


% Generate hyporheses.
{rule(1..12,1..12)}.

#minimise[rule(1..12,1..12)=3].

% If the goal is achieve at time T, we would like the
% agent do nothing from then.
:- goal(T),not donothing(Tf),time(Tf),Tf>=T,Tf<=10.

% 1-1 correspondance of action and condition.
:- rule(ID1,P1),rule(ID2,P2),ID1=ID2,P1!=P2.
:- rule(ID1,P1),rule(ID2,P2),ID1!=ID2,P1=P2.

goal:- on(c,t,1),on(b,c,6),on(a,b,9),
       on(d,t,2),on(e,t,3),on(f,t,5),
       on(g,t,7),on(h,t,8),on(i,t,4).

:- not goal.



#hide.
#show rule/2.
