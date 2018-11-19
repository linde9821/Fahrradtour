Program Fahrradtour;
{$R+}
{$Q+}
{$I+}
uses sysutils, crt;

type user = record 
	name : string;
	password : string;
end;

type hotel = record
	name : string;			//Name des Hotels
	id : integer;
	entfernung : integer;	//Entfernung zum nächsten Hotel
end;

type allUserData = ARRAY [0..99] OF user;
type allHotelData = ARRAY [0..5] of hotel;

var 
input : String;
start, ziel, totaleEntfernung : integer;
fehlereingabe, i, j, userId : integer;
correct : boolean;
geschwindigkeit, dauer : real;

userAmount : integer;

benutzerliste: allUserData;
Datei: FILE OF allUserData;

hotelliste : allHotelData;
Datei2 : FILE OF allHotelData;

procedure iniAll();
begin
	fehlereingabe := 0;
	userAmount := 1;

	//benutzerliste[0].name := 'admin';
	//benutzerliste[0].password := 'root';


	Assign(Datei, 'daten.dat');{$I-}
	Reset(Datei);
	Read(Datei, benutzerliste);
	Close(Datei);

	Assign(Datei2, 'daten2.dat');
	Reset(Datei2);
	Read(Datei2, hotelliste);
	Close(Datei2);{$I+}
	
	{
	hotelliste[0].name := 'Krone';	
	hotelliste[0].entfernung := 11;
	hotelliste[1].name := 'Adler';	
	hotelliste[1].entfernung := 5;
	hotelliste[2].name := 'Sonne';	
	hotelliste[2].entfernung := 11;
	hotelliste[3].name := 'Central';	
	hotelliste[3].entfernung := 5;
	hotelliste[4].name := 'Hirsch';	
	hotelliste[4].entfernung := 0;
	}
	
	correct := false;
end;

procedure registUser();
begin
	

end;

procedure exit();
begin
	Assign(Datei, 'daten.dat');{$I-}
	ReWrite(Datei);
	Write(Datei, benutzerliste);
	Close(Datei);

	Assign(Datei2, 'daten2.dat');
	ReWrite(Datei2);
	Write(Datei2, hotelliste);
	Close(Datei2);{$I+}
end;

procedure showHotelliste();
begin
	for i:= low(hotelliste) to high(hotelliste) do write('--', hotelliste[i].name, '--', hotelliste[i].entfernung, 'km');
	
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
		until (i > userAmount);
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
	
	showHotelliste();
	
	write('aktuelles Hotel eingaben: ');
	readln(input);

	for i := 0 to 4 do
	begin
		if (hotelliste[i].name = input) then
			start := i;
	end;
	
	write('Zielhotel eingaben: ');
	readln(input);
	
	for i := 0 to 4 do
	begin
		if (hotelliste[i].name = input) then
			ziel := i;
	end;

	write('Geschwindigkeit (in km/h): ');
	readln(input);
	geschwindigkeit := strtofloat(input);
		
	totaleEntfernung := 0;
	
	if (start < ziel) then 
	begin 
		for j := start to ziel - 1 do totaleEntfernung := totaleEntfernung + hotelliste[j].entfernung;
	end
	else 
	begin
		for j := ziel to start - 1 do totaleEntfernung := totaleEntfernung + hotelliste[j].entfernung;
	end;
	
	writeln('Entfernung zu Hotel ', hotelliste[ziel].name , ': ', totaleEntfernung, 'km');
			
	dauer := totaleEntfernung / geschwindigkeit;	//t = s / v
			
	writeln('Dauer: ', dauer, 'h');	
	
	exit();
	
end.

