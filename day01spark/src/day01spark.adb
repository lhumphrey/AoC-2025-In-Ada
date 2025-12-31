with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Day01spark with SPARK_Mode, Always_Terminates => False is

   subtype Rotation_Amount is Integer range 1 .. 1000;
   subtype Dial_Position is Integer range 0 .. 99;

   Filename : constant String := "input.txt";
   File : File_Type;
   S : String (1 .. 32) with Relaxed_Initialization;
   Idx, Last_Idx : Natural;
   Num : Integer;
   Dist : Rotation_Amount;
   Remainder : Integer;
   Position1, Position2 : Dial_Position := 50;
   Count1, Count2 : Integer := 0;

begin

   begin
      Open (File, In_File, Filename);
   exception
      when others =>
         Put_Line ("Error: Could not open file.");
         return;
   end;

   while not End_Of_File (File) loop
      begin
         Get_Line (File, S, Last_Idx);
      exception
         when others =>
            Put_Line ("Error: Could not read line from file.");
            return;
      end;

      if Last_Idx > 1 then
         pragma Assert (S (1)'Initialized);
         pragma Assert (S (2 .. Last_Idx)'Initialized);
         begin
            Ada.Integer_Text_IO.Get (S (2 .. Last_Idx), Num, Idx);
         exception
            when others =>
               Put_Line ("Error: Could not convert string input to number.");
               return;
         end;
         if Num not in Rotation_Amount'Range then
            Put_Line ("Error: Input number greater than expected.");
            return;
         end if;
         Dist := Num;

         -- Part 1
         if S (1) = 'R' then
            Position1 := (Position1 + Dist) mod 100;
         else
            Position1 := (Position1 - Dist) mod 100;
         end if;
         if Position1 = 0 then
            if Count1 < Integer'Last then
               Count1 := Count1 + 1;
            else
               Put_Line ("Error: Count1 would have overflowed");
               return;
            end if;
         end if;

         -- Part 2
         if Count2 < Integer'Last - Dist then
            Count2 := Count2 + Dist / 100;
         else
            Put_Line ("Error: Count2 would have overflowed");
            return;
         end if;
         Remainder := Dist mod 100;
         if S (1) = 'R' then
            if Position2 + Remainder >= 100 then
               if Count2 < Integer'Last then
                  Count2 := Count2 + 1;
               else
                  Put_Line ("Error: Count2 would have overflowed");
                  return;
               end if;
            end if;
            Position2 := (Position2 + Dist) mod 100;
         else
            if Position2 /= 0 and then Position2 - Remainder <= 0 then
               if Count2 < Integer'Last then
                  Count2 := Count2 + 1;
               else
                  Put_Line ("Error: Count2 would have overflowed");
                  return;
               end if;
            end if;
            Position2 := (Position2 - Dist) mod 100;
         end if;
      end if;
   end loop;

   Close (File);
   Put_Line ("The count for Part 1 is: " & Count1'Image);
   Put_Line ("The count for Part 2 is: " & Count2'Image);

end Day01spark;