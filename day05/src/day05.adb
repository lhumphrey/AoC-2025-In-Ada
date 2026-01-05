with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with GNAT.Regpat; use GNAT.Regpat;
with SPARK.Containers.Formal.Vectors;
with Ada.Containers; use Ada.Containers;
with Helpers; use Helpers;

with Ada.Strings.Fixed;
with Ada.Strings;

use Ada.Strings;

procedure Day05 is

   use Id_Range_Vectors;

   package Long_Integer_Vectors is new
     SPARK.Containers.Formal.Vectors (Positive, Long_Integer);
   use Long_Integer_Vectors;

   Filename : constant String := "input.txt";
   File : File_Type;
   S : String (1 .. 64) with Relaxed_Initialization;
   Idx, Last_Idx, Dummy_Idx : Natural;

   Range_Matcher : constant Pattern_Matcher := Compile ("(\d+)-(\d+)");
   Range_Matches : Match_Array (0 .. 2);
   Id_Ranges : Id_Range_Vectors.Vector (256);
   Ids : Long_Integer_Vectors.Vector (1024);
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
      Get_Line (File, S, Last_Idx);
      Match (Range_Matcher, S (1 .. Last_Idx), Range_Matches);
      if Range_Matches (1) = No_Match or else Range_Matches (2) = No_Match then
         exit;
      else
         Append (Id_Ranges,
                 Id_Range'(
                  Long_Integer'Value(S (Range_Matches (1).First .. Range_Matches (1).Last)),
                  Long_Integer'Value(S (Range_Matches (2).First .. Range_Matches (2).Last))));
      end if;
   end loop;

   while not End_Of_File(File) loop
      Get_Line (File, S, Last_Idx);
      Append (Ids, Long_Integer'Value (S (1 .. Last_Idx)));
   end loop;

   for E of Ids loop
      if In_A_Fresh_Range (Id_Ranges, E) then
         Count1 := Count1 + 1;
      end if;
   end loop;

   Make_Fresh_Ranges_Non_Overlapping (Id_Ranges);

   for Interval of Id_Ranges loop
      -- Put_Line (Ada.Strings.Fixed.Trim (Interval (1)'Image, Both) & "-" & Ada.Strings.Fixed.Trim (Interval (2)'Image, Both));
      Count2 := Count2 + Interval (2) - Interval (1) + 1;
   end loop;

   Put_Line ("The total for part 1 is : " & Count1'Image);
   Put_Line ("The total for part 2 is : " & Count2'Image);

end Day05;
