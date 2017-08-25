% In this program we assume only one action will be taken at a time.
pm(1..5).
ps(1..3).


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

% Actions for top level TR procedure

ruleapp(T,P,m):- on(b,c,T),on(c,t,T),clear(a,T),clear(b,T),pm(P,mb).
ruleapp(T,P,m):- on(b,c,T),on(c,t,T),pm(P,md).
ruleapp(T,P,m):- on(c,t,T),clear(b,T),clear(c,T),pm(P,me).
ruleapp(T,P,m):- on(c,t,T),clear(b,T),pm(P,mf).
ruleapp(T,P,m):- on(c,t,T),pm(P,mg).


move_on(a,b,T):- ruleapp(T,P,m),not higher_rule_m(T,P).

make_clear(a,T):- ruleapp(T,P,m),not higher_rule_m(T,P).
move_on(b,c,T):- ruleapp(T,P,m),not higher_rule_m(T,P).
make_clear(c,T):- ruleapp(T,P,m),not higher_rule_m(T,P).
make_clear(b,T):- ruleapp(T,P,m),not higher_rule_m(T,P).

% Actions for sub-task TR procedure 'make_clear/2'
% I do not know wether it is good to let ruleapp have variable B in it
ruleapp(T,B,Ps,s):- make_clear_h(B,T),clear(B,T),ps(Ps,sa).
ruleapp(T,AB,Ps,s):- make_clear_h(B,T),on(AB,B,T),clear(AB,T),ps(Ps,sb).
ruleapp(T,AB,Ps,s):- make_clear_h(B,T),on(AB,B,T),not clear(AB,T),ps(Ps,sc). 
already_clear(B,T):- ruleapp(T,B,Ps,s),not higher_rule_s(T,Ps).
move_on(AB,t,T):- ruleapp(T,AB,Ps,s),not higher_rule_s(T,Ps).
make_clear_h(AB,T):- ruleapp(T,AB,Ps,s),not higher_rule_s(T,Ps).

% generate hypotheses.

1{pm(1..5,mb)}1.
1{pm(1..5,md)}1.
1{pm(1..5,me)}1.
1{pm(1..5,mf)}1.
1{pm(1..5,mg)}1.

1{ps(1..3,sa)}1.
1{ps(1..3,sb)}1.
1{ps(1..3,sc)}1.


:- pm(P1,ID1),pm(P2,ID2),P1=P2,ID1!=ID2.
:- ps(P1,ID1),ps(P2,ID2),P1=P2,ID1!=ID2.

goal:- on(c,t,1),on(b,c,6),on(a,b,9),
       on(d,t,2),on(e,t,3),on(f,t,5),
       on(g,t,7),on(h,t,8),on(i,t,4).

:- not goal.



#hide.
#show pm/2.
#show ps/2.
