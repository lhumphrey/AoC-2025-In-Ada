with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Vectors;

procedure Day06 is

   type Math_Operator is (Add, Mult);

   package Math_Operator_Vectors is new
     Ada.Containers.Vectors (Positive, Math_Operator);
   use Math_Operator_Vectors;

   package Integer_Vectors is new
     Ada.Containers.Vectors (Positive, Integer);
   use Integer_Vectors;

   Filename : constant String := "input.txt";
   File : File_Type;
   S : String (1 .. 4096) with Relaxed_Initialization;
   Input_Strings : array (1 .. 10) of String (1 .. 4096) := [others => [others => ' ']];
   Last_Idx : Natural;
   Line_Idx, Num_Lines : Natural := 0;
   Ops : Math_Operator_Vectors.Vector;
   Token_Start_Positions, Token_End_Positions : Integer_Vectors.Vector;
   Count1, Count2 : Long_Integer := 0;

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
      Get_Line (File, S, Last_Idx);
      Num_Lines := Num_Lines + 1;
      if Last_Idx > Line_Idx then
         Line_Idx := Last_Idx;
      end if;
      Input_Strings (Num_Lines) (1 .. Last_Idx) := S (1 .. Last_Idx);
   end loop;

   for I in 1 .. Last_Idx loop
      if Input_Strings (Num_Lines) (I) = '*' or else
         Input_Strings (Num_Lines) (I) = '+'
      then
         Token_Start_Positions.Append (I);
         Ops.Append ((if Input_Strings (Num_Lines) (I) = '*' then Mult else Add));
      end if;
   end loop;

   for I in 2 .. Integer (Length (Token_Start_Positions)) loop
      Token_End_Positions.Append (Token_Start_Positions.Element (I) - 2);
   end loop;
   Token_End_Positions.Append (Line_Idx);

   ------------------------
   ----- COMPUTATION ------
   ------------------------

   for Col in 1 .. Integer (Length (Ops)) loop
      declare
         Ind1 : constant Integer := Token_Start_Positions.Element (Col);
         Ind2 : constant Integer := Token_End_Positions.Element (Col);
         Num : Integer;
         Total : Long_Integer;
      begin
         Total := (if Ops.Element (Col) = Mult then 1 else 0);
         for Row in 1 .. Num_Lines - 1 loop
            Ada.Integer_Text_IO.Get (Input_Strings (Row) (Ind1 .. Ind2), Num, Last_Idx);
            if Ops.Element (Col) = Mult then
               Total := Total * Long_Integer (Num);
            else
               Total := Total + Long_Integer (Num);
            end if;
         end loop;
         Count1 := Count1 + Total;
      end;
   end loop;

   for Col in 1 .. Integer (Length (Ops)) loop
      declare
         Ind1 : constant Integer := Token_Start_Positions.Element (Col);
         Ind2 : constant Integer := Token_End_Positions.Element (Col);
         Num_Str : String (1 .. Num_Lines - 1) := [others => ' '];
         Num : Integer;
         Total : Long_Integer;
      begin
         Total := (if Ops.Element (Col) = Mult then 1 else 0);
         for Sub_Col in Ind1 .. Ind2 loop
            for Row in 1 .. Num_Lines - 1 loop
               Num_Str (Row) := Input_Strings (Row) (Sub_Col);
            end loop;
            Ada.Integer_Text_IO.Get (Num_Str, Num, Last_Idx);
            if Ops.Element (Col) = Mult then
               Total := Total * Long_Integer (Num);
            else
               Total := Total + Long_Integer (Num);
            end if;
         end loop;
         Count2 := Count2 + Total;
      end;
   end loop;

   Put_Line ("The total for part 1 is: " & Count1'Image);
   Put_Line ("The total for part 2 is: " & Count2'Image);

end Day06;
