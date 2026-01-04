with Ada.Text_IO; use Ada.Text_IO;
with Helpers; use Helpers;

procedure Day04spark with SPARK_Mode is

   Filename : constant String := "input.txt";
   File : File_Type;
   S : String (1 .. 256) with Relaxed_Initialization;
   Last_Idx, Dummy_Idx : Natural;
   Input_Arr : Roll_Array := (others => (others => False));
   Input_Arr_Copy : Roll_Array;
   Num_Cols, Num_Rows : Roll_Array_Index_Extended := 0;
   Grid_Changed : Boolean;
   Count1, Count2 : Integer := 0;

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

      if Last_Idx >= 1 and then
         Last_Idx <= Roll_Array_Index'Last and then
         Num_Cols < Roll_Array_Index_Extended'Last and then
         Num_Rows < Roll_Array_Index_Extended'Last 
      then
         Num_Cols := Last_Idx;
         Num_Rows := Num_Rows + 1;
         for I in 1 .. Num_Cols loop
            Input_Arr (Num_Rows, I) := (if S (I) = '@' then True else False);
         end loop;
      else
         Put_Line ("Error: Problem with input format.");
         return;
      end if;
   end loop;

   ------------------------
   ------ COMPUTATION -----
   ------------------------
   for I in 1 .. Num_Rows loop
      pragma Loop_Invariant (Count1 <= Num_Cols * (I - 1));
      for J in 1 .. Num_Cols loop
         if Input_Arr (I, J) and then Num_Adjacent_Rolls (Input_Arr, I, J) < 4 then
            Count1 := Count1 + 1;
         end if;
         pragma Loop_Invariant (Count1 <= Count1'Loop_Entry + J);
      end loop;
   end loop;

   Input_Arr_Copy := Input_Arr;
   Grid_Changed := True;
   while Grid_Changed loop
      Input_Arr := Input_Arr_Copy;
      Grid_Changed := False;
      for I in 1 .. Num_Rows loop
         for J in 1 .. Num_Cols loop
            if Input_Arr (I, J) and Num_Adjacent_Rolls (Input_Arr, I, J) < 4 then
               Input_Arr_Copy (I, J) := False;
               Grid_Changed := True;
               if Count2 < Integer'Last then
                  Count2 := Count2 + 1;
               else
                  Put_Line ("Error: Count2 would have overflowed.");
                  return;
               end if;
            end if;
         end loop;
      end loop;
   end loop;

   Put_Line ("The total for part 1 is: " & Count1'Image);
   Put_Line ("The total for part 2 is: " & Count2'Image);

end Day04spark;