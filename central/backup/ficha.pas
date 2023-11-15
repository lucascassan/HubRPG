unit Ficha;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, MaskEdit, Buttons, Spin, Database;

type

  { TFFicha }

  TFFicha = class(TForm)
    btSalvar: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    btCancelar: TBitBtn;
    cbIDImagem: TComboBox;
    btExcluir: TBitBtn;
    GroupBox1: TGroupBox;
    Image1: TImage;
    lbStatus: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mkDestreza: TMaskEdit;
    mkTag: TMaskEdit;
    mkNome: TMaskEdit;
    mkClasse: TMaskEdit;
    mkForca: TMaskEdit;
    mkAgilidade: TMaskEdit;
    mkInteligencia: TMaskEdit;
    mkVitalidade: TMaskEdit;
    mkCarisma: TMaskEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    lbaadas: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    procedure btCancelarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Label7Click(Sender: TObject);
    procedure SQLite3Connection1AfterConnect(Sender: TObject);
  private
    FID : integer;

  public
    class function Execute( ATag : string; AOwner : TObject) : boolean;


  end;

var
  FFicha: TFFicha;

implementation

uses
  leituraficha;

{$R *.lfm}


{ TFFicha }

procedure TFFicha.Label7Click(Sender: TObject);
begin

end;

procedure TFFicha.Button1Click(Sender: TObject);
begin



end;

procedure TFFicha.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFFicha.btCancelarClick(Sender: TObject);
begin
   Close;
end;

procedure TFFicha.btExcluirClick(Sender: TObject);
begin

end;

procedure TFFicha.btSalvarClick(Sender: TObject);
begin
   With TFDatabase.Create(nil) do
     Try
       With Query, SQL do
       begin
         if (FID > 0) then
         begin
           Add('UPDATE Fichas');
           Add('      SET');
           Add('      Tag = :Tag,');
           Add('      Nome = :Nome,');
           Add('      Classe = :Classe,');
           Add('      Forca = :Forca,');
           Add('      Agilidade = :Agilidade,');
           Add('      Vitalidade = :Vitalidade,');
           Add('      Inteligencia = :Inteligencia,');
           Add('      Destreza = :Destreza,');
           Add('      Carisma = :Carisma,');
           Add('      IDImagem = :IDImagem');
           Add('WHERE ID = :ID');
           ParamByName('ID').Value           := FID;
         end
         else
         begin
           SQL.Add('INSERT INTO Fichas(');
           SQL.Add('       Tag, Nome, Classe, Forca, Agilidade, Vitalidade,');
           SQL.Add('       Inteligencia, Destreza, Carisma, IDImagem)');
           SQL.Add('VALUES (');
           SQL.Add('       :Tag, :Nome, :Classe, :Forca, :Agilidade, :Vitalidade,');
           SQL.Add('       :Inteligencia, :Destreza, :Carisma, :IDImagem)');
         end;
         ParamByName('Tag').Value 	     := mkTag.Text;
         ParamByName('Nome').Value           := mkNome.Text;
         ParamByName('Classe').Value 	     := mkClasse.Text;
         ParamByName('Forca').Value 	     := StrToIntDef(mkForca.Text, 0);
         ParamByName('Agilidade').Value      := StrToIntDef(mkAgilidade.Text, 0);
         ParamByName('Vitalidade').Value     := StrToIntDef(mkVitalidade.Text, 0);
         ParamByName('Inteligencia').Value   := StrToIntDef(mkInteligencia.Text, 0);
         ParamByName('Destreza').Value 	     := StrToIntDef(mkDestreza.Text, 0);
         ParamByName('Carisma').Value 	     := StrToIntDef(mkCarisma.Text, 0);
         ParamByName('IDImagem').Value 	     := cbIDImagem.Text;
         ExecSQL;
       end;
     finally
       Free;
     end;


   Close;
end;

procedure TFFicha.SQLite3Connection1AfterConnect(Sender: TObject);
begin

end;

class function TFFicha.Execute(ATag: string; AOwner : TObject): boolean;
begin

  if not Assigned(FFicha) then
      FFicha := TFFicha.Create(nil);
  With FFicha do
  try
     if (ATag = '') then
       Exit;

     With TFDatabase.Create(nil) do
     Try
       With Query, SQL do
       begin
         Add('SELECT *');
         Add('FROM Fichas');
         Add('WHERE Tag = :Tag');
         ParamByName('Tag').Value := ATag;
         Open;

         if not (IsEmpty) then
         begin
           FID  := FieldByName('ID').AsInteger;
           mkTag.Text           := FieldByName('Tag').AsString;
           mkNome.Text          := FieldByName('Nome').AsString;
           mkClasse.Text        := FieldByName('Classe').AsString;
           mkForca.Text         := FieldByName('Forca').AsString;
           mkAgilidade.Text     := FieldByName('Agilidade').AsString;
           mkVitalidade.Text    := FieldByName('Vitalidade').AsString;
           mkInteligencia.Text  := FieldByName('Inteligencia').AsString;
           mkDestreza.Text      := FieldByName('Destreza').AsString;
           mkCarisma.Text       := FieldByName('Carisma').AsString;
           cbIDImagem.Text      := FieldByName('IdImagem').AsString;
          //loadImage();
           lbStatus.Caption:= 'Alterando';
         end
         else
         begin
           FID := 0;
           mkTag.Text      := ATag;
           mkTag.Text           := '';
           mkNome.Text          := '';
           mkClasse.Text        := '';
           mkForca.Text         := '0';
           mkAgilidade.Text     := '0';
           mkVitalidade.Text    := '0';
           mkInteligencia.Text  := '0';
           mkDestreza.Text      := '0';
           mkCarisma.Text       := '0';
           cbIDImagem.Text      := '0';
           lbStatus.Caption:= 'Nova Ficha';
         end;

       end;
     Finally
       Free;
     End;
     Parent := TWinControl(AOwner);
     Top:= 0;
     Left:= 0;
     FLeituraFicha.Close;
     Show;
  finally
  end;

end;

end.













