unit uSoPropertyKeeper;

interface

uses
  System.SyncObjs, System.SysUtils,
  uSoBaseOperator, uSoBasePart, uSoObject, uSoProperties, uSoContainerTypes;

type
  TSoPropertyKeeper = class(TSoOperator<TSoProperties>)
  private
    procedure OnItemDestroy(ASender: TObject);
  public
    procedure Add(const AItem: TSoProperties); override;
    function AddFromTemplate(const ASubject: TSoObject; const ATemplateName: string): TSoProperties; override;
    constructor Create(const ACritical: TCriticalSection); override;
  end;

implementation

{ TSoPropertyKeeper }

procedure TSoPropertyKeeper.Add(const AItem: TSoProperties);
begin

end;

function TSoPropertyKeeper.AddFromTemplate(const ASubject: TSoObject; const ATemplateName: string): TSoProperties;
begin

end;

constructor TSoPropertyKeeper.Create(const ACritical: TCriticalSection);
begin
  inherited;

end;

procedure TSoPropertyKeeper.OnItemDestroy(ASender: TObject);
begin
  FList.Remove(TSoProperties(ASender));
end;

end.
