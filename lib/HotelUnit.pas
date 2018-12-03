unit HotelUnit;

interface

//hotel record
type hotel = record
	name : string;			
	id : integer;
	distance : integer;		//Distanz zum nächsten Hotel
end;

type HotelFileType = File of hotel;
type HotelArrayType = array of Hotel;

function loadHotelsFromeFile(path : string) : HotelArrayType;
procedure saveHotelsToFile(path : string; var ar : HotelArrayType);
procedure showHotelListe(var ar : HotelArrayType);
function getHotelFrom(var ar : HotelArrayType) : integer;

implementation

function loadHotelsFromeFile(path : string) : HotelArrayType;
var hotelArray : HotelArrayType;
var hotelFile : HotelFileType;
begin
    assign(hotelFile, path);
    reset(hotelFile);

    setLength(hotelArray, 1);

	while not eof(hotelFile) do
	begin
		read(hotelFile, hotelArray[Length(hotelArray) - 1]);
		setLength(hotelArray, Length(hotelArray) + 1);
	end;

	setLength(HotelArray, Length(hotelArray) - 1);

	close(hotelFile);

	loadHotelsFromeFile := hotelArray;
end;

procedure saveHotelsToFile(path : string; var ar : HotelArrayType);
var i : integer;
var hotelFile : HotelFileType;
begin
    assign(hotelFile, path);
    rewrite(hotelFile);

    for i := low(ar) to high(ar) do write(hotelFile, ar[i]);

	close(hotelFile);   
end;

procedure showHotelListe(var ar : HotelArrayType);
var i : integer;
begin
	for i := low(ar) to high(ar) do write('--', ar[i].name, '[', i, ']', '--', ar[i].distance, 'km');

	writeln();
end;

function getHotelFrom(var ar : HotelArrayType):integer;
var
	correct : boolean;
	index, i : integer;
	input : string;
begin
	correct := false;

	repeat
		readln(input);

		for i := 0 to 4 do
		begin
			if (ar[i].name = input) then
			begin
				index := i;
				correct := true;
			end;
		end;

		if (correct = false) then
		begin
			writeln('Hotel nicht gefunden');
			getHotelFrom := -1;
		end;
	until (correct);

	getHotelFrom := index;
end;

end.