unit TestTicTacToeClass;

{$mode objfpc}{$H+}

interface

uses
  // Use Main (Application TicTacToe � tester)
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
// Proc�dures de test
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
  asserttrue('Premier joueur par d�faut pas X',sPlaySign = 'X');
  FMain.rgPlayFirst.ItemIndex := 1;
  FMain.btnNewGameClick(Fmain.FindComponent('btnNewGame'));
  asserttrue('Premier joueur apr�s changement et nouveau jeu incorrect',sPlaySign = 'O');
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

  //On r�cup�re l'�tat final du tableau
  tableau_final := '';
  for j:= 0 to 7 do begin
    tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(j))).Caption + ',';
  end;
  tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(8))).Caption;

  asserttrue('Tableau apr�s nouvelle partie dans �tat incorrect',tableau_final = ',,,,,,,,');
end;

procedure TTestTicTacToe.TestResetScore;
begin
  Fmain.InitPlayGround;

  //On initialise les scores � autre chose que 0
  iXScore := 5;
  iOScore := 10;
  // On reset le score, qu'il faut confirmer
  FMain.btnResetScoreClick(Fmain.FindComponent('btnResetScore'));

  //On v�rifie que les scores sont bien remis � 0
  asserttrue('Le score de X pas remis � 0',iXScore=0);
  asserttrue('Le score de O pas remis � 0',iOScore=0);

end;

procedure TTestTicTacToe.TestCaseDejaOccupee;
var
  case_joue: 0..8;
  valeur_case1: String;
  valeur_case2: String;
begin
  //On va v�rifier que chaque case occup�e garde son symbole initial lorsqu'on reclique dessus
  for case_joue := 0 to 8 do begin
    Fmain.InitPlayGround;
    //On clique sur la case
    FMain.lblCell0Click(TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))));
    //On r�cup�re le symbole dans la case
    valeur_case1 := TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))).Caption;

    //On clique sur la case
    FMain.lblCell0Click(TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))));
    //On r�cup�re de nouveau le symbole dans la case
    valeur_case2 := TLabel(Fmain.FindComponent('lblCell' + IntToStr(case_joue))).Caption;

    asserttrue('Case d�j� occup�e a �t� modifi�e',valeur_case1 = valeur_case2);
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
//      Fields.Delimiter := ';'; // Le s�parateur du fichier d�limit� est le point-virgule
//      Fields.DelimitedText := FileContent.Strings[ligne]; // On r�cup�re le contenu de la ligne
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

//La fonction JouerPartie prend en param�tre d'entr�e
//- la partie de Morpion � jouer issue du fichier (premier champ du csv)
//- l'�tat final du tableau attendu (deuxi�me champ du csv)
//- le r�sultat de la partie (gagnant ou �galit�, troisi�me champ du csv)
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
//  //On r�cup�re l'�tat final du tableau
//  for j:= 0 to 7 do begin
//    tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(j))).Caption + ',';
//  end;
//  tableau_final := tableau_final + TLabel(Fmain.FindComponent('lblCell' + IntToStr(8))).Caption;
//
//  //On r�cup�re le r�sultat final (si bwin est faux, c'est draw, sinon c'est le signe qui gagne)
//  if bwin then resultat_final:='win'+sPlaySign else resultat_final:='draw';
//
//  AssertEquals('Le tableau final ne correspond pas � ce qui est attendu', tableau_final, tableau_attendu);
//  AssertEquals('Le r�sultat final ne correspond pas � ce qui est attendu', resultat_final, resultat_attendu);
//
//  //Des print de v�rification pendant la conception de la fonction
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
// Proc�dure d'initialisation des instances de classes � tester
//----------------------------------------------------------------------
procedure TTestTicTacToe.SetUp;
begin
  // initialisation de l'application TicTacToe
  FMain := Tfrmain.create(application);
end; 
//----------------------------------------------------------------------
// Proc�dure de lib�ration des instances allou�es
//----------------------------------------------------------------------
procedure TTestTicTacToe.TearDown; 
begin
  // Lib�ration de la classe de la fenetre principale de l'application
  Fmain.free;
end; 
//----------------------------------------------------------------------
initialization

  RegisterTest(TTestTicTacToe); 
end.

