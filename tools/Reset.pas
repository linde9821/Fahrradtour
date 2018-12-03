program reset;

{$R+} {$Q+} {$I+}

uses sysutils, crt, HotelUnit in '../lib/HotelUnit.pas';

//user record
type user = record 
	name : string;
	password : string;
end;

type UserFileType = File of User;

var
userFile : UserFileType;
userArray : array of user;
hotelArray : array of hotel;

begin
	Assign(userFile, '../files/user.dat');
	ReWrite(userFile);
	
	setLength(userArray, 1);
	
	userArray[0].name := 'admin';
	userArray[0].password := 'root';

	write(userFile, userArray[0]);
	
	close(userFile);
	
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
	
	saveHotelsToFile('../files/hotel.dat', hotelArray);
end.