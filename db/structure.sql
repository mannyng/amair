--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gin; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gin WITH SCHEMA public;


--
-- Name: EXTENSION btree_gin; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gin IS 'support for indexing common datatypes in GIN';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET search_path = public, pg_catalog;

--
-- Name: refresh_customer_details(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION refresh_customer_details() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY
    customer_details;
      RETURN NULL;
     EXCEPTION
        WHEN feature_not_supported THEN
           RETURN NULL;
      END $$;


--
-- Name: refresh_seeking_matview(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION refresh_seeking_matview() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
      REFRESH MATERIALIZED VIEW CONCURRENTLY
    seeking_matview;
      RETURN NULL;
     EXCEPTION
        WHEN feature_not_supported THEN
           RETURN NULL;
      END $$;


--
-- Name: english; Type: TEXT SEARCH CONFIGURATION; Schema: public; Owner: -
--

CREATE TEXT SEARCH CONFIGURATION english (
    PARSER = pg_catalog."default" );

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR asciiword WITH english_stem;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR word WITH english_stem;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR numword WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR email WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR url WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR host WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR sfloat WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR version WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR hword_numpart WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR hword_part WITH english_stem;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR hword_asciipart WITH english_stem;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR numhword WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR asciihword WITH english_stem;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR hword WITH english_stem;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR url_path WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR file WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR "float" WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR "int" WITH simple;

ALTER TEXT SEARCH CONFIGURATION english
    ADD MAPPING FOR uint WITH simple;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    street character varying NOT NULL,
    city character varying NOT NULL,
    state_id integer NOT NULL,
    zipcode character varying NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    name character varying NOT NULL,
    postcode integer
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    username character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet
);


--
-- Name: customers_billing_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers_billing_addresses (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    address_id integer NOT NULL
);


--
-- Name: customers_shipping_addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers_shipping_addresses (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    address_id integer NOT NULL,
    "primary" boolean DEFAULT false NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE states (
    id integer NOT NULL,
    code character varying NOT NULL,
    name character varying NOT NULL
);


--
-- Name: customer_details; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW customer_details AS
 SELECT customers.id AS customer_id,
    customers.first_name,
    customers.last_name,
    customers.email,
    customers.username,
    customers.created_at AS joined_at,
    billing_address.id AS billing_address_id,
    billing_address.street AS billing_street,
    billing_address.city AS billing_city,
    billing_state.code AS billing_state,
    billing_address.zipcode AS billing_zipcode,
    shipping_address.id AS shipping_address_id,
    shipping_address.street AS shipping_street,
    shipping_address.city AS shipping_city,
    shipping_state.code AS shipping_state,
    shipping_address.zipcode AS shipping_zipcode
   FROM ((((((customers
     JOIN customers_billing_addresses ON ((customers.id = customers_billing_addresses.customer_id)))
     JOIN addresses billing_address ON ((billing_address.id = customers_billing_addresses.address_id)))
     JOIN states billing_state ON ((billing_address.state_id = billing_state.id)))
     JOIN customers_shipping_addresses ON (((customers.id = customers_shipping_addresses.customer_id) AND (customers_shipping_addresses."primary" = true))))
     JOIN addresses shipping_address ON ((shipping_address.id = customers_shipping_addresses.address_id)))
     JOIN states shipping_state ON ((shipping_address.state_id = shipping_state.id)))
  WITH NO DATA;


--
-- Name: customers_billing_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_billing_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_billing_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_billing_addresses_id_seq OWNED BY customers_billing_addresses.id;


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_id_seq OWNED BY customers.id;


--
-- Name: customers_offering_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers_offering_posts (
    id integer NOT NULL,
    post_id integer NOT NULL,
    customer_id integer NOT NULL
);


--
-- Name: customers_offering_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_offering_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_offering_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_offering_posts_id_seq OWNED BY customers_offering_posts.id;


--
-- Name: customers_seeking_posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE customers_seeking_posts (
    id integer NOT NULL,
    post_id integer NOT NULL,
    customer_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: customers_seeking_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_seeking_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_seeking_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_seeking_posts_id_seq OWNED BY customers_seeking_posts.id;


--
-- Name: customers_shipping_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE customers_shipping_addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_shipping_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE customers_shipping_addresses_id_seq OWNED BY customers_shipping_addresses.id;


--
-- Name: posts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts (
    id integer NOT NULL,
    title text NOT NULL,
    content text NOT NULL,
    category_id integer NOT NULL,
    city_id integer NOT NULL,
    language text DEFAULT 'english'::text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_id_seq OWNED BY posts.id;


--
-- Name: posts_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE posts_tags (
    id integer NOT NULL,
    post_id integer NOT NULL,
    tag_id integer NOT NULL
);


--
-- Name: posts_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE posts_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: posts_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE posts_tags_id_seq OWNED BY posts_tags.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE states_id_seq OWNED BY states.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name text NOT NULL
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    CONSTRAINT email_must_be_company_email CHECK (((email)::text ~* '^[^@]+@example\.com'::text))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers ALTER COLUMN id SET DEFAULT nextval('customers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers_billing_addresses ALTER COLUMN id SET DEFAULT nextval('customers_billing_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers_offering_posts ALTER COLUMN id SET DEFAULT nextval('customers_offering_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers_seeking_posts ALTER COLUMN id SET DEFAULT nextval('customers_seeking_posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY customers_shipping_addresses ALTER COLUMN id SET DEFAULT nextval('customers_shipping_addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts ALTER COLUMN id SET DEFAULT nextval('posts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY posts_tags ALTER COLUMN id SET DEFAULT nextval('posts_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: customers_seeking_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers_seeking_posts
    ADD CONSTRAINT customers_seeking_posts_pkey PRIMARY KEY (id);


--
-- Name: posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts
    ADD CONSTRAINT posts_pkey PRIMARY KEY (id);


--
-- Name: seeking_matview; Type: MATERIALIZED VIEW; Schema: public; Owner: -; Tablespace: 
--

CREATE MATERIALIZED VIEW seeking_matview AS
 SELECT p.id AS post_id,
    p.created_at,
    p.updated_at,
    p.content,
    p.title,
    c.id AS city_id,
    c.name AS city,
    c.postcode AS city_postcode,
    ca.id AS category_id,
    ca.name AS category,
    sp.id AS seeking_post_id,
    sp.customer_id AS seeking_customer_id,
    sp.post_id AS seeking_post
   FROM (((posts p
     JOIN customers_seeking_posts sp ON ((p.id = sp.post_id)))
     JOIN cities c ON ((c.id = p.city_id)))
     JOIN categories ca ON ((ca.id = p.category_id)))
  GROUP BY p.id, c.id, ca.id, sp.id
  WITH NO DATA;


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: customers_billing_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers_billing_addresses
    ADD CONSTRAINT customers_billing_addresses_pkey PRIMARY KEY (id);


--
-- Name: customers_offering_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers_offering_posts
    ADD CONSTRAINT customers_offering_posts_pkey PRIMARY KEY (id);


--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: customers_shipping_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY customers_shipping_addresses
    ADD CONSTRAINT customers_shipping_addresses_pkey PRIMARY KEY (id);


--
-- Name: posts_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY posts_tags
    ADD CONSTRAINT posts_tags_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: states_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: customer_details_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX customer_details_customer_id ON customer_details USING btree (customer_id);


--
-- Name: customers_lower_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customers_lower_email ON customers USING btree (lower((email)::text));


--
-- Name: customers_lower_first_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customers_lower_first_name ON customers USING btree (lower((first_name)::text) varchar_pattern_ops);


--
-- Name: customers_lower_last_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX customers_lower_last_name ON customers USING btree (lower((last_name)::text) varchar_pattern_ops);


--
-- Name: index_addresses_on_state_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_state_id ON addresses USING btree (state_id);


--
-- Name: index_customers_billing_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_billing_addresses_on_address_id ON customers_billing_addresses USING btree (address_id);


--
-- Name: index_customers_billing_addresses_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_billing_addresses_on_customer_id ON customers_billing_addresses USING btree (customer_id);


--
-- Name: index_customers_offering_posts_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_offering_posts_on_customer_id ON customers_offering_posts USING btree (customer_id);


--
-- Name: index_customers_offering_posts_on_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_offering_posts_on_post_id ON customers_offering_posts USING btree (post_id);


--
-- Name: index_customers_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_customers_on_email ON customers USING btree (email);


--
-- Name: index_customers_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_customers_on_reset_password_token ON customers USING btree (reset_password_token);


--
-- Name: index_customers_on_username; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_customers_on_username ON customers USING btree (username);


--
-- Name: index_customers_seeking_posts_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_seeking_posts_on_customer_id ON customers_seeking_posts USING btree (customer_id);


--
-- Name: index_customers_seeking_posts_on_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_seeking_posts_on_post_id ON customers_seeking_posts USING btree (post_id);


--
-- Name: index_customers_shipping_addresses_on_address_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_shipping_addresses_on_address_id ON customers_shipping_addresses USING btree (address_id);


--
-- Name: index_customers_shipping_addresses_on_customer_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_customers_shipping_addresses_on_customer_id ON customers_shipping_addresses USING btree (customer_id);


--
-- Name: index_posts_on_category_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_category_id ON posts USING btree (category_id);


--
-- Name: index_posts_on_city_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_on_city_id ON posts USING btree (city_id);


--
-- Name: index_posts_tags_on_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_tags_on_post_id ON posts_tags USING btree (post_id);


--
-- Name: index_posts_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_posts_tags_on_tag_id ON posts_tags USING btree (tag_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: seeking_matview_post_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX seeking_matview_post_id ON seeking_matview USING btree (post_id);


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON customers FOR EACH STATEMENT EXECUTE PROCEDURE refresh_customer_details();


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON customers_shipping_addresses FOR EACH STATEMENT EXECUTE PROCEDURE refresh_customer_details();


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON customers_billing_addresses FOR EACH STATEMENT EXECUTE PROCEDURE refresh_customer_details();


--
-- Name: refresh_customer_details; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_customer_details AFTER INSERT OR DELETE OR UPDATE ON addresses FOR EACH STATEMENT EXECUTE PROCEDURE refresh_customer_details();


--
-- Name: refresh_seeking_matview; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_seeking_matview AFTER INSERT OR DELETE OR UPDATE ON posts FOR EACH STATEMENT EXECUTE PROCEDURE refresh_seeking_matview();


--
-- Name: refresh_seeking_matview; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_seeking_matview AFTER INSERT OR DELETE OR UPDATE ON cities FOR EACH STATEMENT EXECUTE PROCEDURE refresh_seeking_matview();


--
-- Name: refresh_seeking_matview; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER refresh_seeking_matview AFTER INSERT OR DELETE OR UPDATE ON categories FOR EACH STATEMENT EXECUTE PROCEDURE refresh_seeking_matview();


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20161029044413'), ('20161029154515'), ('20161030052946'), ('20161101081153'), ('20161106121046'), ('20161106121435'), ('20161107081716'), ('20161115075527'), ('20161115083637'), ('20161115092855'), ('20161115101159'), ('20161116071448'), ('20161117075054'), ('20161117090917'), ('20161117104514'), ('20161117115436'), ('20161117121627'), ('20161118094818'), ('20161119143421'), ('20161119152720'), ('20161120143200'), ('20161121072222'), ('20161121074324'), ('20161121075500'), ('20161121082705'), ('20161121133113'), ('20161122050444'), ('20161122063916'), ('20161123090024'), ('20161201114212'), ('20161203172959'), ('20161203174756'), ('20161217095348'), ('20161221113129');


