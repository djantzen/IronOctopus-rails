class AlterNumericMeasurementsToRange < ActiveRecord::Migration

  def self.up
    execute <<-OES
      alter table application.measurements alter column cadence drop default;
      alter table application.measurements alter column calories drop default;
      alter table application.measurements alter column distance drop default;
      alter table application.measurements alter column duration drop default;
      alter table application.measurements alter column incline drop default;
      alter table application.measurements alter column level drop default;
      alter table application.measurements alter column repetitions drop default;
      alter table application.measurements alter column resistance drop default;
      alter table application.measurements alter column speed drop default;
      alter table application.measurements alter column heart_rate drop default;

      alter table application.measurements drop constraint measurements_cadence_check;
      alter table application.measurements drop constraint measurements_calories_check;
      alter table application.measurements drop constraint measurements_distance_check;
      alter table application.measurements drop constraint measurements_duration_check;
      alter table application.measurements drop constraint measurements_incline_check;
      alter table application.measurements drop constraint measurements_level_check;
      alter table application.measurements drop constraint measurements_repetitions_check;
      alter table application.measurements drop constraint measurements_resistance_check;
      alter table application.measurements drop constraint measurements_speed_check;
      alter table application.measurements drop constraint measurements_heart_rate_check;

      alter table application.measurements alter column cadence type numrange using(numrange('['||cadence||','||cadence||']'));
      alter table application.measurements alter column calories type int4range using(int4range('['||calories||','||calories||']'));
      alter table application.measurements alter column distance type numrange using(numrange('['||distance||','||distance||']'));
      alter table application.measurements alter column duration type int4range using(int4range('['||duration||','||duration||']'));
      alter table application.measurements alter column incline type numrange using(numrange('['||incline||','||incline||']'));
      alter table application.measurements alter column level type int4range using(int4range('['||level||','||level||']'));
      alter table application.measurements alter column repetitions type int4range using(int4range('['||repetitions||','||repetitions||']'));
      alter table application.measurements alter column resistance type numrange using(numrange('['||resistance||','||resistance||']'));
      alter table application.measurements alter column speed type numrange using(numrange('['||speed||','||speed||']'));
      alter table application.measurements alter column heart_rate type int4range using(int4range('['||heart_rate||','||heart_rate||']'));

      alter table application.measurements alter column cadence set default numrange('[0,0]');
      alter table application.measurements alter column calories set default int4range('[0,0]');
      alter table application.measurements alter column distance set default numrange('[0,0]');
      alter table application.measurements alter column duration set default int4range('[0,0]');
      alter table application.measurements alter column incline set default numrange('[0,0]');
      alter table application.measurements alter column level set default int4range('[0,0]');
      alter table application.measurements alter column repetitions set default int4range('[0,0]');
      alter table application.measurements alter column resistance set default numrange('[0,0]');
      alter table application.measurements alter column speed set default numrange('[0,0]');
      alter table application.measurements alter column heart_rate set default int4range('[0,0]');

      alter table application.measurements add check(numrange('[0,200]') @> cadence);
      alter table application.measurements add check(int4range('[0,5000]') @> calories);
      alter table application.measurements add check(numrange('[0,42000]') @> distance);
      alter table application.measurements add check(int4range('[0,86000]') @> duration);
      alter table application.measurements add check(numrange('[0,20]') @> incline);
      alter table application.measurements add check(int4range('[0,20]') @> level);
      alter table application.measurements add check(int4range('[0,500]') @> repetitions);
      alter table application.measurements add check(numrange('[0,500]') @> resistance);
      alter table application.measurements add check(numrange('[0,100]') @> speed);
      alter table application.measurements add check(int4range('[0,200]') @> heart_rate);

    OES
  end

  def self.down
    execute <<-OES
      alter table application.measurements alter column cadence drop default;
      alter table application.measurements alter column calories drop default;
      alter table application.measurements alter column distance drop default;
      alter table application.measurements alter column duration drop default;
      alter table application.measurements alter column incline drop default;
      alter table application.measurements alter column level drop default;
      alter table application.measurements alter column repetitions drop default;
      alter table application.measurements alter column speed drop default;
      alter table application.measurements alter column heart_rate drop default;

      alter table application.measurements drop constraint measurements_cadence_check;
      alter table application.measurements drop constraint measurements_calories_check;
      alter table application.measurements drop constraint measurements_distance_check;
      alter table application.measurements drop constraint measurements_duration_check;
      alter table application.measurements drop constraint measurements_incline_check;
      alter table application.measurements drop constraint measurements_level_check;
      alter table application.measurements drop constraint measurements_repetitions_check;
      alter table application.measurements drop constraint measurements_resistance_check;
      alter table application.measurements drop constraint measurements_speed_check;
      alter table application.measurements drop constraint measurements_heart_rate_check;

      alter table application.measurements alter column cadence type numeric using(lower(cadence));
      alter table application.measurements alter column calories type integer using(lower(calories));
      alter table application.measurements alter column distance type numeric using(lower(distance));
      alter table application.measurements alter column duration type integer using(lower(duration));
      alter table application.measurements alter column incline type numeric using(lower(incline));
      alter table application.measurements alter column level type integer using(lower(level));
      alter table application.measurements alter column repetitions type integer using(lower(repetitions));
      alter table application.measurements alter column speed type numeric using(lower(numeric));
      alter table application.measurements alter column heart_rate type integer using(lower(heart_rate));

      alter table application.measurements alter column cadence set default 0;
      alter table application.measurements alter column calories set default 0;
      alter table application.measurements alter column distance set default 0;
      alter table application.measurements alter column duration set default 0;
      alter table application.measurements alter column incline set default 0;
      alter table application.measurements alter column level set default 0;
      alter table application.measurements alter column repetitions set default 0;
      alter table application.measurements alter column speed set default 0;
      alter table application.measurements alter column heart_rate set default 0;

      alter table application.measurements add check(cadence between 0 and 200);
      alter table application.measurements add check(calories between 0 and 5000);
      alter table application.measurements add check(distance between 0 and 4200);
      alter table application.measurements add check(duration between 0 and 8600);
      alter table application.measurements add check(incline between 0 and 20);
      alter table application.measurements add check(level between 0 and 20);
      alter table application.measurements add check(repetitions between 0 and 1000);
      alter table application.measurements add check(resistance between 0 and 500);
      alter table application.measurements add check(speed between 0 and 100);
      alter table application.measurements add check(heart_rate between 0 and 200);
    OES
  end
end
