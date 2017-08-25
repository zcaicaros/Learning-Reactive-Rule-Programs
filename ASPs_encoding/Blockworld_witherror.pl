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
%on(b,d,1).on(d,c,1).on(c,t,1).
%on(a,t,1).


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

% Actions for sub-task TR procedure 'make_clear/2'
% I do not know wether it is good to let ruleapp have variable B in it
ruleapp(T,B,1,s):- make_clear_h(B,T),clear(B,T).
ruleapp(T,AB,2,s):- make_clear_h(B,T),on(AB,B,T),clear(AB,T).
ruleapp(T,AB,3,s):- make_clear_h(B,T),on(AB,B,T),not clear(AB,T). 
already_clear(B,T):- ruleapp(T,B,1,s),not higher_rule_s(T,1).
move_on(AB,t,T):- ruleapp(T,AB,2,s),not higher_rule_s(T,2).
make_clear_h(AB,T):- ruleapp(T,AB,3,s),not higher_rule_s(T,3).

% We add this noise to test whether the block world agent can recover from some bad situations
1{ move_on(b,c,T),error(T,2,m)}1:- ruleapp(T,5,m),not higher_rule_m(T,5).

#hide.
%#show ruleapp/3.
#show move_on/3.
%#show error/3.
%#show goal/1.
%#show donothing/1.
%#show clear/2.
%#show on/3.
%#show ruleapp/2.
%#show make_clear/2.
%#show clear(a,T).
%#show higher_rule_s/2.
%#show ruleapp/4.
%#show clear/2.
%#show make_clear_h(B,T).
%#show make_clear_h/2.
