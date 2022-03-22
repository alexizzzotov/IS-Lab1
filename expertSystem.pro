DOMAINS 
  conditions = number*
  number = integer
  category = string
DATABASE 
  topic(category)
  rule(number, category, category, conditions)
  cond(number, category)
  yes(number)
  no(number)
PREDICATES
  nondeterm show_menu
  nondeterm do_consulting
  nondeterm process(integer)
  goes(category)
  clear
  eval_reply(char)
  nondeterm go(category)
  nondeterm check(number, conditions)
  inpo(number, number, string)
  do_answer(number, string, number, number)

CLAUSES
  rule(1, "1", "cheap", [1]).
  rule(2, "1", "average", [2]).
  rule(3, "1", "expensive", [3]).
  
  rule(4, "cheap", "ZTE Blade L8 (3 490 �.)", [7, 8, 12, 15]).
  rule(4, "cheap", "Realme C11 (10 990 �.)", [6, 9, 13, 15]).

  rule(4, "average", "Xiaomi Redmi Note 10 Pro (27 490 �.)", [6, 10, 14, 16]).
  rule(4, "average", "Samsung Galaxy A22 (19 990 �.)", [6, 10, 13, 15]).
  
  rule(4, "expensive", "Samsung Galaxy S21 FE (60 990 �.)", [5, 11, 13, 16]).
  rule(4, "expensive", "Apple iPhone 13 Pro Max (137 990 �.)", [4, 11, 14, 16]).

  cond(1, "�� 15 ���. ���.").
  cond(2, "�� 15 �� 30 ���. ���.").
  cond(3, "�� 30 �� 150 ���. ���.").
  
  cond(4, "������� ������������: 4350 ���").
  cond(5, "������� ������������: 4500 ���").
  cond(6, "������� ������������: 5000 ���").
  cond(7, "������� ������������: 2000 ���").
  
  cond(8, "����� ���������� ������: 32 GB").
  cond(9, "����� ���������� ������: 64 GB").
  cond(10, "����� ���������� ������: 128 GB").
  cond(11, "����� ���������� ������: 256 GB").
  
  cond(12, "��������� ������: 5 (����)").
  cond(13, "��������� ������: �� 6.4 �� 6.52 (����)").
  cond(14, "��������� ������: �� 6.67 �� 6.7 (����)").
  
  cond(15, "�������� ������: ������ ��� �������").
  cond(16, "�������� ������: ������").
  
  show_menu:-
    write("->  1 - ������"), nl,
    write("->  0 - �����"), nl,
    readint(Choice), process(Choice).
    
  process(1):-
    do_consulting.
  process(0):-
    exit.
    
  do_consulting:-
    goes(Mygoal), 
    go(Mygoal), !.
  do_consulting:-
    nl, write("���������� ������ �� �������."), nl,
  do_consulting.
  
  goes(MyGoal):-
    clear, nl,  
    write("����� ������ �����, ������� '1'"), nl,
    readln(Mygoal), !.
    
  inpo(Rno, Bno, Text):-
    nl, write(Text, "?"),nl,
    write("\t->  1 - ��"), nl,
    write("\t->  2 - ���"), nl,
    write("\t->  0 - �����"), nl,
    readint(Response),
    do_answer(Rno, Text, Bno, Response).
    
  eval_reply('1'):-
    write("������� �� ���������! ��������, ���������� ������� ������� ��� � ������ ��������."), nl, nl.
  eval_reply('2'):-
    write("� ���������, ���������� ������ �� �������. ���������� ��������������� ������� �����."), nl, nl.
    
  go(Mygoal):-
    NOT(rule(_, Mygoal, _, _)), !, nl,
    write("������, ��������������� ��������� ��������: ", Mygoal), nl,
    write("�������� �� ��� ������ ������ (1 - ��, 2 - ���)?"), nl,
    readchar(R),
    eval_reply(R).
  go(Mygoal):-
    rule(Rno, Mygoal, Ny, Cond),
    check(Rno, Cond),
    go(Ny).
  
  check(Rno, [Bno|Rest]):-
    yes(Bno), !,
    check(Rno, Rest).
  check(_, [Bno|_]):-
    no(Bno), !, fail.
  check(Rno, [Bno|Rest]):-
    cond(Bno, Text), 
    inpo(Rno, Bno, Text),
    check(Rno, Rest).
  check(_, []).
  
  do_answer(_, _, _, 0):-
    exit.
  do_answer(_, _, Bno, 1):-
    assert(yes(Bno)),
    write("��"), nl.
  do_answer(_, _, Bno, 2):-
    assert(no(Bno)),
    write("��"), nl, fail.
  
  clear:-
    retract(yes(_)), fail;
    retract(no(_)), fail;
    !.

GOAL
  show_menu.