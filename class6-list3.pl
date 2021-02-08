:-dynamic(letra/2).
:-dynamic(var_count/2).

conta2(_,[],0).
conta2(A,[B|L],C):-
    A == B,
    conta2(A,L,C1),
    C is C1 + 1.
conta2(A,[_|L],C):-
conta2(A,L,C).

conta3(_,[],0).
conta3(A,[B|L],C):-
    A == B, !,
    conta3(A,L,C1),
    C is C1 + 1.
conta3(A,[_|L],C):-
    conta3(A,L,C).

conta4(_,[],0).
conta4(A,[B|L],C):-
(
    atom(B), % atomic/2 não rejeita inteiros ou float
    A = B, !, % usar a unificação não é uma boa ideia
    conta4(A,L,C1),
    C is C1 + 1
    ;
    conta4(A,L,C)
).

% executions:

% ?- conta4(a, [b,a,X,Y,a,c],C).
% C = 2 ;
% false.

% ?- conta3(a, [b,a,X,Y,a,c],C).
% C = 2 ;
% false.

% ?- conta2(a, [b,a,X,Y,a,c],C).
% C = 2 ;
% C = 1 ;
% C = 1 ;
% C = 0 ;
% false.

/* substituir(+Subtermo,+Termo,+Subtermo1,-Termo1) é verdade sse todas
ocorrências de Subtermo em Termo são substituídas por Subtermo1,
unificando Termo1 com Termo substituído com Subtermo1. */
substituir(Termo,Termo,Termo1,Termo1):- !.
substituir(_,Termo,_,Termo):-
    atomic(Termo),!.
substituir(Sub,Termo,Sub1,Termo1):-
    Termo =.. [F|Args],
    subst_lista(Sub,Args,Sub1,Args1),
    Termo1 =.. [F|Args1].

/* subst_lista(+Subtermo,+Lista,+Subtermo1,-Lista1) é verdade sse todas
ocorrências de Subtermo em Lista são substituídos por Subtermo1
unificando Lista1 com o resulta da substituição. */
subst_lista(_,[],_,[]):- !.
subst_lista(Sub,[Termo|Termos],Sub1,[Termo1|Termos1]):-
    substituir(Sub,Termo,Sub1,Termo1),
    subst_lista(Sub,Termos,Sub1,Termos1).

% execution:

% [trace]  ?- substituir(sin(x),2*sin(x)*f(sin(x)),t,F).
%    Call: (10) substituir(sin(x), 2*sin(x)*f(sin(x)), t, _13116) ? creep
%    Call: (11) 2*sin(x)*f(sin(x))=..[_13558|_13560] ? creep
%    Exit: (11) 2*sin(x)*f(sin(x))=..[*, 2*sin(x), f(sin(x))] ? creep
%    Call: (11) subst_lista(sin(x), [2*sin(x), f(sin(x))], t, _13722) ? creep
%    Call: (12) substituir(sin(x), 2*sin(x), t, _13708) ? creep
%    Call: (13) 2*sin(x)=..[_13758|_13760] ? creep
%    Exit: (13) 2*sin(x)=..[*, 2, sin(x)] ? creep
%    Call: (13) subst_lista(sin(x), [2, sin(x)], t, _13922) ? creep
%    Call: (14) substituir(sin(x), 2, t, _13908) ? creep
%    Exit: (14) substituir(sin(x), 2, t, 2) ? creep
%    Call: (14) subst_lista(sin(x), [sin(x)], t, _13910) ? creep
%    Call: (15) substituir(sin(x), sin(x), t, _14046) ? creep
%    Exit: (15) substituir(sin(x), sin(x), t, t) ? creep
%    Call: (15) subst_lista(sin(x), [], t, _14048) ? creep
%    Exit: (15) subst_lista(sin(x), [], t, []) ? creep
%    Exit: (14) subst_lista(sin(x), [sin(x)], t, [t]) ? creep
%    Exit: (13) subst_lista(sin(x), [2, sin(x)], t, [2, t]) ? creep
%    Call: (13) _13708=..[*, 2, t] ? creep
%    Exit: (13) 2*t=..[*, 2, t] ? creep
%    Exit: (12) substituir(sin(x), 2*sin(x), t, 2*t) ? creep
%    Call: (12) subst_lista(sin(x), [f(sin(x))], t, _13710) ? creep
%    Call: (13) substituir(sin(x), f(sin(x)), t, _14504) ? creep
%    Call: (14) f(sin(x))=..[_14554|_14556] ? creep
%    Exit: (14) f(sin(x))=..[f, sin(x)] ? creep
%    Call: (14) subst_lista(sin(x), [sin(x)], t, _14712) ? creep
%    Call: (15) substituir(sin(x), sin(x), t, _14698) ? creep
%    Exit: (15) substituir(sin(x), sin(x), t, t) ? creep
%    Call: (15) subst_lista(sin(x), [], t, _14700) ? creep
%    Exit: (15) subst_lista(sin(x), [], t, []) ? creep
%    Exit: (14) subst_lista(sin(x), [sin(x)], t, [t]) ? creep
%    Call: (14) _14504=..[f, t] ? creep
%    Exit: (14) f(t)=..[f, t] ? creep
%    Exit: (13) substituir(sin(x), f(sin(x)), t, f(t)) ? creep
%    Call: (13) subst_lista(sin(x), [], t, _14506) ? creep
%    Exit: (13) subst_lista(sin(x), [], t, []) ? creep
%    Exit: (12) subst_lista(sin(x), [f(sin(x))], t, [f(t)]) ? creep
%    Exit: (11) subst_lista(sin(x), [2*sin(x), f(sin(x))], t, [2*t, f(t)]) ? creep
%    Call: (11) _13116=..[*, 2*t, f(t)] ? creep
%    Exit: (11) 2*t*f(t)=..[*, 2*t, f(t)] ? creep
%    Exit: (10) substituir(sin(x), 2*sin(x)*f(sin(x)), t, 2*t*f(t)) ? creep
% F = 2*t*f(t).

tabuadas:-
    L = [0,1,2,3,4,5,6,7,8,9],
    member(X,L),
    member(Y,L),
    Z is X*Y,
    assertz(produto(X,Y,Z)),
    fail.
tabuadas :- !.

repete.
repete :- repete.

ecoa:-
    repete,
    read(X),
    ( X == pare,!
    ; write(X),nl,
    fail
    ).

letra(a,vogal).
letra(b,cons).
letra(c,cons).
letra(c,cons).
letra(d,cons).
letra(e,vogal).
letra(f,cons).
letra(f,cons).
letra(f,cons).
letra(f,cons).
letra(g,cons).
letra(g,cons).
letra(g,cons).
letra(h,cons).
letra(h,cons).
letra(i,vogal).
letra(i,vogal).
letra(i,vogal).
letra(o,vogal).
letra(u,vogal).
letra(u,vogal).

find_vowels :-
    bagof(Letra,letra(Letra,vogal),Letras),
    write(Letras), nl.

find_all_letters_0 :- 
    bagof(Letra,letra(Letra,_),Letras),
    write(Letras), nl.

% ?- find_all_letters_0.
% [b,c,c,d,f,f,f,f,g,g,g,h,h]
% true ;
% [a,e,i,i,i,o,u,u]
% true.

% Mas o resultado não foi o que esperávamos, pois as soluções
% foram dadas pela volta para trás, separadas para cada valor da
% variável ignorada.
% Para evitar isso, utilizamos o operador ^/2, de quantificação
% existencial, juntamente com a(s) variável(is) que queremos
% ignorar, justapostos ao Padrão:

find_all_letters_1 :-
    bagof(Letra,Tipo^letra(Letra,Tipo),Letras),
    write(Letras), nl.

% ?- find_all_letters_1.
% [a,b,c,c,d,e,f,f,f,f,g,g,g,h,h,i,i,i,o,u,u]
% true.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Exercises %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* simplify/2 
 * ?- simplify(1+1, E).
 * E = 2.
 *
 * ?- simplify(1+1+4+3, E).
 * E = 9.
 *
 * ?- simplify(a+1+1+4+3, E).
 * E = 9+a.
 *
 * ?- simplify(a+1+1+4+b+3, E).
 * E = 9+(a+b).
 *
 * ?- simplify(a+1+1+4+b+o+3, E).
 * E = 9+(a+(b+o)).
 *
 * ?- simplify(a+1+g+1+4+b+o+3, E).
 * E = 9+(a+(g+(b+o))).
 * */

make_sum_expr([A], E) :- 
	(var_count(A, C) -> 
	 	E = C*A
	;
		E = A
	), !.
make_sum_expr([A, B], E) :- 
	make_sum_expr([A], E1),
	make_sum_expr([B], E2), 
	E = E1 + E2, !.
make_sum_expr([H|T], Expr) :-
	make_sum_expr(T, ExprT),
	make_sum_expr([H], E1),
	append([+],[E1], L1),
	append(L1, [ExprT], L2),
	Expr =.. L2.

simplify(A, Expr) :-
	assertz(var_count(1, 0)), % just add this procedure so we don't get an error in simplify_list
	atom(A) -> Expr = A, !;
	integer(A) -> Expr = A, !;
	simplify(A, Expr, [], VarList, 0, Sum),
	% write(VarList), nl,
	retractall(var_count(_, _)),
	abolish(var_count/2).

simplify(H, SimplExpr, VarListAcc, VarList, SumAcc, Sum) :-
	integer(H) -> Sum is SumAcc + H, VarList = VarListAcc, append([Sum], VarList, ExprList), make_sum_expr(ExprList, SimplExpr), !;
	atom(H) -> 
		Sum = SumAcc,
		(var_count(H, C) ->
			C1 is C + 1,
			retract(var_count(H, C)),
			assertz(var_count(H, C1)),
			append([Sum], VarListAcc, ExprList),
			VarList = VarListAcc
		;
			assertz(var_count(H, 1)),
			append([H], VarListAcc, VarList),
			append([Sum], VarList, ExprList)
		),
		make_sum_expr(ExprList, SimplExpr), !.

simplify(Expr, SimplExpr, VarListAcc, VarList, SumAcc, Sum) :-
	Expr =.. [F|Args],
	simplify_list(Args, SimplExpr, VarListAcc, VarList, SumAcc, Sum).

simplify_list([H,T], SimplExpr, VarListAcc, VarList, SumAcc, Sum) :-
	integer(T) -> 
		SumAcc1 is SumAcc + T, 
		simplify(H, SimplExpr, VarListAcc, VarList, SumAcc1, Sum)
	;
		atom(T) -> 
			(var_count(T, C) -> 
				C1 is C + 1, 
				retract(var_count(T, C)),
				assertz(var_count(T, C1)), 
				simplify(H, SimplExpr, VarListAcc, VarList, SumAcc, Sum)
			;
				assertz(var_count(T, 1)),
				append([T], VarListAcc, VarListAcc1), 
				simplify(H, SimplExpr, VarListAcc1, VarList, SumAcc, Sum)
			).

% Fail attempts

% insere_li(Item, [L|X]) :- X = [Item|Y].
% insere_li(Item, [L|X]) :- append(IL, [Item|Y], IL).
% insere_li(Item, [L|X]).
% insere_li(Item, [_|X]) :- =(X, [Item|_]).

% [trace]  ?- LI = [a,b,c|Y], insere_li(d, LI).
%    Call: (11) _13966=[a, b, c|_13962] ? creep
%    Exit: (11) [a, b, c|_13962]=[a, b, c|_13962] ? creep
%    Call: (11) insere_li(d, [a, b, c|_13962]) ? creep
%    Call: (12) [b, c|_13962]=[d|_14626] ? creep
%    Fail: (12) [b, c|_13962]=[d|_14626] ? creep
%    Fail: (11) insere_li(d, [a, b, c|_13962]) ? creep
% false.

% The problem is that Prolog considers _ as just the head of the list 
% and not the entire list without the logic variable :/ 
% How do I represent that -- a general incomplete list?
% Maybe this could be easir done with difference lists?!
% But we can also traverse the list and insert the item in the end:

insert_il(X, L) :- 
    var(L), !, L = [X|_]. %found end of list, add element
insert_il(X, [_|T]):- insert_il(X, T). % traverse input list to reach end/X

% ?- LI = [a,b,c|Y], insert_il(d, LI).
% LI = [a, b, c, d|_6668],
% Y = [d|_6668].

aterrado(Term) :-
    Term =.. [F|Args],
    atom(F),
    aterrado_list(Args).

aterrado_list([]).
aterrado_list([H|T]) :-
    \+ var(H),
    H =.. [F|Args],
    atom(F),
    aterrado_list(Args).

subsume(Term1,Term2) :- unifiable(Term1, Term2, _).

delete_tabuada :-
    abolish(produto/3).

delete_0_tabuada :-
    L = [1,2,3,4,5,6,7,8,9],
    member(Y,L),
    retract(produto(0,Y,0)),
    fail.
delete_0_tabuada :-
    L = [1,2,3,4,5,6,7,8,9],
    member(X,L),
    retract(produto(X,0,0)),
    fail.
delete_0_tabuada :-
    retract(produto(0,0,0)).

my_copy_term(Term, Copy) :-
    var(Term) -> var(Copy).
my_copy_term(Term, Copy) :-
    Term =.. [F|Args],
    R =.. Args,
    my_copy_term(R, CopyR),
    CopyR =.. L,
    Copy =.. [F|L].

% my_copy_term(Term, Copy) :-
%     Copy = Term,
%     retract(Term),
%     asserta(Copy).

% copy_term(In, Out)

% :- dynamic insect/1.
% insect(ant).
% insect(bee).

% ?- (   retract(insect(I)),
%        writeln(I),
%        retract(insect(bee)),
%        fail
%        ;   true
%     ).
%     ant ;
%     bee.

% subset(Set, SubsetsList) :-
%     bagof(, SubsetsList).

bratko_copy_term(Term,Copy):-
    bagof(X,X=Term,[Copy]).

% Some executions:

% ?- bratko_copy_term(f(Y), Copy).
% Copy = f(Y).

% ?- bratko_copy_term(a, Copy).
% Copy = a.

% ?- bratko_copy_term(X, Copy).
% X = Copy.

% ?- bratko_copy_term(f(a, Y), Copy).
% Copy = f(a, Y).

%%%%

% this is not correct yet:
% correct_bratko_copy_term(Term,Copy):-
%     bagof(X,Term^X=Term,[Copy]).

% [trace]  ?- correct_bratko_copy_term(f(a, Y), Copy).
%    Call: (10) correct_bratko_copy_term(f(a, _73232), _73238) ? creep
% ^  Call: (11) bagof(_73698, f(a, _73232)^_73698=f(a, _73232), [_73238]) ? creep
% ^  Fail: (11) bagof(_73698, user:(f(a, _73232)^_73698=f(a, _73232)), [_73238]) ? creep
%    Fail: (10) correct_bratko_copy_term(f(a, _73232), _73238) ? creep
% false.

% [trace]  ?- bratko_copy_term(f(a, Y), Copy).
%    Call: (10) bratko_copy_term(f(a, _74632), _74638) ? creep
% ^  Call: (11) bagof(_75098, _75098=f(a, _74632), [_74638]) ? creep
% ^  Exit: (11) bagof(_75098, user:(_75098=f(a, _74632)), [f(a, _74632)]) ? creep
%    Exit: (10) bratko_copy_term(f(a, _74632), f(a, _74632)) ? creep
% Copy = f(a, Y).

findall_copy_term(Term, Copy) :-
    findall(X,X=Term,[Copy]).

para(F,F,F):- !.
para(I,I,F):- 
    I < F.
para(C,I,F):-
    I < F,
    N is I+1,
    para(C,N,F).

write_line(C) :-
    para(C1,1,C), write(*), fail.
write_line(C).

triangle(N) :-
    para(C,1,N), S is N-C, tab(S), 
    A is 2*C-1, write_line(A),
    tab(S),
    nl, fail.
triangle(N).
    
