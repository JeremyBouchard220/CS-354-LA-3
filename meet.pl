#!/bin/gprolog --consult-file

:- include('data.pl').
:- include('uniq.pl').

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

%asdf
match(slot(FirstBegin,FirstEnd),slot(SecondBegin,SecondEnd),slot(SecondBegin,SecondEnd)) :-
    lte(FirstBegin,SecondBegin),
    lte(SecondBegin,FirstEnd),
    lte(SecondEnd,FirstEnd),
    SecondBegin\==SecondEnd.

match(slot(FirstBegin,FirstEnd),slot(SecondBegin,SecondEnd),slot(SecondBegin,FirstEnd)) :-
    lte(FirstBegin,SecondBegin),
    lte(SecondBegin,FirstEnd),
    lte(FirstEnd,SecondEnd),
    SecondBegin\==FirstEnd.

%asdf
meetCheck(FirstSlot,SecondSlot,MeetingSlot) :-
    match(FirstSlot,SecondSlot,MeetingSlot).

meetCheck(FirstSlot,SecondSlot,MeetingSlot) :-
    match(SecondSlot,FirstSlot,MeetingSlot).

%asdf
meetCollect([Second|Tail],FirstSlot,Slot) :-
    free(Second,SecondSlot),
    meetCheck(FirstSlot,SecondSlot,Slot0),
    meetCollect(Tail,Slot0,Slot).
    
meetCollect([],Slot,Slot).

%asdf
meetTimes([First|Tail],Slot) :-
    free(First,FirstSlot),
    meetCollect(Tail,FirstSlot,Slot).

%asdf
meet(Slot) :-
    people(People),
    meetTimes(People,Slot).

people([bob,jeremy,carla]).

main :- findall(Slot, meet(Slot), Slots),
        uniq(Slots, Uniq),
        write(Uniq), nl, halt.

:- initialization(main).
