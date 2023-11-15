unit dicepy.view;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  PairSplitter;

type

  { TDicePyView }

  TDicePyView = class(TForm)
    img2: TImage;
    img1: TImage;
    img3: TImage;
    lbD1: TLabel;
    lbD2: TLabel;
    lbD3: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
    constructor Execute(TheOwner: TComponent; Values : string);
  end;

var
  DicePyView: TDicePyView;

implementation

{$R *.lfm}

{ TDicePyView }

procedure TDicePyView.Timer1Timer(Sender: TObject);
begin
  Close;
  FreeAndNil(self);
end;

constructor TDicePyView.Execute(TheOwner: TComponent; Values : string);
  var
    Aux: TStringList;
    i,j : integer;

  procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
  begin
   //  ListOfStrings.Clear;
     ListOfStrings.Delimiter       := Delimiter;
     ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
     ListOfStrings.DelimitedText   := Str;
  end;
begin
  Create(TheOwner);
    Aux := TStringList.Create;
    Split(';', Values, Aux);

     case Aux.Count of
        3 : begin
          lbD1.Caption := Aux[0];
          lbD2.Caption := Aux[1];
          lbD3.Caption := Aux[2];
        end;
        5 :  begin
          lbD1.Caption := Aux[0];
          lbD2.Caption := Aux[1];
        end;
        6 : begin
          lbD2.Caption := Aux[0];
        end;
    end;

    img1.Visible:=  lbD1.Caption <> '0';
    lbD1.Visible:=  img1.Visible;

    img2.Visible:=  lbD2.Caption <> '0';
    lbD2.Visible:=  img2.Visible;

    img3.Visible:=  lbD3.Caption <> '0';
    lbD3.Visible:=  img3.Visible;

end;

procedure TDicePyView.Panel1Click(Sender: TObject);
begin

end;

procedure TDicePyView.FormShow(Sender: TObject);
begin
  Timer1.Enabled:= true;
end;

end.

