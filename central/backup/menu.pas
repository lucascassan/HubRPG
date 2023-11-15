unit menu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, lNet, lNetComponents, CompRPG, dicepy, messagealert, padroes, process, LeituraFicha;

type

TModo = ( mNone, mLeituraNFC);


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
    pStatus: TPanel;
    pDice: TPanel;
    pMusic: TPanel;
    pToken: TPanel;
    pDuel: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure onReceive(aSocket: TLSocket);
    procedure pDuelClick(Sender: TObject);
    procedure pMusicClick(Sender: TObject);
    procedure pTokenClick(Sender: TObject);
    procedure SendMessageToDice(aSocket: TLSocket);
    procedure onReceiveDice(aSocket : TLSocket);
    procedure onErrorDice(const msg: string; aSocket: TLSocket);
    procedure pDiceClick(Sender: TObject);

  private
    procedure start();

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
  start();
  {$IFDEF LINUX}
  FMenu.WindowState := wsFullScreen;
  FMenu.BorderStyle := bsNone;
  {$ENDIF}
end;

procedure TFMenu.onReceive(aSocket: TLSocket);
var s : string;
begin
   if (aSocket.GetMessage(s)>0) then
   begin
      if (FModo <> mNone) then
         TCompRPG.Execute(Self, s);
      LTCP.SendMessage(s, aSocket);
   end;
end;

procedure TFMenu.pDuelClick(Sender: TObject);
begin

end;

procedure TFMenu.pMusicClick(Sender: TObject);
var s : string;
begin
     //RunCommand('mplayer .1.wav', s, s);
end;

procedure TFMenu.pTokenClick(Sender: TObject);
begin
  TFLeituraFicha.Execute(Self);

  //TFFicha.Execute('AAA', FMenu);
end;

procedure TFMenu.SendMessageToDice(aSocket: TLSocket);
begin
end;

procedure TFMenu.onReceiveDice(aSocket: TLSocket);
var s : string;
begin
  if (aSocket.GetMessage(s)>0) then
   begin
     TCompRPG.Execute(Self, s);
   end;
end;

procedure TFMenu.onErrorDice(const msg: string; aSocket: TLSocket);
begin
     pDice.Color:= clGray;
end;

procedure TFMenu.pDiceClick(Sender: TObject);
begin
  TFMessageAlert.Execute('Jogue os dados', Self);
  Application.ProcessMessages;
  Sleep(5000);
  SendMessageToDice(LTCPDice.Iterator);
end;

procedure TFMenu.start();
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
  LTCPDice.Connect('localhost', 4321);
end;

end.

