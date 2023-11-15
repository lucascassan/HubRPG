unit Ficha;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, SQLite3Conn, SQLDB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, MaskEdit, Buttons, Spin, Database, StrUtils, question;

type

  { TFFicha }

  TFFicha = class(TForm)
    Label14: TLabel;
    MinuCarisma: TBitBtn;
    mkDisponiveis: TMaskEdit;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel2: TPanel;
    pAdvertencia: TPanel;
    pExcluir: TPanel;
    PlusCarisma: TBitBtn;
    MinuDestreza: TBitBtn;
    PlusDestreza: TBitBtn;
    PlusForca: TBitBtn;
    MinuForca: TBitBtn;
    MinuAgilidade: TBitBtn;
    PlusAgilidade: TBitBtn;
    MinuInteligencia: TBitBtn;
    PlusInteligencia: TBitBtn;
    MinuVitalidade: TBitBtn;
    PlusVitalidade: TBitBtn;
    cbIDImagem: TComboBox;
    GroupBox1: TGroupBox;
    Image1: TImage;
    Label10: TLabel;
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
    mkRaca: TMaskEdit;
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
    pImagem: TPanel;
    Panel3: TPanel;
    lbaadas: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure AddPoint(Sender: TObject);
    procedure btCancelarClick(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbIDImagemChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure Label7Click(Sender: TObject);
    procedure mkNomeEnter(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure PlusForcaClick(Sender: TObject);
    procedure SQLite3Connection1AfterConnect(Sender: TObject);
  private
    FID : integer;
    procedure LoadImage(AID : string);
    function CalculaPontos() : boolean;
    function Validacao() : boolean;

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

procedure TFFicha.mkNomeEnter(Sender: TObject);
begin
  pAdvertencia.Visible:= False;
end;

procedure TFFicha.Panel1Click(Sender: TObject);
begin

end;

procedure TFFicha.PlusForcaClick(Sender: TObject);
begin

end;

procedure TFFicha.Button1Click(Sender: TObject);
begin



end;

procedure TFFicha.cbIDImagemChange(Sender: TObject);
begin
  LoadImage(IntToStr(cbIDImagem.ItemIndex));
end;

procedure TFFicha.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFFicha.btCancelarClick(Sender: TObject);
begin
   Close;
end;

procedure TFFicha.AddPoint(Sender: TObject);
var
  LStatus : string;
  LValue : integer;
begin



   LStatus := Copy((Sender as TBitBtn).Name, 5, 20);
   LValue  := StrToIntDef( (FindComponent('mk'+LStatus) as TMaskEdit).Text, 0);

   if Pos( 'Minu', (Sender as TBitBtn).Name) > 0 then
      Dec(LValue)
   else
   begin
      Inc(LValue);
      if StrToIntDef(mkDisponiveis.Text, 0) = 0 then
         Exit;
   end;

   (FindComponent('mk'+LStatus) as TMaskEdit).Text := IntToStr(LValue);

    TBitBtn(FindComponent('Minu'+LStatus)).Enabled := (LValue <> 0);
    TBitBtn(FindComponent('Plus'+LStatus)).Enabled := (LValue <> 10);

    CalculaPontos();

end;

procedure TFFicha.btExcluirClick(Sender: TObject);
begin

   if not TFQuestion.Execute() then
      Exit;

   With TFDatabase.Create(nil) do
     Try
       With Query, SQL do
       begin
         if (FID > 0) then
         begin
           Add('DELETE FROM Fichas');
           Add('WHERE ID = :ID');
           ParamByName('ID').Value           := FID;
           ExecSQL;
         end
       end;
     finally
       Free;
     end;

   Close();



end;

procedure TFFicha.btSalvarClick(Sender: TObject);
begin

  if not Validacao() then
     Exit;

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
           Add('      Raca = :Raca,');
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
           SQL.Add('       Tag, Nome, Classe, Raca, Forca, Agilidade, Vitalidade,');
           SQL.Add('       Inteligencia, Destreza, Carisma, IDImagem)');
           SQL.Add('VALUES (');
           SQL.Add('       :Tag, :Nome, :Classe,:Raca, :Forca, :Agilidade, :Vitalidade,');
           SQL.Add('       :Inteligencia, :Destreza, :Carisma, :IDImagem)');
         end;
         ParamByName('Tag').Value 	     := mkTag.Text;
         ParamByName('Nome').Value           := mkNome.Text;
         ParamByName('Classe').Value 	     := mkClasse.Text;
         ParamByName('Raca').Value 	     := mkRaca.Text;
         ParamByName('Forca').Value 	     := StrToIntDef(mkForca.Text, 0);
         ParamByName('Agilidade').Value      := StrToIntDef(mkAgilidade.Text, 0);
         ParamByName('Vitalidade').Value     := StrToIntDef(mkVitalidade.Text, 0);
         ParamByName('Inteligencia').Value   := StrToIntDef(mkInteligencia.Text, 0);
         ParamByName('Destreza').Value 	     := StrToIntDef(mkDestreza.Text, 0);
         ParamByName('Carisma').Value 	     := StrToIntDef(mkCarisma.Text, 0);
         ParamByName('IDImagem').Value 	     := cbIDImagem.ItemIndex;
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

procedure TFFicha.LoadImage(AID: string);
begin
  Try
     Image1.Picture.LoadFromFile('assets/char/'+AID+'.png');
     pImagem.Caption := '';
  Except
    Image1.Picture := nil;
    pImagem.Caption := 'Sem Imagem';
  end;
end;

function TFFicha.CalculaPontos(): boolean;
var  LAtuais : integer;
     LMax : integer;
     LDisponivel : integer;
begin
  LAtuais := StrToIntDef(mkForca.Text, 0)+
             StrToIntDef(mkAgilidade.Text, 0)+
             StrToIntDef(mkVitalidade.Text, 0)+
             StrToIntDef(mkInteligencia.Text, 0)+
             StrToIntDef(mkDestreza.Text, 0)+
             StrToIntDef(mkCarisma.Text, 0);

  LMax := 30;
  LDisponivel:= LMax-LAtuais;

  mkDisponiveis.Text:= IntToStr(LDisponivel);



end;

function TFFicha.Validacao(): boolean;

  procedure ShowAdvertencia(AMsg : string);
  begin
    pAdvertencia.Caption:= 'Atenção: '+AMsg;
    pAdvertencia.Visible:= true;
    Abort;
  end;


begin
  result := false;
  if Trim(mkNome.Text)='' then
     ShowAdvertencia('Informe o Nome do Personagem');
  if Trim(mkClasse.Text)='' then
     ShowAdvertencia('Informe a Classe do Personagem');
  if Trim(mkRaca.Text)='' then
     ShowAdvertencia('Informe a Raça do Personagem');
  if StrToIntDef(mkDisponiveis.Text,0)>0 then
     ShowAdvertencia('Distribua todos os Pontos Disponíveis');
  if cbIDImagem.ItemIndex = 0 then
     ShowAdvertencia('Selecione uma Imagem');

  pAdvertencia.Visible:= False;
  Result := True;
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
           mkRaca.Text        := FieldByName('Raca').AsString;
           mkForca.Text         := FieldByName('Forca').AsString;
           mkAgilidade.Text     := FieldByName('Agilidade').AsString;
           mkVitalidade.Text    := FieldByName('Vitalidade').AsString;
           mkInteligencia.Text  := FieldByName('Inteligencia').AsString;
           mkDestreza.Text      := FieldByName('Destreza').AsString;
           mkCarisma.Text       := FieldByName('Carisma').AsString;
           cbIDImagem.ItemIndex := FieldByName('IdImagem').AsInteger;
           loadImage(IntToStr(cbIDImagem.ItemIndex));
           pExcluir.Color:= RGBToColor(103,159,252);
           pExcluir.Enabled:= true;
           lbStatus.Caption:= 'Alterando';
         end
         else
         begin
           FID := 0;
           mkTag.Text           := ATag;
           mkNome.Text          := '';
           mkClasse.Text        := '';
           mkForca.Text         := '0';
           mkAgilidade.Text     := '0';
           mkVitalidade.Text    := '0';
           mkInteligencia.Text  := '0';
           mkDestreza.Text      := '0';
           mkCarisma.Text       := '0';
           cbIDImagem.Text      := '0';
           cbIDImagem.ItemIndex := 0;
           LoadImage('0');
           pExcluir.Color:= RGBToColor(157,174,201);
           pExcluir.Enabled:= false;
           lbStatus.Caption:= 'Nova Ficha';
         end;

         CalculaPontos();

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













