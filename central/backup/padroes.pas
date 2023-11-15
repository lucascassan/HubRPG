unit Padroes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFPadroes }

  TFPadroes = class(TForm)
    Button1: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    class procedure Cria(AClient: TObject);
  public

  end;


var
  FPadroes: TFPadroes;

implementation

{$R *.lfm}

{ TFPadroes }

procedure TFPadroes.Button1Click(Sender: TObject);
begin

end;

class procedure TFPadroes.Cria(AClient: TObject);
var
  ALabel : TLabel;
begin
    with Create(nil) do
     Try
       ALabel := TLabel.Create(nil);
       ALabel.Top := 30;
       ALabel.Left := 30;
       ALabel.Parent := TWinControl(AClient);





     finally
     end;

end;

end.

