SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

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
    value jsonb NOT NULL,
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
-- Name: audit_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.audit_events (
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


--
-- Name: audit_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.audit_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.audit_events_id_seq OWNED BY public.audit_events.id;


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
-- Name: data_type_identifiers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.data_type_identifiers (
    id bigint NOT NULL,
    generic_key text,
    data_type_id bigint,
    runtime_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    generic_type_id bigint,
    generic_mapper_id bigint,
    function_generic_mapper_id bigint,
    CONSTRAINT check_480d44acbd CHECK ((num_nonnulls(generic_key, data_type_id, generic_type_id) = 1))
);


--
-- Name: data_type_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.data_type_identifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: data_type_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.data_type_identifiers_id_seq OWNED BY public.data_type_identifiers.id;


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
    variant integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    runtime_id bigint NOT NULL,
    removed_at timestamp with time zone,
    generic_keys text[] DEFAULT '{}'::text[] NOT NULL,
    parent_type_id bigint,
    flows_id bigint,
    CONSTRAINT check_3a7198812e CHECK ((char_length(identifier) <= 50))
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
-- Name: flow_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_settings (
    id bigint NOT NULL,
    flow_id bigint,
    flow_setting_id text NOT NULL,
    object jsonb NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
-- Name: flow_type_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.flow_type_settings (
    id bigint NOT NULL,
    flow_type_id bigint NOT NULL,
    identifier text NOT NULL,
    "unique" boolean DEFAULT false NOT NULL,
    data_type_id bigint NOT NULL,
    default_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
    input_type_id bigint,
    return_type_id bigint,
    editable boolean DEFAULT true NOT NULL,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
    input_type_id bigint,
    return_type_id bigint,
    starting_node_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
    return_type_id bigint
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
-- Name: function_generic_mappers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.function_generic_mappers (
    id bigint NOT NULL,
    target text NOT NULL,
    parameter_id text,
    runtime_parameter_definition_id bigint,
    runtime_function_definition_id bigint,
    runtime_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: function_generic_mappers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.function_generic_mappers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: function_generic_mappers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.function_generic_mappers_id_seq OWNED BY public.function_generic_mappers.id;


--
-- Name: generic_combination_strategies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generic_combination_strategies (
    id bigint NOT NULL,
    type integer,
    generic_mapper_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: generic_combination_strategies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.generic_combination_strategies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generic_combination_strategies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.generic_combination_strategies_id_seq OWNED BY public.generic_combination_strategies.id;


--
-- Name: generic_mappers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generic_mappers (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    target text NOT NULL,
    generic_type_id bigint,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: generic_mappers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.generic_mappers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generic_mappers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.generic_mappers_id_seq OWNED BY public.generic_mappers.id;


--
-- Name: generic_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generic_types (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: generic_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.generic_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: generic_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.generic_types_id_seq OWNED BY public.generic_types.id;


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
    locked_at timestamp with time zone
);


--
-- Name: namespace_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_licenses (
    id bigint NOT NULL,
    data text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id bigint NOT NULL
);


--
-- Name: namespace_licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.namespace_licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: namespace_licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.namespace_licenses_id_seq OWNED BY public.namespace_licenses.id;


--
-- Name: namespace_member_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.namespace_member_roles (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    member_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
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
    namespace_project_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
    id bigint NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    namespace_id bigint NOT NULL,
    primary_runtime_id bigint,
    CONSTRAINT check_09e881e641 CHECK ((char_length(name) <= 50)),
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
    id bigint NOT NULL,
    ability integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
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
    id bigint NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
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
    runtime_function_id bigint NOT NULL,
    next_node_id bigint,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
    runtime_parameter_id bigint NOT NULL,
    node_function_id bigint NOT NULL,
    literal_value jsonb,
    reference_value_id bigint,
    function_value_id bigint,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    CONSTRAINT check_fdac0ea550 CHECK ((num_nonnulls(literal_value, reference_value_id, function_value_id) = 1))
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
-- Name: parameter_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.parameter_definitions (
    id bigint NOT NULL,
    runtime_parameter_definition_id bigint NOT NULL,
    default_value jsonb,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    data_type_id bigint
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
    data_type_identifier_id bigint NOT NULL,
    primary_level integer NOT NULL,
    secondary_level integer NOT NULL,
    tertiary_level integer,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
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
-- Name: runtime_function_definition_error_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_function_definition_error_types (
    id bigint NOT NULL,
    runtime_function_definition_id bigint NOT NULL,
    data_type_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: runtime_function_definition_error_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runtime_function_definition_error_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runtime_function_definition_error_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runtime_function_definition_error_types_id_seq OWNED BY public.runtime_function_definition_error_types.id;


--
-- Name: runtime_function_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_function_definitions (
    id bigint NOT NULL,
    runtime_id bigint NOT NULL,
    runtime_name text NOT NULL,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    return_type_id bigint,
    generic_keys text[] DEFAULT '{}'::text[] NOT NULL,
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
-- Name: runtime_parameter_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runtime_parameter_definitions (
    id bigint NOT NULL,
    runtime_function_definition_id bigint NOT NULL,
    runtime_name text NOT NULL,
    removed_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    default_value jsonb,
    data_type_id bigint,
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
    status integer DEFAULT 0 NOT NULL,
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
-- Name: audit_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events ALTER COLUMN id SET DEFAULT nextval('public.audit_events_id_seq'::regclass);


--
-- Name: backup_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_codes ALTER COLUMN id SET DEFAULT nextval('public.backup_codes_id_seq'::regclass);


--
-- Name: data_type_identifiers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers ALTER COLUMN id SET DEFAULT nextval('public.data_type_identifiers_id_seq'::regclass);


--
-- Name: data_type_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_rules ALTER COLUMN id SET DEFAULT nextval('public.data_type_rules_id_seq'::regclass);


--
-- Name: data_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types ALTER COLUMN id SET DEFAULT nextval('public.data_types_id_seq'::regclass);


--
-- Name: flow_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_settings ALTER COLUMN id SET DEFAULT nextval('public.flow_settings_id_seq'::regclass);


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
-- Name: function_generic_mappers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_generic_mappers ALTER COLUMN id SET DEFAULT nextval('public.function_generic_mappers_id_seq'::regclass);


--
-- Name: generic_combination_strategies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_combination_strategies ALTER COLUMN id SET DEFAULT nextval('public.generic_combination_strategies_id_seq'::regclass);


--
-- Name: generic_mappers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_mappers ALTER COLUMN id SET DEFAULT nextval('public.generic_mappers_id_seq'::regclass);


--
-- Name: generic_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_types ALTER COLUMN id SET DEFAULT nextval('public.generic_types_id_seq'::regclass);


--
-- Name: namespace_licenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_licenses ALTER COLUMN id SET DEFAULT nextval('public.namespace_licenses_id_seq'::regclass);


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
-- Name: runtime_function_definition_error_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_error_types ALTER COLUMN id SET DEFAULT nextval('public.runtime_function_definition_error_types_id_seq'::regclass);


--
-- Name: runtime_function_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions ALTER COLUMN id SET DEFAULT nextval('public.runtime_function_definitions_id_seq'::regclass);


--
-- Name: runtime_parameter_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions ALTER COLUMN id SET DEFAULT nextval('public.runtime_parameter_definitions_id_seq'::regclass);


--
-- Name: runtimes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtimes ALTER COLUMN id SET DEFAULT nextval('public.runtimes_id_seq'::regclass);


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
-- Name: audit_events audit_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT audit_events_pkey PRIMARY KEY (id);


--
-- Name: backup_codes backup_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_codes
    ADD CONSTRAINT backup_codes_pkey PRIMARY KEY (id);


--
-- Name: data_type_identifiers data_type_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers
    ADD CONSTRAINT data_type_identifiers_pkey PRIMARY KEY (id);


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
-- Name: flow_settings flow_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_settings
    ADD CONSTRAINT flow_settings_pkey PRIMARY KEY (id);


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
-- Name: function_generic_mappers function_generic_mappers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_generic_mappers
    ADD CONSTRAINT function_generic_mappers_pkey PRIMARY KEY (id);


--
-- Name: generic_combination_strategies generic_combination_strategies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_combination_strategies
    ADD CONSTRAINT generic_combination_strategies_pkey PRIMARY KEY (id);


--
-- Name: generic_mappers generic_mappers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_mappers
    ADD CONSTRAINT generic_mappers_pkey PRIMARY KEY (id);


--
-- Name: generic_types generic_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_types
    ADD CONSTRAINT generic_types_pkey PRIMARY KEY (id);


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
-- Name: namespace_licenses namespace_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_licenses
    ADD CONSTRAINT namespace_licenses_pkey PRIMARY KEY (id);


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
-- Name: runtime_function_definition_error_types runtime_function_definition_error_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_error_types
    ADD CONSTRAINT runtime_function_definition_error_types_pkey PRIMARY KEY (id);


--
-- Name: runtime_function_definitions runtime_function_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions
    ADD CONSTRAINT runtime_function_definitions_pkey PRIMARY KEY (id);


--
-- Name: runtime_parameter_definitions runtime_parameter_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions
    ADD CONSTRAINT runtime_parameter_definitions_pkey PRIMARY KEY (id);


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
-- Name: idx_on_namespace_role_id_ability_a092da8841; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_namespace_role_id_ability_a092da8841 ON public.namespace_role_abilities USING btree (namespace_role_id, ability);


--
-- Name: idx_on_role_id_project_id_5d4b5917dc; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_role_id_project_id_5d4b5917dc ON public.namespace_role_project_assignments USING btree (role_id, project_id);


--
-- Name: idx_on_runtime_function_definition_id_data_type_id_b6aa8fe066; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_on_runtime_function_definition_id_data_type_id_b6aa8fe066 ON public.runtime_function_definition_error_types USING btree (runtime_function_definition_id, data_type_id);


--
-- Name: idx_on_runtime_function_definition_id_f0f8f95496; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_runtime_function_definition_id_f0f8f95496 ON public.function_generic_mappers USING btree (runtime_function_definition_id);


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
-- Name: idx_on_runtime_parameter_definition_id_3cbdb30381; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_runtime_parameter_definition_id_3cbdb30381 ON public.function_generic_mappers USING btree (runtime_parameter_definition_id);


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
-- Name: index_audit_events_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_audit_events_on_author_id ON public.audit_events USING btree (author_id);


--
-- Name: index_backup_codes_on_user_id_LOWER_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_backup_codes_on_user_id_LOWER_token" ON public.backup_codes USING btree (user_id, lower(token));


--
-- Name: index_data_type_identifiers_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_identifiers_on_data_type_id ON public.data_type_identifiers USING btree (data_type_id);


--
-- Name: index_data_type_identifiers_on_function_generic_mapper_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_identifiers_on_function_generic_mapper_id ON public.data_type_identifiers USING btree (function_generic_mapper_id);


--
-- Name: index_data_type_identifiers_on_generic_mapper_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_identifiers_on_generic_mapper_id ON public.data_type_identifiers USING btree (generic_mapper_id);


--
-- Name: index_data_type_identifiers_on_generic_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_identifiers_on_generic_type_id ON public.data_type_identifiers USING btree (generic_type_id);


--
-- Name: index_data_type_identifiers_on_runtime_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_identifiers_on_runtime_id ON public.data_type_identifiers USING btree (runtime_id);


--
-- Name: index_data_type_rules_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_type_rules_on_data_type_id ON public.data_type_rules USING btree (data_type_id);


--
-- Name: index_data_types_on_flows_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_types_on_flows_id ON public.data_types USING btree (flows_id);


--
-- Name: index_data_types_on_parent_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_data_types_on_parent_type_id ON public.data_types USING btree (parent_type_id);


--
-- Name: index_data_types_on_runtime_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_data_types_on_runtime_id_and_identifier ON public.data_types USING btree (runtime_id, identifier);


--
-- Name: index_flow_settings_on_flow_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flow_settings_on_flow_id ON public.flow_settings USING btree (flow_id);


--
-- Name: index_flow_type_settings_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flow_type_settings_on_data_type_id ON public.flow_type_settings USING btree (data_type_id);


--
-- Name: index_flow_type_settings_on_flow_type_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flow_type_settings_on_flow_type_id_and_identifier ON public.flow_type_settings USING btree (flow_type_id, identifier);


--
-- Name: index_flow_types_on_input_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flow_types_on_input_type_id ON public.flow_types USING btree (input_type_id);


--
-- Name: index_flow_types_on_return_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flow_types_on_return_type_id ON public.flow_types USING btree (return_type_id);


--
-- Name: index_flow_types_on_runtime_id_and_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_flow_types_on_runtime_id_and_identifier ON public.flow_types USING btree (runtime_id, identifier);


--
-- Name: index_flows_on_flow_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_flow_type_id ON public.flows USING btree (flow_type_id);


--
-- Name: index_flows_on_input_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_input_type_id ON public.flows USING btree (input_type_id);


--
-- Name: index_flows_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_project_id ON public.flows USING btree (project_id);


--
-- Name: index_flows_on_return_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_return_type_id ON public.flows USING btree (return_type_id);


--
-- Name: index_flows_on_starting_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_flows_on_starting_node_id ON public.flows USING btree (starting_node_id);


--
-- Name: index_function_definitions_on_return_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_function_definitions_on_return_type_id ON public.function_definitions USING btree (return_type_id);


--
-- Name: index_function_definitions_on_runtime_function_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_function_definitions_on_runtime_function_definition_id ON public.function_definitions USING btree (runtime_function_definition_id);


--
-- Name: index_function_generic_mappers_on_runtime_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_function_generic_mappers_on_runtime_id ON public.function_generic_mappers USING btree (runtime_id);


--
-- Name: index_generic_combination_strategies_on_generic_mapper_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_generic_combination_strategies_on_generic_mapper_id ON public.generic_combination_strategies USING btree (generic_mapper_id);


--
-- Name: index_generic_mappers_on_generic_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_generic_mappers_on_generic_type_id ON public.generic_mappers USING btree (generic_type_id);


--
-- Name: index_generic_mappers_on_runtime_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_generic_mappers_on_runtime_id ON public.generic_mappers USING btree (runtime_id);


--
-- Name: index_generic_types_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_generic_types_on_data_type_id ON public.generic_types USING btree (data_type_id);


--
-- Name: index_generic_types_on_runtime_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_generic_types_on_runtime_id ON public.generic_types USING btree (runtime_id);


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
-- Name: index_good_jobs_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_jobs_on_finished_at ON public.good_jobs USING btree (finished_at) WHERE ((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL));


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
-- Name: index_good_jobs_on_cron_key_and_created_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_cron_key_and_created_at_cond ON public.good_jobs USING btree (cron_key, created_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_cron_key_and_cron_at_cond; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_good_jobs_on_cron_key_and_cron_at_cond ON public.good_jobs USING btree (cron_key, cron_at) WHERE (cron_key IS NOT NULL);


--
-- Name: index_good_jobs_on_labels; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_labels ON public.good_jobs USING gin (labels) WHERE (labels IS NOT NULL);


--
-- Name: index_good_jobs_on_locked_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_locked_by_id ON public.good_jobs USING btree (locked_by_id) WHERE (locked_by_id IS NOT NULL);


--
-- Name: index_good_jobs_on_priority_scheduled_at_unfinished_unlocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_priority_scheduled_at_unfinished_unlocked ON public.good_jobs USING btree (priority, scheduled_at) WHERE ((finished_at IS NULL) AND (locked_by_id IS NULL));


--
-- Name: index_good_jobs_on_queue_name_and_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_queue_name_and_scheduled_at ON public.good_jobs USING btree (queue_name, scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_good_jobs_on_scheduled_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_jobs_on_scheduled_at ON public.good_jobs USING btree (scheduled_at) WHERE (finished_at IS NULL);


--
-- Name: index_namespace_licenses_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_namespace_licenses_on_namespace_id ON public.namespace_licenses USING btree (namespace_id);


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
-- Name: index_node_functions_on_next_node_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_functions_on_next_node_id ON public.node_functions USING btree (next_node_id);


--
-- Name: index_node_functions_on_runtime_function_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_functions_on_runtime_function_id ON public.node_functions USING btree (runtime_function_id);


--
-- Name: index_node_parameters_on_function_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_parameters_on_function_value_id ON public.node_parameters USING btree (function_value_id);


--
-- Name: index_node_parameters_on_node_function_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_parameters_on_node_function_id ON public.node_parameters USING btree (node_function_id);


--
-- Name: index_node_parameters_on_reference_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_parameters_on_reference_value_id ON public.node_parameters USING btree (reference_value_id);


--
-- Name: index_node_parameters_on_runtime_parameter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_node_parameters_on_runtime_parameter_id ON public.node_parameters USING btree (runtime_parameter_id);


--
-- Name: index_organizations_on_LOWER_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "index_organizations_on_LOWER_name" ON public.organizations USING btree (lower(name));


--
-- Name: index_parameter_definitions_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parameter_definitions_on_data_type_id ON public.parameter_definitions USING btree (data_type_id);


--
-- Name: index_parameter_definitions_on_runtime_parameter_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_parameter_definitions_on_runtime_parameter_definition_id ON public.parameter_definitions USING btree (runtime_parameter_definition_id);


--
-- Name: index_reference_paths_on_reference_value_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_paths_on_reference_value_id ON public.reference_paths USING btree (reference_value_id);


--
-- Name: index_reference_values_on_data_type_identifier_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reference_values_on_data_type_identifier_id ON public.reference_values USING btree (data_type_identifier_id);


--
-- Name: index_runtime_function_definitions_on_return_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_runtime_function_definitions_on_return_type_id ON public.runtime_function_definitions USING btree (return_type_id);


--
-- Name: index_runtime_parameter_definitions_on_data_type_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_runtime_parameter_definitions_on_data_type_id ON public.runtime_parameter_definitions USING btree (data_type_id);


--
-- Name: index_runtimes_on_namespace_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_runtimes_on_namespace_id ON public.runtimes USING btree (namespace_id);


--
-- Name: index_runtimes_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_runtimes_on_token ON public.runtimes USING btree (token);


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
-- Name: index_users_on_totp_secret; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_totp_secret ON public.users USING btree (totp_secret) WHERE (totp_secret IS NOT NULL);


--
-- Name: flow_types fk_rails_01f5c9215f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types
    ADD CONSTRAINT fk_rails_01f5c9215f FOREIGN KEY (input_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: data_type_identifiers fk_rails_01f5d14544; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers
    ADD CONSTRAINT fk_rails_01f5d14544 FOREIGN KEY (generic_mapper_id) REFERENCES public.generic_mappers(id) ON DELETE RESTRICT;


--
-- Name: runtime_function_definition_error_types fk_rails_070c5bfcf0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_error_types
    ADD CONSTRAINT fk_rails_070c5bfcf0 FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE CASCADE;


--
-- Name: function_definitions fk_rails_0c2eb746ef; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions
    ADD CONSTRAINT fk_rails_0c2eb746ef FOREIGN KEY (return_type_id) REFERENCES public.data_type_identifiers(id) ON DELETE RESTRICT;


--
-- Name: node_parameters fk_rails_0d79310cfa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT fk_rails_0d79310cfa FOREIGN KEY (node_function_id) REFERENCES public.node_functions(id) ON DELETE CASCADE;


--
-- Name: node_parameters fk_rails_0ff4fd0049; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT fk_rails_0ff4fd0049 FOREIGN KEY (runtime_parameter_id) REFERENCES public.runtime_parameter_definitions(id) ON DELETE CASCADE;


--
-- Name: data_types fk_rails_118c914ed0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT fk_rails_118c914ed0 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: generic_combination_strategies fk_rails_1f88a2577e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_combination_strategies
    ADD CONSTRAINT fk_rails_1f88a2577e FOREIGN KEY (generic_mapper_id) REFERENCES public.generic_mappers(id) ON DELETE CASCADE;


--
-- Name: namespace_roles fk_rails_205092c9cb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_roles
    ADD CONSTRAINT fk_rails_205092c9cb FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: generic_types fk_rails_20f4bf6b34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_types
    ADD CONSTRAINT fk_rails_20f4bf6b34 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: runtime_parameter_definitions fk_rails_260318ad67; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions
    ADD CONSTRAINT fk_rails_260318ad67 FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE CASCADE;


--
-- Name: function_generic_mappers fk_rails_26b6470eba; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_generic_mappers
    ADD CONSTRAINT fk_rails_26b6470eba FOREIGN KEY (runtime_parameter_definition_id) REFERENCES public.runtime_parameter_definitions(id) ON DELETE RESTRICT;


--
-- Name: generic_types fk_rails_275446d9e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_types
    ADD CONSTRAINT fk_rails_275446d9e6 FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE CASCADE;


--
-- Name: namespace_licenses fk_rails_38f693332d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_licenses
    ADD CONSTRAINT fk_rails_38f693332d FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id) ON DELETE CASCADE;


--
-- Name: parameter_definitions fk_rails_3b02763f84; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_definitions
    ADD CONSTRAINT fk_rails_3b02763f84 FOREIGN KEY (runtime_parameter_definition_id) REFERENCES public.runtime_parameter_definitions(id) ON DELETE CASCADE;


--
-- Name: runtime_function_definition_error_types fk_rails_408d037751; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definition_error_types
    ADD CONSTRAINT fk_rails_408d037751 FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: data_type_identifiers fk_rails_40d8496abb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers
    ADD CONSTRAINT fk_rails_40d8496abb FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: data_types fk_rails_4434ad0b90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT fk_rails_4434ad0b90 FOREIGN KEY (parent_type_id) REFERENCES public.data_type_identifiers(id) ON DELETE RESTRICT;


--
-- Name: function_generic_mappers fk_rails_4593a9a9b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_generic_mappers
    ADD CONSTRAINT fk_rails_4593a9a9b6 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: function_definitions fk_rails_48f4bbe3b6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_definitions
    ADD CONSTRAINT fk_rails_48f4bbe3b6 FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE CASCADE;


--
-- Name: data_types fk_rails_490081f598; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_types
    ADD CONSTRAINT fk_rails_490081f598 FOREIGN KEY (flows_id) REFERENCES public.flows(id) ON DELETE RESTRICT;


--
-- Name: runtime_function_definitions fk_rails_5161ff47e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions
    ADD CONSTRAINT fk_rails_5161ff47e6 FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: backup_codes fk_rails_556c1feac3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.backup_codes
    ADD CONSTRAINT fk_rails_556c1feac3 FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


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
-- Name: namespace_role_project_assignments fk_rails_623f8a5b72; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_role_project_assignments
    ADD CONSTRAINT fk_rails_623f8a5b72 FOREIGN KEY (role_id) REFERENCES public.namespace_roles(id);


--
-- Name: node_parameters fk_rails_646d4dbfbc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT fk_rails_646d4dbfbc FOREIGN KEY (reference_value_id) REFERENCES public.reference_values(id) ON DELETE RESTRICT;


--
-- Name: data_type_identifiers fk_rails_65151da1fb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers
    ADD CONSTRAINT fk_rails_65151da1fb FOREIGN KEY (generic_type_id) REFERENCES public.generic_types(id) ON DELETE CASCADE;


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
    ADD CONSTRAINT fk_rails_69066bda8f FOREIGN KEY (project_id) REFERENCES public.namespace_projects(id);


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
-- Name: runtime_function_definitions fk_rails_73ca8569ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_function_definitions
    ADD CONSTRAINT fk_rails_73ca8569ea FOREIGN KEY (return_type_id) REFERENCES public.data_type_identifiers(id) ON DELETE RESTRICT;


--
-- Name: node_parameters fk_rails_74b7800b37; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_parameters
    ADD CONSTRAINT fk_rails_74b7800b37 FOREIGN KEY (function_value_id) REFERENCES public.node_functions(id) ON DELETE RESTRICT;


--
-- Name: data_type_rules fk_rails_7759633ff8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_rules
    ADD CONSTRAINT fk_rails_7759633ff8 FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE CASCADE;


--
-- Name: namespace_projects fk_rails_79012c5895; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.namespace_projects
    ADD CONSTRAINT fk_rails_79012c5895 FOREIGN KEY (primary_runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: flows fk_rails_7de9ce6578; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_7de9ce6578 FOREIGN KEY (starting_node_id) REFERENCES public.node_functions(id) ON DELETE RESTRICT;


--
-- Name: node_functions fk_rails_8953e1d86a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions
    ADD CONSTRAINT fk_rails_8953e1d86a FOREIGN KEY (runtime_function_id) REFERENCES public.runtime_function_definitions(id) ON DELETE RESTRICT;


--
-- Name: data_type_identifiers fk_rails_8d8385e8ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers
    ADD CONSTRAINT fk_rails_8d8385e8ec FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: flows fk_rails_8f97500cd4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_8f97500cd4 FOREIGN KEY (return_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: reference_paths fk_rails_92e51047ea; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_paths
    ADD CONSTRAINT fk_rails_92e51047ea FOREIGN KEY (reference_value_id) REFERENCES public.reference_values(id) ON DELETE RESTRICT;


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: function_generic_mappers fk_rails_9f59fae6ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.function_generic_mappers
    ADD CONSTRAINT fk_rails_9f59fae6ab FOREIGN KEY (runtime_function_definition_id) REFERENCES public.runtime_function_definitions(id) ON DELETE RESTRICT;


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
-- Name: flow_type_settings fk_rails_a1471d011d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_settings
    ADD CONSTRAINT fk_rails_a1471d011d FOREIGN KEY (data_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: flows fk_rails_ab927e0ecb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_ab927e0ecb FOREIGN KEY (project_id) REFERENCES public.namespace_projects(id) ON DELETE CASCADE;


--
-- Name: reference_values fk_rails_bb34a5d62c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reference_values
    ADD CONSTRAINT fk_rails_bb34a5d62c FOREIGN KEY (data_type_identifier_id) REFERENCES public.data_type_identifiers(id) ON DELETE RESTRICT;


--
-- Name: flows fk_rails_bb587eff6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flows
    ADD CONSTRAINT fk_rails_bb587eff6a FOREIGN KEY (input_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


--
-- Name: flow_types fk_rails_bead35b1a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_types
    ADD CONSTRAINT fk_rails_bead35b1a6 FOREIGN KEY (return_type_id) REFERENCES public.data_types(id) ON DELETE RESTRICT;


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
-- Name: generic_mappers fk_rails_c7984c8a7a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_mappers
    ADD CONSTRAINT fk_rails_c7984c8a7a FOREIGN KEY (runtime_id) REFERENCES public.runtimes(id) ON DELETE CASCADE;


--
-- Name: parameter_definitions fk_rails_ca0a397b6f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.parameter_definitions
    ADD CONSTRAINT fk_rails_ca0a397b6f FOREIGN KEY (data_type_id) REFERENCES public.data_type_identifiers(id) ON DELETE RESTRICT;


--
-- Name: data_type_identifiers fk_rails_d08626f743; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.data_type_identifiers
    ADD CONSTRAINT fk_rails_d08626f743 FOREIGN KEY (function_generic_mapper_id) REFERENCES public.function_generic_mappers(id) ON DELETE RESTRICT;


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
-- Name: generic_mappers fk_rails_e0d918961b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generic_mappers
    ADD CONSTRAINT fk_rails_e0d918961b FOREIGN KEY (generic_type_id) REFERENCES public.generic_types(id) ON DELETE RESTRICT;


--
-- Name: runtime_parameter_definitions fk_rails_e64f825793; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtime_parameter_definitions
    ADD CONSTRAINT fk_rails_e64f825793 FOREIGN KEY (data_type_id) REFERENCES public.data_type_identifiers(id) ON DELETE RESTRICT;


--
-- Name: runtimes fk_rails_eeb42116cc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runtimes
    ADD CONSTRAINT fk_rails_eeb42116cc FOREIGN KEY (namespace_id) REFERENCES public.namespaces(id);


--
-- Name: audit_events fk_rails_f64374fc56; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.audit_events
    ADD CONSTRAINT fk_rails_f64374fc56 FOREIGN KEY (author_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: flow_type_settings fk_rails_f6af7d8edf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.flow_type_settings
    ADD CONSTRAINT fk_rails_f6af7d8edf FOREIGN KEY (flow_type_id) REFERENCES public.flow_types(id) ON DELETE CASCADE;


--
-- Name: node_functions fk_rails_fbc91a3407; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node_functions
    ADD CONSTRAINT fk_rails_fbc91a3407 FOREIGN KEY (next_node_id) REFERENCES public.node_functions(id) ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;



