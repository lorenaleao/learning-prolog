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
