unit uSoObject;

interface

uses
  uGeometryClasses, System.Types, System.Classes, uCommonClasses, uSoProperties, uSoProperty;

type
  TSoObject = class
  private
    FContainer: TObject;
    function GetProperty(APropertyName: string): TSoProperty;
    //procedure AddChangeScaleHandler(const AHandler: TNotifyEvent);
  //  procedure RemoveChangeScaleHandler(const AHandler: TNotifyEvent);
//    procedure SetProperty(APropertyName: string; const Value: TSoProperty);
  protected
    FPosition: TPosition;
    FProperties: TSoProperties;
    FOnDestroyHandlers{, FChangeScaleHandlers}: TNotifyEventList;
    FOnChangePositionHandlers: TEventList<TPosition>;
    function GetCenter: TPointF;
    function GetScalePoint: TPointF;
    procedure SetCenter(const Value: TPointF);
    procedure SetPosition(const Value: TPosition);
    procedure SetRotate(const Value: Single);
    procedure SetScale(const Value: Single);
    procedure SetScalePoint(const Value: TPointF);
    procedure SetScaleX(const Value: Single);
    procedure SetScaleY(const Value: Single);
    procedure SetX(const Value: Single);
    procedure SetY(const Value: Single);
    procedure SetContainer(const AContainer: TObject);
  public
    // Geometrical properties �������������� ��������
    property Position: TPosition read FPosition write SetPosition; // ������� ��������� ���� ������ � ������� �������
    property X: Single read FPosition.x write SetX; // ���������� X �� ������� �������
    property Y: Single read FPosition.y write SetY; // ���������� Y �� ������� �������
    property Center: TPointF read GetCenter write SetCenter;
    property ScalePoint: TPointF read GetScalePoint write SetScalePoint;
    property Rotate: Single read FPosition.Rotate write SetRotate; // ���� �������� ������������ ������
    property ScaleX: Single read FPosition.ScaleX write SetScaleX;  // ������� ������� �� ����� ���������
    property ScaleY: Single read FPosition.ScaleY write SetScaleY;  // ������� ������� �� ����� ���������
    property Scale: Single write SetScale;  // ������� ������� �� ����� ���������
//    property Properties: TSoProperties read FProperties;
    property Properties[APropertyName: string]: TSoProperty read GetProperty; default;// write SetProperty; default;
    property Container: TObject read FContainer;
{    procedure RemoveChangeScaleHandler(const AHandler: TNotifyEvent);
    procedure AddChangeScaleHandler(const AHandler: TNotifyEvent);
    procedure AddChangeRotateHandler(const AHandler: TNotifyEvent);    }
    procedure RemoveChangePositionHandler(const AHandler: TEvent<TPosition>);
    procedure AddChangePositionHandler(const AHandler: TEvent<TPosition>);
    function AddProperty(const AName: string): TSoProperty;
    procedure AddDestroyHandler(const AHandler: TNotifyEvent);
    procedure RemoveDestroyHandler(const AHandler: TNotifyEvent);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TBaseUnitContainer }

procedure TSoObject.AddChangePositionHandler(const AHandler: TEvent<TPosition>);
begin
  FOnChangePositionHandlers.Add(AHandler);
end;

{procedure TSoObject.AddChangeScaleHandler(const AHandler: TNotifyEvent);
begin
  FChangeScaleHandlers.Add(AHandler);
end;   }

procedure TSoObject.AddDestroyHandler(const AHandler: TNotifyEvent);
begin
  FOnDestroyHandlers.Add(AHandler);
end;

function TSoObject.AddProperty(const AName: string): TSoProperty;
begin
  Result := FProperties.Add(AName);
end;

constructor TSoObject.Create;
begin
  FOnDestroyHandlers := TNotifyEventList.Create;
  //FChangeScaleHandlers := TNotifyEventList.Create;
  FOnChangePositionHandlers := TEventList<TPosition>.Create;
  FProperties := TSoProperties.Create;
  FPosition.X := 0;
  FPosition.Y := 0;
  FPosition.Rotate := 0;
  FPosition.ScaleX := 1;
  FPosition.ScaleY := 1;
end;

destructor TSoObject.Destroy;
begin
  FOnDestroyHandlers.RaiseEvent(Self);
  FOnDestroyHandlers.Free;
  FOnChangePositionHandlers.Free;
  FProperties.Free;

  inherited;
end;

function TSoObject.GetCenter: TPointF;
begin
  Result := FPosition.XY;
end;

function TSoObject.GetProperty(APropertyName: string): TSoProperty;
begin
  Result := FProperties[APropertyName];
end;

function TSoObject.GetScalePoint: TPointF;
begin
  Result := FPosition.Scale;
end;

procedure TSoObject.RemoveChangePositionHandler(const AHandler: TEvent<TPosition>);
begin
  FOnChangePositionHandlers.Remove(AHandler);
end;

{procedure TSoObject.RemoveChangeScaleHandler(const AHandler: TNotifyEvent);
begin
  FChangeScaleHandlers.Remove(AHandler);
end;}

procedure TSoObject.RemoveDestroyHandler(const AHandler: TNotifyEvent);
begin
  FOnDestroyHandlers.Remove(AHandler);
end;

procedure TSoObject.SetCenter(const Value: TPointF);
begin
  FPosition.X := Value.X;
  FPosition.Y := Value.Y;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
end;

procedure TSoObject.SetContainer(const AContainer: TObject);
begin
  FContainer := AContainer;
end;

procedure TSoObject.SetPosition(const Value: TPosition);
begin
  FPosition := Value;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
  //FChangeScaleHandlers.RaiseEvent(Self);
end;

{procedure TSoObject.SetProperty(APropertyName: string;
  const Value: TSoProperty);
begin
  FProperties[APropertyName] := Value;
end;}

procedure TSoObject.SetRotate(const Value: Single);
begin
  FPosition.Rotate := Value;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
end;

procedure TSoObject.SetScale(const Value: Single);
var
  vSoot: Single;
begin
  if (FPosition.ScaleX) <> 0 then
  begin
    vSoot := FPosition.ScaleY / FPosition.scaleX;
  end
  else begin
    vSoot := 1;
  end;

  FPosition.scaleX := Value;
  FPosition.scaleY := vSoot * Value;
  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
//  FChangeScaleHandlers.RaiseEvent(Self);
end;

procedure TSoObject.SetScalePoint(const Value: TPointF);
begin
  FPosition.ScaleX := Value.X;
  FPosition.ScaleY := Value.Y;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
  //FChangeScaleHandlers.RaiseEvent(Self);
end;

procedure TSoObject.SetScaleX(const Value: Single);
begin
  FPosition.ScaleX := Value;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
//  FChangeScaleHandlers.RaiseEvent(Self);
end;

procedure TSoObject.SetScaleY(const Value: Single);
begin
  FPosition.ScaleY := Value;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
//  FChangeScaleHandlers.RaiseEvent(Self);
end;

procedure TSoObject.SetX(const Value: Single);
begin
  FPosition.X := Value;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
end;

procedure TSoObject.SetY(const Value: Single);
begin
  FPosition.Y := Value;

  FOnChangePositionHandlers.RaiseEvent(Self, FPosition);
end;

end.
