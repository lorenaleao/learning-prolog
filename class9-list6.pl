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

% first version of bfs -- it doesn't work correctly

/*
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
*/

/* this one works! */
bfs([R|Subtrees]) :-
	write(R), nl,
	b(Subtrees, [], _).

/* b/3 simulates a loop so we don't need to do something like the following
 * manually:
 *
 * ?- a([[2, [4,[8,[],[11]],[9]],[5]],[3,[6,[10],[]],[7]]], [], R).  
 * 2
 * 3
 * R = [[4, [8, [], [11]], [9]], [5], [6, [10], []], [7]].
 * 
 * ?- R = [[2, [4,[8,[],[11]],[9]],[5]],[3,[6,[10],[]],[7]]], a(R, [], R1).
 * 2
 * 3
 * R = [[2, [4, [8, [], [11]], [9]], [5]], [3, [6, [10], []], [7]]],
 * R1 = [[4, [8, [], [11]], [9]], [5], [6, [10], []], [7]].
 *
 * ?- R1 = [[4, [8, [], [11]], [9]], [5], [6, [10], []], [7]], a(R1, [], R2).
 * 4
 * 5
 * 6
 * 7
 * R1 = [[4, [8, [], [11]], [9]], [5], [6, [10], []], [7]],
 * R2 = [[8, [], [11]], [9], [10], []].
 *
 * ?- R2 = [[8, [], [11]], [9], [10], []], a(R2, [], R3).
 * 8
 * 9
 * 10
 * []
 * R2 = [[8, [], [11]], [9], [10], []],
 * R3 = [[], [11]].
 *
 * ?- R3 = [[], [11]].
 * R3 = [[], [11]].
 *
 * ?- R3 = [[], [11]], a(R3, [], R4).
 * []
 * 11
 * R3 = [[], [11]],
 * R4 = [].
 *
 */
b([], _, _).
b(L, Acc, R) :-
	a(L, Acc, R),
	b(R, Acc, _).

/* a/3 writes in the screen the roots of the subtrees or the heads of the
 * sublists and returns the rest of the sublists 
 */
a([], RestAcc, RestAcc). 
a([L|R], RestAcc, Rest) :-
	L = [H|T] ->
		write(H), nl,
		append(RestAcc, T, RestT),
		a(R, RestT, Rest)
	;
	L = [] -> 
		write(L), nl, 
		a(R, RestAcc, Rest). 
