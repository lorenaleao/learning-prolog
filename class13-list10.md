<!-- $\forall$
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
$\models$ -->

### Class #13 - List #10

#### 1. Traduza as seguintes frases para lógica de 1ª ordem:

##### 1.1. João é mais baixo que Maria.

$altura(João, X), altura(Maria, Y), X < Y.$

##### 1.2. Maria é mais alta que João.

$altura(João, X), altura(Maria, Y), Y > X.$

##### 1.3. Ninguém é mais alto que José.

$\forall$ $P, altura(P, X), altura(José, Y), Y > X.$


##### 1.4. Tanto Maria, quanto Fábio são mais altos que João.

$altura(Maria, M), altura(Fábio, F), altura(João, J), M > J, F > J.$

##### 1.5. Para todo X e Y, se X é mais alto que Y, então Y é mais baixo que X.

$\forall$ $X, Y \quad X > Y$ $\rightarrow$ $Y < X.$

##### 1.6. “Mais baixo que” é transitiva.

$X > Y, Y > Z \quad$ $\rightarrow$ $\quad X > Z.$

#### 2. Traduza as seguintes sentenças para a lógica de 1ª ordem:

##### 2.1. Você pode enganar algumas pessoas todo o tempo e todas as pessoas por algum tempo, mas você não pode enganar todas as pessoas todo o tempo.

$\forall$ $Tempo$ $\exists$ $Pessoa$ $você\_engana(Pessoa, Tempo)$ $\land$ $\forall$ $Pessoa$ $\exists$ $Tempo$ $você\_engana(Pessoa, Tempo)$ $\land$ $\neg$$($$\forall$ $Pessoa$ $\forall$ $Tempo$ $você\_engana(Pessoa, Tempo)$$).$

##### 2.2. Uma maçã todo dia, mantém o médico longe.

$\forall$ $Dia$ $come\_maçã(Pessoa, Dia)$ $\rightarrow$ $não\_precisa\_médico(P)$.
