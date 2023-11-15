unit compRPG;

{$mode objfpc}{$H+}
interface


type
  ICompRPG = interface
    function Execute(Owner : TObject;  Value: string): boolean;
  end;

  { TCompRPG }

  TCompRPG = class
    private
    public
      class function Execute(Owner : TObject; Value : string) : boolean;
      function ExtractOrigin(Value : string) : string;
      function ExtractMessage(Value : string; Index : integer =1 ) : string;
  end;




implementation

uses dicepy, arduinonfc, menu, ficha, classes;

{ TCompRPG }

class function TCompRPG.Execute(Owner : TObject; Value: string): boolean;
var
   LObj : ICompRPG;
begin
     With TCompRPG.Create do
     Try

     if (ExtractOrigin(Value) = 'dicepy') then
     begin
        LObj :=  TDicepy.Create;
        LObj.Execute(Owner, ExtractMessage(Value));
     end;


     if (Copy(ExtractOrigin(Value),1,3) = 'nfc')
        and (TFMenu(Owner).FModo = mLeituraNFC) then
           TFFicha.Execute(ExtractMessage(Value,2),Owner);
     finally
       Free;
     end;

end;

function TCompRPG.ExtractOrigin(Value: string): string;
begin
  Result := Copy(Value, 0, Pos(';', Value)-1);
end;

function TCompRPG.ExtractMessage(Value: string; Index : integer): string;
var
  Aux : TStringList;
  procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
  begin
       ListOfStrings.Delimiter       := Delimiter;
       ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
       ListOfStrings.DelimitedText   := Str;
    end;
begin
  Aux := TStringList.Create;
  Split(';',Value,Aux);
  Result := Aux[Index];
end;

end.

