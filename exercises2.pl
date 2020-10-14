mescla(Xs,[],Xs). % 1
mescla([],Ys,Ys). % 2
mescla([X|Xs],[Y|Ys],[X|Zs]):- % 3
    X < Y, % 3.1
    mescla(Xs,[Y|Ys],Zs). % 3.2
mescla([X|Xs],[Y|Ys],[X,Y|Zs]):- % 4
    X =:= Y, % 4.1
    mescla(Xs,Ys,Zs). % 4.2
mescla([X|Xs],[Y|Ys],[Y|Zs]):- % 5
    X > Y, % 5.1
    mescla([X|Xs],Ys,Zs). % 5.2

/* mescla(Xs,[],Xs).*/
mescla1(As,Bs,Cs):- Bs = [], Cs = As.
/* mescla([],Ys,Ys).*/
mescla1(As,Bs,Cs):- As = [], Cs = Bs.
/* mescla([X|Xs],[Y|Ys],[X|Zs]):- */
mescla1(As,Bs,Cs):-
    As = [X|Xs], Bs = [Y|Ys], Cs = [X|Zs],
    X < Y, mescla1(Xs,Bs,Zs).
/* mescla([X|Xs],[Y|Ys],[X,Y|Zs]):- */
mescla1(As,Bs,Cs):- 
    As = [X|Xs], Bs = [Y|Ys],
    Cs = [X,Y|Zs],
    X == Y, mescla1(Xs,Ys,Zs).
/* mescla([X|Xs],[Y|Ys],[Y|Zs]):- */
mescla1(As,Bs,Cs):-
    As = [X|Xs], Bs = [Y|Ys], Cs = [Y|Zs],
    X > Y, mescla1(As,Ys,Zs).


mescla2(As,Bs,Cs):-
    ( 
        Bs = [] -> % cláusula 1
        Cs = As
        ; 
        ( 
            As = [] -> % cláusula 2
            Cs = Bs
            ; 
            As = [X|Xs], Bs = [Y|Ys], % parâmetros comuns às cláusulas 3,4 e 5
            ( 
                X < Y -> % cláusula 3
                Cs = [X|Zs],
                mescla2(Xs,Bs,Zs)
                ; 
                (
                    X == Y -> % cláusula 4
                    Cs = [X,Y|Zs],
                    mescla2(Xs,Ys,Zs)
                    ; 
                    Cs = [Y|Zs], % cláusula 5
                    mescla2(As,Ys,Zs)
                )
            )
        )
    ).

max(X,Y,X):- X > Y,!.
max(X,Y,Y):- X =< Y.

% max1 - wrong max rule
max1(X,Y,X):- X > Y,!.
max1(X,Y,Y).

% fixed max
max2(X,Y,Z):-
    ( X > Y, !,
    Z = X
    ;
    Z = Y).

add2(E,[],[E]):- !.
add2(E,[E|L],[E|L]):- !.
add2(E,[X|L],[X|R]):-
add2(E,L,R).

para(F,F,F):- !.
para(I,I,F):-
    I < F.
para(C,I,F):-
    I < F,
    N is I+1,
    para(C,N,F).

mostra(I,F):-
    para(C,I,F),
    write(C), nl,
    fail.
    
% % % % % % % 
% exercises %
% % % % % % %

p(1).
p(2) :- !.
p(3).

% 1.1. |?- p(X). X = 1; X = 2.
% 1.2. |?- p(X),p(Y). What I thought at first that would be the answer: X = 1; X = 2, but the answer is:
    % ?- p(X), p(Y).
    % X = Y, Y = 1 ;
    % X = 1,
    % Y = 2 ;
    % X = 2,
    % Y = 1 ;
    % X = Y, Y = 2.
% 1.3. |?- p(X),!,p(Y). What I thought at first that would be the answer: X = 1, Y = 2, but the answer is:
    % ?- p(X), !, p(Y).
    % X = Y, Y = 1 ;
    % X = 1,
    % Y = 2.

class(Int, Class) :- 
    (
        Int > 0, Class = positivo;
        Int =:= 0, Class = zero;
        Int < 0, Class = negativo
    ).

% the efficient version
class1(Int, Class) :- 
    (
        Int > 0 -> Class = positivo;
        Int =:= 0 -> Class = zero;
        Int < 0 -> Class = negativo
    ).

separate([], [], []).
separate([H|T], Pos, Neg) :- 
    class1(H, positivo), Pos = [H|P1], separate(T, P1, Neg).
separate([H|T], Pos, Neg) :- 
    class1(H, zero), Pos = [H|P1], separate(T, P1, Neg).
separate([H|T], Pos, Neg) :- 
    class1(H, negativo), Neg = [H|N1], separate(T, Pos, N1).

separate1([], [], []) :- !.
separate1([H|T], Pos, Neg) :- 
    (
        class1(H, positivo) -> Pos = [H|P1], separate1(T, P1, Neg);
        class1(H, zero) -> Pos = [H|P1], separate1(T, P1, Neg);
        class1(H, negativo) -> Neg = [H|N1], separate1(T, Pos, N1)
    ).

separate2(Int, Pos, Neg) :- 
    (
        Int = [] -> Pos = [], Neg = [];
        Int = [H|T],
        (
            class1(H, positivo) -> 
                Pos = [H|P1], separate2(T, P1, Neg)
                ;
            (
                class1(H, zero) -> 
                    Pos = [H|P1], separate2(T, P1, Neg)
                    ;
                    Neg = [H|N1], separate2(T, Pos, N1)
            )
        )
    ).

class2(Int, Class) :- 
    (
        Int >= 0 -> Class = positivo;
        Int < 0 -> Class = negativo
    ).

separate3(Int, Pos, Neg) :- 
    (
        Int = [] -> Pos = [], Neg = [];
        Int = [H|T],
        (
            class2(H, positivo) -> 
                Pos = [H|P1], separate3(T, P1, Neg)
                ;
                Neg = [H|N1], separate3(T, Pos, N1)
        )
    ).
