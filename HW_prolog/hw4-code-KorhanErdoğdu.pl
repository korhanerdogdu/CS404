%----------------------------------------------------------------------
% gene-hw4.pl - genealogical relationships
%
% Relationships can be read as "relationship of", so parent(P,C)
% means P is parent of C.
%----------------------------------------------------------------------

:- dynamic person/5.
:- dynamic message/1.

% ---------------- BASIC RELATIONS ----------------

parent(P,C) :-
  (mother(P,C) ; father(P,C)).

child(C,P) :- parent(P,C).

son(C,P) :- parent(P,C), male(C).

daughter(C,P) :- parent(P,C), female(C).

wife(W,P) :-
  spouse(W,P),
  female(W).

husband(H,P) :-
  spouse(H,P),
  male(H).

ancestor(A,P) :-
  parent(A,P).
ancestor(A,P) :-
  parent(X,P),
  ancestor(A,X).

descendent(D,P) :-
  parent(P,D).
descendent(D,P) :-
  parent(P,X),
  descendent(D,X).

full_sibling(S1, S2) :-
  mother(M,S2),
  mother(M,S1),
  S1 \= S2,
  father(F,S2),
  father(F,S1).

half_sibling(S1, S2) :-
  mother(M,S2),
  mother(M,S1),
  S1 \= S2,
  father(F,S2),
  \+(father(F,S1)).
half_sibling(S1, S2) :-
  mother(M,S2),
  mother(M,S1),
  S1 \= S2,
  father(F,S1),
  \+(father(F,S2)).
half_sibling(S1, S2) :-
  father(F,S2),
  father(F,S1),
  S1 \= S2,
  mother(M,S2),
  \+(mother(M,S1)).
half_sibling(S1, S2) :-
  father(F,S2),
  father(F,S1),
  S1 \= S2,
  mother(M,S1),
  \+(mother(M,S2)).

sibling(S1, S2) :-
  full_sibling(S1,S2).
sibling(S1, S2) :-
  half_sibling(S1,S2).

sister(S,P) :-
  sibling(S,P),
  female(S).

brother(B,P) :-
  sibling(B,P),
  male(B).

step_sibling(S1, S2) :-
  parent(P2, S2),
  spouse(M2, P2),
  parent(M2, S1),
  \+(parent(M2,S2)),
  \+(half_sibling(S1,S2)).

uncle(U,X) :-
  parent(P,X),
  brother(U,P).

aunt(A,X) :-
  parent(P,X),
  sister(A,P).

step_parent(P2,C) :-
  parent(P,C),
  spouse(P2,P),
  \+ parent(P2,C).

step_child(C2,P) :-
  step_parent(P,C2).

step_mother(M,C) :-
  step_parent(M,C),
  female(M).

step_father(F,C) :-
  step_parent(F,C),
  male(F).

step_son(S,P) :-
  step_child(S,P),
  male(S).

step_daughter(D,P) :-
  step_child(D,P),
  female(D).

nephew(N,P) :-
  sibling(S,P),
  son(N,S).

niece(N,P) :-
  sibling(S,P),
  daughter(N,S).

cousin(C,P) :-
  parent(X,P),
  sibling(S,X),
  child(C,S).

grandmother(GM,C) :-
  parent(GM,P),
  parent(P,C),
  female(GM).

grandfather(GF,C) :-
  parent(GF,P),
  parent(P,C),
  male(GF).

grandchild(GC,X) :-
  parent(X,C),
  parent(C,GC).

% ---------------- HW4: ADD NEW PREDICATES HERE ----------------
%TO-COMPLETE

% P(X,Y) means: X is P of Y

% hala: father's-side aunt (sister of Y's father)
hala(X,Y) :-
  father(F,Y),
  sister(X,F).

% teyze: mother's-side aunt (sister of Y's mother)
teyze(X,Y) :-
  mother(M,Y),
  sister(X,M).

% dayi: mother's-side uncle (brother of Y's mother)
dayi(X,Y) :-
  mother(M,Y),
  brother(X,M).

% amca: father's-side uncle (brother of Y's father)
amca(X,Y) :-
  father(F,Y),
  brother(X,F).

% anneanne: maternal grandmother (mother of Y's mother)
anneanne(X,Y) :-
  mother(M,Y),
  mother(X,M).

% babaanne: paternal grandmother (mother of Y's father)
babaanne(X,Y) :-
  father(F,Y),
  mother(X,F).

% gelin: daughter-in-law (X is married to Y's son)
gelin(X,Y) :-
  son(S,Y),
  spouse(X,S),
  female(X).

% damat: son-in-law (X is married to Y's daughter)
damat(X,Y) :-
  daughter(D,Y),
  spouse(X,D),
  male(X).

% torun: grandchild
torun(X,Y) :-
  grandchild(X,Y).

% dunur: X and Y are dünür if their children are married to each other
dunur(X,Y) :-
  child(C1,X),
  spouse(C1,C2),
  child(C2,Y),
  X \= Y.

% Q2 listing predicate: print spouse pairs once, one line per couple (no ';')
list_spouse_pairs :-
  spouse(X,Y),
  X @< Y,
  write(X), write(' - '), write(Y), nl,
  fail.
list_spouse_pairs.

% If you want the exact hyphen-name from the homework text:
'list-spouse-pairs' :-
  list_spouse_pairs.

% If you also want the other wording some versions use:
'list-all-married-couples' :-
  list_spouse_pairs.

% ---------------- relation/3 helper (unchanged) ----------------

relations([parent, wife, husband, ancestor, descendent, full_sibling,
    half_sibling, sibling, sister, brother, step_sibling, uncle,
    aunt, mother, father, child, son, daughter, step_parent,
    step_child, step_mother, step_father, step_son, step_daughter,
    nephew, niece, cousin, grandmother, grandfather, grandchild]).

relation(R,P1,P2) :-
  relations(Rs),
  member(R,Rs),
  Pred =.. [R,P1,P2],
  call(Pred).

% ---------------- DATABASE PREDICATES ----------------

person(X) :-
  person(X,_,_,_,_).

male(X) :-
  person(X,male,_,_,_).

female(X) :-
  person(X,female,_,_,_).

mother(M,C) :-
  person(C,_,M,_,_).

father(F,C) :-
  person(C,_,_,F,_).

spouse(S,P) :-
  person(P,_,_,_,S),
  S \= single.

% ---------------- UPDATE / INTEGRITY CHECKS ----------------

add(Name,Gender,Mother,Father,Spouse) :-
  assert(person(Name,Gender,Mother,Father,Spouse)).

% rollback on backtracking
add(Name,_,_,_,_) :-
  delete(Name),
  fail.

close :-
  retractall(person(_,_,_,_,_)).

delete(X) :-
  retract(person(X,_,_,_,_)).

add_person(Name,Gender,Mother,Father,Spouse) :-
  retractall(message(_)),
  dup_check(Name),
  add(Name,Gender,Mother,Father,Spouse),
  ancestor_check(Name),
  mother_check(Name, Gender, Mother),
  father_check(Name, Gender, Father).

dup_check(Name) :-
  person(Name),
  assert(message("Person is already in database")),
  !, fail.
dup_check(_).

ancestor_check(Name) :-
  ancestor(Name,Name),
  assert(message("Person is their own ancestor/descendent")),
  !, fail.
ancestor_check(_).

mother_check(_, _, Mother) :- \+(person(Mother)), !.
mother_check(_, _, Mother) :-
  male(Mother),
  assert(message("Person's mother is a man")),
  !, fail.
mother_check(Name, male, _) :-
  mother(Name, _),
  assert(message("Person, a male, is someone's mother")),
  !, fail.
mother_check(_,_,_).

father_check(_, _, Father) :- \+(person(Father)), !.
father_check(_, _, Father) :-
  female(Father),
  assert(message("Person's father is a man")),
  !, fail.
father_check(Name, female, _) :-
  father(Name, _),
  assert(message("Person, a female, is someone's father")),
  !, fail.
father_check(_,_,_).

% ---------------- HW4: SAMPLE FAMILY FACTS ----------------
%TO-COMPLETE

:- retractall(person(_,_,_,_,_)),
   add_person(ayse,   female, unknown, unknown, ali),
   add_person(ali,    male,   unknown, unknown, ayse),

   add_person(remzi,  male,   unknown, unknown, rukiye),
   add_person(rukiye, female, unknown, unknown, remzi),

   add_person(osman,  male,   ayse, ali, mualla),
   add_person(oya,    female, ayse, ali, murat),

   add_person(murat,  male,   rukiye, remzi, oya),
   add_person(mualla, female, rukiye, remzi, osman),

   add_person(esra,   female, mualla, osman, single),
   add_person(elif,   female, mualla, osman, single).
