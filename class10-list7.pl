list([]).
list([_|T]) :- list(T).

/*
[1,[2],[3,[6],[7]]]

[1,
    [2],
    [3,
        [6],
        [7]
    ]
]

*/

/*

[1,[2,[6],[7,[15,[],[19],[],[20]],[16],[17],[18]],[8],[9]],[3,[10],[11],[12],[13]],[4,[14],[],[],[]],[5]]

[1,
    [2,
        [6],
        [7,
            [15,
                [],
                [19],
                [],
                [20]
            ],
            [16],
            [17],
            [18]
        ],
        [8],
        [9]
    ],
    [3,
        [10],
        [11],
        [12],
        [13]
    ],
    [4,
        [14],
        [],
        [],
        []
    ],
    [5]
]
*/

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
       
/*
prof_iter(NósIni,Prof,Sol) :-       % NósIni é a lista de nós iniciais
    p_i(NósIni,NósIni,Prof,Sol).

p_i([],NósIni,Prof,Sol) :-          % Já visitou os nós até o nível Prof
    Prof1 is Prof + 1,              % Itera a profundidade
    prof_iter(NósIni,Prof1,Sol).    % Verifica os NósIni à Prof+1

p_i([N|Nós],NósIni,Prof,[N]) :-
    solução(N).                     % O nó N é solução

p_i([N|Nós],NósIni,Prof,Sol) :-
    profundidade(N,ProfN),          % Determina  profundidade do nó N
    ProfN <= Prof,                  % N está a uma prof. menor que Prof
    expande(N,Filhos),              % então, expande seus filhos
    conc(Filhos,Nós,NovosNós),      % Faz a procura em profundidade 1o,
    p_i(NovosNós,NósIni,Prof,Sol).
    
p_i([_|Nós],NósIni,Prof,Sol) :-
    p_i(Nós,NósIni,Prof,Sol).       % O 1o. nó é folha e não é solução
*/

/****************************************************
*****************************************************/

/* These examples are working:

[debug]  ?- T = [1,[2],[3,[6],[7]]], iter_dfs([T], 0, 0, 0).
1
-----
T = [1, [2], [3, [6], [7]]] .

[debug]  ?- T = [1,[2],[3,[6],[7]]], iter_dfs([T], 0, 0, 1).
1
-----
1
2
3
-----
T = [1, [2], [3, [6], [7]]] .

[debug]  ?- T = [1,[2],[3,[6],[7]]], iter_dfs([T], 0, 0, 2).
1
-----
1
2
3
-----
1
2
3
6
7
T = [1, [2], [3, [6], [7]]] .

[debug]  ?- T = [1,[2],[3,[6],[7]]], iter_dfs([T], 0, 0, 3).
1
-----
1
2
3
-----
1
2
3
6
7
T = [1, [2], [3, [6], [7]]] .

This longer one is not: (TODO: fix it)

T = [1,[2,[6],[7,[15,[],[19],[],[20]],[16],[17],[18]],[8],[9]],[3,[10],[11],[12],[13]],[4,[14],[],[],[]],[5]], iter_dfs([T], 0, 0, 5).
*/

iter_dfs(InitialNodes, CurrDepth, MaxDepth, WantedDepth) :-                   % in this case, the search will stop at the wanted depth
    i_dfs(InitialNodes, InitialNodes, CurrDepth, MaxDepth, WantedDepth).      % this is our "solution"

i_dfs([], InitialNodes, CurrDepth, MaxDepth, WantedDepth) :- !.
    % NextCurrDepth is CurrDepth - 1,
    % NextMaxDepth is MaxDepth + 1,
    % iter_dfs(InitialNodes, CurrDepth, NextMaxDepth, WantedDepth).

i_dfs(_, _, _, MaxDepth, WantedDepth) :-
    MaxDepth > WantedDepth -> !.

i_dfs([[E|T0] | T1], InitialNodes, CurrDepth, MaxDepth, WantedDepth) :-
    % write('------------1st------------'),
    T0 \= [] -> (
        write(E), nl,
        NextCurrDepth is CurrDepth + 1,
        NextCurrDepth =< MaxDepth ->
            (
                append(T0, T1, NewNodes),
                i_dfs(NewNodes, InitialNodes, NextCurrDepth, MaxDepth, WantedDepth)
            )
            ;
            (
                NextMaxDepth is MaxDepth + 1,
                write('-----'), nl,
                iter_dfs(InitialNodes, 0, NextMaxDepth, WantedDepth)
            )
    ).

i_dfs([[E] | T], InitialNodes, CurrDepth, MaxDepth, WantedDepth) :-
    % write('------------2nd------------'),
    write(E), nl,
    i_dfs(T, InitialNodes, CurrDepth, MaxDepth, WantedDepth).

i_dfs([[] | T], InitialNodes, CurrDepth, MaxDepth, WantedDepth) :-
    % write('------------3rd------------'),
    write([]), nl,
    i_dfs(T, InitialNodes, CurrDepth, MaxDepth, WantedDepth).
    
% i_dfs([_|Nodes], InitialNodes, MaxDepth, WantedDepth) :-
%     i_dfs(Nodes, InitialNodes, MaxDepth, WantedDepth).

