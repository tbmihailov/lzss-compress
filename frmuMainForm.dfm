object frmMainForm: TfrmMainForm
  Left = 302
  Top = 171
  Width = 439
  Height = 450
  Caption = 'LZSS Compressor'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object gpbSettings: TGroupBox
    Left = 0
    Top = 0
    Width = 423
    Height = 49
    Align = alTop
    Caption = 'Settings'
    TabOrder = 1
    object lblMinLenght: TLabel
      Left = 16
      Top = 16
      Width = 85
      Height = 13
      Caption = 'Match MIN length'
    end
    object seMatchMinLength: TSpinEdit
      Left = 112
      Top = 16
      Width = 73
      Height = 22
      TabStop = False
      MaxValue = 1000
      MinValue = 2
      TabOrder = 0
      Value = 2
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 355
    Width = 423
    Height = 57
    Align = alBottom
    TabOrder = 4
    object lblCopyright: TLabel
      Left = 1
      Top = 43
      Width = 421
      Height = 13
      Align = alBottom
      Alignment = taCenter
      Caption = 'LZSS Compressor - Todor Mihailov 121208040 FKSU 64'
    end
    object gProgress: TGauge
      Left = 1
      Top = 1
      Width = 421
      Height = 16
      Align = alTop
      ForeColor = 16744448
      Progress = 0
    end
  end
  object pnlOptions: TPanel
    Left = 0
    Top = 169
    Width = 423
    Height = 66
    Align = alTop
    TabOrder = 2
    object btnGo: TButton
      Left = 128
      Top = 8
      Width = 169
      Height = 49
      Caption = 'Go'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnGoClick
    end
    object rgAction: TRadioGroup
      Left = 16
      Top = 8
      Width = 105
      Height = 49
      Caption = 'Action'
      ItemIndex = 0
      Items.Strings = (
        'Compress'
        'Decompress')
      TabOrder = 0
    end
    object btnSwap: TButton
      Left = 304
      Top = 8
      Width = 105
      Height = 49
      Caption = 'Swap Input Output'
      TabOrder = 2
      OnClick = btnSwapClick
    end
  end
  object gpbInput: TGroupBox
    Left = 0
    Top = 49
    Width = 423
    Height = 120
    Align = alTop
    Caption = 'Input'
    TabOrder = 0
    object mmoInput: TMemo
      Left = 2
      Top = 15
      Width = 419
      Height = 103
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object gpbOutput: TGroupBox
    Left = 0
    Top = 235
    Width = 423
    Height = 120
    Align = alTop
    Caption = 'Output'
    TabOrder = 3
    object mmoOutPut: TMemo
      Left = 2
      Top = 15
      Width = 419
      Height = 103
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object tmrProcessTime: TTimer
    Enabled = False
    Interval = 1
    Left = 192
    Top = 8
  end
end
