unit DAO.EnderecoIntegracao;

interface

uses
  System.SysUtils, System.JSON,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TDAOEnderecoIntegracao = class
  private
    fConector: TFDConnection;
  public
    function Get(const aId: Int64 = 0): TJSONArray;
    function Insert(aJsonArray: TJSONArray): integer;
    function Update(const aId: Int64; aJsonArray: TJSONArray): Integer;
    function Delete(const aId: Int64): Integer;

    constructor Create(aConector: TFDConnection);
    destructor Destroy; override;
  published
  end;

implementation

{ TDAOEnderecoIntegracao }

uses DAO.DMConexao, uJsonDataSetHelper;

constructor TDAOEnderecoIntegracao.Create(aConector: TFDConnection);
begin
  fConector:= aConector;
end;

destructor TDAOEnderecoIntegracao.Destroy;
begin

  inherited;
end;

function TDAOEnderecoIntegracao.Get(const aId: Int64 = 0): TJSONArray;
const
  _sql = 'SELECT * FROM teste_delphi.endereco_integracao';
begin
  Result:= nil;

  try
    DMConexao.fdqEnderecoEntegracao.SQL.Clear;
    DMConexao.fdqEnderecoEntegracao.SQL.Add(_sql);

    if aId > 0 then
      DMConexao.fdqEnderecoEntegracao.SQL.Add('WHERE idendereco = ' + aId.ToString);

    DMConexao.fdqPessoa.SQL.Add('ORDER BY idendereco');
    DMConexao.fdqEnderecoEntegracao.Open;

    Result:= DMConexao.fdqEnderecoEntegracao.ToJsonArray;
  except on E: Exception do
    raise;
  end;
end;

function TDAOEnderecoIntegracao.Insert(aJsonArray: TJSONArray): integer;
const
  _sql = 'INSERT INTO teste_delphi.endereco_integracao (' +
         '  idendereco, ' +
         '  dsuf, ' +
         '  nmcidade, ' +
         '  nmbairro, ' +
         '  nmlograduro, ' +
         '  dscomplemento' +
         ') VALUES (' +
         '  :idendereco, ' +
         '  :dsuf, ' +
         '  :nmcidade, ' +
         '  :nmbairro, ' +
         '  :nmlograduro, ' +
         '  :dscomplemento' +
         ')';
var
  jValores: TJSONValue;
  idx:      Integer;
begin
  idx:= 0;

  try
    fConector.StartTransaction;

    DMConexao.fdqEnderecoEntegracao.SQL.Clear;
    DMConexao.fdqEnderecoEntegracao.SQL.Add(_sql);
    DMConexao.fdqEnderecoEntegracao.Params.ArraySize:= aJsonArray.Count;

    for jValores in aJsonArray do
    begin
      DMConexao.fdqEnderecoEntegracao.ParamByName('idendereco').AsLargeInts[idx]:=  jValores.GetValue<Largeint>('dsuf');
      DMConexao.fdqEnderecoEntegracao.ParamByName('dsuf').AsStrings[idx]:=          jValores.GetValue<string>('dsuf');
      DMConexao.fdqEnderecoEntegracao.ParamByName('nmcidade').AsStrings[idx]:=      jValores.GetValue<string>('nmcidade');
      DMConexao.fdqEnderecoEntegracao.ParamByName('nmbairro').AsStrings[idx]:=      jValores.GetValue<string>('nmbairro');
      DMConexao.fdqEnderecoEntegracao.ParamByName('nmlograduro').AsStrings[idx]:=   jValores.GetValue<string>('nmlograduro');
      DMConexao.fdqEnderecoEntegracao.ParamByName('dscomplemento').AsStrings[idx]:= jValores.GetValue<string>('dscomplemento');

      Inc(idx);
    end;

    if idx > 0 then
      DMConexao.fdqEnderecoEntegracao.Execute(idx);

    fConector.Commit;

    Result:= idx;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

function TDAOEnderecoIntegracao.Update(const aId: Int64; aJsonArray: TJSONArray): Integer;
const
  _sql = 'UPDATE teste_delphi.endereco_integracao ' +
         'SET ' +
         '  dsuf          = :dsuf, ' +
         '  nmcidade      = :nmcidade, ' +
         '  nmbairro      = :nmbairro, ' +
         '  nmlograduro   = :nmlograduro, ' +
         '  dscomplemento = :dscomplemento ' +
         'WHERE idendereco = :idendereco';
var
  lValores: TJSONValue;
begin
{
  Foi mantido o usso do jsonArray para futuramente suportar a atualiza��o de multiplos resgistros
  essa altera��os ser� feita com a criar de uma fun��o concorrente (overload)
}
  Result:= 0;

  try
    lValores:= aJsonArray.Items[0];

    fConector.StartTransaction;

    DMConexao.fdqEnderecoEntegracao.SQL.Clear;
    DMConexao.fdqEnderecoEntegracao.SQL.Add(_sql);

    DMConexao.fdqEnderecoEntegracao.ParamByName('idendereco').AsLargeInt:=  aId;
    DMConexao.fdqEnderecoEntegracao.ParamByName('dsuf').AsSmallInt:=        lValores.GetValue<SmallInt>('dsuf');
    DMConexao.fdqEnderecoEntegracao.ParamByName('nmcidade').AsString:=      lValores.GetValue<string>('nmcidade');
    DMConexao.fdqEnderecoEntegracao.ParamByName('nmbairro').AsString:=      lValores.GetValue<string>('nmbairro');
    DMConexao.fdqEnderecoEntegracao.ParamByName('nmlograduro').AsString:=   lValores.GetValue<string>('nmlograduro');
    DMConexao.fdqEnderecoEntegracao.ParamByName('dscomplemento').AsString:= lValores.GetValue<string>('dscomplemento');

    DMConexao.fdqEnderecoEntegracao.ExecSQL;

    fConector.Commit;

    Result:= aJsonArray.Count;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

function TDAOEnderecoIntegracao.Delete(const aId: Int64): Integer;
const
  _sql = 'DELETE FROM teste_delphi.endereco_integracao	WHERE idendereco = :idendereco';
begin
{
  O retorno foi mantido como inteiro para que futuramente a fun��o possa ser
  alterada para suportar a dele��o de multiplos registros
}
  Result:= 0;

  try
    fConector.StartTransaction;

    DMConexao.fdqEnderecoEntegracao.SQL.Clear;
    DMConexao.fdqEnderecoEntegracao.SQL.Add(_sql);

    DMConexao.fdqEnderecoEntegracao.ParamByName('idendereco').AsLargeInt:= aId;

    DMConexao.fdqEnderecoEntegracao.ExecSQL;

    fConector.Commit;

    Result:= 1;
  except
    on E: Exception do
    begin
      fConector.Rollback;
      raise;
    end;
  end;
end;

end.
