package body Helpers with SPARK_Mode is

    function Max_Joltage_1 (Arr : Input_Array) return Integer is
        Ind1, Ind2 : Input_Array_Index := 1;
        Max : Input_Number := 0;
    begin
        for I in 1 .. Arr.Length - 1 loop
            if Arr.Contents (I) > Max then
                Max := Arr.Contents (I);
                Ind1 := I;
            end if;
        end loop;

        Max := 0;
        for I in Ind1 + 1 .. Arr.Length loop
            if Arr.Contents (I) > Max then
                Max := Arr.Contents (I);
                Ind2 := I;
            end if;
        end loop;

        return 10 * Arr.Contents (Ind1) + Arr.Contents (Ind2);

    end Max_Joltage_1;

    procedure Power_Inequality (X, Y : Natural) is
    begin
        null;
    end Power_Inequality;

    function Max_Joltage_2 (Arr : Input_Array; Digits_To_Go : Joltage_Digit) return Long_Integer is
        Max_Ind : Input_Array_Index := 1;
        Ind1 : Input_Array_Index := 1;
        Max : Input_Number := 0;
        Val1, Val2 : Long_Integer := 0;
    begin
        Max_Ind := Arr.Length - Digits_To_Go + 1;

        --  I find it strange that I have to assert this here instead of after
        --  the computation of Val2 in order for everything to prove.
        Power_Inequality (Digits_To_Go, 12);
        pragma Assert (10 ** Digits_To_Go <= 10 ** 12);

        for I in 1 .. Max_Ind loop
            if Arr.Contents (I) > Max then
                Max := Arr.Contents (I);
                Ind1 := I;
            end if;
            pragma Loop_Invariant (Ind1 <= Arr.Length - Digits_To_Go + 1);
        end loop;
        Val1 := Long_Integer (Arr.Contents (Ind1)) * (10 ** (Digits_To_Go - 1));
        pragma Assert (Val1 <= 9 * (10 ** (Digits_To_Go - 1)));
        Power_Inequality (Digits_To_Go - 1, 12);
        pragma Assert (Val1 <= 9 * (10 ** 12));

        Val2 := 0;
        if Digits_To_Go > 1 then
            declare
                Sub_Arr : Input_Array;
            begin
                Sub_Arr.Length := Arr.Length - Ind1;
                for I in Ind1 + 1 .. Arr.Length loop
                    Sub_Arr.Contents (I - Ind1) := Arr.Contents (I);
                end loop;
                Val2 := Max_Joltage_2 (Sub_Arr, Digits_To_Go - 1);
            end;
        end if;
        pragma Assert (Val2 <= 10 ** (Digits_To_Go));
        pragma Assert (Val2 <= 10 ** 12);

        pragma Assert (Val1 < Long_Integer'Last - Val2);
        return Val1 + Val2;

    end Max_Joltage_2;
end Helpers;