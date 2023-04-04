:-use_module(library(lists)).
:-use_module(library(random)).

printX(_, 0).
%(+Str, +X)
printX(Str, X):-
    write(Str),
    NewX is X - 1,
    printX(Str, NewX).

write_letters(0, _).
%(+Width, +Ascii)
write_letters(Width, Ascii):-
    char_code(Letter, Ascii),
    write('   '),
    write(Letter),
    NewWidth is Width - 1,
    NewAscii is Ascii + 1,
    write_letters(NewWidth, NewAscii).

%(+GameState)
display_game([Board, Turn, ScoreX, ScoreO]):-
    nth0(0,Board, Row),
    length(Row, Width),
    
    %write('   A   B   C   D   E   F   G'), nl,
    write_letters(Width, 65),nl,
    %write(' +---+---+---+---+---+---+---+'),
    write(' '),
    /*printX('+---', Width),*/
    nl,
    display_board(Board, 1),
    write('Score X = '), write(ScoreX),nl,
    write('Score O = '), write(ScoreO),nl,
    write('Current turn: '), write(Turn), nl.

display_board([], _).
%(+Board, +N)
display_board([R| L], N):-
            length(R, Width),
            write(N),
            display_row(R), write('|'),
            nl,write(' '),
            printX('+---', Width),
            nl,
            N1 is N + 1,
            display_board(L, N1).



display_row([]).
%(+Row)
display_row([E|R]):-
    write('|'),
    write(' '),
    write(E),
    write(' '),
    display_row(R).
    
%(-Number, +Lower, +Upper)
getNumber(Number, Lower, Upper):-
    read(Number),
    Number =< Upper, Number >= Lower.
getNumber(Number, Lower, Upper):-
    write('Must be between '), write(Lower), write(' and '), write(Upper),nl,
    getNumber(Number, Lower, Upper).

play:-
    showMenu.

showMenu:-
    write('Game Modes:'),
    nl,
    write('Player vs Player - 1'),
    nl,
    write('Player vs CPU - 2'),
    nl,
    write('CPU vs CPU - 3'),
    nl,
    getNumber(X, 1, 3),
    
    write('Insert the width of the board'),nl,
    getNumber(Width, 2, 9),
    write('Insert the height of the board'), nl,
    getNumber(Height, 2, 9),

    start_game(X, Height, Width).

%(+GameState, +Mode)
game_cycle(GameState, Mode, Level) :-
    board(GameState, Board),
    get_possible_moves(Board, Moves),
    length(Moves, NumberMoves),
    NumberMoves \= 0,
    current_player(GameState, Turn),
    ai_or_player(GameState, Mode, Level, Turn, Y, X),
    write(Y),write(X),nl,
    move(GameState, Y, X, NewGame),
    display_game(NewGame),
    game_cycle(NewGame, Mode, Level).

game_cycle(GameState, Mode, Level):-
    board(GameState, Board),
    scoreX(GameState, ScoreX),
    scoreO(GameState, ScoreO),
    write('Game finished'), nl,
    display_game(GameState),
    ((ScoreX > ScoreO, write('X player wins.'), nl);
     (ScoreO < ScoreX, write('O player wins.'), nl);
     (ScoreX = ScoreO, write('Draw.'), nl)).

ai_or_player(GameState, 2, Level, 'X', Y, X):-
    bot_move(GameState, Level, Y, X).

ai_or_player(GameState, 3, _, _, Y, X):-
    bot_move(GameState, 1, Y, X).

ai_or_player(GameState, 1, _, _, Y, X):-
    board(GameState, Board),
    get_move(Board, Y, X).

ai_or_player(GameState, 2, _, 'O', Y, X):-
    board(GameState, Board),
    get_move(Board, Y, X).

bot_move(GameState,1,Line, Column):-
    board(GameState, Board),
    nth0(0,Board, Row),
    length(Row, Width),
    length(Board, Height),
    random(0,Height,Line),
    random(0,Width,Column).
    is_valid(Board, Line, Collumn).

bot_move(GameState,1,Line, Column):-
    bot_move(GameState,1,Line, Column).

bot_move(GameState,_,Line, Column):-
    board(GameState, Board),
    get_possible_moves(Board,Moves),
    check_bot_moves(GameState,Moves,Line,Column,0).

check_bot_moves(BGameState,[H|T],Y,X,Score):-
    moveparser(H,NY,NX),
    /*write(NY),write(NX),nl,*/
    move(BGameState,NY,NX,[_, _, BScore, _]),
    (BScore >= Score,
    check_bot_moves(BGameState,T,NY,NX,BScore)), Y is NY, X is NX; check_bot_moves(BGameState,T,Y,X,Score). 

check_bot_moves(BGameState,[],Y,X,Score):-!.

moveparser(Y-X, Y, X).


%Get element from 2D List where collumn is a uppercase char (get_element_char(+Board, +Line, -Element))
get_element_char(Board, Line, Collumn_char, Element):-
    char_code(Collumn_char, Char_value),
    Collumn is Char_value - 65,
    get_element(Board, Line, Collumn, Element).

initRows(0, []).
initRows(Width, Row):-
    NewWidth is Width - 1,
    initRows(NewWidth, NewRow),
    append([' '], NewRow, Row).

initBoard(0, _, []).
initBoard(Height, Width, Board) :-
    NewHeight is Height - 1,
    initBoard(NewHeight, Width, NewBoard),
    initRows(Width, NewRow),
    append([NewRow], NewBoard, Board).


start_game(X, Height, Width):-
    X\=2,
    initBoard(Height, Width, Board),
    GameState = [Board, 'O', 0, 0],
    display_game(GameState),
    game_cycle(GameState, X,0).

start_game(2, Height, Width):-
    write('Level of AI difficulty - 1 || 2 '),nl,
    getNumber(L,1,2),
    initBoard(Height, Width, Board),
    GameState = [Board, 'O', 0, 0],
    display_game(GameState),
    game_cycle(GameState, 2,L).



getName(X, Name):-
    	write('Enter player '), write(X), write('s name:'), nl,
        read(Name).

%Get current player from GameState
current_player([_, Turn, _, _], Turn).
%Get board from GameState
board([Board, _, _, _], Board).
scoreO([_, _, _, ScoreO], ScoreO).
scoreX([_, _, ScoreX, _], ScoreX).
char_parser(Char, Int) :-
    char_code(Char, Char_value),
    Int is Char_value - 97.
get_element(Board, Line, Collumn, Element) :- 
        nth0(Line, Board, Row),
        nth0(Collumn, Row, Element). 

is_valid(Board, Line, Collumn):-
    get_element(Board, Line, Collumn, Element),
    Element = ' '.

is_valid_b(' ').



%(+Mode, +Board, -Line, -Collumn)
get_move(Board, Line, Collumn):-
    get_move_input(Line, Collumn),
    is_valid(Board, Line, Collumn).

get_move(Board, Line, Collumn):-
    write('Move is invalid!'), nl,
    get_move(Board, Line, Collumn).

%(-Line, -Collumn)
get_move_input(Line, Collumn) :-
    write('Enter a position (ex: a1)'), nl,
    read(Chars),
    atom_chars(Chars, CharsArray),
    nth0(0, CharsArray, Ychar),
    char_parser(Ychar, Collumn),
    nth0(1, CharsArray, Xchar),
    
    char_code(Xchar, Xcharvalue),
    Line is Xcharvalue - 49.

%(+I, +List, +Element, -Result)
replace(I, List, Element, Result):-
    nth0(I, List, _, R),
    nth0(I, Result, Element, R).

%(+Board, +Y, +X, +Element, -NewBoard)
replace2d(Board, Y, X, Element, NewBoard):-
    nth0(Y, Board, Row),
    replace(X, Row , Element, NewRow),
    replace(Y, Board, NewRow, NewBoard).

change_turn('X', 'O').
change_turn('O', 'X').

% (+Board, +Y, -Score)
check_line(Board, Y, Score):-
    nth0(Y, Board, Line),
    check_line_rec(Line, Score).

check_line(Board, Y, Score):-
    Score is 0.

check_line_rec([], 0).
check_line_rec([X|Line], Score):-
    X \= ' ',
    check_line_rec(Line, NewScore),
    Score is NewScore + 1.

% (+Board, +X, -Score)
check_collumn_rec([X|L], Collumn, Score):-
    nth0(Collumn,X, Element),
    Element \= ' ',
    check_collumn_rec(L, Collumn, NewScore),
    Score is NewScore + 1.

check_collumn_rec([], _, _, 0).

check_collumn(Board, X, Score):-
    check_collumn_rec(Board, X, NewScore),
    Score is NewScore.
check_collumn(Board, X, 0).

% (+Board, +X, +Turn,+Type, -Score)
check_diagonal(Board, Y, X, Type, Score):-
    check_diagonal_rec(Board, Y, X, 1,Type, Score1),
    check_diagonal_rec(Board, Y, X, -1,Type, Score2),
    Score1 \= 0,
    Score2 \= 0,
    Score is Score1 + Score2 - 1.
check_diagonal(Board, Y, X, Type, 0).



check_diagonal_rec(Board, Y, X, Increment, Type, Score):-
    get_element(Board, Y, X, Element),
    Element \= ' ',
    NewX is X + Increment,
    ((Type = 0, NewY is Y - Increment) ; (Type = 1, NewY is Y + Increment)),
    check_diagonal_rec(Board, NewY, NewX, Increment, Type, NewScore),
    Score is NewScore + 1.
check_diagonal_rec(Board, Y, X, _, _, 0):-
    nth0(0, Board, Row),
    length(Board, LengthY),
    length(Row, LengthX),
    (Y >= LengthY; Y < 0 ;
    X >= LengthX; X < 0).



%(+Gamestate, +Y, +X, -NewGameState)
move([Board, Turn, ScoreX, ScoreO], Y, X, [NewBoard, NewTurn, NewScoreX, NewScoreO]) :-
    replace2d(Board, Y, X, Turn, NewBoard),
    check_line(NewBoard,Y, ScoreLine),
    check_collumn(NewBoard,X, ScoreCollumn),
    check_diagonal(NewBoard,Y, X, 0, ScoreDiagonal),
    check_diagonal(NewBoard,Y, X, 1, ScoreDiagonal2),

    TotalScore is ScoreLine + ScoreCollumn + ScoreDiagonal + ScoreDiagonal2,
    addScore(ScoreX, ScoreO, Turn,TotalScore,  NewScoreX, NewScoreO),
    change_turn(Turn, NewTurn).

%(+Board, -Moves)
get_possible_moves(Board, Moves):-
    get_possible_moves_rec(Board, 0, Moves).

get_possible_moves_rec([], _, []).
get_possible_moves_rec([E|L], Y, Moves):-
    get_possible_moves_add_move(E, Y, 0, MovesFromRow),
    NewY is Y + 1,
    get_possible_moves_rec(L,NewY, NewMoves),
    append(MovesFromRow, NewMoves, Moves).
    
get_possible_moves_add_move([], _, _, []).
get_possible_moves_add_move([E|L], Y, X, Moves):-
    NewX is X + 1,
    get_possible_moves_add_move(L, Y, NewX, NewMove),
    ((E = ' ',
    append([Y-X], NewMove, Moves)); E \= ' ', Moves = NewMove).
get_possible_moves_add_move(_, _, _, []).

%(+ScoreX, +ScoreO, +Turn, +Score, -NewScoreX, -NewScoreO)
addScore(ScoreX, ScoreO,'X', Score, NewScoreX, NewScoreO):-
    NewScoreX is ScoreX + Score,
    NewScoreO is ScoreO.

addScore(ScoreX, ScoreO,'O', Score, NewScoreX, NewScoreO):-
    NewScoreX is ScoreX,
    NewScoreO is ScoreO + Score.

