object Form1: TForm1
  Left = 46
  Top = 31
  Width = 688
  Height = 509
  Caption = 'w '
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object img_move: TImage
    Left = 16
    Top = 8
    Width = 300
    Height = 300
  end
  object chrt: TChart
    Left = 328
    Top = 16
    Width = 337
    Height = 297
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    MarginBottom = 0
    MarginLeft = 5
    MarginRight = 0
    MarginTop = 0
    Title.Text.Strings = (
      'F(V)dV=dn(V,dV)/n - imovirnist'#39' maty V u intervali ot  V do V+dV')
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.Maximum = 1800.000000000000000000
    BottomAxis.Title.Caption = 'V, m/s'
    ClipPoints = False
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Maximum = 0.050000000000000000
    Legend.Visible = False
    View3D = False
    BevelOuter = bvNone
    TabOrder = 0
    object Series1: TBarSeries
      Marks.ArrowLength = 20
      Marks.Visible = False
      SeriesColor = clLime
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
    object Series2: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object gb_par: TGroupBox
    Left = 0
    Top = 321
    Width = 680
    Height = 161
    Align = alBottom
    Caption = 'V=15*15*0.3 (nm^3)'
    TabOrder = 1
    object Label1: TLabel
      Left = 528
      Top = 72
      Width = 13
      Height = 13
      Caption = 'nZ'
    end
    object Label2: TLabel
      Left = 520
      Top = 113
      Width = 76
      Height = 13
      Caption = 'Nuber of Strikes'
    end
    object le_T: TLabeledEdit
      Left = 16
      Top = 36
      Width = 121
      Height = 21
      EditLabel.Width = 89
      EditLabel.Height = 13
      EditLabel.Caption = 'input T   (T<400 K)'
      TabOrder = 0
      Text = '300'
    end
    object rg_m: TRadioGroup
      Left = 184
      Top = 16
      Width = 153
      Height = 121
      Caption = 'mol. mass'
      ItemIndex = 0
      Items.Strings = (
        '0,028'
        '0,032'
        '0,040')
      TabOrder = 1
    end
    object btn_start: TButton
      Left = 30
      Top = 112
      Width = 91
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = btn_startClick
    end
    object cb_theor: TCheckBox
      Left = 520
      Top = 24
      Width = 153
      Height = 17
      Caption = 'do theoretical'
      TabOrder = 3
    end
    object le_nz: TLabeledEdit
      Left = 16
      Top = 76
      Width = 121
      Height = 21
      EditLabel.Width = 120
      EditLabel.Height = 13
      EditLabel.Caption = 'interval V dV=10-30 (m/s)'
      TabOrder = 4
      Text = '20'
    end
    object Button1: TButton
      Left = 360
      Top = 24
      Width = 113
      Height = 25
      Caption = 'Vx=--Vx, Vy=--Vy'
      TabOrder = 5
      OnClick = Button1Click
    end
    object Edit1: TEdit
      Left = 368
      Top = 72
      Width = 121
      Height = 21
      TabOrder = 6
      Text = '60'
    end
    object Edit2: TEdit
      Left = 368
      Top = 112
      Width = 121
      Height = 21
      TabOrder = 7
      Text = 'square 3 nm'
    end
  end
end
