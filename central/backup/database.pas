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
  Transaction.EndTransaction;
  SQLite3.Connected:= false;
end;

end.

