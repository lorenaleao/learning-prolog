$\forall$
$\neg$
$\rightarrow$
$\leftrightarrow$
$\vee$
$\wedge$
$\vdash$
$\dashv$

Predicate Logic 	
$\land$
$\forall$
$\exists$
$\in$
$\models$

### Class #13 - List #10

#### 1. Traduza as seguintes frases para lógica de 1ª ordem:

##### 1.1. João é mais baixo que Maria.

$altura(João, X)$ $\land$ $altura(Maria, Y)$ $\land$ $X < Y$

##### 1.2. Maria é mais alta que João.

$altura(João, X)$ $\land$ $altura(Maria, Y)$ $\land$ $Y > X$

##### 1.3. Ninguém é mais alto que José.

$\forall$ $P$ $altura(P, X)$ $\land$ $altura(José, Y)$ $\land$ $Y > X$


##### 1.4. Tanto Maria, quanto Fábio são mais altos que João.

$altura(Maria, M)$ $\land$ $altura(Fábio, F)$ $\land$ $altura(João, J)$ $\land$ $M > J$ $\land$ $F > J$

##### 1.5. Para todo X e Y, se X é mais alto que Y, então Y é mais baixo que X.

$\forall$ $X, Y \quad mais\_alto\_que(X,Y)$ $\rightarrow$ $mais\_baixo\_que(Y,X)$

> $mais\_alto\_que(X, Y)$ é uma representação para dizer "$X$ é mais alto que $Y$" e $mais\_baixo\_que(X, Y)$ é uma representação para dizer "$X$ é mais baixo que $Y$".

##### 1.6. “Mais baixo que” é transitiva.

$mais\_baixo\_que(X, Y)$ $\land$ $mais\_baixo\_que(Y, Z) \quad$ $\rightarrow$ $\quad mais\_baixo\_que(X,Z)$ 

#### 2. Traduza as seguintes sentenças para a lógica de 1ª ordem:

##### 2.1. Você pode enganar algumas pessoas todo o tempo e todas as pessoas por algum tempo, mas você não pode enganar todas as pessoas todo o tempo.

$\forall$ $Tempo$ $\exists$ $Pessoa$ $você\_engana(Pessoa, Tempo)$ $\land$ $\forall$ $Pessoa$ $\exists$ $Tempo$ $você\_engana(Pessoa, Tempo)$ $\land$ $\neg$$($$\forall$ $Pessoa$ $\forall$ $Tempo$ $você\_engana(Pessoa, Tempo)$$)$

##### 2.2. Uma maçã todo dia, mantém o médico longe.

$\forall$ $Dia$ $come\_maçã(Pessoa, Dia)$ $\rightarrow$ $não\_precisa\_médico(P)$

#### 3. Prove que, para qualquer sentença $p$ e objeto $a$, $\forall$ $X$ $p(X)$ $\vDash$ $p(a)$. Em que circunstâncias é verdade que $p(a)$ $\vDash$ $\forall$ $X$ $p(X)$?

$\forall$ $X$ $p(X)$  $\equiv$ $p(X_{0})$ $\land$ $p(X_{1})$ $\land$ $p(X_{2})$ $...$ $\land$ $p(X_{n})$. Como $p$ é verdade para qualquer $X$, $X$ pode ser o objeto $a$, isto é, $a$ é uma instância de $X$. Então, $p(a)$ é verdade e é uma consequência lógica de $\forall$ $X$ $p(X)$.

$p(a)$ $\vDash$ $\forall$ $X$ $p(X)$ é verdade se $X = {a}$, isto é, se $X$ só puder assumir o valor $a$.

<!-- 
Exemplo: p ∧ (p → q)  q. Se p ∧ (p → q) é V em M, então
p é V em M e p → q é V em M. Logo, q é V em M. Pela
definição de consequência lógica, p ∧ (p → q)  q. -->

#### 4. Prove ou disprove que, para toda sentença $p$:

##### 4.1. $\forall$ $X$ $p(X)$ $\vDash$ $\exists$ $X$ $p(X)$. 

Se para todo $X$, $p$ é verdade, então é verdade também que existe pelo menos um $X$ para o qual $X$ é verdade.

##### 4.2. $\exists$ $X$ $p(X)$ $\vDash$ $\forall$ $X$ $p(X)$.

A afirmação acima não é necessariamente verdadeira. $\exists$ $X$ $p(X)$  $\equiv$ $p(X_{0})$ $\vee$ $p(X_{1})$ $\vee$ $p(X_{2})$ $...$ $\vee$ $p(X_{n})$. Para $\exists$ $X$ $p(X)$ ser verdade apenas uma dessas sentenças deve ser verdade. Por isso, não podemos concluir $\forall$ $X$ $p(X)$ a partir de $\exists$ $X$ $p(X)$.

#### 5. Seja $M$ um modelo, e $p$ qualquer sentença da lógica de 1ª ordem. Mostre que ou $p$ é válida em $M$, ou $\neg$ $p$ é válida em $M$.

Seja $M$ um modelo que contém $p$, isto é, $p$ $\in$ $M$. Pela definição de modelo, $p$ é verdade, portanto. Dessa forma, $\neg$ $p$ é falso, isto é, $\neg$ $p$ $\equiv$ $\neg$ $V$ $\equiv$ $F$. 

Seja $M$ um modelo que não contém $p$, isto é, $p$ $\notin$ $M$. Pela definição de modelo, $p$ é falso, portanto. Dessa forma, $\neg$ $p$ é verdade, isto é, $\neg$ $p$ $\equiv$ $\neg$ $F$ $\equiv$ $V$. 


> **Definição de modelo:** Um subconjunto $M$ $\subset$ $A$, onde $A$ é o conjunto de todos os literais da linguagem, é um modelo, se os literais de $M$ são verdadeiros e os que não pertencem ao subconjunto $M$ são falsos.

#### 6. Seja $F$ uma sentença que é válida em modelo nenhum.

##### 6.1. Mostre que $F$ $\vDash$ $p$, para qualquer sentença $p$.

Como $F$ não pertence a nenhum modelo, $F$ é falsa. Como o antecedente é falso, o consequente é verdadeiro por vacuidade.

$P$ | $Q$ | $P$ $\rightarrow$ $Q$
:---: | :---: | :---: 
V | V | V
V | F | F
F | V | V
F | F | V

##### 6.2. Dê um exemplo de uma sentença $F$ com esta propriedade.

##### 7. Prove as seguintes sentenças:

##### 7.1. $p$ $\vDash$ $q$ é equivalente a $\vDash$ $p$ $\rightarrow$ $q$.
##### 7.2. $\vDash$ $($$p$ $\rightarrow$ $q$$)$ $\vee$ $($$\neg$ $p$ $\rightarrow$ $q$$)$. Isso significa que, ou $p$ $\vDash$ $q$ é válido, ou $\neg$ $p$ $\vDash$ $q$ é válido sempre?
