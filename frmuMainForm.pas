unit frmuMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Gauges;

type
  TfrmMainForm = class(TForm)
    gpbSettings: TGroupBox;
    lblMinLenght: TLabel;
    seMatchMinLength: TSpinEdit;
    pnlBottom: TPanel;
    pnlOptions: TPanel;
    gpbInput: TGroupBox;
    gpbOutput: TGroupBox;
    btnGo: TButton;
    rgAction: TRadioGroup;
    mmoInput: TMemo;
    mmoOutPut: TMemo;
    lblCopyright: TLabel;
    gProgress: TGauge;
    tmrProcessTime: TTimer;
    btnSwap: TButton;
    procedure btnGoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnSwapClick(Sender: TObject);
  private
    { Private declarations }
    function LZSSCompress(input:string; lengthMinMatch:SmallInt=2):string;
    function LZSSDecompress(input:string):string;
  public
    { Public declarations }
  end;

var
  frmMainForm: TfrmMainForm;

implementation
//uses LZSS;
{$R *.dfm}
const
  BRACE_LEFT_CHAR = '{';
  BRACE_RIGHT_CHAR = '}';
  SEPARATOR_CHAR = ',';
//funkciq za LZSS kompresiq na string
function TfrmMainForm.LZSSCompress(input:string; lengthMinMatch:SmallInt=2):string;
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

      matchPosition := Pos(match, window);
      //ako e sre6tnato suvpadenie izlizame ot turseneto
      if (matchPosition>0) then
      begin
        isMatchMet := True;
        Break;
      end;
    end;

    if (isMatchMet = true) then
    begin
      outPart := Format(BRACE_LEFT_CHAR+'%d'+SEPARATOR_CHAR+'%d'+BRACE_RIGHT_CHAR,[matchPosition, lengthMatch]);
      i := j +1;
    end
    else
    begin
      outPart := input[i];
      i := i+1;
    end;

    gProgress.Progress := i;
    Application.ProcessMessages();
    
    output := output + outPart;
  end;

  Result := output;
end;

//funkciq za LZSS dekompresiq na string
function TfrmMainForm.LZSSDecompress(input:string):string;
var i, iNext : integer;
    lengthInput : Integer;//duljinata na vhoda
    outPart,strVal : String;
    output : String;//izhodniq string
    currentChar : String;
    lookAheadBuffer : String;
  //proverqva dali e pointer i se opitva da vzeme stoinostta
  function TryGetPointerValue(s:String; out value:string; out closeBracketPosition):Boolean;
  var sourceLength:Integer;
      brLeftIndex, brRightIndex, separatorIndex : Integer;
      strOffset, strLengthMacth : string;
      offset, lengthMatch : Integer;

  begin
    Result:=False;
    
    
    brLeftIndex := Pos(BRACE_LEFT_CHAR, s);
    separatorIndex := Pos(SEPARATOR_CHAR, s);
    brRightIndex := Pos(BRACE_RIGHT_CHAR, s);


    if(brLeftIndex < 0)or(brRightIndex < 0)or(separatorIndex < 0)then
      Exit;

    strOffset := Copy(s, brLeftIndex+1, separatorIndex - (brLeftIndex+1));
    strLengthMacth := Copy(s, separatorIndex+1, brRightIndex - (separatorIndex+1));

    if ((TryStrToInt(strOffset, offset)=False)or
        (TryStrToInt(strLengthMacth, lengthMatch)=False)) then
      Exit;

    value := Copy(output, offset, lengthMatch);
    iNext := brRightIndex;

    Result := True;
  end;
begin
  output := '';
  lengthInput := Length(input);
  i := 1;//slagame pointera v na4aloto
  //zapo4vame da mestim pointer, 4rez izpulnqvane na stupki
  while i <= lengthInput do
  begin
    currentChar := input[i];
    if (currentChar <> BRACE_LEFT_CHAR) then
    begin
      outPart := currentChar;
      i := i+1;
    end
    else
    begin
      if (TryGetPointerValue(lookAheadBuffer, strVal, iNext)=False) then
      begin
        outPart := input[i];
        i := i + 1;
      end
      else
      begin
        outPart := strVal;
        i := i+iNext;
      end;
    end;

    gProgress.Progress := i;
    Application.ProcessMessages();

    //dobavqme stoinostta na 4astta
    output := output + outPart;

    //i4islqvame nanovo lookahead buffer-a
    lookAheadBuffer := Copy(input, i, lengthInput - i +1);

    //promenqme input-a, taka, 4e na4aloto da e output-a
    input := output + lookAheadBuffer;
    lengthInput := Length(input);

    //prei4islqvame i sprqmo noviqt input
    i := Length(output)+1;

    //priz4islqvame duljinata i q setvame i na progresa
    gProgress.MaxValue := lengthInput;
  end;

  Result := output;
end;

procedure TfrmMainForm.btnGoClick(Sender: TObject);
begin
  gProgress.MaxValue := Length(mmoInput.Text);
  gProgress.Progress := 0;
  if(rgAction.ItemIndex = 0 ) then
  begin
    mmoOutPut.Text := LZSSCompress(mmoInput.Text, seMatchMinLength.Value)
  end
  else
  begin
    mmoOutPut.Text := LZSSDecompress(mmoInput.Text)
  end;  
end;

procedure TfrmMainForm.FormResize(Sender: TObject);
var ioWindowHeight:Integer;
begin
  ioWindowHeight := (ClientHeight - (gpbSettings.Height + pnlBottom.Height +pnlOptions.Height)) div 2;
  gpbInput.Height := ioWindowHeight;
  gpbOutput.Height := ioWindowHeight;
end;

procedure TfrmMainForm.btnSwapClick(Sender: TObject);
var buff:string;
begin
  buff := mmoInput.Text;
  mmoInput.Text := mmoOutPut.Text;
  mmoOutPut.Text := buff;
end;

end.
