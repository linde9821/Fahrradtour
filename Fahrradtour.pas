Program Fahrradtour;
{$R+} {$Q+} {$I+}

uses sysutils, crt;

//user record
type user = record
	name : string;
	password : string;
end;

//hotel record
type hotel = record
	name : string;			
	id : integer;
	distance : integer;		//distance zum nächsten Hotel
end;

type HotelFileType = File of Hotel;
type UserFileType = File of User;

//TODO: Variablen lokalisieren
var
start, goal: integer;
errorInput, i, j, userId : integer;
userFile : UserFileType;
hotelFile : HotelFileType;

userArray : array of user;
hotelArray : array of hotel;

//inis all vars and loads all data from files
procedure iniAll();
begin
	errorInput := 0;

	Assign(userFile, 'user.dat');
	Reset(userFile);

	setLength(userArray, 1);

	userArray[0].name := 'admin';
	userArray[0].password := 'root';

	while not eof(userFile) do
	begin
		setLength(userArray, Length(userArray) + 1);
		read(userFile, userArray[Length(userArray) - 1]);
	end;

	close(userFile);

	Assign(hotelFile, 'hotel.dat');
	reset(hotelFile);

	setLength(hotelArray, 1);

	while not eof(hotelFile) do
	begin
		read(hotelFile, hotelArray[Length(hotelArray) - 1]);
		setLength(hotelArray, Length(hotelArray) + 1);
	end;

	close(hotelFile);
end;

//registes user (would need to be reworked if list would be implimented)
procedure registUser();
var newName, newPassword : string;
begin
	writeln('Neuer Benutzername: ');
	readln(newName);

	writeln('Benutzerpassword: ');
	readln(newPassword);

	userArray[Length(userArray) - 1].name := newName;
	userArray[Length(userArray) - 1].password := newPassword;

	SetLength(userArray, Length(userArray) + 1);
end;

//not workings (needs list to provide this functionality)
procedure delAUser();
var username : string;
i : integer;
wasCorrected : boolean;
begin
	wasCorrected := false;
	writeln('Welcher benutzer soll gelöscht werden?');

	readln(username);

	for i := 1 to high(userArray) do begin
		if username = userArray[i].name then
		begin
			wasCorrected := true;
			//userList[i].name := nil;
			//userList[1].password := nil;
		end;
	end;

	if (wasCorrected <> true) then writeln('Kein User mit diesem Namen');

end;

//not workings (needs list to provide this functionality)
procedure delAllUsers();
var i : integer;
begin
	for i:= 1 to High(userArray) do
	begin
		userArray[i].name := '';
		userArray[i].password := '';
	end;
end;

//closes program and saves all data
procedure exit();
var i : integer;
begin
	Assign(userFile, 'user.dat');
	Rewrite(userFile);

	for i := low(userArray) + 1 to high(userArray) do write(userFile, userArray[i]);

	close(userFile);

	Assign(hotelFile, 'hotel.dat');
	Rewrite(hotelFile);

	for i := low(hotelArray) to high(hotelArray) do write(hotelFile, hotelArray[i]);

	close(hotelFile);
end;

procedure showHotelListe();
begin
	for i := low(hotelArray) to high(hotelArray) do write('--', hotelArray[i].name, '--', hotelArray[i].distance, 'km');

	writeln();
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

function calcKM():integer;
var total : integer;
	temp : integer;
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

	for j := start to goal - 1 do
	begin
		total := total + hotelArray[j].distance;

		writeln
	end;

	calcKM := total;
end;

function login():boolean;
var input : string;
begin
	//Prüfen des benutzernamens
	login := false;

	repeat
		write('Name: ');
		readln(input);
		i := 0;
		repeat
			if (userArray[i].name = input) then
			begin
				writeln('Brack at index: ' , i);
				login := true;
				userId := i;
				break;
			end;

			i := i+1;
		until (i >= Length(userArray));
	until(login);

	login := false;

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

//returns hotelindex if valid, otherwise -1
function getHotel():integer;
var
	correct : boolean;
	index : integer;
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

//allowes to input hotels inbetween the start and goal hotel
//bug with "if (inbetweenIndex is inbeetweenHotels)"
procedure inbeetweenHotels();
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

procedure registHotel();
var
	name, input : string;
	correct : boolean;
	index : array[0..1] of integer;
	dif : integer;
begin
	writeln('Hotelnname: ');
	readln(name);

	writeln('Wo liegt das Hotel?');

	showHotelListe();

	writeln('Liegt das neue Hotel innerhalb der Liste oder Außerhalb der Liste? (J)a/(N)ein)');
	readln(input);

	correct := false;

	if input = 'J' then
	begin
		writeln('Innerhalb');
		writeln('Geben Sie die Namen der Hotels an zwischen denen sich das neue Hotel befindet');
		repeat
			writeln('Hotel 1: ');
			index[0] := getHotel();

			writeln('Hotel 2: ');
			index[1] := getHotel();

			dif := index[1] - index[0];

			if (dif = 1) then correct := true;

		until correct;
	end
	else
	begin
		writeln('Außerhalb');

	end;
end;

procedure reise();
var
totaleDistance : integer;
speed : real;
input : String;	
begin
		showhotelListe();

		writeln('Starthotel');
		start := getHotel();

		writeln('Zielhotel');
		goal := getHotel();

		inbeetweenHotels();

		write('Geschwindigkeit (in km/h): ');
		readln(input);
		speed := StrToFloat(input);

		totaleDistance := calcKM();

		writeln('Die Distanz zu Hotel ', hotelArray[goal].name , 'betraegt ', totaleDistance, ' km');

		writeln('Reisezeit: ', calcTravelTime(totaleDistance, speed), ' Minuten');
end;

//Hauptprogramm
var
input : String;								//std input string
begin
	//Initialisierungen
	iniAll();

	//Anmeldung
	login();

	writeln('H = Hotels  R = User registrieren');
	readln(input);

	if ((input = 'h') or (input = 'H')) then
	begin
		reise();
	end
	else if ((input = 'r') or (input = 'R')) then
	begin
		registUser();
	end
	//under construction
	else if ((input = 'nh') or (input = 'NH')) then
	begin
		registHotel();
	end
	else if ((input = 'dau') or (input = 'DAU')) then
	begin
		//delAllUsers();
	end
	else if ((input = 'du') or (input = 'DU')) then
	begin
		//delAUser();
	end
	else if ((input = 'h') or (input = 'help')) then
	begin

	end;

	exit();
end.
