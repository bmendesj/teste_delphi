unit Controller.Pessoas;

interface

uses
  DAO.Pessoas, Controller.Enderecos, DTO.Pessoa, DTO.Endereco, uReturnCustom,
  System.Classes, System.SysUtils, System.JSON.Writers, System.JSON.Types,
  System.JSON, Data.DB, REST.Types, FireDAC.Comp.Client;

type
  TControllerPessoa = class
  private
    fDAO:              TDAOPessoas;
    fIdPaginacao:      Int64;
    function Insert(aLista: TJSonArray): Int64; overload;
    function Update(aID:Int64; aLista: TJSonArray): Boolean; overload;
    function Delete(aID:Int64): Boolean; overload;
  public
    function GetDataSource: TDataSource;
    function GetRegistro: TDTOPessoa;
    function Select(aIdPaginacao: Int64 = 0): Boolean;
    function Insert(aPessoa: TDTOPessoa; aEndereco: TDTOEndereco): Int64; overload;
    function Update(aPessoa: TDTOPessoa): Boolean; overload;
    function Delete: Boolean; overload;
    function CargaEmLote(const aLista: TStringList): InT64;
    function Validar(aPessoa: TDTOPessoa): TReturnBoolean;
    procedure Close;
    Procedure InsertSomenteNoDataSet(aPessoa: TDTOPessoa);
    procedure ProximaPagina;
    procedure PaginaAnterior;

    constructor Create;
  published
  end;

implementation

{ TControllerPessoa }

constructor TControllerPessoa.Create;
begin
  fIdPaginacao:= 0;
  fDAO:= TDAOPessoas.GetInstance;
end;

function TControllerPessoa.Select(aIdPaginacao: Int64 = 0): Boolean;
begin
  Result:= False;

  if aIdPaginacao <> 0 then
    fIdPaginacao:= aIdPaginacao;

  fDAO.Adapter.AutoUpdate:= True;
  fDAO.Request.Method:= TRESTRequestMethod.rmGET;
  fDAO.Request.Params.Clear;
  fDAO.Request.Params.AddItem('qIdPaginacao', fIdPaginacao.ToString, TRESTRequestParameterKind.pkQUERY);
  fDAO.Request.Execute;

  if not fDAO.Request.Response.Status.Success then
    raise Exception.Create(fDAO.Request.Response.StatusText);

  Result:= True;
end;

function TControllerPessoa.Insert(aPessoa: TDTOPessoa; aEndereco: TDTOEndereco): Int64;
var
  stringWriter:   TStringWriter;
  jsonTextWriter: TJsonTextWriter;
  jsonArray:      TJSonArray;
begin
  stringWriter:=   nil;
  jsonTextWriter:= nil;

  try
    stringWriter:= TStringWriter.Create;

    jsonTextWriter:= TJsonTextWriter.Create(stringWriter);
    jsonTextWriter.Formatting:= TJsonFormatting.Indented;

    jsonTextWriter.WriteStartArray;
    jsonTextWriter.WriteStartObject;

    jsonTextWriter.WritePropertyName('flnatureza');    jsonTextWriter.WriteValue(aPessoa.Natureza.ToString);
    jsonTextWriter.WritePropertyName('dsdocumento');   jsonTextWriter.WriteValue(aPessoa.Documento);
    jsonTextWriter.WritePropertyName('nmprimeiro');    jsonTextWriter.WriteValue(aPessoa.Primeiro);
    jsonTextWriter.WritePropertyName('nmsegundo');     jsonTextWriter.WriteValue(aPessoa.Segundo);
    jsonTextWriter.WritePropertyName('dtregistro');    jsonTextWriter.WriteValue(FormatDateTime('DD/MM/YYYY', aPessoa.Registro));
    jsonTextWriter.WritePropertyName('dscep');         jsonTextWriter.WriteValue(aEndereco.Cep);
    jsonTextWriter.WritePropertyName('dsuf');          jsonTextWriter.WriteValue(aEndereco.Uf);
    jsonTextWriter.WritePropertyName('nmcidade');      jsonTextWriter.WriteValue(aEndereco.Cidade);
    jsonTextWriter.WritePropertyName('nmbairro');      jsonTextWriter.WriteValue(aEndereco.Bairro);
    jsonTextWriter.WritePropertyName('nmlogradouro');  jsonTextWriter.WriteValue(aEndereco.Logradouro);
    jsonTextWriter.WritePropertyName('dscomplemento'); jsonTextWriter.WriteValue(aEndereco.Complemento);

    jsonTextWriter.WriteEndObject;
    jsonTextWriter.WriteEndArray;

    jsonArray:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(stringWriter.ToString), 0) as TJSONArray;

    Result:= Self.Insert(jsonArray);

    if Result < 1 then
      Exit;

    fDAO.DataSet.Insert;
    fDAO.DataSetidpessoa.Value:=    Result;
    fDAO.DataSetflnatureza.Value:=  aPessoa.Natureza;
    fDAO.DataSetdsdocumento.Value:= aPessoa.Documento;
    fDAO.DataSetnmprimeiro.Value:=  aPessoa.Primeiro;
    fDAO.DataSetnmsegundo.Value:=   aPessoa.Segundo;
    fDAO.DataSetdtregistro.Value:=  aPessoa.Registro;
    fDAO.DataSet.Post;
  finally
    if stringWriter <> nil then
      FreeAndNil(stringWriter);

    if jsonTextWriter <> nil then
      FreeAndNil(jsonTextWriter);
  end;
end;

procedure TControllerPessoa.InsertSomenteNoDataSet(aPessoa: TDTOPessoa);
begin
  fDAO.DataSet.Insert;
  fDAO.DataSetidpessoa.Value:=    aPessoa.Idpessoa;
  fDAO.DataSetflnatureza.Value:=  aPessoa.Natureza;
  fDAO.DataSetdsdocumento.Value:= aPessoa.Documento;
  fDAO.DataSetnmprimeiro.Value:=  aPessoa.Primeiro;
  fDAO.DataSetnmsegundo.Value:=   aPessoa.Segundo;
  fDAO.DataSetdtregistro.Value:=  aPessoa.Registro;
  fDAO.DataSet.Post;
end;

function TControllerPessoa.Insert(aLista: TJSonArray): Int64;
var
 jsonRetorno: TJSONArray;
begin
  Result:= 0;

  if (aLista = nil) or (aLista.Count = 0) then
    raise Exception.Create('Informe a lista de insers�o');

  fDAO.Adapter.AutoUpdate:= False;
  fDAO.Request.Method:= TRESTRequestMethod.rmPOST;
  fDAO.Request.Params.Clear;
  fDAO.Request.Body.ClearBody;
  fDAO.Request.Body.Add(aLista.ToString, ContentTypeFromString(CONTENTTYPE_APPLICATION_JSON));
  fDAO.Request.Execute;

  if not fDAO.Request.Response.Status.Success then
    raise Exception.Create(fDAO.Request.Response.StatusText);

  jsonRetorno:= (fDAO.Request.Response.JSONValue AS TJSONArray);

  Result:= (jsonRetorno.Items[0] AS TJSONObject).GetValue<Int64>('ultimaId');
end;

function TControllerPessoa.Update(aPessoa: TDTOPessoa): Boolean;
var
  stringWriter:   TStringWriter;
  jsonTextWriter: TJsonTextWriter;
  jsonArray:      TJSonArray;
begin
  stringWriter:=   nil;
  jsonTextWriter:= nil;

  try
    stringWriter:= TStringWriter.Create;

    jsonTextWriter:= TJsonTextWriter.Create(stringWriter);
    jsonTextWriter.Formatting:= TJsonFormatting.Indented;

    jsonTextWriter.WriteStartArray;
    jsonTextWriter.WriteStartObject;

    jsonTextWriter.WritePropertyName('flnatureza');    jsonTextWriter.WriteValue(aPessoa.Natureza.ToString);
    jsonTextWriter.WritePropertyName('dsdocumento');   jsonTextWriter.WriteValue(aPessoa.Documento);
    jsonTextWriter.WritePropertyName('nmprimeiro');    jsonTextWriter.WriteValue(aPessoa.Primeiro);
    jsonTextWriter.WritePropertyName('nmsegundo');     jsonTextWriter.WriteValue(aPessoa.Segundo);
    jsonTextWriter.WritePropertyName('dtregistro');    jsonTextWriter.WriteValue(FormatDateTime('DD/MM/YYYY', aPessoa.Registro));

    jsonTextWriter.WriteEndObject;
    jsonTextWriter.WriteEndArray;

    jsonArray:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(stringWriter.ToString), 0) as TJSONArray;

    Result:= Self.Update(aPessoa.Idpessoa, jsonArray);

    if not Result then
      Exit;

    fDAO.DataSet.Edit;
    fDAO.DataSetidpessoa.Value:=    aPessoa.Idpessoa;
    fDAO.DataSetflnatureza.Value:=  aPessoa.Natureza;
    fDAO.DataSetdsdocumento.Value:= aPessoa.Documento;
    fDAO.DataSetnmprimeiro.Value:=  aPessoa.Primeiro;
    fDAO.DataSetnmsegundo.Value:=   aPessoa.Segundo;
    fDAO.DataSetdtregistro.Value:=  aPessoa.Registro;
    fDAO.DataSet.Post;
  finally
    if stringWriter <> nil then
      FreeAndNil(stringWriter);

    if jsonTextWriter <> nil then
      FreeAndNil(jsonTextWriter);
  end;
end;

function TControllerPessoa.Validar(aPessoa: TDTOPessoa): TReturnBoolean;
begin
  Result.Clear;

  if aPessoa.Natureza < 1 then
  begin
    Result.Mensage:= 'Selecione uma Naureza.';
    Exit;
  end;

  if aPessoa.Documento.Length = 0 then
  begin
    Result.Mensage:= 'Informe um documento.';
    Exit;
  end;

  if aPessoa.Documento.Length > 20 then
  begin
    Result.Mensage:= 'O documento deve conter no m�ximo 20 caracteres.';
    Exit;
  end;

  if aPessoa.Primeiro.Length = 0 then
  begin
    Result.Mensage:= 'Informe o Nome.';
    Exit;
  end;

  if aPessoa.Primeiro.Length > 100 then
  begin
    Result.Mensage:= 'O Nome deve conter no m�ximo 100 caracteres.';
    Exit;
  end;

  if aPessoa.Segundo.Length = 0 then
  begin
    Result.Mensage:= 'Informe o Sobreome.';
    Exit;
  end;

  if aPessoa.Segundo.Length > 100 then
  begin
    Result.Mensage:= 'O Sobrenome deve conter no m�ximo 100 caracteres.';
    Exit;
  end;

  Result.HasError:= False;
  Result.Value:=    True;
end;

function TControllerPessoa.Update(aID: Int64; aLista: TJSonArray): Boolean;
begin
  Result:= False;

  if (aLista = nil) or (aLista.Count = 0) then
    raise Exception.Create('Informe a lista de insers�o');

  fDAO.Adapter.AutoUpdate:= False;
  fDAO.Request.Method:= TRESTRequestMethod.rmPUT;
  fDAO.Request.Params.Clear;
  fDao.Request.Params.AddItem('qId', aId.ToString, TRESTRequestParameterKind.pkQUERY);
  fDAO.Request.Body.ClearBody;
  fDAO.Request.Body.Add(aLista.ToString, ContentTypeFromString(CONTENTTYPE_APPLICATION_JSON));
  fDAO.Request.Execute;

  if not fDAO.Request.Response.Status.Success then
    raise Exception.Create(fDAO.Request.Response.StatusText);

  Result:= True;
end;

function TControllerPessoa.Delete: Boolean;
begin
  Result:= Self.Delete(fDao.DataSetidpessoa.Value);
end;

function TControllerPessoa.Delete(aID: Int64): Boolean;
begin
  fDao.Adapter.AutoUpdate:= False;
  fDao.Request.Method:= TRESTRequestMethod.rmDELETE;
  fDao.Request.Params.Clear;
  fDao.Request.Params.AddItem('qId', fDao.DataSetidpessoa.Value.ToString, TRESTRequestParameterKind.pkQUERY);
  fDao.Request.Execute;

  if fDao.Request.Response.Status.Success then
    fDao.DataSet.Delete
  else
    raise Exception.Create(fDAO.Request.Response.StatusText);
end;

function TControllerPessoa.CargaEmLote(const aLista: TStringList): Int64;
var
  s:              string;
  sl:             TStrings;
  stringWriter:   TStringWriter;
  jsonTextWriter: TJsonTextWriter;
  jsonArray:      TJSonArray;
begin
  sl:=             nil;
  stringWriter:=   nil;
  jsonTextWriter:= nil;

  if aLista = nil then
    raise Exception.Create('Informe a Lista.');

  if aLista.Count = 0 then
    raise Exception.Create('Lista em branco');

  try
    stringWriter:= TStringWriter.Create;

    jsonTextWriter:= TJsonTextWriter.Create(stringWriter);
    jsonTextWriter.Formatting:= TJsonFormatting.Indented;
    jsonTextWriter.WriteStartArray;

    sl:= TStringList.Create;
    sl.Delimiter:= Char(',');
    sl.StrictDelimiter:= True;

    for s in aLista do
    begin
      sl.Clear;
      sl.DelimitedText:= s;

      jsonTextWriter.WriteStartObject;

      jsonTextWriter.WritePropertyName('flnatureza');    jsonTextWriter.WriteValue(sl[00]);
      jsonTextWriter.WritePropertyName('dsdocumento');   jsonTextWriter.WriteValue(sl[01]);
      jsonTextWriter.WritePropertyName('nmprimeiro');    jsonTextWriter.WriteValue(sl[02]);
      jsonTextWriter.WritePropertyName('nmsegundo');     jsonTextWriter.WriteValue(sl[03]);
      jsonTextWriter.WritePropertyName('dtregistro');    jsonTextWriter.WriteValue(sl[04]);
      jsonTextWriter.WritePropertyName('dscep');         jsonTextWriter.WriteValue(sl[05]);
      jsonTextWriter.WritePropertyName('dsuf');          jsonTextWriter.WriteValue(sl[06]);
      jsonTextWriter.WritePropertyName('nmcidade');      jsonTextWriter.WriteValue(sl[07]);
      jsonTextWriter.WritePropertyName('nmbairro');      jsonTextWriter.WriteValue(sl[08]);
      jsonTextWriter.WritePropertyName('nmlogradouro');  jsonTextWriter.WriteValue(sl[09]);
      jsonTextWriter.WritePropertyName('dscomplemento'); jsonTextWriter.WriteValue(sl[10]);

      jsonTextWriter.WriteEndObject;
    end;

    jsonTextWriter.WriteEndArray;

    jsonArray:= TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(stringWriter.ToString), 0) as TJSONArray;

    aLista.Clear;
    aLista.Text:= jsonArray.ToString;
//    aLista.SaveToFile('c:\lista.txt');

    Result:= Insert(jsonArray);
  finally
    if sl <> nil then
      FreeAndNil(sl);

    if stringWriter <> nil then
      FreeAndNil(stringWriter);

    if jsonTextWriter <> nil then
      FreeAndNil(jsonTextWriter);
  end;
end;

function TControllerPessoa.GetDataSource: TDataSource;
begin
  Result:= fDAO.DataSource;
end;

function TControllerPessoa.GetRegistro: TDTOPessoa;
begin
  Result:= TDTOPessoa.Create;
  Result.Idpessoa:=  fDAO.DataSetidpessoa.Value;
  Result.Natureza:=  fDAO.DataSetflnatureza.Value;
  Result.Documento:= fDAO.DataSetdsdocumento.Value;
  Result.Primeiro:=  fDAO.DataSetnmprimeiro.Value;
  Result.Segundo:=   fDAO.DataSetnmsegundo.Value;
  Result.Registro:=  fDAO.DataSetdtregistro.Value;
end;

procedure TControllerPessoa.Close;
begin
  fDAO.DataSet.EmptyDataSet;
end;

procedure TControllerPessoa.PaginaAnterior;
var
  recNo: Integer;
  nTemp: Int64;
begin
  nTemp:= 9999999999999;

  try
    recNo:= fDAO.DataSet.RecNo;

    fDAO.DataSet.DisableControls;
    fDAO.DataSet.First;

    while not fDAO.DataSet.Eof do
    begin
      if fDAO.DataSetidpessoa.Value < nTemp then
        nTemp:= fDAO.DataSetidpessoa.Value;

      fDAO.DataSet.Next;
    end;
  finally
    fDAO.DataSet.RecNo:= recNo;
    fDAO.DataSet.EnableControls;
  end;

  nTemp:= nTemp - 200;
  Self.Select(nTemp);
end;

procedure TControllerPessoa.ProximaPagina;
var
  recNo: Integer;
  nTemp: Int64;
begin
  nTemp:= 0;

  try
    recNo:= fDAO.DataSet.RecNo;

    fDAO.DataSet.DisableControls;
    fDAO.DataSet.First;

    while not fDAO.DataSet.Eof do
    begin
      if fDAO.DataSetidpessoa.Value > nTemp then
        nTemp:= fDAO.DataSetidpessoa.Value;

      fDAO.DataSet.Next;
    end;
  finally
    fDAO.DataSet.RecNo:= recNo;
    fDAO.DataSet.EnableControls;
  end;

  Self.Select(nTemp);
end;

end.
