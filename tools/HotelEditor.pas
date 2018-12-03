program HotelEditor;

uses HotelUnit in '../lib/HotelUnit.pas', sysutils;

var hotelArray : array of hotel;

procedure addHotel();
var index, i : integer;
	nHotel : Hotel;
begin
	writeln('Add');
	writeln('hotelname: ');
	readln(nHotel.name);

	writeln('distance: ');
	readln(nHotel.distance);

	showHotelListe(hotelArray);
	writeln('new index:');
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
	writeln('Delete');
	showHotelListe(hotelArray);

	index := getHotelFrom(hotelArray);

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

	showHotelListe(hotelArray);
end;

procedure modifyHotel();
var index : integer;
	dis : string;
begin
	writeln('Modify');
	showHotelListe(hotelArray);

	index := getHotelFrom(hotelArray);

	writeln('changed Name for (', hotelArray[index].name, '): ');
	readln(hotelArray[index].name);

	writeln('changed distance (old: ', hotelArray[index].distance, ')');
	readln(dis);

	hotelArray[index].distance := strtoint(dis);
end;

//Einstiegspunkt
var input : string;
begin
	hotelArray := loadHotelsFromeFile('../files/Hotel.dat');

	writeln('loaded');

	repeat
		writeln('(A)dd/(D)elete/(M)odify/(S)how/(E)xit:');
		readln(input);
		if (input = 'a') or (input = 'A') then addHotel()
		else if (input = 'd') or (input = 'D') then deleteHotel()
		else if (input = 'm') or (input = 'M') then modifyHotel()
		else if (input = 's') or (input = 'S') then showHotelListe(hotelArray);
	until (input = 'e') or (input = 'E');

	writeln('Save changes? (Y)es/(N):');
	readln(input);

	if (input = 'y') or (input = 'Y') then begin 
		saveHotelsToFile('../files/Hotel.dat', hotelArray); 
		writeln('saved');
	end else writeln('discarded');
end.