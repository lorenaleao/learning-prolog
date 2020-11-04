:- dynamic valor_folha/2.

max(X,Y,Z):- ( 
    X > Y ->
    Z = X 
    ;
    Z = Y
).

min(X,Y,Z):- ( 
    X < Y ->
    Z = X 
    ;
    Z = Y
).

% Maxs and Mins Tree

% max(a,[
%     min(b,[
%         max(e,[
%             min(h,[]),
%             min(i,[
%                 max(l,[]),
%                 max(m,[])
%             ]),
%         ]),
%     ]),
%     min(c,[
%         max(f,[]),
%         max(g,[]),
%     ]),
%     min(d,[])
% ])

valor_folha(l, 1).
valor_folha(m, -1).
valor_folha(h, -1).
valor_folha(f, 1).
valor_folha(g, 1).
valor_folha(d, -1).

% Testing the minimax algorithm

% ?- T = max(a,[min(b,[max(e,[min(h,[]),min(i,[max(l,[]),max(m,[])])])]),min(c,[max(f,[]),max(g,[])]),min(d,[])]), minimax(T, V).
% T = max(a, [min(b, [max(e, [min(h, []), min(i, [max(..., ...)|...])])]), min(c, [max(f, []), max(g, [])]), min(d, [])]),
% V = 1.

% It's working!
    
minimax(Folha,V):-
    ( Folha = max(N,[])
    ; Folha = min(N,[])), !,
    valor_folha(N,V).

minimax(max(_,F),V):-
    max_filhos(F,-inf,V).

minimax(min(_,F),V):-
    min_filhos(F,inf,V).

max_filhos([],Max,Max).
max_filhos([N|Nodes],Max0,Max):-
    minimax(N,V),
    max(V,Max0,Max1),
    max_filhos(Nodes,Max1,Max).

min_filhos([],Min,Min).
min_filhos([N|Nodes],Min0,Min):-
    minimax(N,V),
    min(V,Min0,Min1),
    min_filhos(Nodes,Min1,Min).

% generate_state(0, Acc, Acc) :- !.
% generate_state(N, Acc, S) :- 
%     append(Acc, ['x'], Acc1), 
%     N1 is N - 1, 
%     generate_state(N1, Acc1, S). 
% generate_state(N, Acc, S) :- 
%     append(Acc, ['o'], Acc1), 
%     N1 is N - 1, 
%     generate_state(N1, Acc1, S). 

% generate_all_states :-
%     generate_state(9, [], S), write(S), nl, fail. 

% generate_all_states (above) doesn't generate all of the intermediate states, 
% i.e., states that contains empty spaces, which are where the game can end.
% Therefore, we need to generate those missing states, but this increases 
% the number of states to 3^9 = 19683, yikes! 

generate_state(0, Acc, Acc) :- !.
generate_state(N, Acc, S) :- 
    append(Acc, ['x'], Acc1), 
    N1 is N - 1, 
    generate_state(N1, Acc1, S). 
generate_state(N, Acc, S) :- 
    append(Acc, ['o'], Acc1), 
    N1 is N - 1, 
    generate_state(N1, Acc1, S).
generate_state(N, Acc, S) :- 
    append(Acc, ['-'], Acc1), 
    N1 is N - 1, 
    generate_state(N1, Acc1, S). 

generate_all_states :-
    generate_state(9, [], S), 
    write(S), nl, 
    x_positions(S, 1, [], XPosList),
    o_positions(S, 1, [], OPosList),
    empty_positions(S, 1, [], EmptyPosList),
    (
        is_winning_state(XPosList) -> assertz(valor_folha(S, 1)); % player wins
        is_winning_state(OPosList) -> assertz(valor_folha(S, -1)); % opponent wins
        size(EmptyPosList, 0) -> assertz(valor_folha(S, 0)) % tie
    ),
    fail. 
generate_all_states.

x_positions([], _, Acc, Acc).
x_positions(['x'|T], Pos, Acc, PosList) :-
    append(Acc, [Pos], Acc1),
    Pos1 is Pos + 1,
    x_positions(T, Pos1, Acc1, PosList).
x_positions(['o'|T], Pos, Acc, PosList) :-
    Pos1 is Pos + 1,
    x_positions(T, Pos1, Acc, PosList).
x_positions(['-'|T], Pos, Acc, PosList) :-
    Pos1 is Pos + 1,
    x_positions(T, Pos1, Acc, PosList).

o_positions([], _, Acc, Acc).
o_positions(['o'|T], Pos, Acc, PosList) :-
    append(Acc, [Pos], Acc1),
    Pos1 is Pos + 1,
    o_positions(T, Pos1, Acc1, PosList).
o_positions(['x'|T], Pos, Acc, PosList) :-
    Pos1 is Pos + 1,
    o_positions(T, Pos1, Acc, PosList).
o_positions(['-'|T], Pos, Acc, PosList) :-
    Pos1 is Pos + 1,
    o_positions(T, Pos1, Acc, PosList).

empty_positions([], _, Acc, Acc).
empty_positions(['-'|T], Pos, Acc, PosList) :-
    append(Acc, [Pos], Acc1),
    Pos1 is Pos + 1,
    empty_positions(T, Pos1, Acc1, PosList).
empty_positions(['x'|T], Pos, Acc, PosList) :-
    Pos1 is Pos + 1,
    empty_positions(T, Pos1, Acc, PosList).
empty_positions(['o'|T], Pos, Acc, PosList) :-
    Pos1 is Pos + 1,
    empty_positions(T, Pos1, Acc, PosList).

array_diff([], _, []) :- !.
array_diff(C, [], C) :- !.
array_diff([H|T], C, [H|T2]) :- \+ member(H, C), !, array_diff(T, C, T2).
array_diff([_|T], C, Dif) :- array_diff(T, C, Dif).

size([], 0).
size([_|T], N) :- size(T, N1), N is 1 + N1.

is_winning_state(XPosList) :-
    size(XPosList, XS), 
    winning_positions(Y),
    array_diff(XPosList, Y, Diff),
    size(Diff, XD),
    X is XS - XD,
    X = 3.

winning_positions([1,2,3]).
winning_positions([4,5,6]).
winning_positions([7,8,9]).
winning_positions([1,4,7]).
winning_positions([2,5,8]).
winning_positions([3,6,9]).
winning_positions([1,5,9]).
winning_positions([3,5,7]).

%%%%%%%%%%%%%%%%%%%%

% para(F,F,F):- !.
% para(I,I,F):- 
%     I > F.
% para(C,I,F):-
%     I > F,
%     N is I-1,
%     para(C,N,F).

% write_line(C) :-
%     para(C1,C,1), write(*), fail.
% write_line(C).

pick_place(max, ['-'|T], ['x'|T]).
pick_place(min, ['-'|T], ['o'|T]).
pick_place(Player, [H|T1], [H|T2]) :- pick_place(Player, T1, T2).

tic_tac_toe_generator(Player, Board, Board, T, NewT) :- 
    x_positions(Board, 1, [], XPosList),
    o_positions(Board, 1, [], OPosList),
    empty_positions(Board, 1, [], EmptyPosList),
    (
        is_winning_state(XPosList) -> writeln('max won! :)'), nl; % player wins
        is_winning_state(OPosList) -> writeln('max lost! :('), nl; % opponent wins
        size(EmptyPosList, 0) -> writeln('velha! :|'), nl % tie
    ),
    append(T, [Player, Board], NewT),
    write('==============='), nl, print_board(Board), 
    !.

tic_tac_toe_generator(max, CurrBoard, FinalBoard, T, FinalT) :- 
    append(T, [max, CurrBoard], NewT),
    pick_place(max, CurrBoard, NewBoard),
    write('==============='), nl, print_board(NewBoard), 
    tic_tac_toe_generator(min, NewBoard, FinalBoard, NewT, FinalT).

tic_tac_toe_generator(min, CurrBoard, FinalBoard, T, FinalT) :- 
    append(T, [min, CurrBoard], NewT),
    pick_place(min, CurrBoard, NewBoard),
    write('==============='), nl, print_board(NewBoard),
    tic_tac_toe_generator(max, NewBoard, FinalBoard, NewT, FinalT).

print_board([]) :- write('==============='), nl, nl, !.
print_board([A, B, C | Board]) :-
    tab(2), write(A),
    write('  │ '),
    write(B),
    write(' │  '),
    write(C), nl,
    (Board \= [] ->
        write('─────┼───┼─────'), nl;
        true),
    print_board(Board).

run :-
    tic_tac_toe_generator(max, ['-','-','-','-','-','-','-','-','-'], B, [], T),
    write(T), nl.


% I still haven't been able to generate the max and mins tree in the
% correct format (e.g. line 17), which would be the input for the minimax/2 predicate.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://stackoverflow.com/questions/19917369/prolog-using-2-univ-in-a-recursive-way
% list_2_compound(L, T) :-
%     var(T) ->  L = [F|Fs], maplist(list_2_compound, Fs, Ts), T =.. [F|Ts]
%     ;   
%     atomic(T) ->  L = T
%     ;   
%     L = [F|Fs], T =.. [F|Ts], maplist(list_2_compound, Fs, Ts).
% list_2_compound(T, T).


    