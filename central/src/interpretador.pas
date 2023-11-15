unit Interpretador;

{$mode objfpc}{$H+}
interface


type

  TInterpretador = class
    private
    public
      class function Execute(Owner : TObject; Value : string) : boolean;
      function ExtractOrigin(Value : string) : string;
      function ExtractMessage(Value : string; Index : integer = 0 ) : string;
  end;

implementation

uses dicepy, menu, ficha, classes, batalha;

{ TCompRPG }

class function TInterpretador.Execute(Owner : TObject; Value: string): boolean;
begin
     With TInterpretador.Create do
     Try

     if (ExtractOrigin(Value) = 'dicepy') then
     begin
        With TDicepy.Create do
          Execute(Owner, ExtractMessage(Value));
     end;

     if (Copy(ExtractOrigin(Value),1,3) = 'nfc')
        and (TFMenu(Owner).FModo = mLeituraNFC) then
           TFFicha.Execute(ExtractMessage(Value,2),Owner);


      if (Copy(ExtractOrigin(Value),1,3) = 'nfc')
        and (TFMenu(Owner).FModo = mBatalha) then
            FBatalha.LoadPlayer(ExtractMessage(Value,1),ExtractMessage(Value,2)) ;

     finally
       Free;
     end;





end;

function TInterpretador.ExtractOrigin(Value: string): string;
begin
  Result := Copy(Value, 0, Pos(';', Value)-1);
end;

function TInterpretador.ExtractMessage(Value: string; Index : integer): string;
var
  Aux : TStringList;
  procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
  begin
       ListOfStrings.Delimiter       := Delimiter;
       ListOfStrings.StrictDelimiter := True; // Requires D2006 or newer.
       ListOfStrings.DelimitedText   := Str;
    end;
begin
  if (index > 0) then
  begin
     Aux := TStringList.Create;
     Split(';',Value,Aux);
     Result := Aux[Index]
  end
  else
     Result := Copy(Value, Pos(';', Value)+1, 10);

end;

end.

