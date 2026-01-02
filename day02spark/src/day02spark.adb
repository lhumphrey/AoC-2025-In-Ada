with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Strings; use Ada.Strings;
with Ada.Integer_Text_IO;
with GNAT.Regpat; use GNAT.Regpat;
with SPARK.Containers.Formal.Vectors;
with Ada.Containers; use Ada.Containers;
with Helpers; use Helpers;

procedure Day02spark with SPARK_Mode, Always_Terminates => False is
   
   package Id_Range_Vectors is new
     SPARK.Containers.Formal.Vectors (Positive, Id_Range);
   use Id_Range_Vectors;

   package Long_Integer_IO is new 
      Ada.Text_IO.Integer_IO (Long_Integer);

   Filename : constant String := "input.txt";
   File : File_Type;
   S : String (1 .. 512) with Relaxed_Initialization;
   Idx, Last_Idx, Dummy_Idx : Natural;
   LB, UB : Long_Positive := 1;
   LI : Long_Integer;
   Id_Ranges : Id_Range_Vectors.Vector (50);
   Range_Matcher : Pattern_Matcher := Compile("(\d+)-(\d+)");
   Range_Matches : Match_Array (0 .. 2);
   Count1, Count2 : Long_Integer := 0;

begin

   ------------------------
   --- INPUT PROCESSING ---
   ------------------------

   begin
      Open (File, In_File, Filename);
      Get_Line (File, S, Last_Idx);
   exception
      when others =>
         Put_Line ("Error: Problem reading from file.");
         return;
   end;

   pragma Assert (S (1 .. Last_Idx)'Initialized);

   Idx := 1;
   while Last_Idx in 1 .. S'Last and then Idx in 1 .. Last_Idx - 1 loop
      pragma Loop_Invariant (S (1 .. Last_Idx)'Initialized);
      pragma Loop_Invariant (S (Idx .. Last_Idx)'Initialized);
      Match (Range_Matcher, S (Idx .. Last_Idx), Range_Matches);
      if Range_Matches (1) /= No_Match and then Range_Matches (2) /= No_Match
         and then Range_Matches (1).First in Idx .. Last_Idx
         and then Range_Matches (1).Last in Idx .. Last_Idx
         and then Range_Matches (1).First <= Range_Matches (1).Last
         and then Range_Matches (2).First in Idx .. Last_Idx
         and then Range_Matches (2).Last in Idx .. Last_Idx
         and then Range_Matches (2).First <= Range_Matches (2).Last
      then
         begin
            Long_Integer_IO.Get(S (Range_Matches(1).First .. Range_Matches(1).Last), LI, Dummy_Idx);
         exception
            when others =>
               Put_Line ("Error: Problem converting first input value in pair.");
               return;
         end;
         if LI >= 1 then
            LB := LI;
         else
            Put_Line ("Error: First input value in pair must be positive.");
         end if;

         begin
            Long_Integer_IO.Get(S (Range_Matches(2).First .. Range_Matches(2).Last), LI, Dummy_Idx);
         exception
            when others =>
               Put_Line ("Error: Problem converting second input value in pair.");
               return;
         end;
         if LI >= 1 then
            UB := LI;
         else
            Put_Line ("Error: Second input value in pair must be positive.");
         end if;

         if Length(Id_Ranges) < Id_Ranges.Capacity then
               Append(Id_Ranges, Id_Range'(LB, UB));
         else
            Put_Line ("Error: Too many input values.");
         end if;
      end if;

      if Range_Matches(0).Last <= S'Last then
         Idx := Range_Matches(0).Last + 1;
      else
         Put_Line ("Error: Invalid match index.");
         return;
      end if;

   end loop;

   ------------------------
   ------ COMPUTATION -----
   ------------------------

   for E of Id_Ranges loop
      for X in E.Low .. E.High loop
         if Is_Invalid_1 (X) then
            if Count1 < Long_Integer'Last - X then
               Count1 := Count1 + X;
            else
               Put_Line ("Error: Total for part 1 would have overflowed.");
               return;
            end if;
         end if;

         if Is_Invalid_2 (X) then
            if Count2 < Long_Integer'Last - X then
               Count2 := Count2 + X;
            else
               Put_Line ("Error: Total for part 2 would have overflowed.");
               return;
            end if;
         end if;
      end loop;
   end loop;

   Put_Line ("The total for part 1 is: " & Count1'Image);
   Put_Line ("The total for part 2 is: " & Count2'Image);
   
end Day02spark;
