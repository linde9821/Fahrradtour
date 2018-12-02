program reset;

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

type HotelFileType = File of Hotel;
type UserFileType = File of User;

var
userFile : UserFileType;
hotelFile : HotelFileType;
userArray : array of user;
hotelArray : array of hotel;

var 
i : integer;
begin
	Assign(userFile, 'user.dat');
	ReWrite(userFile);
	
	setLength(userArray, 1);
	
	userArray[0].name := 'admin';
	userArray[0].password := 'root';

	write(userFile, userArray[0]);
	
	close(userFile);
	
	Assign(hotelFile, 'hotel.dat');
	ReWrite(hotelFile);
	
	setLength(hotelArray, 5);
	
	hotelArray[0].name := 'Krone';	
	hotelArray[0].distance := 11;
	hotelArray[1].name := 'Adler';	
	hotelArray[1].distance := 5;
	hotelArray[2].name := 'Sonne';	
	hotelArray[2].distance := 11;
	hotelArray[3].name := 'Central';	
	hotelArray[3].distance := 5;
	hotelArray[4].name := 'Hirsch';	
	hotelArray[4].distance := 0;
	
	for i := 0 to 4 do write(hotelFile, hotelArray[i]);
	
	close(hotelFile);
end.