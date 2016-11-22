unit uWorkSpaceView;

interface

uses
  System.Generics.Collections, System.SysUtils, System.Types, FMX.Graphics,
  FMX.Controls, FMX.Layouts,  FMX.Objects, FMX.StdCtrls, FMX.Forms, FMX.Dialogs,
  FMX.Types, System.Classes, System.UITypes, uEasyDevice, uNamedOptionsForm,
  uSSBTypes, uIWorkSpaceView, uIItemView, uItemView, uMVPFrameWork, FMX.Effects,
  uImagerPresenter, uObjecterPresenter, uITableView, uNamedTableView, uMainPanelFrame;

type
  TWorkSpaceView = class(TInterfacedObject, IWorkSpaceView, IView)
  private
    FElements: TDictionary<IItemView, TItemView>;
    FOptionsForm: TNamedOptionsForm;
    FEffect: TGlowEffect;
    FParentTopLeft: TPointFunction;
    FFrame: TMainPanelFrame;
    FSelected: TImage;
    FOpenDialog: TOpenDialog;
    FObjecter: IInterface;
    FImager: IInterface;
    procedure MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    function PanelTopLeft: TPointF;
    function GetImager: TImagerPresenter;
    function GetObjecter: TObjecterPresenter;
    procedure SetImager(const Value: TImagerPresenter);
    procedure SetObjecter(const Value: TObjecterPresenter);
  public
    constructor Create(AFrame: TMainPanelFrame;{APanel: TPanel; ABackground,} ASelected: TImage;
      AOpenDialog: TOpenDialog; AParentTopLeft: TPointFunction);
    destructor Destroy; override;
    procedure ClearAndFreeImg;
    function GetMousePos: TPoint;
    function AddElement: IItemView;
    function GetScale: Single;
    procedure RemoveElement(const AElement: IItemView);
    procedure SelectElement(const AElement: IItemView);
    procedure SetBackground(const AImg: TImage);
    function FilenameFromDlg(out AFileName: string): boolean;
    procedure ChangeCursor(const ACursor: TCursor);
    function AddTableView: ITableView;
    property Imager: TImagerPresenter read GetImager write SetImager;
    property Objecter: TObjecterPresenter read GetObjecter write SetObjecter;
  end;

implementation

{ TSSBView }

function TWorkSpaceView.PanelTopLeft: TPointF;
begin
  Result := (FFrame.Position.Point + FParentTopLeft);
//  FPanel. (FPanel.Position.Point - FParentTopLeft);
end;

function TWorkSpaceView.AddElement: IItemView;
var
  vImg: TItemView;
begin
  vImg := TItemView.Create(FFrame.Panel, PanelTopLeft);
  FElements.Add(vImg, vImg);
  vImg.Image.WrapMode := TImageWrapMode.Stretch;
  Result := vImg;
end;

function TWorkSpaceView.AddTableView: ITableView;
begin
  Result := TTableView.Create;
end;

procedure TWorkSpaceView.ChangeCursor(const ACursor: TCursor);
begin
  if ACursor = FFrame.MainImg.Cursor then
    Exit;
  FFrame.MainImg.Cursor := ACursor;
end;

procedure TWorkSpaceView.ClearAndFreeImg;
begin

end;

constructor TWorkSpaceView.Create(AFrame: TMainPanelFrame; ASelected: TImage;
  AOpenDialog: TOpenDialog; AParentTopLeft: TPointFunction);
begin
  FElements := TDictionary<IItemView, TItemView>.Create;
  FFrame := AFrame;
  FSelected := ASelected;
  FOpenDialog := AOpenDialog;
  FParentTopLeft := AParentTopLeft;
  FOptionsForm := TNamedOptionsForm.Create(nil);
  FEffect := TGlowEffect.Create(nil);
end;

destructor TWorkSpaceView.Destroy;
var
  vItem: TPair<IItemView, TItemView>;
begin
  FImager := nil;
  FObjecter := nil;

  FEffect.Free;
  for vItem in FElements do
    FElements.Remove(vItem.Key);

  FElements.Clear;
  FElements.Free;

 // FPanel := nil;
  //FBackground := nil;
  FFrame := nil;
  FSelected := nil;
  FOpenDialog := nil;

  inherited;
end;

function TWorkSpaceView.FilenameFromDlg(out AFileName: string): Boolean;
begin
  AFileName := '';
  Result := FOpenDialog.Execute;
  if Result then
    AFileName := FOpenDialog.FileName;
end;

function TWorkSpaceView.GetImager: TImagerPresenter;
begin
  Result := TImagerPresenter(FImager);
end;

function TWorkSpaceView.GetMousePos: TPoint;
begin
  Result := ((uEasyDevice.MousePos - FFrame.Position.Point - FParentTopLeft) / FFrame.Panel.Scale.X).Round;
end;

function TWorkSpaceView.GetObjecter: TObjecterPresenter;
begin
  Result := TObjecterPresenter(FObjecter);
end;

function TWorkSpaceView.GetScale: Single;
begin
  Result := FFrame.Panel.Scale.X;
end;

procedure TWorkSpaceView.MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin

end;

procedure TWorkSpaceView.RemoveElement(const AElement: IItemView);
var
  vItem: TItemView;
begin
  FEffect.Parent := nil;
  FElements.Remove(AElement);
  vItem := TItemView(AElement);
  vItem.Image.Free;
end;

procedure TWorkSpaceView.SelectElement(const AElement: IItemView);
begin
  FSelected.Bitmap.Assign(FElements[AElement].Image.Bitmap);
  FEffect.Parent := FElements[AElement].Image;
end;

procedure TWorkSpaceView.SetBackground(const AImg: TImage);
begin

end;

procedure TWorkSpaceView.SetImager(const Value: TImagerPresenter);
begin
  FImager := Value;
end;

procedure TWorkSpaceView.SetObjecter(const Value: TObjecterPresenter);
begin
  FObjecter := Value;
end;

end.
