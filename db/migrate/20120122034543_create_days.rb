class CreateDays < ActiveRecord::Migration

  def self.up
    execute <<-OES
      create table reporting.days (
        day_id integer primary key not null default replace(now()::date::varchar, '-', '')::integer,
        full_date date not null default now()::date,
        year integer not null default date_part('year', now()),
        month integer not null default date_part('month', now()),
        day integer not null default date_part('day', now()),
        created_at timestamptz default now()
      );

      create unique index days_idx_full_date on reporting.days (full_date);
      create unique index days_idx_year_month_day on reporting.days (day, month, year);

      grant select on reporting.days to reporter;
      grant insert, select on reporting.days to application;

      comment on table reporting.days is 'A dimension for date-based reporting.';
    OES
  end
  
  def self.down
    execute <<-OES
      drop table reporting.days;
    OES
  end
  
  
end
