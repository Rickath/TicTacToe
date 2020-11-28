program TestTicTacToeApp;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, TestTicTacToeClass, Main;

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

