unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,

  FBC.NaverCommerce;

type
  TfrmMain = class(TForm)
    btnToken: TButton;
    eLog: TMemo;
    Label1: TLabel;
    eAccountID: TEdit;
    Label2: TLabel;
    eClientID: TEdit;
    Label3: TLabel;
    eSecret: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure btnTokenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    FNaverCommerce: TNaverCommerce;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

constructor TfrmMain.Create(AOwner: TComponent);
begin
  inherited;

  FNaverCommerce := TNaverCommerce.Create;
end;

destructor TfrmMain.Destroy;
begin
  FNaverCommerce.Free;

  inherited;
end;

procedure TfrmMain.btnTokenClick(Sender: TObject);
begin
  FNaverCommerce.AccountID := eAccountID.Text;
  FNaverCommerce.ClientID := eClientID.Text;
  FNaverCommerce.ClientSecret := eSecret.Text;

  var LResponse := FNaverCommerce.GetToken;
  eLog.Lines.Add(LResponse.Data.ToJSON);
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  var LBeginDate := Now() - 180;
  var LEndDate := Now();
  var LResponse := FNaverCommerce.CustomerStatus(LBeginDate, LEndDate);
  eLog.Lines.Add(LResponse.Data.ToJSON);
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  var LResponse := FNaverCommerce.AccountInfo;
  eLog.Lines.Add(LResponse.Data.ToJSON);
end;

end.
