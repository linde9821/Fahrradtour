unit UserUnit;

interface

//user record
type user = record
	name : string;
	password : string;
end;

type UserFileType = File of User;
type UserArrayType = array of User;

function loadUsersFromeFile(path : string) : UserArrayType;
procedure saveUsersToFile(path : string; var ar : UserArrayType);

implementation

function loadUsersFromeFile(path : string) : UserArrayType;
var userArray : userArrayType;
var userFile : UserFileType;
begin
    assign(userFile, path);
    reset(userFile);

    setLength(userArray, 1);

	while not eof(userFile) do
	begin
		read(userFile, userArray[Length(userArray) - 1]);
		setLength(userArray, Length(userArray) + 1);
	end;

	setLength(userArray, Length(userArray) - 1);

	close(userFile);

	loadusersFromeFile := userArray;
end;

procedure saveUsersToFile(path : string; var ar : UserArrayType);
var i : integer;
var userFile : userFileType;
begin
    assign(userFile, path);
    rewrite(userFile);

    for i := low(ar) to high(ar) do write(userFile, ar[i]);

	close(userFile);   
end;

end.