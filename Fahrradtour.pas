Program Fahrradtour;
{$R+} {$Q+} {$I+}

uses sysutils, crt;

//user record
type user = record 
	name : string;
	password : string;
end;

//hotrl record
type hotel = record
	name : string;			//Name des Hotels
	id : integer;
	distance : integer;	//distance zum nächsten Hotel
end;

type allUserData = ARRAY [0..99] of user;
//type allHotelData = ARRAY [0..4] of hotel;

//TODO: Variablen lokalisieren 
var 
input : String;								//std input string
start, goal, totaleDistance : integer;
errorInput, i, j, userId : integer;
speed : real;

userAmount : integer;

userList: allUserData;
file1: FILE OF allUserData;

hotelListe : allHotelData;
file2 : FILE OF allHotelData;

//inis all vars and loads all data from files
procedure iniAll();
begin
	errorInput := 0;
	userAmount := 2;

	{$I-}
	Assign(file1, 'daten.dat');
	Reset(file1);
	Read(file1, userList);
	Close(file1);

	{
	Assign(file2, 'daten2.dat');
	Reset(file2);
	Read(file2, hotelListe);
	Close(file2);
	}
	{$I+}
	
	userList[0].name := 'admin';
	userList[0].password := 'root';
end;

//registes user (would need to be reworked if list would be implimented)
procedure registUser();
var newName, newPassword : string;
begin
	writeln('Neuer Benutzername: ');
	readln(newName);
	
	writeln('Benutzerpassword: ');
	readln(newPassword);

	userAmount := userAmount + 1;
	userList[userAmount - 1].name := newName;
	userList[userAmount - 1].password := newPassword;
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
	
	for i := 1 to high(userList) do begin 
		if username = userList[i].name then 
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
	for i:= 1 to userAmount do
	begin
		userList[i].name := '';
		userList[i].password := '';
	end;
end;

//closes program and saves all data
procedure exit();
begin
	{$I-}
	Assign(file1, 'daten.dat');
	ReWrite(file1);
	Write(file1, userList);
	Close(file1);
	{
	Assign(file2, 'daten2.dat');
	ReWrite(file2);
	Write(file2, hotelListe);
	Close(file2);
	}
	{$I+}
end;

procedure showhotelListe();
var 
	h : hotel;
begin
	for i:= low(hotelListe) to high(hotelListe) do write('--', hotelListe[i].name, '--', hotelListe[i].distance, 'km');
	
	writeln();
end;

function calcTravelTime(totaleDistance, speed : real):String;
var 
	temp : real;
begin
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
		total := total + hotelListe[j].distance;
		
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
			if (userList[i].name = input) then 
			begin
				login := true;
				userId := i;
				break;
			end;
				
			i := i+1;
		until (i > userAmount);
	until(login);
	
	login := false;

	//Prüfen des Passwords
	repeat 
		write('Password: ');
		readln(input);
		
		if (userList[userId].password = input) then login := true
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
var correct : boolean;
var index : integer;
begin	
	correct := false;

	repeat
		readln(input);
	
		for i := 0 to 4 do
		begin
			if (hotelListe[i].name = input) then 
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

//program startpoint
begin
	//Initialisierungen
	iniAll();
	
	//Anmeldung
	login();
	
	writeln('H = Hotels  R = User registrieren');
	readln(input);
	
	if ((input = 'h') or (input = 'H')) then
	begin
		showhotelListe();

		writeln('Starthotel');
		start := getHotel();
		
		writeln('Zielhotel');
		goal := getHotel();
		
		inbeetweenHotels();

		write('speed (in km/h): ');
		readln(input);
		speed := strtofloat(input);
		
		totaleDistance := calcKM();
	
		writeln('Die Distanz zu Hotel ', hotelListe[goal].name , 'betraegt ', totaleDistance, ' km');
				
		writeln('Reisezeit: ', calcTravelTime(totaleDistance, speed), ' Minuten');	
		
		
	end
	else if ((input = 'r') or (input = 'R')) then
	begin
		registUser();
	end	
	else if ((input = 'd') or (input = 'D')) then
	begin
		
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