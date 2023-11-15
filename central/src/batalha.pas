unit batalha;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  MaskEdit, Buttons, Database;

type

  { TFBatalha }

  TFBatalha = class(TForm)
    Image1: TImage;
    img1: TImage;
    img2: TImage;
    imgWait2: TImage;
    imgWait1: TImage;
    lbPlayer1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    lbPlayer2: TLabel;
    lbRacaClasse1: TLabel;
    lbRacaClasse2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lbaadas: TPanel;
    lbaadas1: TPanel;
    mkAgilidade1: TMaskEdit;
    mkAgilidade2: TMaskEdit;
    mkCarisma1: TMaskEdit;
    mkCarisma2: TMaskEdit;
    mkDestreza1: TMaskEdit;
    mkDestreza2: TMaskEdit;
    mkForca1: TMaskEdit;
    mkForca2: TMaskEdit;
    mkInteligencia1: TMaskEdit;
    mkInteligencia2: TMaskEdit;
    mkVitalidade1: TMaskEdit;
    mkVitalidade2: TMaskEdit;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel2: TPanel;
    pStatus1: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    pStatus2: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    procedure ComparePlayers();
    procedure LoadImage(ASide, AIdImage : string);
  public
    procedure loadPlayer( ASide, ATag : string);
    class procedure Execute(AOwner : TObject);
  end;


var
  FBatalha: TFBatalha;

implementation


uses menu;
{$R *.lfm}

{ TFBatalha }

procedure TFBatalha.FormShow(Sender: TObject);
begin
end;

procedure TFBatalha.Panel2Click(Sender: TObject);
begin
  Close;
end;

procedure TFBatalha.SpeedButton1Click(Sender: TObject);
begin
  Close();
end;

procedure TFBatalha.ComparePlayers();

  procedure CompareValues(MK1, MK2 : TMaskEdit);
  begin
     if StrToIntDef(MK1.Text,0) > StrToIntDef(MK2.Text,0) then
         MK2.Parent.Color := clGray
     else if StrToIntDef(MK1.Text,0) < StrToIntDef(MK2.Text, 0) then
         MK1.Parent.Color := clGray
     else
     begin
        MK1.Parent.Color := RGBToColor(134,138,179);
        MK2.Parent.Color := RGBToColor(134,138,179);
     end;
  end;
begin
   CompareValues(mkAgilidade1, mkAgilidade2);
   CompareValues(mkForca1, mkForca2);
   CompareValues(mkDestreza1, mkDestreza2);
   CompareValues(mkInteligencia1, mkInteligencia2);
   CompareValues(mkVitalidade1, mkVitalidade2);
   CompareValues(mkCarisma1, mkCarisma2);

end;

procedure TFBatalha.LoadImage(ASide, AIdImage : string);
begin
   Try
      if (ASide = '1') then
         (FindComponent('img'+ASide) as TImage).Picture.LoadFromFile('assets/char/'+AIdImage+'.png')
      else
         (FindComponent('img'+ASide) as TImage).Picture.LoadFromFile('assets/char/'+AIdImage+'_2.png');

  Except
    Image1.Picture := nil;
  end;
end;

procedure TFBatalha.loadPlayer(ASide, ATag: string);
begin

  if (ATag = '') then
    Exit;

  With TFDatabase.Create(nil) do
  Try
     With Query, SQL do
     begin
       Add('SELECT *');
       Add('FROM Fichas');
       Add('WHERE Tag = :Tag');
       ParamByName('Tag').Value := ATag;
       Open;

       if (IsEmpty) then
         Exit;

       (Self.FindComponent('lbPlayer'+ASide) as TLabel).Visible := true;
       (Self.FindComponent('lbRacaClasse'+ASide) as TLabel).Visible := true;
       (Self.FindComponent('img'+ASide) as TImage).Visible := true;
       (Self.FindComponent('pStatus'+ASide) as TPanel).Visible := true;
       (Self.FindComponent('imgWait'+ASide) as TImage).Visible := false;

       (Self.FindComponent('lbPlayer'+ASide) as TLabel).Caption        := UpperCase(FieldByName('Nome').AsString);
       (Self.FindComponent('lbRacaClasse'+ASide) as TLabel).Caption    := FieldByName('Classe').AsString   + ' / ' + FieldByName('Raca').AsString;

       (Self.FindComponent('mkForca'+ASide) as TMaskEdit).Text         := FieldByName('Forca').AsString;
       (Self.FindComponent('mkAgilidade'+ASide) as TMaskEdit).Text     := FieldByName('Agilidade').AsString;
       (Self.FindComponent('mkVitalidade'+ASide) as TMaskEdit).Text    := FieldByName('Vitalidade').AsString;
       (Self.FindComponent('mkInteligencia'+ASide) as TMaskEdit).Text  := FieldByName('Inteligencia').AsString;
       (Self.FindComponent('mkDestreza'+ASide) as TMaskEdit).Text      := FieldByName('Destreza').AsString;
       (Self.FindComponent('mkCarisma'+ASide) as TMaskEdit).Text       := FieldByName('Carisma').AsString;

       LoadImage(ASide, FieldByName('IdImagem').AsString);

     end;
   Finally
     Free;
   End;

  if (lbPlayer1.Visible) and (lbPlayer2.Visible) then
    ComparePlayers();

end;

class procedure TFBatalha.Execute(AOwner: TObject);
begin

  if not Assigned(FBatalha) then
      FBatalha := TFBatalha.Create(nil);

  With FBatalha do
  try
    lbPlayer2.Visible    := false;
    lbRacaClasse2.Visible:= false;
    img2.Visible         := false;
    pStatus2.Visible     := false;

    lbPlayer1.Visible    := false;
    lbRacaClasse1.Visible:= false;
    img1.Visible         := false;
    pStatus1.Visible     := false;

    imgWait1.Visible     := True;
    imgWait2.Visible     := True;

   TFMenu(AOwner).FModo := mBatalha;
   Parent := TWinControl(AOwner);
   Top:= 0;
   Left:= 0;
   Show;
  finally
  end;
end;


end.

