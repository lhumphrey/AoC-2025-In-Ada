with Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;

package body Helpers with SPARK_Mode is

function Is_Invalid_1 (X : Long_Positive) return Boolean is
    S : String := Ada.Strings.Fixed.Trim(X'Image, Both);
    Num_Digits : Natural := S'Length;
begin
    if Num_Digits mod 2 /= 0 then
        return False;
    end if;

    if S (1 .. Num_Digits / 2) = S (Num_Digits / 2 + 1 .. S'Length) then
        return True;
    end if;
    return False;
end Is_Invalid_1;


function Is_Invalid_2 (X : Long_Positive) return Boolean is
    S : String := Ada.Strings.Fixed.Trim(X'Image, Both);
    Num_Digits : Natural := S'Length;
    Substring_Len : Positive;
    Repeats : Boolean;
begin
    if Num_Digits = 1 then
        return False;
    end if;

    for Divs in 2 .. Num_Digits loop
        if Num_Digits mod Divs = 0 then
            Substring_Len := Num_Digits / Divs;
            Repeats := True;
            for i in 1 .. Divs - 1 loop
                if S (i * Substring_Len + 1 .. (i + 1) * Substring_Len) /= S (1 .. Substring_Len) then
                    Repeats := False;
                end if;
            end loop;
            if Repeats then
                return True;
            end if; 
        end if;
    end loop;

    return False;
end Is_Invalid_2;

end Helpers;