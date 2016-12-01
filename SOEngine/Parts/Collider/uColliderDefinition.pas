unit uColliderDefinition;

interface

uses
  System.Generics.Collections,
  uRawShapes;

type
  TColliderDefinition = class
  private
    FShapes: TList<TRawShape>;
    FFriction, FDensity, FRestitution: Single;
    FIsSensor: Boolean;
  public
    property Shape: TList<TRawShape> read FShapes;
    property Friction: Single read FFriction; // ������
    property Restitution: Single read FRestitution; // ����������� ���������
    property Density: Single read FDensity; // ���������
    property IsSensor: Boolean read FIsSensor; // ����� �� ����������� � �������� ��� ������ ���������� ���

    constructor Create(const AShapes: TList<TRawShape>; const AFriction, ADensity, ARestitution: Single; const AIsSensor: Boolean);
    destructor Destroy; override;
  end;


implementation

{ TColliderDefinition }

constructor TColliderDefinition.Create(const AShapes: TList<TRawShape>; const AFriction, ADensity, ARestitution: Single; const AIsSensor: Boolean);
var
  i: Integer;
begin
  FShapes := TList<TRawShape>.Create;
  for i := 0 to AShapes.Count - 1 do
    FShapes.Add(AShapes[i].Clone);

  FFriction := AFriction;
  FDensity := ADensity;
  FRestitution := ARestitution;
  FIsSensor := AIsSensor;
end;

destructor TColliderDefinition.Destroy;
var
  i: Integer;
begin
  for i := 0 to FShapes.Count - 1 do
    FShapes[i].Free;
  FShapes.Free;
  inherited;
end;

end.
