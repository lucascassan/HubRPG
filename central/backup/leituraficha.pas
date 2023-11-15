unit leituraficha;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TFLeituraFicha }

  TFLeituraFicha = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
  private

  public
    class procedure Execute(AOwner : TObject);

  end;

var
  FLeituraFicha: TFLeituraFicha;

implementation


uses menu;
{$R *.lfm}

{ TFLeituraFicha }

procedure TFLeituraFicha.SpeedButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TFLeituraFicha.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  TFMenu(FLeituraFicha.Parent).FModo:= mNone;
end;

class procedure TFLeituraFicha.Execute(AOwner: TObject);
begin
  if not Assigned(FLeituraFicha) then
     FLeituraFicha := TFLeituraFicha.Create(nil);
  With FLeituraFicha do
  begin
    Top    := 0;
    Left   := 0;
    Parent := TWinControl(AOwner);
    Show;
  end;

end;

end.

