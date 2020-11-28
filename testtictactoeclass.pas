unit TestTicTacToeClass;

{$mode objfpc}{$H+}

interface

uses
  // Use Main (Application TicTacToe à tester)
  main, forms,Dialogs, ExtCtrls, StdCtrls,
  // Autres uses
  Classes, SysUtils, fpcunit, testutils, testregistry; 

type

  { TTestTicTacToe }

  TTestTicTacToe= class(TTestCase)
  FMain : Tfrmain;
  private
    procedure TestCells(i, j, k: integer);
  protected
    procedure SetUp; override; 
    procedure TearDown; override; 
  published
    procedure TestHookUp; 
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
end;

procedure TTestTicTacToe.TestCells (i,j,k : integer);
begin
Fmain.InitPlayGround;
asserttrue('Cellule '+inttostr(i),Fmain.GamePlay(i)=-1);
asserttrue('Cellule '+inttostr(j),Fmain.GamePlay(j)=-1);
asserttrue('Cellule '+inttostr(k),Fmain.GamePlay(k)<>-1);
end;
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

