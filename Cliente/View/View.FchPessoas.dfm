object fchPessoas: TfchPessoas
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Ficha de Ende'#231'o'
  ClientHeight = 600
  ClientWidth = 710
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  KeyPreview = True
  OldCreateOrder = False
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 19
  object Label3: TLabel
    Left = 5
    Top = 5
    Width = 28
    Height = 19
    Caption = 'CEP'
  end
  object Label4: TLabel
    Left = 101
    Top = 5
    Width = 47
    Height = 19
    Caption = 'Estado'
  end
  object Label1: TLabel
    Left = 5
    Top = 55
    Width = 48
    Height = 19
    Caption = 'Cidade'
  end
  object Bairro: TLabel
    Left = 5
    Top = 105
    Width = 42
    Height = 19
    Caption = 'Bairro'
  end
  object Label2: TLabel
    Left = 5
    Top = 155
    Width = 82
    Height = 19
    Caption = 'Logradouro'
  end
  object Label5: TLabel
    Left = 5
    Top = 205
    Width = 99
    Height = 19
    Caption = 'Complemento'
  end
  object pLateral: TPanel
    Left = 0
    Top = 564
    Width = 710
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 6
    DesignSize = (
      710
      36)
    object btmFechar: TSpeedButton
      Left = 615
      Top = 5
      Width = 90
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Fechar'
      OnClick = btmFecharClick
      ExplicitLeft = 689
    end
    object btnSalvar: TSpeedButton
      Left = 520
      Top = 5
      Width = 90
      Height = 26
      Anchors = [akTop, akRight]
      Caption = 'Salvar'
      OnClick = btnSalvarClick
      ExplicitLeft = 594
    end
  end
  object edtEstado: TEdit
    Left = 101
    Top = 25
    Width = 601
    Height = 27
    MaxLength = 50
    TabOrder = 1
    Text = '020406080_020406080_020406080_020406080_020406080_'
  end
  object edtCidade: TEdit
    Left = 5
    Top = 75
    Width = 697
    Height = 27
    MaxLength = 100
    TabOrder = 2
    Text = 
      '020406080_020406080_020406080_020406080_020406080_020406080_0204' +
      '06080_020406080_020406080_020406080_'
  end
  object edtBairro: TEdit
    Left = 5
    Top = 125
    Width = 697
    Height = 27
    MaxLength = 50
    TabOrder = 3
    Text = '020406080_020406080_020406080_020406080_020406080_'
  end
  object edtLogradouro: TEdit
    Left = 2
    Top = 175
    Width = 700
    Height = 27
    MaxLength = 100
    TabOrder = 4
    Text = 
      '020406080_020406080_020406080_020406080_020406080_020406080_0204' +
      '06080_020406080_020406080_020406080_'
  end
  object edtComplemento: TEdit
    Left = 2
    Top = 225
    Width = 700
    Height = 27
    MaxLength = 100
    TabOrder = 5
    Text = 
      '020406080_020406080_020406080_020406080_020406080_020406080_0204' +
      '06080_020406080_020406080_020406080_'
  end
  object edtCep: TEdit
    Left = 5
    Top = 25
    Width = 90
    Height = 27
    MaxLength = 8
    TabOrder = 0
    Text = '020406080_020406080_020406080_020406080_020406080_'
    OnExit = edtCepExit
    OnKeyPress = edtCepKeyPress
  end
end
