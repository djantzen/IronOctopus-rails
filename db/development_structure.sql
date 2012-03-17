--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: application; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA application;


--
-- Name: SCHEMA application; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA application IS 'Reporting and analysis schema.';


--
-- Name: reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reporting;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = application, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: activities; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activities (
    activity_id integer NOT NULL,
    name text NOT NULL,
    activity_type_id integer NOT NULL,
    creator_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activities; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activities IS 'All activities or exercises available in the system e.g. ''Bench Press''';


--
-- Name: activities_activity_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE activities_activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activities_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE activities_activity_id_seq OWNED BY activities.activity_id;


--
-- Name: activity_sets; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activity_sets (
    routine_id integer NOT NULL,
    activity_id integer NOT NULL,
    measurement_id integer NOT NULL,
    "position" real DEFAULT 1 NOT NULL,
    optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE activity_sets; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activity_sets IS 'Maps routines, activities and activity sets to a user.';


--
-- Name: COLUMN activity_sets."position"; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN activity_sets."position" IS 'Represents a numeric position within a hierarchy similar to outline numbering.';


--
-- Name: activity_types; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activity_types (
    activity_type_id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: TABLE activity_types; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activity_types IS 'Organizes activities into categories like ''Cardiovascular'', ''Weight Training'', ''Plyometrics''';


--
-- Name: activity_types_activity_type_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE activity_types_activity_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_types_activity_type_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE activity_types_activity_type_id_seq OWNED BY activity_types.activity_type_id;


--
-- Name: measurements; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE measurements (
    measurement_id integer NOT NULL,
    duration integer DEFAULT 0 NOT NULL,
    resistance real DEFAULT 0 NOT NULL,
    repetitions integer DEFAULT 1 NOT NULL,
    pace real DEFAULT 0 NOT NULL,
    distance real DEFAULT 0 NOT NULL,
    calories integer DEFAULT 0 NOT NULL,
    distance_unit_id integer DEFAULT 0 NOT NULL,
    resistance_unit_id integer DEFAULT 0 NOT NULL,
    pace_unit_id integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE measurements; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE measurements IS 'Measures associated with a set or work record.';


--
-- Name: COLUMN measurements.duration; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN measurements.duration IS 'In seconds.';


--
-- Name: measurements_measurement_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE measurements_measurement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurements_measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE measurements_measurement_id_seq OWNED BY measurements.measurement_id;


--
-- Name: routines; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE routines (
    routine_id integer NOT NULL,
    name text DEFAULT 'Routine'::text NOT NULL,
    owner_id integer NOT NULL,
    creator_id integer NOT NULL,
    goal text DEFAULT 'None'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE routines; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE routines IS 'A grouping of activity sets that may be assigned to a user.';


--
-- Name: routines_routine_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE routines_routine_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: routines_routine_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE routines_routine_id_seq OWNED BY routines.routine_id;


--
-- Name: units; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE units (
    unit_id integer NOT NULL,
    name text NOT NULL,
    abbr text NOT NULL
);


--
-- Name: TABLE units; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE units IS 'Stores units of measure for modifying numeric values, e.g. ''Pound'', ''Kilogram'', ''Sock''';


--
-- Name: units_unit_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE units_unit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: units_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE units_unit_id_seq OWNED BY units.unit_id;


--
-- Name: user_relationships; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE user_relationships (
    teacher_id integer NOT NULL,
    student_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE user_relationships; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE user_relationships IS 'A table to construct the graph of user relationships';


--
-- Name: users; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE users (
    user_id integer NOT NULL,
    login text NOT NULL,
    email text NOT NULL,
    password_digest text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE users; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE users IS 'All users in the systems.';


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE users_user_id_seq OWNED BY users.user_id;


SET search_path = public, pg_catalog;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


SET search_path = reporting, pg_catalog;

--
-- Name: days; Type: TABLE; Schema: reporting; Owner: -; Tablespace: 
--

CREATE TABLE days (
    day_id integer DEFAULT (replace((((now())::date)::character varying)::text, '-'::text, ''::text))::integer NOT NULL,
    full_date date DEFAULT (now())::date NOT NULL,
    year integer DEFAULT date_part('year'::text, now()) NOT NULL,
    month integer DEFAULT date_part('month'::text, now()) NOT NULL,
    day integer DEFAULT date_part('day'::text, now()) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE days; Type: COMMENT; Schema: reporting; Owner: -
--

COMMENT ON TABLE days IS 'A dimension for date-based reporting.';


--
-- Name: work; Type: TABLE; Schema: reporting; Owner: -; Tablespace: 
--

CREATE TABLE work (
    user_id integer NOT NULL,
    routine_id integer NOT NULL,
    activity_id integer NOT NULL,
    measurement_id integer NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    start_day_id integer NOT NULL
);


--
-- Name: TABLE work; Type: COMMENT; Schema: reporting; Owner: -
--

COMMENT ON TABLE work IS 'A running log of metrics achieved during the performance of activities.';


SET search_path = application, pg_catalog;

--
-- Name: activity_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE activities ALTER COLUMN activity_id SET DEFAULT nextval('activities_activity_id_seq'::regclass);


--
-- Name: activity_type_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE activity_types ALTER COLUMN activity_type_id SET DEFAULT nextval('activity_types_activity_type_id_seq'::regclass);


--
-- Name: measurement_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE measurements ALTER COLUMN measurement_id SET DEFAULT nextval('measurements_measurement_id_seq'::regclass);


--
-- Name: routine_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE routines ALTER COLUMN routine_id SET DEFAULT nextval('routines_routine_id_seq'::regclass);


--
-- Name: unit_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE units ALTER COLUMN unit_id SET DEFAULT nextval('units_unit_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE users ALTER COLUMN user_id SET DEFAULT nextval('users_user_id_seq'::regclass);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (activity_id);


--
-- Name: activity_sets_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_pkey PRIMARY KEY (routine_id, activity_id, measurement_id, "position");


--
-- Name: activity_types_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_types
    ADD CONSTRAINT activity_types_pkey PRIMARY KEY (activity_type_id);


--
-- Name: measurements_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (measurement_id);


--
-- Name: routines_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY routines
    ADD CONSTRAINT routines_pkey PRIMARY KEY (routine_id);


--
-- Name: units_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_pkey PRIMARY KEY (unit_id);


--
-- Name: user_relationships_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_pkey PRIMARY KEY (teacher_id, student_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


SET search_path = reporting, pg_catalog;

--
-- Name: days_pkey; Type: CONSTRAINT; Schema: reporting; Owner: -; Tablespace: 
--

ALTER TABLE ONLY days
    ADD CONSTRAINT days_pkey PRIMARY KEY (day_id);


--
-- Name: work_pkey; Type: CONSTRAINT; Schema: reporting; Owner: -; Tablespace: 
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_pkey PRIMARY KEY (start_day_id, user_id, routine_id, activity_id, measurement_id, start_time, end_time);


SET search_path = application, pg_catalog;

--
-- Name: activities_uniq_idx_name; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX activities_uniq_idx_name ON activities USING btree (lower(name));


--
-- Name: activity_sets_uniq_idx_routine_id_position; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX activity_sets_uniq_idx_routine_id_position ON activity_sets USING btree (routine_id, "position");


--
-- Name: activity_types_uniq_idx_name; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX activity_types_uniq_idx_name ON activity_types USING btree (name);


--
-- Name: measurement_uniq_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX measurement_uniq_idx ON measurements USING btree (duration, resistance, repetitions, pace, distance, calories, distance_unit_id, resistance_unit_id, pace_unit_id);


--
-- Name: routines_uniq_idx_owner_name; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX routines_uniq_idx_owner_name ON routines USING btree (owner_id, lower(name));


--
-- Name: units_uniq_idx_name; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX units_uniq_idx_name ON units USING btree (lower(name));


--
-- Name: users_uniq_idx_email; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_uniq_idx_email ON users USING btree (lower(email));


--
-- Name: users_uniq_idx_login; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_uniq_idx_login ON users USING btree (lower(login));


SET search_path = public, pg_catalog;

--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


SET search_path = reporting, pg_catalog;

--
-- Name: days_idx_full_date; Type: INDEX; Schema: reporting; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX days_idx_full_date ON days USING btree (full_date);


--
-- Name: days_idx_year_month_day; Type: INDEX; Schema: reporting; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX days_idx_year_month_day ON days USING btree (day, month, year);


SET search_path = application, pg_catalog;

--
-- Name: activities_activity_type_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_activity_type_id_fkey FOREIGN KEY (activity_type_id) REFERENCES activity_types(activity_type_id);


--
-- Name: activities_creator_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(user_id);


--
-- Name: activity_sets_activity_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id);


--
-- Name: activity_sets_measurement_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_measurement_id_fkey FOREIGN KEY (measurement_id) REFERENCES measurements(measurement_id);


--
-- Name: activity_sets_routine_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES routines(routine_id);


--
-- Name: measurements_distance_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT measurements_distance_unit_id_fkey FOREIGN KEY (distance_unit_id) REFERENCES units(unit_id);


--
-- Name: measurements_pace_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT measurements_pace_unit_id_fkey FOREIGN KEY (pace_unit_id) REFERENCES units(unit_id);


--
-- Name: measurements_resistance_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT measurements_resistance_unit_id_fkey FOREIGN KEY (resistance_unit_id) REFERENCES units(unit_id);


--
-- Name: routines_creator_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY routines
    ADD CONSTRAINT routines_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(user_id);


--
-- Name: routines_owner_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY routines
    ADD CONSTRAINT routines_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES users(user_id);


--
-- Name: user_relationships_student_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_student_id_fkey FOREIGN KEY (student_id) REFERENCES users(user_id);


--
-- Name: user_relationships_teacher_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES users(user_id);


SET search_path = reporting, pg_catalog;

--
-- Name: work_activity_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES application.activities(activity_id);


--
-- Name: work_measurement_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_measurement_id_fkey FOREIGN KEY (measurement_id) REFERENCES application.measurements(measurement_id);


--
-- Name: work_routine_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES application.routines(routine_id);


--
-- Name: work_start_day_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_start_day_id_fkey FOREIGN KEY (start_day_id) REFERENCES days(day_id);


--
-- Name: work_user_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_user_id_fkey FOREIGN KEY (user_id) REFERENCES application.users(user_id);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120122034505');

INSERT INTO schema_migrations (version) VALUES ('20120122034507');

INSERT INTO schema_migrations (version) VALUES ('20120122034510');

INSERT INTO schema_migrations (version) VALUES ('20120122034515');

INSERT INTO schema_migrations (version) VALUES ('20120122034520');

INSERT INTO schema_migrations (version) VALUES ('20120122034525');

INSERT INTO schema_migrations (version) VALUES ('20120122034535');

INSERT INTO schema_migrations (version) VALUES ('20120122034540');

INSERT INTO schema_migrations (version) VALUES ('20120122034543');

INSERT INTO schema_migrations (version) VALUES ('20120122034545');

INSERT INTO schema_migrations (version) VALUES ('20120122034550');