G%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE3520/CpSc3520 SDE1: Prolog Declarative and Logic Programming

% Use the following Prolog relations as a database of familial 
% relationships for 4 generations of people.  If you find obvious
% minor errors (typos) you may correct them.  You may add additional
% data if you like but you do not have to.

% Then write Prolog rules to encode the relations listed at the bottomG.
% You may create additional predicates as needed to accomplish this,
% including relations for debugging or extra relations as you desire.
% All should be included when you turn this in.  Your rules must be able
% to work on any data and across as many generations as the data specifies.
% They may not be specific to this data.

% Using SWI-Prolog, run your code, demonstrating that it works in all modes.
% Log this session and turn it in with your code in this (modified) file.
% You examples should demonstrate working across 4 generations where
% applicable.

% Fact recording Predicates:

% list of two parents, father first, then list of all children
% parent_list(?Parent_list, ?Child_list).

% Data:
parent_list([]).

parent_list([fred_smith, mary_jones],[tom_smith, lisa_smith, jane_smith, john_smith]).

parent_list([tom_smith, evelyn_harris],[mark_smith, freddy_smith, joe_smith, francis_smith]).

parent_list([mark_smith, pam_wilson], [martha_smith, frederick_smith]).

parent_list([freddy_smith, connie_warrick], [jill_smith, marcus_smith, tim_smith]).

parent_list([john_smith, layla_morris], [julie_smith, leslie_smith, heather_smith, zach_smith]).

parent_list([edward_thompson, susan_holt], [leonard_thompson, mary_thompson]).

parent_list([leonard_thompson, list_smith], [joe_thompson, catherine_thompson, john_thompson, carrie_thompson]).

parent_list([joe_thompson, lisa_houser], [lilly_thompson, richard_thompson, marcus_thompson]).

parent_list([john_thompson, mary_snyder], []).

parent_list([jeremiah_leech, sally_swithers], [arthur_leech]).

parent_list([arthur_leech, jane_smith], [timothy_leech, jack_leech, heather_leech]).

parent_list([robert_harris, julia_swift], [evelyn_harris, albert_harris]).

parent_list([albert_harris, margaret_little], [june_harris, jackie_harrie, leonard_harris]).

parent_list([leonard_harris, constance_may], [jennifer_harris, karen_harris, kenneth_harris]).

parent_list([beau_morris, jennifer_willis], [layla_morris]).

parent_list([willard_louis, missy_deas], [jonathan_louis]).

parent_list([jonathan_louis, marsha_lang], [tom_louis]).

parent_list([tom_louis, catherine_thompson], [mary_louis, jane_louis, katie_louis]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SWE1 Assignment - Create rules for:
:-use_module(library(clpfd)).

male(fred_smith).
male(tom_smith).
male(frederick_smith).
male(freddy_smith).
male(marcus_smith).
male(tim_smith).
male(joe_smith).
male(john_smith).
male(blake_towns).
male(cal_holms).
male(joseph_oleary).
male(zach_smith).
male(edward_thompson).
male(leonard_thompson).
male(joe_thompson).
male(richard_thompson).
male(marcus_thompson).
male(tom_louis).
male(john_thompson).
male(george_frey).
male(larry_mcbride).
male(jeremiah_leech).
male(arthur_leech).
male(timothy_leech).
male(jack_leech).
male(robert_harris).
male(albert_harris).
male(james_french).
male(doug_lauder).
male(leonard_harris).
male(kenneth_harris).
male(beau_morris).
male(willard_louis).
male(jonathan_louis).
%
female(mary_jones).
female(evelyn_harris).
female(pam_wilson).
female(martha_smith).
female(connie_warrick).
female(jill_smith).
female(francis_smith).
female(lisa_smith).
female(jane_smith).
female(layla_morris).
female(julie_smith).
female(leslie_smith).
female(heather_smith).
female(patty_mcdonna).
female(susan_holt).
female(lisa_houser).
female(lilly_thompson).
female(catherine_thompson).
female(mary_snyder).
female(carrie_thompson).
female(mary_thompson).
female(sally_swithers).
female(heather_leech).
female(julia_swift).
female(margaret_little).
female(june_harris).
female(jackie_harris).
female(constance_may).
female(jennifer_harris).
female(karen_harris).
female(jennifer_willis).
female(layla_morris).
female(missy_deas).
female(marsha_lang).
female(mary_louis).
female(jane_louis).
female(katie_louis).
% the Parent is the parent - mother or father of the child
% parent(?Parent, ?Child).
parent(P, C) :- parent_list(PL, CL), member(P, PL), member(C, CL).

% Husband is married to Wife - note the order is significant
% This is found in the first list of the parent_list predicate
% married(?Husband, ?Wife).
married(H, W) :- parent_list(PL, _), nth0(0, PL, H), nth0(1, PL, W).

% Ancestor is parent, grandparent, great-grandparent, etc. of Person
% Order is significant.  This looks for chains between records in the parent_list data
% ancestor(?Ancestor, ?Person).
ancestor(A, P) :- parent(A, P).
ancestor(A, P) :- parent(Z, P), ancestor(A, Z).

% Really the same as ancestor, only backwards.  May be more convenient in some cases.
% descendent(?Decendent, ?Person).
descendent(D, P) :- ancestor(P, D).

% There are exactly Gen generations between Ancestor and Person.  Person and parent 
% have a Gen of 1.  The length of the chain (or path) from Person to Ancestor.
% Again order is significant.
% generations(?Ancesstor, ?Person, ?Gen).
generations(A, P, G).

% Ancestor is the ancestor of both Person1 and Person2.  There must not exist another
% common ancestor that is fewer generations. 
% least_common_ancestor(?Person1, ?Person2, ?Ancestor).
least_common_ancestor(P1, P2, A).

% Do Person1 and Person2 have a common ancestor?
% blood(?Person1, ?Person2). %% blood relative
blood(P1, P2) :- ancestor(P1, P2) ; descendent(P1, P2).

% Are Person1 and Person2 on the same list 2nd are of a parent_list record.
% sibling(?Person1, Person2).
sibling(P1, P2) :- parent_list(_, CL), member(P1, CL), member(P2, CL), P1\=P2.

% These are pretty obvious, and really just capturing info we already can get - except that
% the gender is important.  Note that father is always first on the list in parent_list.
% father(?Father, ?Child).
father(F, C) :- husband(F), parent(F, C).

% mother(?Mother, ?Child).
mother(M, C) :- wife(M), parent(M, C).

% Note that some uncles may not be in a parent list arg of parent_list, but would have 
% a male record to specify gender.
% uncle(?Uncle, ?Person). %% 
uncle(U, P) :- (male(U) ; husband(U)), sibling(U, Z),  parent(Z, P).
uncle(U, P) :- sibling(Z, Q), parent(Q, P), married(U, Z).

% aunt(?Aunt, ?Person). %% 
aunt(A, P) :- (female(A) ; wife(A)), sibling(A, Z), parent(Z, P).
aunt(A, P) :- married(Z, A), uncle(Z, P).

% cousins have a generations greater than parents and aunts/uncles.
% cousin(?Cousin, ?Person).
cousin(C, P) :- uncle(Z, P), parent(Z, C).

%% 1st cousin, 2nd cousin, 3rd once removed, etc.
% cousin_type(+Person1, +Person2, -CousinType, -Removed).
cousin_type(P1, P2, CT, R) :- common_ancestor(P1, P2, A), ancestor_with_dist(A, P1, D1), ancestor_with_dist(A, P2, D2), D1 >= 2, D2 >= 2, CT #= (min(D1, D2) - 1), R #= abs(D1-D2), \+(sibling(P1, P2)), \+(parent(P1, P2)), \+(parent(P2, P1)), \+(aunt(P1, P2) ; uncle(P1, P2)), \+(aunt(P2, P1) ; uncle(P2, P1)), P1\=P2.