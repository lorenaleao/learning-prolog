list([]).
list([_|T]) :- list(T).

/* I had implemented like this before:
list([]).
list([_|_]).
*/

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

/* a sublist2 is the suffix for the prefix of a list.*/
sublist2(S, L) :- conc(L1, _, L), conc(_, S, L1).

prefix(P, L) :- conc(P, _, L).
suffix(S, L) :- conc(_, S, L).

sublist3(S, L) :- suffix(Suffix, L), prefix(S, Suffix).
sublist4(S, L) :- prefix(Prefix, L), suffix(S, Prefix).

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

/*TODO: Improve this */
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

/* This is still not working */
subsum(List, Sum, Subset) :- 
    list(List), 
    mysubset2(List, Subset), 
    list_sum(Subset, Sum).

/*interval(N1, N2, X) :- N1 < N2, X is N1 + 1, interval(X, N2, _).*/

/* 1st attempt */
interval(N1, N2, X) :- N1 < N2, X is N1 + 1, interval(X, N2, X1).
interval(_, N2, X) :- X is N2-1, !.

/* 2nd attempt -- it doesn't work completely yet */
interval2(J,F,F):- 
    J is F - 1,
    !.
interval2(J,I,F):-
    J is I + 1, 
    I < F.
interval2(C,I,F):-
    I < F,
    N is I+1,
    interval2(C,N,F).


para1(F,F,F):- !.
para1(I,I,F):- 
    I < F.
para1(C,I,F):-
    I < F,
    N is I+1,
    para(C,N,F).


/*para(C,1,5),write(C),nl,fail.*/

