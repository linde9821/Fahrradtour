Program Fahrradtour;
{$R+} {$Q+} {$I+}

uses sysutils, crt, HotelUnit in 'lib/HotelUnit.pas', UserUnit in 'lib/userUnit.pas' ;

var
userArray : array of user;
hotelArray : array of hotel;

//loads all Files and sets admin-acc
procedure loadFiles();
begin

	userArray := loadUsersFromeFile('files/User.dat');
	userArray[0].name := 'admin';
	userArray[0].password := 'root';

	hotelArray := loadHotelsFromeFile('files/Hotel.dat');
end;

//closes program and saves all data
procedure exit();
begin
	saveUsersToFile('files/User.dat', userArray);	
	saveHotelsToFile('files/Hotel.dat', hotelArray);
end;

function login():boolean;
var input : string;
	i, errorInput, userId : integer;
begin
	//Prüfen des benutzernamens
	login := false;

	writeln('Login:');

	repeat
		write('Name: ');
		readln(input);
		i := 0;
		repeat
			if (userArray[i].name = input) then
			begin
				login := true;
				userId := i;
				break;
			end;

			i := i+1;
		until (i >= Length(userArray));
	until(login);

	login := false;
	errorInput := 0;

	//Prüfen des Passwords
	repeat
		write('Password: ');
		readln(input);

		if (userArray[userId].password = input) then login := true
		else
		begin
			writeln('Falsches Password');
			errorInput := errorInput + 1;

			if (errorInput > 3) then
			begin
				writeln('Zu viele Fehlerhafte eingaben');
				login := false;
			end;
		end;
	until(login);

	writeln('Erfolgreich angemeldet');
end;

//registes user
procedure registUser();
var newName, newPassword : string;
begin
	writeln('Neuer Benutzername: ');
	readln(newName);

	writeln('Benutzerpassword: ');
	readln(newPassword);

	SetLength(userArray, Length(userArray) + 1);

	userArray[high(userArray)].name := newName;
	userArray[high(userArray)].password := newPassword;
end;

//returns hotelindex if valid, otherwise -1
function getHotel():integer;
var
	correct : boolean;
	index, i : integer;
	input : string;
begin
	correct := false;

	repeat
		readln(input);

		for i := low(hotelArray) to high(hotelArray) do
		begin
			if (hotelArray[i].name = input) then
			begin
				index := i;
				correct := true;
			end;
		end;
	until (correct);

	getHotel := index;
end;

function calcTravelTime(totaleDistance, speed : real):String;
var
	temp : real;
begin
	if (speed <= 0) then speed := 1;

	temp := totaleDistance / speed;	//t = s / v
	temp := temp * 60;

	calcTravelTime := FloatToStr(temp);
end;

function calcKm(start, goal : integer):integer;
var total, temp, i : integer;
begin
	total := 0;

	//if true swap start and goal (makes no difference to the output)
	if (start > goal) then
	begin
		temp := goal;
		goal := start;
		start := temp;
	end;

	write('Start ');

	for i := start to goal - 1 do
	begin
		total := total + hotelArray[i].distance;
		writeln();
	end;

	calcKM := total;
end;

//allowes to input hotels inbetween the start and goal hotel
//bug with "if (inbetweenIndex is inbeetweenHotels)"
procedure inbeetweenHotels(start, goal : integer);
var input : string;
	inbetweenIndex : integer;
begin
	if abs(goal - start) > 1 then
	begin
		writeln('Gibt es zwischenziele? (J)a / (N)ein: ');
		readln(input);

		if ((input = 'J') or (Input = 'j')) then
		begin
			writeln('Zwischenziel: ');
			inbetweenIndex := getHotel();

			if (start > inbetweenIndex) or (goal < inbetweenIndex) then writeln('Hotel liegt nicht dazwischen');
		end;
	end;

end;

procedure reise();
var
	totaleDistance, start, goal : integer;
	speed : real;
	input : String;	
begin
		showHotelListe(hotelArray);

		writeln('Starthotel');
		start := getHotel();

		writeln('Zielhotel');
		goal := getHotel();

		inbeetweenHotels(start, goal);

		write('Geschwindigkeit (in km/h): ');
		readln(input);
		speed := StrToFloat(input);

		totaleDistance := calcKm(start, goal);

		writeln('Die Distanz zu Hotel ', hotelArray[goal].name , 'betraegt ', totaleDistance, ' km');

		writeln('Reisezeit: ', calcTravelTime(totaleDistance, speed), ' Minuten');
end;

//Einstiegspunkt
var
input : String;								//std input string
begin
	//Initialisierungen
	loadFiles();

	repeat
		//Anmeldung
		login();

		repeat
			writeln('(H)otels (U)ser registrieren (A)usloggen (E)xit:');
			readln(input);

			if ((input = 'h') or (input = 'H')) then reise()
			else if ((input = 'u') or (input = 'U')) then registUser()
		until (input = 'e') or (input = 'E') or (input = 'a') or (input = 'A');
	until (input = 'e') or (input = 'E');

	//saves all Data
	exit();
end.
