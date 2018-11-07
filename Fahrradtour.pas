Program Fahrradtoud;
{$R+}
{$Q+}

uses sysutils;

type user = record 
	name : string;
	password : string;
end;

type hotel = record
	name : string;			//Name des Hotels
	id : integer;
	entfernung : integer;	//Entfernung zum nächsten Hotel
end;

var 
input : String;
fehlereingabe, i, userId : integer;
benutzerliste : array[0..4] of user;
hotelliste : array[0..4] of hotel;
correct : boolean;
geschwindigkeit, dauer : real;

procedure iniAll();
begin
	fehlereingabe := 0;
	
	for i := 0 to 4 do 
	begin
		benutzerliste[i].name := 'user' + IntToStr(i);
		benutzerliste[i].password := '1234';
	end;
	
	hotelliste[0].name := 'A';	
	hotelliste[0].entfernung := 70;
	hotelliste[1].name := 'B';	
	hotelliste[1].entfernung := 110;
	hotelliste[2].name := 'C';	
	hotelliste[2].entfernung := 54;
	hotelliste[3].name := 'D';	
	hotelliste[3].entfernung := 118;
	hotelliste[4].name := 'E';	
	hotelliste[4].entfernung := 0;
	
	correct := false;
end;

procedure showHotels();
begin
	for i:= low(hotelliste) to high(hotelliste) do 
	begin
		write('--', hotelliste[i].name, '--', hotelliste[i].entfernung, 'km');
	end;
	writeln();
end;

begin
	//Initialisierungen
	iniAll();
	
	//Anmeldung
	//Prüfen des benutzernamens
	repeat 
		write('Name: ');
		readln(input);
		i := 0;
		repeat 
			if (benutzerliste[i].name = input) then 
			begin
				correct := true;
				userId := i;
				break;
			end;
				
			i := i+1;
		until (i > 4);
	until(correct);
	
	correct := false;

	//Prüfen des Passwords
	repeat 
		write('Password: ');
		readln(input);
		
		if (benutzerliste[userId].password = input) then correct := true
		else
		begin
			writeln('Falsches Password');
			fehlereingabe := fehlereingabe + 1;
			
			if (fehlereingabe > 3) then 
			begin
				writeln('Zu viele Fehlerhafte eingaben');
				exit;
			end;
		end;
	until(correct);
	
	writeln('Erfolgreich angemeldet');
	
	showHotels();
	
	write('Hotel eingaben: ');
	readln(input);
	
	for i := 0 to 3 do
	begin
		if (hotelliste[i].name = input) then 
		begin
			write('Geschwindigkeit (in km/h): ');
			readln(input);
			geschwindigkeit := strtofloat(input);
			
			
			writeln('Entfernung zu Hotel ', hotelliste[i+1].name , ': ', hotelliste[i].entfernung, 'km');
			
			dauer := hotelliste[i].entfernung / geschwindigkeit;	//t = s / v
			
			writeln('Dauer: ', dauer, 'h');			
		end;
	end;
end.

