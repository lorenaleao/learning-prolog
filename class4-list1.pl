all_occurrences(_, [], []).
all_occurrences(H, [H|T], [H|T1]) :- all_occurrences(H, T, T1).
all_occurrences(E, [H|T], L) :- E =\= H, all_occurrences(E, T, L).

frequency(_, [], 0).
frequency(H, [H|T], N) :- frequency(H, T, N1), N is 1 + N1.
frequency(E, [H|T], N) :- E =\= H, frequency(E, T, N).

size([], 0).
size([_|T], N) :- size(T, N1), N is 1 + N1.

frequency2(E, L, N) :- all_occurrences(E, L, Occurrences), size(Occurrences, N).

doesnt_occurr(_, [], []).
doesnt_occurr(H, [H|T], L) :- doesnt_occurr(H, T, L).
doesnt_occurr(E, [H|T], [H|T1]) :- E =\= H, doesnt_occurr(E, T, T1).

freq_doesnt_occurr(_, [], 0).
freq_doesnt_occurr(H, [H|T], N) :- freq_doesnt_occurr(H, T, N).
freq_doesnt_occurr(E, [H|T], N) :- E =\= H, freq_doesnt_occurr(E, T, N1), N is 1 + N1.

freq_doesnt_occurr1(E, L, N) :- doesnt_occurr(E, L, Diff), size(Diff, N).

measure :-
    statistics(walltime, [TimeSinceStart | [TimeSinceLastCall]]),
    alfametico3([S,E,I,T,V,N]),
    statistics(walltime, [NewTimeSinceStart | [ExecutionTime]]),
    write('Execution took '), write(ExecutionTime), write(' ms.'), nl.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alfametico without modifications
% Execution took 159 ms in average (I ran the program 5 times).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alfametico([S,E,I,T,V,N]):-
    unifica([0,1,2,3,4,5,6,7,8,9],[S,E,I,T,V,N]),
    V \= 0,
    1000*S + 100*E + 10*I + S +
    1000*S + 100*E + 10*T + E +
    1000*S + 100*E + 10*T + E =:=
    10000*V + 1000*I + 100*N + 10*T + E.

unifica(_,[]).
unifica(Num,[N|Vars]):-
    del(N,Num,NumSemN),
    unifica(NumSemN,Vars).

del(X,[X|Xs],Xs).
del(Xs,[Y|Ys],[Y|Zs]):-
    del(Xs,Ys,Zs).

roda([S,E,I,S],[S,E,T,E],[S,E,T,E],[V,I,N,T,E]):-
    alfametico([S,E,I,T,V,N]).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version 2: alfametico with V being picked up first
% Execution took 25,2 ms in average (i ran the program 5 times).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alfametico2([S,E,I,T,V,N]):-
    unifica([0,1,2,3,4,5,6,7,8,9],[V,S,E,I,T,N]),
    V \= 0,
    1000*S + 100*E + 10*I + S +
    1000*S + 100*E + 10*T + E +
    1000*S + 100*E + 10*T + E =:=
    10000*V + 1000*I + 100*N + 10*T + E.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version 3: version 1 of alfametico with V being either 1 or 2.
% Execution took 32,2 ms in average ( I ran the program 5 times).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

alfametico3([S,E,I,T,V,N]):-
    unifica([0,1,2,3,4,5,6,7,8,9],[V,S,E,I,T,N]),
    V \= 0,
    (V = 1; V = 2),
    1000*S + 100*E + 10*I + S +
    1000*S + 100*E + 10*T + E +
    1000*S + 100*E + 10*T + E =:=
    10000*V + 1000*I + 100*N + 10*T + E.

/* Picking up V first certainly helps in terms of runtime, 
but I'm not sure if we have a much better result limiting 
the range of solutions for variable V. */