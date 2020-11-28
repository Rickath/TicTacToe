program TicTacToe;

{$mode objfpc}{$H+}

uses
  Forms, Interfaces,
  Main in 'Main.pas' {frMain};

begin
  Application.Initialize;
  Application.CreateForm(TfrMain, frMain);
  Application.Run;
end.
