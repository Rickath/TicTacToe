unit TestTicTacToeClass;

{$mode objfpc}{$H+}

interface

uses
  // Use Main (Application TicTacToe à tester)
  main, forms,Dialogs, ExtCtrls, StdCtrls,
  // Autres uses
  Classes, SysUtils, fpcunit, testregistry;

type

  { TTestTicTacToe }

  TTestTicTacToe= class(TTestCase)
  FMain : Tfrmain;
  private
    procedure TestCells(i, j, k: integer);
    //procedure JouerPartie(partie,tableau_attendu,resultat_attendu: String);
  protected
    procedure SetUp; override; 
    procedure TearDown; override; 
  published
    procedure TestHookUp;
    procedure TestChgtPremierJoueur;
    procedure TestNouvellePartie;
    procedure TestResetScore;
    procedure TestCaseDejaOccupee;
    //procedure TestParties;
  end;

implementation

//----------------------------------------------------------------------
// Procédures de test
//----------------------------------------------------------------------
procedure TTestTicTacToe.TestHookUp; 
begin
// tests des lignes
TestCells(0,1,2);
TestCells(3,4,5);
TestCells(6,7,8);
// Test des colonnes
TestCells(0,3,6);
TestCells(1,4,7);
TestCells(2,5,8);
// Test des diagonales
TestCells(0,4,8);
TestCells(2,4,6);

end;

procedure TTestTicTacToe.TestChgtPremierJoueur;
begin
  Fmain.InitPlayGround;
  asserttrue('Premier joueur par défaut pas X',sPlaySign = 'X');
  FMain.rgPlayFirst.ItemIndex := 1;
  FMain.btnNewGameClick(Fmain.FindComponent('btnNewGame'));
  asserttrue('Premier joueur après changement et nouveau jeu incorrect',sPlaySign = 'O');
end;

procedure TTestTicTacToe.TestNouvellePartie;
var
  tableau_final: String;
  j: 0..7;
begin
  Fmain.InitPlayGround;

  //On clique sur une case
  FMain.lblCell0Click(TLabel(Fmain.FindComponent('lblCell0')));
  // On lance une nouvelle partie qu'il faut confirmer
  FMain.btnNewGameClick(Fmain.FindComponent('btnNewGame'));

  //On récupère l'état final du tableau
  tableau_final := '';
  for j:= 0 to 7 do begin
    tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(j))).Caption + ',';
  end;
  tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(8))).Caption;

  asserttrue('Tableau après nouvelle partie dans état incorrect',tableau_final = ',,,,,,,,');
end;

procedure TTestTicTacToe.TestResetScore;
begin
  Fmain.InitPlayGround;

  //On initialise les scores à autre chose que 0
  iXScore := 5;
  iOScore := 10;
  // On reset le score, qu'il faut confirmer
  FMain.btnResetScoreClick(Fmain.FindComponent('btnResetScore'));

  //On vérifie que les scores sont bien remis à 0
  asserttrue('Le score de X pas remis à 0',iXScore=0);
  asserttrue('Le score de O pas remis à 0',iOScore=0);

end;

procedure TTestTicTacToe.TestCaseDejaOccupee;
var
  case_joue: 0..8;
  valeur_case1: String;
  valeur_case2: String;
begin
  //On va vérifier que chaque case occupée garde son symbole initial lorsqu'on reclique dessus
  for case_joue := 0 to 8 do begin
    Fmain.InitPlayGround;
    //On clique sur la case
    FMain.lblCell0Click(TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))));
    //On récupère le symbole dans la case
    valeur_case1 := TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))).Caption;

    //On clique sur la case
    FMain.lblCell0Click(TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))));
    //On récupère de nouveau le symbole dans la case
    valeur_case2 := TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))).Caption;

    asserttrue('Case déjà occupée a été modifiée',valeur_case1 = valeur_case2);
  end;
end;

//procedure TTestTicTacToe.TestParties;
//var
//  FileName: String;
//  FileContent: TStringList;
//  Fields: TStringList;
//  ligne: longint;
//begin
//  FileName := 'Simulateur_parties/parties_extrait.csv';
//  FileContent := TStringList.Create;
//try
//  FileContent.LoadFromFile(FileName); // On met le contenu du fichier dans une TStringList
//
//  // On parcourt chacune des lignes de la liste
//  for ligne := 0 to pred(FileContent.Count) do begin
//    Fields := TStringList.Create;
//    try
//      Fields.Delimiter := ';'; // Le séparateur du fichier délimité est le point-virgule
//      Fields.DelimitedText := FileContent.Strings[ligne]; // On récupère le contenu de la ligne
//      //On joue la partie de la ligne
//      JouerPartie(Fields[0],Fields[1],Fields[2]);
//    finally
//      Fields.Free;
//    end;
//
//  end;
//  finally
//    FileContent.Free;
//  end;
//end;

//La fonction JouerPartie prend en paramètre d'entrée
//- la partie de Morpion à jouer issue du fichier (premier champ du csv)
//- l'état final du tableau attendu (deuxième champ du csv)
//- le résultat de la partie (gagnant ou égalité, troisième champ du csv)
//procedure TTestTicTacToe.JouerPartie(partie,tableau_attendu,resultat_attendu : String);
//var
//  i: longint;
//  j: 0..8;
//  case_joue : 0..8;
//  //Wnd: HWND;
//  tableau_final: String;
//  resultat_final: String;
//begin
//  //On initialise au bon premier joueur
//  if partie[1] = 'X' then FMain.rgPlayFirst.ItemIndex := 0;
//  if partie[1] = 'O' then FMain.rgPlayFirst.ItemIndex := 1;
//
//  FMain.InitPlayground;
//  tableau_final := '';
//
//  //On parcourt tous les coups, et on les joue en simulant le clic sur l'interface
//  for i := 1 to Length(partie) Div 2 do begin
//    case_joue := StrToInt(partie[2*i]);
//    FMain.lblCell0Click(TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))));
//  end;
//
//  //On récupère l'état final du tableau
//  for j:= 0 to 7 do begin
//    tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(j))).Caption + ',';
//  end;
//  tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(8))).Caption;
//
//  //On récupère le résultat final (si bwin est faux, c'est draw, sinon c'est le signe qui gagne)
//  if bwin then resultat_final:='win'+sPlaySign else resultat_final:='draw';
//
//  AssertEquals('Le tableau final ne correspond pas à ce qui est attendu', tableau_final, tableau_attendu);
//  AssertEquals('Le résultat final ne correspond pas à ce qui est attendu', resultat_final, resultat_attendu);
//
//  //Des print de vérification pendant la conception de la fonction
//  //Write(tableau_final); Write(' ###### '); Write(tableau_attendu);
//  //Writeln('');
//  //Write(resultat_final); Write(' ###### '); Write(resultat_attendu);
//  //Writeln('');
//end;

procedure TTestTicTacToe.TestCells (i,j,k : integer);
begin
  Fmain.InitPlayGround;
  asserttrue('Cellule '+inttostr(i),Fmain.GamePlay(i)=-1);
  asserttrue('Cellule '+inttostr(j),Fmain.GamePlay(j)=-1);
  asserttrue('Cellule '+inttostr(k),Fmain.GamePlay(k)<>-1);
end;

//procedure TTestTicTacToe.TestCells (i,j,k : integer);
//begin
//  Fmain.InitPlayGround;
//  asserttrue('Cellule '+inttostr(i),Fmain.GamePlay(i)=-1);
//  asserttrue('Cellule '+inttostr(j),Fmain.GamePlay(j)=-1);
//  asserttrue('Cellule '+inttostr(k),Fmain.GamePlay(k)<>-1);
//end;
//----------------------------------------------------------------------
// Procédure d'initialisation des instances de classes à tester
//----------------------------------------------------------------------
procedure TTestTicTacToe.SetUp;
begin
  // initialisation de l'application TicTacToe
  FMain := Tfrmain.create(application);
end; 
//----------------------------------------------------------------------
// Procédure de libération des instances allouées
//----------------------------------------------------------------------
procedure TTestTicTacToe.TearDown; 
begin
  // Libération de la classe de la fenetre principale de l'application
  Fmain.free;
end; 
//----------------------------------------------------------------------
initialization

  RegisterTest(TTestTicTacToe); 
end.

