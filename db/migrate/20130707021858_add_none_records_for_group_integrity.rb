class AddNoneRecordsForGroupIntegrity < ActiveRecord::Migration
  def up

    unless Rails.env =~ /test/
      execute <<-EOS
        insert into application.states (state_id, name, abbr, the_geom)
          values (0, 'None', 'none', (select ST_GeomFromText('POINT(0 0)')));

        insert into application.cities (city_id, state_id, name, the_geom)
          values (0, 0, 'None', (select ST_GeomFromText('POINT(0 0)')));

        insert into application.users (user_id, login, first_name, last_name, email, city_id, password_digest)
          values (0, 'None', 'None', 'None', 'noone@ironoctop.us', 0,
                  '$2a$10$YZ2.QsL4Bn7TX0VsRKxvMeAyIbsnCdeYjYKi2bYg2jJmAnWqAxcD6');

        insert into application.routines (routine_id, name, permalink, client_id, trainer_id)
          values (0, 'None', 'none', 0, 0);

        insert into application.activity_set_groups (activity_set_group_id, routine_id, name)
          values (0, 0, 'None');

      EOS
    end
  end

  def down
    unless Rails.env =~ /test/
      execute <<-OES
        delete from application.activity_set_groups where activity_set_group_id = 0;
        delete from application.routines where routine_id = 0;
        delete from application.users where user_id = 0;
        delete from application.cities where city_id = 0;
        delete from application.states where state_id = 0;
      OES
    end
  end
end
