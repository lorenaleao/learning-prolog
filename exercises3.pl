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