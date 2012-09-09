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

COMMENT ON SCHEMA application IS 'Operational schema.';


--
-- Name: reporting; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA reporting;


--
-- Name: SCHEMA reporting; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA reporting IS 'Reporting and analysis schema.';


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
    instructions text DEFAULT 'None'::text NOT NULL,
    warnings text DEFAULT 'None'::text NOT NULL,
    activity_type_id integer NOT NULL,
    permalink text NOT NULL,
    creator_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activities; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activities IS 'All activities or exercises available in the system e.g. ''Bench Press''';


--
-- Name: activities_activity_attributes; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activities_activity_attributes (
    activity_id integer NOT NULL,
    activity_attribute_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activities_activity_attributes; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activities_activity_attributes IS 'A mapping table from activities to activity attributes';


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
-- Name: activities_body_parts; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activities_body_parts (
    activity_id integer NOT NULL,
    body_part_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activities_body_parts; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activities_body_parts IS 'A table mapping activities to body parts';


--
-- Name: activities_implements; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activities_implements (
    activity_id integer NOT NULL,
    implement_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activities_implements; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activities_implements IS 'A mapping table joining activities to implements.';


--
-- Name: activities_metrics; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activities_metrics (
    activity_id integer NOT NULL,
    metric_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activities_metrics; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activities_metrics IS 'Mapping table to associate metrics to activities.';


--
-- Name: activity_attributes; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activity_attributes (
    activity_attribute_id integer NOT NULL,
    name text NOT NULL,
    permalink text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE activity_attributes; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activity_attributes IS 'A table of user generated attributes';


--
-- Name: activity_attributes_activity_attribute_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE activity_attributes_activity_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_attributes_activity_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE activity_attributes_activity_attribute_id_seq OWNED BY activity_attributes.activity_attribute_id;


--
-- Name: activity_sets; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE activity_sets (
    routine_id integer NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    activity_id integer NOT NULL,
    measurement_id integer NOT NULL,
    cadence_unit_id integer NOT NULL,
    distance_unit_id integer NOT NULL,
    duration_unit_id integer NOT NULL,
    resistance_unit_id integer NOT NULL,
    speed_unit_id integer NOT NULL,
    optional boolean DEFAULT false NOT NULL,
    comments text DEFAULT ''::text NOT NULL
);


--
-- Name: TABLE activity_sets; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE activity_sets IS 'Maps routines, activities and activity sets to a user.';


--
-- Name: COLUMN activity_sets."position"; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN activity_sets."position" IS 'Represents a numeric position within a list.';


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

COMMENT ON TABLE activity_types IS 'Organizes activities into categories like ''Cardiovascular'', ''Resistance'', ''Plyometric''';


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
-- Name: body_parts; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE body_parts (
    body_part_id integer NOT NULL,
    name text NOT NULL,
    region text NOT NULL,
    permalink text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE body_parts; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE body_parts IS 'A reference table of basic human physiology.';


--
-- Name: body_parts_body_part_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE body_parts_body_part_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: body_parts_body_part_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE body_parts_body_part_id_seq OWNED BY body_parts.body_part_id;


--
-- Name: confirmations; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE confirmations (
    user_id integer NOT NULL,
    confirmation_uuid uuid NOT NULL,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE confirmations; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE confirmations IS 'A table storing confirmation email statuses.';


--
-- Name: devices; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE devices (
    device_id integer NOT NULL,
    device_uuid uuid NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE devices; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE devices IS 'A table of registered mobile devices';


--
-- Name: devices_device_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE devices_device_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: devices_device_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE devices_device_id_seq OWNED BY devices.device_id;


--
-- Name: feedback; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE feedback (
    feedback_id integer NOT NULL,
    user_id integer NOT NULL,
    remarks text NOT NULL,
    score integer DEFAULT 0 NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT feedback_score_check CHECK (((score >= (-5)) AND (score <= 5)))
);


--
-- Name: TABLE feedback; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE feedback IS 'A table of user generated feedback';


--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE feedback_feedback_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feedback_feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE feedback_feedback_id_seq OWNED BY feedback.feedback_id;


--
-- Name: implements; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE implements (
    implement_id integer NOT NULL,
    name text NOT NULL,
    category text DEFAULT 'None'::text NOT NULL,
    permalink text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE implements; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE implements IS 'An implement to be utilized in the performance of an activity.';


--
-- Name: implements_implement_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE implements_implement_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: implements_implement_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE implements_implement_id_seq OWNED BY implements.implement_id;


--
-- Name: invitations; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    invitation_id integer NOT NULL,
    invitation_uuid uuid NOT NULL,
    trainer_id integer NOT NULL,
    license_id integer NOT NULL,
    email_to text NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE invitations; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE invitations IS 'A table mapping licenses, trainers and email invitations.';


--
-- Name: invitations_invitation_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE invitations_invitation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_invitation_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE invitations_invitation_id_seq OWNED BY invitations.invitation_id;


--
-- Name: licenses; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE licenses (
    license_id integer NOT NULL,
    license_uuid uuid NOT NULL,
    trainer_id integer NOT NULL,
    client_id integer NOT NULL,
    status text DEFAULT 'new'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT licenses_status_check CHECK ((status = ANY (ARRAY['new'::text, 'pending'::text, 'assigned'::text])))
);


--
-- Name: TABLE licenses; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE licenses IS 'A table recording all seat licenses in the system';


--
-- Name: licenses_license_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE licenses_license_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licenses_license_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE licenses_license_id_seq OWNED BY licenses.license_id;


--
-- Name: measurements; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE measurements (
    measurement_id integer NOT NULL,
    cadence numeric DEFAULT 0 NOT NULL,
    calories integer DEFAULT 0 NOT NULL,
    distance numeric DEFAULT 0 NOT NULL,
    duration integer DEFAULT 0 NOT NULL,
    incline numeric DEFAULT 0 NOT NULL,
    level integer DEFAULT 0 NOT NULL,
    repetitions integer DEFAULT 0 NOT NULL,
    resistance numeric DEFAULT 0 NOT NULL,
    speed numeric DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT measurements_cadence_check CHECK (((cadence >= (0)::numeric) AND (cadence <= (200)::numeric))),
    CONSTRAINT measurements_calories_check CHECK (((calories >= 0) AND (calories <= 5000))),
    CONSTRAINT measurements_distance_check CHECK (((distance >= (0)::numeric) AND (distance <= (42000)::numeric))),
    CONSTRAINT measurements_duration_check CHECK (((duration >= 0) AND (duration <= 86400))),
    CONSTRAINT measurements_incline_check CHECK (((incline >= (0)::numeric) AND (incline <= (20)::numeric))),
    CONSTRAINT measurements_level_check CHECK (((level >= 0) AND (level <= 20))),
    CONSTRAINT measurements_repetitions_check CHECK (((repetitions >= 0) AND (repetitions <= 100))),
    CONSTRAINT measurements_resistance_check CHECK (((resistance >= (0)::numeric) AND (resistance <= (500)::numeric))),
    CONSTRAINT measurements_speed_check CHECK (((speed >= (0)::numeric) AND (speed <= (100)::numeric)))
);


--
-- Name: TABLE measurements; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE measurements IS 'Measures associated with a set or work record.';


--
-- Name: COLUMN measurements.distance; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN measurements.distance IS 'In meters';


--
-- Name: COLUMN measurements.duration; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN measurements.duration IS 'In seconds';


--
-- Name: COLUMN measurements.resistance; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN measurements.resistance IS 'In kilograms';


--
-- Name: COLUMN measurements.speed; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON COLUMN measurements.speed IS 'In kilometers per hour';


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
-- Name: metrics; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE metrics (
    metric_id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: TABLE metrics; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE metrics IS 'Measures such as resistance, duration associated with an activity set.';


--
-- Name: metrics_metric_id_seq; Type: SEQUENCE; Schema: application; Owner: -
--

CREATE SEQUENCE metrics_metric_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metrics_metric_id_seq; Type: SEQUENCE OWNED BY; Schema: application; Owner: -
--

ALTER SEQUENCE metrics_metric_id_seq OWNED BY metrics.metric_id;


--
-- Name: routines; Type: TABLE; Schema: application; Owner: -; Tablespace: 
--

CREATE TABLE routines (
    routine_id integer NOT NULL,
    name text NOT NULL,
    permalink text NOT NULL,
    trainer_id integer NOT NULL,
    client_id integer NOT NULL,
    has_been_sent boolean DEFAULT false NOT NULL,
    goal text DEFAULT 'Not specified'::text NOT NULL,
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
    abbr text NOT NULL,
    is_metric boolean DEFAULT false NOT NULL,
    metric_id integer NOT NULL
);


--
-- Name: TABLE units; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE units IS 'Units associated with an activity set.';


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
    trainer_id integer NOT NULL,
    client_id integer NOT NULL,
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
    first_name text NOT NULL,
    last_name text NOT NULL,
    email text NOT NULL,
    login text NOT NULL,
    password_digest text NOT NULL,
    identity_confirmed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: TABLE users; Type: COMMENT; Schema: application; Owner: -
--

COMMENT ON TABLE users IS 'All users in the system.';


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
-- Name: activity_attribute_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE activity_attributes ALTER COLUMN activity_attribute_id SET DEFAULT nextval('activity_attributes_activity_attribute_id_seq'::regclass);


--
-- Name: activity_type_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE activity_types ALTER COLUMN activity_type_id SET DEFAULT nextval('activity_types_activity_type_id_seq'::regclass);


--
-- Name: body_part_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE body_parts ALTER COLUMN body_part_id SET DEFAULT nextval('body_parts_body_part_id_seq'::regclass);


--
-- Name: device_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE devices ALTER COLUMN device_id SET DEFAULT nextval('devices_device_id_seq'::regclass);


--
-- Name: feedback_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE feedback ALTER COLUMN feedback_id SET DEFAULT nextval('feedback_feedback_id_seq'::regclass);


--
-- Name: implement_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE implements ALTER COLUMN implement_id SET DEFAULT nextval('implements_implement_id_seq'::regclass);


--
-- Name: invitation_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE invitations ALTER COLUMN invitation_id SET DEFAULT nextval('invitations_invitation_id_seq'::regclass);


--
-- Name: license_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE licenses ALTER COLUMN license_id SET DEFAULT nextval('licenses_license_id_seq'::regclass);


--
-- Name: measurement_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE measurements ALTER COLUMN measurement_id SET DEFAULT nextval('measurements_measurement_id_seq'::regclass);


--
-- Name: metric_id; Type: DEFAULT; Schema: application; Owner: -
--

ALTER TABLE metrics ALTER COLUMN metric_id SET DEFAULT nextval('metrics_metric_id_seq'::regclass);


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
-- Name: activities_activity_attributes_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_activity_attributes
    ADD CONSTRAINT activities_activity_attributes_pkey PRIMARY KEY (activity_id, activity_attribute_id);


--
-- Name: activities_body_parts_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_body_parts
    ADD CONSTRAINT activities_body_parts_pkey PRIMARY KEY (activity_id, body_part_id);


--
-- Name: activities_implements_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_implements
    ADD CONSTRAINT activities_implements_pkey PRIMARY KEY (activity_id, implement_id);


--
-- Name: activities_metrics_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities_metrics
    ADD CONSTRAINT activities_metrics_pkey PRIMARY KEY (activity_id, metric_id);


--
-- Name: activities_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (activity_id);


--
-- Name: activity_attributes_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_attributes
    ADD CONSTRAINT activity_attributes_pkey PRIMARY KEY (activity_attribute_id);


--
-- Name: activity_sets_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_pkey PRIMARY KEY (routine_id, "position");


--
-- Name: activity_types_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY activity_types
    ADD CONSTRAINT activity_types_pkey PRIMARY KEY (activity_type_id);


--
-- Name: body_parts_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY body_parts
    ADD CONSTRAINT body_parts_pkey PRIMARY KEY (body_part_id);


--
-- Name: confirmations_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY confirmations
    ADD CONSTRAINT confirmations_pkey PRIMARY KEY (user_id);


--
-- Name: devices_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_pkey PRIMARY KEY (device_id);


--
-- Name: feedback_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id);


--
-- Name: implements_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY implements
    ADD CONSTRAINT implements_pkey PRIMARY KEY (implement_id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (invitation_id);


--
-- Name: licenses_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (license_id);


--
-- Name: measurements_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY measurements
    ADD CONSTRAINT measurements_pkey PRIMARY KEY (measurement_id);


--
-- Name: metrics_pkey; Type: CONSTRAINT; Schema: application; Owner: -; Tablespace: 
--

ALTER TABLE ONLY metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (metric_id);


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
    ADD CONSTRAINT user_relationships_pkey PRIMARY KEY (trainer_id, client_id);


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
    ADD CONSTRAINT work_pkey PRIMARY KEY (user_id, start_day_id, routine_id, activity_id, measurement_id, start_time, end_time);


SET search_path = application, pg_catalog;

--
-- Name: activities_permalink_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX activities_permalink_idx ON activities USING btree (permalink);


--
-- Name: activity_attributes_permalink_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX activity_attributes_permalink_idx ON activity_attributes USING btree (permalink);


--
-- Name: activity_types_name_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX activity_types_name_idx ON activity_types USING btree (name);


--
-- Name: body_parts_permalink_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX body_parts_permalink_idx ON body_parts USING btree (permalink);


--
-- Name: implements_permalink_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX implements_permalink_idx ON implements USING btree (permalink);


--
-- Name: invitations_license_id_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX invitations_license_id_idx ON invitations USING btree (license_id);


--
-- Name: invitations_trainer_id_email_to_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX invitations_trainer_id_email_to_idx ON invitations USING btree (trainer_id, email_to);


--
-- Name: licenses_trainer_id_client_id_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX licenses_trainer_id_client_id_idx ON licenses USING btree (trainer_id, client_id) WHERE (trainer_id <> client_id);


--
-- Name: measures_uniq_idx_all; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX measures_uniq_idx_all ON measurements USING btree (cadence, calories, distance, duration, incline, level, repetitions, resistance, speed);


--
-- Name: metrics_name_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX metrics_name_idx ON metrics USING btree (name);


--
-- Name: routines_client_id_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE INDEX routines_client_id_idx ON routines USING btree (client_id);


--
-- Name: routines_client_id_permalink_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX routines_client_id_permalink_idx ON routines USING btree (client_id, permalink);


--
-- Name: routines_trainer_id_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE INDEX routines_trainer_id_idx ON routines USING btree (trainer_id);


--
-- Name: units_abbr_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX units_abbr_idx ON units USING btree (abbr);


--
-- Name: units_name_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX units_name_idx ON units USING btree (name);


--
-- Name: users_lower_idx; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_lower_idx ON users USING btree (lower(login));


--
-- Name: users_lower_idx1; Type: INDEX; Schema: application; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX users_lower_idx1 ON users USING btree (lower(email));


SET search_path = public, pg_catalog;

--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


SET search_path = reporting, pg_catalog;

--
-- Name: days_day_month_year_idx; Type: INDEX; Schema: reporting; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX days_day_month_year_idx ON days USING btree (day, month, year);


--
-- Name: days_full_date_idx; Type: INDEX; Schema: reporting; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX days_full_date_idx ON days USING btree (full_date);


SET search_path = application, pg_catalog;

--
-- Name: activities_activity_attributes_activity_attribute_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_activity_attributes
    ADD CONSTRAINT activities_activity_attributes_activity_attribute_id_fkey FOREIGN KEY (activity_attribute_id) REFERENCES activity_attributes(activity_attribute_id) DEFERRABLE;


--
-- Name: activities_activity_attributes_activity_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_activity_attributes
    ADD CONSTRAINT activities_activity_attributes_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id) DEFERRABLE;


--
-- Name: activities_activity_type_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_activity_type_id_fkey FOREIGN KEY (activity_type_id) REFERENCES activity_types(activity_type_id) DEFERRABLE;


--
-- Name: activities_body_parts_activity_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_body_parts
    ADD CONSTRAINT activities_body_parts_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id) DEFERRABLE;


--
-- Name: activities_body_parts_body_part_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_body_parts
    ADD CONSTRAINT activities_body_parts_body_part_id_fkey FOREIGN KEY (body_part_id) REFERENCES body_parts(body_part_id) DEFERRABLE;


--
-- Name: activities_creator_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities
    ADD CONSTRAINT activities_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: activities_implements_activity_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_implements
    ADD CONSTRAINT activities_implements_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id) DEFERRABLE;


--
-- Name: activities_implements_implement_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_implements
    ADD CONSTRAINT activities_implements_implement_id_fkey FOREIGN KEY (implement_id) REFERENCES implements(implement_id) DEFERRABLE;


--
-- Name: activities_metrics_activity_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_metrics
    ADD CONSTRAINT activities_metrics_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id) DEFERRABLE;


--
-- Name: activities_metrics_metric_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activities_metrics
    ADD CONSTRAINT activities_metrics_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES metrics(metric_id) DEFERRABLE;


--
-- Name: activity_sets_activity_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES activities(activity_id) DEFERRABLE;


--
-- Name: activity_sets_cadence_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_cadence_unit_id_fkey FOREIGN KEY (cadence_unit_id) REFERENCES units(unit_id) DEFERRABLE;


--
-- Name: activity_sets_distance_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_distance_unit_id_fkey FOREIGN KEY (distance_unit_id) REFERENCES units(unit_id) DEFERRABLE;


--
-- Name: activity_sets_duration_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_duration_unit_id_fkey FOREIGN KEY (duration_unit_id) REFERENCES units(unit_id) DEFERRABLE;


--
-- Name: activity_sets_measurement_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_measurement_id_fkey FOREIGN KEY (measurement_id) REFERENCES measurements(measurement_id) DEFERRABLE;


--
-- Name: activity_sets_resistance_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_resistance_unit_id_fkey FOREIGN KEY (resistance_unit_id) REFERENCES units(unit_id) DEFERRABLE;


--
-- Name: activity_sets_routine_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES routines(routine_id) DEFERRABLE;


--
-- Name: activity_sets_speed_unit_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY activity_sets
    ADD CONSTRAINT activity_sets_speed_unit_id_fkey FOREIGN KEY (speed_unit_id) REFERENCES units(unit_id) DEFERRABLE;


--
-- Name: confirmations_user_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY confirmations
    ADD CONSTRAINT confirmations_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: devices_user_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY devices
    ADD CONSTRAINT devices_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY feedback
    ADD CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: invitations_license_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_license_id_fkey FOREIGN KEY (license_id) REFERENCES licenses(license_id) DEFERRABLE;


--
-- Name: invitations_trainer_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: licenses_client_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY licenses
    ADD CONSTRAINT licenses_client_id_fkey FOREIGN KEY (client_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: licenses_trainer_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY licenses
    ADD CONSTRAINT licenses_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: routines_client_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY routines
    ADD CONSTRAINT routines_client_id_fkey FOREIGN KEY (client_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: routines_trainer_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY routines
    ADD CONSTRAINT routines_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: units_metric_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY units
    ADD CONSTRAINT units_metric_id_fkey FOREIGN KEY (metric_id) REFERENCES metrics(metric_id) DEFERRABLE;


--
-- Name: user_relationships_client_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_client_id_fkey FOREIGN KEY (client_id) REFERENCES users(user_id) DEFERRABLE;


--
-- Name: user_relationships_trainer_id_fkey; Type: FK CONSTRAINT; Schema: application; Owner: -
--

ALTER TABLE ONLY user_relationships
    ADD CONSTRAINT user_relationships_trainer_id_fkey FOREIGN KEY (trainer_id) REFERENCES users(user_id) DEFERRABLE;


SET search_path = reporting, pg_catalog;

--
-- Name: work_activity_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_activity_id_fkey FOREIGN KEY (activity_id) REFERENCES application.activities(activity_id) DEFERRABLE;


--
-- Name: work_measurement_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_measurement_id_fkey FOREIGN KEY (measurement_id) REFERENCES application.measurements(measurement_id) DEFERRABLE;


--
-- Name: work_routine_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_routine_id_fkey FOREIGN KEY (routine_id) REFERENCES application.routines(routine_id) DEFERRABLE;


--
-- Name: work_start_day_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_start_day_id_fkey FOREIGN KEY (start_day_id) REFERENCES days(day_id) DEFERRABLE;


--
-- Name: work_user_id_fkey; Type: FK CONSTRAINT; Schema: reporting; Owner: -
--

ALTER TABLE ONLY work
    ADD CONSTRAINT work_user_id_fkey FOREIGN KEY (user_id) REFERENCES application.users(user_id) DEFERRABLE;


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20120122034505');

INSERT INTO schema_migrations (version) VALUES ('20120122034507');

INSERT INTO schema_migrations (version) VALUES ('20120122034510');

INSERT INTO schema_migrations (version) VALUES ('20120122034520');

INSERT INTO schema_migrations (version) VALUES ('20120122034525');

INSERT INTO schema_migrations (version) VALUES ('20120122034529');

INSERT INTO schema_migrations (version) VALUES ('20120122034530');

INSERT INTO schema_migrations (version) VALUES ('20120122034531');

INSERT INTO schema_migrations (version) VALUES ('20120122034535');

INSERT INTO schema_migrations (version) VALUES ('20120122034540');

INSERT INTO schema_migrations (version) VALUES ('20120122034543');

INSERT INTO schema_migrations (version) VALUES ('20120122034545');

INSERT INTO schema_migrations (version) VALUES ('20120122034550');

INSERT INTO schema_migrations (version) VALUES ('20120411000000');

INSERT INTO schema_migrations (version) VALUES ('20120411022122');

INSERT INTO schema_migrations (version) VALUES ('20120414011444');

INSERT INTO schema_migrations (version) VALUES ('20120414011464');

INSERT INTO schema_migrations (version) VALUES ('20120505031744');

INSERT INTO schema_migrations (version) VALUES ('20120730022445');

INSERT INTO schema_migrations (version) VALUES ('20120828015710');

INSERT INTO schema_migrations (version) VALUES ('20120931022445');

INSERT INTO schema_migrations (version) VALUES ('20120931022446');

INSERT INTO schema_migrations (version) VALUES ('20120931022447');

INSERT INTO schema_migrations (version) VALUES ('20120931122447');

INSERT INTO schema_migrations (version) VALUES ('20120931122448');