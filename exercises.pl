list([]).
list([_|_]).

size([], 0).
size([_|T], N) :- size(T, N1), N is 1 + N1.

even_size([]).
even_size([_, _ | T]) :- even_size(T).

odd_size(L) :- not(even_size(L)).

conc([], L, L).
conc([H|T1], L2, [H|T2]) :- conc(T1, L2, T2).

invert([], []).
invert([H|L], L2) :- invert(L, L1), conc(L1, [H], L2).

insert(X, [], [X]).
insert(X, [H|T], [X, H | T]).
insert(X, [H|T], [H|T2]) :- insert(X, T, T2).

spin([], []).
spin([H|T], L) :- conc(T, [H], L).

achata([H|T], L) :- list(H), conc(H, T, L1), achata(L1, L).
achata([H|T1], [H|T2]) :- not(list(H)), achata(T1, T2).

equal_size(L1, L2) :- size(L1, N1), size(L2, N2), N1 =:= N2.

divide_list([], [], []).
divide_list([H], [H], []).
divide_list([E1,E2|T], [E1|T1], [E2|T2]) :- divide_list(T, T1, T2).

sublist(S, L) :- conc(_, L2, L), conc(S, _, L2).

max(X, Y, Y) :- Y >= X.
max(X, Y, X) :- Y < X. 

mdc(_,_,0).

list_max([], 0). 
list_max([H|T], Max) :- list_max(T, TMax), max(H, TMax, Max).

list_sum([], 0).
list_sum([H|T], Sum) :- list_sum(T, TSum), Sum is H + TSum.