with Ada.Text_IO; use Ada.Text_IO;

package Helpers with SPARK_Mode is

subtype Long_Positive is Long_Integer range 1 .. Long_Integer'Last;

type Id_Range is record
      Low : Long_Positive := 1;
      High : Long_Positive := 2;
   end record;

function Is_Invalid_1 (X : Long_Positive) return Boolean;

function Is_Invalid_2 (X : Long_Positive) return Boolean;

end Helpers;