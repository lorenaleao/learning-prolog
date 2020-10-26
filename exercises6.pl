% [1,[2,[4,[8,[],[11]],[9]],[5]],[3,[6,[10],[]],[7]]]

% 1
%  2
%   4
%    8
%     []
%     11
%    9
%   5
%  3
%   6
%    10
%    []
%   7

list([]).
list([_|T]) :- list(T).

mostra(Tree) :-
    show(0, Tree).

show(C, []) :-
    tab(C), write([]), nl.
show(C, [L]) :-
    tab(C), write(L), nl.
show(C, [R, LSubtree, RSubtree]) :-
    tab(C), write(R), nl,
    C1 is C + 1,  
    show(C1, LSubtree),
    show(C1, RSubtree).

prefix(Tree) :-
    prefix_visit(0, Tree).

% prefix_visit/2 is identical to show/2
prefix_visit(C, []) :-
    tab(C), write([]), nl.
prefix_visit(C, [L]) :-
    tab(C), write(L), nl.
prefix_visit(C, [R, LSubtree, RSubtree]) :-
    tab(C), write(R), nl,
    C1 is C + 1,  
    prefix_visit(C1, LSubtree),
    prefix_visit(C1, RSubtree).

infix(Tree) :-
    infix_visit(0, Tree).

infix_visit(C, []) :-
    tab(C), write([]), nl.
infix_visit(C, [L]) :-
    tab(C), write(L), nl.
infix_visit(C, [R, LSubtree, RSubtree]) :-
    C1 is C + 1, 
    infix_visit(C1, LSubtree),
    tab(C), write(R), nl, 
    infix_visit(C1, RSubtree).

posfix(Tree) :-
    posfix_visit(0, Tree).

posfix_visit(C, []) :-
    tab(C), write([]), nl.
posfix_visit(C, [L]) :-
    tab(C), write(L), nl.
posfix_visit(C, [R, LSubtree, RSubtree]) :-
    C1 is C + 1, 
    posfix_visit(C1, LSubtree),
    posfix_visit(C1, RSubtree),
    tab(C), write(R), nl.

% the dfs visits the tree nodes in the same way prefix does 
dfs([]) :-
    write([]), nl.
dfs([L]) :-
    write(L), nl.
dfs([R, LSubtree, RSubtree]) :-
    write(R), nl,  
    dfs(LSubtree),
    dfs(RSubtree).

% the bfs is not working correctly yet
bfs([]) :-
    write([]), nl.
bfs([R, LSubtree, RSubtree | T]) :-
    write(R), nl,
    append(LSubtree, RSubtree, Subtree),
    append(T, Subtree, NewTree),
    bfs(NewTree).
bfs([L | T]) :-
    write(L), nl, 
    bfs(T).