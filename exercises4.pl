:- dynamic(fib1/2).

% without Tail Recursion Optimization (TRO):

tam1([],0).
tam1([_|T],L) :-
    tam1(T,L1),
    L is L1 + 1.

% with TRO:

tam2([],N,N).
tam2([_|T],Acum,N):-
    Acum1 is Acum + 1,
    tam2(T,Acum1,N).

tam2(L,N):-
    tam2(L, 0 ,N).

conc([], L, L).
conc([H|T1], L2, [H|T2]) :- conc(T1, L2, T2).

% without TRO
inv1([],[]).
inv1([X|Xs],Ys) :-
    inv1(Xs,XsI),
    conc(XsI,[X],Ys).

% with TRO
inv([],Acum,Acum).
inv([X|Xs],Acum,Ys):-
    inv(Xs,[X|Acum],Ys).

conc_dl(A-B,B-C,A-C).

% ?- conc_dl([1,2,3|X]-X,[4,5|Y]-Y,L).
% X = [4, 5|Y],
% L = [1, 2, 3, 4, 5|Y]-Y.

% ?- conc_dl([1,2,3|X]-X,[4,5|Y]-Y,L-[]).
% X = [4, 5],
% Y = [],
% L = [1, 2, 3, 4, 5].

quicksort([ ],[ ]).
quicksort([X|Xs],O):-
    particiona(X,Xs,Menores,Maiores),
    quicksort(Menores,MenoresO),
    quicksort(Maiores,MaioresO),
    conc(MenoresO,[X|MaioresO],O).

particiona(_,[ ],[ ],[ ]).
particiona(X,[Y|Ys],[Y|Menores],Maiores):-
    X>Y, !,
    particiona(X,Ys,Menores,Maiores).
particiona(X,[Y|Ys],Menores,[Y|Maiores]):-
    particiona(X,Ys,Menores,Maiores).

% Versão com diferença de listas
quicksort1(L,O):- qsort1(L,O-[]).

qsort1([],Z-Z).

qsort1([X|Xs],A1-Z):-
    particiona(X,Xs,Menores,Maiores),
    qsort1(Menores,A1-[X|A2]),
    qsort1(Maiores,A2-Z).

% Versão com acumulador:
quicksort2(L,O):- qsort2(L,[],O).

qsort2([],Ac,Ac).
qsort2([X|Xs],Ac,O):-
    particiona(X,Xs,Menores,Maiores),
    qsort2(Maiores,Ac,MaioresO),
    qsort2(Menores,[X|MaioresO],O).

% Graph/Map Coloring Problem

% Part of Europe:

viz(andorra,[franca,espanha]).
viz(portugal, [espanha]).
viz(espanha, [portugal, franca, andorra]).
viz(franca, [andorra, espanha, italia, alemanha, belgica, luxemburgo, suica]).
viz(italia, [franca, suica]).
viz(alemanha, [holanda, belgica, luxemburgo, suica, franca, dinamarca]).
viz(suica, [alemanha, italia, franca]).
viz(luxemburgo, [belgica, franca, alemanha]).
viz(belgica, [holanda, alemanha, franca, luxemburgo]).
viz(holanda, [belgica, alemanha]).
viz(dinamarca, [alemanha]).

cores([]).
cores([Pais/Cor|Outros]):-
    cores(Outros),
    member(Cor,[amarelo,azul,vermelho,verde]),
    \+ (member(Pais1/Cor,Outros), vizinho(Pais,Pais1)).

vizinho(Pais,Pais1):-
    viz(Pais,Vizinhos),
    member(Pais1,Vizinhos).

color_map() :- 
    findall(Pais/Cor,viz(Pais,_),ListaPaisCor),
    cores(ListaPaisCor),
    write(ListaPaisCor), nl.


% execution:

% findall(Pais/Cor,viz(Pais,_),ListaPaisCor),
% cores(ListaPaisCor).
% ListaPaisCor = [albania/amarelo, andorra/amarelo, austria/amarelo] ;
% ListaPaisCor = [albania/azul, andorra/amarelo, austria/amarelo] ;
% ListaPaisCor = [albania/vermelho, andorra/amarelo, austria/amarelo] ;
% ListaPaisCor = [albania/verde, andorra/amarelo, austria/amarelo] ;
% ListaPaisCor = [albania/amarelo, andorra/azul, austria/amarelo] ;
% ListaPaisCor = [albania/azul, andorra/azul, austria/amarelo] ;
% ListaPaisCor = [albania/vermelho, andorra/azul, austria/amarelo] ;
% ListaPaisCor = [albania/verde, andorra/azul, austria/amarelo] .

fib(1,1).
fib(2,1).
fib(N,F):-
    N > 2,
    N1 is N-1,
    fib(N1,F1),
    N2 is N1-1,
    fib(N2,F2),
    F is F1+F2.

fib1(1,1).
fib1(2,1).
fib1(N,F):-
    N > 2,
    N1 is N-1,
    fib1(N1,F1),
    N2 is N1-1,
    fib1(N2,F2),
    F is F1+F2,
    asserta(fib1(N,F)).

fib2(N,F):-
    fib3(2,N,F1,F2,F).
fib3(M,N,_,F2,F2):-
    M >= N.
fib3(M,N,F1,F2,F):-
    M < N,
    ProxM is M+1,
    ProxF2 is F1+F2,
    fib3(ProxM,N,F2,ProxF2,F).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Exercises %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

add_to_the_end(A-B, Item, NewDifList) :- conc_dl(A-B, [Item|Y]-Y, NewDifList).

inv2(L,I):- inv3(L,I-[]).

inv3([],L-L).
inv3([X|Xs],Ys-Y) :-
    inv3(Xs,Ys-[X|Yz]),
    conc_dl(Ys-[X|Yz],[X|Y]-Y,Ys-Y).

faz_lista(Lista):-
    coleta([franca],[],Lista).
    /* coleta(+Abertos,+Fechados,?Lista) é verdade sse Lista é instanciada
    com a lista de todos os nós de um grafo cíclico definido por viz/2.
    Abertos contém um nó inicial. Fechados contém os nós já coletados.
    */
    coleta([],Fechados,Fechados).
    coleta([No|Abertos],Fechados,Lista):-
    member(No,Fechados),!,
    coleta(Abertos,Fechados,Lista).
    coleta([No|Abertos],Fechados,Lista):-
    viz(No,Vizs),
    conc(Vizs,Abertos,VAbertos),
    coleta(VAbertos,[No|Fechados],Lista).

color_map_2 :-
    faz_lista(L),
    cores(L),
    write(L).

max(X,Y,Z):- ( 
    X > Y ->
    Z = X 
    ;
    Z = Y
).

list_max([], 0). 
list_max([H|T], Max) :- list_max(T, TMax), max(H, TMax, Max).

list_max1([], Acum, Acum).
list_max1([H|T], Acum, Max) :- Acum1 is max(Acum, H), list_max1(T, Acum1, Max).

% list_max with difference lists????


measure_color_map :-
    statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
    color_map(),
    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
    write('Color Map -- Execution took '), write(ExecutionTime), write(' ms.'), nl.

measure_faz_lista :-
    statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
    faz_lista(Lista),
    write(Lista),
    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
    write('Faz Lista -- Execution took '), write(ExecutionTime), write(' ms.'), nl.
