unit FMX.CalendarHolidayDays.Style;

interface

uses
  System.UITypes, FMX.Calendar, FMX.Calendar.Style, FMX.Controls.Model, FMX.Presentation.Messages, FMX.Controls.Presentation,
  FMX.ListBox;

type

  TStyledCalendarWithHolidayDays = class(TStyledCalendar)
  protected
    { Messages from Model }
    /// <summary>Notification about changing value of DataSource of a model of <c>PresentedControl</c> </summary>
    procedure MMDataChanged(var AMessage: TDispatchMessageWithValue<TDataRecord>); message MM_DATA_CHANGED;
  protected
    procedure FillDays; override;

    procedure CreateBackground(ADayItem: TListBoxItem; const AColor: TAlphaColor); virtual;
    procedure RemoveDaysBackgrounds;

    procedure PaintWeekends; virtual;
    procedure PaintEvents; virtual;
  end;

implementation

uses
  System.SysUtils, System.DateUtils, System.Math, System.Types, FMX.Presentation.Factory, FMX.Controls, FMX.Presentation.Style, FMX.Types, FMX.Objects, FMX.Graphics, FMX.Calendar.Helpers;

{ TStyledCalendarWithHolidayDays }

procedure TStyledCalendarWithHolidayDays.CreateBackground(ADayItem: TListBoxItem; const AColor: TAlphaColor);
var
  Hightlight: TRectangle;
begin
  Hightlight := TRectangle.Create(nil);
  Hightlight.Name := 'HightlightBackground';
  Hightlight.HitTest := False;
  Hightlight.Align := TAlignLayout.Contents;
  Hightlight.Margins.Rect := TRectF.Create(1, 1, 1, 1);
  Hightlight.Stroke.Color:=TAlphaColors.White;
  Hightlight.Stroke.Kind := TBrushKind.Solid;
  Hightlight.Fill.Color := AColor;
  ADayItem.InsertObject(0, Hightlight);
end;

procedure TStyledCalendarWithHolidayDays.FillDays;
begin
  inherited;
  // Paint holidays
  RemoveDaysBackgrounds;
  if Model.ShowWeekends then
    PaintWeekends;
  if Model.ShowEvents then
    PaintEvents;
end;

procedure TStyledCalendarWithHolidayDays.MMDataChanged(var AMessage: TDispatchMessageWithValue<TDataRecord>);
begin
  if SameText(AMessage.Value.Key, 'ShowWeekends') or
     SameText(AMessage.Value.Key, 'ShowEvents') or
     SameText(AMessage.Value.Key, 'EventsColor') or
     SameText(AMessage.Value.Key, 'WeekendsColor') or
     SameText(AMessage.Value.Key, 'Events') then
    FillCalendar
  else
    inherited;
end;

procedure TStyledCalendarWithHolidayDays.PaintEvents;
var
  Events: TArray<TDateTime>;
  Event: TDateTime;
  DayItem: TListBoxItem;
begin
  if Model.Data['Events'].IsType<TArray<TDateTime>> then
  begin
    Events := Model.Data['Events'].AsType<TArray<TDateTime>>;
    for Event in Events do
    begin
      DayItem := TryFindDayItem(Event);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.EventsColor);
    end;
  end;
end;

procedure TStyledCalendarWithHolidayDays.PaintWeekends;
var
  DayItem: TListBoxItem;
  FirstDate: TDateTime;
  FirstDay: Word;
  LWeek: Integer;
  WeekendDate: TDateTime;
  FirstWeekendDay: Integer;
  MonthDaysCount: Word;
  SaturdayDay: Word;
  SundayDay: Word;
begin
  FirstDate := StartOfTheMonth(Self.Date);
  FirstDay := DayOfTheWeek(FirstDate);
  MonthDaysCount := DaysInMonth(FirstDate);
  FirstWeekendDay := DaysPerWeek - FirstDay + 1;

  for LWeek := 0 to 4 do
  begin
    // Saturday
    SaturdayDay := FirstWeekendDay - 1 + LWeek * DaysPerWeek;
    if InRange(SaturdayDay, 1, MonthDaysCount) then
    begin
      WeekendDate := RecodeDay(FirstDate, SaturdayDay);
      DayItem := TryFindDayItem(WeekendDate);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.WeekendsColor);
    end;
    // Sunday
    SundayDay := FirstWeekendDay + LWeek * DaysPerWeek;
    if InRange(SundayDay, 1, MonthDaysCount) then
    begin
      WeekendDate := RecodeDay(FirstDate, SundayDay);
      DayItem := TryFindDayItem(WeekendDate);
      if DayItem <> nil then
        CreateBackground(DayItem, Model.WeekendsColor);
    end;
  end;
end;

procedure TStyledCalendarWithHolidayDays.RemoveDaysBackgrounds;

  procedure RemoveBackground(ADayItem: TListBoxItem);
  var
    I: Integer;
    Background: TControl;
  begin
    for I := ADayItem.ControlsCount - 1 downto 0 do
      if ADayItem.Controls[I].Name = 'HightlightBackground' then
      begin
        Background := ADayItem.Controls[I];
        Background.Parent := nil;
        Background.Free;
      end;
  end;

var
  I: Integer;
  DayItem: TListBoxItem;
begin
  if Days <> nil then
    for I := 0 to Days.Count - 1 do
    begin
      DayItem := Days.ListItems[I];
      RemoveBackground(DayItem);
    end;
end;

initialization
  TPresentationProxyFactory.Current.Replace(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendarWithHolidayDays>);
finalization
  TPresentationProxyFactory.Current.Replace(TCalendar, TControlType.Styled, TStyledPresentationProxy<TStyledCalendar>);
end.
