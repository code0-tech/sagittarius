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

CREATE TABLE backup_codes (
    id bigint NOT NULL,
    token text,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_458fe46218 CHECK ((char_length(token) <= 10))
);

CREATE SEQUENCE backup_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE backup_codes_id_seq OWNED BY backup_codes.id;

CREATE TABLE data_type_rules (
    id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    variant integer NOT NULL,
    config jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE data_type_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE data_type_rules_id_seq OWNED BY data_type_rules.id;

CREATE TABLE data_types (
    id bigint NOT NULL,
    namespace_id bigint,
    identifier text NOT NULL,
    variant integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    parent_type_id bigint,
    CONSTRAINT check_3a7198812e CHECK ((char_length(identifier) <= 50))
);

CREATE SEQUENCE data_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE data_types_id_seq OWNED BY data_types.id;

CREATE TABLE good_job_batches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    description text,
    serialized_properties jsonb,
    on_finish text,
    on_success text,
    on_discard text,
    callback_queue_name text,
    callback_priority integer,
    enqueued_at timestamp with time zone,
    discarded_at timestamp with time zone,
    finished_at timestamp with time zone,
    jobs_finished_at timestamp with time zone
);

CREATE TABLE good_job_executions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    active_job_id uuid NOT NULL,
    job_class text,
    queue_name text,
    serialized_params jsonb,
    scheduled_at timestamp with time zone,
    finished_at timestamp with time zone,
    error text,
    error_event smallint,
    error_backtrace text[],
    process_id uuid,
    duration interval
);

CREATE TABLE good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    state jsonb,
    lock_type smallint
);

CREATE TABLE good_job_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    key text,
    value jsonb
);

CREATE TABLE good_jobs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    queue_name text,
    priority integer,
    serialized_params jsonb,
    scheduled_at timestamp with time zone,
    performed_at timestamp with time zone,
    finished_at timestamp with time zone,
    error text,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    active_job_id uuid,
    concurrency_key text,
    cron_key text,
    retried_good_job_id uuid,
    cron_at timestamp with time zone,
    batch_id uuid,
    batch_callback_id uuid,
    is_discrete boolean,
    executions_count integer,
    job_class text,
    error_event smallint,
    labels text[],
    locked_by_id uuid,
    locked_at timestamp with time zone
);

CREATE TABLE namespace_licenses (
    id bigint NOT NULL,
    data text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id bigint NOT NULL
);

CREATE SEQUENCE namespace_licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_licenses_id_seq OWNED BY namespace_licenses.id;

CREATE TABLE namespace_member_roles (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE namespace_member_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_member_roles_id_seq OWNED BY namespace_member_roles.id;

CREATE TABLE namespace_members (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id bigint NOT NULL
);

CREATE SEQUENCE namespace_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_members_id_seq OWNED BY namespace_members.id;

CREATE TABLE namespace_projects (
    id bigint NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id bigint NOT NULL,
    CONSTRAINT check_09e881e641 CHECK ((char_length(name) <= 50)),
    CONSTRAINT check_a77bf7c685 CHECK ((char_length(description) <= 500))
);

CREATE SEQUENCE namespace_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_projects_id_seq OWNED BY namespace_projects.id;

CREATE TABLE namespace_role_abilities (
    id bigint NOT NULL,
    ability integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_role_id bigint NOT NULL
);

CREATE SEQUENCE namespace_role_abilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_role_abilities_id_seq OWNED BY namespace_role_abilities.id;

CREATE TABLE namespace_role_project_assignments (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    project_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE namespace_role_project_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_role_project_assignments_id_seq OWNED BY namespace_role_project_assignments.id;

CREATE TABLE namespace_roles (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id bigint NOT NULL
);

CREATE SEQUENCE namespace_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespace_roles_id_seq OWNED BY namespace_roles.id;

CREATE TABLE namespaces (
    id bigint NOT NULL,
    parent_type character varying NOT NULL,
    parent_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE namespaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE namespaces_id_seq OWNED BY namespaces.id;

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

CREATE TABLE runtime_function_definitions (
    id bigint NOT NULL,
    return_type_id bigint NOT NULL,
    namespace_id bigint NOT NULL,
    runtime_name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_fe8fff4f27 CHECK ((char_length(runtime_name) <= 50))
);

CREATE SEQUENCE runtime_function_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE runtime_function_definitions_id_seq OWNED BY runtime_function_definitions.id;

CREATE TABLE runtime_parameter_definitions (
    id bigint NOT NULL,
    runtime_function_definition_id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_95aff0700e CHECK ((char_length(name) <= 50))
);

CREATE SEQUENCE runtime_parameter_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE runtime_parameter_definitions_id_seq OWNED BY runtime_parameter_definitions.id;

CREATE TABLE runtimes (
    id bigint NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    token text NOT NULL,
    namespace_id bigint,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_090cd49d30 CHECK ((char_length(name) <= 50)),
    CONSTRAINT check_f3c2ba8db3 CHECK ((char_length(description) <= 500))
);

CREATE SEQUENCE runtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE runtimes_id_seq OWNED BY runtimes.id;

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);

CREATE TABLE translations (
    id bigint NOT NULL,
    code text NOT NULL,
    content text NOT NULL,
    owner_type character varying NOT NULL,
    owner_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE translations_id_seq OWNED BY translations.id;

CREATE TABLE user_identities (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    provider_id text NOT NULL,
    identifier text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);

CREATE SEQUENCE user_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE user_identities_id_seq OWNED BY user_identities.id;

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
    totp_secret text,
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

ALTER TABLE ONLY backup_codes ALTER COLUMN id SET DEFAULT nextval('backup_codes_id_seq'::regclass);

ALTER TABLE ONLY data_type_rules ALTER COLUMN id SET DEFAULT nextval('data_type_rules_id_seq'::regclass);

ALTER TABLE ONLY data_types ALTER COLUMN id SET DEFAULT nextval('data_types_id_seq'::regclass);

ALTER TABLE ONLY namespace_licenses ALTER COLUMN id SET DEFAULT nextval('namespace_licenses_id_seq'::regclass);

ALTER TABLE ONLY namespace_member_roles ALTER COLUMN id SET DEFAULT nextval('namespace_member_roles_id_seq'::regclass);

ALTER TABLE ONLY namespace_members ALTER COLUMN id SET DEFAULT nextval('namespace_members_id_seq'::regclass);

ALTER TABLE ONLY namespace_projects ALTER COLUMN id SET DEFAULT nextval('namespace_projects_id_seq'::regclass);

ALTER TABLE ONLY namespace_role_abilities ALTER COLUMN id SET DEFAULT nextval('namespace_role_abilities_id_seq'::regclass);

ALTER TABLE ONLY namespace_role_project_assignments ALTER COLUMN id SET DEFAULT nextval('namespace_role_project_assignments_id_seq'::regclass);

ALTER TABLE ONLY namespace_roles ALTER COLUMN id SET DEFAULT nextval('namespace_roles_id_seq'::regclass);

ALTER TABLE ONLY namespaces ALTER COLUMN id SET DEFAULT nextval('namespaces_id_seq'::regclass);

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);

ALTER TABLE ONLY runtime_function_definitions ALTER COLUMN id SET DEFAULT nextval('runtime_function_definitions_id_seq'::regclass);

ALTER TABLE ONLY runtime_parameter_definitions ALTER COLUMN id SET DEFAULT nextval('runtime_parameter_definitions_id_seq'::regclass);

ALTER TABLE ONLY runtimes ALTER COLUMN id SET DEFAULT nextval('runtimes_id_seq'::regclass);

ALTER TABLE ONLY translations ALTER COLUMN id SET DEFAULT nextval('translations_id_seq'::regclass);

ALTER TABLE ONLY user_identities ALTER COLUMN id SET DEFAULT nextval('user_identities_id_seq'::regclass);

ALTER TABLE ONLY user_sessions ALTER COLUMN id SET DEFAULT nextval('user_sessions_id_seq'::regclass);

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);

ALTER TABLE ONLY application_settings
    ADD CONSTRAINT application_settings_pkey PRIMARY KEY (id);

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);

ALTER TABLE ONLY audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);

ALTER TABLE ONLY backup_codes
    ADD CONSTRAINT backup_codes_pkey PRIMARY KEY (id);

ALTER TABLE ONLY data_type_rules
    ADD CONSTRAINT data_type_rules_pkey PRIMARY KEY (id);

ALTER TABLE ONLY data_types
    ADD CONSTRAINT data_types_pkey PRIMARY KEY (id);

ALTER TABLE ONLY good_job_batches
    ADD CONSTRAINT good_job_batches_pkey PRIMARY KEY (id);

ALTER TABLE ONLY good_job_executions
    ADD CONSTRAINT good_job_executions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);

ALTER TABLE ONLY good_job_settings
    ADD CONSTRAINT good_job_settings_pkey PRIMARY KEY (id);

ALTER TABLE ONLY good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_licenses
    ADD CONSTRAINT namespace_licenses_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_member_roles
    ADD CONSTRAINT namespace_member_roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_members
    ADD CONSTRAINT namespace_members_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_projects
    ADD CONSTRAINT namespace_projects_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_role_abilities
    ADD CONSTRAINT namespace_role_abilities_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_role_project_assignments
    ADD CONSTRAINT namespace_role_project_assignments_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespace_roles
    ADD CONSTRAINT namespace_roles_pkey PRIMARY KEY (id);

ALTER TABLE ONLY namespaces
    ADD CONSTRAINT namespaces_pkey PRIMARY KEY (id);

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);

ALTER TABLE ONLY runtime_function_definitions
    ADD CONSTRAINT runtime_function_definitions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY runtime_parameter_definitions
    ADD CONSTRAINT runtime_parameter_definitions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY runtimes
    ADD CONSTRAINT runtimes_pkey PRIMARY KEY (id);

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

ALTER TABLE ONLY translations
    ADD CONSTRAINT translations_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_identities
    ADD CONSTRAINT user_identities_pkey PRIMARY KEY (id);

ALTER TABLE ONLY user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX idx_on_namespace_id_runtime_name_dba40f4549 ON runtime_function_definitions USING btree (namespace_id, runtime_name);

CREATE UNIQUE INDEX idx_on_namespace_role_id_ability_a092da8841 ON namespace_role_abilities USING btree (namespace_role_id, ability);

CREATE UNIQUE INDEX idx_on_role_id_project_id_5d4b5917dc ON namespace_role_project_assignments USING btree (role_id, project_id);

CREATE UNIQUE INDEX idx_on_runtime_function_definition_id_name_4860aebcbe ON runtime_parameter_definitions USING btree (runtime_function_definition_id, name);

CREATE UNIQUE INDEX index_application_settings_on_setting ON application_settings USING btree (setting);

CREATE INDEX index_audit_events_on_author_id ON audit_events USING btree (author_id);

CREATE INDEX index_backup_codes_on_user_id ON backup_codes USING btree (user_id);

CREATE UNIQUE INDEX "index_backup_codes_on_user_id_LOWER_token" ON backup_codes USING btree (user_id, lower(token));

CREATE INDEX index_data_type_rules_on_data_type_id ON data_type_rules USING btree (data_type_id);

CREATE UNIQUE INDEX index_data_types_on_namespace_id_and_identifier ON data_types USING btree (namespace_id, identifier);

CREATE INDEX index_data_types_on_parent_type_id ON data_types USING btree (parent_type_id);

CREATE INDEX index_good_job_executions_on_active_job_id_and_created_at ON good_job_executions USING btree (active_job_id, created_at);

CREATE INDEX index_good_job_executions_on_process_id_and_created_at ON good_job_executions USING btree (process_id, created_at);

CREATE INDEX index_good_job_jobs_for_candidate_lookup ON good_jobs USING btree (priority, created_at) WHERE (finished_at IS NULL);

CREATE UNIQUE INDEX index_good_job_settings_on_key ON good_job_settings USING btree (key);

CREATE INDEX index_good_jobs_jobs_on_finished_at ON good_jobs USING btree (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL));

CREATE INDEX index_good_jobs_jobs_on_priority_created_at_when_unfinished ON good_jobs USING btree (priority DESC NULLS LAST, created_at) WHERE (finished_at IS NULL);

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON good_jobs USING btree (active_job_id, created_at);

CREATE INDEX index_good_jobs_on_batch_callback_id ON good_jobs USING btree (batch_callback_id) WHERE (batch_callback_id IS NOT NULL);

CREATE INDEX index_good_jobs_on_batch_id ON good_jobs USING btree (batch_id) WHERE (batch_id IS NOT NULL);

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON good_jobs USING btree (cron_key, cron_at) WHERE (cron_key IS NOT NULL);

CREATE INDEX index_good_jobs_on_labels ON good_jobs USING gin (labels) WHERE (labels IS NOT NULL);

CREATE INDEX index_good_jobs_on_locked_by_id ON good_jobs USING btree (locked_by_id) WHERE (locked_by_id IS NOT NULL);

CREATE INDEX index_good_jobs_on_priority_scheduled_at_unfinished_unlocked ON good_jobs USING btree (priority, scheduled_at) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);

CREATE INDEX index_good_jobs_on_scheduled_at ON good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);

CREATE INDEX index_namespace_licenses_on_namespace_id ON namespace_licenses USING btree (namespace_id);

CREATE INDEX index_namespace_member_roles_on_member_id ON namespace_member_roles USING btree (member_id);

CREATE INDEX index_namespace_member_roles_on_role_id ON namespace_member_roles USING btree (role_id);

CREATE UNIQUE INDEX index_namespace_members_on_namespace_id_and_user_id ON namespace_members USING btree (namespace_id, user_id);

CREATE INDEX index_namespace_members_on_user_id ON namespace_members USING btree (user_id);

CREATE INDEX index_namespace_projects_on_namespace_id ON namespace_projects USING btree (namespace_id);

CREATE INDEX index_namespace_role_project_assignments_on_project_id ON namespace_role_project_assignments USING btree (project_id);

CREATE UNIQUE INDEX "index_namespace_roles_on_namespace_id_LOWER_name" ON namespace_roles USING btree (namespace_id, lower(name));

CREATE UNIQUE INDEX index_namespaces_on_parent_id_and_parent_type ON namespaces USING btree (parent_id, parent_type);

CREATE UNIQUE INDEX "index_organizations_on_LOWER_name" ON organizations USING btree (lower(name));

CREATE INDEX index_runtime_function_definitions_on_return_type_id ON runtime_function_definitions USING btree (return_type_id);

CREATE INDEX index_runtime_parameter_definitions_on_data_type_id ON runtime_parameter_definitions USING btree (data_type_id);

CREATE INDEX index_runtimes_on_namespace_id ON runtimes USING btree (namespace_id);

CREATE UNIQUE INDEX index_runtimes_on_token ON runtimes USING btree (token);

CREATE INDEX index_translations_on_owner ON translations USING btree (owner_type, owner_id);

CREATE UNIQUE INDEX index_user_identities_on_provider_id_and_identifier ON user_identities USING btree (provider_id, identifier);

CREATE INDEX index_user_identities_on_user_id ON user_identities USING btree (user_id);

CREATE UNIQUE INDEX index_user_sessions_on_token ON user_sessions USING btree (token);

CREATE INDEX index_user_sessions_on_user_id ON user_sessions USING btree (user_id);

CREATE UNIQUE INDEX "index_users_on_LOWER_email" ON users USING btree (lower(email));

CREATE UNIQUE INDEX "index_users_on_LOWER_username" ON users USING btree (lower(username));

CREATE UNIQUE INDEX index_users_on_totp_secret ON users USING btree (totp_secret) WHERE (totp_secret IS NOT NULL);

ALTER TABLE ONLY namespace_roles
    ADD CONSTRAINT fk_rails_205092c9cb FOREIGN KEY (namespace_id) REFERENCES namespaces(id) ON DELETE CASCADE;

ALTER TABLE ONLY runtime_parameter_definitions
    ADD CONSTRAINT fk_rails_260318ad67 FOREIGN KEY (runtime_function_definition_id) REFERENCES runtime_function_definitions(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_licenses
    ADD CONSTRAINT fk_rails_38f693332d FOREIGN KEY (namespace_id) REFERENCES namespaces(id) ON DELETE CASCADE;

ALTER TABLE ONLY data_types
    ADD CONSTRAINT fk_rails_4434ad0b90 FOREIGN KEY (parent_type_id) REFERENCES data_types(id) ON DELETE RESTRICT;

ALTER TABLE ONLY backup_codes
    ADD CONSTRAINT fk_rails_556c1feac3 FOREIGN KEY (user_id) REFERENCES users(id);

ALTER TABLE ONLY namespace_members
    ADD CONSTRAINT fk_rails_567f152a62 FOREIGN KEY (namespace_id) REFERENCES namespaces(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_member_roles
    ADD CONSTRAINT fk_rails_585a684166 FOREIGN KEY (role_id) REFERENCES namespace_roles(id) ON DELETE CASCADE;

ALTER TABLE ONLY runtime_function_definitions
    ADD CONSTRAINT fk_rails_5f0aa31141 FOREIGN KEY (namespace_id) REFERENCES namespaces(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_role_project_assignments
    ADD CONSTRAINT fk_rails_623f8a5b72 FOREIGN KEY (role_id) REFERENCES namespace_roles(id);

ALTER TABLE ONLY user_identities
    ADD CONSTRAINT fk_rails_684b0e1ce0 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_role_project_assignments
    ADD CONSTRAINT fk_rails_69066bda8f FOREIGN KEY (project_id) REFERENCES namespace_projects(id);

ALTER TABLE ONLY namespace_member_roles
    ADD CONSTRAINT fk_rails_6c0d5a04c4 FOREIGN KEY (member_id) REFERENCES namespace_members(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_role_abilities
    ADD CONSTRAINT fk_rails_6f3304b078 FOREIGN KEY (namespace_role_id) REFERENCES namespace_roles(id) ON DELETE CASCADE;

ALTER TABLE ONLY runtime_function_definitions
    ADD CONSTRAINT fk_rails_73ca8569ea FOREIGN KEY (return_type_id) REFERENCES data_types(id) ON DELETE RESTRICT;

ALTER TABLE ONLY data_type_rules
    ADD CONSTRAINT fk_rails_7759633ff8 FOREIGN KEY (data_type_id) REFERENCES data_types(id) ON DELETE CASCADE;

ALTER TABLE ONLY user_sessions
    ADD CONSTRAINT fk_rails_9fa262d742 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_members
    ADD CONSTRAINT fk_rails_a0a760b9b4 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE ONLY namespace_projects
    ADD CONSTRAINT fk_rails_d4f50e2f00 FOREIGN KEY (namespace_id) REFERENCES namespaces(id) ON DELETE CASCADE;

ALTER TABLE ONLY runtime_parameter_definitions
    ADD CONSTRAINT fk_rails_e64f825793 FOREIGN KEY (data_type_id) REFERENCES data_types(id) ON DELETE RESTRICT;

ALTER TABLE ONLY runtimes
    ADD CONSTRAINT fk_rails_eeb42116cc FOREIGN KEY (namespace_id) REFERENCES namespaces(id);

ALTER TABLE ONLY audit_events
    ADD CONSTRAINT fk_rails_f64374fc56 FOREIGN KEY (author_id) REFERENCES users(id) ON DELETE SET NULL;
