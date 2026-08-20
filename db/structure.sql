SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: sagittarius_partitions_dynamic; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA sagittarius_partitions_dynamic;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: application_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.application_settings (
    id bigint NOT NULL,
    setting integer NOT NULL,
    value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: application_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.application_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: application_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.application_settings_id_seq OWNED BY public.application_settings.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: backup_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.backup_codes (
    id bigint NOT NULL,
    token text NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_458fe46218 CHECK ((char_length(token) <= 10))
);


--
-- Name: backup_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.backup_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: backup_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.backup_codes_id_seq OWNED BY public.backup_codes.id;


--
-- Name: data_type_data_type_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_type_data_type_links (
    id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    referenced_data_type_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: data_type_data_type_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_type_data_type_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_type_data_type_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_type_data_type_links_id_seq OWNED BY public.data_type_data_type_links.id;


--
-- Name: data_type_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_type_rules (
    id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    variant integer NOT NULL,
    config jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: data_type_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_type_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_type_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_type_rules_id_seq OWNED BY public.data_type_rules.id;


--
-- Name: data_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_types (
    id bigint NOT NULL,
    identifier text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    runtime_id bigint NOT NULL,
    removed_at timestamp with time zone,
    generic_keys text[] DEFAULT '{}'::text[] NOT NULL,
    version text NOT NULL,
    type text NOT NULL,
    definition_source text,
    runtime_module_id bigint NOT NULL,
    CONSTRAINT check_01ca31b7b9 CHECK ((char_length(type) <= 65536)),
    CONSTRAINT check_3a7198812e CHECK ((char_length(identifier) <= 200)),
    CONSTRAINT check_a133157a46 CHECK ((char_length(definition_source) <= 50))
);


--
-- Name: data_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_types_id_seq OWNED BY public.data_types.id;


--
-- Name: flow_data_type_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_data_type_links (
    id bigint NOT NULL,
    flow_id bigint NOT NULL,
    referenced_data_type_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: flow_data_type_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flow_data_type_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flow_data_type_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flow_data_type_links_id_seq OWNED BY public.flow_data_type_links.id;


--
-- Name: flow_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_settings (
    id bigint NOT NULL,
    flow_id bigint NOT NULL,
    flow_setting_id text NOT NULL,
    object jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "cast" text,
    CONSTRAINT check_65f98666ae CHECK ((char_length("cast") <= 500))
);


--
-- Name: flow_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flow_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flow_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flow_settings_id_seq OWNED BY public.flow_settings.id;


--
-- Name: flow_type_data_type_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_type_data_type_links (
    id bigint NOT NULL,
    flow_type_id bigint NOT NULL,
    referenced_data_type_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: flow_type_data_type_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flow_type_data_type_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flow_type_data_type_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flow_type_data_type_links_id_seq OWNED BY public.flow_type_data_type_links.id;


--
-- Name: flow_type_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_type_settings (
    id bigint NOT NULL,
    flow_type_id bigint NOT NULL,
    identifier text NOT NULL,
    default_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    "unique" integer DEFAULT 0 NOT NULL,
    removed_at timestamp with time zone,
    optional boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


--
-- Name: flow_type_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flow_type_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flow_type_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flow_type_settings_id_seq OWNED BY public.flow_type_settings.id;


--
-- Name: flow_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_types (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    identifier text NOT NULL,
    editable boolean DEFAULT true NOT NULL,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    version text NOT NULL,
    signature text DEFAULT ''::text NOT NULL,
    definition_source text,
    display_icon text,
    runtime_module_id bigint NOT NULL,
    runtime_flow_type_id bigint NOT NULL,
    CONSTRAINT check_3311b57eb7 CHECK ((char_length(definition_source) <= 50)),
    CONSTRAINT check_3f33e69ae0 CHECK ((char_length(display_icon) <= 100)),
    CONSTRAINT check_dfcfd661f1 CHECK ((char_length(signature) <= 500))
);


--
-- Name: flow_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flow_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flow_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flow_types_id_seq OWNED BY public.flow_types.id;


--
-- Name: flows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flows (
    id bigint NOT NULL,
    project_id bigint NOT NULL,
    flow_type_id bigint NOT NULL,
    starting_node_id bigint,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    validation_status integer DEFAULT 0 NOT NULL,
    disabled_reason integer,
    signature text DEFAULT ''::text NOT NULL,
    validation_diagnostics jsonb DEFAULT '[]'::jsonb NOT NULL,
    CONSTRAINT check_8c731c24ec CHECK ((char_length(signature) <= 500))
);


--
-- Name: flows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.flows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.flows_id_seq OWNED BY public.flows.id;


--
-- Name: function_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.function_definitions (
    id bigint NOT NULL,
    runtime_function_definition_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    runtime_module_id bigint NOT NULL,
    identifier text NOT NULL,
    removed_at timestamp with time zone,
    runtime_id bigint NOT NULL,
    design text,
    CONSTRAINT check_0641c95c39 CHECK ((char_length(identifier) <= 50)),
    CONSTRAINT check_8b4572b26a CHECK ((char_length(design) <= 200))
);


--
-- Name: function_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.function_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: function_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.function_definitions_id_seq OWNED BY public.function_definitions.id;


--
-- Name: good_job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_batches (
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


--
-- Name: good_job_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_executions (
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


--
-- Name: good_job_processes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_processes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    state jsonb,
    lock_type smallint
);


--
-- Name: good_job_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_job_settings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    key text,
    value jsonb
);


--
-- Name: good_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.good_jobs (
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
    locked_at timestamp with time zone,
    lock_type integer
);


--
-- Name: inline_reference_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.inline_reference_values (
    id bigint NOT NULL,
    node_parameter_id bigint,
    parent_inline_reference_value_id bigint,
    signature text NOT NULL,
    literal_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_0d28d5496a CHECK ((num_nonnulls(node_parameter_id, parent_inline_reference_value_id) = 1)),
    CONSTRAINT check_d4a03a969a CHECK ((char_length(signature) <= 500))
);


--
-- Name: inline_reference_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.inline_reference_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inline_reference_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.inline_reference_values_id_seq OWNED BY public.inline_reference_values.id;


--
-- Name: licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.licenses (
    id bigint CONSTRAINT organization_licenses_id_not_null NOT NULL,
    data text CONSTRAINT organization_licenses_data_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT organization_licenses_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT organization_licenses_updated_at_not_null NOT NULL,
    namespace_id bigint
);


--
-- Name: licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.licenses_id_seq OWNED BY public.licenses.id;


--
-- Name: module_configuration_definition_data_type_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_configuration_definition_data_type_links (
    id bigint NOT NULL,
    module_configuration_definition_id bigint CONSTRAINT module_configuration_defini_module_configuration_defin_not_null NOT NULL,
    referenced_data_type_id bigint CONSTRAINT module_configuration_definitio_referenced_data_type_id_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT module_configuration_definition_data_type_l_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT module_configuration_definition_data_type_l_updated_at_not_null NOT NULL
);


--
-- Name: module_configuration_definition_data_type_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_configuration_definition_data_type_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_configuration_definition_data_type_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_configuration_definition_data_type_links_id_seq OWNED BY public.module_configuration_definition_data_type_links.id;


--
-- Name: module_configuration_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_configuration_definitions (
    id bigint NOT NULL,
    runtime_module_id bigint NOT NULL,
    identifier text NOT NULL,
    type text NOT NULL,
    default_value jsonb,
    optional boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_7fe4a3bc1a CHECK ((char_length(type) <= 8192)),
    CONSTRAINT check_b0290d44f1 CHECK ((char_length(identifier) <= 50))
);


--
-- Name: module_configuration_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_configuration_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_configuration_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_configuration_definitions_id_seq OWNED BY public.module_configuration_definitions.id;


--
-- Name: module_configurations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.module_configurations (
    id bigint NOT NULL,
    namespace_project_runtime_assignment_id bigint CONSTRAINT module_configurations_namespace_project_runtime_assign_not_null NOT NULL,
    module_configuration_definition_id bigint CONSTRAINT module_configurations_module_configuration_definition__not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: module_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.module_configurations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: module_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.module_configurations_id_seq OWNED BY public.module_configurations.id;


--
-- Name: namespace_member_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_member_roles (
    id bigint CONSTRAINT organization_member_roles_id_not_null NOT NULL,
    role_id bigint CONSTRAINT organization_member_roles_role_id_not_null NOT NULL,
    member_id bigint CONSTRAINT organization_member_roles_member_id_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT organization_member_roles_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT organization_member_roles_updated_at_not_null NOT NULL
);


--
-- Name: namespace_member_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_member_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_member_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_member_roles_id_seq OWNED BY public.namespace_member_roles.id;


--
-- Name: namespace_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_members (
    id bigint CONSTRAINT organization_members_id_not_null NOT NULL,
    user_id bigint CONSTRAINT organization_members_user_id_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT organization_members_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT organization_members_updated_at_not_null NOT NULL,
    namespace_id bigint NOT NULL
);


--
-- Name: namespace_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_members_id_seq OWNED BY public.namespace_members.id;


--
-- Name: namespace_project_runtime_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_project_runtime_assignments (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    namespace_project_id bigint CONSTRAINT namespace_project_runtime_assignm_namespace_project_id_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    compatible boolean DEFAULT false NOT NULL
);


--
-- Name: namespace_project_runtime_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_project_runtime_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_project_runtime_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_project_runtime_assignments_id_seq OWNED BY public.namespace_project_runtime_assignments.id;


--
-- Name: namespace_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_projects (
    id bigint CONSTRAINT organization_projects_id_not_null NOT NULL,
    name text CONSTRAINT organization_projects_name_not_null NOT NULL,
    description text DEFAULT ''::text CONSTRAINT organization_projects_description_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT organization_projects_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT organization_projects_updated_at_not_null NOT NULL,
    namespace_id bigint NOT NULL,
    primary_runtime_id bigint,
    slug text NOT NULL,
    CONSTRAINT check_09e881e641 CHECK ((char_length(name) <= 50)),
    CONSTRAINT check_34f7fad2d8 CHECK ((char_length(slug) <= 50)),
    CONSTRAINT check_a77bf7c685 CHECK ((char_length(description) <= 500))
);


--
-- Name: namespace_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_projects_id_seq OWNED BY public.namespace_projects.id;


--
-- Name: namespace_role_abilities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_role_abilities (
    id bigint CONSTRAINT organization_role_abilities_id_not_null NOT NULL,
    ability integer CONSTRAINT organization_role_abilities_ability_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT organization_role_abilities_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT organization_role_abilities_updated_at_not_null NOT NULL,
    namespace_role_id bigint NOT NULL
);


--
-- Name: namespace_role_abilities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_role_abilities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_role_abilities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_role_abilities_id_seq OWNED BY public.namespace_role_abilities.id;


--
-- Name: namespace_role_project_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_role_project_assignments (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    project_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: namespace_role_project_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_role_project_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_role_project_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_role_project_assignments_id_seq OWNED BY public.namespace_role_project_assignments.id;


--
-- Name: namespace_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_roles (
    id bigint CONSTRAINT organization_roles_id_not_null NOT NULL,
    name text CONSTRAINT organization_roles_name_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT organization_roles_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT organization_roles_updated_at_not_null NOT NULL,
    namespace_id bigint NOT NULL
);


--
-- Name: namespace_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_roles_id_seq OWNED BY public.namespace_roles.id;


--
-- Name: namespaces; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespaces (
    id bigint NOT NULL,
    parent_type character varying NOT NULL,
    parent_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: namespaces_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespaces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespaces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespaces_id_seq OWNED BY public.namespaces.id;


--
-- Name: node_functions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.node_functions (
    id bigint NOT NULL,
    next_node_id bigint,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    flow_id bigint NOT NULL,
    function_definition_id bigint NOT NULL
);


--
-- Name: node_functions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.node_functions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: node_functions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.node_functions_id_seq OWNED BY public.node_functions.id;


--
-- Name: node_parameters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.node_parameters (
    id bigint NOT NULL,
    node_function_id bigint NOT NULL,
    literal_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    parameter_definition_id bigint NOT NULL,
    "cast" text,
    CONSTRAINT check_6439c80497 CHECK ((char_length("cast") <= 500))
);


--
-- Name: node_parameters_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.node_parameters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: node_parameters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.node_parameters_id_seq OWNED BY public.node_parameters.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_d130d769e0 CHECK ((char_length(name) <= 50))
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: p_application_usage_daily_aggregates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_application_usage_daily_aggregates (
    date date NOT NULL,
    execution_count bigint DEFAULT 0 NOT NULL,
    total_execution_time_us bigint DEFAULT 0 CONSTRAINT p_application_usage_daily_aggr_total_execution_time_us_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (date);


--
-- Name: p_audit_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_audit_events (
    id bigint NOT NULL,
    author_id bigint NOT NULL,
    entity_id bigint NOT NULL,
    entity_type text NOT NULL,
    action_type integer NOT NULL,
    details jsonb NOT NULL,
    ip_address inet,
    target_id bigint NOT NULL,
    target_type text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (created_at);


--
-- Name: p_audit_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.p_audit_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: p_audit_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.p_audit_events_id_seq OWNED BY public.p_audit_events.id;


--
-- Name: p_execution_node_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_execution_node_results (
    id bigint NOT NULL,
    execution_result_id bigint NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer NOT NULL,
    started_at bigint NOT NULL,
    finished_at bigint NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
)
PARTITION BY RANGE (created_at);


--
-- Name: p_execution_node_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.p_execution_node_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: p_execution_node_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.p_execution_node_results_id_seq OWNED BY public.p_execution_node_results.id;


--
-- Name: p_execution_parameter_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_execution_parameter_results (
    id bigint NOT NULL,
    execution_node_result_id bigint NOT NULL,
    "position" integer NOT NULL,
    value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (created_at);


--
-- Name: p_execution_parameter_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.p_execution_parameter_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: p_execution_parameter_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.p_execution_parameter_results_id_seq OWNED BY public.p_execution_parameter_results.id;


--
-- Name: p_execution_results; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_execution_results (
    id bigint NOT NULL,
    flow_id bigint NOT NULL,
    execution_identifier text NOT NULL,
    input jsonb,
    started_at bigint NOT NULL,
    finished_at bigint NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
)
PARTITION BY RANGE (created_at);


--
-- Name: p_execution_results_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.p_execution_results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: p_execution_results_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.p_execution_results_id_seq OWNED BY public.p_execution_results.id;


--
-- Name: p_flow_usage_daily_aggregates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_flow_usage_daily_aggregates (
    flow_id bigint NOT NULL,
    date date NOT NULL,
    execution_count bigint DEFAULT 0 NOT NULL,
    total_execution_time_us bigint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (date);


--
-- Name: p_namespace_project_usage_daily_aggregates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_namespace_project_usage_daily_aggregates (
    project_id bigint NOT NULL,
    date date NOT NULL,
    execution_count bigint DEFAULT 0 CONSTRAINT p_namespace_project_usage_daily_aggreg_execution_count_not_null NOT NULL,
    total_execution_time_us bigint DEFAULT 0 CONSTRAINT p_namespace_project_usage_dail_total_execution_time_us_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (date);


--
-- Name: p_namespace_usage_daily_aggregates; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_namespace_usage_daily_aggregates (
    namespace_id bigint NOT NULL,
    date date NOT NULL,
    execution_count bigint DEFAULT 0 NOT NULL,
    total_execution_time_us bigint DEFAULT 0 CONSTRAINT p_namespace_usage_daily_aggreg_total_execution_time_us_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (date);


--
-- Name: p_runtime_module_status_daily_uptimes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_runtime_module_status_daily_uptimes (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date NOT NULL,
    outage_seconds integer DEFAULT 0 NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (date);


--
-- Name: p_runtime_status_daily_uptimes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.p_runtime_status_daily_uptimes (
    runtime_status_id bigint NOT NULL,
    date date NOT NULL,
    outage_seconds integer DEFAULT 0 NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
)
PARTITION BY RANGE (date);


--
-- Name: parameter_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parameter_definitions (
    id bigint NOT NULL,
    runtime_parameter_definition_id bigint NOT NULL,
    default_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    function_definition_id bigint NOT NULL,
    optional boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


--
-- Name: parameter_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.parameter_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: parameter_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.parameter_definitions_id_seq OWNED BY public.parameter_definitions.id;


--
-- Name: postgres_detached_partitions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.postgres_detached_partitions AS
 SELECT ((c.oid)::regclass)::text AS identifier,
    c.oid,
    n.nspname AS schema,
    c.relname AS name,
    ((obj_description(c.oid))::jsonb ->> 'table'::text) AS parent_identifier,
    (((obj_description(c.oid))::jsonb ->> 'detached_at'::text))::timestamp with time zone AS detached_at
   FROM (pg_class c
     JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
  WHERE ((c.relkind = 'r'::"char") AND (n.nspname = 'sagittarius_partitions_dynamic'::name) AND (NOT (EXISTS ( SELECT 1
           FROM pg_inherits
          WHERE (pg_inherits.inhrelid = c.oid)))) AND ((obj_description(c.oid))::jsonb ? 'table'::text) AND ((obj_description(c.oid))::jsonb ? 'detached_at'::text));


--
-- Name: postgres_partitioned_tables; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.postgres_partitioned_tables AS
 SELECT ((c.oid)::regclass)::text AS identifier,
    c.oid,
    n.nspname AS schema,
    c.relname AS name,
        CASE p.partstrat
            WHEN 'l'::"char" THEN 'list'::text
            WHEN 'r'::"char" THEN 'range'::text
            WHEN 'h'::"char" THEN 'hash'::text
            ELSE NULL::text
        END AS strategy,
    pg_get_partkeydef(c.oid) AS partition_key
   FROM ((pg_partitioned_table p
     JOIN pg_class c ON ((c.oid = p.partrelid)))
     JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
  WHERE (n.nspname = "current_schema"());


--
-- Name: postgres_partitions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.postgres_partitions AS
 SELECT ((c.oid)::regclass)::text AS identifier,
    c.oid,
    n.nspname AS schema,
    c.relname AS name,
    ((i.inhparent)::regclass)::text AS parent_identifier,
    pg_get_expr(c.relpartbound, c.oid) AS condition,
    obj_description(c.oid) AS comment,
    (i.inhrelid IS NOT NULL) AS attached
   FROM ((pg_class c
     LEFT JOIN pg_inherits i ON ((c.oid = i.inhrelid)))
     JOIN pg_namespace n ON ((n.oid = c.relnamespace)))
  WHERE (c.relispartition AND (c.relkind = 'r'::"char") AND (n.nspname = ANY (ARRAY["current_schema"(), 'sagittarius_partitions_dynamic'::name])));


--
-- Name: reference_paths; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_paths (
    id bigint NOT NULL,
    path text,
    array_index integer,
    reference_value_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: reference_paths_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reference_paths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_paths_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reference_paths_id_seq OWNED BY public.reference_paths.id;


--
-- Name: reference_values; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reference_values (
    id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    node_function_id bigint,
    parameter_index integer,
    input_index integer,
    input_type_identifier text,
    node_parameter_id bigint,
    inline_reference_value_id bigint,
    CONSTRAINT check_18132d63ea CHECK ((num_nonnulls(node_parameter_id, inline_reference_value_id) = 1)),
    CONSTRAINT check_a2e3734389 CHECK ((num_nonnulls(parameter_index, input_index) = ANY (ARRAY[0, 2])))
);


--
-- Name: reference_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reference_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reference_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reference_values_id_seq OWNED BY public.reference_values.id;


--
-- Name: runtime_flow_type_data_type_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_flow_type_data_type_links (
    id bigint NOT NULL,
    runtime_flow_type_id bigint NOT NULL,
    referenced_data_type_id bigint CONSTRAINT runtime_flow_type_data_type_li_referenced_data_type_id_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: runtime_flow_type_data_type_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_flow_type_data_type_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_flow_type_data_type_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_flow_type_data_type_links_id_seq OWNED BY public.runtime_flow_type_data_type_links.id;


--
-- Name: runtime_flow_type_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_flow_type_settings (
    id bigint NOT NULL,
    runtime_flow_type_id bigint NOT NULL,
    identifier text NOT NULL,
    "unique" integer DEFAULT 0 NOT NULL,
    default_value jsonb,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    optional boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL
);


--
-- Name: runtime_flow_type_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_flow_type_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_flow_type_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_flow_type_settings_id_seq OWNED BY public.runtime_flow_type_settings.id;


--
-- Name: runtime_flow_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_flow_types (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    runtime_module_id bigint NOT NULL,
    identifier text NOT NULL,
    editable boolean DEFAULT false NOT NULL,
    signature text DEFAULT ''::text NOT NULL,
    removed_at timestamp with time zone,
    definition_source text,
    display_icon text,
    version text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_0d21df63ce CHECK ((char_length(identifier) <= 50)),
    CONSTRAINT check_a082764ff7 CHECK ((char_length(definition_source) <= 50)),
    CONSTRAINT check_c63332f6d6 CHECK ((char_length(signature) <= 500)),
    CONSTRAINT check_e4e6c481a3 CHECK ((char_length(display_icon) <= 100))
);


--
-- Name: runtime_flow_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_flow_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_flow_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_flow_types_id_seq OWNED BY public.runtime_flow_types.id;


--
-- Name: runtime_function_definition_data_type_links; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_function_definition_data_type_links (
    id bigint NOT NULL,
    runtime_function_definition_id bigint CONSTRAINT runtime_function_definition_runtime_function_definitio_not_null NOT NULL,
    referenced_data_type_id bigint CONSTRAINT runtime_function_definition_da_referenced_data_type_id_not_null NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: runtime_function_definition_data_type_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_function_definition_data_type_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_function_definition_data_type_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_function_definition_data_type_links_id_seq OWNED BY public.runtime_function_definition_data_type_links.id;


--
-- Name: runtime_function_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_function_definitions (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    runtime_name text NOT NULL,
    throws_error boolean DEFAULT true NOT NULL,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    version text NOT NULL,
    signature text NOT NULL,
    definition_source text,
    display_icon text,
    runtime_module_id bigint NOT NULL,
    design text,
    CONSTRAINT check_4cf530fb6a CHECK ((char_length(definition_source) <= 50)),
    CONSTRAINT check_86da361565 CHECK ((char_length(signature) <= 500)),
    CONSTRAINT check_b25f98a584 CHECK ((char_length(design) <= 200)),
    CONSTRAINT check_ef62cf61e5 CHECK ((char_length(display_icon) <= 100)),
    CONSTRAINT check_fe8fff4f27 CHECK ((char_length(runtime_name) <= 50))
);


--
-- Name: runtime_function_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_function_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_function_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_function_definitions_id_seq OWNED BY public.runtime_function_definitions.id;


--
-- Name: runtime_module_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_module_definitions (
    id bigint NOT NULL,
    runtime_module_id bigint NOT NULL,
    host text NOT NULL,
    port bigint NOT NULL,
    endpoint text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    protocol text NOT NULL,
    CONSTRAINT check_5328b69b6f CHECK ((char_length(host) <= 253)),
    CONSTRAINT check_5a8231f609 CHECK ((char_length(endpoint) <= 2048)),
    CONSTRAINT check_cdbfabb698 CHECK ((char_length(protocol) <= 255))
);


--
-- Name: runtime_module_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_module_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_module_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_module_definitions_id_seq OWNED BY public.runtime_module_definitions.id;


--
-- Name: runtime_module_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_module_statuses (
    id bigint NOT NULL,
    runtime_module_id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    last_heartbeat timestamp with time zone,
    current_outage_started_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: runtime_module_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_module_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_module_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_module_statuses_id_seq OWNED BY public.runtime_module_statuses.id;


--
-- Name: runtime_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_modules (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    identifier text NOT NULL,
    documentation text DEFAULT ''::text NOT NULL,
    author text DEFAULT ''::text NOT NULL,
    icon text,
    version text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    definition_source text,
    CONSTRAINT check_1a843f8ec6 CHECK ((char_length(identifier) <= 50)),
    CONSTRAINT check_3f8395fc6a CHECK ((char_length(icon) <= 100)),
    CONSTRAINT check_436ae79860 CHECK ((char_length(definition_source) <= 50)),
    CONSTRAINT check_59e12f7f02 CHECK ((char_length(author) <= 200)),
    CONSTRAINT check_d169c23c07 CHECK ((char_length(documentation) <= 200))
);


--
-- Name: runtime_modules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_modules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_modules_id_seq OWNED BY public.runtime_modules.id;


--
-- Name: runtime_parameter_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_parameter_definitions (
    id bigint NOT NULL,
    runtime_function_definition_id bigint CONSTRAINT runtime_parameter_definitio_runtime_function_definitio_not_null NOT NULL,
    runtime_name text NOT NULL,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    default_value jsonb,
    optional boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    CONSTRAINT check_c1156ce358 CHECK ((char_length(runtime_name) <= 50))
);


--
-- Name: runtime_parameter_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_parameter_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_parameter_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_parameter_definitions_id_seq OWNED BY public.runtime_parameter_definitions.id;


--
-- Name: runtime_statuses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_statuses (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    last_heartbeat timestamp with time zone,
    current_outage_started_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: runtime_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_statuses_id_seq OWNED BY public.runtime_statuses.id;


--
-- Name: runtimes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtimes (
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


--
-- Name: runtimes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtimes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtimes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtimes_id_seq OWNED BY public.runtimes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sub_flow_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sub_flow_settings (
    id bigint NOT NULL,
    sub_flow_id bigint NOT NULL,
    identifier text NOT NULL,
    default_value jsonb,
    optional boolean DEFAULT false NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: sub_flow_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sub_flow_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sub_flow_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sub_flow_settings_id_seq OWNED BY public.sub_flow_settings.id;


--
-- Name: sub_flows; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sub_flows (
    id bigint NOT NULL,
    node_parameter_id bigint,
    starting_node_id bigint,
    function_definition_id bigint,
    signature text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    inline_reference_value_id bigint,
    CONSTRAINT check_53a99b1dd3 CHECK ((num_nonnulls(starting_node_id, function_definition_id) = 1)),
    CONSTRAINT check_943d01babb CHECK ((char_length(signature) <= 500)),
    CONSTRAINT check_e3ee180b07 CHECK ((num_nonnulls(node_parameter_id, inline_reference_value_id) = 1))
);


--
-- Name: sub_flows_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sub_flows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sub_flows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sub_flows_id_seq OWNED BY public.sub_flows.id;


--
-- Name: translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.translations (
    id bigint NOT NULL,
    code text NOT NULL,
    content text NOT NULL,
    owner_type character varying NOT NULL,
    owner_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    purpose text
);


--
-- Name: translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.translations_id_seq OWNED BY public.translations.id;


--
-- Name: user_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_identities (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    provider_id text NOT NULL,
    identifier text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: user_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_identities_id_seq OWNED BY public.user_identities.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
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
    email_verified_at timestamp with time zone,
    readme text,
    user_type integer DEFAULT 0 NOT NULL,
    blocked_at timestamp with time zone,
    CONSTRAINT check_11461c37fb CHECK ((char_length(readme) <= 5000)),
    CONSTRAINT check_3bedaaa612 CHECK ((char_length(email) <= 255)),
    CONSTRAINT check_56606ce552 CHECK ((char_length(username) <= 50)),
    CONSTRAINT check_60346c5299 CHECK ((char_length(lastname) <= 50)),
    CONSTRAINT check_d4bc21c175 CHECK ((char_length(firstname) <= 50))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: p_audit_events_Y2026M08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2026M08" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2026M09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2026M09" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2026M10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2026M10" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2026M11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2026M11" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2026M12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2026M12" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2027M01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2027M01" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2027M02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2027M02" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2027M03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_audit_events_Y2027M03" (
    id bigint DEFAULT nextval('public.p_audit_events_id_seq'::regclass) CONSTRAINT p_audit_events_id_not_null NOT NULL,
    author_id bigint CONSTRAINT p_audit_events_author_id_not_null NOT NULL,
    entity_id bigint CONSTRAINT p_audit_events_entity_id_not_null NOT NULL,
    entity_type text CONSTRAINT p_audit_events_entity_type_not_null NOT NULL,
    action_type integer CONSTRAINT p_audit_events_action_type_not_null NOT NULL,
    details jsonb CONSTRAINT p_audit_events_details_not_null NOT NULL,
    ip_address inet,
    target_id bigint CONSTRAINT p_audit_events_target_id_not_null NOT NULL,
    target_type text CONSTRAINT p_audit_events_target_type_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_audit_events_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_audit_events_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_node_results_Y2026M07D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M07D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M08D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_node_results_Y2026M09D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19" (
    id bigint DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass) CONSTRAINT p_execution_node_results_id_not_null NOT NULL,
    execution_result_id bigint CONSTRAINT p_execution_node_results_execution_result_id_not_null NOT NULL,
    node_function_id bigint,
    function_definition_id bigint,
    "position" integer CONSTRAINT p_execution_node_results_position_not_null NOT NULL,
    started_at bigint CONSTRAINT p_execution_node_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_node_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_node_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_node_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_63b54a1a28 CHECK ((num_nonnulls(success, error) <= 1))
);


--
-- Name: p_execution_parameter_results_Y2026M07D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D20" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D21" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D22" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D23" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D24" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D25" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D26" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D27" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D28" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D29" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D30" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M07D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D31" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D01" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D02" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D03" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D04" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D05" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D06" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D07" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D08" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D09" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D10" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D11" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D12" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D13" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D14" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D15" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D16" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D17" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D18" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D19" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D20" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D21" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D22" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D23" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D24" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D25" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D26" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D27" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D28" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D29" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D30" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M08D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D31" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D01" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D02" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D03" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D04" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D05" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D06" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D07" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D08" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D09" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D10" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D11" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D12" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D13" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D14" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D15" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D16" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D17" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D18" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_parameter_results_Y2026M09D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D19" (
    id bigint DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass) CONSTRAINT p_execution_parameter_results_id_not_null NOT NULL,
    execution_node_result_id bigint CONSTRAINT p_execution_parameter_results_execution_node_result_id_not_null NOT NULL,
    "position" integer CONSTRAINT p_execution_parameter_results_position_not_null NOT NULL,
    value jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_parameter_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_parameter_results_updated_at_not_null NOT NULL
);


--
-- Name: p_execution_results_Y2026M07D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D20" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D21" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D22" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D23" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D24" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D25" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D26" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D27" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D28" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D29" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D30" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M07D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M07D31" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D01" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D02" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D03" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D04" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D05" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D06" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D07" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D08" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D09" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D10" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D11" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D12" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D13" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D14" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D15" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D16" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D17" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D18" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D19" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D20" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D21" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D22" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D23" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D24" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D25" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D26" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D27" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D28" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D29" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D30" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M08D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M08D31" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D01" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D02" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D03" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D04" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D05" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D06" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D07" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D08" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D09" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D10" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D11" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D12" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D13" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D14" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D15" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D16" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D17" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D18" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_execution_results_Y2026M09D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_execution_results_Y2026M09D19" (
    id bigint DEFAULT nextval('public.p_execution_results_id_seq'::regclass) CONSTRAINT p_execution_results_id_not_null NOT NULL,
    flow_id bigint CONSTRAINT p_execution_results_flow_id_not_null NOT NULL,
    execution_identifier text CONSTRAINT p_execution_results_execution_identifier_not_null NOT NULL,
    input jsonb,
    started_at bigint CONSTRAINT p_execution_results_started_at_not_null NOT NULL,
    finished_at bigint CONSTRAINT p_execution_results_finished_at_not_null NOT NULL,
    success jsonb,
    error jsonb,
    created_at timestamp with time zone CONSTRAINT p_execution_results_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_execution_results_updated_at_not_null NOT NULL,
    CONSTRAINT check_0be3430b8f CHECK ((num_nonnulls(success, error) <= 1)),
    CONSTRAINT check_78e6af6e12 CHECK ((char_length(execution_identifier) <= 200))
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D05" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D06" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D07" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D08" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D09" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D10" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D11" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D12" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D13" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D14" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D15" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D16" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D17" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D18" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D19" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D20" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D21" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D22" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D23" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D24" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D25" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D26" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D27" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D28" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D29" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D30" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D31" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D01" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D02" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D03" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D04" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D05" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D06" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D07" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D08" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D09" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D10" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D11" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D12" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D13" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D14" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D15" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D16" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D17" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D18" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D19" (
    runtime_module_status_id bigint CONSTRAINT p_runtime_module_status_daily_runtime_module_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_module_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_module_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_module_status_daily_uptime_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_module_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D05" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D06" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D07" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D08" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D09" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D10" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D11" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D12" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D13" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D14" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D15" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D16" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D17" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D18" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D19" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D20; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D20" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D21; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D21" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D22; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D22" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D23; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D23" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D24; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D24" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D25; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D25" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D26; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D26" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D27; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D27" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D28; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D28" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D29; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D29" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D30; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D30" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D31; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D31" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D01; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D01" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D02; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D02" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D03; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D03" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D04; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D04" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D05; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D05" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D06; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D06" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D07; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D07" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D08; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D08" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D09; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D09" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D10; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D10" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D11; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D11" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D12; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D12" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D13; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D13" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D14; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D14" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D15; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D15" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D16; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D16" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D17; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D17" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D18; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D18" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D19; Type: TABLE; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE TABLE sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D19" (
    runtime_status_id bigint CONSTRAINT p_runtime_status_daily_uptimes_runtime_status_id_not_null NOT NULL,
    date date CONSTRAINT p_runtime_status_daily_uptimes_date_not_null NOT NULL,
    outage_seconds integer DEFAULT 0 CONSTRAINT p_runtime_status_daily_uptimes_outage_seconds_not_null NOT NULL,
    uptime_percentage numeric(5,2) DEFAULT 100.0 CONSTRAINT p_runtime_status_daily_uptimes_uptime_percentage_not_null NOT NULL,
    created_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_created_at_not_null NOT NULL,
    updated_at timestamp with time zone CONSTRAINT p_runtime_status_daily_uptimes_updated_at_not_null NOT NULL
);


--
-- Name: p_audit_events_Y2026M08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M08" FOR VALUES FROM ('2026-08-01 00:00:00+00') TO ('2026-09-01 00:00:00+00');


--
-- Name: p_audit_events_Y2026M09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M09" FOR VALUES FROM ('2026-09-01 00:00:00+00') TO ('2026-10-01 00:00:00+00');


--
-- Name: p_audit_events_Y2026M10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M10" FOR VALUES FROM ('2026-10-01 00:00:00+00') TO ('2026-11-01 00:00:00+00');


--
-- Name: p_audit_events_Y2026M11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M11" FOR VALUES FROM ('2026-11-01 00:00:00+00') TO ('2026-12-01 00:00:00+00');


--
-- Name: p_audit_events_Y2026M12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M12" FOR VALUES FROM ('2026-12-01 00:00:00+00') TO ('2027-01-01 00:00:00+00');


--
-- Name: p_audit_events_Y2027M01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M01" FOR VALUES FROM ('2027-01-01 00:00:00+00') TO ('2027-02-01 00:00:00+00');


--
-- Name: p_audit_events_Y2027M02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M02" FOR VALUES FROM ('2027-02-01 00:00:00+00') TO ('2027-03-01 00:00:00+00');


--
-- Name: p_audit_events_Y2027M03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M03" FOR VALUES FROM ('2027-03-01 00:00:00+00') TO ('2027-04-01 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20" FOR VALUES FROM ('2026-07-20 00:00:00+00') TO ('2026-07-21 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21" FOR VALUES FROM ('2026-07-21 00:00:00+00') TO ('2026-07-22 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22" FOR VALUES FROM ('2026-07-22 00:00:00+00') TO ('2026-07-23 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23" FOR VALUES FROM ('2026-07-23 00:00:00+00') TO ('2026-07-24 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24" FOR VALUES FROM ('2026-07-24 00:00:00+00') TO ('2026-07-25 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25" FOR VALUES FROM ('2026-07-25 00:00:00+00') TO ('2026-07-26 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26" FOR VALUES FROM ('2026-07-26 00:00:00+00') TO ('2026-07-27 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27" FOR VALUES FROM ('2026-07-27 00:00:00+00') TO ('2026-07-28 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28" FOR VALUES FROM ('2026-07-28 00:00:00+00') TO ('2026-07-29 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29" FOR VALUES FROM ('2026-07-29 00:00:00+00') TO ('2026-07-30 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30" FOR VALUES FROM ('2026-07-30 00:00:00+00') TO ('2026-07-31 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M07D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31" FOR VALUES FROM ('2026-07-31 00:00:00+00') TO ('2026-08-01 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01" FOR VALUES FROM ('2026-08-01 00:00:00+00') TO ('2026-08-02 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02" FOR VALUES FROM ('2026-08-02 00:00:00+00') TO ('2026-08-03 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03" FOR VALUES FROM ('2026-08-03 00:00:00+00') TO ('2026-08-04 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04" FOR VALUES FROM ('2026-08-04 00:00:00+00') TO ('2026-08-05 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05" FOR VALUES FROM ('2026-08-05 00:00:00+00') TO ('2026-08-06 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06" FOR VALUES FROM ('2026-08-06 00:00:00+00') TO ('2026-08-07 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07" FOR VALUES FROM ('2026-08-07 00:00:00+00') TO ('2026-08-08 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08" FOR VALUES FROM ('2026-08-08 00:00:00+00') TO ('2026-08-09 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09" FOR VALUES FROM ('2026-08-09 00:00:00+00') TO ('2026-08-10 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10" FOR VALUES FROM ('2026-08-10 00:00:00+00') TO ('2026-08-11 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11" FOR VALUES FROM ('2026-08-11 00:00:00+00') TO ('2026-08-12 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12" FOR VALUES FROM ('2026-08-12 00:00:00+00') TO ('2026-08-13 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13" FOR VALUES FROM ('2026-08-13 00:00:00+00') TO ('2026-08-14 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14" FOR VALUES FROM ('2026-08-14 00:00:00+00') TO ('2026-08-15 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15" FOR VALUES FROM ('2026-08-15 00:00:00+00') TO ('2026-08-16 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16" FOR VALUES FROM ('2026-08-16 00:00:00+00') TO ('2026-08-17 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17" FOR VALUES FROM ('2026-08-17 00:00:00+00') TO ('2026-08-18 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18" FOR VALUES FROM ('2026-08-18 00:00:00+00') TO ('2026-08-19 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19" FOR VALUES FROM ('2026-08-19 00:00:00+00') TO ('2026-08-20 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20" FOR VALUES FROM ('2026-08-20 00:00:00+00') TO ('2026-08-21 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21" FOR VALUES FROM ('2026-08-21 00:00:00+00') TO ('2026-08-22 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22" FOR VALUES FROM ('2026-08-22 00:00:00+00') TO ('2026-08-23 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23" FOR VALUES FROM ('2026-08-23 00:00:00+00') TO ('2026-08-24 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24" FOR VALUES FROM ('2026-08-24 00:00:00+00') TO ('2026-08-25 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25" FOR VALUES FROM ('2026-08-25 00:00:00+00') TO ('2026-08-26 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26" FOR VALUES FROM ('2026-08-26 00:00:00+00') TO ('2026-08-27 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27" FOR VALUES FROM ('2026-08-27 00:00:00+00') TO ('2026-08-28 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28" FOR VALUES FROM ('2026-08-28 00:00:00+00') TO ('2026-08-29 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29" FOR VALUES FROM ('2026-08-29 00:00:00+00') TO ('2026-08-30 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30" FOR VALUES FROM ('2026-08-30 00:00:00+00') TO ('2026-08-31 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M08D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31" FOR VALUES FROM ('2026-08-31 00:00:00+00') TO ('2026-09-01 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01" FOR VALUES FROM ('2026-09-01 00:00:00+00') TO ('2026-09-02 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02" FOR VALUES FROM ('2026-09-02 00:00:00+00') TO ('2026-09-03 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03" FOR VALUES FROM ('2026-09-03 00:00:00+00') TO ('2026-09-04 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04" FOR VALUES FROM ('2026-09-04 00:00:00+00') TO ('2026-09-05 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05" FOR VALUES FROM ('2026-09-05 00:00:00+00') TO ('2026-09-06 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06" FOR VALUES FROM ('2026-09-06 00:00:00+00') TO ('2026-09-07 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07" FOR VALUES FROM ('2026-09-07 00:00:00+00') TO ('2026-09-08 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08" FOR VALUES FROM ('2026-09-08 00:00:00+00') TO ('2026-09-09 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09" FOR VALUES FROM ('2026-09-09 00:00:00+00') TO ('2026-09-10 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10" FOR VALUES FROM ('2026-09-10 00:00:00+00') TO ('2026-09-11 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11" FOR VALUES FROM ('2026-09-11 00:00:00+00') TO ('2026-09-12 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12" FOR VALUES FROM ('2026-09-12 00:00:00+00') TO ('2026-09-13 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13" FOR VALUES FROM ('2026-09-13 00:00:00+00') TO ('2026-09-14 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14" FOR VALUES FROM ('2026-09-14 00:00:00+00') TO ('2026-09-15 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15" FOR VALUES FROM ('2026-09-15 00:00:00+00') TO ('2026-09-16 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16" FOR VALUES FROM ('2026-09-16 00:00:00+00') TO ('2026-09-17 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17" FOR VALUES FROM ('2026-09-17 00:00:00+00') TO ('2026-09-18 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18" FOR VALUES FROM ('2026-09-18 00:00:00+00') TO ('2026-09-19 00:00:00+00');


--
-- Name: p_execution_node_results_Y2026M09D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19" FOR VALUES FROM ('2026-09-19 00:00:00+00') TO ('2026-09-20 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D20" FOR VALUES FROM ('2026-07-20 00:00:00+00') TO ('2026-07-21 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D21" FOR VALUES FROM ('2026-07-21 00:00:00+00') TO ('2026-07-22 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D22" FOR VALUES FROM ('2026-07-22 00:00:00+00') TO ('2026-07-23 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D23" FOR VALUES FROM ('2026-07-23 00:00:00+00') TO ('2026-07-24 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D24" FOR VALUES FROM ('2026-07-24 00:00:00+00') TO ('2026-07-25 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D25" FOR VALUES FROM ('2026-07-25 00:00:00+00') TO ('2026-07-26 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D26" FOR VALUES FROM ('2026-07-26 00:00:00+00') TO ('2026-07-27 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D27" FOR VALUES FROM ('2026-07-27 00:00:00+00') TO ('2026-07-28 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D28" FOR VALUES FROM ('2026-07-28 00:00:00+00') TO ('2026-07-29 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D29" FOR VALUES FROM ('2026-07-29 00:00:00+00') TO ('2026-07-30 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D30" FOR VALUES FROM ('2026-07-30 00:00:00+00') TO ('2026-07-31 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M07D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D31" FOR VALUES FROM ('2026-07-31 00:00:00+00') TO ('2026-08-01 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D01" FOR VALUES FROM ('2026-08-01 00:00:00+00') TO ('2026-08-02 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D02" FOR VALUES FROM ('2026-08-02 00:00:00+00') TO ('2026-08-03 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D03" FOR VALUES FROM ('2026-08-03 00:00:00+00') TO ('2026-08-04 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D04" FOR VALUES FROM ('2026-08-04 00:00:00+00') TO ('2026-08-05 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D05" FOR VALUES FROM ('2026-08-05 00:00:00+00') TO ('2026-08-06 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D06" FOR VALUES FROM ('2026-08-06 00:00:00+00') TO ('2026-08-07 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D07" FOR VALUES FROM ('2026-08-07 00:00:00+00') TO ('2026-08-08 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D08" FOR VALUES FROM ('2026-08-08 00:00:00+00') TO ('2026-08-09 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D09" FOR VALUES FROM ('2026-08-09 00:00:00+00') TO ('2026-08-10 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D10" FOR VALUES FROM ('2026-08-10 00:00:00+00') TO ('2026-08-11 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D11" FOR VALUES FROM ('2026-08-11 00:00:00+00') TO ('2026-08-12 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D12" FOR VALUES FROM ('2026-08-12 00:00:00+00') TO ('2026-08-13 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D13" FOR VALUES FROM ('2026-08-13 00:00:00+00') TO ('2026-08-14 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D14" FOR VALUES FROM ('2026-08-14 00:00:00+00') TO ('2026-08-15 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D15" FOR VALUES FROM ('2026-08-15 00:00:00+00') TO ('2026-08-16 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D16" FOR VALUES FROM ('2026-08-16 00:00:00+00') TO ('2026-08-17 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D17" FOR VALUES FROM ('2026-08-17 00:00:00+00') TO ('2026-08-18 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D18" FOR VALUES FROM ('2026-08-18 00:00:00+00') TO ('2026-08-19 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D19" FOR VALUES FROM ('2026-08-19 00:00:00+00') TO ('2026-08-20 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D20" FOR VALUES FROM ('2026-08-20 00:00:00+00') TO ('2026-08-21 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D21" FOR VALUES FROM ('2026-08-21 00:00:00+00') TO ('2026-08-22 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D22" FOR VALUES FROM ('2026-08-22 00:00:00+00') TO ('2026-08-23 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D23" FOR VALUES FROM ('2026-08-23 00:00:00+00') TO ('2026-08-24 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D24" FOR VALUES FROM ('2026-08-24 00:00:00+00') TO ('2026-08-25 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D25" FOR VALUES FROM ('2026-08-25 00:00:00+00') TO ('2026-08-26 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D26" FOR VALUES FROM ('2026-08-26 00:00:00+00') TO ('2026-08-27 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D27" FOR VALUES FROM ('2026-08-27 00:00:00+00') TO ('2026-08-28 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D28" FOR VALUES FROM ('2026-08-28 00:00:00+00') TO ('2026-08-29 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D29" FOR VALUES FROM ('2026-08-29 00:00:00+00') TO ('2026-08-30 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D30" FOR VALUES FROM ('2026-08-30 00:00:00+00') TO ('2026-08-31 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M08D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D31" FOR VALUES FROM ('2026-08-31 00:00:00+00') TO ('2026-09-01 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D01" FOR VALUES FROM ('2026-09-01 00:00:00+00') TO ('2026-09-02 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D02" FOR VALUES FROM ('2026-09-02 00:00:00+00') TO ('2026-09-03 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D03" FOR VALUES FROM ('2026-09-03 00:00:00+00') TO ('2026-09-04 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D04" FOR VALUES FROM ('2026-09-04 00:00:00+00') TO ('2026-09-05 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D05" FOR VALUES FROM ('2026-09-05 00:00:00+00') TO ('2026-09-06 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D06" FOR VALUES FROM ('2026-09-06 00:00:00+00') TO ('2026-09-07 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D07" FOR VALUES FROM ('2026-09-07 00:00:00+00') TO ('2026-09-08 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D08" FOR VALUES FROM ('2026-09-08 00:00:00+00') TO ('2026-09-09 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D09" FOR VALUES FROM ('2026-09-09 00:00:00+00') TO ('2026-09-10 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D10" FOR VALUES FROM ('2026-09-10 00:00:00+00') TO ('2026-09-11 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D11" FOR VALUES FROM ('2026-09-11 00:00:00+00') TO ('2026-09-12 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D12" FOR VALUES FROM ('2026-09-12 00:00:00+00') TO ('2026-09-13 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D13" FOR VALUES FROM ('2026-09-13 00:00:00+00') TO ('2026-09-14 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D14" FOR VALUES FROM ('2026-09-14 00:00:00+00') TO ('2026-09-15 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D15" FOR VALUES FROM ('2026-09-15 00:00:00+00') TO ('2026-09-16 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D16" FOR VALUES FROM ('2026-09-16 00:00:00+00') TO ('2026-09-17 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D17" FOR VALUES FROM ('2026-09-17 00:00:00+00') TO ('2026-09-18 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D18" FOR VALUES FROM ('2026-09-18 00:00:00+00') TO ('2026-09-19 00:00:00+00');


--
-- Name: p_execution_parameter_results_Y2026M09D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D19" FOR VALUES FROM ('2026-09-19 00:00:00+00') TO ('2026-09-20 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D20" FOR VALUES FROM ('2026-07-20 00:00:00+00') TO ('2026-07-21 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D21" FOR VALUES FROM ('2026-07-21 00:00:00+00') TO ('2026-07-22 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D22" FOR VALUES FROM ('2026-07-22 00:00:00+00') TO ('2026-07-23 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D23" FOR VALUES FROM ('2026-07-23 00:00:00+00') TO ('2026-07-24 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D24" FOR VALUES FROM ('2026-07-24 00:00:00+00') TO ('2026-07-25 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D25" FOR VALUES FROM ('2026-07-25 00:00:00+00') TO ('2026-07-26 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D26" FOR VALUES FROM ('2026-07-26 00:00:00+00') TO ('2026-07-27 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D27" FOR VALUES FROM ('2026-07-27 00:00:00+00') TO ('2026-07-28 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D28" FOR VALUES FROM ('2026-07-28 00:00:00+00') TO ('2026-07-29 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D29" FOR VALUES FROM ('2026-07-29 00:00:00+00') TO ('2026-07-30 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D30" FOR VALUES FROM ('2026-07-30 00:00:00+00') TO ('2026-07-31 00:00:00+00');


--
-- Name: p_execution_results_Y2026M07D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D31" FOR VALUES FROM ('2026-07-31 00:00:00+00') TO ('2026-08-01 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D01" FOR VALUES FROM ('2026-08-01 00:00:00+00') TO ('2026-08-02 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D02" FOR VALUES FROM ('2026-08-02 00:00:00+00') TO ('2026-08-03 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D03" FOR VALUES FROM ('2026-08-03 00:00:00+00') TO ('2026-08-04 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D04" FOR VALUES FROM ('2026-08-04 00:00:00+00') TO ('2026-08-05 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D05" FOR VALUES FROM ('2026-08-05 00:00:00+00') TO ('2026-08-06 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D06" FOR VALUES FROM ('2026-08-06 00:00:00+00') TO ('2026-08-07 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D07" FOR VALUES FROM ('2026-08-07 00:00:00+00') TO ('2026-08-08 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D08" FOR VALUES FROM ('2026-08-08 00:00:00+00') TO ('2026-08-09 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D09" FOR VALUES FROM ('2026-08-09 00:00:00+00') TO ('2026-08-10 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D10" FOR VALUES FROM ('2026-08-10 00:00:00+00') TO ('2026-08-11 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D11" FOR VALUES FROM ('2026-08-11 00:00:00+00') TO ('2026-08-12 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D12" FOR VALUES FROM ('2026-08-12 00:00:00+00') TO ('2026-08-13 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D13" FOR VALUES FROM ('2026-08-13 00:00:00+00') TO ('2026-08-14 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D14" FOR VALUES FROM ('2026-08-14 00:00:00+00') TO ('2026-08-15 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D15" FOR VALUES FROM ('2026-08-15 00:00:00+00') TO ('2026-08-16 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D16" FOR VALUES FROM ('2026-08-16 00:00:00+00') TO ('2026-08-17 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D17" FOR VALUES FROM ('2026-08-17 00:00:00+00') TO ('2026-08-18 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D18" FOR VALUES FROM ('2026-08-18 00:00:00+00') TO ('2026-08-19 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D19" FOR VALUES FROM ('2026-08-19 00:00:00+00') TO ('2026-08-20 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D20" FOR VALUES FROM ('2026-08-20 00:00:00+00') TO ('2026-08-21 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D21" FOR VALUES FROM ('2026-08-21 00:00:00+00') TO ('2026-08-22 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D22" FOR VALUES FROM ('2026-08-22 00:00:00+00') TO ('2026-08-23 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D23" FOR VALUES FROM ('2026-08-23 00:00:00+00') TO ('2026-08-24 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D24" FOR VALUES FROM ('2026-08-24 00:00:00+00') TO ('2026-08-25 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D25" FOR VALUES FROM ('2026-08-25 00:00:00+00') TO ('2026-08-26 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D26" FOR VALUES FROM ('2026-08-26 00:00:00+00') TO ('2026-08-27 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D27" FOR VALUES FROM ('2026-08-27 00:00:00+00') TO ('2026-08-28 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D28" FOR VALUES FROM ('2026-08-28 00:00:00+00') TO ('2026-08-29 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D29" FOR VALUES FROM ('2026-08-29 00:00:00+00') TO ('2026-08-30 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D30" FOR VALUES FROM ('2026-08-30 00:00:00+00') TO ('2026-08-31 00:00:00+00');


--
-- Name: p_execution_results_Y2026M08D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D31" FOR VALUES FROM ('2026-08-31 00:00:00+00') TO ('2026-09-01 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D01" FOR VALUES FROM ('2026-09-01 00:00:00+00') TO ('2026-09-02 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D02" FOR VALUES FROM ('2026-09-02 00:00:00+00') TO ('2026-09-03 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D03" FOR VALUES FROM ('2026-09-03 00:00:00+00') TO ('2026-09-04 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D04" FOR VALUES FROM ('2026-09-04 00:00:00+00') TO ('2026-09-05 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D05" FOR VALUES FROM ('2026-09-05 00:00:00+00') TO ('2026-09-06 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D06" FOR VALUES FROM ('2026-09-06 00:00:00+00') TO ('2026-09-07 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D07" FOR VALUES FROM ('2026-09-07 00:00:00+00') TO ('2026-09-08 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D08" FOR VALUES FROM ('2026-09-08 00:00:00+00') TO ('2026-09-09 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D09" FOR VALUES FROM ('2026-09-09 00:00:00+00') TO ('2026-09-10 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D10" FOR VALUES FROM ('2026-09-10 00:00:00+00') TO ('2026-09-11 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D11" FOR VALUES FROM ('2026-09-11 00:00:00+00') TO ('2026-09-12 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D12" FOR VALUES FROM ('2026-09-12 00:00:00+00') TO ('2026-09-13 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D13" FOR VALUES FROM ('2026-09-13 00:00:00+00') TO ('2026-09-14 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D14" FOR VALUES FROM ('2026-09-14 00:00:00+00') TO ('2026-09-15 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D15" FOR VALUES FROM ('2026-09-15 00:00:00+00') TO ('2026-09-16 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D16" FOR VALUES FROM ('2026-09-16 00:00:00+00') TO ('2026-09-17 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D17" FOR VALUES FROM ('2026-09-17 00:00:00+00') TO ('2026-09-18 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D18" FOR VALUES FROM ('2026-09-18 00:00:00+00') TO ('2026-09-19 00:00:00+00');


--
-- Name: p_execution_results_Y2026M09D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D19" FOR VALUES FROM ('2026-09-19 00:00:00+00') TO ('2026-09-20 00:00:00+00');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D05" FOR VALUES FROM ('2026-08-05') TO ('2026-08-06');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D06" FOR VALUES FROM ('2026-08-06') TO ('2026-08-07');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D07" FOR VALUES FROM ('2026-08-07') TO ('2026-08-08');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D08" FOR VALUES FROM ('2026-08-08') TO ('2026-08-09');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D09" FOR VALUES FROM ('2026-08-09') TO ('2026-08-10');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D10" FOR VALUES FROM ('2026-08-10') TO ('2026-08-11');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D11" FOR VALUES FROM ('2026-08-11') TO ('2026-08-12');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D12" FOR VALUES FROM ('2026-08-12') TO ('2026-08-13');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D13" FOR VALUES FROM ('2026-08-13') TO ('2026-08-14');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D14" FOR VALUES FROM ('2026-08-14') TO ('2026-08-15');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D15" FOR VALUES FROM ('2026-08-15') TO ('2026-08-16');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D16" FOR VALUES FROM ('2026-08-16') TO ('2026-08-17');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D17" FOR VALUES FROM ('2026-08-17') TO ('2026-08-18');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D18" FOR VALUES FROM ('2026-08-18') TO ('2026-08-19');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D19" FOR VALUES FROM ('2026-08-19') TO ('2026-08-20');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D20" FOR VALUES FROM ('2026-08-20') TO ('2026-08-21');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D21" FOR VALUES FROM ('2026-08-21') TO ('2026-08-22');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D22" FOR VALUES FROM ('2026-08-22') TO ('2026-08-23');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D23" FOR VALUES FROM ('2026-08-23') TO ('2026-08-24');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D24" FOR VALUES FROM ('2026-08-24') TO ('2026-08-25');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D25" FOR VALUES FROM ('2026-08-25') TO ('2026-08-26');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D26" FOR VALUES FROM ('2026-08-26') TO ('2026-08-27');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D27" FOR VALUES FROM ('2026-08-27') TO ('2026-08-28');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D28" FOR VALUES FROM ('2026-08-28') TO ('2026-08-29');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D29" FOR VALUES FROM ('2026-08-29') TO ('2026-08-30');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D30" FOR VALUES FROM ('2026-08-30') TO ('2026-08-31');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D31" FOR VALUES FROM ('2026-08-31') TO ('2026-09-01');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D01" FOR VALUES FROM ('2026-09-01') TO ('2026-09-02');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D02" FOR VALUES FROM ('2026-09-02') TO ('2026-09-03');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D03" FOR VALUES FROM ('2026-09-03') TO ('2026-09-04');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D04" FOR VALUES FROM ('2026-09-04') TO ('2026-09-05');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D05" FOR VALUES FROM ('2026-09-05') TO ('2026-09-06');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D06" FOR VALUES FROM ('2026-09-06') TO ('2026-09-07');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D07" FOR VALUES FROM ('2026-09-07') TO ('2026-09-08');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D08" FOR VALUES FROM ('2026-09-08') TO ('2026-09-09');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D09" FOR VALUES FROM ('2026-09-09') TO ('2026-09-10');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D10" FOR VALUES FROM ('2026-09-10') TO ('2026-09-11');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D11" FOR VALUES FROM ('2026-09-11') TO ('2026-09-12');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D12" FOR VALUES FROM ('2026-09-12') TO ('2026-09-13');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D13" FOR VALUES FROM ('2026-09-13') TO ('2026-09-14');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D14" FOR VALUES FROM ('2026-09-14') TO ('2026-09-15');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D15" FOR VALUES FROM ('2026-09-15') TO ('2026-09-16');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D16" FOR VALUES FROM ('2026-09-16') TO ('2026-09-17');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D17" FOR VALUES FROM ('2026-09-17') TO ('2026-09-18');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D18" FOR VALUES FROM ('2026-09-18') TO ('2026-09-19');


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D19" FOR VALUES FROM ('2026-09-19') TO ('2026-09-20');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D05" FOR VALUES FROM ('2026-08-05') TO ('2026-08-06');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D06" FOR VALUES FROM ('2026-08-06') TO ('2026-08-07');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D07" FOR VALUES FROM ('2026-08-07') TO ('2026-08-08');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D08" FOR VALUES FROM ('2026-08-08') TO ('2026-08-09');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D09" FOR VALUES FROM ('2026-08-09') TO ('2026-08-10');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D10" FOR VALUES FROM ('2026-08-10') TO ('2026-08-11');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D11" FOR VALUES FROM ('2026-08-11') TO ('2026-08-12');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D12" FOR VALUES FROM ('2026-08-12') TO ('2026-08-13');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D13" FOR VALUES FROM ('2026-08-13') TO ('2026-08-14');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D14" FOR VALUES FROM ('2026-08-14') TO ('2026-08-15');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D15" FOR VALUES FROM ('2026-08-15') TO ('2026-08-16');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D16" FOR VALUES FROM ('2026-08-16') TO ('2026-08-17');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D17" FOR VALUES FROM ('2026-08-17') TO ('2026-08-18');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D18" FOR VALUES FROM ('2026-08-18') TO ('2026-08-19');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D19" FOR VALUES FROM ('2026-08-19') TO ('2026-08-20');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D20; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D20" FOR VALUES FROM ('2026-08-20') TO ('2026-08-21');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D21; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D21" FOR VALUES FROM ('2026-08-21') TO ('2026-08-22');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D22; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D22" FOR VALUES FROM ('2026-08-22') TO ('2026-08-23');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D23; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D23" FOR VALUES FROM ('2026-08-23') TO ('2026-08-24');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D24; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D24" FOR VALUES FROM ('2026-08-24') TO ('2026-08-25');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D25; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D25" FOR VALUES FROM ('2026-08-25') TO ('2026-08-26');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D26; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D26" FOR VALUES FROM ('2026-08-26') TO ('2026-08-27');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D27; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D27" FOR VALUES FROM ('2026-08-27') TO ('2026-08-28');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D28; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D28" FOR VALUES FROM ('2026-08-28') TO ('2026-08-29');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D29; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D29" FOR VALUES FROM ('2026-08-29') TO ('2026-08-30');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D30; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D30" FOR VALUES FROM ('2026-08-30') TO ('2026-08-31');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D31; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D31" FOR VALUES FROM ('2026-08-31') TO ('2026-09-01');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D01; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D01" FOR VALUES FROM ('2026-09-01') TO ('2026-09-02');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D02; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D02" FOR VALUES FROM ('2026-09-02') TO ('2026-09-03');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D03; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D03" FOR VALUES FROM ('2026-09-03') TO ('2026-09-04');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D04; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D04" FOR VALUES FROM ('2026-09-04') TO ('2026-09-05');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D05; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D05" FOR VALUES FROM ('2026-09-05') TO ('2026-09-06');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D06; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D06" FOR VALUES FROM ('2026-09-06') TO ('2026-09-07');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D07; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D07" FOR VALUES FROM ('2026-09-07') TO ('2026-09-08');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D08; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D08" FOR VALUES FROM ('2026-09-08') TO ('2026-09-09');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D09; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D09" FOR VALUES FROM ('2026-09-09') TO ('2026-09-10');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D10; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D10" FOR VALUES FROM ('2026-09-10') TO ('2026-09-11');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D11; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D11" FOR VALUES FROM ('2026-09-11') TO ('2026-09-12');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D12; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D12" FOR VALUES FROM ('2026-09-12') TO ('2026-09-13');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D13; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D13" FOR VALUES FROM ('2026-09-13') TO ('2026-09-14');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D14; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D14" FOR VALUES FROM ('2026-09-14') TO ('2026-09-15');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D15; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D15" FOR VALUES FROM ('2026-09-15') TO ('2026-09-16');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D16; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D16" FOR VALUES FROM ('2026-09-16') TO ('2026-09-17');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D17; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D17" FOR VALUES FROM ('2026-09-17') TO ('2026-09-18');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D18; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D18" FOR VALUES FROM ('2026-09-18') TO ('2026-09-19');


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D19; Type: TABLE ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D19" FOR VALUES FROM ('2026-09-19') TO ('2026-09-20');


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: application_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings ALTER COLUMN id SET DEFAULT nextval('public.application_settings_id_seq'::regclass);


--
-- Name: backup_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_codes ALTER COLUMN id SET DEFAULT nextval('public.backup_codes_id_seq'::regclass);


--
-- Name: data_type_data_type_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_data_type_links ALTER COLUMN id SET DEFAULT nextval('public.data_type_data_type_links_id_seq'::regclass);


--
-- Name: data_type_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_rules ALTER COLUMN id SET DEFAULT nextval('public.data_type_rules_id_seq'::regclass);


--
-- Name: data_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types ALTER COLUMN id SET DEFAULT nextval('public.data_types_id_seq'::regclass);


--
-- Name: flow_data_type_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_data_type_links ALTER COLUMN id SET DEFAULT nextval('public.flow_data_type_links_id_seq'::regclass);


--
-- Name: flow_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_settings ALTER COLUMN id SET DEFAULT nextval('public.flow_settings_id_seq'::regclass);


--
-- Name: flow_type_data_type_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_data_type_links ALTER COLUMN id SET DEFAULT nextval('public.flow_type_data_type_links_id_seq'::regclass);


--
-- Name: flow_type_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_settings ALTER COLUMN id SET DEFAULT nextval('public.flow_type_settings_id_seq'::regclass);


--
-- Name: flow_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types ALTER COLUMN id SET DEFAULT nextval('public.flow_types_id_seq'::regclass);


--
-- Name: flows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows ALTER COLUMN id SET DEFAULT nextval('public.flows_id_seq'::regclass);


--
-- Name: function_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions ALTER COLUMN id SET DEFAULT nextval('public.function_definitions_id_seq'::regclass);


--
-- Name: inline_reference_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inline_reference_values ALTER COLUMN id SET DEFAULT nextval('public.inline_reference_values_id_seq'::regclass);


--
-- Name: licenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licenses ALTER COLUMN id SET DEFAULT nextval('public.licenses_id_seq'::regclass);


--
-- Name: module_configuration_definition_data_type_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definition_data_type_links ALTER COLUMN id SET DEFAULT nextval('public.module_configuration_definition_data_type_links_id_seq'::regclass);


--
-- Name: module_configuration_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definitions ALTER COLUMN id SET DEFAULT nextval('public.module_configuration_definitions_id_seq'::regclass);


--
-- Name: module_configurations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configurations ALTER COLUMN id SET DEFAULT nextval('public.module_configurations_id_seq'::regclass);


--
-- Name: namespace_member_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_member_roles ALTER COLUMN id SET DEFAULT nextval('public.namespace_member_roles_id_seq'::regclass);


--
-- Name: namespace_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_members ALTER COLUMN id SET DEFAULT nextval('public.namespace_members_id_seq'::regclass);


--
-- Name: namespace_project_runtime_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_project_runtime_assignments ALTER COLUMN id SET DEFAULT nextval('public.namespace_project_runtime_assignments_id_seq'::regclass);


--
-- Name: namespace_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_projects ALTER COLUMN id SET DEFAULT nextval('public.namespace_projects_id_seq'::regclass);


--
-- Name: namespace_role_abilities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_abilities ALTER COLUMN id SET DEFAULT nextval('public.namespace_role_abilities_id_seq'::regclass);


--
-- Name: namespace_role_project_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_project_assignments ALTER COLUMN id SET DEFAULT nextval('public.namespace_role_project_assignments_id_seq'::regclass);


--
-- Name: namespace_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_roles ALTER COLUMN id SET DEFAULT nextval('public.namespace_roles_id_seq'::regclass);


--
-- Name: namespaces id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces ALTER COLUMN id SET DEFAULT nextval('public.namespaces_id_seq'::regclass);


--
-- Name: node_functions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions ALTER COLUMN id SET DEFAULT nextval('public.node_functions_id_seq'::regclass);


--
-- Name: node_parameters id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters ALTER COLUMN id SET DEFAULT nextval('public.node_parameters_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: p_audit_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_audit_events ALTER COLUMN id SET DEFAULT nextval('public.p_audit_events_id_seq'::regclass);


--
-- Name: p_execution_node_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results ALTER COLUMN id SET DEFAULT nextval('public.p_execution_node_results_id_seq'::regclass);


--
-- Name: p_execution_parameter_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results ALTER COLUMN id SET DEFAULT nextval('public.p_execution_parameter_results_id_seq'::regclass);


--
-- Name: p_execution_results id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_execution_results ALTER COLUMN id SET DEFAULT nextval('public.p_execution_results_id_seq'::regclass);


--
-- Name: parameter_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_definitions ALTER COLUMN id SET DEFAULT nextval('public.parameter_definitions_id_seq'::regclass);


--
-- Name: reference_paths id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_paths ALTER COLUMN id SET DEFAULT nextval('public.reference_paths_id_seq'::regclass);


--
-- Name: reference_values id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_values ALTER COLUMN id SET DEFAULT nextval('public.reference_values_id_seq'::regclass);


--
-- Name: runtime_flow_type_data_type_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_data_type_links ALTER COLUMN id SET DEFAULT nextval('public.runtime_flow_type_data_type_links_id_seq'::regclass);


--
-- Name: runtime_flow_type_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_settings ALTER COLUMN id SET DEFAULT nextval('public.runtime_flow_type_settings_id_seq'::regclass);


--
-- Name: runtime_flow_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_types ALTER COLUMN id SET DEFAULT nextval('public.runtime_flow_types_id_seq'::regclass);


--
-- Name: runtime_function_definition_data_type_links id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_data_type_links ALTER COLUMN id SET DEFAULT nextval('public.runtime_function_definition_data_type_links_id_seq'::regclass);


--
-- Name: runtime_function_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions ALTER COLUMN id SET DEFAULT nextval('public.runtime_function_definitions_id_seq'::regclass);


--
-- Name: runtime_module_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_module_definitions ALTER COLUMN id SET DEFAULT nextval('public.runtime_module_definitions_id_seq'::regclass);


--
-- Name: runtime_module_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_module_statuses ALTER COLUMN id SET DEFAULT nextval('public.runtime_module_statuses_id_seq'::regclass);


--
-- Name: runtime_modules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_modules ALTER COLUMN id SET DEFAULT nextval('public.runtime_modules_id_seq'::regclass);


--
-- Name: runtime_parameter_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions ALTER COLUMN id SET DEFAULT nextval('public.runtime_parameter_definitions_id_seq'::regclass);


--
-- Name: runtime_statuses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_statuses ALTER COLUMN id SET DEFAULT nextval('public.runtime_statuses_id_seq'::regclass);


--
-- Name: runtimes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtimes ALTER COLUMN id SET DEFAULT nextval('public.runtimes_id_seq'::regclass);


--
-- Name: sub_flow_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flow_settings ALTER COLUMN id SET DEFAULT nextval('public.sub_flow_settings_id_seq'::regclass);


--
-- Name: sub_flows id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flows ALTER COLUMN id SET DEFAULT nextval('public.sub_flows_id_seq'::regclass);


--
-- Name: translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.translations ALTER COLUMN id SET DEFAULT nextval('public.translations_id_seq'::regclass);


--
-- Name: user_identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_identities ALTER COLUMN id SET DEFAULT nextval('public.user_identities_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: application_settings application_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.application_settings
    ADD CONSTRAINT application_settings_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: backup_codes backup_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_codes
    ADD CONSTRAINT backup_codes_pkey PRIMARY KEY (id);


--
-- Name: data_type_data_type_links data_type_data_type_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_data_type_links
    ADD CONSTRAINT data_type_data_type_links_pkey PRIMARY KEY (id);


--
-- Name: data_type_rules data_type_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_rules
    ADD CONSTRAINT data_type_rules_pkey PRIMARY KEY (id);


--
-- Name: data_types data_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT data_types_pkey PRIMARY KEY (id);


--
-- Name: flow_data_type_links flow_data_type_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_data_type_links
    ADD CONSTRAINT flow_data_type_links_pkey PRIMARY KEY (id);


--
-- Name: flow_settings flow_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_settings
    ADD CONSTRAINT flow_settings_pkey PRIMARY KEY (id);


--
-- Name: flow_type_data_type_links flow_type_data_type_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_data_type_links
    ADD CONSTRAINT flow_type_data_type_links_pkey PRIMARY KEY (id);


--
-- Name: flow_type_settings flow_type_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_settings
    ADD CONSTRAINT flow_type_settings_pkey PRIMARY KEY (id);


--
-- Name: flow_types flow_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types
    ADD CONSTRAINT flow_types_pkey PRIMARY KEY (id);


--
-- Name: flows flows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT flows_pkey PRIMARY KEY (id);


--
-- Name: function_definitions function_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions
    ADD CONSTRAINT function_definitions_pkey PRIMARY KEY (id);


--
-- Name: good_job_batches good_job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_batches
    ADD CONSTRAINT good_job_batches_pkey PRIMARY KEY (id);


--
-- Name: good_job_executions good_job_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_executions
    ADD CONSTRAINT good_job_executions_pkey PRIMARY KEY (id);


--
-- Name: good_job_processes good_job_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_processes
    ADD CONSTRAINT good_job_processes_pkey PRIMARY KEY (id);


--
-- Name: good_job_settings good_job_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_job_settings
    ADD CONSTRAINT good_job_settings_pkey PRIMARY KEY (id);


--
-- Name: good_jobs good_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.good_jobs
    ADD CONSTRAINT good_jobs_pkey PRIMARY KEY (id);


--
-- Name: inline_reference_values inline_reference_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inline_reference_values
    ADD CONSTRAINT inline_reference_values_pkey PRIMARY KEY (id);


--
-- Name: licenses licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT licenses_pkey PRIMARY KEY (id);


--
-- Name: module_configuration_definition_data_type_links module_configuration_definition_data_type_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definition_data_type_links
    ADD CONSTRAINT module_configuration_definition_data_type_links_pkey PRIMARY KEY (id);


--
-- Name: module_configuration_definitions module_configuration_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definitions
    ADD CONSTRAINT module_configuration_definitions_pkey PRIMARY KEY (id);


--
-- Name: module_configurations module_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configurations
    ADD CONSTRAINT module_configurations_pkey PRIMARY KEY (id);


--
-- Name: namespace_member_roles namespace_member_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_member_roles
    ADD CONSTRAINT namespace_member_roles_pkey PRIMARY KEY (id);


--
-- Name: namespace_members namespace_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_members
    ADD CONSTRAINT namespace_members_pkey PRIMARY KEY (id);


--
-- Name: namespace_project_runtime_assignments namespace_project_runtime_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_project_runtime_assignments
    ADD CONSTRAINT namespace_project_runtime_assignments_pkey PRIMARY KEY (id);


--
-- Name: namespace_projects namespace_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_projects
    ADD CONSTRAINT namespace_projects_pkey PRIMARY KEY (id);


--
-- Name: namespace_role_abilities namespace_role_abilities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_abilities
    ADD CONSTRAINT namespace_role_abilities_pkey PRIMARY KEY (id);


--
-- Name: namespace_role_project_assignments namespace_role_project_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_project_assignments
    ADD CONSTRAINT namespace_role_project_assignments_pkey PRIMARY KEY (id);


--
-- Name: namespace_roles namespace_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_roles
    ADD CONSTRAINT namespace_roles_pkey PRIMARY KEY (id);


--
-- Name: namespaces namespaces_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespaces
    ADD CONSTRAINT namespaces_pkey PRIMARY KEY (id);


--
-- Name: node_functions node_functions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions
    ADD CONSTRAINT node_functions_pkey PRIMARY KEY (id);


--
-- Name: node_parameters node_parameters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT node_parameters_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: p_application_usage_daily_aggregates p_application_usage_daily_aggregates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_application_usage_daily_aggregates
    ADD CONSTRAINT p_application_usage_daily_aggregates_pkey PRIMARY KEY (date);


--
-- Name: p_audit_events p_audit_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_audit_events
    ADD CONSTRAINT p_audit_events_pkey PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results p_execution_node_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_execution_node_results
    ADD CONSTRAINT p_execution_node_results_pkey PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results p_execution_parameter_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_execution_parameter_results
    ADD CONSTRAINT p_execution_parameter_results_pkey PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results p_execution_results_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_execution_results
    ADD CONSTRAINT p_execution_results_pkey PRIMARY KEY (id, created_at);


--
-- Name: p_flow_usage_daily_aggregates p_flow_usage_daily_aggregates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_flow_usage_daily_aggregates
    ADD CONSTRAINT p_flow_usage_daily_aggregates_pkey PRIMARY KEY (flow_id, date);


--
-- Name: p_namespace_project_usage_daily_aggregates p_namespace_project_usage_daily_aggregates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_namespace_project_usage_daily_aggregates
    ADD CONSTRAINT p_namespace_project_usage_daily_aggregates_pkey PRIMARY KEY (project_id, date);


--
-- Name: p_namespace_usage_daily_aggregates p_namespace_usage_daily_aggregates_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_namespace_usage_daily_aggregates
    ADD CONSTRAINT p_namespace_usage_daily_aggregates_pkey PRIMARY KEY (namespace_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes p_runtime_module_status_daily_uptimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_runtime_module_status_daily_uptimes
    ADD CONSTRAINT p_runtime_module_status_daily_uptimes_pkey PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes p_runtime_status_daily_uptimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.p_runtime_status_daily_uptimes
    ADD CONSTRAINT p_runtime_status_daily_uptimes_pkey PRIMARY KEY (runtime_status_id, date);


--
-- Name: parameter_definitions parameter_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_definitions
    ADD CONSTRAINT parameter_definitions_pkey PRIMARY KEY (id);


--
-- Name: reference_paths reference_paths_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_paths
    ADD CONSTRAINT reference_paths_pkey PRIMARY KEY (id);


--
-- Name: reference_values reference_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_values
    ADD CONSTRAINT reference_values_pkey PRIMARY KEY (id);


--
-- Name: runtime_flow_type_data_type_links runtime_flow_type_data_type_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_data_type_links
    ADD CONSTRAINT runtime_flow_type_data_type_links_pkey PRIMARY KEY (id);


--
-- Name: runtime_flow_type_settings runtime_flow_type_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_settings
    ADD CONSTRAINT runtime_flow_type_settings_pkey PRIMARY KEY (id);


--
-- Name: runtime_flow_types runtime_flow_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_types
    ADD CONSTRAINT runtime_flow_types_pkey PRIMARY KEY (id);


--
-- Name: runtime_function_definition_data_type_links runtime_function_definition_data_type_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_data_type_links
    ADD CONSTRAINT runtime_function_definition_data_type_links_pkey PRIMARY KEY (id);


--
-- Name: runtime_function_definitions runtime_function_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions
    ADD CONSTRAINT runtime_function_definitions_pkey PRIMARY KEY (id);


--
-- Name: runtime_module_definitions runtime_module_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_module_definitions
    ADD CONSTRAINT runtime_module_definitions_pkey PRIMARY KEY (id);


--
-- Name: runtime_module_statuses runtime_module_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_module_statuses
    ADD CONSTRAINT runtime_module_statuses_pkey PRIMARY KEY (id);


--
-- Name: runtime_modules runtime_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_modules
    ADD CONSTRAINT runtime_modules_pkey PRIMARY KEY (id);


--
-- Name: runtime_parameter_definitions runtime_parameter_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions
    ADD CONSTRAINT runtime_parameter_definitions_pkey PRIMARY KEY (id);


--
-- Name: runtime_statuses runtime_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_statuses
    ADD CONSTRAINT runtime_statuses_pkey PRIMARY KEY (id);


--
-- Name: runtimes runtimes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtimes
    ADD CONSTRAINT runtimes_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sub_flow_settings sub_flow_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flow_settings
    ADD CONSTRAINT sub_flow_settings_pkey PRIMARY KEY (id);


--
-- Name: sub_flows sub_flows_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flows
    ADD CONSTRAINT sub_flows_pkey PRIMARY KEY (id);


--
-- Name: translations translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.translations
    ADD CONSTRAINT translations_pkey PRIMARY KEY (id);


--
-- Name: user_identities user_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_identities
    ADD CONSTRAINT user_identities_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: p_audit_events_Y2026M08 p_audit_events_Y2026M08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2026M08"
    ADD CONSTRAINT "p_audit_events_Y2026M08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2026M09 p_audit_events_Y2026M09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2026M09"
    ADD CONSTRAINT "p_audit_events_Y2026M09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2026M10 p_audit_events_Y2026M10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2026M10"
    ADD CONSTRAINT "p_audit_events_Y2026M10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2026M11 p_audit_events_Y2026M11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2026M11"
    ADD CONSTRAINT "p_audit_events_Y2026M11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2026M12 p_audit_events_Y2026M12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2026M12"
    ADD CONSTRAINT "p_audit_events_Y2026M12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2027M01 p_audit_events_Y2027M01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2027M01"
    ADD CONSTRAINT "p_audit_events_Y2027M01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2027M02 p_audit_events_Y2027M02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2027M02"
    ADD CONSTRAINT "p_audit_events_Y2027M02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_audit_events_Y2027M03 p_audit_events_Y2027M03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_audit_events_Y2027M03"
    ADD CONSTRAINT "p_audit_events_Y2027M03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D20 p_execution_node_results_Y2026M07D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D20_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D21 p_execution_node_results_Y2026M07D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D21_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D22 p_execution_node_results_Y2026M07D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D22_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D23 p_execution_node_results_Y2026M07D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D23_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D24 p_execution_node_results_Y2026M07D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D24_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D25 p_execution_node_results_Y2026M07D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D25_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D26 p_execution_node_results_Y2026M07D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D26_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D27 p_execution_node_results_Y2026M07D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D27_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D28 p_execution_node_results_Y2026M07D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D28_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D29 p_execution_node_results_Y2026M07D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D29_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D30 p_execution_node_results_Y2026M07D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D30_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M07D31 p_execution_node_results_Y2026M07D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31"
    ADD CONSTRAINT "p_execution_node_results_Y2026M07D31_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D01 p_execution_node_results_Y2026M08D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D02 p_execution_node_results_Y2026M08D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D03 p_execution_node_results_Y2026M08D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D04 p_execution_node_results_Y2026M08D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D04_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D05 p_execution_node_results_Y2026M08D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D05_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D06 p_execution_node_results_Y2026M08D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D06_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D07 p_execution_node_results_Y2026M08D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D07_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D08 p_execution_node_results_Y2026M08D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D09 p_execution_node_results_Y2026M08D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D10 p_execution_node_results_Y2026M08D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D11 p_execution_node_results_Y2026M08D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D12 p_execution_node_results_Y2026M08D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D13 p_execution_node_results_Y2026M08D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D13_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D14 p_execution_node_results_Y2026M08D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D14_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D15 p_execution_node_results_Y2026M08D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D15_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D16 p_execution_node_results_Y2026M08D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D16_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D17 p_execution_node_results_Y2026M08D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D17_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D18 p_execution_node_results_Y2026M08D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D18_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D19 p_execution_node_results_Y2026M08D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D19_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D20 p_execution_node_results_Y2026M08D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D20_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D21 p_execution_node_results_Y2026M08D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D21_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D22 p_execution_node_results_Y2026M08D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D22_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D23 p_execution_node_results_Y2026M08D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D23_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D24 p_execution_node_results_Y2026M08D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D24_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D25 p_execution_node_results_Y2026M08D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D25_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D26 p_execution_node_results_Y2026M08D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D26_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D27 p_execution_node_results_Y2026M08D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D27_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D28 p_execution_node_results_Y2026M08D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D28_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D29 p_execution_node_results_Y2026M08D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D29_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D30 p_execution_node_results_Y2026M08D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D30_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M08D31 p_execution_node_results_Y2026M08D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31"
    ADD CONSTRAINT "p_execution_node_results_Y2026M08D31_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D01 p_execution_node_results_Y2026M09D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D02 p_execution_node_results_Y2026M09D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D03 p_execution_node_results_Y2026M09D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D04 p_execution_node_results_Y2026M09D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D04_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D05 p_execution_node_results_Y2026M09D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D05_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D06 p_execution_node_results_Y2026M09D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D06_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D07 p_execution_node_results_Y2026M09D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D07_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D08 p_execution_node_results_Y2026M09D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D09 p_execution_node_results_Y2026M09D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D10 p_execution_node_results_Y2026M09D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D11 p_execution_node_results_Y2026M09D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D12 p_execution_node_results_Y2026M09D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D13 p_execution_node_results_Y2026M09D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D13_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D14 p_execution_node_results_Y2026M09D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D14_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D15 p_execution_node_results_Y2026M09D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D15_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D16 p_execution_node_results_Y2026M09D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D16_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D17 p_execution_node_results_Y2026M09D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D17_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D18 p_execution_node_results_Y2026M09D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D18_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_node_results_Y2026M09D19 p_execution_node_results_Y2026M09D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19"
    ADD CONSTRAINT "p_execution_node_results_Y2026M09D19_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D20 p_execution_parameter_results_Y2026M07D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D20"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D20_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D21 p_execution_parameter_results_Y2026M07D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D21"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D21_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D22 p_execution_parameter_results_Y2026M07D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D22"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D22_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D23 p_execution_parameter_results_Y2026M07D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D23"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D23_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D24 p_execution_parameter_results_Y2026M07D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D24"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D24_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D25 p_execution_parameter_results_Y2026M07D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D25"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D25_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D26 p_execution_parameter_results_Y2026M07D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D26"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D26_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D27 p_execution_parameter_results_Y2026M07D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D27"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D27_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D28 p_execution_parameter_results_Y2026M07D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D28"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D28_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D29 p_execution_parameter_results_Y2026M07D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D29"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D29_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D30 p_execution_parameter_results_Y2026M07D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D30"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D30_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M07D31 p_execution_parameter_results_Y2026M07D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D31"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M07D31_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D01 p_execution_parameter_results_Y2026M08D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D01"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D02 p_execution_parameter_results_Y2026M08D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D02"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D03 p_execution_parameter_results_Y2026M08D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D03"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D04 p_execution_parameter_results_Y2026M08D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D04"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D04_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D05 p_execution_parameter_results_Y2026M08D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D05"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D05_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D06 p_execution_parameter_results_Y2026M08D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D06"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D06_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D07 p_execution_parameter_results_Y2026M08D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D07"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D07_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D08 p_execution_parameter_results_Y2026M08D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D08"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D09 p_execution_parameter_results_Y2026M08D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D09"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D10 p_execution_parameter_results_Y2026M08D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D10"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D11 p_execution_parameter_results_Y2026M08D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D11"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D12 p_execution_parameter_results_Y2026M08D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D12"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D13 p_execution_parameter_results_Y2026M08D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D13"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D13_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D14 p_execution_parameter_results_Y2026M08D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D14"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D14_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D15 p_execution_parameter_results_Y2026M08D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D15"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D15_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D16 p_execution_parameter_results_Y2026M08D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D16"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D16_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D17 p_execution_parameter_results_Y2026M08D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D17"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D17_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D18 p_execution_parameter_results_Y2026M08D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D18"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D18_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D19 p_execution_parameter_results_Y2026M08D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D19"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D19_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D20 p_execution_parameter_results_Y2026M08D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D20"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D20_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D21 p_execution_parameter_results_Y2026M08D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D21"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D21_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D22 p_execution_parameter_results_Y2026M08D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D22"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D22_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D23 p_execution_parameter_results_Y2026M08D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D23"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D23_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D24 p_execution_parameter_results_Y2026M08D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D24"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D24_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D25 p_execution_parameter_results_Y2026M08D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D25"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D25_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D26 p_execution_parameter_results_Y2026M08D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D26"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D26_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D27 p_execution_parameter_results_Y2026M08D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D27"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D27_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D28 p_execution_parameter_results_Y2026M08D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D28"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D28_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D29 p_execution_parameter_results_Y2026M08D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D29"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D29_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D30 p_execution_parameter_results_Y2026M08D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D30"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D30_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M08D31 p_execution_parameter_results_Y2026M08D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D31"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M08D31_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D01 p_execution_parameter_results_Y2026M09D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D01"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D02 p_execution_parameter_results_Y2026M09D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D02"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D03 p_execution_parameter_results_Y2026M09D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D03"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D04 p_execution_parameter_results_Y2026M09D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D04"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D04_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D05 p_execution_parameter_results_Y2026M09D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D05"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D05_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D06 p_execution_parameter_results_Y2026M09D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D06"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D06_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D07 p_execution_parameter_results_Y2026M09D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D07"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D07_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D08 p_execution_parameter_results_Y2026M09D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D08"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D09 p_execution_parameter_results_Y2026M09D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D09"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D10 p_execution_parameter_results_Y2026M09D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D10"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D11 p_execution_parameter_results_Y2026M09D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D11"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D12 p_execution_parameter_results_Y2026M09D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D12"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D13 p_execution_parameter_results_Y2026M09D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D13"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D13_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D14 p_execution_parameter_results_Y2026M09D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D14"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D14_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D15 p_execution_parameter_results_Y2026M09D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D15"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D15_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D16 p_execution_parameter_results_Y2026M09D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D16"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D16_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D17 p_execution_parameter_results_Y2026M09D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D17"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D17_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D18 p_execution_parameter_results_Y2026M09D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D18"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D18_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_parameter_results_Y2026M09D19 p_execution_parameter_results_Y2026M09D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D19"
    ADD CONSTRAINT "p_execution_parameter_results_Y2026M09D19_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D20 p_execution_results_Y2026M07D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D20"
    ADD CONSTRAINT "p_execution_results_Y2026M07D20_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D21 p_execution_results_Y2026M07D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D21"
    ADD CONSTRAINT "p_execution_results_Y2026M07D21_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D22 p_execution_results_Y2026M07D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D22"
    ADD CONSTRAINT "p_execution_results_Y2026M07D22_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D23 p_execution_results_Y2026M07D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D23"
    ADD CONSTRAINT "p_execution_results_Y2026M07D23_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D24 p_execution_results_Y2026M07D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D24"
    ADD CONSTRAINT "p_execution_results_Y2026M07D24_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D25 p_execution_results_Y2026M07D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D25"
    ADD CONSTRAINT "p_execution_results_Y2026M07D25_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D26 p_execution_results_Y2026M07D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D26"
    ADD CONSTRAINT "p_execution_results_Y2026M07D26_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D27 p_execution_results_Y2026M07D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D27"
    ADD CONSTRAINT "p_execution_results_Y2026M07D27_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D28 p_execution_results_Y2026M07D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D28"
    ADD CONSTRAINT "p_execution_results_Y2026M07D28_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D29 p_execution_results_Y2026M07D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D29"
    ADD CONSTRAINT "p_execution_results_Y2026M07D29_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D30 p_execution_results_Y2026M07D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D30"
    ADD CONSTRAINT "p_execution_results_Y2026M07D30_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M07D31 p_execution_results_Y2026M07D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M07D31"
    ADD CONSTRAINT "p_execution_results_Y2026M07D31_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D01 p_execution_results_Y2026M08D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D01"
    ADD CONSTRAINT "p_execution_results_Y2026M08D01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D02 p_execution_results_Y2026M08D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D02"
    ADD CONSTRAINT "p_execution_results_Y2026M08D02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D03 p_execution_results_Y2026M08D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D03"
    ADD CONSTRAINT "p_execution_results_Y2026M08D03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D04 p_execution_results_Y2026M08D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D04"
    ADD CONSTRAINT "p_execution_results_Y2026M08D04_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D05 p_execution_results_Y2026M08D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D05"
    ADD CONSTRAINT "p_execution_results_Y2026M08D05_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D06 p_execution_results_Y2026M08D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D06"
    ADD CONSTRAINT "p_execution_results_Y2026M08D06_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D07 p_execution_results_Y2026M08D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D07"
    ADD CONSTRAINT "p_execution_results_Y2026M08D07_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D08 p_execution_results_Y2026M08D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D08"
    ADD CONSTRAINT "p_execution_results_Y2026M08D08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D09 p_execution_results_Y2026M08D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D09"
    ADD CONSTRAINT "p_execution_results_Y2026M08D09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D10 p_execution_results_Y2026M08D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D10"
    ADD CONSTRAINT "p_execution_results_Y2026M08D10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D11 p_execution_results_Y2026M08D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D11"
    ADD CONSTRAINT "p_execution_results_Y2026M08D11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D12 p_execution_results_Y2026M08D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D12"
    ADD CONSTRAINT "p_execution_results_Y2026M08D12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D13 p_execution_results_Y2026M08D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D13"
    ADD CONSTRAINT "p_execution_results_Y2026M08D13_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D14 p_execution_results_Y2026M08D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D14"
    ADD CONSTRAINT "p_execution_results_Y2026M08D14_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D15 p_execution_results_Y2026M08D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D15"
    ADD CONSTRAINT "p_execution_results_Y2026M08D15_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D16 p_execution_results_Y2026M08D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D16"
    ADD CONSTRAINT "p_execution_results_Y2026M08D16_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D17 p_execution_results_Y2026M08D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D17"
    ADD CONSTRAINT "p_execution_results_Y2026M08D17_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D18 p_execution_results_Y2026M08D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D18"
    ADD CONSTRAINT "p_execution_results_Y2026M08D18_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D19 p_execution_results_Y2026M08D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D19"
    ADD CONSTRAINT "p_execution_results_Y2026M08D19_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D20 p_execution_results_Y2026M08D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D20"
    ADD CONSTRAINT "p_execution_results_Y2026M08D20_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D21 p_execution_results_Y2026M08D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D21"
    ADD CONSTRAINT "p_execution_results_Y2026M08D21_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D22 p_execution_results_Y2026M08D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D22"
    ADD CONSTRAINT "p_execution_results_Y2026M08D22_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D23 p_execution_results_Y2026M08D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D23"
    ADD CONSTRAINT "p_execution_results_Y2026M08D23_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D24 p_execution_results_Y2026M08D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D24"
    ADD CONSTRAINT "p_execution_results_Y2026M08D24_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D25 p_execution_results_Y2026M08D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D25"
    ADD CONSTRAINT "p_execution_results_Y2026M08D25_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D26 p_execution_results_Y2026M08D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D26"
    ADD CONSTRAINT "p_execution_results_Y2026M08D26_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D27 p_execution_results_Y2026M08D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D27"
    ADD CONSTRAINT "p_execution_results_Y2026M08D27_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D28 p_execution_results_Y2026M08D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D28"
    ADD CONSTRAINT "p_execution_results_Y2026M08D28_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D29 p_execution_results_Y2026M08D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D29"
    ADD CONSTRAINT "p_execution_results_Y2026M08D29_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D30 p_execution_results_Y2026M08D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D30"
    ADD CONSTRAINT "p_execution_results_Y2026M08D30_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M08D31 p_execution_results_Y2026M08D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M08D31"
    ADD CONSTRAINT "p_execution_results_Y2026M08D31_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D01 p_execution_results_Y2026M09D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D01"
    ADD CONSTRAINT "p_execution_results_Y2026M09D01_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D02 p_execution_results_Y2026M09D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D02"
    ADD CONSTRAINT "p_execution_results_Y2026M09D02_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D03 p_execution_results_Y2026M09D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D03"
    ADD CONSTRAINT "p_execution_results_Y2026M09D03_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D04 p_execution_results_Y2026M09D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D04"
    ADD CONSTRAINT "p_execution_results_Y2026M09D04_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D05 p_execution_results_Y2026M09D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D05"
    ADD CONSTRAINT "p_execution_results_Y2026M09D05_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D06 p_execution_results_Y2026M09D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D06"
    ADD CONSTRAINT "p_execution_results_Y2026M09D06_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D07 p_execution_results_Y2026M09D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D07"
    ADD CONSTRAINT "p_execution_results_Y2026M09D07_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D08 p_execution_results_Y2026M09D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D08"
    ADD CONSTRAINT "p_execution_results_Y2026M09D08_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D09 p_execution_results_Y2026M09D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D09"
    ADD CONSTRAINT "p_execution_results_Y2026M09D09_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D10 p_execution_results_Y2026M09D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D10"
    ADD CONSTRAINT "p_execution_results_Y2026M09D10_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D11 p_execution_results_Y2026M09D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D11"
    ADD CONSTRAINT "p_execution_results_Y2026M09D11_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D12 p_execution_results_Y2026M09D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D12"
    ADD CONSTRAINT "p_execution_results_Y2026M09D12_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D13 p_execution_results_Y2026M09D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D13"
    ADD CONSTRAINT "p_execution_results_Y2026M09D13_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D14 p_execution_results_Y2026M09D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D14"
    ADD CONSTRAINT "p_execution_results_Y2026M09D14_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D15 p_execution_results_Y2026M09D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D15"
    ADD CONSTRAINT "p_execution_results_Y2026M09D15_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D16 p_execution_results_Y2026M09D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D16"
    ADD CONSTRAINT "p_execution_results_Y2026M09D16_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D17 p_execution_results_Y2026M09D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D17"
    ADD CONSTRAINT "p_execution_results_Y2026M09D17_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D18 p_execution_results_Y2026M09D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D18"
    ADD CONSTRAINT "p_execution_results_Y2026M09D18_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_execution_results_Y2026M09D19 p_execution_results_Y2026M09D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_execution_results_Y2026M09D19"
    ADD CONSTRAINT "p_execution_results_Y2026M09D19_pkey" PRIMARY KEY (id, created_at);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D05 p_runtime_module_status_daily_uptimes_Y2026M08D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D05"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D05_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D06 p_runtime_module_status_daily_uptimes_Y2026M08D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D06"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D06_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D07 p_runtime_module_status_daily_uptimes_Y2026M08D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D07"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D07_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D08 p_runtime_module_status_daily_uptimes_Y2026M08D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D08"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D08_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D09 p_runtime_module_status_daily_uptimes_Y2026M08D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D09"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D09_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D10 p_runtime_module_status_daily_uptimes_Y2026M08D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D10"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D10_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D11 p_runtime_module_status_daily_uptimes_Y2026M08D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D11"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D11_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D12 p_runtime_module_status_daily_uptimes_Y2026M08D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D12"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D12_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D13 p_runtime_module_status_daily_uptimes_Y2026M08D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D13"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D13_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D14 p_runtime_module_status_daily_uptimes_Y2026M08D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D14"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D14_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D15 p_runtime_module_status_daily_uptimes_Y2026M08D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D15"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D15_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D16 p_runtime_module_status_daily_uptimes_Y2026M08D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D16"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D16_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D17 p_runtime_module_status_daily_uptimes_Y2026M08D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D17"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D17_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D18 p_runtime_module_status_daily_uptimes_Y2026M08D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D18"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D18_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D19 p_runtime_module_status_daily_uptimes_Y2026M08D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D19"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D19_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D20 p_runtime_module_status_daily_uptimes_Y2026M08D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D20"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D20_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D21 p_runtime_module_status_daily_uptimes_Y2026M08D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D21"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D21_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D22 p_runtime_module_status_daily_uptimes_Y2026M08D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D22"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D22_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D23 p_runtime_module_status_daily_uptimes_Y2026M08D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D23"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D23_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D24 p_runtime_module_status_daily_uptimes_Y2026M08D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D24"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D24_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D25 p_runtime_module_status_daily_uptimes_Y2026M08D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D25"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D25_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D26 p_runtime_module_status_daily_uptimes_Y2026M08D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D26"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D26_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D27 p_runtime_module_status_daily_uptimes_Y2026M08D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D27"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D27_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D28 p_runtime_module_status_daily_uptimes_Y2026M08D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D28"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D28_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D29 p_runtime_module_status_daily_uptimes_Y2026M08D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D29"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D29_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D30 p_runtime_module_status_daily_uptimes_Y2026M08D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D30"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D30_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D31 p_runtime_module_status_daily_uptimes_Y2026M08D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D31"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M08D31_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D01 p_runtime_module_status_daily_uptimes_Y2026M09D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D01"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D01_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D02 p_runtime_module_status_daily_uptimes_Y2026M09D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D02"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D02_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D03 p_runtime_module_status_daily_uptimes_Y2026M09D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D03"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D03_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D04 p_runtime_module_status_daily_uptimes_Y2026M09D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D04"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D04_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D05 p_runtime_module_status_daily_uptimes_Y2026M09D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D05"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D05_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D06 p_runtime_module_status_daily_uptimes_Y2026M09D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D06"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D06_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D07 p_runtime_module_status_daily_uptimes_Y2026M09D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D07"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D07_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D08 p_runtime_module_status_daily_uptimes_Y2026M09D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D08"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D08_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D09 p_runtime_module_status_daily_uptimes_Y2026M09D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D09"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D09_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D10 p_runtime_module_status_daily_uptimes_Y2026M09D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D10"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D10_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D11 p_runtime_module_status_daily_uptimes_Y2026M09D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D11"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D11_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D12 p_runtime_module_status_daily_uptimes_Y2026M09D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D12"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D12_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D13 p_runtime_module_status_daily_uptimes_Y2026M09D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D13"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D13_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D14 p_runtime_module_status_daily_uptimes_Y2026M09D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D14"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D14_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D15 p_runtime_module_status_daily_uptimes_Y2026M09D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D15"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D15_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D16 p_runtime_module_status_daily_uptimes_Y2026M09D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D16"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D16_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D17 p_runtime_module_status_daily_uptimes_Y2026M09D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D17"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D17_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D18 p_runtime_module_status_daily_uptimes_Y2026M09D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D18"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D18_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D19 p_runtime_module_status_daily_uptimes_Y2026M09D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D19"
    ADD CONSTRAINT "p_runtime_module_status_daily_uptimes_Y2026M09D19_pkey" PRIMARY KEY (runtime_module_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D05 p_runtime_status_daily_uptimes_Y2026M08D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D05"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D05_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D06 p_runtime_status_daily_uptimes_Y2026M08D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D06"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D06_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D07 p_runtime_status_daily_uptimes_Y2026M08D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D07"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D07_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D08 p_runtime_status_daily_uptimes_Y2026M08D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D08"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D08_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D09 p_runtime_status_daily_uptimes_Y2026M08D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D09"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D09_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D10 p_runtime_status_daily_uptimes_Y2026M08D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D10"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D10_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D11 p_runtime_status_daily_uptimes_Y2026M08D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D11"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D11_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D12 p_runtime_status_daily_uptimes_Y2026M08D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D12"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D12_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D13 p_runtime_status_daily_uptimes_Y2026M08D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D13"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D13_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D14 p_runtime_status_daily_uptimes_Y2026M08D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D14"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D14_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D15 p_runtime_status_daily_uptimes_Y2026M08D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D15"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D15_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D16 p_runtime_status_daily_uptimes_Y2026M08D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D16"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D16_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D17 p_runtime_status_daily_uptimes_Y2026M08D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D17"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D17_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D18 p_runtime_status_daily_uptimes_Y2026M08D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D18"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D18_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D19 p_runtime_status_daily_uptimes_Y2026M08D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D19"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D19_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D20 p_runtime_status_daily_uptimes_Y2026M08D20_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D20"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D20_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D21 p_runtime_status_daily_uptimes_Y2026M08D21_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D21"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D21_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D22 p_runtime_status_daily_uptimes_Y2026M08D22_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D22"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D22_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D23 p_runtime_status_daily_uptimes_Y2026M08D23_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D23"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D23_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D24 p_runtime_status_daily_uptimes_Y2026M08D24_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D24"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D24_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D25 p_runtime_status_daily_uptimes_Y2026M08D25_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D25"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D25_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D26 p_runtime_status_daily_uptimes_Y2026M08D26_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D26"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D26_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D27 p_runtime_status_daily_uptimes_Y2026M08D27_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D27"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D27_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D28 p_runtime_status_daily_uptimes_Y2026M08D28_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D28"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D28_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D29 p_runtime_status_daily_uptimes_Y2026M08D29_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D29"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D29_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D30 p_runtime_status_daily_uptimes_Y2026M08D30_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D30"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D30_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D31 p_runtime_status_daily_uptimes_Y2026M08D31_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D31"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M08D31_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D01 p_runtime_status_daily_uptimes_Y2026M09D01_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D01"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D01_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D02 p_runtime_status_daily_uptimes_Y2026M09D02_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D02"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D02_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D03 p_runtime_status_daily_uptimes_Y2026M09D03_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D03"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D03_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D04 p_runtime_status_daily_uptimes_Y2026M09D04_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D04"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D04_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D05 p_runtime_status_daily_uptimes_Y2026M09D05_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D05"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D05_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D06 p_runtime_status_daily_uptimes_Y2026M09D06_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D06"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D06_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D07 p_runtime_status_daily_uptimes_Y2026M09D07_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D07"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D07_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D08 p_runtime_status_daily_uptimes_Y2026M09D08_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D08"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D08_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D09 p_runtime_status_daily_uptimes_Y2026M09D09_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D09"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D09_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D10 p_runtime_status_daily_uptimes_Y2026M09D10_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D10"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D10_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D11 p_runtime_status_daily_uptimes_Y2026M09D11_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D11"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D11_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D12 p_runtime_status_daily_uptimes_Y2026M09D12_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D12"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D12_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D13 p_runtime_status_daily_uptimes_Y2026M09D13_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D13"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D13_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D14 p_runtime_status_daily_uptimes_Y2026M09D14_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D14"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D14_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D15 p_runtime_status_daily_uptimes_Y2026M09D15_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D15"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D15_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D16 p_runtime_status_daily_uptimes_Y2026M09D16_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D16"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D16_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D17 p_runtime_status_daily_uptimes_Y2026M09D17_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D17"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D17_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D18 p_runtime_status_daily_uptimes_Y2026M09D18_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D18"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D18_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D19 p_runtime_status_daily_uptimes_Y2026M09D19_pkey; Type: CONSTRAINT; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER TABLE ONLY sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D19"
    ADD CONSTRAINT "p_runtime_status_daily_uptimes_Y2026M09D19_pkey" PRIMARY KEY (runtime_status_id, date);


--
-- Name: idx_data_types_on_runtime_module_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_data_types_on_runtime_module_id_identifier ON public.data_types USING btree (runtime_module_id, identifier);


--
-- Name: idx_flow_types_on_runtime_module_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_flow_types_on_runtime_module_id_identifier ON public.flow_types USING btree (runtime_module_id, identifier);


--
-- Name: idx_function_definitions_on_runtime_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_function_definitions_on_runtime_id_identifier ON public.function_definitions USING btree (runtime_id, identifier);


--
-- Name: idx_module_config_links_on_config_id_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_module_config_links_on_config_id_data_type_id ON public.module_configuration_definition_data_type_links USING btree (module_configuration_definition_id, referenced_data_type_id);


--
-- Name: idx_module_configs_on_assignment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_module_configs_on_assignment_id ON public.module_configurations USING btree (namespace_project_runtime_assignment_id);


--
-- Name: idx_module_configs_on_assignment_id_and_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_module_configs_on_assignment_id_and_definition_id ON public.module_configurations USING btree (namespace_project_runtime_assignment_id, module_configuration_definition_id);


--
-- Name: idx_module_configs_on_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_module_configs_on_definition_id ON public.module_configurations USING btree (module_configuration_definition_id);


--
-- Name: idx_module_configs_on_module_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_module_configs_on_module_id_identifier ON public.module_configuration_definitions USING btree (runtime_module_id, identifier);


--
-- Name: idx_on_data_type_id_referenced_data_type_id_bb9b090c90; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_data_type_id_referenced_data_type_id_bb9b090c90 ON public.data_type_data_type_links USING btree (data_type_id, referenced_data_type_id);


--
-- Name: idx_on_flow_id_referenced_data_type_id_14b02b52f8; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_flow_id_referenced_data_type_id_14b02b52f8 ON public.flow_data_type_links USING btree (flow_id, referenced_data_type_id);


--
-- Name: idx_on_flow_type_id_referenced_data_type_id_70312c9382; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_flow_type_id_referenced_data_type_id_70312c9382 ON public.flow_type_data_type_links USING btree (flow_type_id, referenced_data_type_id);


--
-- Name: idx_on_namespace_role_id_ability_a092da8841; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_namespace_role_id_ability_a092da8841 ON public.namespace_role_abilities USING btree (namespace_role_id, ability);


--
-- Name: idx_on_parent_inline_reference_value_id_54dc335844; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_parent_inline_reference_value_id_54dc335844 ON public.inline_reference_values USING btree (parent_inline_reference_value_id);


--
-- Name: idx_on_role_id_project_id_5d4b5917dc; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_role_id_project_id_5d4b5917dc ON public.namespace_role_project_assignments USING btree (role_id, project_id);


--
-- Name: idx_on_runtime_function_definition_id_referenced_da_a6da962633; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_runtime_function_definition_id_referenced_da_a6da962633 ON public.runtime_function_definition_data_type_links USING btree (runtime_function_definition_id, referenced_data_type_id);


--
-- Name: idx_on_runtime_function_definition_id_runtime_name_abb3bb31bc; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_runtime_function_definition_id_runtime_name_abb3bb31bc ON public.runtime_parameter_definitions USING btree (runtime_function_definition_id, runtime_name);


--
-- Name: idx_on_runtime_id_namespace_project_id_bc3c86cc70; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_runtime_id_namespace_project_id_bc3c86cc70 ON public.namespace_project_runtime_assignments USING btree (runtime_id, namespace_project_id);


--
-- Name: idx_on_runtime_id_runtime_name_de2ab1bfc0; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_runtime_id_runtime_name_de2ab1bfc0 ON public.runtime_function_definitions USING btree (runtime_id, runtime_name);


--
-- Name: idx_p_exec_node_results_on_execution_id_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_p_exec_node_results_on_execution_id_and_position ON ONLY public.p_execution_node_results USING btree (created_at, execution_result_id, "position");


--
-- Name: idx_p_exec_param_results_on_node_result_id_and_position; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_p_exec_param_results_on_node_result_id_and_position ON ONLY public.p_execution_parameter_results USING btree (created_at, execution_node_result_id, "position");


--
-- Name: idx_p_execution_results_on_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_p_execution_results_on_identifier ON ONLY public.p_execution_results USING btree (execution_identifier);


--
-- Name: idx_rfd_on_runtime_module_id_runtime_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rfd_on_runtime_module_id_runtime_name ON public.runtime_function_definitions USING btree (runtime_module_id, runtime_name);


--
-- Name: idx_rft_links_on_rft_id_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rft_links_on_rft_id_data_type_id ON public.runtime_flow_type_data_type_links USING btree (runtime_flow_type_id, referenced_data_type_id);


--
-- Name: idx_rft_on_runtime_module_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rft_on_runtime_module_id_identifier ON public.runtime_flow_types USING btree (runtime_module_id, identifier);


--
-- Name: idx_rft_settings_on_rft_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_rft_settings_on_rft_id_identifier ON public.runtime_flow_type_settings USING btree (runtime_flow_type_id, identifier);


--
-- Name: idx_runtime_modules_on_runtime_id_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_runtime_modules_on_runtime_id_identifier ON public.runtime_modules USING btree (runtime_id, identifier);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_application_settings_on_setting; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_application_settings_on_setting ON public.application_settings USING btree (setting);


--
-- Name: index_backup_codes_on_user_id_LOWER_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_backup_codes_on_user_id_LOWER_token" ON public.backup_codes USING btree (user_id, lower(token));


--
-- Name: index_data_type_rules_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_rules_on_data_type_id ON public.data_type_rules USING btree (data_type_id);


--
-- Name: index_data_types_on_runtime_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_data_types_on_runtime_id_and_identifier ON public.data_types USING btree (runtime_id, identifier);


--
-- Name: index_flow_settings_on_flow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flow_settings_on_flow_id ON public.flow_settings USING btree (flow_id);


--
-- Name: index_flow_type_settings_on_flow_type_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flow_type_settings_on_flow_type_id_and_identifier ON public.flow_type_settings USING btree (flow_type_id, identifier);


--
-- Name: index_flow_types_on_runtime_flow_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flow_types_on_runtime_flow_type_id ON public.flow_types USING btree (runtime_flow_type_id);


--
-- Name: index_flow_types_on_runtime_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flow_types_on_runtime_id_and_identifier ON public.flow_types USING btree (runtime_id, identifier);


--
-- Name: index_flows_on_flow_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_flow_type_id ON public.flows USING btree (flow_type_id);


--
-- Name: index_flows_on_name_and_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flows_on_name_and_project_id ON public.flows USING btree (name, project_id);


--
-- Name: index_flows_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_project_id ON public.flows USING btree (project_id);


--
-- Name: index_flows_on_starting_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_starting_node_id ON public.flows USING btree (starting_node_id);


--
-- Name: index_function_definitions_on_runtime_function_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_function_definitions_on_runtime_function_definition_id ON public.function_definitions USING btree (runtime_function_definition_id);


--
-- Name: index_good_job_executions_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_active_job_id_and_created_at ON public.good_job_executions USING btree (active_job_id, created_at);


--
-- Name: index_good_job_executions_on_process_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_executions_on_process_id_and_created_at ON public.good_job_executions USING btree (process_id, created_at);


--
-- Name: index_good_job_jobs_for_candidate_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_job_jobs_for_candidate_lookup ON public.good_jobs USING btree (priority, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_job_settings_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_job_settings_on_key ON public.good_job_settings USING btree (key);


--
-- Name: index_good_jobs_for_candidate_dequeue_unlocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_for_candidate_dequeue_unlocked ON public.good_jobs USING btree (priority, scheduled_at, id) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_jobs_on_finished_at_only; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at_only ON public.good_jobs USING btree (finished_at) WHERE (finished_at IS NOT NULL);


--
-- Name: index_good_jobs_jobs_on_priority_created_at_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_priority_created_at_when_unfinished ON public.good_jobs USING btree (priority DESC NULLS LAST, created_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_active_job_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_active_job_id_and_created_at ON public.good_jobs USING btree (active_job_id, created_at);


--
-- Name: index_good_jobs_on_batch_callback_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_callback_id ON public.good_jobs USING btree (batch_callback_id) WHERE (batch_callback_id IS NOT NULL);


--
-- Name: index_good_jobs_on_batch_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_batch_id ON public.good_jobs USING btree (batch_id) WHERE (batch_id IS NOT NULL);


--
-- Name: index_good_jobs_on_concurrency_key_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_and_created_at ON public.good_jobs USING btree (concurrency_key, created_at);


--
-- Name: index_good_jobs_on_concurrency_key_when_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_concurrency_key_when_unfinished ON public.good_jobs USING btree (concurrency_key) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_created_at ON public.good_jobs USING btree (created_at);


--
-- Name: index_good_jobs_on_cron_key_and_created_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON public.good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON public.good_jobs USING btree (cron_key, cron_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_discarded; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_discarded ON public.good_jobs USING btree (finished_at DESC) WHERE ((finished_at IS NOT NULL) AND (error IS NOT NULL));


--
-- Name: index_good_jobs_on_job_class; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_job_class ON public.good_jobs USING btree (job_class);


--
-- Name: index_good_jobs_on_labels; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_labels ON public.good_jobs USING gin (labels) WHERE (labels IS NOT NULL);


--
-- Name: index_good_jobs_on_locked_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_locked_by_id ON public.good_jobs USING btree (locked_by_id) WHERE (locked_by_id IS NOT NULL);


--
-- Name: index_good_jobs_on_priority_scheduled_at_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_priority_scheduled_at_unfinished ON public.good_jobs USING btree (priority, scheduled_at, id) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_priority_scheduled_at_unfinished_unlocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_priority_scheduled_at_unfinished_unlocked ON public.good_jobs USING btree (priority, scheduled_at) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_on_queue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name ON public.good_jobs USING btree (queue_name);


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON public.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_queue_name_priority_scheduled_at_unfinished; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_priority_scheduled_at_unfinished ON public.good_jobs USING btree (queue_name, scheduled_at, id) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at_and_queue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at_and_queue_name ON public.good_jobs USING btree (scheduled_at, queue_name);


--
-- Name: index_good_jobs_on_unfinished_or_errored; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_unfinished_or_errored ON public.good_jobs USING btree (id) WHERE ((finished_at IS NULL) OR (error IS NOT NULL));


--
-- Name: index_inline_reference_values_on_node_parameter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_inline_reference_values_on_node_parameter_id ON public.inline_reference_values USING btree (node_parameter_id);


--
-- Name: index_licenses_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_licenses_on_namespace_id ON public.licenses USING btree (namespace_id);


--
-- Name: index_namespace_member_roles_on_member_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_member_roles_on_member_id ON public.namespace_member_roles USING btree (member_id);


--
-- Name: index_namespace_member_roles_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_member_roles_on_role_id ON public.namespace_member_roles USING btree (role_id);


--
-- Name: index_namespace_members_on_namespace_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespace_members_on_namespace_id_and_user_id ON public.namespace_members USING btree (namespace_id, user_id);


--
-- Name: index_namespace_members_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_members_on_user_id ON public.namespace_members USING btree (user_id);


--
-- Name: index_namespace_projects_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_projects_on_namespace_id ON public.namespace_projects USING btree (namespace_id);


--
-- Name: index_namespace_projects_on_primary_runtime_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_projects_on_primary_runtime_id ON public.namespace_projects USING btree (primary_runtime_id);


--
-- Name: index_namespace_projects_on_slug; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespace_projects_on_slug ON public.namespace_projects USING btree (slug);


--
-- Name: index_namespace_role_project_assignments_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_role_project_assignments_on_project_id ON public.namespace_role_project_assignments USING btree (project_id);


--
-- Name: index_namespace_roles_on_namespace_id_LOWER_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_namespace_roles_on_namespace_id_LOWER_name" ON public.namespace_roles USING btree (namespace_id, lower(name));


--
-- Name: index_namespaces_on_parent_id_and_parent_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_namespaces_on_parent_id_and_parent_type ON public.namespaces USING btree (parent_id, parent_type);


--
-- Name: index_node_functions_on_flow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_functions_on_flow_id ON public.node_functions USING btree (flow_id);


--
-- Name: index_node_functions_on_function_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_functions_on_function_definition_id ON public.node_functions USING btree (function_definition_id);


--
-- Name: index_node_functions_on_next_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_functions_on_next_node_id ON public.node_functions USING btree (next_node_id);


--
-- Name: index_node_parameters_on_node_function_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_parameters_on_node_function_id ON public.node_parameters USING btree (node_function_id);


--
-- Name: index_node_parameters_on_parameter_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_parameters_on_parameter_definition_id ON public.node_parameters USING btree (parameter_definition_id);


--
-- Name: index_organizations_on_LOWER_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_organizations_on_LOWER_name" ON public.organizations USING btree (lower(name));


--
-- Name: index_p_audit_events_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_p_audit_events_on_author_id ON ONLY public.p_audit_events USING btree (author_id);


--
-- Name: index_p_execution_node_results_on_function_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_p_execution_node_results_on_function_definition_id ON ONLY public.p_execution_node_results USING btree (function_definition_id);


--
-- Name: index_p_execution_node_results_on_node_function_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_p_execution_node_results_on_node_function_id ON ONLY public.p_execution_node_results USING btree (node_function_id);


--
-- Name: index_parameter_definitions_on_function_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parameter_definitions_on_function_definition_id ON public.parameter_definitions USING btree (function_definition_id);


--
-- Name: index_parameter_definitions_on_runtime_parameter_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parameter_definitions_on_runtime_parameter_definition_id ON public.parameter_definitions USING btree (runtime_parameter_definition_id);


--
-- Name: index_reference_paths_on_reference_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_paths_on_reference_value_id ON public.reference_paths USING btree (reference_value_id);


--
-- Name: index_reference_values_on_inline_reference_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_values_on_inline_reference_value_id ON public.reference_values USING btree (inline_reference_value_id);


--
-- Name: index_reference_values_on_node_function_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_values_on_node_function_id ON public.reference_values USING btree (node_function_id);


--
-- Name: index_reference_values_on_node_parameter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_values_on_node_parameter_id ON public.reference_values USING btree (node_parameter_id);


--
-- Name: index_runtime_flow_types_on_runtime_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_runtime_flow_types_on_runtime_id_and_identifier ON public.runtime_flow_types USING btree (runtime_id, identifier);


--
-- Name: index_runtime_module_definitions_on_runtime_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_runtime_module_definitions_on_runtime_module_id ON public.runtime_module_definitions USING btree (runtime_module_id);


--
-- Name: index_runtime_module_statuses_on_runtime_module_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_runtime_module_statuses_on_runtime_module_id ON public.runtime_module_statuses USING btree (runtime_module_id);


--
-- Name: index_runtime_statuses_on_runtime_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_runtime_statuses_on_runtime_id ON public.runtime_statuses USING btree (runtime_id);


--
-- Name: index_runtimes_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_runtimes_on_namespace_id ON public.runtimes USING btree (namespace_id);


--
-- Name: index_runtimes_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_runtimes_on_token ON public.runtimes USING btree (token);


--
-- Name: index_sub_flow_settings_on_sub_flow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_flow_settings_on_sub_flow_id ON public.sub_flow_settings USING btree (sub_flow_id);


--
-- Name: index_sub_flows_on_function_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_flows_on_function_definition_id ON public.sub_flows USING btree (function_definition_id);


--
-- Name: index_sub_flows_on_inline_reference_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sub_flows_on_inline_reference_value_id ON public.sub_flows USING btree (inline_reference_value_id);


--
-- Name: index_sub_flows_on_node_parameter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sub_flows_on_node_parameter_id ON public.sub_flows USING btree (node_parameter_id);


--
-- Name: index_sub_flows_on_starting_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_flows_on_starting_node_id ON public.sub_flows USING btree (starting_node_id);


--
-- Name: index_translations_on_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_translations_on_owner ON public.translations USING btree (owner_type, owner_id);


--
-- Name: index_user_identities_on_provider_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_identities_on_provider_id_and_identifier ON public.user_identities USING btree (provider_id, identifier);


--
-- Name: index_user_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_identities_on_user_id ON public.user_identities USING btree (user_id);


--
-- Name: index_user_identities_on_user_id_and_provider_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_identities_on_user_id_and_provider_id ON public.user_identities USING btree (user_id, provider_id);


--
-- Name: index_user_sessions_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_sessions_on_token ON public.user_sessions USING btree (token);


--
-- Name: index_user_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_sessions_on_user_id ON public.user_sessions USING btree (user_id);


--
-- Name: index_users_on_LOWER_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_users_on_LOWER_email" ON public.users USING btree (lower(email));


--
-- Name: index_users_on_LOWER_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_users_on_LOWER_username" ON public.users USING btree (lower(username));


--
-- Name: p_audit_events_Y2026M08_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2026M08_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2026M08" USING btree (author_id);


--
-- Name: p_audit_events_Y2026M09_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2026M09_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2026M09" USING btree (author_id);


--
-- Name: p_audit_events_Y2026M10_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2026M10_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2026M10" USING btree (author_id);


--
-- Name: p_audit_events_Y2026M11_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2026M11_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2026M11" USING btree (author_id);


--
-- Name: p_audit_events_Y2026M12_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2026M12_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2026M12" USING btree (author_id);


--
-- Name: p_audit_events_Y2027M01_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2027M01_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2027M01" USING btree (author_id);


--
-- Name: p_audit_events_Y2027M02_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2027M02_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2027M02" USING btree (author_id);


--
-- Name: p_audit_events_Y2027M03_author_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_audit_events_Y2027M03_author_id_idx" ON sagittarius_partitions_dynamic."p_audit_events_Y2027M03" USING btree (author_id);


--
-- Name: p_execution_node_results_Y2026M07D20_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D20_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D20_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D20_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D21_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D21_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D21_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D21_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D22_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D22_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D22_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D22_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D23_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D23_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D23_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D23_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D24_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D24_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D24_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D24_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D25_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D25_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D25_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D25_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D26_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D26_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D26_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D26_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D27_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D27_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D27_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D27_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D28_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D28_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D28_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D28_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D29_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D29_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D29_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D29_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D30_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D30_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D30_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D30_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M07D31_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D31_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M07D31_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M07D31_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D01_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D01_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D01_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D01_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D02_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D02_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D02_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D02_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D03_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D03_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D03_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D03_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D04_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D04_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D04_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D04_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D05_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D05_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D05_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D05_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D06_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D06_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D06_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D06_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D07_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D07_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D07_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D07_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D08_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D08_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D08_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D08_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D09_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D09_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D09_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D09_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D10_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D10_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D10_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D10_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D11_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D11_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D11_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D11_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D12_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D12_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D12_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D12_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D13_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D13_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D13_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D13_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D14_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D14_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D14_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D14_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D15_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D15_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D15_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D15_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D16_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D16_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D16_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D16_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D17_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D17_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D17_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D17_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D18_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D18_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D18_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D18_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D19_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D19_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D19_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D19_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D20_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D20_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D20_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D20_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D21_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D21_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D21_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D21_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D22_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D22_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D22_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D22_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D23_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D23_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D23_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D23_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D24_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D24_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D24_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D24_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D25_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D25_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D25_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D25_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D26_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D26_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D26_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D26_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D27_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D27_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D27_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D27_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D28_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D28_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D28_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D28_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D29_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D29_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D29_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D29_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D30_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D30_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D30_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D30_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M08D31_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D31_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M08D31_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M08D31_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D01_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D01_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D01_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D01_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D02_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D02_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D02_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D02_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D03_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D03_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D03_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D03_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D04_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D04_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D04_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D04_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D05_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D05_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D05_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D05_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D06_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D06_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D06_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D06_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D07_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D07_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D07_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D07_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D08_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D08_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D08_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D08_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D09_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D09_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D09_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D09_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D10_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D10_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D10_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D10_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D11_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D11_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D11_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D11_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D12_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D12_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D12_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D12_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D13_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D13_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D13_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D13_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D14_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D14_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D14_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D14_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D15_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D15_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D15_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D15_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D16_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D16_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D16_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D16_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D17_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D17_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D17_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D17_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D18_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D18_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D18_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D18_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y2026M09D19_function_definition_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D19_function_definition_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19" USING btree (function_definition_id);


--
-- Name: p_execution_node_results_Y2026M09D19_node_function_id_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_node_results_Y2026M09D19_node_function_id_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19" USING btree (node_function_id);


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx1; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx1" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx2; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx2" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx3; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx3" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx4; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx4" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx5; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx5" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx6; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx6" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx7; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx7" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx8; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx8" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx9; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result__idx9" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y202_created_at_execution_result_i_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y202_created_at_execution_result_i_idx" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx10; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx10" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx11; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx11" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx12; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx12" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx13; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx13" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx14; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx14" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx15; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx15" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx16; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx16" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx17; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx17" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx18; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx18" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx19; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx19" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx20; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx20" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx21; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx21" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx22; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx22" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx23; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx23" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx24; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx24" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx25; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx25" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx26; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx26" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx27; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx27" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx28; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx28" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx29; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx29" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx30; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx30" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx31; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx31" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx32; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx32" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx33; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx33" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx34; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx34" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx35; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx35" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx36; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx36" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx37; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx37" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx38; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx38" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx39; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx39" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx40; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx40" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx41; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx41" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx42; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx42" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx43; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx43" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx44; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx44" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx45; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx45" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx46; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx46" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx47; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx47" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx48; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx48" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx49; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx49" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx50; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx50" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx51; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx51" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx52; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx52" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx53; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx53" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx54; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx54" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx55; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx55" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx56; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx56" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx57; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx57" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx58; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx58" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx59; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx59" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx60; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx60" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx61; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX "p_execution_node_results_Y20_created_at_execution_result__idx61" ON sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19" USING btree (created_at, execution_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx10; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx10 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D30" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx11; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx11 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D31" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx12; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx12 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D01" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx13; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx13 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D02" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx14; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx14 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D03" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx15; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx15 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D04" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx16; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx16 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D05" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx17; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx17 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D06" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx18; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx18 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D07" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx19; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx19 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D08" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx20; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx20 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D09" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx21; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx21 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D10" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx22; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx22 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D11" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx23; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx23 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D12" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx24; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx24 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D13" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx25; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx25 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D14" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx26; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx26 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D15" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx27; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx27 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D16" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx28; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx28 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D17" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx29; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx29 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D18" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx30; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx30 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D19" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx31; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx31 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D20" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx32; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx32 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D21" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx33; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx33 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D22" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx34; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx34 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D23" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx35; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx35 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D24" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx36; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx36 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D25" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx37; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx37 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D26" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx38; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx38 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D27" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx39; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx39 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D28" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx40; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx40 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D29" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx41; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx41 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D30" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx42; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx42 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D31" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx43; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx43 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D01" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx44; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx44 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D02" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx45; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx45 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D03" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx46; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx46 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D04" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx47; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx47 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D05" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx48; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx48 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D06" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx49; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx49 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D07" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx50; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx50 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D08" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx51; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx51 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D09" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx52; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx52 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D10" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx53; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx53 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D11" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx54; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx54 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D12" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx55; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx55 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D13" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx56; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx56 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D14" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx57; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx57 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D15" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx58; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx58 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D16" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx59; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx59 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D17" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx60; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx60 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D18" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx61; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_result_created_at_execution_node_re_idx61 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D19" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx1; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx1 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D21" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx2; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx2 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D22" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx3; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx3 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D23" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx4; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx4 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D24" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx5; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx5 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D25" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx6; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx6 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D26" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx7; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx7 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D27" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx8; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx8 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D28" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx9; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_re_idx9 ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D29" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_parameter_results_created_at_execution_node_res_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE UNIQUE INDEX p_execution_parameter_results_created_at_execution_node_res_idx ON sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D20" USING btree (created_at, execution_node_result_id, "position");


--
-- Name: p_execution_results_Y2026M07D20_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D20_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D20" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D21_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D21_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D21" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D22_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D22_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D22" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D23_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D23_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D23" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D24_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D24_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D24" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D25_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D25_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D25" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D26_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D26_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D26" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D27_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D27_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D27" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D28_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D28_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D28" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D29_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D29_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D29" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D30_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D30_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D30" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M07D31_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M07D31_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M07D31" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D01_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D01_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D01" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D02_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D02_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D02" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D03_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D03_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D03" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D04_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D04_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D04" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D05_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D05_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D05" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D06_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D06_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D06" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D07_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D07_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D07" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D08_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D08_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D08" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D09_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D09_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D09" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D10_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D10_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D10" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D11_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D11_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D11" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D12_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D12_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D12" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D13_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D13_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D13" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D14_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D14_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D14" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D15_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D15_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D15" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D16_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D16_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D16" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D17_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D17_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D17" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D18_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D18_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D18" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D19_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D19_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D19" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D20_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D20_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D20" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D21_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D21_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D21" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D22_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D22_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D22" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D23_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D23_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D23" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D24_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D24_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D24" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D25_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D25_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D25" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D26_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D26_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D26" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D27_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D27_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D27" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D28_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D28_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D28" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D29_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D29_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D29" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D30_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D30_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D30" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M08D31_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M08D31_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M08D31" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D01_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D01_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D01" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D02_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D02_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D02" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D03_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D03_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D03" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D04_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D04_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D04" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D05_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D05_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D05" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D06_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D06_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D06" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D07_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D07_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D07" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D08_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D08_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D08" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D09_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D09_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D09" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D10_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D10_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D10" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D11_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D11_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D11" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D12_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D12_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D12" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D13_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D13_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D13" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D14_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D14_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D14" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D15_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D15_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D15" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D16_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D16_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D16" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D17_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D17_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D17" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D18_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D18_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D18" USING btree (execution_identifier);


--
-- Name: p_execution_results_Y2026M09D19_execution_identifier_idx; Type: INDEX; Schema: sagittarius_partitions_dynamic; Owner: -
--

CREATE INDEX "p_execution_results_Y2026M09D19_execution_identifier_idx" ON sagittarius_partitions_dynamic."p_execution_results_Y2026M09D19" USING btree (execution_identifier);


--
-- Name: p_audit_events_Y2026M08_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M08_author_id_idx";


--
-- Name: p_audit_events_Y2026M08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M08_pkey";


--
-- Name: p_audit_events_Y2026M09_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M09_author_id_idx";


--
-- Name: p_audit_events_Y2026M09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M09_pkey";


--
-- Name: p_audit_events_Y2026M10_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M10_author_id_idx";


--
-- Name: p_audit_events_Y2026M10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M10_pkey";


--
-- Name: p_audit_events_Y2026M11_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M11_author_id_idx";


--
-- Name: p_audit_events_Y2026M11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M11_pkey";


--
-- Name: p_audit_events_Y2026M12_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M12_author_id_idx";


--
-- Name: p_audit_events_Y2026M12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2026M12_pkey";


--
-- Name: p_audit_events_Y2027M01_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M01_author_id_idx";


--
-- Name: p_audit_events_Y2027M01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M01_pkey";


--
-- Name: p_audit_events_Y2027M02_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M02_author_id_idx";


--
-- Name: p_audit_events_Y2027M02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M02_pkey";


--
-- Name: p_audit_events_Y2027M03_author_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_audit_events_on_author_id ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M03_author_id_idx";


--
-- Name: p_audit_events_Y2027M03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_audit_events_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_audit_events_Y2027M03_pkey";


--
-- Name: p_execution_node_results_Y2026M07D20_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D20_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D20_pkey";


--
-- Name: p_execution_node_results_Y2026M07D21_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D21_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D21_pkey";


--
-- Name: p_execution_node_results_Y2026M07D22_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D22_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D22_pkey";


--
-- Name: p_execution_node_results_Y2026M07D23_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D23_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D23_pkey";


--
-- Name: p_execution_node_results_Y2026M07D24_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D24_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D24_pkey";


--
-- Name: p_execution_node_results_Y2026M07D25_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D25_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D25_pkey";


--
-- Name: p_execution_node_results_Y2026M07D26_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D26_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D26_pkey";


--
-- Name: p_execution_node_results_Y2026M07D27_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D27_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D27_pkey";


--
-- Name: p_execution_node_results_Y2026M07D28_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D28_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D28_pkey";


--
-- Name: p_execution_node_results_Y2026M07D29_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D29_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D29_pkey";


--
-- Name: p_execution_node_results_Y2026M07D30_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D30_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D30_pkey";


--
-- Name: p_execution_node_results_Y2026M07D31_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D31_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M07D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M07D31_pkey";


--
-- Name: p_execution_node_results_Y2026M08D01_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D01_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D01_pkey";


--
-- Name: p_execution_node_results_Y2026M08D02_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D02_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D02_pkey";


--
-- Name: p_execution_node_results_Y2026M08D03_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D03_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D03_pkey";


--
-- Name: p_execution_node_results_Y2026M08D04_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D04_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D04_pkey";


--
-- Name: p_execution_node_results_Y2026M08D05_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D05_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D05_pkey";


--
-- Name: p_execution_node_results_Y2026M08D06_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D06_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D06_pkey";


--
-- Name: p_execution_node_results_Y2026M08D07_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D07_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D07_pkey";


--
-- Name: p_execution_node_results_Y2026M08D08_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D08_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D08_pkey";


--
-- Name: p_execution_node_results_Y2026M08D09_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D09_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D09_pkey";


--
-- Name: p_execution_node_results_Y2026M08D10_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D10_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D10_pkey";


--
-- Name: p_execution_node_results_Y2026M08D11_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D11_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D11_pkey";


--
-- Name: p_execution_node_results_Y2026M08D12_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D12_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D12_pkey";


--
-- Name: p_execution_node_results_Y2026M08D13_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D13_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D13_pkey";


--
-- Name: p_execution_node_results_Y2026M08D14_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D14_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D14_pkey";


--
-- Name: p_execution_node_results_Y2026M08D15_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D15_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D15_pkey";


--
-- Name: p_execution_node_results_Y2026M08D16_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D16_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D16_pkey";


--
-- Name: p_execution_node_results_Y2026M08D17_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D17_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D17_pkey";


--
-- Name: p_execution_node_results_Y2026M08D18_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D18_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D18_pkey";


--
-- Name: p_execution_node_results_Y2026M08D19_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D19_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D19_pkey";


--
-- Name: p_execution_node_results_Y2026M08D20_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D20_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D20_pkey";


--
-- Name: p_execution_node_results_Y2026M08D21_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D21_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D21_pkey";


--
-- Name: p_execution_node_results_Y2026M08D22_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D22_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D22_pkey";


--
-- Name: p_execution_node_results_Y2026M08D23_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D23_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D23_pkey";


--
-- Name: p_execution_node_results_Y2026M08D24_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D24_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D24_pkey";


--
-- Name: p_execution_node_results_Y2026M08D25_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D25_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D25_pkey";


--
-- Name: p_execution_node_results_Y2026M08D26_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D26_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D26_pkey";


--
-- Name: p_execution_node_results_Y2026M08D27_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D27_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D27_pkey";


--
-- Name: p_execution_node_results_Y2026M08D28_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D28_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D28_pkey";


--
-- Name: p_execution_node_results_Y2026M08D29_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D29_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D29_pkey";


--
-- Name: p_execution_node_results_Y2026M08D30_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D30_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D30_pkey";


--
-- Name: p_execution_node_results_Y2026M08D31_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D31_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M08D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M08D31_pkey";


--
-- Name: p_execution_node_results_Y2026M09D01_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D01_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D01_pkey";


--
-- Name: p_execution_node_results_Y2026M09D02_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D02_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D02_pkey";


--
-- Name: p_execution_node_results_Y2026M09D03_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D03_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D03_pkey";


--
-- Name: p_execution_node_results_Y2026M09D04_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D04_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D04_pkey";


--
-- Name: p_execution_node_results_Y2026M09D05_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D05_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D05_pkey";


--
-- Name: p_execution_node_results_Y2026M09D06_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D06_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D06_pkey";


--
-- Name: p_execution_node_results_Y2026M09D07_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D07_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D07_pkey";


--
-- Name: p_execution_node_results_Y2026M09D08_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D08_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D08_pkey";


--
-- Name: p_execution_node_results_Y2026M09D09_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D09_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D09_pkey";


--
-- Name: p_execution_node_results_Y2026M09D10_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D10_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D10_pkey";


--
-- Name: p_execution_node_results_Y2026M09D11_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D11_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D11_pkey";


--
-- Name: p_execution_node_results_Y2026M09D12_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D12_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D12_pkey";


--
-- Name: p_execution_node_results_Y2026M09D13_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D13_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D13_pkey";


--
-- Name: p_execution_node_results_Y2026M09D14_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D14_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D14_pkey";


--
-- Name: p_execution_node_results_Y2026M09D15_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D15_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D15_pkey";


--
-- Name: p_execution_node_results_Y2026M09D16_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D16_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D16_pkey";


--
-- Name: p_execution_node_results_Y2026M09D17_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D17_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D17_pkey";


--
-- Name: p_execution_node_results_Y2026M09D18_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D18_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D18_pkey";


--
-- Name: p_execution_node_results_Y2026M09D19_function_definition_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_function_definition_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19_function_definition_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D19_node_function_id_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.index_p_execution_node_results_on_node_function_id ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19_node_function_id_idx";


--
-- Name: p_execution_node_results_Y2026M09D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_node_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y2026M09D19_pkey";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx1; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx1";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx2; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx2";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx3; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx3";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx4; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx4";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx5; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx5";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx6; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx6";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx7; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx7";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx8; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx8";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result__idx9; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result__idx9";


--
-- Name: p_execution_node_results_Y202_created_at_execution_result_i_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y202_created_at_execution_result_i_idx";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx10; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx10";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx11; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx11";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx12; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx12";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx13; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx13";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx14; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx14";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx15; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx15";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx16; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx16";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx17; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx17";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx18; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx18";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx19; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx19";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx20; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx20";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx21; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx21";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx22; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx22";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx23; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx23";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx24; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx24";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx25; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx25";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx26; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx26";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx27; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx27";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx28; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx28";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx29; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx29";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx30; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx30";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx31; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx31";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx32; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx32";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx33; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx33";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx34; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx34";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx35; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx35";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx36; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx36";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx37; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx37";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx38; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx38";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx39; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx39";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx40; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx40";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx41; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx41";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx42; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx42";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx43; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx43";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx44; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx44";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx45; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx45";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx46; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx46";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx47; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx47";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx48; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx48";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx49; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx49";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx50; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx50";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx51; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx51";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx52; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx52";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx53; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx53";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx54; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx54";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx55; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx55";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx56; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx56";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx57; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx57";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx58; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx58";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx59; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx59";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx60; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx60";


--
-- Name: p_execution_node_results_Y20_created_at_execution_result__idx61; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_node_results_on_execution_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_node_results_Y20_created_at_execution_result__idx61";


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx10; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx10;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx11; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx11;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx12; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx12;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx13; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx13;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx14; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx14;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx15; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx15;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx16; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx16;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx17; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx17;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx18; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx18;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx19; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx19;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx20; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx20;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx21; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx21;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx22; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx22;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx23; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx23;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx24; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx24;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx25; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx25;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx26; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx26;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx27; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx27;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx28; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx28;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx29; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx29;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx30; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx30;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx31; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx31;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx32; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx32;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx33; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx33;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx34; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx34;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx35; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx35;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx36; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx36;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx37; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx37;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx38; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx38;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx39; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx39;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx40; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx40;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx41; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx41;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx42; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx42;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx43; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx43;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx44; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx44;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx45; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx45;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx46; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx46;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx47; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx47;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx48; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx48;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx49; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx49;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx50; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx50;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx51; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx51;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx52; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx52;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx53; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx53;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx54; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx54;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx55; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx55;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx56; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx56;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx57; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx57;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx58; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx58;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx59; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx59;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx60; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx60;


--
-- Name: p_execution_parameter_result_created_at_execution_node_re_idx61; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_result_created_at_execution_node_re_idx61;


--
-- Name: p_execution_parameter_results_Y2026M07D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D20_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D21_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D22_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D23_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D24_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D25_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D26_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D27_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D28_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D29_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D30_pkey";


--
-- Name: p_execution_parameter_results_Y2026M07D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M07D31_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D01_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D02_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D03_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D04_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D05_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D06_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D07_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D08_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D09_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D10_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D11_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D12_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D13_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D14_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D15_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D16_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D17_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D18_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D19_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D20_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D21_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D22_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D23_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D24_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D25_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D26_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D27_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D28_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D29_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D30_pkey";


--
-- Name: p_execution_parameter_results_Y2026M08D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M08D31_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D01_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D02_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D03_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D04_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D05_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D06_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D07_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D08_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D09_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D10_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D11_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D12_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D13_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D14_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D15_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D16_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D17_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D18_pkey";


--
-- Name: p_execution_parameter_results_Y2026M09D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_parameter_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_parameter_results_Y2026M09D19_pkey";


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx1; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx1;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx2; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx2;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx3; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx3;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx4; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx4;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx5; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx5;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx6; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx6;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx7; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx7;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx8; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx8;


--
-- Name: p_execution_parameter_results_created_at_execution_node_re_idx9; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_re_idx9;


--
-- Name: p_execution_parameter_results_created_at_execution_node_res_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_exec_param_results_on_node_result_id_and_position ATTACH PARTITION sagittarius_partitions_dynamic.p_execution_parameter_results_created_at_execution_node_res_idx;


--
-- Name: p_execution_results_Y2026M07D20_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D20_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D20_pkey";


--
-- Name: p_execution_results_Y2026M07D21_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D21_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D21_pkey";


--
-- Name: p_execution_results_Y2026M07D22_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D22_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D22_pkey";


--
-- Name: p_execution_results_Y2026M07D23_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D23_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D23_pkey";


--
-- Name: p_execution_results_Y2026M07D24_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D24_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D24_pkey";


--
-- Name: p_execution_results_Y2026M07D25_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D25_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D25_pkey";


--
-- Name: p_execution_results_Y2026M07D26_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D26_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D26_pkey";


--
-- Name: p_execution_results_Y2026M07D27_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D27_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D27_pkey";


--
-- Name: p_execution_results_Y2026M07D28_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D28_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D28_pkey";


--
-- Name: p_execution_results_Y2026M07D29_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D29_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D29_pkey";


--
-- Name: p_execution_results_Y2026M07D30_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D30_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D30_pkey";


--
-- Name: p_execution_results_Y2026M07D31_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D31_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M07D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M07D31_pkey";


--
-- Name: p_execution_results_Y2026M08D01_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D01_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D01_pkey";


--
-- Name: p_execution_results_Y2026M08D02_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D02_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D02_pkey";


--
-- Name: p_execution_results_Y2026M08D03_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D03_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D03_pkey";


--
-- Name: p_execution_results_Y2026M08D04_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D04_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D04_pkey";


--
-- Name: p_execution_results_Y2026M08D05_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D05_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D05_pkey";


--
-- Name: p_execution_results_Y2026M08D06_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D06_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D06_pkey";


--
-- Name: p_execution_results_Y2026M08D07_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D07_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D07_pkey";


--
-- Name: p_execution_results_Y2026M08D08_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D08_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D08_pkey";


--
-- Name: p_execution_results_Y2026M08D09_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D09_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D09_pkey";


--
-- Name: p_execution_results_Y2026M08D10_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D10_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D10_pkey";


--
-- Name: p_execution_results_Y2026M08D11_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D11_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D11_pkey";


--
-- Name: p_execution_results_Y2026M08D12_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D12_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D12_pkey";


--
-- Name: p_execution_results_Y2026M08D13_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D13_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D13_pkey";


--
-- Name: p_execution_results_Y2026M08D14_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D14_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D14_pkey";


--
-- Name: p_execution_results_Y2026M08D15_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D15_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D15_pkey";


--
-- Name: p_execution_results_Y2026M08D16_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D16_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D16_pkey";


--
-- Name: p_execution_results_Y2026M08D17_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D17_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D17_pkey";


--
-- Name: p_execution_results_Y2026M08D18_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D18_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D18_pkey";


--
-- Name: p_execution_results_Y2026M08D19_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D19_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D19_pkey";


--
-- Name: p_execution_results_Y2026M08D20_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D20_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D20_pkey";


--
-- Name: p_execution_results_Y2026M08D21_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D21_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D21_pkey";


--
-- Name: p_execution_results_Y2026M08D22_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D22_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D22_pkey";


--
-- Name: p_execution_results_Y2026M08D23_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D23_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D23_pkey";


--
-- Name: p_execution_results_Y2026M08D24_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D24_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D24_pkey";


--
-- Name: p_execution_results_Y2026M08D25_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D25_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D25_pkey";


--
-- Name: p_execution_results_Y2026M08D26_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D26_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D26_pkey";


--
-- Name: p_execution_results_Y2026M08D27_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D27_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D27_pkey";


--
-- Name: p_execution_results_Y2026M08D28_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D28_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D28_pkey";


--
-- Name: p_execution_results_Y2026M08D29_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D29_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D29_pkey";


--
-- Name: p_execution_results_Y2026M08D30_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D30_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D30_pkey";


--
-- Name: p_execution_results_Y2026M08D31_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D31_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M08D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M08D31_pkey";


--
-- Name: p_execution_results_Y2026M09D01_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D01_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D01_pkey";


--
-- Name: p_execution_results_Y2026M09D02_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D02_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D02_pkey";


--
-- Name: p_execution_results_Y2026M09D03_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D03_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D03_pkey";


--
-- Name: p_execution_results_Y2026M09D04_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D04_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D04_pkey";


--
-- Name: p_execution_results_Y2026M09D05_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D05_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D05_pkey";


--
-- Name: p_execution_results_Y2026M09D06_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D06_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D06_pkey";


--
-- Name: p_execution_results_Y2026M09D07_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D07_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D07_pkey";


--
-- Name: p_execution_results_Y2026M09D08_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D08_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D08_pkey";


--
-- Name: p_execution_results_Y2026M09D09_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D09_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D09_pkey";


--
-- Name: p_execution_results_Y2026M09D10_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D10_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D10_pkey";


--
-- Name: p_execution_results_Y2026M09D11_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D11_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D11_pkey";


--
-- Name: p_execution_results_Y2026M09D12_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D12_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D12_pkey";


--
-- Name: p_execution_results_Y2026M09D13_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D13_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D13_pkey";


--
-- Name: p_execution_results_Y2026M09D14_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D14_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D14_pkey";


--
-- Name: p_execution_results_Y2026M09D15_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D15_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D15_pkey";


--
-- Name: p_execution_results_Y2026M09D16_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D16_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D16_pkey";


--
-- Name: p_execution_results_Y2026M09D17_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D17_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D17_pkey";


--
-- Name: p_execution_results_Y2026M09D18_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D18_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D18_pkey";


--
-- Name: p_execution_results_Y2026M09D19_execution_identifier_idx; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.idx_p_execution_results_on_identifier ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D19_execution_identifier_idx";


--
-- Name: p_execution_results_Y2026M09D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_execution_results_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_execution_results_Y2026M09D19_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D05_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D06_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D07_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D08_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D09_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D10_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D11_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D12_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D13_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D14_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D15_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D16_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D17_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D18_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D19_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D20_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D21_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D22_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D23_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D24_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D25_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D26_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D27_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D28_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D29_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D30_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M08D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M08D31_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D01_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D02_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D03_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D04_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D05_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D06_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D07_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D08_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D09_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D10_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D11_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D12_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D13_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D14_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D15_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D16_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D17_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D18_pkey";


--
-- Name: p_runtime_module_status_daily_uptimes_Y2026M09D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_module_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_module_status_daily_uptimes_Y2026M09D19_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D05_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D06_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D07_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D08_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D09_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D10_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D11_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D12_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D13_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D14_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D15_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D16_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D17_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D18_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D19_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D20_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D20_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D21_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D21_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D22_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D22_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D23_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D23_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D24_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D24_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D25_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D25_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D26_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D26_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D27_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D27_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D28_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D28_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D29_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D29_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D30_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D30_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M08D31_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M08D31_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D01_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D01_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D02_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D02_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D03_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D03_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D04_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D04_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D05_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D05_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D06_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D06_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D07_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D07_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D08_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D08_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D09_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D09_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D10_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D10_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D11_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D11_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D12_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D12_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D13_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D13_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D14_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D14_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D15_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D15_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D16_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D16_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D17_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D17_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D18_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D18_pkey";


--
-- Name: p_runtime_status_daily_uptimes_Y2026M09D19_pkey; Type: INDEX ATTACH; Schema: sagittarius_partitions_dynamic; Owner: -
--

ALTER INDEX public.p_runtime_status_daily_uptimes_pkey ATTACH PARTITION sagittarius_partitions_dynamic."p_runtime_status_daily_uptimes_Y2026M09D19_pkey";


--
-- Name: node_parameters fk_rails_0d79310cfa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT fk_rails_0d79310cfa FOREIGN KEY (node_function_id) REFERENCES public.node_functions(id) ON DELETE CASCADE;


--
-- Name: data_types fk_rails_118c914ed0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT fk_rails_118c914ed0 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: flow_types fk_rails_18bfb8e8af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types
    ADD CONSTRAINT fk_rails_18bfb8e8af FOREIGN KEY (runtime_flow_type_id) REFERENCES public.runtime_flow_types(id) ON DELETE CASCADE;


--
-- Name: parameter_definitions fk_rails_18c14268dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_definitions
    ADD CONSTRAINT fk_rails_18c14268dd FOREIGN KEY (function_definition_id) REFERENCES public.function_definitions(id) ON DELETE CASCADE;


--
-- Name: runtime_module_statuses fk_rails_19736617d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_module_statuses
    ADD CONSTRAINT fk_rails_19736617d3 FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: namespace_roles fk_rails_205092c9cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_roles
    ADD CONSTRAINT fk_rails_205092c9cb FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: inline_reference_values fk_rails_242c3f297c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inline_reference_values
    ADD CONSTRAINT fk_rails_242c3f297c FOREIGN KEY (parent_inline_reference_value_id) REFERENCES public.inline_reference_values(id) ON DELETE CASCADE;


--
-- Name: runtime_parameter_definitions fk_rails_260318ad67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions
    ADD CONSTRAINT fk_rails_260318ad67 FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE CASCADE;


--
-- Name: function_definitions fk_rails_2b9456e278; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions
    ADD CONSTRAINT fk_rails_2b9456e278 FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: node_parameters fk_rails_2ed7c53167; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT fk_rails_2ed7c53167 FOREIGN KEY (parameter_definition_id) REFERENCES public.parameter_definitions(id) ON DELETE RESTRICT;


--
-- Name: p_runtime_status_daily_uptimes fk_rails_31e87d50f7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_runtime_status_daily_uptimes
    ADD CONSTRAINT fk_rails_31e87d50f7 FOREIGN KEY (runtime_status_id) REFERENCES public.runtime_statuses(id) ON DELETE CASCADE;


--
-- Name: sub_flows fk_rails_32ab48790a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flows
    ADD CONSTRAINT fk_rails_32ab48790a FOREIGN KEY (node_parameter_id) REFERENCES public.node_parameters(id) ON DELETE CASCADE;


--
-- Name: runtime_flow_types fk_rails_3675f29c4e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_types
    ADD CONSTRAINT fk_rails_3675f29c4e FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: flow_type_data_type_links fk_rails_38698de52d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_data_type_links
    ADD CONSTRAINT fk_rails_38698de52d FOREIGN KEY (referenced_data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: runtime_flow_type_data_type_links fk_rails_38758d9b2b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_data_type_links
    ADD CONSTRAINT fk_rails_38758d9b2b FOREIGN KEY (referenced_data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: licenses fk_rails_38f693332d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.licenses
    ADD CONSTRAINT fk_rails_38f693332d FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: runtime_statuses fk_rails_3af887feb9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_statuses
    ADD CONSTRAINT fk_rails_3af887feb9 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: parameter_definitions fk_rails_3b02763f84; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_definitions
    ADD CONSTRAINT fk_rails_3b02763f84 FOREIGN KEY (runtime_parameter_definition_id) REFERENCES public.runtime_parameter_definitions(id) ON DELETE CASCADE;


--
-- Name: module_configuration_definition_data_type_links fk_rails_42593aae68; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definition_data_type_links
    ADD CONSTRAINT fk_rails_42593aae68 FOREIGN KEY (module_configuration_definition_id) REFERENCES public.module_configuration_definitions(id) ON DELETE CASCADE;


--
-- Name: module_configurations fk_rails_42e0cac371; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configurations
    ADD CONSTRAINT fk_rails_42e0cac371 FOREIGN KEY (module_configuration_definition_id) REFERENCES public.module_configuration_definitions(id) ON DELETE CASCADE;


--
-- Name: data_type_data_type_links fk_rails_443c90661b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_data_type_links
    ADD CONSTRAINT fk_rails_443c90661b FOREIGN KEY (referenced_data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: p_execution_node_results fk_rails_460ac90523; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_execution_node_results
    ADD CONSTRAINT fk_rails_460ac90523 FOREIGN KEY (execution_result_id, created_at) REFERENCES public.p_execution_results(id, created_at) ON DELETE CASCADE;


--
-- Name: module_configurations fk_rails_47f7323aca; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configurations
    ADD CONSTRAINT fk_rails_47f7323aca FOREIGN KEY (namespace_project_runtime_assignment_id) REFERENCES public.namespace_project_runtime_assignments(id) ON DELETE CASCADE;


--
-- Name: function_definitions fk_rails_48f4bbe3b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions
    ADD CONSTRAINT fk_rails_48f4bbe3b6 FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE CASCADE;


--
-- Name: flow_type_data_type_links fk_rails_4a293cd114; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_data_type_links
    ADD CONSTRAINT fk_rails_4a293cd114 FOREIGN KEY (flow_type_id) REFERENCES public.flow_types(id) ON DELETE CASCADE;


--
-- Name: runtime_modules fk_rails_4ad6cfc2c6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_modules
    ADD CONSTRAINT fk_rails_4ad6cfc2c6 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: runtime_function_definitions fk_rails_5161ff47e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions
    ADD CONSTRAINT fk_rails_5161ff47e6 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: p_execution_results fk_rails_521c5925e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_execution_results
    ADD CONSTRAINT fk_rails_521c5925e7 FOREIGN KEY (flow_id) REFERENCES public.flows(id) ON DELETE CASCADE;


--
-- Name: node_functions fk_rails_53cf3476d6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions
    ADD CONSTRAINT fk_rails_53cf3476d6 FOREIGN KEY (function_definition_id) REFERENCES public.function_definitions(id) ON DELETE RESTRICT;


--
-- Name: backup_codes fk_rails_556c1feac3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_codes
    ADD CONSTRAINT fk_rails_556c1feac3 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sub_flow_settings fk_rails_55f76c79cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flow_settings
    ADD CONSTRAINT fk_rails_55f76c79cc FOREIGN KEY (sub_flow_id) REFERENCES public.sub_flows(id) ON DELETE CASCADE;


--
-- Name: namespace_members fk_rails_567f152a62; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_members
    ADD CONSTRAINT fk_rails_567f152a62 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: namespace_member_roles fk_rails_585a684166; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_member_roles
    ADD CONSTRAINT fk_rails_585a684166 FOREIGN KEY (role_id) REFERENCES public.namespace_roles(id) ON DELETE CASCADE;


--
-- Name: module_configuration_definitions fk_rails_5967026f74; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definitions
    ADD CONSTRAINT fk_rails_5967026f74 FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: runtime_function_definition_data_type_links fk_rails_5a52fd74a0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_data_type_links
    ADD CONSTRAINT fk_rails_5a52fd74a0 FOREIGN KEY (referenced_data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: namespace_role_project_assignments fk_rails_623f8a5b72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_project_assignments
    ADD CONSTRAINT fk_rails_623f8a5b72 FOREIGN KEY (role_id) REFERENCES public.namespace_roles(id) ON DELETE CASCADE;


--
-- Name: runtime_function_definition_data_type_links fk_rails_64dd235e33; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_data_type_links
    ADD CONSTRAINT fk_rails_64dd235e33 FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE CASCADE;


--
-- Name: flow_data_type_links fk_rails_657ea5202b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_data_type_links
    ADD CONSTRAINT fk_rails_657ea5202b FOREIGN KEY (referenced_data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: p_runtime_module_status_daily_uptimes fk_rails_6607b796b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_runtime_module_status_daily_uptimes
    ADD CONSTRAINT fk_rails_6607b796b1 FOREIGN KEY (runtime_module_status_id) REFERENCES public.runtime_module_statuses(id) ON DELETE CASCADE;


--
-- Name: user_identities fk_rails_684b0e1ce0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_identities
    ADD CONSTRAINT fk_rails_684b0e1ce0 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: flow_types fk_rails_687d671458; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types
    ADD CONSTRAINT fk_rails_687d671458 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: namespace_role_project_assignments fk_rails_69066bda8f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_project_assignments
    ADD CONSTRAINT fk_rails_69066bda8f FOREIGN KEY (project_id) REFERENCES public.namespace_projects(id) ON DELETE CASCADE;


--
-- Name: flow_types fk_rails_69115ada7f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types
    ADD CONSTRAINT fk_rails_69115ada7f FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: namespace_member_roles fk_rails_6c0d5a04c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_member_roles
    ADD CONSTRAINT fk_rails_6c0d5a04c4 FOREIGN KEY (member_id) REFERENCES public.namespace_members(id) ON DELETE CASCADE;


--
-- Name: namespace_role_abilities fk_rails_6f3304b078; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_abilities
    ADD CONSTRAINT fk_rails_6f3304b078 FOREIGN KEY (namespace_role_id) REFERENCES public.namespace_roles(id) ON DELETE CASCADE;


--
-- Name: data_types fk_rails_70e5bacc8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT fk_rails_70e5bacc8c FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: p_flow_usage_daily_aggregates fk_rails_73e82432d5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_flow_usage_daily_aggregates
    ADD CONSTRAINT fk_rails_73e82432d5 FOREIGN KEY (flow_id) REFERENCES public.flows(id) ON DELETE CASCADE;


--
-- Name: data_type_rules fk_rails_7759633ff8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_rules
    ADD CONSTRAINT fk_rails_7759633ff8 FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE CASCADE;


--
-- Name: inline_reference_values fk_rails_78d76b86a9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.inline_reference_values
    ADD CONSTRAINT fk_rails_78d76b86a9 FOREIGN KEY (node_parameter_id) REFERENCES public.node_parameters(id) ON DELETE CASCADE;


--
-- Name: namespace_projects fk_rails_79012c5895; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_projects
    ADD CONSTRAINT fk_rails_79012c5895 FOREIGN KEY (primary_runtime_id) REFERENCES public.runtimes(id) ON DELETE RESTRICT;


--
-- Name: p_namespace_project_usage_daily_aggregates fk_rails_7967df4c6b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_namespace_project_usage_daily_aggregates
    ADD CONSTRAINT fk_rails_7967df4c6b FOREIGN KEY (project_id) REFERENCES public.namespace_projects(id) ON DELETE CASCADE;


--
-- Name: p_execution_node_results fk_rails_7aca8c4942; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_execution_node_results
    ADD CONSTRAINT fk_rails_7aca8c4942 FOREIGN KEY (function_definition_id) REFERENCES public.function_definitions(id) ON DELETE SET NULL;


--
-- Name: flows fk_rails_7de9ce6578; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_7de9ce6578 FOREIGN KEY (starting_node_id) REFERENCES public.node_functions(id) ON DELETE SET NULL;


--
-- Name: node_functions fk_rails_8615bd0635; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions
    ADD CONSTRAINT fk_rails_8615bd0635 FOREIGN KEY (flow_id) REFERENCES public.flows(id) ON DELETE CASCADE;


--
-- Name: p_execution_node_results fk_rails_885be76a3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_execution_node_results
    ADD CONSTRAINT fk_rails_885be76a3a FOREIGN KEY (node_function_id) REFERENCES public.node_functions(id) ON DELETE SET NULL;


--
-- Name: reference_values fk_rails_8b9d8f68cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_values
    ADD CONSTRAINT fk_rails_8b9d8f68cc FOREIGN KEY (node_function_id) REFERENCES public.node_functions(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: reference_values fk_rails_8c916f07f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_values
    ADD CONSTRAINT fk_rails_8c916f07f1 FOREIGN KEY (node_parameter_id) REFERENCES public.node_parameters(id) ON DELETE CASCADE;


--
-- Name: data_type_data_type_links fk_rails_90fbf0d8ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_data_type_links
    ADD CONSTRAINT fk_rails_90fbf0d8ef FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE CASCADE;


--
-- Name: runtime_module_definitions fk_rails_9249522e69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_module_definitions
    ADD CONSTRAINT fk_rails_9249522e69 FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: reference_paths fk_rails_92e51047ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_paths
    ADD CONSTRAINT fk_rails_92e51047ea FOREIGN KEY (reference_value_id) REFERENCES public.reference_values(id) ON DELETE CASCADE;


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: p_audit_events fk_rails_9c5a4c4493; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_audit_events
    ADD CONSTRAINT fk_rails_9c5a4c4493 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- Name: user_sessions fk_rails_9fa262d742; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT fk_rails_9fa262d742 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: namespace_members fk_rails_a0a760b9b4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_members
    ADD CONSTRAINT fk_rails_a0a760b9b4 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sub_flows fk_rails_a99aa3478f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flows
    ADD CONSTRAINT fk_rails_a99aa3478f FOREIGN KEY (function_definition_id) REFERENCES public.function_definitions(id) ON DELETE RESTRICT;


--
-- Name: flows fk_rails_ab927e0ecb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_ab927e0ecb FOREIGN KEY (project_id) REFERENCES public.namespace_projects(id) ON DELETE CASCADE;


--
-- Name: function_definitions fk_rails_ac308a3f72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions
    ADD CONSTRAINT fk_rails_ac308a3f72 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: reference_values fk_rails_af0ece4310; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_values
    ADD CONSTRAINT fk_rails_af0ece4310 FOREIGN KEY (inline_reference_value_id) REFERENCES public.inline_reference_values(id) ON DELETE CASCADE;


--
-- Name: runtime_flow_type_data_type_links fk_rails_b300bcf944; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_data_type_links
    ADD CONSTRAINT fk_rails_b300bcf944 FOREIGN KEY (runtime_flow_type_id) REFERENCES public.runtime_flow_types(id) ON DELETE CASCADE;


--
-- Name: sub_flows fk_rails_bc5ce475f9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flows
    ADD CONSTRAINT fk_rails_bc5ce475f9 FOREIGN KEY (inline_reference_value_id) REFERENCES public.inline_reference_values(id) ON DELETE CASCADE;


--
-- Name: namespace_project_runtime_assignments fk_rails_c019e5b233; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_project_runtime_assignments
    ADD CONSTRAINT fk_rails_c019e5b233 FOREIGN KEY (namespace_project_id) REFERENCES public.namespace_projects(id) ON DELETE CASCADE;


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: namespace_project_runtime_assignments fk_rails_c640af2146; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_project_runtime_assignments
    ADD CONSTRAINT fk_rails_c640af2146 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: runtime_function_definitions fk_rails_d2d9392ab1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions
    ADD CONSTRAINT fk_rails_d2d9392ab1 FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: namespace_projects fk_rails_d4f50e2f00; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_projects
    ADD CONSTRAINT fk_rails_d4f50e2f00 FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: flows fk_rails_d9ad50fe4b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_d9ad50fe4b FOREIGN KEY (flow_type_id) REFERENCES public.flow_types(id) ON DELETE CASCADE;


--
-- Name: flow_settings fk_rails_da3b2fb3c5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_settings
    ADD CONSTRAINT fk_rails_da3b2fb3c5 FOREIGN KEY (flow_id) REFERENCES public.flows(id) ON DELETE CASCADE;


--
-- Name: p_namespace_usage_daily_aggregates fk_rails_e1a53ee65f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_namespace_usage_daily_aggregates
    ADD CONSTRAINT fk_rails_e1a53ee65f FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: sub_flows fk_rails_e27dd4d82a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_flows
    ADD CONSTRAINT fk_rails_e27dd4d82a FOREIGN KEY (starting_node_id) REFERENCES public.node_functions(id) ON DELETE RESTRICT;


--
-- Name: p_execution_parameter_results fk_rails_e2c2b3fddc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE public.p_execution_parameter_results
    ADD CONSTRAINT fk_rails_e2c2b3fddc FOREIGN KEY (execution_node_result_id, created_at) REFERENCES public.p_execution_node_results(id, created_at) ON DELETE CASCADE;


--
-- Name: runtime_flow_types fk_rails_e729dc57e7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_types
    ADD CONSTRAINT fk_rails_e729dc57e7 FOREIGN KEY (runtime_module_id) REFERENCES public.runtime_modules(id) ON DELETE CASCADE;


--
-- Name: module_configuration_definition_data_type_links fk_rails_e893387710; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.module_configuration_definition_data_type_links
    ADD CONSTRAINT fk_rails_e893387710 FOREIGN KEY (referenced_data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: runtimes fk_rails_eeb42116cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtimes
    ADD CONSTRAINT fk_rails_eeb42116cc FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: flow_data_type_links fk_rails_f4202724d3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_data_type_links
    ADD CONSTRAINT fk_rails_f4202724d3 FOREIGN KEY (flow_id) REFERENCES public.flows(id) ON DELETE CASCADE;


--
-- Name: flow_type_settings fk_rails_f6af7d8edf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_settings
    ADD CONSTRAINT fk_rails_f6af7d8edf FOREIGN KEY (flow_type_id) REFERENCES public.flow_types(id) ON DELETE CASCADE;


--
-- Name: node_functions fk_rails_fbc91a3407; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions
    ADD CONSTRAINT fk_rails_fbc91a3407 FOREIGN KEY (next_node_id) REFERENCES public.node_functions(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: runtime_flow_type_settings fk_rails_fbd356a9f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_flow_type_settings
    ADD CONSTRAINT fk_rails_fbd356a9f4 FOREIGN KEY (runtime_flow_type_id) REFERENCES public.runtime_flow_types(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;



