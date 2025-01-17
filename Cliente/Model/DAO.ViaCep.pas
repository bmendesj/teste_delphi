unit DAO.ViaCep;

interface

uses
  System.SysUtils, System.Classes, REST.Types,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, REST.Response.Adapter, REST.Client, Data.Bind.Components,
  Data.Bind.ObjectScope, System.JSON;

type
  TDAOViaCep = class(TDataModule)
    Adapter: TRESTResponseDataSetAdapter;
    DataSet: TFDMemTable;
    DataSource: TDataSource;
    Client: TRESTClient;
    Request: TRESTRequest;
    Response: TRESTResponse;
    DataSetcep: TStringField;
    DataSetlogradouro: TStringField;
    DataSetcomplemento: TStringField;
    DataSetbairro: TStringField;
    DataSetlocalidade: TStringField;
    DataSetuf: TStringField;
    DataSetibge: TStringField;
    DataSetgia: TStringField;
    DataSetddd: TStringField;
    DataSetsiafi: TStringField;
  strict private
    { Private declarations }
    class var FInstance: TDAOViaCep;
    constructor PrivateCreate;
  public
    { Public declarations }
    class function GetInstance:TDAOViaCep;

    constructor Create;
    destructor  Destroy; override;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDAOViaCep }

constructor TDAOViaCep.Create;
begin
  raise Exception.Create('Para obter uma instancia de DAO pessoas invoque o m�todo GetIntance');
end;

destructor TDAOViaCep.Destroy;
begin
  inherited;
end;

class function TDAOViaCep.GetInstance: TDAOViaCep;
begin
  if not Assigned(FInstance) then
    FInstance:= TDAOViaCep.PrivateCreate;

  Result:= FInstance;
end;

constructor TDAOViaCep.PrivateCreate;
begin
  inherited Create(nil);
end;

end.
