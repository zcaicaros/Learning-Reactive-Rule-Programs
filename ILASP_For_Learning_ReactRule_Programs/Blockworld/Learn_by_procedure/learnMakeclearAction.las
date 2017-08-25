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


% data, each situation S has 3 default fluents on/3
% we give the initial fluents and use frame problem code to generate fluents for time forward 
on(g,h,1).on(h,a,1).on(a,t,1).
on(d,e,1).on(e,b,1).on(b,t,1).
on(i,f,1).on(f,c,1).on(c,t,1).

% Define what means a block is clear at time T.
% The idea is to generate clear/2 based on 3 fluent on/3 at each time.
clear(B,T):- not not_clear(B,T),on(B,O,T). % on/3 here is only for safe rule.
not_clear(B,T):-on(AB,B,T),block(B).

% Code solve the frame axiom problem.
on(B,O,T):- move_on(B,O,T-1),time(T).
on(B,O,T):- on(B,O,T-1),move_on(B1,O1,T-1),B!=B1,time(T).% This rule restrict one action at a time.
on(B,O,T):- not action(T-1),time(T),on(B,O,T-1).
action(T):- move_on(B,O,T).

% Helper functions of 'make_clear/2'.
make_clear_h(B,T):- make_clear(B,T). % for generate atom make_clear_h/2
make_clear_h(B,T+1):- make_clear_h(B,T),not clear(B,T),time(T+1). % If block B is not clear after doing 
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
    ruleapp(T,Priority,s),
    ruleapp(T,Priority1,s),
    Priority1<Priority.

% Actions for top level TR procedure
ruleapp(T,1,m):- goal(T).
ruleapp(T,2,m):- on(b,c,T),on(c,t,T),clear(a,T),clear(b,T).
ruleapp(T,3,m):- on(b,c,T),on(c,t,T),clear(a,T).
ruleapp(T,4,m):- on(b,c,T),on(c,t,T).
ruleapp(T,5,m):- on(c,t,T),clear(b,T),clear(c,T).
ruleapp(T,6,m):- on(c,t,T),clear(b,T).
ruleapp(T,7,m):- on(c,t,T).
ruleapp(T,8,m):- clear(c,T).
ruleapp(T,9,m):- time(T).
donothing(T):- ruleapp(T,1,m),not higher_rule_m(T,1).
move_on(a,b,T):- ruleapp(T,2,m),not higher_rule_m(T,2).
make_clear(b,T):- ruleapp(T,3,m),not higher_rule_m(T,3).
make_clear(a,T):- ruleapp(T,4,m),not higher_rule_m(T,4).
move_on(b,c,T):- ruleapp(T,5,m),not higher_rule_m(T,5).
make_clear(c,T):- ruleapp(T,6,m),not higher_rule_m(T,6).
make_clear(b,T):- ruleapp(T,7,m),not higher_rule_m(T,7).
move_on(c,t,T):- ruleapp(T,8,m),not higher_rule_m(T,8).
make_clear(c,T):- ruleapp(T,9,m),not higher_rule_m(T,9).

goal(T):- on(a,b,T),on(b,c,T),on(c,t,T),clear(a,T).

% Know priority and body of ruleapp.
ruleapp(T,B,1,s):- make_clear_h(B,T),clear(B,T).
ruleapp(T,AB,2,s):- make_clear_h(B,T),on(AB,B,T),clear(AB,T).
ruleapp(T,AB,3,s):- make_clear_h(B,T),on(AB,B,T),not clear(AB,T). 


% S_M
#modeh(already_clear(var(block),var(time))).
#modeh(move_on(var(block),t,var(time))).
#modeh(make_clear_h(var(block),var(time))).
#modeb(1,ruleapp(var(time),var(block),const(priority),s),(positive)).
#modeb(1,higher_rule_s(var(time),const(priority))).
#constant(priority,1).
#constant(priority,2).
#constant(priority,3).
#maxv(3).

% Pos and Neg Examples
#pos(p1, {on(c,t,1),on(b,c,6),on(a,b,9),clear(a,8),
	  on(d,t,2),on(e,t,3),on(f,t,5),
	  on(g,t,7),on(h,t,8),on(i,t,4)}, {}).

% Comments: using -s we know the expected hypothesis are in the search space.
% However, ILASP only generate optimal hypothesis, and ruleapp(T,AB,2,s) and
% ruleapp(T,AB,3,s) are mutually exclusive. As a result, it generate hypothsis
% make_clear_h(V1,V0) :- ruleapp(V0,V1,3,s).
% move_on(V1,t,V0) :- ruleapp(V0,V1,2,s).
% without higher_rule. In addition, it will not generate the first rule because 
% it will be automatically satiesfied, and based on optimal property of ILASP, 
% it will not be included in the hypothesis.
