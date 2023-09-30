--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Debian 14.2-1.pgdg110+1)
-- Dumped by pg_dump version 14.9 (Ubuntu 14.9-1.pgdg20.04+1)

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

--
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: isn; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS isn WITH SCHEMA public;


--
-- Name: EXTENSION isn; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION isn IS 'data types for international product numbering standards';


--
-- Name: lo; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS lo WITH SCHEMA public;


--
-- Name: EXTENSION lo; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION lo IS 'Large Object maintenance';


--
-- Name: ltree; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS ltree WITH SCHEMA public;


--
-- Name: EXTENSION ltree; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION ltree IS 'data type for hierarchical tree-like structures';


--
-- Name: pg_buffercache; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_buffercache WITH SCHEMA public;


--
-- Name: EXTENSION pg_buffercache; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_buffercache IS 'examine the shared buffer cache';


--
-- Name: pg_prewarm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_prewarm WITH SCHEMA public;


--
-- Name: EXTENSION pg_prewarm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_prewarm IS 'prewarm relation data';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgrowlocks; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgrowlocks WITH SCHEMA public;


--
-- Name: EXTENSION pgrowlocks; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgrowlocks IS 'show row-level locking information';


--
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


--
-- Name: oban_job_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.oban_job_state AS ENUM (
    'available',
    'scheduled',
    'executing',
    'retryable',
    'completed',
    'discarded',
    'cancelled'
);


--
-- Name: oban_jobs_notify(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.oban_jobs_notify() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  channel text;
  notice json;
BEGIN
  IF NEW.state = 'available' THEN
    channel = 'public.oban_insert';
    notice = json_build_object('queue', NEW.queue);

    PERFORM pg_notify(channel, notice::text);
  END IF;

  RETURN NULL;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts (
    id uuid NOT NULL,
    email_address public.citext NOT NULL,
    confirmed_at timestamp(0) without time zone,
    username public.citext,
    onboarding_state public.citext NOT NULL,
    hashed_password character varying(255) NOT NULL,
    profile jsonb DEFAULT '{}'::jsonb NOT NULL,
    settings jsonb DEFAULT '{}'::jsonb NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    provider text,
    provider_access_token text,
    provider_refresh_token text,
    provider_token_expiration integer,
    provider_id text,
    avatar_uri text,
    provider_scopes text[] DEFAULT ARRAY[]::text[]
);


--
-- Name: accounts_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.accounts_tokens (
    id uuid NOT NULL,
    account_id uuid NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: acts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acts (
    id uuid NOT NULL,
    world_id uuid NOT NULL,
    adventure_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    "position" double precision NOT NULL,
    name text,
    location_id uuid,
    name_structure integer
);


--
-- Name: adventure_descriptor_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adventure_descriptor_options (
    id uuid NOT NULL,
    name text,
    tags text[],
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: adventure_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adventure_people (
    id uuid NOT NULL,
    person_id uuid NOT NULL,
    adventure_id uuid NOT NULL,
    role public.citext NOT NULL
);


--
-- Name: adventures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.adventures (
    id uuid NOT NULL,
    theme text,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    name text,
    action text,
    descriptor text,
    stage text,
    location_id uuid,
    incidents text[],
    setups text[],
    stakes text[],
    name_structure integer
);


--
-- Name: archetype_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.archetype_options (
    id uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    goals text[]
);


--
-- Name: artifacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.artifacts (
    id uuid NOT NULL,
    name text,
    description text,
    owner_person_id uuid,
    location_id uuid,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    pronouns jsonb,
    name_structure integer
);


--
-- Name: asset_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.asset_options (
    id uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    type text[] NOT NULL,
    weight integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: background_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.background_options (
    id uuid NOT NULL,
    name text NOT NULL,
    proficiencies text[] NOT NULL,
    languages text[] NOT NULL,
    special text NOT NULL,
    specials text[] NOT NULL,
    origin text NOT NULL,
    origins text[] NOT NULL,
    personalities text[] NOT NULL,
    ideals text[] NOT NULL,
    bonds text[] NOT NULL,
    flaws text[] NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    goals text[]
);


--
-- Name: cultural_arts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_arts (
    id uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultural_ethoses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_ethoses (
    id uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultural_gender_preference_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_gender_preference_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultural_phase_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_phase_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultural_pillar_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_pillar_options (
    id uuid NOT NULL,
    name text[] NOT NULL,
    description text[] NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultural_scale_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_scale_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultural_society_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultural_society_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: culture_languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.culture_languages (
    id uuid NOT NULL,
    language_id uuid,
    culture_id uuid,
    phase public.citext,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: cultures; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cultures (
    id uuid NOT NULL,
    name text,
    scale text,
    arts text[],
    society text,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    ethos text,
    phase text,
    figurehead_gender_preference text,
    pillars text[],
    naming_onomastics text[]
);


--
-- Name: deities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.deities (
    id uuid NOT NULL,
    domains text[] NOT NULL,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    pantheon_id uuid NOT NULL,
    person_id uuid,
    symbols text[],
    animals text[]
);


--
-- Name: encounter_context_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encounter_context_options (
    id uuid NOT NULL,
    name text NOT NULL,
    theme text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: encounter_monsters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encounter_monsters (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    monster_id uuid NOT NULL,
    encounter_id uuid NOT NULL
);


--
-- Name: encounters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.encounters (
    id uuid NOT NULL,
    context text,
    rating integer,
    act_id uuid,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: gender_identity_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gender_identity_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: gender_presentation_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gender_presentation_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: generations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generations (
    id uuid NOT NULL,
    resource_id uuid NOT NULL,
    property public.citext NOT NULL,
    state boolean NOT NULL,
    world_id uuid NOT NULL,
    randomizer text NOT NULL
);


--
-- Name: government_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.government_memberships (
    id uuid NOT NULL,
    role text NOT NULL,
    person_id uuid NOT NULL,
    government_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: governments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.governments (
    id uuid NOT NULL,
    name text,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: gpu_servers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.gpu_servers (
    id uuid NOT NULL,
    origin text,
    secret text,
    busy boolean DEFAULT true NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    name text,
    power public.citext DEFAULT 'off'::public.citext NOT NULL
);


--
-- Name: group_age_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_age_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: group_goal_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_goal_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: group_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_memberships (
    id uuid NOT NULL,
    role text NOT NULL,
    person_id uuid NOT NULL,
    group_id uuid NOT NULL
);


--
-- Name: group_scope_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_scope_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: group_size_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_size_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id uuid NOT NULL,
    name text,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    size text,
    age text,
    type text,
    assets jsonb[],
    headquarters jsonb,
    scope text,
    goals text,
    name_structure integer
);


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id uuid NOT NULL,
    person_id uuid NOT NULL,
    by_culture_id uuid,
    name text,
    titles text[],
    world_id uuid,
    pronouns jsonb
);


--
-- Name: image_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.image_batches (
    id uuid NOT NULL,
    prompt text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    subject_artifact_id uuid,
    subject_deity_id uuid,
    subject_religion_id uuid,
    subject_pantheon_id uuid,
    subject_person_id uuid,
    subject_location_id uuid,
    subject_group_id uuid,
    subject_government_id uuid
);


--
-- Name: images; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.images (
    id uuid NOT NULL,
    content bytea NOT NULL,
    image_batch_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languages (
    id uuid NOT NULL,
    name text,
    parent_language_id uuid,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: location_development_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_development_options (
    id uuid NOT NULL,
    name text NOT NULL,
    theme text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: location_embellishment_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_embellishment_options (
    id uuid NOT NULL,
    name text NOT NULL,
    theme text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: location_founding_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.location_founding_options (
    id uuid NOT NULL,
    name text NOT NULL,
    theme text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.locations (
    id uuid NOT NULL,
    type text,
    terrain text,
    founding text,
    development text,
    descriptor text,
    embellishment text,
    altdescriptor text,
    enhancer text,
    specific text,
    form integer,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    name text
);


--
-- Name: monsters; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monsters (
    id uuid NOT NULL,
    name text NOT NULL,
    size text NOT NULL,
    alignment text NOT NULL,
    source text NOT NULL,
    tags text[] NOT NULL,
    challenge double precision NOT NULL,
    xp integer NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: name_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.name_options (
    id text NOT NULL,
    tags text[] NOT NULL,
    trigrams text[] NOT NULL
);


--
-- Name: oban_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.oban_jobs (
    id bigint NOT NULL,
    state public.oban_job_state DEFAULT 'available'::public.oban_job_state NOT NULL,
    queue text DEFAULT 'default'::text NOT NULL,
    worker text NOT NULL,
    args jsonb DEFAULT '{}'::jsonb NOT NULL,
    errors jsonb[] DEFAULT ARRAY[]::jsonb[] NOT NULL,
    attempt integer DEFAULT 0 NOT NULL,
    max_attempts integer DEFAULT 20 NOT NULL,
    inserted_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    scheduled_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL,
    attempted_at timestamp without time zone,
    completed_at timestamp without time zone,
    attempted_by text[],
    discarded_at timestamp without time zone,
    priority integer DEFAULT 0 NOT NULL,
    tags character varying(255)[] DEFAULT ARRAY[]::character varying[],
    meta jsonb DEFAULT '{}'::jsonb,
    cancelled_at timestamp without time zone,
    CONSTRAINT attempt_range CHECK (((attempt >= 0) AND (attempt <= max_attempts))),
    CONSTRAINT positive_max_attempts CHECK ((max_attempts > 0)),
    CONSTRAINT priority_range CHECK (((priority >= 0) AND (priority <= 3))),
    CONSTRAINT queue_length CHECK (((char_length(queue) > 0) AND (char_length(queue) < 128))),
    CONSTRAINT worker_length CHECK (((char_length(worker) > 0) AND (char_length(worker) < 128)))
);


--
-- Name: TABLE oban_jobs; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.oban_jobs IS '11';


--
-- Name: oban_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.oban_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oban_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.oban_jobs_id_seq OWNED BY public.oban_jobs.id;


--
-- Name: oban_peers; Type: TABLE; Schema: public; Owner: -
--

CREATE UNLOGGED TABLE public.oban_peers (
    name text NOT NULL,
    node text NOT NULL,
    started_at timestamp without time zone NOT NULL,
    expires_at timestamp without time zone NOT NULL
);


--
-- Name: objective_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.objective_options (
    id uuid NOT NULL,
    name text NOT NULL,
    long_form text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    methods jsonb NOT NULL
);


--
-- Name: organization_memberships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_memberships (
    id uuid NOT NULL,
    account_id uuid NOT NULL,
    organization_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: organization_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_permissions (
    id uuid NOT NULL,
    permission_id uuid NOT NULL,
    organization_membership_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id uuid NOT NULL,
    name text NOT NULL,
    slug public.citext NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: pantheons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pantheons (
    id uuid NOT NULL,
    name text,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.people (
    id uuid NOT NULL,
    type text,
    race text,
    role text,
    theme text,
    background jsonb,
    objective jsonb,
    appearance jsonb,
    religion_id uuid,
    culture_id uuid,
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    traits jsonb[],
    archetype_option_id uuid,
    background_option_id uuid,
    goal text,
    gender_identity text,
    gender_presentation text
);


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.permissions (
    id uuid NOT NULL,
    name text NOT NULL,
    slug public.citext NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: person_appearance_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_appearance_options (
    id uuid NOT NULL,
    name text NOT NULL,
    type text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: person_goal_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_goal_options (
    id uuid NOT NULL,
    description text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: person_role_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_role_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: person_type_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.person_type_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: race_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.race_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: religion_pantheons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.religion_pantheons (
    id uuid NOT NULL,
    religion_id uuid NOT NULL,
    pantheon_id uuid NOT NULL
);


--
-- Name: religion_value_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.religion_value_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: religions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.religions (
    id uuid NOT NULL,
    name text,
    "values" text[],
    world_id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: room_detail_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.room_detail_options (
    id uuid NOT NULL,
    name text NOT NULL,
    theme text NOT NULL,
    type text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.rooms (
    id uuid NOT NULL,
    type text,
    terrain text,
    specific text,
    size text,
    door_material text,
    door_latch text,
    door_feature text,
    floor_material text,
    floor_feature text,
    ceiling_shape text,
    ceiling_feature text,
    wall_details text,
    notable_contents text,
    encounter_id uuid,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id uuid NOT NULL,
    name text NOT NULL,
    slug public.citext NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trait_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trait_options (
    id uuid NOT NULL,
    name text NOT NULL,
    description text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_bait_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_bait_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_effect_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_effect_options (
    id uuid NOT NULL,
    name text NOT NULL,
    specific text[] NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_lethality_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_lethality_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_location_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_location_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_purpose_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_purpose_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_reset_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_reset_options (
    id uuid NOT NULL,
    name text NOT NULL,
    specific text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_trigger_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_trigger_options (
    id uuid NOT NULL,
    name text NOT NULL,
    specific text[] NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: trap_type_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trap_type_options (
    id uuid NOT NULL,
    name text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: traps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.traps (
    id uuid NOT NULL,
    type text,
    lethality text,
    purpose text,
    trigger jsonb,
    mechanism jsonb,
    effect jsonb,
    encounter_id uuid,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.versions (
    id bigint NOT NULL,
    event public.citext NOT NULL,
    item_type text NOT NULL,
    item_id uuid NOT NULL,
    item_changes jsonb NOT NULL,
    originator_id uuid,
    origin text,
    meta jsonb,
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.versions_id_seq OWNED BY public.versions.id;


--
-- Name: webhooks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.webhooks (
    id uuid NOT NULL,
    provider public.citext NOT NULL,
    headers jsonb NOT NULL,
    payload jsonb NOT NULL
);


--
-- Name: word_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.word_options (
    id text NOT NULL,
    tags text[] NOT NULL
);


--
-- Name: worlds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.worlds (
    id uuid NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    name text,
    shape double precision[],
    organization_id uuid
);


--
-- Name: oban_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oban_jobs ALTER COLUMN id SET DEFAULT nextval('public.oban_jobs_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions ALTER COLUMN id SET DEFAULT nextval('public.versions_id_seq'::regclass);


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: accounts_tokens accounts_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts_tokens
    ADD CONSTRAINT accounts_tokens_pkey PRIMARY KEY (id);


--
-- Name: acts acts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts
    ADD CONSTRAINT acts_pkey PRIMARY KEY (id);


--
-- Name: adventure_descriptor_options adventure_descriptor_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventure_descriptor_options
    ADD CONSTRAINT adventure_descriptor_options_pkey PRIMARY KEY (id);


--
-- Name: adventure_people adventure_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventure_people
    ADD CONSTRAINT adventure_people_pkey PRIMARY KEY (id);


--
-- Name: adventures adventures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventures
    ADD CONSTRAINT adventures_pkey PRIMARY KEY (id);


--
-- Name: archetype_options archetypes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.archetype_options
    ADD CONSTRAINT archetypes_pkey PRIMARY KEY (id);


--
-- Name: artifacts artifacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_pkey PRIMARY KEY (id);


--
-- Name: asset_options asset_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.asset_options
    ADD CONSTRAINT asset_options_pkey PRIMARY KEY (id);


--
-- Name: background_options background_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.background_options
    ADD CONSTRAINT background_options_pkey PRIMARY KEY (id);


--
-- Name: cultural_arts cultural_arts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_arts
    ADD CONSTRAINT cultural_arts_pkey PRIMARY KEY (id);


--
-- Name: cultural_ethoses cultural_ethoses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_ethoses
    ADD CONSTRAINT cultural_ethoses_pkey PRIMARY KEY (id);


--
-- Name: cultural_gender_preference_options cultural_gender_preference_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_gender_preference_options
    ADD CONSTRAINT cultural_gender_preference_options_pkey PRIMARY KEY (id);


--
-- Name: cultural_phase_options cultural_phase_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_phase_options
    ADD CONSTRAINT cultural_phase_options_pkey PRIMARY KEY (id);


--
-- Name: cultural_pillar_options cultural_pillars_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_pillar_options
    ADD CONSTRAINT cultural_pillars_pkey PRIMARY KEY (id);


--
-- Name: cultural_scale_options cultural_scale_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_scale_options
    ADD CONSTRAINT cultural_scale_options_pkey PRIMARY KEY (id);


--
-- Name: cultural_society_options cultural_society_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultural_society_options
    ADD CONSTRAINT cultural_society_options_pkey PRIMARY KEY (id);


--
-- Name: culture_languages culture_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.culture_languages
    ADD CONSTRAINT culture_languages_pkey PRIMARY KEY (id);


--
-- Name: cultures cultures_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultures
    ADD CONSTRAINT cultures_pkey PRIMARY KEY (id);


--
-- Name: deities deities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deities
    ADD CONSTRAINT deities_pkey PRIMARY KEY (id);


--
-- Name: encounter_context_options encounter_context_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encounter_context_options
    ADD CONSTRAINT encounter_context_options_pkey PRIMARY KEY (id);


--
-- Name: encounter_monsters encounter_monsters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encounter_monsters
    ADD CONSTRAINT encounter_monsters_pkey PRIMARY KEY (id);


--
-- Name: encounters encounters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encounters
    ADD CONSTRAINT encounters_pkey PRIMARY KEY (id);


--
-- Name: gender_identity_options gender_identity_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gender_identity_options
    ADD CONSTRAINT gender_identity_options_pkey PRIMARY KEY (id);


--
-- Name: gender_presentation_options gender_presentation_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gender_presentation_options
    ADD CONSTRAINT gender_presentation_options_pkey PRIMARY KEY (id);


--
-- Name: generations generations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generations
    ADD CONSTRAINT generations_pkey PRIMARY KEY (id);


--
-- Name: government_memberships government_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.government_memberships
    ADD CONSTRAINT government_memberships_pkey PRIMARY KEY (id);


--
-- Name: governments governments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.governments
    ADD CONSTRAINT governments_pkey PRIMARY KEY (id);


--
-- Name: gpu_servers gpu_servers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.gpu_servers
    ADD CONSTRAINT gpu_servers_pkey PRIMARY KEY (id);


--
-- Name: group_age_options group_age_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_age_options
    ADD CONSTRAINT group_age_options_pkey PRIMARY KEY (id);


--
-- Name: group_goal_options group_goal_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_goal_options
    ADD CONSTRAINT group_goal_options_pkey PRIMARY KEY (id);


--
-- Name: group_memberships group_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_memberships
    ADD CONSTRAINT group_memberships_pkey PRIMARY KEY (id);


--
-- Name: group_scope_options group_scope_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_scope_options
    ADD CONSTRAINT group_scope_options_pkey PRIMARY KEY (id);


--
-- Name: group_size_options group_size_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_size_options
    ADD CONSTRAINT group_size_options_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: image_batches image_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_pkey PRIMARY KEY (id);


--
-- Name: images images_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: location_development_options location_development_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_development_options
    ADD CONSTRAINT location_development_options_pkey PRIMARY KEY (id);


--
-- Name: location_embellishment_options location_embellishment_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_embellishment_options
    ADD CONSTRAINT location_embellishment_options_pkey PRIMARY KEY (id);


--
-- Name: location_founding_options location_founding_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.location_founding_options
    ADD CONSTRAINT location_founding_options_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: monsters monsters_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monsters
    ADD CONSTRAINT monsters_pkey PRIMARY KEY (id);


--
-- Name: name_options name_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.name_options
    ADD CONSTRAINT name_options_pkey PRIMARY KEY (id);


--
-- Name: oban_jobs oban_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oban_jobs
    ADD CONSTRAINT oban_jobs_pkey PRIMARY KEY (id);


--
-- Name: oban_peers oban_peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.oban_peers
    ADD CONSTRAINT oban_peers_pkey PRIMARY KEY (name);


--
-- Name: objective_options objectives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.objective_options
    ADD CONSTRAINT objectives_pkey PRIMARY KEY (id);


--
-- Name: organization_memberships organization_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_memberships
    ADD CONSTRAINT organization_memberships_pkey PRIMARY KEY (id);


--
-- Name: organization_permissions organization_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_permissions
    ADD CONSTRAINT organization_permissions_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: pantheons pantheons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pantheons
    ADD CONSTRAINT pantheons_pkey PRIMARY KEY (id);


--
-- Name: people people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: person_appearance_options person_appearance_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_appearance_options
    ADD CONSTRAINT person_appearance_options_pkey PRIMARY KEY (id);


--
-- Name: person_goal_options person_goal_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_goal_options
    ADD CONSTRAINT person_goal_options_pkey PRIMARY KEY (id);


--
-- Name: person_role_options person_role_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_role_options
    ADD CONSTRAINT person_role_options_pkey PRIMARY KEY (id);


--
-- Name: person_type_options person_type_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.person_type_options
    ADD CONSTRAINT person_type_options_pkey PRIMARY KEY (id);


--
-- Name: race_options race_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.race_options
    ADD CONSTRAINT race_options_pkey PRIMARY KEY (id);


--
-- Name: religion_pantheons religion_pantheons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.religion_pantheons
    ADD CONSTRAINT religion_pantheons_pkey PRIMARY KEY (id);


--
-- Name: religion_value_options religion_value_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.religion_value_options
    ADD CONSTRAINT religion_value_options_pkey PRIMARY KEY (id);


--
-- Name: religions religions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.religions
    ADD CONSTRAINT religions_pkey PRIMARY KEY (id);


--
-- Name: room_detail_options room_detail_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.room_detail_options
    ADD CONSTRAINT room_detail_options_pkey PRIMARY KEY (id);


--
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: trait_options trait_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trait_options
    ADD CONSTRAINT trait_options_pkey PRIMARY KEY (id);


--
-- Name: trap_bait_options trap_bait_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_bait_options
    ADD CONSTRAINT trap_bait_options_pkey PRIMARY KEY (id);


--
-- Name: trap_effect_options trap_effect_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_effect_options
    ADD CONSTRAINT trap_effect_options_pkey PRIMARY KEY (id);


--
-- Name: trap_lethality_options trap_lethality_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_lethality_options
    ADD CONSTRAINT trap_lethality_options_pkey PRIMARY KEY (id);


--
-- Name: trap_location_options trap_location_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_location_options
    ADD CONSTRAINT trap_location_options_pkey PRIMARY KEY (id);


--
-- Name: trap_purpose_options trap_purpose_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_purpose_options
    ADD CONSTRAINT trap_purpose_options_pkey PRIMARY KEY (id);


--
-- Name: trap_reset_options trap_reset_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_reset_options
    ADD CONSTRAINT trap_reset_options_pkey PRIMARY KEY (id);


--
-- Name: trap_trigger_options trap_trigger_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_trigger_options
    ADD CONSTRAINT trap_trigger_options_pkey PRIMARY KEY (id);


--
-- Name: trap_type_options trap_type_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trap_type_options
    ADD CONSTRAINT trap_type_options_pkey PRIMARY KEY (id);


--
-- Name: traps traps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traps
    ADD CONSTRAINT traps_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


--
-- Name: webhooks webhooks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.webhooks
    ADD CONSTRAINT webhooks_pkey PRIMARY KEY (id);


--
-- Name: word_options word_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.word_options
    ADD CONSTRAINT word_options_pkey PRIMARY KEY (id);


--
-- Name: worlds worlds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worlds
    ADD CONSTRAINT worlds_pkey PRIMARY KEY (id);


--
-- Name: accounts_email_address_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX accounts_email_address_index ON public.accounts USING btree (email_address);


--
-- Name: accounts_onboarding_state_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accounts_onboarding_state_index ON public.accounts USING btree (onboarding_state);


--
-- Name: accounts_tokens_account_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX accounts_tokens_account_id_index ON public.accounts_tokens USING btree (account_id);


--
-- Name: accounts_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX accounts_tokens_context_token_index ON public.accounts_tokens USING btree (context, token);


--
-- Name: acts_adventure_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acts_adventure_id_index ON public.acts USING btree (adventure_id);


--
-- Name: acts_position_adventure_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX acts_position_adventure_id_index ON public.acts USING btree ("position", adventure_id);


--
-- Name: acts_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX acts_world_id_index ON public.acts USING btree (world_id);


--
-- Name: adventure_descriptor_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX adventure_descriptor_options_name_index ON public.adventure_descriptor_options USING btree (name);


--
-- Name: adventure_people_adventure_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adventure_people_adventure_id_index ON public.adventure_people USING btree (adventure_id);


--
-- Name: adventure_people_person_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adventure_people_person_id_index ON public.adventure_people USING btree (person_id);


--
-- Name: adventures_location_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adventures_location_id_index ON public.adventures USING btree (location_id);


--
-- Name: adventures_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX adventures_world_id_index ON public.adventures USING btree (world_id);


--
-- Name: cultural_gender_preference_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cultural_gender_preference_options_name_index ON public.cultural_gender_preference_options USING btree (name);


--
-- Name: cultural_phase_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cultural_phase_options_name_index ON public.cultural_phase_options USING btree (name);


--
-- Name: cultural_scale_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cultural_scale_options_name_index ON public.cultural_scale_options USING btree (name);


--
-- Name: cultural_society_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX cultural_society_options_name_index ON public.cultural_society_options USING btree (name);


--
-- Name: culture_languages_culture_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX culture_languages_culture_id_index ON public.culture_languages USING btree (culture_id);


--
-- Name: culture_languages_language_id_culture_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX culture_languages_language_id_culture_id_index ON public.culture_languages USING btree (language_id, culture_id);


--
-- Name: culture_languages_phase_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX culture_languages_phase_index ON public.culture_languages USING btree (phase);


--
-- Name: culture_languages_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX culture_languages_world_id_index ON public.culture_languages USING btree (world_id);


--
-- Name: cultures_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cultures_world_id_index ON public.cultures USING btree (world_id);


--
-- Name: deities_pantheon_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deities_pantheon_id_index ON public.deities USING btree (pantheon_id);


--
-- Name: deities_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX deities_world_id_index ON public.deities USING btree (world_id);


--
-- Name: encounter_context_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX encounter_context_options_name_index ON public.encounter_context_options USING btree (name);


--
-- Name: encounter_monsters_encounter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX encounter_monsters_encounter_id_index ON public.encounter_monsters USING btree (encounter_id);


--
-- Name: encounter_monsters_monster_id_encounter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX encounter_monsters_monster_id_encounter_id_index ON public.encounter_monsters USING btree (monster_id, encounter_id);


--
-- Name: encounters_act_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX encounters_act_id_index ON public.encounters USING btree (act_id);


--
-- Name: gender_identity_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX gender_identity_options_name_index ON public.gender_identity_options USING btree (name);


--
-- Name: gender_presentation_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX gender_presentation_options_name_index ON public.gender_presentation_options USING btree (name);


--
-- Name: generations_resource_id_property_state_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX generations_resource_id_property_state_index ON public.generations USING btree (resource_id, property, state);


--
-- Name: generations_resource_id_state_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX generations_resource_id_state_index ON public.generations USING btree (resource_id, state);


--
-- Name: generations_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX generations_world_id_index ON public.generations USING btree (world_id);


--
-- Name: government_memberships_government_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX government_memberships_government_id_index ON public.government_memberships USING btree (government_id);


--
-- Name: government_memberships_person_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX government_memberships_person_id_index ON public.government_memberships USING btree (person_id);


--
-- Name: government_memberships_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX government_memberships_role_index ON public.government_memberships USING btree (role);


--
-- Name: governments_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX governments_world_id_index ON public.governments USING btree (world_id);


--
-- Name: gpu_servers_busy_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gpu_servers_busy_index ON public.gpu_servers USING btree (busy);


--
-- Name: gpu_servers_origin_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX gpu_servers_origin_index ON public.gpu_servers USING btree (origin);


--
-- Name: gpu_servers_power_busy_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX gpu_servers_power_busy_index ON public.gpu_servers USING btree (power, busy);


--
-- Name: group_age_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX group_age_options_name_index ON public.group_age_options USING btree (name);


--
-- Name: group_goal_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX group_goal_options_name_index ON public.group_goal_options USING btree (name);


--
-- Name: group_memberships_person_id_group_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX group_memberships_person_id_group_id_index ON public.group_memberships USING btree (person_id, group_id);


--
-- Name: group_memberships_person_id_group_id_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group_memberships_person_id_group_id_role_index ON public.group_memberships USING btree (person_id, group_id, role);


--
-- Name: group_memberships_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX group_memberships_role_index ON public.group_memberships USING btree (role);


--
-- Name: group_scope_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX group_scope_options_name_index ON public.group_scope_options USING btree (name);


--
-- Name: group_size_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX group_size_options_name_index ON public.group_size_options USING btree (name);


--
-- Name: groups_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX groups_world_id_index ON public.groups USING btree (world_id);


--
-- Name: identities_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX identities_world_id_index ON public.identities USING btree (world_id);


--
-- Name: image_batches_subject_artifact_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_artifact_id_index ON public.image_batches USING btree (subject_artifact_id);


--
-- Name: image_batches_subject_deity_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_deity_id_index ON public.image_batches USING btree (subject_deity_id);


--
-- Name: image_batches_subject_government_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_government_id_index ON public.image_batches USING btree (subject_government_id);


--
-- Name: image_batches_subject_group_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_group_id_index ON public.image_batches USING btree (subject_group_id);


--
-- Name: image_batches_subject_location_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_location_id_index ON public.image_batches USING btree (subject_location_id);


--
-- Name: image_batches_subject_pantheon_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_pantheon_id_index ON public.image_batches USING btree (subject_pantheon_id);


--
-- Name: image_batches_subject_person_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_person_id_index ON public.image_batches USING btree (subject_person_id);


--
-- Name: image_batches_subject_religion_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX image_batches_subject_religion_id_index ON public.image_batches USING btree (subject_religion_id);


--
-- Name: images_image_batch_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX images_image_batch_id_index ON public.images USING btree (image_batch_id);


--
-- Name: languages_name_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX languages_name_world_id_index ON public.languages USING btree (name, world_id) WHERE ((name IS NOT NULL) AND (length(name) > 0));


--
-- Name: languages_parent_language_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX languages_parent_language_id_index ON public.languages USING btree (parent_language_id);


--
-- Name: languages_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX languages_world_id_index ON public.languages USING btree (world_id);


--
-- Name: location_development_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX location_development_options_name_index ON public.location_development_options USING btree (name);


--
-- Name: location_embellishment_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX location_embellishment_options_name_index ON public.location_embellishment_options USING btree (name);


--
-- Name: location_founding_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX location_founding_options_name_index ON public.location_founding_options USING btree (name);


--
-- Name: locations_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX locations_world_id_index ON public.locations USING btree (world_id);


--
-- Name: name_options_tags_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX name_options_tags_index ON public.name_options USING btree (tags);


--
-- Name: oban_jobs_args_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oban_jobs_args_index ON public.oban_jobs USING gin (args);


--
-- Name: oban_jobs_meta_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oban_jobs_meta_index ON public.oban_jobs USING gin (meta);


--
-- Name: oban_jobs_state_queue_priority_scheduled_at_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX oban_jobs_state_queue_priority_scheduled_at_id_index ON public.oban_jobs USING btree (state, queue, priority, scheduled_at, id);


--
-- Name: organization_memberships_account_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organization_memberships_account_id_index ON public.organization_memberships USING btree (account_id);


--
-- Name: organization_memberships_organization_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organization_memberships_organization_id_index ON public.organization_memberships USING btree (organization_id);


--
-- Name: organization_permissions_organization_membership_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX organization_permissions_organization_membership_id_index ON public.organization_permissions USING btree (organization_membership_id);


--
-- Name: organization_permissions_permission_id_organization_membership_; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organization_permissions_permission_id_organization_membership_ ON public.organization_permissions USING btree (permission_id, organization_membership_id);


--
-- Name: organizations_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX organizations_slug_index ON public.organizations USING btree (slug);


--
-- Name: pantheons_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX pantheons_world_id_index ON public.pantheons USING btree (world_id);


--
-- Name: people_background_option_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_background_option_id_index ON public.people USING btree (background_option_id);


--
-- Name: people_culture_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_culture_id_index ON public.people USING btree (culture_id);


--
-- Name: people_religion_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_religion_id_index ON public.people USING btree (religion_id);


--
-- Name: people_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX people_world_id_index ON public.people USING btree (world_id);


--
-- Name: permissions_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX permissions_slug_index ON public.permissions USING btree (slug);


--
-- Name: person_appearance_options_name_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX person_appearance_options_name_type_index ON public.person_appearance_options USING btree (name, type);


--
-- Name: person_goal_options_description_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX person_goal_options_description_index ON public.person_goal_options USING btree (description);


--
-- Name: person_role_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX person_role_options_name_index ON public.person_role_options USING btree (name);


--
-- Name: person_type_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX person_type_options_name_index ON public.person_type_options USING btree (name);


--
-- Name: race_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX race_options_name_index ON public.race_options USING btree (name);


--
-- Name: religion_pantheons_pantheon_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX religion_pantheons_pantheon_id_index ON public.religion_pantheons USING btree (pantheon_id);


--
-- Name: religion_pantheons_religion_id_pantheon_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX religion_pantheons_religion_id_pantheon_id_index ON public.religion_pantheons USING btree (religion_id, pantheon_id);


--
-- Name: religion_value_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX religion_value_options_name_index ON public.religion_value_options USING btree (name);


--
-- Name: religions_world_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX religions_world_id_index ON public.religions USING btree (world_id);


--
-- Name: room_detail_options_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX room_detail_options_name_index ON public.room_detail_options USING btree (name);


--
-- Name: rooms_encounter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX rooms_encounter_id_index ON public.rooms USING btree (encounter_id);


--
-- Name: tags_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tags_name_index ON public.tags USING btree (name);


--
-- Name: tags_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX tags_slug_index ON public.tags USING btree (slug);


--
-- Name: traps_encounter_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX traps_encounter_id_index ON public.traps USING btree (encounter_id);


--
-- Name: versions_event_item_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX versions_event_item_type_index ON public.versions USING btree (event, item_type);


--
-- Name: versions_item_id_item_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX versions_item_id_item_type_index ON public.versions USING btree (item_id, item_type);


--
-- Name: versions_item_type_inserted_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX versions_item_type_inserted_at_index ON public.versions USING btree (item_type, inserted_at);


--
-- Name: versions_originator_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX versions_originator_id_index ON public.versions USING btree (originator_id);


--
-- Name: webhooks_provider_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX webhooks_provider_index ON public.webhooks USING btree (provider);


--
-- Name: word_options_tags_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX word_options_tags_index ON public.word_options USING btree (tags);


--
-- Name: oban_jobs oban_notify; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER oban_notify AFTER INSERT ON public.oban_jobs FOR EACH ROW EXECUTE FUNCTION public.oban_jobs_notify();


--
-- Name: accounts_tokens accounts_tokens_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.accounts_tokens
    ADD CONSTRAINT accounts_tokens_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id) ON DELETE CASCADE;


--
-- Name: acts acts_adventure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts
    ADD CONSTRAINT acts_adventure_id_fkey FOREIGN KEY (adventure_id) REFERENCES public.adventures(id) ON DELETE CASCADE;


--
-- Name: acts acts_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts
    ADD CONSTRAINT acts_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: acts acts_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acts
    ADD CONSTRAINT acts_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: adventure_people adventure_people_adventure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventure_people
    ADD CONSTRAINT adventure_people_adventure_id_fkey FOREIGN KEY (adventure_id) REFERENCES public.adventures(id) ON DELETE CASCADE;


--
-- Name: adventure_people adventure_people_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventure_people
    ADD CONSTRAINT adventure_people_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: adventures adventures_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventures
    ADD CONSTRAINT adventures_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: adventures adventures_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.adventures
    ADD CONSTRAINT adventures_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: artifacts artifacts_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id);


--
-- Name: artifacts artifacts_owner_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_owner_person_id_fkey FOREIGN KEY (owner_person_id) REFERENCES public.people(id);


--
-- Name: artifacts artifacts_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.artifacts
    ADD CONSTRAINT artifacts_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: culture_languages culture_languages_culture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.culture_languages
    ADD CONSTRAINT culture_languages_culture_id_fkey FOREIGN KEY (culture_id) REFERENCES public.cultures(id) ON DELETE CASCADE;


--
-- Name: culture_languages culture_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.culture_languages
    ADD CONSTRAINT culture_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id) ON DELETE CASCADE;


--
-- Name: culture_languages culture_languages_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.culture_languages
    ADD CONSTRAINT culture_languages_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: cultures cultures_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cultures
    ADD CONSTRAINT cultures_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: deities deities_pantheon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deities
    ADD CONSTRAINT deities_pantheon_id_fkey FOREIGN KEY (pantheon_id) REFERENCES public.pantheons(id);


--
-- Name: deities deities_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deities
    ADD CONSTRAINT deities_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: deities deities_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.deities
    ADD CONSTRAINT deities_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: encounter_monsters encounter_monsters_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encounter_monsters
    ADD CONSTRAINT encounter_monsters_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounters(id) ON DELETE CASCADE;


--
-- Name: encounter_monsters encounter_monsters_monster_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encounter_monsters
    ADD CONSTRAINT encounter_monsters_monster_id_fkey FOREIGN KEY (monster_id) REFERENCES public.monsters(id) ON DELETE CASCADE;


--
-- Name: encounters encounters_act_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.encounters
    ADD CONSTRAINT encounters_act_id_fkey FOREIGN KEY (act_id) REFERENCES public.acts(id) ON DELETE CASCADE;


--
-- Name: government_memberships government_memberships_government_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.government_memberships
    ADD CONSTRAINT government_memberships_government_id_fkey FOREIGN KEY (government_id) REFERENCES public.governments(id) ON DELETE CASCADE;


--
-- Name: government_memberships government_memberships_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.government_memberships
    ADD CONSTRAINT government_memberships_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: governments governments_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.governments
    ADD CONSTRAINT governments_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: group_memberships group_memberships_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_memberships
    ADD CONSTRAINT group_memberships_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: group_memberships group_memberships_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_memberships
    ADD CONSTRAINT group_memberships_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: groups groups_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: identities identities_by_culture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_by_culture_id_fkey FOREIGN KEY (by_culture_id) REFERENCES public.cultures(id) ON DELETE CASCADE;


--
-- Name: identities identities_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_person_id_fkey FOREIGN KEY (person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: identities identities_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_artifact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_artifact_id_fkey FOREIGN KEY (subject_artifact_id) REFERENCES public.artifacts(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_deity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_deity_id_fkey FOREIGN KEY (subject_deity_id) REFERENCES public.deities(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_government_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_government_id_fkey FOREIGN KEY (subject_government_id) REFERENCES public.governments(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_group_id_fkey FOREIGN KEY (subject_group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_location_id_fkey FOREIGN KEY (subject_location_id) REFERENCES public.locations(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_pantheon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_pantheon_id_fkey FOREIGN KEY (subject_pantheon_id) REFERENCES public.pantheons(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_person_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_person_id_fkey FOREIGN KEY (subject_person_id) REFERENCES public.people(id) ON DELETE CASCADE;


--
-- Name: image_batches image_batches_subject_religion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.image_batches
    ADD CONSTRAINT image_batches_subject_religion_id_fkey FOREIGN KEY (subject_religion_id) REFERENCES public.religions(id) ON DELETE CASCADE;


--
-- Name: images images_image_batch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.images
    ADD CONSTRAINT images_image_batch_id_fkey FOREIGN KEY (image_batch_id) REFERENCES public.image_batches(id) ON DELETE CASCADE;


--
-- Name: languages languages_parent_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_parent_language_id_fkey FOREIGN KEY (parent_language_id) REFERENCES public.languages(id) ON DELETE SET NULL;


--
-- Name: languages languages_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: locations locations_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: organization_memberships organization_memberships_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_memberships
    ADD CONSTRAINT organization_memberships_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.accounts(id);


--
-- Name: organization_memberships organization_memberships_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_memberships
    ADD CONSTRAINT organization_memberships_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: organization_permissions organization_permissions_organization_membership_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_permissions
    ADD CONSTRAINT organization_permissions_organization_membership_id_fkey FOREIGN KEY (organization_membership_id) REFERENCES public.organization_memberships(id);


--
-- Name: organization_permissions organization_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_permissions
    ADD CONSTRAINT organization_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- Name: pantheons pantheons_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pantheons
    ADD CONSTRAINT pantheons_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: people people_archetype_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_archetype_id_fkey FOREIGN KEY (archetype_option_id) REFERENCES public.archetype_options(id) ON DELETE SET NULL;


--
-- Name: people people_background_option_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_background_option_id_fkey FOREIGN KEY (background_option_id) REFERENCES public.background_options(id) ON DELETE CASCADE;


--
-- Name: people people_culture_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_culture_id_fkey FOREIGN KEY (culture_id) REFERENCES public.cultures(id);


--
-- Name: people people_religion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_religion_id_fkey FOREIGN KEY (religion_id) REFERENCES public.religions(id);


--
-- Name: people people_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.people
    ADD CONSTRAINT people_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: religion_pantheons religion_pantheons_pantheon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.religion_pantheons
    ADD CONSTRAINT religion_pantheons_pantheon_id_fkey FOREIGN KEY (pantheon_id) REFERENCES public.pantheons(id);


--
-- Name: religion_pantheons religion_pantheons_religion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.religion_pantheons
    ADD CONSTRAINT religion_pantheons_religion_id_fkey FOREIGN KEY (religion_id) REFERENCES public.religions(id);


--
-- Name: religions religions_world_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.religions
    ADD CONSTRAINT religions_world_id_fkey FOREIGN KEY (world_id) REFERENCES public.worlds(id) ON DELETE CASCADE;


--
-- Name: rooms rooms_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounters(id) ON DELETE CASCADE;


--
-- Name: traps traps_encounter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.traps
    ADD CONSTRAINT traps_encounter_id_fkey FOREIGN KEY (encounter_id) REFERENCES public.encounters(id) ON DELETE CASCADE;


--
-- Name: versions versions_originator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.versions
    ADD CONSTRAINT versions_originator_id_fkey FOREIGN KEY (originator_id) REFERENCES public.accounts(id);


--
-- Name: worlds worlds_organization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.worlds
    ADD CONSTRAINT worlds_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES public.organizations(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

INSERT INTO public."schema_migrations" (version) VALUES (20191225213553);
INSERT INTO public."schema_migrations" (version) VALUES (20191225213554);
INSERT INTO public."schema_migrations" (version) VALUES (20200127021834);
INSERT INTO public."schema_migrations" (version) VALUES (20200127021837);
INSERT INTO public."schema_migrations" (version) VALUES (20200127021838);
INSERT INTO public."schema_migrations" (version) VALUES (20200127021839);
INSERT INTO public."schema_migrations" (version) VALUES (20201215210357);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093328);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093329);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093330);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093331);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093333);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093340);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093343);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093344);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093345);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093346);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093347);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093348);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093349);
INSERT INTO public."schema_migrations" (version) VALUES (20211220093350);
INSERT INTO public."schema_migrations" (version) VALUES (20220118100509);
INSERT INTO public."schema_migrations" (version) VALUES (20220118100510);
INSERT INTO public."schema_migrations" (version) VALUES (20220118100511);
INSERT INTO public."schema_migrations" (version) VALUES (20220118100512);
INSERT INTO public."schema_migrations" (version) VALUES (20220120233632);
INSERT INTO public."schema_migrations" (version) VALUES (20220121225745);
INSERT INTO public."schema_migrations" (version) VALUES (20220204155956);
INSERT INTO public."schema_migrations" (version) VALUES (20220208012234);
INSERT INTO public."schema_migrations" (version) VALUES (20220208200843);
INSERT INTO public."schema_migrations" (version) VALUES (20220209090825);
INSERT INTO public."schema_migrations" (version) VALUES (20220209201940);
INSERT INTO public."schema_migrations" (version) VALUES (20220210195820);
INSERT INTO public."schema_migrations" (version) VALUES (20220212040549);
INSERT INTO public."schema_migrations" (version) VALUES (20220212040550);
INSERT INTO public."schema_migrations" (version) VALUES (20220212040551);
INSERT INTO public."schema_migrations" (version) VALUES (20220213223800);
INSERT INTO public."schema_migrations" (version) VALUES (20220213223807);
INSERT INTO public."schema_migrations" (version) VALUES (20220213223835);
INSERT INTO public."schema_migrations" (version) VALUES (20220306230221);
INSERT INTO public."schema_migrations" (version) VALUES (20220306234625);
INSERT INTO public."schema_migrations" (version) VALUES (20220306234924);
INSERT INTO public."schema_migrations" (version) VALUES (20220307002932);
INSERT INTO public."schema_migrations" (version) VALUES (20220317045106);
INSERT INTO public."schema_migrations" (version) VALUES (20220318213536);
INSERT INTO public."schema_migrations" (version) VALUES (20220318213537);
INSERT INTO public."schema_migrations" (version) VALUES (20220318213538);
INSERT INTO public."schema_migrations" (version) VALUES (20220321011400);
INSERT INTO public."schema_migrations" (version) VALUES (20220325193420);
INSERT INTO public."schema_migrations" (version) VALUES (20220325194029);
INSERT INTO public."schema_migrations" (version) VALUES (20220509221803);
INSERT INTO public."schema_migrations" (version) VALUES (20220509225347);
INSERT INTO public."schema_migrations" (version) VALUES (20220510203021);
INSERT INTO public."schema_migrations" (version) VALUES (20220510203127);
INSERT INTO public."schema_migrations" (version) VALUES (20220510203145);
INSERT INTO public."schema_migrations" (version) VALUES (20220510204226);
INSERT INTO public."schema_migrations" (version) VALUES (20220514230048);
INSERT INTO public."schema_migrations" (version) VALUES (20220519175304);
INSERT INTO public."schema_migrations" (version) VALUES (20220525190007);
INSERT INTO public."schema_migrations" (version) VALUES (20220526004321);
INSERT INTO public."schema_migrations" (version) VALUES (20220526005929);
INSERT INTO public."schema_migrations" (version) VALUES (20220526005930);
INSERT INTO public."schema_migrations" (version) VALUES (20220526005940);
INSERT INTO public."schema_migrations" (version) VALUES (20220621025436);
INSERT INTO public."schema_migrations" (version) VALUES (20220626193425);
INSERT INTO public."schema_migrations" (version) VALUES (20220626193431);
INSERT INTO public."schema_migrations" (version) VALUES (20220626193432);
INSERT INTO public."schema_migrations" (version) VALUES (20220626193451);
INSERT INTO public."schema_migrations" (version) VALUES (20220628175515);
INSERT INTO public."schema_migrations" (version) VALUES (20220630022330);
INSERT INTO public."schema_migrations" (version) VALUES (20220630022331);
INSERT INTO public."schema_migrations" (version) VALUES (20220701174646);
INSERT INTO public."schema_migrations" (version) VALUES (20220701174647);
INSERT INTO public."schema_migrations" (version) VALUES (20220703022534);
INSERT INTO public."schema_migrations" (version) VALUES (20220705093116);
INSERT INTO public."schema_migrations" (version) VALUES (20220713193511);
INSERT INTO public."schema_migrations" (version) VALUES (20220723230908);
INSERT INTO public."schema_migrations" (version) VALUES (20220724201920);
INSERT INTO public."schema_migrations" (version) VALUES (20220724215644);
INSERT INTO public."schema_migrations" (version) VALUES (20220727193951);
INSERT INTO public."schema_migrations" (version) VALUES (20220728212909);
INSERT INTO public."schema_migrations" (version) VALUES (20220801094635);
INSERT INTO public."schema_migrations" (version) VALUES (20220801095036);
INSERT INTO public."schema_migrations" (version) VALUES (20220803204458);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221427);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221436);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221442);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221457);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221505);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221513);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221520);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221536);
INSERT INTO public."schema_migrations" (version) VALUES (20220803221543);
INSERT INTO public."schema_migrations" (version) VALUES (20220803225644);
INSERT INTO public."schema_migrations" (version) VALUES (20220803225651);
INSERT INTO public."schema_migrations" (version) VALUES (20220803225659);
INSERT INTO public."schema_migrations" (version) VALUES (20220803225934);
INSERT INTO public."schema_migrations" (version) VALUES (20220803225951);
INSERT INTO public."schema_migrations" (version) VALUES (20220803225958);
INSERT INTO public."schema_migrations" (version) VALUES (20220803230005);
INSERT INTO public."schema_migrations" (version) VALUES (20220803230012);
INSERT INTO public."schema_migrations" (version) VALUES (20220803230019);
INSERT INTO public."schema_migrations" (version) VALUES (20220804021953);
INSERT INTO public."schema_migrations" (version) VALUES (20220804022527);
INSERT INTO public."schema_migrations" (version) VALUES (20220806030648);
INSERT INTO public."schema_migrations" (version) VALUES (20220809084753);
INSERT INTO public."schema_migrations" (version) VALUES (20220809111410);
INSERT INTO public."schema_migrations" (version) VALUES (20220810211234);
INSERT INTO public."schema_migrations" (version) VALUES (20220810211235);
INSERT INTO public."schema_migrations" (version) VALUES (20220812221115);
INSERT INTO public."schema_migrations" (version) VALUES (20220822204254);
INSERT INTO public."schema_migrations" (version) VALUES (20220822212629);
INSERT INTO public."schema_migrations" (version) VALUES (20220823211235);
INSERT INTO public."schema_migrations" (version) VALUES (20220904221302);
INSERT INTO public."schema_migrations" (version) VALUES (20220906184640);
INSERT INTO public."schema_migrations" (version) VALUES (20220906191201);
INSERT INTO public."schema_migrations" (version) VALUES (20220908060742);
INSERT INTO public."schema_migrations" (version) VALUES (20220915011140);
INSERT INTO public."schema_migrations" (version) VALUES (20220917055635);
INSERT INTO public."schema_migrations" (version) VALUES (20220918082016);
INSERT INTO public."schema_migrations" (version) VALUES (20220922055211);
INSERT INTO public."schema_migrations" (version) VALUES (20220923192305);
INSERT INTO public."schema_migrations" (version) VALUES (20220925000915);
INSERT INTO public."schema_migrations" (version) VALUES (20220925003000);
INSERT INTO public."schema_migrations" (version) VALUES (20220927032208);
INSERT INTO public."schema_migrations" (version) VALUES (20221013104539);
INSERT INTO public."schema_migrations" (version) VALUES (20221021220644);
INSERT INTO public."schema_migrations" (version) VALUES (20221021220645);
INSERT INTO public."schema_migrations" (version) VALUES (20221021220646);
INSERT INTO public."schema_migrations" (version) VALUES (20221021220647);
INSERT INTO public."schema_migrations" (version) VALUES (20221204031602);
INSERT INTO public."schema_migrations" (version) VALUES (20221204232730);
INSERT INTO public."schema_migrations" (version) VALUES (20221226214138);
INSERT INTO public."schema_migrations" (version) VALUES (20221226214142);
INSERT INTO public."schema_migrations" (version) VALUES (20221227071154);
INSERT INTO public."schema_migrations" (version) VALUES (20221230230314);
INSERT INTO public."schema_migrations" (version) VALUES (20230104221333);
INSERT INTO public."schema_migrations" (version) VALUES (20230109074432);
INSERT INTO public."schema_migrations" (version) VALUES (20230109212500);
INSERT INTO public."schema_migrations" (version) VALUES (20230109212501);
INSERT INTO public."schema_migrations" (version) VALUES (20230109212502);
INSERT INTO public."schema_migrations" (version) VALUES (20230116012611);
INSERT INTO public."schema_migrations" (version) VALUES (20230514222733);
INSERT INTO public."schema_migrations" (version) VALUES (20230521182435);
INSERT INTO public."schema_migrations" (version) VALUES (20230522011538);
INSERT INTO public."schema_migrations" (version) VALUES (20230527195132);
INSERT INTO public."schema_migrations" (version) VALUES (20230527195248);
INSERT INTO public."schema_migrations" (version) VALUES (20230527195754);
INSERT INTO public."schema_migrations" (version) VALUES (20230527195839);
INSERT INTO public."schema_migrations" (version) VALUES (20230527200106);
INSERT INTO public."schema_migrations" (version) VALUES (20230527200232);
INSERT INTO public."schema_migrations" (version) VALUES (20230528004426);
INSERT INTO public."schema_migrations" (version) VALUES (20230528014821);
INSERT INTO public."schema_migrations" (version) VALUES (20230911000710);
INSERT INTO public."schema_migrations" (version) VALUES (20230924003443);
INSERT INTO public."schema_migrations" (version) VALUES (20230924040233);
