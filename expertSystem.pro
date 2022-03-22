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
  
  rule(4, "cheap", "ZTE Blade L8 (3 490 р.)", [7, 8, 12, 15]).
  rule(4, "cheap", "Realme C11 (10 990 р.)", [6, 9, 13, 15]).

  rule(4, "average", "Xiaomi Redmi Note 10 Pro (27 490 р.)", [6, 10, 14, 16]).
  rule(4, "average", "Samsung Galaxy A22 (19 990 р.)", [6, 10, 13, 15]).
  
  rule(4, "expensive", "Samsung Galaxy S21 FE (60 990 р.)", [5, 11, 13, 16]).
  rule(4, "expensive", "Apple iPhone 13 Pro Max (137 990 р.)", [4, 11, 14, 16]).

  cond(1, "До 15 тыс. руб.").
  cond(2, "От 15 до 30 тыс. руб.").
  cond(3, "От 30 до 150 тыс. руб.").
  
  cond(4, "Емкость аккумулятора: 4350 мАч").
  cond(5, "Емкость аккумулятора: 4500 мАч").
  cond(6, "Емкость аккумулятора: 5000 мАч").
  cond(7, "Емкость аккумулятора: 2000 мАч").
  
  cond(8, "Объем встроенной памяти: 32 GB").
  cond(9, "Объем встроенной памяти: 64 GB").
  cond(10, "Объем встроенной памяти: 128 GB").
  cond(11, "Объем встроенной памяти: 256 GB").
  
  cond(12, "Диагональ экрана: 5 (дюйм)").
  cond(13, "Диагональ экрана: от 6.4 до 6.52 (дюйм)").
  cond(14, "Диагональ экрана: от 6.67 до 6.7 (дюйм)").
  
  cond(15, "Качество съемки: плохое или среднее").
  cond(16, "Качество съемки: лучшее").
  
  show_menu:-
    write("->  1 - начать"), nl,
    write("->  0 - выйти"), nl,
    readint(Choice), process(Choice).
    
  process(1):-
    do_consulting.
  process(0):-
    exit.
    
  do_consulting:-
    goes(Mygoal), 
    go(Mygoal), !.
  do_consulting:-
    nl, write("Подходящая модель не найдена."), nl,
  do_consulting.
  
  goes(MyGoal):-
    clear, nl,  
    write("Чтобы начать поиск, введите '1'"), nl,
    readln(Mygoal), !.
    
  inpo(Rno, Bno, Text):-
    nl, write(Text, "?"),nl,
    write("\t->  1 - да"), nl,
    write("\t->  2 - нет"), nl,
    write("\t->  0 - выйти"), nl,
    readint(Response),
    do_answer(Rno, Text, Bno, Response).
    
  eval_reply('1'):-
    write("Спасибо за обращение! Надеемся, экспертная система помогла Вам в выборе телефона."), nl, nl.
  eval_reply('2'):-
    write("К сожалению, подходящая модель не найдена. Попробуйте воспользоваться поиском снова."), nl, nl.
    
  go(Mygoal):-
    NOT(rule(_, Mygoal, _, _)), !, nl,
    write("Модель, соответствующая введенным запросам: ", Mygoal), nl,
    write("Подходит ли Вам данная модель (1 - да, 2 - нет)?"), nl,
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
    write("ОК"), nl.
  do_answer(_, _, Bno, 2):-
    assert(no(Bno)),
    write("ОК"), nl, fail.
  
  clear:-
    retract(yes(_)), fail;
    retract(no(_)), fail;
    !.

GOAL
  show_menu.