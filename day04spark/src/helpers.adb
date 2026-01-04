package body Helpers with SPARK_Mode is

    function Num_Adjacent_Rolls (RA : Roll_Array; Row, Col : Roll_Array_Index) return Integer is
        Count : Integer := 0;
    begin
        for I in 1 .. 3 loop
            for J in 1 .. 3 loop
                if Row + I - 2 in Roll_Array_Index'Range
                   and then Col + J - 2 in Roll_Array_Index'Range
                   and then not (I = 2 and then J = 2)
                then
                    if RA (Row + I - 2, Col + J - 2) then
                        Count := Count + 1;
                    end if;
                end if;
                pragma Loop_Invariant (Count <= Count'Loop_Entry + J);
            end loop;
            pragma Assert (Count <= 3 * I);
        end loop;
        return Count;
    end Num_Adjacent_Rolls;

end Helpers;