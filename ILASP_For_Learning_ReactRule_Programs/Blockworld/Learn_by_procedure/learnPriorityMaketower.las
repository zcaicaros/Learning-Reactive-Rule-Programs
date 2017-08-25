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
    ruleapp(ID1,Priority,T,m),
    ruleapp(ID2,Priority1,T,m),
    ID1!=ID2,
    Priority1<Priority.
higher_rule_s(T,Priority):- time(T),
    ruleapp(T,B,Priority,s),
    ruleapp(T,B,Priority1,s),
    Priority1<Priority.

:- ruleapp(ID1,P,T1,m),ruleapp(ID2,P,T2,m),ID1!=ID2.

goal(T):- on(a,b,T),on(b,c,T),on(c,t,T),clear(a,T).

% Actions for top level TR procedure
ruleapp(a,P,T,m):- goal(T),priority(P,a).
ruleapp(b,P,T,m):- on(b,c,T),on(c,t,T),clear(a,T),clear(b,T),priority(P,b).
ruleapp(c,P,T,m):- on(b,c,T),on(c,t,T),clear(a,T),priority(P,c).
ruleapp(d,P,T,m):- on(b,c,T),on(c,t,T),priority(P,d).
ruleapp(e,P,T,m):- on(c,t,T),clear(b,T),clear(c,T),priority(P,e).
ruleapp(f,P,T,m):- on(c,t,T),clear(b,T),priority(P,f).
ruleapp(g,P,T,m):- on(c,t,T),priority(P,g).
ruleapp(h,P,T,m):- clear(c,T),priority(P,h).
ruleapp(i,P,T,m):- time(T),priority(P,i).
donothing(T):- ruleapp(a,P,T,m),not higher_rule_m(T,P).
move_on(a,b,T):- ruleapp(b,P,T,m),not higher_rule_m(T,P).
make_clear(b,T):- ruleapp(c,P,T,m),not higher_rule_m(T,P).
make_clear(a,T):- ruleapp(d,P,T,m),not higher_rule_m(T,P).
move_on(b,c,T):- ruleapp(e,P,T,m),not higher_rule_m(T,P).
make_clear(c,T):- ruleapp(f,P,T,m),not higher_rule_m(T,P).
make_clear(b,T):- ruleapp(g,P,T,m),not higher_rule_m(T,P).
move_on(c,t,T):- ruleapp(h,P,T,m),not higher_rule_m(T,P).
make_clear(c,T):- ruleapp(i,P,T,m),not higher_rule_m(T,P).

% Actions for sub-task TR procedure 'make_clear/2'
ruleapp(T,B,1,s):- make_clear_h(B,T),clear(B,T).
ruleapp(T,AB,2,s):- make_clear_h(B,T),on(AB,B,T),clear(AB,T).
ruleapp(T,AB,3,s):- make_clear_h(B,T),on(AB,B,T),not clear(AB,T). 
already_clear(B,T):- ruleapp(T,B,1,s),not higher_rule_s(T,1).
move_on(AB,t,T):- ruleapp(T,AB,2,s),not higher_rule_s(T,2).
make_clear_h(AB,T):- ruleapp(T,AB,3,s),not higher_rule_s(T,3).

% S_M
#modeh(priority(const(priority),a)).
#modeh(priority(const(priority),b)).
#modeh(priority(const(priority),c)).
#modeh(priority(const(priority),d)).
#modeh(priority(const(priority),e)).
#modeh(priority(const(priority),f)).
#modeh(priority(const(priority),g)).
#modeh(priority(const(priority),h)).
#modeh(priority(const(priority),i)).
#constant(priority,1).
#constant(priority,2).
#constant(priority,3).
#constant(priority,4).
#constant(priority,5).
#constant(priority,6).
#constant(priority,7).
#constant(priority,8).
#constant(priority,9).

% Pos and Neg Examples
#pos(p1, {on(c,t,1),on(b,c,6),on(a,b,9),clear(a,8),
	  on(d,t,2),on(e,t,3),on(f,t,5),
	  on(g,t,7),on(h,t,8),on(i,t,4)}, {}).
