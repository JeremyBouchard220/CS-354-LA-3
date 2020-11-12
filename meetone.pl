#!/bin/gprolog --consult-file

:- include('data.pl').

% Finds start and end time based on am vs pm
lte(time(_,_,am),time(_,_,pm)).

% Checks the hours for each person to see if different.
lte(time(FirstHour,_,Id),time(SecondHour,_,Id)) :-
		FirstHour<SecondHour.

% Check minutes for each person to see if different.
lte(time(Hour,FirstMin,Id),time(Hour,SecondMin,Id)) :-
		FirstMin =< SecondMin.

% Check if a person can meet in specific time frame.
% Person can only meet if persons begin time is less than or equal to other persons time and if end time is greater or equal to the other meet time.
meetone(Person,slot(Begin,End)) :-
		free(Person,slot(FirstTime,SecondTime)),
		lte(FirstTime,Begin), lte(End,SecondTime).

main :- findall(Person,
		meetone(Person,slot(time(8,30,am),time(8,45,am))),
		People),
	write(People), nl, halt.

:- initialization(main).
