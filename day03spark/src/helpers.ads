with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

package Helpers with SPARK_Mode is

   subtype Input_Number is Integer range 0 .. 9;

   subtype Input_Array_Index is Positive range 1 .. 128;

   type Digit_Array is array (Input_Array_Index) of Input_Number;

   subtype Joltage_Digit is Positive range 1 .. 12;

   type Input_Array is record
      Contents : Digit_Array := [others => 0];
      Length : Input_Array_Index;
   end record;

   function Max_Joltage_1 (Arr : Input_Array) return Integer
      with Post => Max_Joltage_1'Result >= 0;

   function Max_Joltage_2 (Arr : Input_Array; Digits_To_Go : Joltage_Digit) return Long_Integer with
      Pre =>
         Digits_To_Go >= 1 and then
         Arr.Length >= Digits_To_Go,
      Post =>
         Max_Joltage_2'Result >= 0 and then
         Max_Joltage_2'Result <= 10 ** Digits_To_Go,
      Subprogram_Variant => (Decreases => Digits_To_Go);

   procedure Power_Inequality (X, Y : Natural) with
      Ghost,
      Pre  => X <= Y and then X <= 12 and then Y <= 12,
      Post => To_Big_Integer (10) ** X <= To_Big_Integer (10) ** Y;

end Helpers;