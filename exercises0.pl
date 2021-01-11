list([]).
list([_|T]) :- list(T).

/* I had implemented like this before:
list([]).
list([_|_]).
*/

numbers_list([]).
numbers_list([H|T]) :- number(H), numbers_list(T). 

size([], 0).
size([_|T], N) :- size(T, N1), N is 1 + N1.

even_size([]).
even_size([_,_|T]) :- even_size(T).

odd_size2(L) :- not(even_size(L)).

odd_size([_]).
odd_size([_|T]) :- even_size(T).

conc([], L, L).
conc([H|T1], L2, [H|T2]) :- conc(T1, L2, T2).

invert([], []).
invert([H|L], L2) :- invert(L, L1), conc(L1, [H], L2).

insert(X, [], [X]).
insert(X, [H|T], [X, H | T]).
insert(X, [H|T], [H|T2]) :- insert(X, T, T2).

spin([], []).
spin([H|T], L) :- conc(T, [H], L).

flatten([], []).
flatten([H|T], L) :- list(H), flatten(H, H1), flatten(T,T1), conc(H1, T1, L).
flatten([H|T1], [H|T2]) :- not(list(H)), flatten(T1, T2).

equal_size(L1, L2) :- size(L1, N1), size(L2, N2), N1 =:= N2.

divide_list([], [], []).
divide_list([H], [H], []).
divide_list([E1,E2|T], [E1|T1], [E2|T2]) :- divide_list(T, T1, T2).

/* a sublist is the prefix for the suffix of a list.*/
sublist(S, L) :- conc(_, L2, L), conc(S, _, L2).

/* sublist1 doesn't return multiple empty lists as solutions */ 
sublist1([], _).
sublist1(S, L) :- conc(_, L2, L), conc(S, _, L2), S \= [].

/* a sublist2 is the suffix for the prefix of a list.*/
sublist2([], _).
sublist2(S, L) :- conc(L1, _, L), conc(_, S, L1), S \= [].

prefix(P, L) :- conc(P, _, L).
suffix(S, L) :- conc(_, S, L).

sublist3([], _).
sublist3(S, L) :- suffix(Suffix, L), prefix(S, Suffix), S \= [].

sublist4([], _).  
sublist4(S, L) :- prefix(Prefix, L), suffix(S, Prefix), S \= [].

del(X,[X|L],L).
del(X,[Y|L1],[Y|L2]) :- del(X,L1,L2).

/* If we add the clause del(X,[],[]), then we don't get the right answer:

?- del(3, [1,2,3], L).
L = [1, 2] ;
L = [1, 2, 3] ;
false.
*/

/*The next definition works, but it produces repeated permutations of the list.*/
notsogood_permute(P, [H|T]) :- insert(H, T, P).
notsogood_permute(P, [H|T]) :- permute(PT, T), insert(H, PT, P).

/*The next definition works without producing repeated permutations of the list.*/
permute([], []).
permute(P, [H|T]) :- permute(PT, T), insert(H, PT, P).


contains([H|_], H).
contains([_|T], X) :- contains(T, X).

/* this version of mysubset doesn't generate all the subsets of a given set */
mysubset(_, []).
mysubset(Set, [H|T]) :- contains(Set, H), mysubset(Set, T).  

/* this one is able to generate some subsets of a given set, but not all */
mysubset2(_, []).
mysubset2([H|T1], [H|T2]) :- mysubset2(T1, T2).
mysubset2([H|T], Subset) :- not(contains(Subset, H)), mysubset2(T, Subset).

/* Changing the last clause of mysubset2 by removing 'not(contains(Subset, H))' we obtain a predicate that generates all subsets of the given set with some repetitions. 

Execution Example:

[debug]  ?- mysubset3([1,2,3], L).
L = [] ;
L = [1] ;
L = [1, 2] ;
L = [1, 2, 3] ;
L = [1, 2] ;
L = [1] ;
L = [1, 3] ;
L = [1] ;
L = [] ;
L = [2] ;
L = [2, 3] ;
L = [2] ;
L = [] ;
L = [3] ;
L = [].

*/

mysubset3(_, []).
mysubset3([H|T1], [H|T2]) :- mysubset3(T1, T2).
mysubset3([_|T], T2) :- mysubset3(T, T2).

/* This last version works properly, yay o/ */
mysubset4([], []).
mysubset4([H|T1], [H|T2]) :- mysubset4(T1, T2).
mysubset4([_|T], T2) :- mysubset4(T, T2).

max(X, Y, Y) :- Y >= X.
max(X, Y, X) :- Y < X. 

/*
?- max(2,1,1).
false.

?- max(1,3,1).
false.

?- max(1,1,1).
true ;
false. temos um ponto de escolha aqui.
*/

max2(X,Y,Z):- ( 
    X > Y, !,
    Z = X 
    ;
    Z = Y
).

max3(X,Y,Z):- ( 
    X > Y ->
    Z = X 
    ;
    Z = Y
).

mdc(0, X, X).
mdc(X, 0, X).
mdc(X, Y, Z) :- Y =\= 0, Mod is X mod Y, mdc(Y, Mod, Z).

list_max([], 0). 
list_max([H|T], Max) :- list_max(T, TMax), max(H, TMax, Max).

list_sum([], 0).
list_sum([H|T], Sum) :- list_sum(T, TSum), Sum is H + TSum.

subsum(List, Sum, Subset) :- 
    numbers_list(List), 
    mysubset4(List, Subset), 
    list_sum(Subset, Sum).

/* 1st attempt */
interval(N1, N2, X) :- 
    N1 < N2, 
    X is N1 + 1, 
    interval(X, N2, _).
interval(_, N2, X) :- 
    X is N2 - 1, 
    !.

/* 2nd attempt -- it does not work completely yet */
interval2(J,F,F):- 
    J is F - 1,
    !.
interval2(J,I,F):-
    J is I + 1, 
    I < F.
interval2(C,I,F):-
    I < F,
    N is I + 1,
    interval2(C,N,F).

/* 3rd attempt */
interval3(F1, F, F1) :- 
    F1 is F - 1,
    !.
interval3(I, F, I1) :-
    I < F, 
    I1 is I + 1.
interval3(I, F, C) :-
    I < F,
    N is I + 1,
    interval3(N, F, C).

/* 4th attempt -- it works for all cases except when the interval is (N-1,N). In that case, we would like to return false since we want the numbers X that are in: N-1 < X < N, but this implementation returns N-1. */
interval4(F1, F, F1) :- 
    F1 is F - 1,
    !.
interval4(I, F, I1) :-
    X is F - 1, 
    I1 is I + 1, 
    I1 < X.
interval4(I, F, C) :-
    I < F,
    N is I + 1,
    interval4(N, F, C).

for(F,F,F):- !.
for(I,I,F):- 
    I < F.
for(C,I,F):-
    I < F,
    N is I+1,
    for(C,N,F).

for(Begin, End) :- 
    for(C,Begin,End),
    write(C), 
    nl,
    fail.

/* Trying to figure it out how to define an if-then-else block */

then(X, Var) :-
    X = Var.
else(X, Var) :-
    X = Var.

if(Var1, Var2, X, Var3, Var4) :-
    Var1 > Var2 -> then(X, Var3), !
    ; 
    else(X, Var4).

/* The above predicate works:

?- X = 2, Y = 3, Val2 is 2*X, Val4 is 4*X, if(Y, Val2,Z, Y, Val4).
X = 2,
Y = 3,
Val2 = 4,
Val4 = Z, Z = 8.

However, this is not exactly what we want in order to define new operators I guess
*/
