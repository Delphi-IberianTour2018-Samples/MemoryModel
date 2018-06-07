unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    TestpurgatoryBtn: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TestpurgatoryBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

uses Utils;

procedure TForm2.Button1Click(Sender: TObject);
var
  TOb: TTestObject;
begin
  TOb := TTestObject.Create;
  Tob.Test;
  //  Tob.Free;
  //  Tob.DisposeOf;
  //  Logger.Debug('Test Object IS DEAD ');
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  TOb: TTestObject;
begin
  TOb := TTestObject.Create;
  Tob.FIntf := TTestIntfObject.Create;
  Tob.Test;
  Tob.Free;
  Logger.Debug('Test Object IS DEAD ');
end;

procedure TForm2.Button3Click(Sender: TObject);
var
  TOb: TTestObject;
  Aux: IInterface;
begin
  TOb := TTestObject.Create;
  Aux := TTestIntfObject.Create;
  Tob.FWIntf := Aux;
  Tob.Test;
  Tob.Free;
  Logger.Debug('Test Object IS DEAD ');
  Logger.Debug('Weak RefCount) ' + IntToStr(TInterFacedObject(Aux).RefCount));
end;

procedure TForm2.TestpurgatoryBtnClick(Sender: TObject);
// A y B se destruyen automaticamente. No se necesita try except!!
var
  A: TTestObject;
  B: TTestObject;
  P: TPurgatory;
begin
  A := P.Add(TTestObject.Create);
  A.Test;
  B := P.Add(TTestObject.Create);
  B.Test;

  raise Exception.Create('Algo salió mal!');
  B.Test;
end;

end.

