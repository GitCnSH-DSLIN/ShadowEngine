unit uSoFastFields;

interface

uses
  System.Generics.Collections, System.SysUtils, uClasses,
  uSoParserValue, uNamedList, uISoObject, uSoObjectDefaultProperties, uSoTypes;

type

  TFastField = class(TValue)
  protected
    function GetValue: Double; virtual; abstract;
    procedure SetValue(const Value: Double); virtual; abstract;
  public
    function IsBroken: Boolean; virtual;
    function Value: Double; override;
    property PropertyValue: Double read GetValue write SetValue;
  end;

  TFastFields = class(TNamedList<TFastField>)
  private
    FIsHor: TBooleanFunction;
  public
    function IsHor: Boolean;
    procedure ClearForSubject(const AObject: ISoObject);
    procedure ClearBroken; // ������� ��� ��������� ����������
    destructor Destroy; override;
    constructor Create(AIsHor: TBooleanFunction); reintroduce;
  end;

  TFastEngineField = class(TFastField)
  private
    FValue: PInteger;
//    fEngine: Pointer;
  public
    constructor Create(const AValue: PInteger); reintroduce; virtual;
//     Pointer: Pointer
    destructor Destroy; override;
  end;

  TFastEngineWidth = class(TFastEngineField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastEngineHeight = class(TFastEngineField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastObjectField = class(TFastField)
  private
    FObject: ISoObject;
  public
    property Subject: ISoObject read FObject;
    constructor Create(const AObject: ISoObject); reintroduce; virtual;
    function IsBroken: Boolean; override;
    destructor Destroy; override;
  end;

  // �������� ��������, ��� ������ �������� ���-���� ��������, ����� �������
  // ����� ������ � ������� ����� ����������, �� ���� ��������� �������
  TFastWidth = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  // �������� ��������, ��� ������ �������� ���-���� ��������, ����� �������
  // ����� ������ � ������� ����� ����������, �� ���� ��������� �������
  TFastHeight = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  // * ����������� ������, � ��� �� ����� ������ � ������ ������ � ������
  // ���-���� ��������. �� ����� ���� ���� �������� �������� ������������������
  TFastLeftBorder = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastRightBorder = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastTopBorder = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastBottomBorder = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastX = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastY = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastScale = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastRotate = class(TFastObjectField)
  protected
    function GetValue: Double; override;
    procedure SetValue(const Value: Double); override;
  end;

  TFastObjectType = class of TFastObjectField;

  function TypeOfFast(const AName: String): TFastObjectType;

implementation

uses
  uEngine2D;

function TypeOfFast(const AName: String): TFastObjectType;
begin
  Result := Nil;
  if (AName = 'width') or (AName = 'w') then Result := TFastWidth;
  if (AName = 'height') or (AName = 'h') then Result := TFastHeight;
  if (AName = 'scale') or (AName = 'sc') then Result := TFastScale;
  if (AName = 'rotate') or (AName = 'angle') then Result := TFastRotate;
  if (AName = 'left') or (AName = 'x') then Result := TFastX;
  if (AName = 'leftborder') then Result := TFastLeftBorder;
  if (AName = 'rightborder') then Result := TFastRightBorder;
  if (AName = 'topborder') then Result := TFastTopBorder;
  if (AName = 'bottomborder') then Result := TFastBottomBorder;
  if (AName = 'top') or (AName = 'y') then Result := TFastY;
end;


{ TFastFields }

procedure TFastFields.ClearBroken;
var
  i, vN: Integer;
begin
  vN := Self.Count - 1;

  for i := 0 to vN do
    if Self[i].IsBroken then
    begin
      Delete(i);
      Self[i].Free;
    end;

end;

procedure TFastFields.ClearForSubject(
  const AObject: ISoObject);
var
  i: Integer;
  vFF: TFastField;
begin
  for i := Self.Count - 1 downto 0 do
    if (Self[i] is TFastObjectField) then
      if TFastObjectField(Self[i]).Subject = AObject then
      begin
        vFF := Self[i];
        Self.Delete(vFF);
        vFF.Free;
      end;
end;

constructor TFastFields.Create(AIsHor: TBooleanFunction);
begin
  inherited Create;
  FIsHor := AIsHor;
end;

destructor TFastFields.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    Items[i].Free;

  inherited;
end;

function TFastFields.IsHor: Boolean;
begin
  Result := FIsHor;
end;

{ TFastWidth }

function TFastWidth.GetValue: Double;
begin
  Result := TSizeObject(fObject[SummarySize].Obj).Width * fObject.Position.ScaleX;
//  Result := fObject['Width'].AsDouble * fObject.ScaleX;
end;

procedure TFastWidth.SetValue(const Value: Double);
begin
  fObject.Position.ScaleX := Value / (TSizeObject(fObject[RenditionRect].Obj).Width * fObject.Position.ScaleX);
//  fObject.Scale := Value / (fObject['Width'].AsDouble * fObject.ScaleX);
end;

{ TFastHeight }

function TFastHeight.GetValue: Double;
begin
  Result := TSizeObject(fObject[RenditionRect].Obj).Height * fObject.Position.ScaleY;
//  Result := FObject['Height'].AsDouble * fObject.ScaleY;
end;

procedure TFastHeight.SetValue(const Value: Double);
begin
  fObject.Position.ScaleY := Value / (TSizeObject(fObject[RenditionRect].Obj).Height * fObject.Position.ScaleY);
//  fObject.h := Value;
end;

{ TFastX }

function TFastX.GetValue: Double;
begin
  Result := fObject.Position.X;
end;

procedure TFastX.SetValue(const Value: Double);
begin
  fObject.Position.X := Value;
end;

{ TFastY }

function TFastY.GetValue: Double;
begin
  Result := fObject.Position.Y;
end;

procedure TFastY.SetValue(const Value: Double);
begin
  fObject.Position.Y := Value;
end;

{ TFastScale }

function TFastScale.GetValue: Double;
begin
  Result := fObject.Position.ScaleX;
end;

procedure TFastScale.SetValue(const Value: Double);
begin
  fObject.Position.ScalePoint := TPointF.Create(Value, Value);
end;

{ TFastRotate }

function TFastRotate.GetValue: Double;
begin
  Result := fObject.Position.Rotate;
end;

procedure TFastRotate.SetValue(const Value: Double);
begin
  fObject.Position.Rotate := Value;
end;

{ TFastObjectFields }

constructor TFastObjectField.Create(const AObject: ISoObject);
begin
  fObject := AObject;
end;

destructor TFastObjectField.Destroy;
begin
  fObject := Nil;
  inherited;
end;

function TFastObjectField.IsBroken: Boolean;
begin
  if fObject = Nil then
    Result := True
  else
    Result := inherited;
end;

{ TFastEngineField }

constructor TFastEngineField.Create(const AValue: PInteger);
begin
  FValue := AValue;
  //fEngine := APointer;
end;

destructor TFastEngineField.Destroy;
begin
  FValue := Nil;
//  fEngine := Nil;
  inherited;
end;

{ TFastEngineWidth }

function TFastEngineWidth.GetValue: Double;
begin
  Result := FValue^;
//  Result := TEngine2d(fEngine).width;
end;

procedure TFastEngineWidth.SetValue(const Value: Double);
begin
  raise Exception.Create('You can not directly set Engine Width by Fast Field');
end;

{ TFastEngineHeight }

function TFastEngineHeight.GetValue: Double;
begin
  Result := FValue^;
  //Result := TEngine2d(fEngine).height;
end;

procedure TFastEngineHeight.SetValue(const Value: Double);
begin
  raise Exception.Create('You can not directly set Engine Height by Fast Field');
end;

{ TFastField }

function TFastField.IsBroken: Boolean;
begin
  Result := False;
end;

function TFastField.Value: Double;
begin
  Result := Self.GetValue;
end;

{ TFastLeftBorder }

function TFastLeftBorder.GetValue: Double;
begin
  Result := fObject.Position.x - TSizeObject(FObject[RenditionRect].Obj).Width * fObject.Position.ScaleX * 0.5;
end;

procedure TFastLeftBorder.SetValue(const Value: Double);
begin
  fObject.Position.x := Value + TSizeObject(FObject[RenditionRect].Obj).Width * fObject.Position.ScaleX * 0.5;
end;

{ TFastRightBorder }

function TFastRightBorder.GetValue: Double;
begin
  Result := fObject.Position.x + TSizeObject(FObject[RenditionRect].Obj).Width * fObject.Position.ScaleX * 0.5;
end;

procedure TFastRightBorder.SetValue(const Value: Double);
begin
  fObject.Position.x := Value - TSizeObject(FObject[RenditionRect].Obj).Width * fObject.Position.ScaleX * 0.5;
end;

{ TFastTopBorder }

function TFastTopBorder.GetValue: Double;
begin
  Result := fObject.Position.y - TSizeObject(FObject[RenditionRect].Obj).Height * fObject.Position.ScaleY * 0.5;
end;

procedure TFastTopBorder.SetValue(const Value: Double);
begin
  fObject.Position.Y  := Value + TSizeObject(FObject[RenditionRect].Obj).Height * fObject.Position.ScaleY * 0.5;
end;

{ TFastBottomBorder }

function TFastBottomBorder.GetValue: Double;
begin
  Result := fObject.Position.Y + TSizeObject(FObject[RenditionRect].Obj).Height * fObject.Position.ScaleY * 0.5;
end;

procedure TFastBottomBorder.SetValue(const Value: Double);
begin
  fObject.Position.y  := Value - TSizeObject(FObject[RenditionRect].Obj).Height * fObject.Position.ScaleY * 0.5;
end;

end.
