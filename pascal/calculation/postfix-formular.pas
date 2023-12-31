type
    stacktype = record
        top: ^node;
        length: integer;
    end;
    node = record
        value : integer;
        next : ^node;
    end;

const
    operation = ['+', '-', '*', '/'];

procedure push(var s: stacktype; v : integer);
var
    temp : ^node;
begin
    if s.top = nil then begin
        new(s.top);
        s.top^.value := v;
        s.top^.next := nil;
    end
    else begin
        new(temp);
        temp^.value := v;
        temp^.next := s.top;
        s.top := temp;
    end;
    s.length := s.length + 1;
end;

function pop(var s: stacktype) : integer;
var
    temp : ^node;
begin
    pop := s.top^.value;
    temp := s.top;
    s.top := s.top^.next;
    s.length := s.length - 1;
    dispose(temp);
end;

procedure trimSpaceRight(var s: string);
begin
    while (length(s) > 0) and (s[length(s)] = ' ') do begin
        delete(s, length(s), 1);
    end;
end;

procedure trimSpaceLeft(var s: string);
begin
    while (length(s) > 0) and (s[1] = ' ') do begin
        delete(s, 1, 1);
    end;
end;

procedure trimMoreThan1Space(var s: string);
var
    i : integer;
begin
    for i:= length(s) downto 2 do begin
        if (s[i] = s[i-1]) and (s[i] = ' ') then
            delete(s, i, 1);
    end;
end;

// Check on string handleing to_number.pas
function parse_integer(var s: string; var isParse: boolean) : integer;
var
    v, code: integer;
begin
    val(s, v, code);
    if code > 0 then begin
        writeln('Error parse at ', code, ' th character, c ="', s[code] ,'", value = "', s, '"');
        isParse := false;
    end
    else begin
        writeln('Found: ', v);
        isParse := true;
    end;
    parse_integer := v;
end;

procedure processingCurrentString(current : string; var stack: stacktype);
var
    x, y, value: integer;
    isparse : boolean;
begin
    writeln('Processing current = ', current);
    // try parse to integer
    if (current[1] in operation) then begin
        if stack.length < 2 then begin
            writeln('Formula error, not enough element for calculation');
        end;
        y := pop(stack);
        x := pop(stack);
        writeln('Found valid operation, do: ', x, ' ', current, ' ', y);
        if current[1] = '+' then push(stack, x + y);
        if current[1] = '-' then push(stack, x - y);
        if current[1] = '*' then push(stack, x * y);
        if current[1] = '/' then push(stack, x div y);
    end
    else begin
        isparse := false;
        value := parse_integer(current, isparse);
        if isparse then
            push(stack, value)
        else
            writeln('Cant parse to integer, skipping');
    end;
end;

var
    stack : stacktype;
    s : string;
    current : string;
    i : integer;
begin
    readln(s);
    trimSpaceRight(s);
    trimSpaceLeft(s);

    for i:= length(s) downto 2 do begin
        if (s[i] in operation) and (s[i-1] in operation) then begin
            insert(' ', s, i);
        end;
    end;

    trimMoreThan1Space(s);
    writeln(s);

    stack.top := nil;
    stack.length := 0;

    current := '';
    for i := 1 to length(s) do begin
        if s[i] <> ' ' then
            current := current + s[i]
        else begin
            processingCurrentString(current, stack);
            current := '';
        end;
    end;
    if current <> '' then
        processingCurrentString(current, stack);
    while stack.top <> nil do begin
        writeln('Pop: ', pop(stack));
    end;
end.
