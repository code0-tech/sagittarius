CREATE TABLE application_settings (
    id bigint NOT NULL,
    setting integer NOT NULL,
    value jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE application_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE application_settings_id_seq OWNED BY application_settings.id;

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

CREATE TABLE organization_member_roles (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE organization_member_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE organization_member_roles_id_seq OWNED BY organization_member_roles.id;

CREATE TABLE organization_members (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE organization_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE organization_members_id_seq OWNED BY organization_members.id;

CREATE TABLE organization_role_abilities (
    id bigint NOT NULL,
    organization_role_id bigint NOT NULL,
    ability integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE organization_role_abilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE organization_role_abilities_id_seq OWNED BY organization_role_abilities.id;

CREATE TABLE organization_roles (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE organization_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE organization_roles_id_seq OWNED BY organization_roles.id;

CREATE TABLE organizations (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_d130d769e0 CHECK ((char_length(name) <= 50))
);

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);

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
    admin boolean DEFAULT false NOT NULL,
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

ALTER TABLE ONLY application_settings ALTER COLUMN id SET DEFAULT nextval('application_settings_id_seq'::regclass);

ALTER TABLE ONLY audit_events ALTER COLUMN id SET DEFAULT nextval('audit_events_id_seq'::regclass);

ALTER TABLE ONLY organization_member_roles ALTER COLUMN id SET DEFAULT nextval('organization_member_roles_id_seq'::regclass);

ALTER TABLE ONLY organization_members ALTER COLUMN id SET DEFAULT nextval('organization_members_id_seq'::regclass);

ALTER TABLE ONLY organization_role_abilities ALTER COLUMN id SET DEFAULT nextval('organization_role_abilities_id_seq'::regclass);

ALTER TABLE ONLY organization_roles ALTER COLUMN id SET DEFAULT nextval('organization_roles_id_seq'::regclass);

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);

ALTER TABLE ONLY user_sessions ALTER COLUMN id SET DEFAULT nextval('user_sessions_id_seq'::regclass);

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

ALTER TABLE ONLY application_settings
    ADD CONSTRAINT application_settings_pkey PRIMARY KEY (id);

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);

ALTER TABLE ONLY audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);

ALTER TABLE ONLY organization_member_roles
    ADD CONSTRAINT organization_member_roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY organization_members
    ADD CONSTRAINT organization_members_pkey PRIMARY KEY (id);

ALTER TABLE ONLY organization_role_abilities
    ADD CONSTRAINT organization_role_abilities_pkey PRIMARY KEY (id);

ALTER TABLE ONLY organization_roles
    ADD CONSTRAINT organization_roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

ALTER TABLE ONLY user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX idx_on_organization_role_id_ability_9df7780947 ON organization_role_abilities USING btree (organization_role_id, ability);

CREATE UNIQUE INDEX index_application_settings_on_setting ON application_settings USING btree (setting);

CREATE INDEX index_audit_events_on_author_id ON audit_events USING btree (author_id);

CREATE INDEX index_organization_member_roles_on_member_id ON organization_member_roles USING btree (member_id);

CREATE INDEX index_organization_member_roles_on_role_id ON organization_member_roles USING btree (role_id);

CREATE INDEX index_organization_members_on_organization_id ON organization_members USING btree (organization_id);

CREATE UNIQUE INDEX index_organization_members_on_organization_id_and_user_id ON organization_members USING btree (organization_id, user_id);

CREATE INDEX index_organization_members_on_user_id ON organization_members USING btree (user_id);

CREATE INDEX index_organization_role_abilities_on_organization_role_id ON organization_role_abilities USING btree (organization_role_id);

CREATE INDEX index_organization_roles_on_organization_id ON organization_roles USING btree (organization_id);

CREATE UNIQUE INDEX "index_organization_roles_on_organization_id_LOWER_name" ON organization_roles USING btree (organization_id, lower(name));

CREATE UNIQUE INDEX "index_organizations_on_LOWER_name" ON organizations USING btree (lower(name));

CREATE UNIQUE INDEX index_user_sessions_on_token ON user_sessions USING btree (token);

CREATE INDEX index_user_sessions_on_user_id ON user_sessions USING btree (user_id);

CREATE UNIQUE INDEX "index_users_on_LOWER_email" ON users USING btree (lower(email));

CREATE UNIQUE INDEX "index_users_on_LOWER_username" ON users USING btree (lower(username));

ALTER TABLE ONLY organization_roles
    ADD CONSTRAINT fk_rails_1edd21f138 FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE;

ALTER TABLE ONLY organization_member_roles
    ADD CONSTRAINT fk_rails_585a684166 FOREIGN KEY (role_id) REFERENCES organization_roles(id) ON DELETE CASCADE;

ALTER TABLE ONLY organization_member_roles
    ADD CONSTRAINT fk_rails_6c0d5a04c4 FOREIGN KEY (member_id) REFERENCES organization_members(id) ON DELETE CASCADE;

ALTER TABLE ONLY user_sessions
    ADD CONSTRAINT fk_rails_9fa262d742 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ONLY organization_members
    ADD CONSTRAINT fk_rails_a0a760b9b4 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ONLY organization_role_abilities
    ADD CONSTRAINT fk_rails_d6431c7c9d FOREIGN KEY (organization_role_id) REFERENCES organization_roles(id) ON DELETE CASCADE;

ALTER TABLE ONLY audit_events
    ADD CONSTRAINT fk_rails_f64374fc56 FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL;

ALTER TABLE ONLY organization_members
    ADD CONSTRAINT fk_rails_ff629e24d8 FOREIGN KEY (organization_id) REFERENCES organizations(id) ON DELETE CASCADE;
