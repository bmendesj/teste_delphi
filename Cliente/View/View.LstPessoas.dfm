object lstPessoas: TlstPessoas
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Lista de Pessoas'
  ClientHeight = 600
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object pLateral: TPanel
    Left = 0
    Top = 564
    Width = 710
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      710
      36)
    object btnAnterior: TSpeedButton
      Left = 5
      Top = 5
      Width = 90
      Height = 26
      Caption = 'Anterior'
      OnClick = btnAnteriorClick
    end
    object btnProximo: TSpeedButton
      Left = 100
      Top = 5
      Width = 90
      Height = 26
      Caption = 'Proximo'
      OnClick = btnProximoClick
    end
    object btnAdicionar: TSpeedButton
      Left = 330
      Top = 5
      Width = 90
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Adicionar'
      OnClick = btnAdicionarClick
      ExplicitLeft = 366
    end
    object Editar: TSpeedButton
      Left = 520
      Top = 5
      Width = 90
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Editar'
      OnClick = EditarClick
      ExplicitLeft = 556
    end
    object apagar: TSpeedButton
      Left = 425
      Top = 5
      Width = 90
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Apagar'
      OnClick = apagarClick
      ExplicitLeft = 461
    end
    object btmFechar: TSpeedButton
      Left = 615
      Top = 5
      Width = 90
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Sair'
      OnClick = btmFecharClick
      ExplicitLeft = 651
    end
    object btnCarregar: TSpeedButton
      Left = 196
      Top = 5
      Width = 90
      Height = 26
      Caption = 'Ins. Lote'
      OnClick = btnCarregarClick
    end
  end
  object DBGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 710
    Height = 564
    Align = alClient
    ReadOnly = True
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -16
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object OpenDialog1: TOpenDialog
    Filter = 'txt|*.txt'
    Title = 'Lista de insers'#227'o'
    Left = 152
    Top = 39
  end
end
