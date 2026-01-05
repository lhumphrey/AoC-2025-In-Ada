with Ada.Containers; use Ada.Containers;
with Ada.Text_IO; use Ada.Text_IO;

package body Helpers with SPARK_Mode is

    function In_A_Fresh_Range
        (Fresh_Ranges : Id_Range_Vectors.Vector;
         Val : Long_Integer) return Boolean
    is
    begin
        for E of Fresh_Ranges loop
            if Val in E (1) .. E (2) then
                return True;
            end if;
        end loop;
        return False;
    end In_A_Fresh_Range;

    procedure Get_Non_Overlapping_Next_Ranges
        (Base_Range, Next_Range : Id_Range;
         Partitioned_Ranges : in out Id_Range_Vectors.Vector)
    is
    begin
        --  Next_Range is strictly less than or greater than Base_Range
        if Next_Range (2) < Base_Range (1) or else Next_Range (1) > Base_Range (2)
        then
            Id_Range_Vectors.Append (Partitioned_Ranges, Next_Range);
            return;
        end if;
        --  Next_Range is entirely contained in Base_Range
        if Next_Range (1) in Base_Range (1) .. Base_Range (2) and then
           Next_Range (2) in Base_Range (1) .. Base_Range (2)
        then
            return;
        end if;
        --  Base_Range is entirely contained within Next_Range
        if Base_Range (1) in Next_Range (1) .. Next_Range (2) and then
           Base_Range (2) in Next_Range (1) .. Next_Range (2)
        then
            if Next_Range (1) < Base_Range (1) then
                Id_Range_Vectors.Append (Partitioned_Ranges, Id_Range'(Next_Range (1), Base_Range (1) - 1));
            end if;
            if Base_Range (2) < Next_Range (2) then
                Id_Range_Vectors.Append (Partitioned_Ranges, Id_Range'(Base_Range (2) + 1, Next_Range (2)));
            end if;
            return;
        end if;
        --  Next_Range overlaps on Base_Range's left
        if Base_Range (1) in Next_Range (1) .. Next_Range (2) then
            Id_Range_Vectors.Append (Partitioned_Ranges, Id_Range'(Next_Range (1), Base_Range (1) - 1));
            return;
        end if;
        --  Next_Range overlaps on Base_Range's right
        if Base_Range (2) in Next_Range (1) .. Next_Range (2) then
            Id_Range_Vectors.Append (Partitioned_Ranges, Id_Range'(Base_Range (2) + 1, Next_Range (2)));
            return;
        end if;
    end Get_Non_Overlapping_Next_Ranges;

    procedure Make_Fresh_Ranges_Non_Overlapping
        (Fresh_Ranges : in out Id_Range_Vectors.Vector)
    is
        Base_Ind : Positive := 1;
        Next_Ind : Positive;
        Partitioned_Ranges : Id_Range_Vectors.Vector (3);
    begin
        while Base_Ind < Integer (Length (Fresh_Ranges)) loop
            Next_Ind := Base_Ind + 1;
            while Next_Ind <= Integer (Length (Fresh_Ranges)) loop
                Partitioned_Ranges := Id_Range_Vectors.Empty_Vector (3);
                Get_Non_Overlapping_Next_Ranges
                    (Element (Fresh_Ranges, Base_Ind),
                     Element (Fresh_Ranges, Next_Ind),
                     Partitioned_Ranges);
                if Length (Partitioned_Ranges) = 0 then
                    Delete (Fresh_Ranges, Next_Ind);
                else
                    Delete (Fresh_Ranges, Next_Ind);
                    Insert_Vector (Fresh_Ranges, Next_Ind, Partitioned_Ranges);
                    Next_Ind := Next_Ind + Integer (Length (Partitioned_Ranges));
                end if;
            end loop;
            Base_Ind := Base_Ind + 1;
        end loop;
    end Make_Fresh_Ranges_Non_Overlapping;

end Helpers;