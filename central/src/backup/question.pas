unit question;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, ExtCtrls,
  StdCtrls;

type

  { TFQuestion }

  TFQuestion = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Panel11: TPanel;
    pExcluir: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
  private
    FResult : boolean;
  public
   class function Execute(AMessage : string = 'CONFIRMAÇÃO' ) : boolean;

  end;

var
  FQuestion: TFQuestion;

implementation

{$R *.lfm}

{ TFQuestion }

procedure TFQuestion.SpeedButton3Click(Sender: TObject);
begin
   FResult:= true;
   Close();
end;

procedure TFQuestion.SpeedButton2Click(Sender: TObject);
begin
   FResult:= false;
   Close();
end;

class function TFQuestion.Execute(AMessage: string): boolean;
begin
  With TFQuestion.Create(nil) do
  Try
    ShowModal;
    Result := FResult;
  finally
    Free;
  end;
end;

end.

