unit LZSS;

interface

uses Classes, StrUtils;

function LZSSCompress(input:string; lengthMinMatch:SmallInt=2):string;
function LZSSDecompress(input:string):string;

implementation

uses SysUtils;

//funkciq za LZSS kompresiq na string
function LZSSCompress(input:string; lengthMinMatch:SmallInt=2):string;
var i:Integer;//"pointer"
    j:Integer;
    lengthWindow:Integer;//duljinata na window-a
    lengthInput:Integer;//duljinata na vhoda
    lengthLookAheadBuffer:Integer;//duljinata na LookAhead Buffer-a
    lengthMatch:Integer;//duljinata na maksimalnoto suvpadenie
    formatPoint : string;//formata, pod koito da se otpe4ati pointera
    offSet : Integer;//otmestvaneto
    match : String;
    output : String;//izhodniq string
    window : string;
    outPart : String;
    matchPosition : Integer;//poziciqta v window-a
    isMatchMet : Boolean;//pokazva dali sme sre6tnali suvpadenie
begin
  output := '';
  lengthInput := Length(input);
  i := 1;//slagame pointera v na4aloto
  //zapo4vame da mestim pointer, 4rez izpulnqvane na stupki
  while i <= lengthInput do
  begin
    lengthLookAheadBuffer := lengthInput - i + 1;
    lengthWindow := i - 1;
    window := Copy(input,1, lengthWindow);

    isMatchMet:=False;//slagame flaga za sre6tnato suvpadenie na false

    //zapo4vame da tursim sudurjanie ot kraq na window-a do
    //dokato suvpadenieto ne e minimalno lengthMinMatch dulgo.
    //Po tozi na4in se zapo4va ot tursene na nai dulgoto suvpadenie
    for j := lengthInput downto i+lengthMinMatch-1 do
    begin
      lengthMatch := j - i +1;
      match := Copy(input, i, lengthMatch);

      matchPosition := pos(match, window);
      //ako e sre6tnato suvpadenie izlizame ot turseneto
      if (matchPosition>0) then
      begin
        isMatchMet := True;
        Break;
      end;
    end;

    if (isMatchMet = true) then
    begin
      outPart := Format('{%d,%d}',[matchPosition, lengthMatch]);
      i := j +1;
    end
    else
    begin
      outPart := input[i];
      i := i+1;
    end;

    output := output + outPart;
  end;

  Result := output;
end;

//funkciq za LZSS dekompresiq na string
function LZSSDecompress(input:string):string;
begin

end;

end.
