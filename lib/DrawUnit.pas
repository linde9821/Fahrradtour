unit DrawUnit;

interface

uses HotelUnit, Graph, Crt, SysUtils;

procedure drawHotel(h : hotel; x, y : integer);
procedure drawPath(h : hotelArrayType; startIndex, goalIndex : integer);

implementation

var treiber, modus : integer;

procedure drawHotel(h : hotel; x, y : integer);
const   width = 200;
const   height = 300;
var i : integer;
begin
    //DetectGraph(treiber, modus);
    //InitGraph(treiber, modus, '..');

    //Wände
    Line(x, y, x + width, y);
    Line(x, y, x, y - height);
    Line(x + width, y, x + width, y - height);
    Line(x, y - height, x + width, y - height);

    //Türen
    Line(x + trunc(width / 2 - 10), y - 5, x + trunc(width / 2 - 30), y - 5);
    Line(x + trunc(width / 2 - 10), y - 50, x + trunc(width / 2 - 30), y - 50);
    Line(x + trunc(width / 2 + 10), y - 5, x + trunc(width / 2 + 30), y - 5);
    Line(x + trunc(width / 2 + 10), y - 50, x + trunc(width / 2 + 30), y - 50);

    Line(x + trunc(width / 2 - 10), y - 5, x + trunc(width / 2 - 10), y - 50);
    Line(x + trunc(width / 2 - 30), y - 5, x + trunc(width / 2 - 30), y - 50);

    Line(x + trunc(width / 2 + 10), y - 5, x + trunc(width / 2 + 10), y - 50);
    Line(x + trunc(width / 2 + 30), y - 5, x + trunc(width / 2 + 30), y - 50);

    //Fenster
    OutTextXY(x + trunc(250/2)-30, y - trunc(300/2), h.name);

    
end;

procedure drawPath(h : hotelArrayType; startIndex, goalIndex : integer);
var i, x, y : integer;
begin
    DetectGraph(treiber, modus);
    InitGraph(treiber, modus, '..');

    x := 10;
    y := 400;
    
    for i := startIndex to goalIndex do 
    begin
        drawHotel(h[i], x, y);

        x := x + 400;
    end;

    x := 10;

    for i := startIndex to goalIndex-1 do 
    begin
        Line(x, y, x + 400, y);

        x := x + 400;

        OutTextXY(x + 50, y + 10, IntToStr(h[i].distance));

        
    end;
end;
end.