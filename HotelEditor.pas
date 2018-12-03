program HotelEditor;

//hotel record
type hotel = record
	name : string;			
	id : integer;
	distance : integer;		//Distanz zum nächsten Hotel
end;

type HotelFileType = File of hotel;

var hotelArray : array of hotel;

procedure loadHotelsFromeFile(var hotelFile : HotelFileType);
begin
    assign(hotelFile, 'hotel.dat');
    reset(hotelFile);

    setLength(hotelArray, 1);

	while not eof(hotelFile) do
	begin
		read(hotelFile, hotelArray[Length(hotelArray) - 1]);
		setLength(hotelArray, Length(hotelArray) + 1);
	end;

	setLength(HotelArray, Length(hotelArray) - 1);

	close(hotelFile);
end;

procedure saveAllChanges(var hotelFile : HotelFileType);
var i : integer;
begin
    assign(hotelFile, 'hotel.dat');
    rewrite(hotelFile);

    for i := low(hotelArray) to high(hotelArray) do write(hotelFile, hotelArray[i]);

	close(hotelFile);   

end;

function getHotel():integer;
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
			if (hotelArray[i].name = input) then
			begin
				index := i;
				correct := true;
			end;
		end;

		if (correct = false) then
		begin
			writeln('Hotel nicht gefunden');
			getHotel := -1;
		end;
	until (correct);

	getHotel := index;
end;

procedure showHotelListe();
var i : integer;
begin
	for i := low(hotelArray) to high(hotelArray) do write('--', hotelArray[i].name, '[', i, ']', '--', hotelArray[i].distance, 'km');

	writeln();
end;

procedure newHotel();
var index, i : integer;
	nHotel : Hotel;
begin
	writeln('Hotelname: ');
	readln(nHotel.name);

	writeln('Distanz: ');
	readln(nHotel.distance);

	showHotelListe();
	writeln('Positionsindex:');
	readln(index);

	setLength(HotelArray, Length(HotelArray) + 1);

	for i := high(HotelArray) - 1 downto index  do 
	begin
		hotelArray[i+1] := hotelArray[i];
	end;


	HotelArray[index] := nHotel;
	
end;

procedure deleteHotel();
var index, i : integer;
	tempHotelArray : array of hotel;
begin
	writeln('Welches Hotel soll geloescht werden');
	showHotelListe();

	index := getHotel();

	setLength(tempHotelArray, Length(hotelArray) - 1);

	for i := low(hotelArray) to high(hotelArray) - 1 do
	begin
		if i < index then tempHotelArray[i] := hotelArray[i]
		else if i >= index then tempHotelArray[i] := hotelArray[i+1];
	end;

	setLength(HotelArray, 0);
	setLength(HotelArray, Length(tempHotelArray));

	for i := low(tempHotelArray) to high(tempHotelArray) do
	begin
		hotelArray[i] := tempHotelArray[i];
	end;

	showHotelListe();
end;

//Einstiegspunkt
var
    hotelFile : HotelFileType;
	input : string;
begin
    loadHotelsFromeFile(hotelFile);

	repeat
		writeln('(N)ew/(D)elete/(S)how/(E)xit:');
		readln(input);
		if (input = 'n') or (input = 'N') then newHotel()
		else if (input = 'd') or (input = 'D') then deleteHotel()
		else if (input = 's') or (input = 'S') then showHotelListe();
	until (input = 'e') or (input = 'E');

	writeln('Save changes? (Y)es/(N):');
	readln(input);

	if (input = 'y') or (input = 'Y') then saveAllChanges(hotelFile);
end.