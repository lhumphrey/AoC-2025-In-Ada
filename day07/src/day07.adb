with Ada.Text_IO; use Ada.Text_IO;

procedure Day07 is

   Filename : constant String := "input.txt";
   File : File_Type;
   Input_Lines : array (1 .. 256) of String (1 .. 256);
   Num_Lines, Num_Locs : Natural := 0;
   Last_Idx : Natural;
   Beam_Counts : array (1 .. 256) of Long_Integer := [others => 0];
   New_Beam_Counts : array (1 .. 256) of Long_Integer;

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
      Num_Lines := Num_Lines + 1;
      Get_Line (File, Input_Lines (Num_Lines), Last_Idx);
      if Num_Locs < Last_Idx then
         Num_Locs := Last_Idx;
      end if;
   end loop;

   for I in 1 .. Num_Locs loop
      if Input_Lines (1) (I) = 'S' then
         Beam_Counts (I) := 1;
         exit;
      end if;
   end loop;

   ------------------------
   ----- COMPUTATION ------
   ------------------------
   for Line_Ind in 2 .. Num_Lines loop
      New_Beam_Counts := [others => 0];
      for Loc in 1 .. Num_Locs loop
         if Beam_Counts (Loc) > 0 and then Input_Lines (Line_Ind) (Loc) = '^' then
            Count1 := Count1 + 1;
            New_Beam_Counts (Loc - 1) := New_Beam_Counts (Loc - 1) + Beam_Counts (Loc);
            New_Beam_Counts (Loc + 1) := New_Beam_Counts (Loc + 1) + Beam_Counts (Loc);
         else
            New_Beam_Counts (Loc) := New_Beam_Counts (Loc) + Beam_Counts (Loc);
         end if;
      end loop;
      for I in 1 .. Num_Locs loop
         Beam_Counts (I) := New_Beam_Counts (I);
      end loop;
   end loop;

   for I in 1 .. Num_Locs loop
      Count2 := Count2 + Beam_Counts (I);
   end loop;

   Put_Line ("The total for part 1 is: " & Count1'Image);
   Put_Line ("The total for part 2 is: " & Count2'Image);

end Day07;
