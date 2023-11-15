unit dicepy;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,CompRPG, stdCtrls,Controls, Dicepy.View,lNet, lNetComponents;


type
    { TDicepy }

    TDicepy = class(TInterfacedObject, ICompRPG)
    private
    public
    function Execute(Owner : TObject; Value: string): boolean;
    function Send(): boolean;
end;

implementation

{ TDicepy }

function TDicepy.Execute(Owner : TObject; Value: string): boolean;
var
 LForm : TDicePyView;
begin

 LForm := TDicePyView.Execute(nil, Value);
 LForm.Parent := TWinControl(Owner);
 LForm.Top:= 0;
 LForm.Left:= 0;

 //LForm.Label1.Caption:= Value;
 LForm.Show;
end;

function TDicepy.Send(): boolean;
var
  LTCP : TLTCPComponent;
begin
  LTCP := TLTCPComponent.Create(nil);
  LTCP.Host:= 'localhost';
  LTCP.Connect('localhost', 4321);

  LTCP.SendMessage('teste');
end;

end.

