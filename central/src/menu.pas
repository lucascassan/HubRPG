unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, lNet, lNetComponents, Interpretador, dicepy, database, messagealert, process, LeituraFicha, batalha;

type

TModo = ( mNone, mLeituraNFC, mBatalha);


  { TFMenu }

  TFMenu = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LTCP: TLTCPComponent;
    LTCPDice : TLTCPComponent;
    pMusic: TPanel;
    pStatus: TPanel;
    pDice: TPanel;
    pStatus1: TPanel;
    pTimer: TPanel;
    pToken: TPanel;
    pDuel: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure onReceive(aSocket: TLSocket);
    procedure pDuelClick(Sender: TObject);
    procedure pMusicClick(Sender: TObject);
    procedure pStatus1Click(Sender: TObject);
    procedure pTokenClick(Sender: TObject);
    procedure SendMessageToDice(aSocket: TLSocket);
    procedure onReceiveDice(aSocket : TLSocket);
    procedure onErrorDice(const msg: string; aSocket: TLSocket);
    procedure pDiceClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);


  private
    IPlocalhost : string;
    procedure StartTCP();
  public
    FModo : TModo;
  end;

var
  FMenu: TFMenu;



implementation

{$R *.lfm}

{ TFMenu }

procedure TFMenu.FormCreate(Sender: TObject);
begin
  TFDatabase.InitTables();

  {$IFDEF LINUX}
  FMenu.WindowState := wsFullScreen;
  FMenu.BorderStyle := bsNone;
  IPLocalhost       := '192.168.15.150';
  {$ENDIF}

  {$IFDEF WINDOWS}
  IPlocalhost := 'localhost';
  {$ENDIF}

  StartTCP();
 // pMusic.Color:= clGray;

end;

procedure TFMenu.onReceive(aSocket: TLSocket);
var s : string;
begin
   if (aSocket.GetMessage(s)>0) then
   begin
      if (FModo <> mNone) then
         TInterpretador.Execute(Self, s);
      LTCP.SendMessage(s, aSocket);
   end;
end;

procedure TFMenu.pDuelClick(Sender: TObject);
begin
  TFBatalha.Execute(Self);
end;

procedure TFMenu.pMusicClick(Sender: TObject);
var s : string;
begin
 //RunCommand('mplayer .1.wav', s, s);
end;

procedure TFMenu.pStatus1Click(Sender: TObject);
begin
  Close();
end;

procedure TFMenu.pTokenClick(Sender: TObject);
begin
  TFLeituraFicha.Execute(Self);
end;

procedure TFMenu.SendMessageToDice(aSocket: TLSocket);
begin
   LTCPDice.SendMessage('start', aSocket);
end;

procedure TFMenu.onReceiveDice(aSocket: TLSocket);
var s : string;
begin
  if (aSocket.GetMessage(s)>0) then
   begin
     TInterpretador.Execute(Self, s);
   end;
end;

procedure TFMenu.onErrorDice(const msg: string; aSocket: TLSocket);
begin
 // pDice.Color:= clGray;
end;

procedure TFMenu.pDiceClick(Sender: TObject);
begin
  TFMessageAlert.Execute('Jogue os dados', Self);
  Application.ProcessMessages;
  Sleep(5000);
  SendMessageToDice(LTCPDice.Iterator);
end;

procedure TFMenu.Timer1Timer(Sender: TObject);
begin
  pTimer.Caption := FormatDateTime('DD/MM/YY hh:mm', Now());
end;


procedure TFMenu.StartTCP();
begin
  FModo:= mNone;
  LTCP := TLTCPComponent.Create(self);
  LTCP.Host:= 'localhost';
  LTCP.OnReceive:= @onReceive;
  if not (LTCP.Listen(1234)) then
  begin
     pStatus.Color:= clBlack;
     pStatus.Caption := 'Status: Erro ao criar a conexão.';
  end;

  LTCPDice := TLTCPComponent.Create(self);
  LTCPDice.OnReceive := @onReceiveDice;
  LTCPDice.OnError   := @onErrorDice;
  LTCPDice.Connect(IPlocalhost, 4321);
end;

end.

