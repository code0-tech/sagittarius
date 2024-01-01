CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

CREATE TABLE audit_events (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    entity_id integer NOT NULL,
    entity_type text NOT NULL,
    action_type integer NOT NULL,
    details jsonb NOT NULL,
    ip_address inet,
    target_id integer NOT NULL,
    target_type text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE audit_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE audit_events_id_seq OWNED BY audit_events.id;

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);

CREATE TABLE team_members (
    id bigint NOT NULL,
    team_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE team_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE team_members_id_seq OWNED BY team_members.id;

CREATE TABLE teams (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_b19127323e CHECK ((char_length(name) <= 50))
);

CREATE SEQUENCE teams_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE teams_id_seq OWNED BY teams.id;

CREATE TABLE user_sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_sessions_id_seq OWNED BY user_sessions.id;

CREATE TABLE users (
    id bigint NOT NULL,
    username text,
    email text,
    password_digest text NOT NULL,
    firstname text,
    lastname text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_3bedaaa612 CHECK ((char_length(email) <= 255)),
    CONSTRAINT check_56606ce552 CHECK ((char_length(username) <= 50)),
    CONSTRAINT check_60346c5299 CHECK ((char_length(lastname) <= 50)),
    CONSTRAINT check_d4bc21c175 CHECK ((char_length(firstname) <= 50))
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;

ALTER TABLE ONLY audit_events ALTER COLUMN id SET DEFAULT nextval('audit_events_id_seq'::regclass);

ALTER TABLE ONLY team_members ALTER COLUMN id SET DEFAULT nextval('team_members_id_seq'::regclass);

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);

ALTER TABLE ONLY user_sessions ALTER COLUMN id SET DEFAULT nextval('user_sessions_id_seq'::regclass);

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);

ALTER TABLE ONLY audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

ALTER TABLE ONLY team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

CREATE INDEX index_audit_events_on_author_id ON audit_events USING btree (author_id);

CREATE INDEX index_team_members_on_team_id ON team_members USING btree (team_id);

CREATE UNIQUE INDEX index_team_members_on_team_id_and_user_id ON team_members USING btree (team_id, user_id);

CREATE INDEX index_team_members_on_user_id ON team_members USING btree (user_id);

CREATE UNIQUE INDEX "index_teams_on_LOWER_name" ON teams USING btree (lower(name));

CREATE UNIQUE INDEX index_user_sessions_on_token ON user_sessions USING btree (token);

CREATE INDEX index_user_sessions_on_user_id ON user_sessions USING btree (user_id);

CREATE UNIQUE INDEX "index_users_on_LOWER_email" ON users USING btree (lower(email));

CREATE UNIQUE INDEX "index_users_on_LOWER_username" ON users USING btree (lower(username));

ALTER TABLE ONLY team_members
    ADD CONSTRAINT fk_rails_194b5b076d FOREIGN KEY (team_id) REFERENCES teams(id);

ALTER TABLE ONLY team_members
    ADD CONSTRAINT fk_rails_9ec2d5e75e FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE ONLY user_sessions
    ADD CONSTRAINT fk_rails_9fa262d742 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ONLY audit_events
    ADD CONSTRAINT fk_rails_f64374fc56 FOREIGN KEY (author_id) REFERENCES users(id);
