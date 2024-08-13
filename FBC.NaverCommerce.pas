unit FBC.NaverCommerce;

interface

{$REGION 'USES'}
uses
  Winapi.Windows,

  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.DateUtils,
  System.NetEncoding,
  System.Net.HttpClient,

  FBC.Bcrypt,
  FBC.Json;
{$ENDREGION}

type
  INaverResponse = interface
    ['{BA41BF51-D516-4217-BFF5-51F08A67A651}']
    function  GetData: TJSONObject;
    function  GetStatusCode: Integer;

    property Data: TJSONObject read GetData;
    property StatusCode: Integer read GetStatusCode;
  end;

  TNaverResponse = class(TInterfacedObject, INaverResponse)
  private
    FData: TJSONObject;
    FStatusCode: Integer;

    function  GetData: TJSONObject;
    function  GetStatusCode: Integer;
  public
    constructor Create(const AResponse: IHTTPResponse);
    destructor Destroy; override;

    property Data: TJSONObject read GetData;
    property StatusCode: Integer read GetStatusCode;
  end;

  TNaverCommerce = class
  strict private
    FAccessToken: string;
    FAccountID: string;
    FBaseURL: string;
    FClientID: string;
    FClientSecret: string;
    FHttpClient: THttpClient;
    FLastTokenAt: TDateTime;
  private
    function  GetUnixTime: Int64;
  public
    constructor Create;
    destructor Destroy; override;

    function  AccountInfo: INaverResponse;
    function  CustomerStatus(const ABeginDate, AEndDate: TDateTime): INaverResponse;
    function  GetToken: INaverResponse;
    function  LastChangedStatuses: INaverResponse;
    function  ProductOrders: INaverResponse;

    property AccessToken: string read FAccessToken;
    property AccountID: string read FAccountID write FAccountID;
    property BaseURL: string read FBaseURL write FBaseURL;
    property ClientID: string read FClientID write FClientID;
    property ClientSecret: string read FClientSecret write FClientSecret;
    property LastTokenAt: TDateTime read FLastTokenAt;
  end;

implementation

{$REGION 'TNaverResponse'}

constructor TNaverResponse.Create(const AResponse: IHTTPResponse);
begin
  FStatusCode := AResponse.StatusCode;
  AResponse.ContentStream.Position := 0;
  FData := TJSONObject.ParseFromStream(AResponse.ContentStream, TEncoding.UTF8) as TJSONObject;
end;

destructor TNaverResponse.Destroy;
begin
  FData.Free;

  inherited;
end;

function TNaverResponse.GetData: TJSONObject;
begin
  Result := FData;
end;

function TNaverResponse.GetStatusCode: Integer;
begin
  Result := FStatusCode;
end;

{$ENDREGION}

{$REGION 'TNaverCommerce'}

constructor TNaverCommerce.Create;
begin
  FBaseURL := 'https://api.commerce.naver.com/external';
  FHttpClient := THttpClient.Create;
  FHttpClient.ContentType := 'application/json;charset=UTF-8';

  FLastTokenAt := 0;
end;

destructor TNaverCommerce.Destroy;
begin
  FHttpClient.Free;

  inherited;
end;

function TNaverCommerce.AccountInfo: INaverResponse;
var
  LURL: string;
begin
  LURL := Format('%s/v1/seller/account', [FBaseURL]);
  FHttpClient.CustHeaders.Add('Authorization', 'Bearer ' + FAccessToken);

  Result := TNaverResponse.Create(FHttpClient.Get(LURL));
end;

function TNaverCommerce.CustomerStatus(const ABeginDate, AEndDate: TDateTime): INaverResponse;
var
  LURL: string;
begin
  LURL := Format('%s/v1/customer-data/customer-status/account/statistics?startDate=%s&endDate=%s',
    [FBaseURL, FormatDateTime('yyyy-mm-dd', ABeginDate), FormatDateTime('yyyy-mm-dd', AEndDate)]);
  FHttpClient.CustHeaders.Add('Authorization', 'Bearer ' + FAccessToken);

  Result := TNaverResponse.Create(FHttpClient.Get(LURL));
end;

function TNaverCommerce.GetToken: INaverResponse;
const
  PARAMS = 'client_id=%s&timestamp=%d&grant_type=client_credentials&client_secret_sign=%s&type=SELF&account_id=%s';
var
  LParam: string;
  LStream: TStringStream;
  LUrl: string;
  LResponse: IHTTPResponse;
  LClientSecretSign: string;
  LTimeStamp: Int64;
begin
  LTimeStamp := GetUnixTime;
  LClientSecretSign := HashPassword(FClientID + '_' + IntToStr(LTimeStamp), FClientSecret);

  LParam := Format(PARAMS, [FClientID, LTimeStamp, LClientSecretSign, FAccountID]);
  LStream := TStringStream.Create(LParam, TEncoding.UTF8);
  try
    FHttpClient.ContentType := 'application/x-www-form-urlencoded';
    LURL := Format('%s/v1/oauth2/token', [FBaseURL]);
    LResponse := FHttpClient.Post(LURL, LStream);

    Result := TNaverResponse.Create(LResponse);
    if LResponse.StatusCode = 200 then
    begin
      FAccessToken := Result.Data.S['access_token'];
    end;
  finally
    LStream.Free;
  end;
end;

function TNaverCommerce.GetUnixTime: Int64;
var
  LDateTime: TDateTime;
  LLocalTime: SystemTime;
begin
  Winapi.Windows.GetLocalTime(LLocalTime);
  LDateTime := System.SysUtils.EncodeDate(LLocalTime.wYear, LLocalTime.wMonth, LLocalTime.wDay) +
               System.SysUtils.EncodeTime(LLocalTime.wHour, LLocalTime.wMinute, LLocalTime.wSecond, LLocalTime.wMilliseconds);

  Result := System.DateUtils.MilliSecondsBetween(LDateTime, UnixDateDelta);
end;

function TNaverCommerce.LastChangedStatuses: INaverResponse;
var
  LURL: string;
begin
  LURL := Format('%s/v1/pay-order/seller/product-orders/last-changed-statuses', [FBaseURL]);
  FHttpClient.CustHeaders.Add('Authorization', 'Bearer ' + FAccessToken);

  Result := TNaverResponse.Create(FHttpClient.Get(LURL));
end;

function TNaverCommerce.ProductOrders: INaverResponse;
var
  LURL: string;
begin
  LURL := Format('%s/v1/pay-order/seller/product-orders/query', [FBaseURL]);
  FHttpClient.CustHeaders.Add('Authorization', 'Bearer ' + FAccessToken);

  Result := TNaverResponse.Create(FHttpClient.Get(LURL));
end;

{$ENDREGION}

end.
