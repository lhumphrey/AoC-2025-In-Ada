package Helpers with SPARK_Mode is

   subtype Roll_Array_Index_Extended is Natural range 0 .. 256;
   subtype Roll_Array_Index is Positive range 1 .. 256;

   type Roll_Array is array (Roll_Array_Index, Roll_Array_Index) of Boolean;

   function Num_Adjacent_Rolls (RA : Roll_Array; Row, Col : Roll_Array_Index) return Integer;

end Helpers;