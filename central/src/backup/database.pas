unit Database;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLDB, SQLite3Conn;

type

  { TFDatabase }

  TFDatabase = class(TDataModule)
    SQLite3: TSQLite3Connection;
    Query: TSQLQuery;
    Transaction: TSQLTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private

  public
    class procedure InitTables();
  end;

var
  FDatabase: TFDatabase;

implementation

{$R *.lfm}

{ TFDatabase }

procedure TFDatabase.DataModuleCreate(Sender: TObject);
begin
  SQLite3.Connected:= true;
  Transaction.StartTransaction;
end;

procedure TFDatabase.DataModuleDestroy(Sender: TObject);
begin
  Transaction.Commit;
  SQLite3.Connected:= false;
end;

class procedure TFDatabase.InitTables();
begin
 With TFDatabase.Create(nil) do
  Try
     With Query do
     begin
       SQL.Text := 'CREATE TABLE IF NOT EXISTS Fichas( '+
	        'ID INTEGER primary key AUTOINCREMENT, '+
	        'Tag varchar(20), '+
	        'Nome varchar(30), '+
	        'Classe varchar(30), '+
                'Raca varchar(30),'+
	        'Forca tinyint, '+
	        'Agilidade tinyint, '+
	        'Vitalidade tinyint, '+
	        'Inteligencia tinyint, '+
	        'Destreza tinyint, '+
	        'Carisma tinyint, '+
	        'IdImagem int()';
        ExecSQL;
     end;
    finally
      Free;
    end;
end;


end.

