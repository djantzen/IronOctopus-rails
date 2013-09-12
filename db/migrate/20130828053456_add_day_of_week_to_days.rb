class AddDayOfWeekToDays < ActiveRecord::Migration

  def self.up
    execute <<-OES
      alter table reporting.days add column day_of_week text not null default 'Sunday'
        check (day_of_week in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'));
      update days set day_of_week = case
         when extract(dow from full_date) = 0 then 'Sunday'
         when extract(dow from full_date) = 1 then 'Monday'
         when extract(dow from full_date) = 2 then 'Tuesday'
         when extract(dow from full_date) = 3 then 'Wednesday'
         when extract(dow from full_date) = 4 then 'Thursday'
         when extract(dow from full_date) = 5 then 'Friday'
         when extract(dow from full_date) = 6 then 'Saturday'
      end;
      create unique index on reporting.days (full_date, day_of_week);
      create index on application.weekday_programs (day_of_week);
    OES
  end

  def self.down
    execute <<-OES
      alter table reporting.days drop column day_of_week;
      drop index application.weekday_programs_day_of_week_idx;
    OES
  end

end
