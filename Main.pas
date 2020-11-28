unit Main;
{
UNITE = PACKAGE comprenant une seule CLASSE TrMain dérivant de TForm
}
//=============================================================================
interface

// Utilisation d'autres UNITES : PACKAGE (dans les interfaces)---------------
// L'interface contient des Classes et Types définies dans les packages
// listés dans la clause USES.
// Association
uses
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, StrUtils, LResources;

// Déclaration des classes et Types -----------------------------------------
type
  TXOPosArray = array [1..3, 1..3] of Integer;

type

  { TfrMain }

  TfrMain = class(TForm)
    lblCell0: TLabel;
    lblCell1: TLabel;
    lblCell2: TLabel;
    lblCell3: TLabel;
    lblCell4: TLabel;
    lblCell5: TLabel;
    lblCell6: TLabel;
    lblCell7: TLabel;
    lblCell8: TLabel;
    gbScoreBoard: TGroupBox;
    rgPlayFirst: TRadioGroup;
    lblX: TLabel;
    lblMinus: TLabel;
    Label1: TLabel;
    lblXScore: TLabel;
    lblColon: TLabel;
    lblOScore: TLabel;
    btnNewGame: TButton;
    btnResetScore: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lblCell0Click(Sender: TObject);
    procedure btnNewGameClick(Sender: TObject);
    procedure btnResetScoreClick(Sender: TObject);
  private

    procedure Switchplayer;
    procedure WinMessage;
  public
    procedure InitPlayGround;
    function CheckWin(iPos : TXOPosArray) : integer;
    function Autoplay(Cell : integer):integer;
    function GamePlay(xo_Move : Integer) : integer;
  end;
//=============================================================================

var
  frMain: TfrMain;

  iXPos : TXOPosArray;
  iOPos : TXOPosArray;
  sPlaySign : String;
  bGameOver,bwin : Boolean;
  iMove : Integer;       // nombre de case cochée
  iXScore : Integer;
  iOScore : Integer;
  CellIndexPlay : Integer;
//=============================================================================
implementation
//--------------------------------------------------------------------------
procedure TfrMain.InitPlayGround;
// le plateau est composé de 9 Composants TLabel nommée de 0 à 8 : LblCell0 à LblCell8
// Cette fonction initialise donc le "Caption" à blanc, c'est à dire vide le plateau
// Repèrage entre les composants Tlabel et la matrice fictive 3 X 3 (cf clacul de k)
var
 i, j, k: integer;
begin
  for i := 1 to 3 do
  begin
    for j := 1 To 3 do
    begin
      k:= (i - 1) * 3 + j - 1; // 0 .. 8
      TLabel(FindComponent('lblCell' + IntToStr(k))).Caption := '';
      iXPos[i, j] := 0;
      iOPos[i][j] := 0;
    end;
  end;

 if rgPlayFirst.ItemIndex = 0 then sPlaySign := 'X';
 if rgPlayFirst.ItemIndex = 1 then sPlaySign := 'O';
 bGameOver := False;
 iMove := 0;
end;
//--------------------------------------------------------------------------
// à la création de la forme, initialisation du plateau
procedure TfrMain.FormCreate(Sender: TObject);
begin
 iXScore := 0;
 iOScore := 0;
 InitPlayGround;
end;
//--------------------------------------------------------------------------
// Vérifie si des croix ou des ronds sont allignés
function TfrMain.CheckWin(iPos : TXOPosArray) : Integer;
var
 iScore : Integer;
 i : Integer;
 j : Integer;
begin
 Result := -1;
 //lignes
 iScore := 0;
 for i := 1 to 3 do
 begin
  iScore := 0;
  Inc(Result);
  for j := 1 To 3 do Inc(iScore, iPos[i,j]);
  if iScore = 3 Then Exit
 end;//for i

 // diagonale gauche?
 iScore := 0;
 Inc(Result);
 for i := 1 to 3 do Inc(iScore, iPos[i,i]);
 if iScore = 3 then Exit;

 // diagonale droite?
 iScore := 0;
 Inc(Result);
 for i := 1 to 3 do Inc(iScore, iPos[i,4-i]);
 if iScore = 3 then Exit;

 //colonnes
 for i := 1 to 3 do
 begin
  iScore := 0;
  Inc(Result);
  for j := 1 to 3 do Inc(iScore, iPos[j,i]);
  if iScore = 3 then Exit;
 end;//for i

 Result := -1;
end;
//--------------------------------------------------------------------------
// affiche les messages à l'écran en cas de gain ou de partie terminée
procedure TfrMain.WinMessage;
begin
if bwin or bgameover then switchplayer();

        if bwin then ShowMessage(sPlaySign + ' - Gagné!');
        if bgameover then
        ShowMessage(sPlaySign + ' - C''est fini!');
end;
//--------------------------------------------------------------------------
// Fonction de vérification du gain et de positionnement des valeurs du
// tableau de la matrice de jeu
function TfrMain.GamePlay(xo_Move : Integer):integer;
var
 x, y : 1..3;
 iWin : integer;
begin
 Result := -1;

 Inc(iMove);
 x := (xo_Move Div 3) + 1;
 y := (xo_Move Mod 3) + 1;

 if sPlaySign = 'O' then
 begin
   iOPos[x,y] := 1;
   iWin := CheckWin(iOPos);
 end
 else
 begin
   iXPos[x,y] := 1;
   iWin := CheckWin(iXPos);
 end;

 TLabel(FindComponent('lblCell' + IntToStr(xo_Move))).Caption := sPlaySign;

 Result := iWin;
 bwin := false;

 if iWin >= 0 then
 begin
   bGameOver := True;
   //victoire
   bwin := true;
   if sPlaySign = 'X' then
   begin
    iXScore := iXScore + 1;
    lblXScore.Caption := IntToStr(iXScore);
   end
   else
   begin
    iOScore := iOScore + 1;
    lblOScore.Caption := IntToStr(iOScore);
   end;

  // ShowMessage(sPlaySign + ' - Gagné!');
 end;

 if (iMove = 9) AND (bGameOver = False) Then
 begin
  // ShowMessage('Fini');
  bGameOver := True
 end;


end;
//--------------------------------------------------------------------------
// Switch entre les joueurs
procedure  TfrMain.Switchplayer;
begin
  if sPlaySign = 'O' Then
   sPlaySign := 'X'
 else
   sPlaySign := 'O';
end  ;
//--------------------------------------------------------------------------
// Procédure associée au click sur une des cases
procedure TfrMain.lblCell0Click(Sender: TObject);
var
  iWin : integer;
  CellIndex : 0..8;
begin
 if bGameOver = True Then Exit;
 if TLabel(Sender).Caption <> '' then
 begin
  ShowMessage('Cellule occupée!');
  Exit;
 end;
 CellIndex := StrToInt(RightStr(TLabel(Sender).Name,1));
 iWin := GamePlay(CellIndex);
 Switchplayer() ;
 AutoPlay(CellIndex);
 WinMessage();
end;
//--------------------------------------------------------------------------
// Procédure associée au bouton Nouvelle partie
procedure TfrMain.btnNewGameClick(Sender: TObject);
begin
 if bGameOver = False then
 begin
  if MessageDlg('Fin du jeu', mtConfirmation, mbOKCancel,0) = mrCancel then Exit;
 end;
 InitPlayGround;
end;
//--------------------------------------------------------------------------
// Procédure associée au bouton reset des scores
procedure TfrMain.btnResetScoreClick(Sender: TObject);
begin
 if MessageDlg('Reset des scores?',mtConfirmation,mbOKCancel,0) = mrCancel then Exit;
     iXScore := 0;
     iOScore := 0;
     lblXScore.Caption := IntToStr(iXScore);
     lblOScore.Caption := IntToStr(iOScore);
end;
//--------------------------------------------------------------------------
// function de jeu automatique heuristique 1
function TfrMain.Autoplay(Cell : integer):integer ;
begin
result := Cell;
end;
//--------------------------------------------------------------------------
// Initialization du package (unité)
initialization
  {$i Main.lrs}
end.
