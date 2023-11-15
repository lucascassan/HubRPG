unit messagealert;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFMessageAlert }

  TFMessageAlert = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure Timer1Timer(Sender: TObject);
  private

  public
    class procedure Execute(Message : string; AOwner : TObject);
  end;

var
  FMessageAlert: TFMessageAlert;

implementation

{$R *.lfm}

{ TFMessageAlert }


procedure TFMessageAlert.Timer1Timer(Sender: TObject);
begin
   Close;
end;


class procedure TFMessageAlert.Execute(Message: string; AOwner: TObject);
var
 LForm : TFMessageAlert;
begin
 LForm := TFMessageAlert.Create(nil);
 LForm.Parent := TWinControl(AOwner);
 LForm.Top:= 0;
 LForm.Left:= 0;

 LForm.Label1.Caption := Message;
 LForm.Timer1.Enabled := true;
 LForm.Show;
end;



end.

