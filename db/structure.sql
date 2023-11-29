CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

CREATE TABLE permissions (
    id bigint NOT NULL,
    name text,
    description text,
    permission_type integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_d0220e0e39 CHECK ((char_length(name) <= 50))
);

CREATE SEQUENCE permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE permissions_id_seq OWNED BY permissions.id;

CREATE TABLE policies (
    id bigint NOT NULL,
    permission_id bigint NOT NULL,
    value integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE policies_id_seq OWNED BY policies.id;

CREATE TABLE role_policies (
    id bigint NOT NULL,
    policy_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE role_policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE role_policies_id_seq OWNED BY role_policies.id;

CREATE TABLE roles (
    id bigint NOT NULL,
    name text,
    team_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_7b6ae76a2e CHECK ((char_length(name) <= 50))
);

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);

CREATE TABLE team_member_roles (
    id bigint NOT NULL,
    team_member_id bigint NOT NULL,
    role_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE team_member_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE team_member_roles_id_seq OWNED BY team_member_roles.id;

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
    name text,
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

CREATE TABLE users (
    id bigint NOT NULL,
    username text,
    email text,
    firstname text,
    lastname text,
    password_digest text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_3bedaaa612 CHECK ((char_length(email) <= 255)),
    CONSTRAINT check_56606ce552 CHECK ((char_length(username) <= 50))
);

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE users_id_seq OWNED BY users.id;

ALTER TABLE ONLY permissions ALTER COLUMN id SET DEFAULT nextval('permissions_id_seq'::regclass);

ALTER TABLE ONLY policies ALTER COLUMN id SET DEFAULT nextval('policies_id_seq'::regclass);

ALTER TABLE ONLY role_policies ALTER COLUMN id SET DEFAULT nextval('role_policies_id_seq'::regclass);

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);

ALTER TABLE ONLY team_member_roles ALTER COLUMN id SET DEFAULT nextval('team_member_roles_id_seq'::regclass);

ALTER TABLE ONLY team_members ALTER COLUMN id SET DEFAULT nextval('team_members_id_seq'::regclass);

ALTER TABLE ONLY teams ALTER COLUMN id SET DEFAULT nextval('teams_id_seq'::regclass);

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);

ALTER TABLE ONLY permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY policies
    ADD CONSTRAINT policies_pkey PRIMARY KEY (id);

ALTER TABLE ONLY role_policies
    ADD CONSTRAINT role_policies_pkey PRIMARY KEY (id);

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

ALTER TABLE ONLY team_member_roles
    ADD CONSTRAINT team_member_roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);

ALTER TABLE ONLY teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX "index_permissions_on_LOWER_name" ON permissions USING btree (lower(name));

CREATE INDEX index_policies_on_permission_id ON policies USING btree (permission_id);

CREATE INDEX index_role_policies_on_policy_id ON role_policies USING btree (policy_id);

CREATE UNIQUE INDEX index_role_policies_on_policy_id_and_role_id ON role_policies USING btree (policy_id, role_id);

CREATE INDEX index_role_policies_on_role_id ON role_policies USING btree (role_id);

CREATE INDEX index_roles_on_team_id ON roles USING btree (team_id);

CREATE UNIQUE INDEX index_roles_on_team_id_and_name ON roles USING btree (team_id, name);

CREATE INDEX index_team_member_roles_on_role_id ON team_member_roles USING btree (role_id);

CREATE INDEX index_team_member_roles_on_team_member_id ON team_member_roles USING btree (team_member_id);

CREATE UNIQUE INDEX index_team_member_roles_on_team_member_id_and_role_id ON team_member_roles USING btree (team_member_id, role_id);

CREATE INDEX index_team_members_on_team_id ON team_members USING btree (team_id);

CREATE UNIQUE INDEX index_team_members_on_team_id_and_user_id ON team_members USING btree (team_id, user_id);

CREATE INDEX index_team_members_on_user_id ON team_members USING btree (user_id);

CREATE UNIQUE INDEX "index_teams_on_LOWER_name" ON teams USING btree (lower(name));

CREATE UNIQUE INDEX "index_users_on_LOWER_email" ON users USING btree (lower(email));

CREATE UNIQUE INDEX "index_users_on_LOWER_username" ON users USING btree (lower(username));

ALTER TABLE ONLY team_members
    ADD CONSTRAINT fk_rails_194b5b076d FOREIGN KEY (team_id) REFERENCES teams(id);

ALTER TABLE ONLY team_member_roles
    ADD CONSTRAINT fk_rails_2ba25f58d9 FOREIGN KEY (role_id) REFERENCES roles(id);

ALTER TABLE ONLY role_policies
    ADD CONSTRAINT fk_rails_7cc227c25f FOREIGN KEY (policy_id) REFERENCES policies(id);

ALTER TABLE ONLY team_member_roles
    ADD CONSTRAINT fk_rails_8344ddd6a4 FOREIGN KEY (team_member_id) REFERENCES team_members(id);

ALTER TABLE ONLY team_members
    ADD CONSTRAINT fk_rails_9ec2d5e75e FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE ONLY policies
    ADD CONSTRAINT fk_rails_b09543d08e FOREIGN KEY (permission_id) REFERENCES permissions(id);

ALTER TABLE ONLY role_policies
    ADD CONSTRAINT fk_rails_c1bb3b357a FOREIGN KEY (role_id) REFERENCES roles(id);

ALTER TABLE ONLY roles
    ADD CONSTRAINT fk_rails_fc288be3b4 FOREIGN KEY (team_id) REFERENCES teams(id);
