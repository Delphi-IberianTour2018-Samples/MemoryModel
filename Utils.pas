unit Utils;

interface

uses System.Generics.Collections;

type
  Logger = class
  public
    class procedure Debug(const Text: string);
  end;

  TTestIntfObject = class(TInterfacedobject, IInterface)
  private
  public
    destructor Destroy; override;
  end;

  TTestObject = class(TObject)
  private
  public
    FIntf: IInterface;
    [WEAK]
    FWIntf: IInterface;
    procedure Test;
    destructor Destroy; override;
  end;

  IPurgatoy = interface
    function Add(Obj: TObject): Pointer;
  end;

  TObjectKiller = class(TInterfacedObject, IInterface)
  private
    FToKill: TObject;
  public
    constructor Create(ObjectToKill: TObject);
    destructor Destroy; override;
  end;

  TPurgatory = record
  private
    FKiller: IInterface;
    FList: TObjectList<TObject>;
    function List: TObjectList<TObject>;
  public
    function Add<T: class>(Instance: T): T;
    procedure Purge;
  end;

implementation

uses FMX.Types, FMX.Dialogs, System.Sysutils;

{ Logger }

class procedure Logger.Debug(const Text: string);
begin
  // Log.d(Text);
  Showmessage(Text);
end;

{ TTestIntfObject }

destructor TTestIntfObject.Destroy;
begin
  Logger.Debug('Test **interfaced** object destroyed');
  inherited;
end;

{ TTestObject }

procedure TTestObject.Test;
begin
  Logger.Debug('Test object is alive');
end;

destructor TTestObject.Destroy;
begin
  Logger.Debug('Test object is destroying');
  if assigned(FIntf) then
    Logger.Debug('RefCount ' + IntToStr(TInterfacedobject(FIntf).RefCount));
  inherited;
end;

{ TObjectKiller }

constructor TObjectKiller.Create(ObjectToKill: TObject);
begin
  inherited Create;
  FToKill := ObjectToKill;
end;

destructor TObjectKiller.Destroy;
begin
  FToKill.Destroy;
  inherited;
end;

{ TPurgatory }

function TPurgatory.Add<T>(Instance: T): T;
begin
  Result := Instance;
  List.Add(Instance);
end;

procedure TPurgatory.Purge;
begin
  FKiller := nil;
end;

function TPurgatory.List: TObjectList<TObject>;
begin
  if FKiller = nil then
  begin
    // La lista debe poseer los objetos!
    FList := TObjectList<TObject>.Create(True);
    FKiller := TObjectKiller.Create(FList);
  end;
  Result := FList;
end;

end.
