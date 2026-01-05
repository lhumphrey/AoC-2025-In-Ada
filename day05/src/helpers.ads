with SPARK.Containers.Formal.Vectors;

package Helpers with SPARK_Mode is

   type Id_Range is array (1 .. 2) of Long_Integer;

   package Id_Range_Vectors is new
     SPARK.Containers.Formal.Vectors (Positive, Id_Range);
   use Id_Range_Vectors;

   function In_A_Fresh_Range
      (Fresh_Ranges : Id_Range_Vectors.Vector;
       Val : Long_Integer) return Boolean;

   procedure Get_Non_Overlapping_Next_Ranges
      (Base_Range, Next_Range : Id_Range;
       Partitioned_Ranges : in out Id_Range_Vectors.Vector)
   with Pre => Is_Empty (Partitioned_Ranges);

   procedure Make_Fresh_Ranges_Non_Overlapping
        (Fresh_Ranges : in out Id_Range_Vectors.Vector);

end Helpers;