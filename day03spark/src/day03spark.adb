with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with SPARK.Containers.Formal.Vectors;
with Ada.Containers; use Ada.Containers;
with Helpers; use Helpers;

procedure Day03spark with SPARK_Mode, Always_Terminates => False is

   package Input_Array_Vectors is new
     SPARK.Containers.Formal.Vectors (Positive, Input_Array);
   use Input_Array_Vectors;

   Filename : constant String := "input.txt";
   File : File_Type;
   S : String (1 .. 128) with Relaxed_Initialization;
   Last_Idx, Dummy_Idx : Natural;
   Input_Arrays : Input_Array_Vectors.Vector (256);
   Count1 : Integer := 0;
   Count2 : Long_Integer := 0;

begin

   ------------------------
   --- INPUT PROCESSING ---
   ------------------------
   begin
      Open (File, In_File, Filename);
   exception
      when others =>
         Put_Line ("Error: Problem reading from file.");
         return;
   end;

   while not End_Of_File (File) loop
      begin
         Get_Line (File, S, Last_Idx);
      exception
         when others =>
            Put_Line ("Error: Problem reading from file.");
            return;
      end;

      pragma Assert (S (1 .. Last_Idx)'Initialized);

      if Last_Idx >= 1 then
         if Last_Idx <= Input_Array_Index'Last then
            declare
               A : Input_Array;
               Int : Integer;
            begin
               A.Length := Last_Idx;
               for I in 1 .. Last_Idx loop
                  begin
                     Ada.Integer_Text_IO.Get(S (I .. I), Int, Dummy_Idx);
                  exception
                     when others =>
                        Put_Line ("Error: Problem converting input character to integer.");
                        return;
                  end;
                  if Int in Input_Number'Range then
                     A.Contents (I) := Int;
                  else
                     Put_Line ("Error: Invalid input character.");
                  end if;
               end loop;
               if Length (Input_Arrays) < Input_Arrays.Capacity then
                  Append (Input_Arrays, A);
               else
                  Put_Line ("Error: Too many lines in input.");
                  return;
               end if;
            end;
         else
            Put_Line ("Error: Input line was too long.");
            return;
         end if;
      end if;
   end loop;

   ------------------------
   ------ COMPUTATION -----
   ------------------------

   for E of Input_Arrays loop
      declare
         Val1 : Integer;
         Val2 : Long_Integer;
      begin
         Val1 := Max_Joltage_1 (E);
         if Count1 < Integer'Last - Val1 then
            Count1 := Count1 + Val1;
         else
            Put_Line ("Error: Count1 would have overflowed.");
            return;
         end if;

         if E.Length >= 12 then
            Val2 := Max_Joltage_2 (E, 12);
         else
            Put_Line ("Error: Input line shorter than 12 digits.");
            return;
         end if;
         if Count2 < Long_Integer'Last - Val2 then
            Count2 := Count2 + Val2;
         else
            Put_Line ("Error: Count2 would have overflowed.");
            return;
         end if;
      end;
   end loop;

   Put_Line ("The total for part 1 is: " & Count1'Image);
   Put_Line ("The total for part 2 is: " & Count2'Image);

end Day03spark;
