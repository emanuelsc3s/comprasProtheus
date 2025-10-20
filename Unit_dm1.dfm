object dm1: Tdm1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 249
  Width = 333
  object ADOConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=far1989!@#123;Persist Security Info' +
      '=True;User ID=sa;Initial Catalog=TOTVS_PRODUCAO;Data Source=192.' +
      '168.0.222'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'SQLOLEDB.1'
    Left = 136
    Top = 56
  end
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=E:\SICFAR.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Protocol=TCPIP'
      'Server=192.168.1.7'
      'Port=3050'
      'CharacterSet=WIN1252'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 136
    Top = 104
  end
  object FDPhysFBDriverLink: TFDPhysFBDriverLink
    VendorLib = 
      'C:\Users\Administrador\C3Soft Dropbox\Emanuel Silva\C3S\D104\Com' +
      'prasProtheus\Win32\fbclient.dll'
    Left = 136
    Top = 152
  end
end
