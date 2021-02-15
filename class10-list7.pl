list([]).
list([_|T]) :- list(T).

dfs([]) :-
    write([]), nl, !.
dfs([L]) :-
    atomic(L), write(L), nl, !.
dfs([H|T]) :-
    list(H) -> 
        dfs(H), 
        (not(T = []) -> dfs(T); true)
    ;
        write(H), nl,
        dfs(T).

aux_bfs([]) :- !.
aux_bfs([[E|T0] | T1]) :-
    write(E), nl,
    append(T1, T0, NewT),
    aux_bfs(NewT).
aux_bfs([[E] | T]) :-
    write(E), nl,
    aux_bfs(T).
aux_bfs([[] | T]) :-
    write([]), nl,
    aux_bfs(T).

bfs(L) :-
    aux_bfs([L]).