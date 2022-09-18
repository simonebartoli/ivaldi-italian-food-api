--
-- PostgreSQL database dump
--

-- Dumped from database version 14.1
-- Dumped by pg_dump version 14.1

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
-- Name: ivaldi; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "ivaldi" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';


ALTER DATABASE "ivaldi" OWNER TO postgres;

\connect -reuse-previous=on "dbname='ivaldi'"

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
-- Name: DATABASE "ivaldi"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE "ivaldi" IS 'This is the main database SQL for Ivaldi Italian Food';


--
-- Name: order_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status AS ENUM (
    'CONFIRMED',
    'CANCELLED',
    'REFUNDED',
    'DELIVERED',
    'REQUIRES_PAYMENT'
);


ALTER TYPE public.order_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_token (
    token_id integer NOT NULL,
    ip character varying(64) NOT NULL,
    ua character varying(255) NOT NULL,
    refresh_token_id integer NOT NULL,
    auth_level character varying(63) DEFAULT 'standard'::character varying NOT NULL
);


ALTER TABLE public.access_token OWNER TO postgres;

--
-- Name: access_token_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.access_token_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.access_token_token_id_seq OWNER TO postgres;

--
-- Name: access_token_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.access_token_token_id_seq OWNED BY public.access_token.token_id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addresses (
    address_id integer NOT NULL,
    city character varying(255) NOT NULL,
    first_address character varying(255) NOT NULL,
    second_address character varying(255),
    postcode character varying(255) NOT NULL,
    user_id integer NOT NULL,
    coordinates character varying(255),
    notes character varying(255)
);


ALTER TABLE public.addresses OWNER TO postgres;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.addresses_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_address_id_seq OWNER TO postgres;

--
-- Name: addresses_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.addresses_address_id_seq OWNED BY public.addresses.address_id;


--
-- Name: billing_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.billing_addresses (
    address_id integer NOT NULL,
    country character varying(255) NOT NULL
);


ALTER TABLE public.billing_addresses OWNER TO postgres;

--
-- Name: bundles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bundles (
    bundle_id integer NOT NULL,
    price double precision NOT NULL,
    notes character varying(511)
);


ALTER TABLE public.bundles OWNER TO postgres;

--
-- Name: bundles_bundle_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bundles_bundle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bundles_bundle_id_seq OWNER TO postgres;

--
-- Name: bundles_bundle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bundles_bundle_id_seq OWNED BY public.bundles.bundle_id;


--
-- Name: bundles_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bundles_items (
    bundle_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.bundles_items OWNER TO postgres;

--
-- Name: carts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.carts (
    user_id integer NOT NULL,
    item_id integer NOT NULL,
    amount integer NOT NULL
);


ALTER TABLE public.carts OWNER TO postgres;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    notes character varying(511)
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_category_id_seq OWNER TO postgres;

--
-- Name: categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_category_id_seq OWNED BY public.categories.category_id;


--
-- Name: categories_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories_items (
    category_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.categories_items OWNER TO postgres;

--
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contact (
    contact_id integer NOT NULL,
    name character varying(63) NOT NULL,
    surname character varying(63) NOT NULL,
    email character varying(255) NOT NULL,
    phone_number character varying(31) NOT NULL,
    message character varying(1023) NOT NULL,
    status character varying(31) DEFAULT 'RECEIVED'::character varying NOT NULL
);


ALTER TABLE public.contact OWNER TO postgres;

--
-- Name: contact_contact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contact_contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.contact_contact_id_seq OWNER TO postgres;

--
-- Name: contact_contact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contact_contact_id_seq OWNED BY public.contact.contact_id;


--
-- Name: discounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discounts (
    discount_id integer NOT NULL,
    percentage integer NOT NULL,
    notes character varying(511)
);


ALTER TABLE public.discounts OWNER TO postgres;

--
-- Name: discounts_discount_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discounts_discount_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.discounts_discount_id_seq OWNER TO postgres;

--
-- Name: discounts_discount_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discounts_discount_id_seq OWNED BY public.discounts.discount_id;


--
-- Name: emails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.emails (
    email_id integer NOT NULL,
    trigger character varying(255) NOT NULL,
    datetime timestamp without time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.emails OWNER TO postgres;

--
-- Name: emails_email_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.emails_email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emails_email_id_seq OWNER TO postgres;

--
-- Name: emails_email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.emails_email_id_seq OWNED BY public.emails.email_id;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.holidays (
    start_date timestamp with time zone NOT NULL,
    end_date timestamp with time zone NOT NULL,
    reason character varying
);


ALTER TABLE public.holidays OWNER TO postgres;

--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items (
    item_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(511) NOT NULL,
    price_total double precision NOT NULL,
    vat_id integer NOT NULL,
    amount_available integer NOT NULL,
    price_unit character varying(255) NOT NULL,
    photo_loc character varying(255) NOT NULL,
    entry_date timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    discount_id integer,
    priority boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_amount_available CHECK ((amount_available >= 0))
);


ALTER TABLE public.items OWNER TO postgres;

--
-- Name: items_hold; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items_hold (
    payment_intent_id character varying NOT NULL,
    item_id integer NOT NULL,
    amount integer NOT NULL,
    expiry_datetime timestamp with time zone NOT NULL
);


ALTER TABLE public.items_hold OWNER TO postgres;

--
-- Name: items_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_item_id_seq OWNER TO postgres;

--
-- Name: items_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_item_id_seq OWNED BY public.items.item_id;


--
-- Name: keywords; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.keywords (
    keyword character varying(63) NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.keywords OWNER TO postgres;

--
-- Name: sub_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_categories (
    sub_category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    notes character varying(511),
    category_id integer NOT NULL
);


ALTER TABLE public.sub_categories OWNER TO postgres;

--
-- Name: list_items_list_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.list_items_list_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.list_items_list_item_id_seq OWNER TO postgres;

--
-- Name: list_items_list_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.list_items_list_item_id_seq OWNED BY public.sub_categories.sub_category_id;


--
-- Name: log_accesses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.log_accesses (
    log_access_id integer NOT NULL,
    ip character varying(255) NOT NULL,
    trigger character varying(255) NOT NULL,
    datetime timestamp without time zone NOT NULL,
    user_id integer
);


ALTER TABLE public.log_accesses OWNER TO postgres;

--
-- Name: log_accesses_log_access_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.log_accesses_log_access_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.log_accesses_log_access_id_seq OWNER TO postgres;

--
-- Name: log_accesses_log_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.log_accesses_log_access_id_seq OWNED BY public.log_accesses.log_access_id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id character varying NOT NULL,
    price_total double precision NOT NULL,
    shipping_cost double precision DEFAULT 0 NOT NULL,
    datetime timestamp without time zone NOT NULL,
    archive text NOT NULL,
    status public.order_status NOT NULL,
    user_id integer NOT NULL,
    vat_total double precision NOT NULL,
    phone_number character varying(63) DEFAULT '+44 77 2309 3701'::character varying NOT NULL,
    reference character varying NOT NULL,
    receipt_number integer NOT NULL,
    type character varying NOT NULL,
    delivered boolean DEFAULT false NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_delivery; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders_delivery (
    order_delivery_id integer NOT NULL,
    suggested character varying(255),
    actual timestamp with time zone,
    reference character varying NOT NULL,
    confirmed character varying(255)
);


ALTER TABLE public.orders_delivery OWNER TO postgres;

--
-- Name: orders_delivery_order_delivery_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_delivery_order_delivery_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_delivery_order_delivery_id_seq OWNER TO postgres;

--
-- Name: orders_delivery_order_delivery_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_delivery_order_delivery_id_seq OWNED BY public.orders_delivery.order_delivery_id;


--
-- Name: orders_receipt_number_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_receipt_number_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_receipt_number_seq OWNER TO postgres;

--
-- Name: orders_receipt_number_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_receipt_number_seq OWNED BY public.orders.receipt_number;


--
-- Name: payment_intents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_intents (
    payment_intent_id character varying(255) NOT NULL,
    hash character varying(255) NOT NULL,
    expiry_datetime timestamp with time zone NOT NULL
);


ALTER TABLE public.payment_intents OWNER TO postgres;

--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payment_methods (
    reference character varying NOT NULL,
    type character varying NOT NULL,
    account character varying NOT NULL
);


ALTER TABLE public.payment_methods OWNER TO postgres;

--
-- Name: recover_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recover_tokens (
    token_id integer NOT NULL,
    secret character varying(511) NOT NULL,
    user_id integer NOT NULL,
    status character varying(63) DEFAULT 'PENDING'::character varying NOT NULL,
    expiry timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.recover_tokens OWNER TO postgres;

--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    token_id integer NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    user_id integer NOT NULL,
    auth_level character varying(63) DEFAULT 'standard'::character varying NOT NULL
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: refresh_tokens_refresh_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refresh_tokens_refresh_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refresh_tokens_refresh_token_id_seq OWNER TO postgres;

--
-- Name: refresh_tokens_refresh_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refresh_tokens_refresh_token_id_seq OWNED BY public.refresh_tokens.token_id;


--
-- Name: refunds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refunds (
    refund_id integer NOT NULL,
    archive character varying NOT NULL,
    order_ref character varying NOT NULL,
    notes character varying NOT NULL,
    datetime timestamp with time zone NOT NULL
);


ALTER TABLE public.refunds OWNER TO postgres;

--
-- Name: refunds_refund_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refunds_refund_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refunds_refund_id_seq OWNER TO postgres;

--
-- Name: refunds_refund_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refunds_refund_id_seq OWNED BY public.refunds.refund_id;


--
-- Name: shipping_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_addresses (
    address_id integer NOT NULL
);


ALTER TABLE public.shipping_addresses OWNER TO postgres;

--
-- Name: sub_categories_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sub_categories_items (
    sub_category_id integer NOT NULL,
    item_id integer NOT NULL
);


ALTER TABLE public.sub_categories_items OWNER TO postgres;

--
-- Name: tokens_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokens_token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tokens_token_id_seq OWNER TO postgres;

--
-- Name: tokens_token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokens_token_id_seq OWNED BY public.recover_tokens.token_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    surname character varying(255) NOT NULL,
    dob date NOT NULL,
    email character varying(255),
    password character varying(511) NOT NULL,
    role character varying(255) DEFAULT 'client'::character varying NOT NULL,
    email_to_verify character varying(255),
    entry_date timestamp with time zone DEFAULT now() NOT NULL,
    stripe_customer_id character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: vat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vat (
    vat_id integer NOT NULL,
    percentage double precision NOT NULL
);


ALTER TABLE public.vat OWNER TO postgres;

--
-- Name: vat_vat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vat_vat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vat_vat_id_seq OWNER TO postgres;

--
-- Name: vat_vat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vat_vat_id_seq OWNED BY public.vat.vat_id;


--
-- Name: access_token token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token ALTER COLUMN token_id SET DEFAULT nextval('public.access_token_token_id_seq'::regclass);


--
-- Name: addresses address_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses ALTER COLUMN address_id SET DEFAULT nextval('public.addresses_address_id_seq'::regclass);


--
-- Name: bundles bundle_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles ALTER COLUMN bundle_id SET DEFAULT nextval('public.bundles_bundle_id_seq'::regclass);


--
-- Name: categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN category_id SET DEFAULT nextval('public.categories_category_id_seq'::regclass);


--
-- Name: contact contact_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact ALTER COLUMN contact_id SET DEFAULT nextval('public.contact_contact_id_seq'::regclass);


--
-- Name: discounts discount_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts ALTER COLUMN discount_id SET DEFAULT nextval('public.discounts_discount_id_seq'::regclass);


--
-- Name: emails email_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails ALTER COLUMN email_id SET DEFAULT nextval('public.emails_email_id_seq'::regclass);


--
-- Name: items item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items ALTER COLUMN item_id SET DEFAULT nextval('public.items_item_id_seq'::regclass);


--
-- Name: log_accesses log_access_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_accesses ALTER COLUMN log_access_id SET DEFAULT nextval('public.log_accesses_log_access_id_seq'::regclass);


--
-- Name: orders receipt_number; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN receipt_number SET DEFAULT nextval('public.orders_receipt_number_seq'::regclass);


--
-- Name: orders_delivery order_delivery_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_delivery ALTER COLUMN order_delivery_id SET DEFAULT nextval('public.orders_delivery_order_delivery_id_seq'::regclass);


--
-- Name: recover_tokens token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recover_tokens ALTER COLUMN token_id SET DEFAULT nextval('public.tokens_token_id_seq'::regclass);


--
-- Name: refresh_tokens token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN token_id SET DEFAULT nextval('public.refresh_tokens_refresh_token_id_seq'::regclass);


--
-- Name: refunds refund_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refunds ALTER COLUMN refund_id SET DEFAULT nextval('public.refunds_refund_id_seq'::regclass);


--
-- Name: sub_categories sub_category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories ALTER COLUMN sub_category_id SET DEFAULT nextval('public.list_items_list_item_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: vat vat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vat ALTER COLUMN vat_id SET DEFAULT nextval('public.vat_vat_id_seq'::regclass);


--
-- Data for Name: access_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_token (token_id, ip, ua, refresh_token_id, auth_level) FROM stdin;
1	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
2	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
3	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
4	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
5	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
6	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
7	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
8	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
9	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
10	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
11	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
12	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
13	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
14	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
15	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
16	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
17	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
18	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
19	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
20	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
21	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
22	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	50	standard
23	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
24	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
25	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
26	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
27	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
28	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
29	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	56	standard
30	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
31	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
32	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
33	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
34	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
35	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
36	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
37	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
38	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
39	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
40	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
41	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	57	standard
42	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	58	standard
43	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	58	standard
44	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	59	standard
45	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	59	standard
46	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	59	standard
164	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	96	standard
166	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	98	standard
1888	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	207	standard
1478	::1	PostmanRuntime/7.29.2	184	standard
362	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	100	standard
363	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	101	standard
364	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	102	standard
370	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	104	standard
375	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	105	standard
163	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	95	standard
165	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	97	standard
3973	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	315	standard
366	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	103	standard
381	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	106	standard
382	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	107	standard
75	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	62	standard
76	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	62	standard
77	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	62	standard
78	::1	PostmanRuntime/7.29.0	34	standard
79	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	63	standard
80	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	63	standard
81	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	64	standard
82	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	64	standard
83	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	64	standard
84	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	64	standard
85	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	65	standard
86	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	66	standard
87	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	66	standard
88	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	66	standard
89	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	66	standard
90	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	66	standard
91	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	67	standard
92	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	67	standard
93	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	68	standard
94	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	68	standard
95	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	68	standard
96	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	68	standard
97	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	68	standard
98	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	68	standard
108	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	70	standard
111	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	71	standard
112	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	72	standard
113	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	73	standard
114	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	74	standard
115	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	75	standard
116	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	76	standard
119	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	77	standard
122	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	78	standard
131	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	79	standard
136	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	80	standard
137	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	81	standard
138	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	82	standard
140	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	83	standard
141	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	85	standard
143	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	86	standard
146	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	87	standard
147	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	88	standard
149	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	89	standard
150	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	90	standard
151	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	91	standard
152	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	92	standard
156	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	93	standard
160	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	94	standard
2319	::1	PostmanRuntime/7.29.2	223	standard
385	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	108	standard
1892	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	210	standard
810	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	191	standard
811	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	192	standard
501	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	147	standard
730	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	190	standard
506	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	148	standard
523	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	149	standard
524	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	150	standard
526	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	151	standard
419	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	109	standard
1647	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	202	standard
453	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	110	standard
454	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	143	standard
529	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	152	standard
461	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	144	standard
462	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	145	standard
537	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	153	standard
542	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	154	standard
543	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	155	standard
544	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	156	standard
547	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	157	standard
553	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	158	standard
1105	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	199	standard
557	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	159	standard
1668	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	203	standard
939	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	193	standard
560	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	160	standard
941	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	194	standard
1109	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	200	standard
1110	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	201	standard
563	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	161	standard
945	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	195	standard
566	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	162	standard
567	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	163	standard
568	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	164	standard
569	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	165	standard
570	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	166	standard
571	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	167	standard
572	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	168	standard
573	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	169	standard
1671	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	204	standard
950	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	196	standard
582	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	170	standard
954	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	197	standard
585	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	171	standard
588	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	172	standard
589	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	173	standard
590	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	174	standard
591	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	175	standard
592	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	176	standard
958	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	198	standard
594	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	177	standard
1673	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	205	standard
3977	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	317	standard
2259	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	250	standard
1890	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	208	standard
1891	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	209	standard
1893	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	211	standard
2444	::1	PostmanRuntime/7.29.2	260	standard
1895	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	212	standard
2445	::1	PostmanRuntime/7.29.2	264	standard
2446	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	258	standard
1899	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	213	standard
1902	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	214	standard
1907	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	215	standard
3674	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	282	standard
1912	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	216	standard
1913	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	217	standard
1915	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	218	standard
3676	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	283	standard
3677	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	284	standard
3678	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	285	standard
3507	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	277	standard
2210	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	246	standard
3697	::1	PostmanRuntime/7.29.2	287	standard
3699	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	286	standard
3700	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	288	standard
3701	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	289	standard
3703	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	290	standard
2488	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36	269	standard
2034	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	224	standard
2035	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	225	standard
2838	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	271	standard
2037	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	226	standard
2039	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	227	standard
2040	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	228	standard
2041	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	229	standard
2043	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	230	standard
1873	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	206	standard
2045	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	231	standard
2046	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	232	standard
2047	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	233	standard
2048	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	234	standard
2053	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	236	standard
2054	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101 Firefox/102.0	236	standard
3344	::1	PostmanRuntime/7.29.2	273	standard
3359	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	276	standard
2516	::1	PostmanRuntime/7.29.2	268	standard
3730	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	291	standard
3735	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	292	standard
3736	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	293	standard
3737	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	294	standard
3642	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	280	standard
3739	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	295	standard
3740	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	296	standard
3743	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	298	standard
3742	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	297	standard
3745	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	299	standard
3975	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	316	standard
3988	::1	PostmanRuntime/7.29.2	321	standard
3778	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	301	standard
3782	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	302	standard
3914	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	310	standard
4422	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	340	standard
4220	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	334	standard
4528	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	343	standard
3924	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	311	standard
4119	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	323	standard
4546	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	345	standard
4557	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	346	standard
4559	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	347	standard
4144	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	327	standard
4145	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	328	standard
4561	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	348	standard
4594	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	350	standard
3981	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	318	standard
3982	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	319	standard
3985	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	320	standard
3997	::1	PostmanRuntime/7.29.2	322	standard
4428	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	341	standard
4212	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	330	standard
4213	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	333	standard
4527	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	342	standard
3764	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	300	standard
4113	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	324	standard
3827	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	305	standard
3828	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	306	standard
3830	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:103.0) Gecko/20100101 Firefox/103.0	309	standard
3928	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	312	standard
3929	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	313	standard
4229	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	335	standard
4125	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	325	standard
3935	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	314	standard
4336	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	337	standard
4236	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	336	standard
4134	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	326	standard
4545	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	344	standard
4341	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	339	standard
4146	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	329	standard
4575	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	349	standard
4181	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	331	standard
4187	::ffff:127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:104.0) Gecko/20100101 Firefox/104.0	332	standard
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, city, first_address, second_address, postcode, user_id, coordinates, notes) FROM stdin;
17	London	1 Yeo Street	Caspian Wharf 40	E3 3AE	11	51.51887790000001, -0.017336947275403046	\N
19	London	1 Yeo Street	Caspian Wharf 40	E3 3AE	11	51.51887790000001, -0.017336947275403046	\N
20	Campi Bisenzio	Via Guido Mammoli	\N	50013	11	43.8171727, 11.1247105	\N
32	Nottingham	12 Violet Road	\N	NG4 3QR	11	52.97415615, -1.0970344	\N
33	Nottingham	12 Violet Road	\N	NG4 3QR	11	52.97415615, -1.0970344	\N
36	Florence	Via del Paradiso 14	\N	51024	11	43.7552615, 11.2888636	\N
37	London	Zopley Street	Discovery Tower 24	E16 1YG	32	\N	\N
38	London	Zopley Street	Discovery Tower 24	E16 1YG	32	\N	\N
40	London	Canter Way	Neroli House 3	E1 8PS	11	\N	\N
\.


--
-- Data for Name: billing_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_addresses (address_id, country) FROM stdin;
19	United Kingdom
20	Italy
33	United Kingdom
36	Italy
38	United Kingdom
40	United Kingdom
\.


--
-- Data for Name: bundles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bundles (bundle_id, price, notes) FROM stdin;
\.


--
-- Data for Name: bundles_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bundles_items (bundle_id, item_id) FROM stdin;
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.carts (user_id, item_id, amount) FROM stdin;
31	36	6
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, name, notes) FROM stdin;
3	bandwidth-monitored	Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus 
4	algorithm	Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum e
5	Robust	Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.
6	Customer-focused	Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, solli
7	Adaptive	Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
8	asynchronous	Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.
1	Stand-aloned	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis 
2	Future-proof	Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
11	test to delete	\N
\.


--
-- Data for Name: categories_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories_items (category_id, item_id) FROM stdin;
6	25
6	34
6	47
6	94
6	97
7	1
1	103
\.


--
-- Data for Name: contact; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contact (contact_id, name, surname, email, phone_number, message, status) FROM stdin;
1	Luca	Osato	lucaostato@libero.it	+447723093701	Ciao caro come stai io bene, volevo comunicarti che il prodotto	RECEIVED
2	Simone 	Bartoli	lucaostato@libero.it	07723093701	Hi bello come stai, i'm very good sharing with\nyou this	RECEIVED
\.


--
-- Data for Name: discounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discounts (discount_id, percentage, notes) FROM stdin;
1	16	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.
2	20	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultr
3	41	Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.
4	41	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec p
5	19	Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy.
6	26	Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.
8	50	\N
9	40	\N
10	25	\N
11	27	\N
12	28	\N
13	24	\N
14	30	\N
15	35	\N
16	10	\N
17	14	\N
\.


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emails (email_id, trigger, datetime, user_id) FROM stdin;
\.


--
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.holidays (start_date, end_date, reason) FROM stdin;
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, name, description, price_total, vat_id, amount_available, price_unit, photo_loc, entry_date, discount_id, priority) FROM stdin;
40	PLxMZ7ac	rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna	13.48	2	23	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
101	this is a test	test to see if works	8.82	2	13	KG	/images/ragu_funghi_300x.webp	2022-09-13 19:01:54.288	2	t
22	nhCgXM	sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio	19.34	2	19	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
11	DeepzB7DCn9E	neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel	18.87	1	0	LT	/images/ragu_funghi_300x.webp	2022-09-13 13:53:07.481	\N	f
23	ciao carissimodvdv	sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate	15.75	1	0	unit	/images/ragu_funghi_300x.webp	2022-09-13 13:53:43.748	5	t
14	iHGksA	sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra	17.2	2	38	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
15	ysoV02urNI	quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien	5.65	3	32	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
17	efCQeGKq	adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante	5.88	2	24	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
18	TdwKPMIs26J	vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede	2.69	1	21	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
21	d9U4mlMeyKk	sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec	10.25	2	34	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
28	2yvFTLO5hE8	a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio	12.44	2	21	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	2	f
29	x0LHbTf	lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem	13.9	3	33	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
31	uq9SftZRGyK	pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate	14.37	2	40	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
32	BWrYrw5	convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet	13.97	2	39	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	1	f
33	7l428YDHXq	penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean	18.56	3	31	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
35	RArlwG	donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit	11.32	3	25	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
37	qDuuIC3	non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci	14.12	3	21	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
38	Ugm2MvBb	vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere	18.82	2	32	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
39	eAtr3zbznd	ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at	19.18	2	26	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
64	SDCpwP0lCCM	eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio	15.45	1	24	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	1	f
41	TwcKbbx	interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam	18.99	2	38	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
42	hePxXVVV8	nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede	16.07	3	31	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	5	f
43	vVMQBD	nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan	18.03	3	31	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
45	mdOAYPOLci	aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam	15.41	1	34	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	5	f
34	lHmuVGrArEof	luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet	4.74	1	1	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	3	f
9	jHDjVM4	sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar	17.5	3	12	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
25	rudfljHLA0vs	mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue	13.23	1	25	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
26	E8hhHg8Np5	habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum	16.08	2	22	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
16	LupuT8	nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim	3.71	3	30	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
19	xjfgqR	vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia	11.15	1	36	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
27	aaT7fpX0wQ	magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt	16.51	2	35	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
20	bN9A7XO3Jkol	sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero	18.15	2	35	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	2	f
30	PFthAqQ	morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac	19	1	26	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
44	gT2623mTZ2Sy	pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa	15.22	3	34	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	1	f
49	BEI726rFOop	blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices	2.78	1	27	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	2	f
50	UfdzXYkfl	posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel	10.6	3	30	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
52	jIm3OhqF	donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis	7.2	2	22	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
53	UsGIDLCqii	ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper	3.59	2	40	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
54	AgswyaWl	morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam	11.2	3	37	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
55	7VnurlD5f7W	erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis	13.77	3	21	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
60	7CwqGZuouh	adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum	18.05	2	31	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
61	ip1FUPvR	eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed	14.97	1	24	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	5	f
63	pAWv3U6AIBv	odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat	6.36	1	32	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
65	RUoH0gpSJoav	at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit	4.16	1	35	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
66	66L2kQ4	accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget	10.06	1	27	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
68	GmeStIiA	dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien	4.49	1	38	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
70	1Zy58y3co3AY	feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa	10.56	3	27	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	5	f
71	aTiARaO	cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris	9.15	3	32	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	2	f
72	NvSvUB	sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa	15.62	2	38	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
74	1Mq3UGob85K	vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci	5.03	3	33	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
76	b9jj08Tx8mJ	ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem	7.3	1	39	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
103	Mozzarella di Bufala	La migliore Mozzarella sul Mercato internazionale proprio qui	5	1	2	KG	/images/ragu_funghi_300x.webp	2022-09-18 11:11:44.472	8	t
75	TEST PRODUCT	phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu	3.15	3	20	unit	/images/ragu_funghi_300x.webp	2022-09-17 18:26:42.325	17	f
5	xFXXvXXNXR	sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum	4.54	2	27	KG	/images/ragu_funghi_300x.webp	2022-09-17 18:26:50.018	\N	f
4	tXjwhKL	lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut	13.49	1	15	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
2	7EiedwtL	neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim	2.43	3	6	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
8	2aNtyJlgZjZ	sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla	18	1	22	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
3	17C8Be1RxUd	amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu	3.56	3	30	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
1	test product 2	This is a test to see if works	15.38	1	5	KG	/images/ragu_funghi_300x.webp	2022-09-13 19:01:57.671	16	t
6	1teuGYJ4JHmM	justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque	18.05	1	24	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	1	f
7	dDEmvtXHh8	accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat	3.08	1	38	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
10	0bjYItN6	a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices	12.46	3	39	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
12	NfIs5RClAdp	iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate	15.53	2	36	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
24	A0pZ0Q	vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere	4.21	2	32	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	5	f
46	zQVSHPvXxq	a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor	6.54	1	26	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
48	cbNidJ8	nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at	5.97	3	34	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
78	MEzPczUQuF	commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula	10.01	3	34	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
79	l4MFHCbB	platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien	17.61	1	32	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	4	f
80	fwuPQIHDAUB	suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu	14.61	2	29	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	5	f
69	IsalJbB2	quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio	7.23	3	0	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	4	f
67	76MckC	diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget	5.43	2	29	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	3	f
59	fERBI3NCG	turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum	7.98	1	22	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
51	8ownjVQ1UD2Q	lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis	17.96	3	25	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
56	68HJOt	sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis	6.45	1	16	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
47	spUlXgTtnIij	ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec	17.21	1	24	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
57	vVtkhTu2T	odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis	7.31	2	26	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
58	V2R07QhrB	montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa	12.22	2	24	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	4	f
62	OOYA8XE	feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse	15.64	3	28	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
85	Tdsgh0ePPOhV	justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque	11.38	3	23	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
88	4YGGwpWVVo	lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate	13.6	2	31	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
89	pHB0e7	vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis	7.86	3	22	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
93	jF1H5rhapH	nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla	5.71	2	34	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
96	NRr1ExTXeh	dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient	15.56	3	27	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
99	HQuWEX	vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at	9.18	3	27	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
94	KPxoq0RO	potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit	18.14	3	0	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
95	9vyGFL	diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam	13.02	3	31	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	3	f
92	VYbzbwxu7gG	donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet	2.39	2	21	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	1	f
97	9EbG3Az	non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim	2.23	1	32	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
84	qDP8bdZCGE	phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac	11.85	3	33	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
83	ghwb5TOD	lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit	11.64	1	23	LT	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	6	f
90	2WeSX08fOl1	integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam	8.75	3	27	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
86	majMp8x	sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl	17.44	1	38	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
98	Q73GuAi	eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis	2.94	3	0	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
81	Ndoe31Yme	convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum	3.33	2	34	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	1	f
100	LgxBPswCt	convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet	9.28	3	0	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
91	XZDbDf9dvrA	urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit	19.53	1	32	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	\N	f
77	XuI1DRXw1OU	nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo	19.88	3	19	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	2	f
82	alRvuSkv73	metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra	15.07	3	21	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	3	f
13	MDAFOZvCp	amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere	11.3	1	17	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	4	f
36	rolwnU	mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum	7.88	3	15	unit	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	4	f
87	VfFs3gyPIB	congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam	18.37	3	39	KG	/images/ragu_funghi_300x.webp	2022-06-27 21:19:55.757144	2	f
\.


--
-- Data for Name: items_hold; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items_hold (payment_intent_id, item_id, amount, expiry_datetime) FROM stdin;
pi_3LRhrKILFxyKM1ma1S9K6xLY	34	3	2022-07-31 20:48:15.725+01
pi_3LRhrKILFxyKM1ma1S9K6xLY	81	5	2022-07-31 20:48:15.725+01
pi_3LRhrKILFxyKM1ma1S9K6xLY	100	2	2022-07-31 20:48:15.725+01
\.


--
-- Data for Name: keywords; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.keywords (keyword, item_id) FROM stdin;
proactive	8
for	8
reconceptualize	8
backward-compatible	8
forward	8
empowered	8
service	8
vertical	2
synthesize	2
wireless	2
cooperative	2
organic	2
seize	3
pandemic	3
empowered	3
idea-sharing	3
nosql	3
convergence	3
service	3
state	3
enterprise	3
thinking	3
envisioneer	3
parallel	4
expanded	4
interdependent	4
iterate	4
synergistic	4
fabricate	4
box	4
revolutionize	5
procrastinate	5
task	5
procedures	5
outside	5
orthogonal	5
storage	5
internal	5
backward-compatible	5
competently	5
researched	5
syndicate	5
chains	5
interdependent	5
collaborative	6
build	6
change	6
inexpensive	6
recaptiualize	6
orthogonal	6
diverse	6
compelling	6
sources	6
e-business	7
e-services	7
web-readiness	7
exploit	7
interfaces	7
wins	7
implement	7
holisticly	7
cross-media	7
backward-compatible	9
of	9
pandemic	9
scrums	9
synthesize	9
quickly	9
high-impact	9
e-business	9
impactful	9
portals	9
networks	9
client-centered	9
integrate	9
performance	9
catalysts	9
prospective	9
competencies	9
high	10
equity	10
directed	10
intuitive	10
resources	10
elastic	10
error-free	10
infomediaries	10
resource-maximizing	10
meta-services	10
e-business	11
positioning	11
applications	11
evisculate	11
internal	11
monetize	11
virtual	11
competencies	11
worldwide	11
aggregate	11
based	11
parallel	11
channels	11
cloud-ready	11
global	11
theme	11
unique	11
storage	11
service	12
market	12
flexible	12
envisioneer	12
market-driven	12
efficiently	12
wireless	12
standards	12
revolutionary	12
products	12
linkage	12
resource-maximizing	12
materials	12
procrastinate	12
24/365	12
value	12
stand-alone	13
wireless	13
items	13
technically	13
cooperative	13
convergence	13
competitive	13
experiences	13
omni-channel	13
box	13
expedite	13
compelling	13
procrastinate	13
niches	13
monetize	14
cross-unit	14
dramatically	14
total	14
streamline	14
emerging	14
user-centric	14
promote	14
clouds	14
future-proof	15
e-services	15
mission-critical	15
appropriately	15
holisticly	15
intellectual	15
sources	15
fungibly	15
systems	15
array	15
standardized	15
adaptive	15
maximize	16
one-to-one	16
models	16
task	16
global	16
alignments	16
fashion	16
testing	17
paradigms	17
streamline	17
quality	17
unique	17
mission-critical	17
initiate	17
fungibly	17
bleeding-edge	17
enabled	17
the	17
performance	17
services	18
administrate	18
human	18
unleash	18
24/365	18
global	18
content	18
integrated	18
build	18
sticky	18
web-readiness	18
one-to-one	18
materials	18
initiatives	19
grow	19
pursue	19
infrastructures	19
core	19
evisculate	19
restore	19
for	19
robust	19
metrics	19
clicks-and-mortar	19
customize	19
supply	19
items	19
24/365	19
nosql	19
highly	19
idea-sharing	19
friendly	20
coordinate	20
ubiquitous	20
end-to-end	20
unleash	20
relationships	20
customer	20
real-time	20
of	20
integrated	20
best	20
efficient	20
initiatives	20
fashion	20
compliant	20
idea-sharing	20
open-source	21
distinctively	21
initiate	21
metrics	21
low-risk	21
on-demand	21
actualize	21
worldwide	21
redefine	21
manufactured	21
communities	21
process	21
cloud-ready	21
researched	21
goal-oriented	21
leading-edge	21
leverage	21
recaptiualize	21
premier	21
distributed	22
professionally	22
elastic	22
value-added	22
mission-critical	22
alignments	22
deliverables	22
synthesize	22
go	22
optimize	22
web-enabled	22
cloudify	22
sticky	22
user-centric	22
in	22
e-business	22
tested	22
24/7	22
supply	22
interfaces	23
cloud-based	23
ubiquitous	23
base	23
leadership	23
emerging	23
content	23
box	23
applications	23
value-added	23
infrastructures	23
scenarios	23
generate	24
provide	24
supply	24
low-risk	24
high-yield	24
worldwide	24
cross-unit	24
collaboration	24
products	24
storage	24
areas	24
phosfluorescently	24
fungibly	24
negotiate	24
quickly	24
the	24
an	24
exceptional	25
applications	25
interfaces	25
pandemic	25
expedite	25
monotonectally	25
cross-media	25
pandemic	26
web-readiness	26
continually	26
visualize	26
efficiently	26
foster	26
brand	26
functional	26
pontificate	26
tactical	26
the	26
multidisciplinary	26
holistic	26
implement	27
corporate	27
empower	27
evolve	27
the	27
schemas	27
practices	27
results	27
functional	27
monetize	27
economically	27
sound	27
highly	27
right-shore	27
fashion	28
extensible	28
competencies	28
streamline	28
forward	28
value-added	28
services	28
grow	28
energistically	28
excellent	28
sound	28
opportunities	28
distinctive	28
low-risk	28
infrastructures	28
adaptive	28
cloud-based	28
driven	28
enhance	28
convergence	29
aggregate	29
directed	29
utilize	29
platforms	29
total	29
mindshare	29
interdependent	29
cost	29
low-risk	29
just	30
innovate	30
thinking	30
empowered	30
maintainable	30
inexpensive	30
intermandated	30
orchestrate	30
magnetic	30
out-of-the-box	30
effective	30
bandwidth	30
visualize	30
processes	30
initiatives	30
web-enabled	30
value	30
develop	30
quickly	30
resource-leveling	31
testing	31
continually	31
synergistic	31
fungible	31
time	31
integrated	31
processes	31
wireless	31
re-engineer	32
theme	32
matrix	32
forward	32
accurate	32
seamless	32
emerging	32
equity	32
backend	32
quickly	32
supply	32
engineer	32
partnerships	32
continually	32
virtual	32
fungible	32
high-impact	32
evisculate	33
cross-platform	33
implement	33
enable	33
reconceptualize	33
market	33
simplify	33
strategic	33
engage	33
sources	33
provide	33
one-to-one	33
communities	34
fabricate	34
leveraged	34
procedures	34
manufactured	34
effective	34
distinctive	34
the	34
fully	34
web-readiness	34
blue	35
internal	35
envisioneer	35
cross-platform	35
users	35
capital	35
multifunctional	35
fungibility	35
accurate	35
unique	36
bleeding-edge	36
goal-oriented	36
cross	36
restore	36
in	36
agile	36
myocardinate	36
develop	36
process-centric	36
processes	36
team	36
expedite	36
multimedia	36
revolutionize	36
forward	36
incentivize	37
24/365	37
strategic	37
cloud-ready	37
create	37
highly	37
flexible	37
value	37
vortals	37
innovate	37
quality	37
sources	37
predominate	37
relationships	37
ideas	37
initiatives	37
total	38
technically	38
box	38
myocardinate	38
generate	38
deliver	38
experiences	38
progressively	38
evisculate	38
business	38
virtualization	39
strategic	39
friendly	39
user-centric	39
myocardinate	39
client-based	39
sources	39
of	39
growth	39
infrastructures	39
cloud-ready	39
top-line	39
content	39
build	40
networks	40
technologies	40
an	40
customize	40
based	40
multimedia	40
competencies	40
progressively	40
interactive	40
implement	40
cloud-based	40
seize	40
B2C	41
holisticly	41
best	41
visualize	41
web-enabled	41
granular	41
virtualization	41
materials	41
wins	42
next-generation	42
resource-leveling	42
service	42
clicks-and-mortar	42
goal-oriented	42
e-commerce	42
organic	42
end-to-end	42
procedures	43
thinking	43
maintain	43
quality	43
technically	43
global	43
parallel	43
corporate	43
simplify	43
e-tailers	43
high-yield	43
performance	43
distinctively	43
compellingly	43
conceptualize	43
streamline	43
web	43
information	44
ideas	44
utilize	44
corporate	44
reinvent	44
frictionless	44
vertical	45
web-readiness	45
bandwidth	45
materials	45
cloud-based	45
cloudify	45
enabled	45
competencies	45
competently	45
enable	45
standards	46
services	46
strategic	46
bandwidth	46
principle-centered	46
maintainable	46
functional	46
bricks-and-clicks	47
e-tailers	47
synthesize	47
deploy	47
implement	47
appropriately	47
efficient	47
multidisciplinary	47
energistically	47
markets	47
nosql	48
resource-leveling	48
high-yield	48
scrums	48
deliver	48
forward	48
process	48
implement	48
resource-maximizing	48
fully	49
niche	49
excellent	49
services	49
synergize	49
service	49
meta-services	49
orthogonal	49
economically	50
processes	50
matrix	50
quickly	50
omni-channel	50
collaboratively	50
scale	50
fabricate	50
communities	50
progressively	50
strategies	50
action	50
paradigms	50
benefits	50
installed	50
efficient	50
chains	51
customize	51
unique	51
premium	51
e-enable	51
results	51
underwhelm	51
resource-leveling	51
distributed	51
resource-maximizing	52
global	52
proactively	52
scale	52
or	52
cloudify	53
agile	53
create	53
capital	53
vectors	53
of	53
market-driven	53
scale	54
researched	54
engage	54
business	54
resource-sucking	54
premier	54
materials	54
adaptive	54
mission-critical	54
vertical	54
economically	54
schemas	54
integrated	54
enable	54
enabled	55
parallel	55
dynamic	55
cost	55
bandwidth	55
myocardinate	55
action	56
researched	56
integrate	56
outsourcing	56
intermandated	56
infrastructures	56
fungibly	56
applications	56
transparent	56
mesh	57
equity	57
standards	57
storage	57
matrix	57
plug-and-play	57
intellectual	57
action	57
fully	57
incubate	57
recaptiualize	57
seize	57
the	57
network	58
mindshare	58
collaborative	58
technologies	58
highly	58
integrated	58
ubiquitous	58
interactive	58
turnkey	58
metrics	58
facilitate	58
enterprise	58
completely	58
in	58
functionalized	58
installed	58
infrastructures	59
leading-edge	59
directed	59
compelling	59
ROI	59
sources	59
transition	59
promote	59
competencies	59
internal	59
architectures	59
leverage	59
authoritatively	59
superior	59
supply	59
re-engineer	60
brand	60
appropriately	60
cloud-centric	60
thinking	60
information	60
processes	60
models	61
impactful	61
unleash	61
deliver	61
markets	61
the	61
service	61
market-driven	61
dramatically	61
progressively	61
cutting-edge	61
professionally	61
capital	61
conveniently	62
niche	62
plug-and-play	62
transition	62
equity	62
extensive	62
existing	62
network	62
credibly	62
cloudified	62
sources	62
empower	62
ubiquitous	62
to	62
exploit	62
quickly	62
researched	62
impactful	62
strategies	62
collaboration	63
revolutionary	63
sources	63
holisticly	63
alignments	63
one-to-one	63
authoritatively	63
fully	64
an	64
rapidiously	64
impact	64
resource-maximizing	64
transparent	64
magnetic	64
omni-channel	64
front-end	65
competencies	65
interdependent	65
growth	65
unleash	65
quickly	65
revolutionary	65
e-enable	65
strategic	66
interdependent	66
productivate	66
an	66
functionalities	66
capital	66
products	66
granular	66
e-commerce	66
cross	66
driven	67
completely	67
innovation	67
e-markets	67
client-centric	67
efficiently	67
materials	67
thinking	67
access	67
of	67
web-enabled	67
based	67
productize	67
competitive	67
disintermediate	67
efficient	67
maximize	67
e-commerce	67
proactively	68
service	68
phosfluorescently	68
strategies	68
disseminate	68
premier	68
markets	68
deliverables	69
fashion	69
promote	69
cost	69
markets	69
vectors	69
simplify	69
driven	69
enterprise-wide	69
web-readiness	69
task	69
thinking	69
storage	69
plug-and-play	69
blue	69
continually	69
extensive	69
formulate	69
array	70
service	70
extensible	70
areas	70
meta-services	70
access	70
results	70
state	70
create	70
infomediaries	70
enterprise	70
strategic	70
ROI	70
chains	70
quality	70
credibly	70
sound	70
B2B	71
evisculate	71
agile	71
architectures	71
user-centric	71
robust	72
efficient	72
coordinate	72
empowerment	72
partnerships	72
cooperative	72
enterprise	72
the	72
cross-media	72
scalable	72
agile	72
alignments	72
users	72
value-added	74
change	74
exceptional	74
e-business	74
error-free	74
services	74
fully	74
sound	74
markets	74
resource-leveling	75
sticky	75
scale	75
exploit	75
integrated	75
the	75
multifunctional	75
best	75
revolutionary	75
infrastructures	75
capital	75
high-payoff	75
directed	75
web	75
productize	75
access	75
myocardinate	76
matrix	76
backend	76
envisioneer	76
outsourcing	76
resource-maximizing	76
covalent	76
facilitate	76
in	76
high-yield	76
market-driven	76
cost	77
timely	77
leverage	77
areas	77
re-engineer	77
communicate	77
accurate	77
interactive	77
holistic	77
transparent	77
of	77
integrate	77
24/365	77
end-to-end	77
build	77
highly	77
cloud-centric	77
impact	77
sources	78
competencies	78
foster	78
of	78
market-driven	78
interoperable	78
skills	78
mission-critical	78
promote	78
enable	78
markets	78
platforms	78
items	79
collaborative	79
functionalities	79
disintermediate	79
conveniently	79
coordinate	79
cooperative	79
go	80
synergistic	80
progressively	80
parallel	80
deliver	80
efficient	80
scalable	80
energistically	80
compliant	80
and	81
state	81
authoritatively	81
coordinate	81
parallel	81
cloud-based	81
seamless	81
prospective	81
redefine	81
scale	81
bleeding-edge	81
data	81
products	81
top-line	81
backward-compatible	82
streamline	82
imperatives	82
synergistically	82
items	82
compellingly	82
collaboration	82
conceptualize	82
leadership	82
web-enabled	83
efficient	83
friendly	83
scenarios	83
or	83
completely	83
restore	83
products	83
maximize	83
leading-edge	83
installed	84
compliant	84
transparent	84
aggregate	84
clouds	84
service	84
low-risk	85
restore	85
strategic	85
leverage	85
items	85
pontificate	85
portals	85
foster	85
high-impact	85
cloud-ready	85
experiences	85
standardized	85
standards	85
benchmark	85
develop	85
web	85
technology	85
client-centric	85
skills	85
technologies	86
in	86
architect	86
functionalities	86
virtualization	86
intermandated	86
synthesize	86
grow	86
restore	86
pontificate	86
strategies	86
standardized	86
e-commerce	86
e-markets	86
customize	87
benefits	87
plagiarize	87
fungibly	87
mindshare	87
linkage	87
orthogonal	87
objectively	87
and	87
communities	87
develop	87
holistic	87
enthusiastically	87
restore	87
client-centered	87
scenarios	87
brand	88
open-source	88
24/7	88
user	88
skills	88
driven	88
long-term	88
markets	88
standardized	88
fungible	89
dynamically	89
materials	89
resource-maximizing	89
timely	89
items	90
sound	90
efficiently	90
maximize	90
web	90
ideas	90
promote	90
excellent	90
strategies	90
client-centric	90
enable	90
deliverables	90
recaptiualize	90
ideas	91
grow	91
solutions	91
enterprise-wide	91
strategies	91
state	92
of	92
metrics	92
driven	92
myocardinate	92
internal	92
researched	92
implement	93
e-services	93
professionally	93
seize	93
partnerships	93
disintermediate	93
users	94
enabled	94
art	94
syndicate	94
customize	94
conveniently	94
efficient	94
enterprise	94
effective	94
web	94
strategic	94
best	94
ROI	94
infomediaries	94
services	94
in	95
effective	95
strategies	95
functional	95
intellectual	95
service	95
strategic	95
wireless	96
sticky	96
magnetic	96
theme	96
capital	96
platforms	96
state	96
quality	96
interdependent	96
manufactured	97
fully	97
sound	97
underwhelm	97
streamline	97
in	97
monetize	97
whiteboard	97
premium	97
applications	97
internal	97
collaborative	97
the	97
backward-compatible	97
based	98
bandwidth	98
leveraged	98
transparent	98
communicate	98
appropriately	98
leverage	98
performance	98
on-demand	98
24/7	98
scrums	98
capital	98
best	98
web-enabled	98
sources	99
opportunities	99
productivate	99
human	99
plug-and-play	99
simplify	99
adaptive	99
linkage	99
innovative	99
niches	99
best-of-breed	99
areas	99
diverse	99
imperatives	99
distributed	100
of	100
future-proof	100
mesh	100
ethical	100
test	1
synergistically	1
incentivize	1
pandemic	1
end-to-end	1
test6666	101
molle	103
bufala	103
formaggio	103
mozzarella	103
\.


--
-- Data for Name: log_accesses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.log_accesses (log_access_id, ip, trigger, datetime, user_id) FROM stdin;
1	::1	VIEW_USER_INFO	2022-06-27 18:52:02.016	5
2	::1	CHANGE_PASSWORD	2022-06-27 18:53:04.071	5
3	::1	VIEW_USER_INFO	2022-06-27 19:22:11.352	5
4	::1	VIEW_USER_INFO	2022-06-27 19:33:57.297	5
5	::1	VIEW_USER_INFO	2022-06-27 19:33:59.08	5
6	::1	VIEW_USER_INFO	2022-06-27 19:34:00.113	5
7	::1	CHANGE_EMAIL	2022-06-27 19:34:10.845	5
8	::1	CHANGE_PASSWORD	2022-06-27 19:34:18.26	5
9	::1	CHANGE_PASSWORD	2022-06-27 19:34:19.746	5
10	::1	VIEW_USER_INFO	2022-06-27 19:34:49.44	5
11	::1	VIEW_USER_INFO	2022-06-27 19:34:50.237	5
12	::1	VIEW_USER_INFO	2022-06-27 19:34:57.301	5
13	::1	VIEW_USER_INFO	2022-06-27 19:34:58.675	5
14	::1	VIEW_USER_INFO	2022-06-27 19:35:00.396	5
15	::1	VIEW_USER_INFO	2022-06-27 19:35:23.925	5
16	::1	VIEW_USER_INFO	2022-06-27 20:04:21.848	5
17	::1	VIEW_USER_INFO	2022-06-27 20:05:33.189	5
18	::1	VIEW_USER_INFO	2022-06-27 20:05:34.044	5
19	::1	VIEW_USER_INFO	2022-06-27 20:05:34.705	5
20	::1	CHANGE_EMAIL	2022-06-27 20:05:37.962	5
21	::1	CHANGE_EMAIL	2022-06-27 20:05:38.833	5
22	::1	CHANGE_EMAIL	2022-06-27 20:05:39.59	5
23	::1	CHANGE_EMAIL	2022-06-27 20:05:40.21	5
24	::1	CHANGE_PASSWORD	2022-06-27 20:05:44.208	5
25	::1	CHANGE_PASSWORD	2022-06-27 20:05:45.316	5
26	::1	CHANGE_PASSWORD	2022-06-27 20:05:46.455	5
27	::1	CHANGE_PASSWORD	2022-06-27 20:05:55.133	5
28	::1	CHANGE_PASSWORD	2022-06-27 20:06:02.85	5
29	::1	CHANGE_PASSWORD	2022-06-27 20:07:23.659	5
30	::1	VIEW_USER_INFO	2022-06-28 18:21:19.642	5
31	::1	VIEW_USER_INFO	2022-06-28 21:03:19.621	5
32	::1	VIEW_USER_INFO	2022-06-29 10:38:07.922	5
33	::1	VIEW_USER_INFO	2022-06-29 17:28:01.304	5
34	::1	VIEW_USER_INFO	2022-06-29 17:28:37.335	5
35	::1	VIEW_USER_INFO	2022-06-29 18:21:51.149	5
36	::1	VIEW_USER_INFO	2022-06-29 18:24:18.944	5
37	::1	VIEW_USER_INFO	2022-06-29 18:29:22.67	5
38	::1	VIEW_USER_INFO	2022-06-29 18:30:02.223	5
39	::1	VIEW_USER_INFO	2022-06-29 18:30:16.105	5
40	::1	VIEW_USER_INFO	2022-06-29 18:32:18.49	5
41	::1	VIEW_USER_INFO	2022-06-29 18:44:05.143	5
42	::1	VIEW_USER_INFO	2022-06-29 18:44:06.219	5
43	::1	VIEW_USER_INFO	2022-06-29 19:18:26.966	5
44	::1	VIEW_USER_INFO	2022-06-29 19:18:38.939	5
45	::1	VIEW_USER_INFO	2022-06-29 22:28:38.975	5
46	::1	VIEW_USER_INFO	2022-06-30 18:02:57.188	5
47	::1	VIEW_USER_INFO	2022-06-30 18:03:13.295	5
48	::1	VIEW_USER_INFO	2022-06-30 21:55:31.5	5
49	::1	VIEW_USER_INFO	2022-07-01 15:09:55.071	5
50	::1	VIEW_USER_INFO	2022-07-02 17:31:53.672	\N
51	::1	VIEW_USER_INFO	2022-07-02 17:36:14.254	\N
52	::1	VIEW_USER_INFO	2022-07-02 17:36:15.351	\N
53	::1	VIEW_USER_INFO	2022-07-02 17:36:16.349	\N
54	::1	VIEW_USER_INFO	2022-07-02 17:36:17.377	\N
55	::1	VIEW_USER_INFO	2022-07-02 17:36:18.32	\N
56	::1	VIEW_USER_INFO	2022-07-02 17:36:19.158	\N
57	::1	VIEW_USER_INFO	2022-07-02 17:36:19.834	\N
58	::1	VIEW_USER_INFO	2022-07-02 19:26:01.421	\N
59	::1	VIEW_USER_INFO	2022-07-02 19:26:31.872	\N
60	::1	VIEW_USER_INFO	2022-07-02 19:26:32.84	\N
61	::1	VIEW_USER_INFO	2022-07-05 16:36:53.472	11
62	::1	VIEW_USER_INFO	2022-07-05 16:37:00.873	11
63	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:38:50.391	11
64	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:38:54.428	11
65	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:41:21.821	11
66	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:41:25.639	11
67	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:53:58.439	11
68	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:54:04.363	11
69	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:58:29.659	11
70	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 13:58:58.294	11
71	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:10:03.503	11
72	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:10:03.555	11
73	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:10:03.652	11
74	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:10:58.914	11
75	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:11:02.908	11
76	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:11:02.91	11
77	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:17:56.048	11
78	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:17:56.051	11
79	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:18:11.164	11
80	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 14:18:11.168	11
81	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:06:26.363	11
82	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:06:26.365	11
83	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:06:40.025	11
84	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:06:40.028	11
85	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:06:40.104	11
86	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:07:40.563	11
87	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:07:46.118	11
88	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:07:46.121	11
89	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:08:41.13	11
90	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:08:41.144	11
91	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:09:00.578	11
92	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:09:00.581	11
93	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:09:00.685	11
94	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:09:41.013	11
95	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:09:43.812	11
96	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:09:43.814	11
97	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:10:31.121	11
98	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:10:31.126	11
99	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:10:31.256	11
100	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:10:54.08	11
101	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:10:54.082	11
102	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:10:54.167	11
103	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:03.721	11
104	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:14.823	11
105	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:14.825	11
106	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:14.907	11
107	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:26.902	11
108	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:37.646	11
109	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:37.651	11
110	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:37.749	11
111	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:11:42.166	11
112	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:12:18.808	11
113	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 17:12:18.809	11
114	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:23:42.433	11
115	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:23:42.437	11
116	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:24:25.404	11
117	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:24:25.405	11
118	::1	VIEW_USER_INFO	2022-07-08 18:25:36.619	11
119	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:26:17.821	11
120	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:26:22.103	11
121	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:26:27.459	11
122	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:26:27.461	11
123	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:26:27.549	11
124	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:26:58.185	11
125	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:27:58.182	11
126	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:27:58.185	11
127	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:46:03.054	11
128	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 18:46:11.74	11
129	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 19:05:24.754	11
130	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:05:38.908	11
131	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:06:19.997	11
132	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:07:53.792	11
133	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:10:52.894	11
134	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:11:02.206	11
135	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:11:51.415	11
136	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:13:41.605	11
137	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:15:58.218	11
138	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:16:02.897	11
139	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:16:02.92	11
140	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:16:08.562	11
141	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:16:09.307	11
142	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:18:37.715	11
143	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:18:38.636	11
144	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:18:44.284	11
145	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:18:44.29	11
146	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:31:34.077	11
147	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:31:35.388	11
148	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:32:14.752	11
149	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:32:14.754	11
150	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:33:32.14	11
151	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:33:32.187	11
152	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:33:54.707	11
153	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:33:55.59	11
154	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 20:58:28.95	11
155	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:05:53.363	11
156	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:05:54.964	11
157	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:06:01.944	11
158	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:06:01.942	11
159	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:06:14.302	11
160	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:06:14.304	11
161	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:11:53.685	11
162	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:11:54.5	11
163	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:00.627	11
164	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:00.63	11
165	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:00.822	11
167	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:04.034	11
166	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:04.027	11
168	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:04.124	11
169	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:21.192	11
170	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:21.194	11
171	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:21.251	11
172	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:12:38.911	11
173	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:14:12.939	11
174	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:14:12.941	11
175	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:55:25.477	11
176	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:55:25.586	11
177	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:56:03.643	11
178	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 21:56:03.649	11
179	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 22:04:15.337	11
180	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-08 22:04:15.531	11
181	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:21:57.636	11
182	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:37:01.698	11
183	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:42:21.451	11
184	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:42:22.835	11
185	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:48:55.489	11
186	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:48:56.663	11
187	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:49:29.249	11
188	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:49:30.149	11
189	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:49:40.467	11
190	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:49:41.308	11
191	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:50:42.804	11
192	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:50:43.708	11
193	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:52:14.691	11
194	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:52:15.539	11
195	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:53:37.085	11
196	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:53:37.087	11
197	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:53:41.236	11
198	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:53:41.238	11
199	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:49.984	11
200	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:49.987	11
201	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:50.062	11
202	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:52.696	11
203	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:52.7	11
204	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:52.832	11
205	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 12:57:58.982	11
206	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:10:34.556	11
207	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:10:41.265	11
208	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:11:16.424	11
209	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:11:16.496	11
210	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:11:20.69	11
211	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:11:20.933	11
212	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:11:20.982	11
213	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:11:34.27	11
214	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:01.886	11
215	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:01.988	11
216	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:07.863	11
217	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:07.866	11
218	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:08.062	11
219	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:28.347	11
220	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:28.383	11
221	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:31.601	11
222	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:31.772	11
223	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:31.818	11
224	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:48.274	11
225	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:48.303	11
226	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:12:48.39	11
227	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:32.283	11
228	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:32.316	11
229	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:36.27	11
230	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:36.504	11
231	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:36.558	11
232	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:57.749	11
233	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:57.751	11
2441	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:21:31.917	11
2442	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:21:32.708	11
2490	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:26:23.646	11
2566	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 13:33:30.629	11
2606	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:19:11.772	11
2636	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:46:03.419	11
2677	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 21:46:18.984	11
2679	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 21:46:24.718	11
2706	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:42:51.737	11
2707	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:42:51.851	11
2734	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 20:00:32.705	11
2735	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 20:00:33.426	11
2736	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 20:00:33.578	11
2764	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:58:17.55	11
2765	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:58:56.709	11
2842	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:40.323	11
2843	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:40.512	11
2846	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:47.548	11
2847	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:18:38.366	11
2849	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:18:38.963	11
2850	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:18:42.433	11
2851	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:18:43.087	11
2852	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:18:43.182	11
2853	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:19:31.744	11
2854	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:19:32.34	11
2858	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:21:05.954	11
2931	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:41:37.455	11
2932	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:41:38.013	11
2959	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:50:07.149	11
2960	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:50:07.265	11
2961	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:50:07.369	11
2986	::1	VIEW_USER_INFO	2022-08-01 14:13:42.175	11
3008	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 20:04:19.555	11
3011	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 20:06:17.696	11
3012	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 20:06:23.473	11
3030	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 13:56:28.617	11
3060	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 22:35:50.59	11
3062	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 22:35:51.09	11
3098	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:42:58.474	11
3099	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:42:58.582	11
3153	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:03:16.883	11
3154	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:03:17.239	11
3155	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:03:17.397	11
3162	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:12:03.66	11
3164	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:12:04.197	11
3165	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:12:31.841	11
3166	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:12:32.232	11
3167	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:12:32.312	11
3200	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:37:34.858	11
3201	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:37:36.106	11
3212	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:42:23.585	11
3213	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:42:28.346	11
3214	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:42:28.856	11
3215	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:42:28.951	11
3237	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:32:07.731	11
3239	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:40:42.82	11
3272	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 15:06:53.578	11
3309	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:56:51.754	11
3310	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:56:52.031	11
3311	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:56:52.592	11
3312	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:57:37.309	11
3315	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:57:53.028	11
3316	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:57:53.553	11
3318	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:01:42.013	11
3319	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:01:42.365	11
3320	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:01:42.511	11
3333	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:26:19.731	11
3358	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:28:37.884	11
3359	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:29:26.93	11
3368	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:41:46.292	11
234	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:13:57.877	11
235	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:06.928	5
236	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:07.796	5
237	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:17.66	5
238	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:17.708	5
239	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:27.333	5
240	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:27.335	5
241	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:40:27.643	5
242	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:54:44.911	5
243	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:54:45.153	5
244	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:54:45.241	5
245	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:54:59.073	5
246	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:54:59.074	5
247	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:54:59.263	5
248	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:55:10.93	5
249	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:55:10.931	5
250	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:55:11.021	5
251	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:58:23.39	5
252	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:58:36.798	5
253	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 13:58:36.839	5
254	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:01:45.838	11
255	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:01:46.709	11
256	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:06.779	11
257	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:06.78	11
258	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:06.966	11
259	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:24.645	5
260	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:25.581	5
261	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:48.595	5
262	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 14:03:49.343	5
263	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 20:56:32.861	19
264	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 20:56:33.654	19
265	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 20:56:56.236	19
266	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 20:56:56.308	19
267	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 20:56:57.711	19
268	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 21:51:33.346	5
269	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 21:51:34.368	5
270	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 21:51:42	5
271	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-10 21:51:42.942	5
272	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:47:34.05	20
273	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:47:35.276	20
274	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:47:46.634	20
275	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:47:56.847	20
276	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:53:47.021	20
277	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:53:47.022	20
278	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:55:27.293	11
279	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:55:27.296	11
280	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:55:28.296	11
281	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:55:39.604	11
282	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 10:55:39.627	11
283	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:34:27.833	11
284	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:34:28.807	11
285	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:37:39.706	21
286	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:37:40.636	21
287	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:39:12.629	22
288	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:39:12.632	22
289	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:39:35.109	22
290	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:39:35.112	22
291	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:40:18.946	22
292	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:40:18.951	22
293	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:43:39.226	23
294	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:43:39.284	23
295	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:43:39.36	23
296	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 11:43:40.026	23
297	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:35:33.754	23
298	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:35:33.756	23
299	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:35:34.027	23
300	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:36:59.049	23
301	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:39:05.196	23
302	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:39:05.269	23
303	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:40:05.92	24
304	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:40:06.894	24
305	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:40:56.824	24
306	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:40:56.876	24
307	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:40:59.056	24
308	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:41:03.957	24
309	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 12:41:04.924	24
310	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 13:06:08.437	24
311	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 13:06:08.441	24
312	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 14:57:27.053	25
313	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 14:57:28.021	25
314	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 14:57:37.287	11
315	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 14:57:37.365	11
316	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 14:57:51.665	11
317	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 14:57:51.809	11
318	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:02:42.754	25
319	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:02:43.657	25
320	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:05:58.391	25
321	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:05:58.394	25
322	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:05:58.519	25
323	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:06:00.894	25
324	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:07:55.847	25
325	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:07:55.848	25
326	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:08:37.076	25
327	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 15:08:37.078	25
328	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:52:26.763	25
329	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:52:26.766	25
330	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:53:22.066	25
331	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:53:22.13	25
332	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:53:22.132	25
333	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:53:42.243	25
334	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:53:42.327	25
335	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:55:02.897	25
336	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:55:02.995	25
337	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:55:02.996	25
339	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:56:01.438	25
340	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:56:14.434	25
341	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:56:14.54	25
342	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:56:20.826	25
343	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:56:20.832	25
345	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:25.632	25
346	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:25.633	25
347	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:45.764	25
348	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:45.982	25
349	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:50.361	25
352	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:03.052	25
353	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:03.645	25
354	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:03.718	25
355	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:07.627	25
356	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:07.632	25
357	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:10.997	25
358	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:10.999	25
359	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:01:58.746	25
363	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:02:39.007	25
364	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:02:39.048	25
365	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:02:56.564	25
366	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:02:56.593	25
367	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:06:32.442	25
368	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:06:32.602	25
369	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:06:40.574	25
372	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:07:07.028	25
383	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.453	25
384	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.631	25
387	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.948	25
390	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:58.273	25
391	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:58.547	25
392	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:58.638	25
403	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.391	25
404	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.452	25
405	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.534	25
409	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.872	25
410	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.958	25
414	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.198	25
415	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.272	25
416	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.344	25
417	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.397	25
418	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.463	25
424	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.036	25
425	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.149	25
427	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.375	25
428	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.554	25
429	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.651	25
431	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.89	25
434	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:04.245	25
439	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.305	25
441	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.502	25
442	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.636	25
443	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.712	25
445	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.845	25
451	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.653	25
453	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.898	25
454	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.963	25
469	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.58	25
471	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.789	25
475	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.226	25
476	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.343	25
478	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.623	25
479	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.786	25
480	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.877	25
482	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.174	25
483	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.296	25
484	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.489	25
485	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.584	25
486	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.64	25
487	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.785	25
488	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.862	25
489	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.959	25
490	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.101	25
504	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.871	25
505	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.036	25
506	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.105	25
508	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.329	25
509	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.408	25
511	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.558	25
524	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.054	25
527	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.394	25
2443	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:21:32.849	11
2491	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:26:38.264	11
2492	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:26:51.722	11
2567	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 15:40:38.755	11
2571	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 15:44:29.44	11
2607	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:34:00.136	11
2609	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:34:45.136	11
2637	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:46:03.915	11
2638	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:46:04.028	11
338	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:56:01.32	25
344	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:25.537	25
350	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:57:50.362	25
351	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 16:58:03.049	25
360	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:01:58.749	25
361	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:01:58.839	25
362	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:02:38.951	25
370	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:06:40.578	25
371	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:06:40.65	25
373	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:07:07.696	25
374	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:07:18.984	25
375	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:07:18.988	25
376	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:07:19.13	25
377	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:22.184	25
378	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:22.187	25
379	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:22.333	25
380	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:22.458	25
381	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:30.391	25
382	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.246	25
385	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.688	25
386	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.838	25
388	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:57.996	25
389	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:58.176	25
393	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:10:58.733	25
394	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:00.69	25
395	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:00.78	25
396	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:00.854	25
397	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:00.93	25
398	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:00.987	25
399	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.052	25
400	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.127	25
401	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.216	25
402	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.28	25
406	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.645	25
407	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.72	25
408	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:01.815	25
411	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.029	25
412	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.08	25
413	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.146	25
419	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.548	25
420	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.648	25
421	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.717	25
422	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.78	25
423	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:02.914	25
426	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.296	25
430	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.764	25
432	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:03.978	25
433	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:04.093	25
435	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:04.481	25
436	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:04.666	25
437	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:04.895	25
438	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.156	25
440	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.396	25
444	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:05.797	25
446	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.006	25
447	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.059	25
448	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.222	25
449	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.402	25
450	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.52	25
452	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:06.744	25
455	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.064	25
456	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.178	25
457	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.33	25
458	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.458	25
459	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.546	25
460	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.664	25
461	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.76	25
462	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.862	25
463	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:07.959	25
464	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.061	25
465	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.159	25
466	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.269	25
467	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.361	25
468	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.482	25
470	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.689	25
472	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:08.972	25
473	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.066	25
474	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.143	25
477	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:09.514	25
481	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:10.003	25
491	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.3	25
492	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.394	25
493	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.475	25
494	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.671	25
495	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.769	25
496	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:11.963	25
497	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.061	25
498	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.188	25
499	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.294	25
500	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.427	25
501	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.517	25
502	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.577	25
503	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:12.723	25
507	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.246	25
510	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.492	25
512	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.644	25
513	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.735	25
514	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.811	25
516	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.069	25
517	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.176	25
525	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.139	25
526	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.241	25
528	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.551	25
529	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.771	25
530	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:15.886	25
531	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:16.003	25
532	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:16.153	25
2444	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 18:01:35.835	11
2446	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 18:01:36.884	11
2447	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 18:02:21.831	11
2448	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 18:02:22.615	11
2493	::1	VIEW_USER_INFO	2022-07-26 21:41:33.19	11
2499	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:15:03.709	11
2568	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 15:40:38.8	11
2569	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 15:44:28.723	11
2570	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 15:44:29.191	11
2608	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:34:16.585	11
2639	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:46:06.201	11
2640	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:46:08.767	11
2641	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:46:08.846	11
2678	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 21:46:24.594	11
2708	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:45:57.138	11
2709	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:45:58.184	11
2737	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 20:29:51.318	11
2766	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:05:59.227	11
2767	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:04.269	11
2768	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:04.748	11
2859	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:26:12.254	11
2861	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:26:12.972	11
2862	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:26:18.261	11
2863	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:26:18.714	11
2865	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:06.883	11
2867	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:07.526	11
2868	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:27.701	11
2869	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:28.51	11
2872	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:29:00.521	11
2876	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:32.505	11
2879	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:36.732	11
2933	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:41:39.062	11
2962	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:54:26.491	11
2964	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:54:27.128	11
2987	::1	VIEW_USER_INFO	2022-08-01 14:13:47.376	11
3009	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 20:04:29.93	11
3010	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 20:04:30.055	11
3031	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 14:29:08.554	11
3063	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:01:32.719	11
3100	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:44:21.949	11
3102	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:45:30.257	11
3103	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:45:30.311	11
3168	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 13:23:42.802	11
3169	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 13:23:43.09	11
3170	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 13:23:43.295	11
3202	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:37:40.226	11
3238	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:32:26.071	11
3273	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 15:07:13.288	11
3321	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:32:34.283	11
3334	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:27:40.302	11
3340	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:33:49.302	11
3355	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:54:57.843	11
3360	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:33:06.309	11
3381	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:03:52.603	11
3395	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 07:58:39.341	11
3397	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 07:59:42.5	11
3407	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:25:28.672	11
3422	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:27:31.361	11
3423	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:28:48.16	11
3424	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:28:48.948	11
3425	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:31:29.207	11
3426	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:31:29.949	11
3461	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:02:24.044	11
3462	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:02:30.963	11
3492	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 21:55:01.059	11
3493	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 21:55:06.608	11
3507	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 18:26:25.415	11
3524	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:57:27.418	11
3525	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:57:39.869	11
3534	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:02:21.493	11
3537	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:03:04.974	11
3538	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:03:10.894	11
3554	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 17:36:39.894	11
3569	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:10:29.73	11
3576	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:34:27.312	11
3590	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:59:41.97	11
3601	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:37:21.178	11
3609	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:19:26.704	11
3613	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:20:08.706	11
3615	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:21:17.618	11
3616	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:21:17.622	11
3617	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:21:17.723	11
3618	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:22:12.816	11
3619	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:22:12.818	11
3631	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:27:15.983	11
3634	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:27:51.457	11
3635	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:27:51.51	11
515	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:13.98	25
518	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.264	25
519	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.345	25
520	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.472	25
521	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.612	25
522	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.699	25
523	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:14.822	25
533	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:11:16.285	25
534	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:12:56.126	11
535	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:12:57.259	11
536	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:13:04.936	11
537	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:13:04.941	11
538	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:13:05.165	11
539	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:13:10.617	11
540	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:13:10.653	11
541	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:14:35.816	11
542	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:14:35.823	11
543	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:15:26.362	11
544	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:15:26.372	11
545	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:13.316	11
546	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:13.318	11
547	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:16.877	11
548	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:16.881	11
549	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:17.031	11
550	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:27.097	11
551	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:27.141	11
552	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:28.364	11
553	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:30.351	11
554	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:16:30.45	11
555	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:02.211	11
556	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:02.212	11
557	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:07.217	11
558	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:07.22	11
559	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:19.211	11
560	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:19.262	11
561	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:29.029	11
562	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:29.043	11
563	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:29.216	11
564	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:43.989	11
565	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:43.991	11
566	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:51.897	11
567	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:51.942	11
568	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:53.485	11
569	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:55.204	11
570	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:55.243	11
571	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:56.617	11
572	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:58.202	11
573	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:58.241	11
574	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:59.563	11
575	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:22:59.564	11
576	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:23:35.515	11
577	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:23:35.521	11
578	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:24:21.47	11
579	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:24:21.471	11
580	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:24:21.542	11
581	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:24:31.47	11
582	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:28:07.668	11
583	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:28:07.776	11
584	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:28:21.998	11
585	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:28:22.102	11
586	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:38:12.362	26
587	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:38:13.574	26
588	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 17:38:46.524	26
589	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 18:01:13.765	11
590	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 18:01:14.998	11
591	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:25:34.504	11
592	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:26:04.634	11
593	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:26:04.635	11
594	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:26:11.359	11
595	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:26:11.413	11
596	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:26:20.405	11
597	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-11 20:26:20.407	11
598	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 11:57:27.926	11
599	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 11:57:29.067	11
600	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 11:57:36.969	11
601	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 11:57:41.841	11
602	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 11:57:52.417	11
603	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 11:59:30.299	11
604	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 19:44:41.81	11
605	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 19:44:43.03	11
606	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:28:38.972	11
607	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:28:38.973	11
608	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:28:48.464	11
609	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:28:48.465	11
610	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:31:02.296	11
611	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:31:03.206	11
612	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:31:29.102	5
613	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:31:29.152	5
614	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:32:30.814	5
615	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:32:30.868	5
616	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:18.113	5
617	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:18.148	5
618	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:25.053	5
619	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:25.118	5
620	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:30.734	5
621	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:47.297	11
622	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:47.391	11
623	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:33:53.736	11
624	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:35:01.357	11
625	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:35:38.755	11
626	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:35:49.069	11
627	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:36:16.154	11
628	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:36:16.172	11
629	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:36:16.285	11
630	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:36:40.688	11
631	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:36:40.694	11
632	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:37:17.98	11
633	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:37:18.008	11
634	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:38:47.957	11
635	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:38:52.46	11
636	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:38:59.325	11
637	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:39:00.041	11
638	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:39:34.737	11
639	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:39:34.788	11
640	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:40:31.454	11
641	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:40:31.455	11
642	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:41:45.836	11
643	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:42:31.346	11
644	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:42:31.347	11
645	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:42:31.81	11
646	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:43:24.993	11
647	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:44:26.929	11
648	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:44:39.671	11
649	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:44:39.737	11
650	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:44:43.928	11
651	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:44:43.945	11
652	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:45:24.644	11
653	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:45:24.651	11
654	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:46:05.366	11
655	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:46:05.367	11
656	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:46:30.871	11
657	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:46:30.872	11
658	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:46:54.071	11
659	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:46:54.072	11
660	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:47:07.823	11
661	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:47:07.823	11
662	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:47:07.872	11
663	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:49:00.297	11
664	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:49:00.299	11
665	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:52:36.868	11
666	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:52:36.876	11
667	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:59:32.342	11
668	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 20:59:32.343	11
669	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:02.137	11
670	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:02.138	11
671	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:02.212	11
672	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:07.906	11
673	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:11.582	11
674	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:11.617	11
675	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:14.245	11
676	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:14.245	11
677	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:14.3	11
678	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:28.568	11
679	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:28.57	11
680	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:28.721	11
681	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:42.466	11
682	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:44.857	11
683	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:44.86	11
684	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:44.949	11
685	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:47.676	11
686	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:47.677	11
687	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:00:47.743	11
688	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:01:14.9	11
689	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:01:14.901	11
690	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:01:15.006	11
691	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:22.921	11
692	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:22.922	11
693	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:27.013	11
694	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:27.07	11
695	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:29.234	11
696	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:40.963	11
697	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:40.964	11
698	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:41.037	11
699	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:45.922	11
700	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:50.021	11
701	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:50.126	11
702	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:02:51.485	11
703	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:03:06.812	5
704	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-13 21:03:06.89	5
736	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:50:56.192	5
737	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:50:58.72	5
738	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:51:23.646	5
739	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:51:23.705	5
740	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:51:39.705	11
741	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:51:39.998	11
742	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:55:58.855	11
743	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:55:58.854	11
744	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:55:58.985	11
745	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:10.548	11
746	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:15.933	11
747	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:15.938	11
748	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:15.983	11
749	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:18.733	11
750	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:20.446	11
751	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:20.476	11
752	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:21.898	11
753	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:23.067	11
754	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:23.097	11
755	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:26.015	11
756	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:28.917	11
757	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:28.947	11
759	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:31.899	11
763	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:47.691	11
765	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:47.744	11
766	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:51.732	11
767	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:54.042	11
768	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:54.075	11
769	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:55.973	11
770	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:58.997	11
771	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:59.029	11
772	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:01.299	11
774	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:03.057	11
776	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:50.986	11
778	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:51.037	11
779	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:58:33.652	11
780	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:58:34.632	11
781	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:58:43.556	11
782	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:58:43.594	11
783	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:58:48.108	11
2445	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 18:01:36.484	11
2449	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 18:02:22.851	11
2494	::1	VIEW_USER_INFO	2022-07-26 21:41:38.294	11
2500	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:16:19.247	11
2572	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:09:56.915	11
2573	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:09:57.43	11
2576	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:10:39.573	11
2610	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:34:45.464	11
2611	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:34:45.554	11
2612	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:37:26.253	11
2642	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:50:05.424	11
2644	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:50:05.757	11
2647	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:51:00.043	11
2654	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:55:11.047	11
2656	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:55:11.804	11
2680	::1	VIEW_USER_INFO	2022-07-29 21:55:34.527	11
2681	::1	VIEW_USER_INFO	2022-07-29 21:55:39.344	11
2710	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:45:58.3	11
2738	::1	VIEW_USER_INFO	2022-07-30 20:33:24.151	11
2769	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:04.877	11
2770	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:11.714	11
2771	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:13.508	11
2772	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:13.551	11
2773	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:15.385	11
2774	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:17.675	11
2775	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:18.943	11
2778	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:07:55.856	11
2781	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:02.316	11
2782	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:06.786	11
2787	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:28.114	11
2788	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:51.005	11
2860	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:26:12.875	11
2864	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:26:18.965	11
2866	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:07.402	11
2870	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:28.628	11
2871	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:28:59.848	11
2873	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:29:00.594	11
2874	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:31.611	11
2875	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:32.392	11
2877	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:35.895	11
2878	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:36.669	11
2882	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:32:46.337	11
2888	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:34:45.069	11
2934	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 10:52:01.735	11
2963	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:54:27.028	11
2988	::1	VIEW_USER_INFO	2022-08-01 14:13:58.056	11
2989	::1	VIEW_USER_INFO	2022-08-01 14:13:58.099	11
3013	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 15:30:00.114	11
3032	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 14:32:11.281	11
3064	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:04:06.057	11
3065	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:04:06.114	11
3066	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:04:06.138	11
3104	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:40:32.396	11
3105	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:40:32.838	11
3107	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:44:14.902	11
3108	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:44:15.519	11
3124	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:20:25.415	11
3125	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:20:30.818	11
3126	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:22:44.544	11
3137	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:17:42.223	11
3171	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 14:40:43.917	11
3173	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 14:40:44.599	11
3205	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:40:25.162	11
3206	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:40:25.219	11
3207	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:41:01.193	11
3208	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:41:01.658	11
3240	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:40:43.156	11
3241	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:40:43.364	11
3274	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:25:44.664	11
3275	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:25:44.976	11
3279	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:28:35.942	11
3280	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:29:58.088	11
3281	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:29:58.339	11
758	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:31.899	11
760	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:42.515	11
761	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:42.618	11
762	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:44.916	11
764	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:56:47.691	11
773	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:03.056	11
775	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:03.092	11
777	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 12:57:50.987	11
784	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 17:36:08.994	11
785	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 17:36:11.143	11
786	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 17:37:02.495	11
787	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 17:37:02.496	11
788	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 17:37:02.614	11
789	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 17:37:16.772	11
790	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 19:42:19.622	11
791	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 19:42:19.623	11
792	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 19:42:19.727	11
793	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 19:42:32.72	11
794	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 19:42:32.765	11
795	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 19:42:33.723	11
796	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:20.865	11
797	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:20.867	11
798	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:21.146	11
800	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:37.098	11
799	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:37.097	11
801	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:37.242	11
802	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:02:50.279	11
803	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:03:44.676	11
804	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:03:44.677	11
805	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:05:00.087	11
806	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:05:00.095	11
807	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:05:20.962	11
808	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:05:40.501	11
809	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:06:14.835	11
810	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:07:47.886	11
811	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:08:19.845	11
812	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:09:03.261	11
813	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:09:56.316	11
814	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:11:53.99	11
815	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:14:37.808	11
816	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:14:39.814	11
817	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:14:42.369	11
818	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:14:42.422	11
819	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:14:43.4	11
820	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:16.209	11
821	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:16.21	11
822	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:16.268	11
823	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:19.014	11
824	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:55.918	11
825	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:55.922	11
826	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:15:56.017	11
827	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:08.662	11
828	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:08.663	11
829	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:08.804	11
830	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:16.591	11
831	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:24.066	11
832	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:24.066	11
833	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:16:24.148	11
834	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:17:41.909	11
835	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:17:41.918	11
836	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:23:26.946	11
837	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:23:26.947	11
838	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:23:36.402	11
839	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:23:42.247	11
840	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:23:58.528	11
841	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:24:24.136	11
842	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:27:05.584	11
843	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:27:06.418	11
844	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:30:51.066	11
845	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:31:45.935	11
846	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:31:59.336	11
847	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:32:02.573	11
848	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:32:26.298	11
849	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:32:26.299	11
850	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:32:26.406	11
851	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:32:36.659	11
852	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:32:46.339	11
853	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:33:08.977	11
854	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-14 20:33:22.803	11
855	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 10:57:47.795	11
856	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 10:57:48.895	11
857	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 10:57:57.571	11
858	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 10:58:13.091	11
859	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 10:58:42.812	11
860	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 10:59:17.601	11
861	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:00:02.928	11
862	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:00:03.64	11
863	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:00:11.498	11
864	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:00:17.589	11
865	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:00:25.764	11
866	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:01:22.467	11
867	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:01:31.939	11
868	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:05:04.744	11
869	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:05:11.658	11
870	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:05:18.136	11
871	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:05:29.143	11
872	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:05:42.981	11
873	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:06:16.47	11
874	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:06:25.339	11
875	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:14:33.874	11
876	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:15:29.802	11
877	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:15:36.923	11
878	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:18:56.701	11
879	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:22:22.851	11
880	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:22:23.686	11
881	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:22:55.815	11
882	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:22:56.714	11
883	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:23:03.235	11
884	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:24:04.635	11
885	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:24:05.445	11
886	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:24:12.952	11
887	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:24:19.842	11
888	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:25:52.457	11
889	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:25:53.359	11
890	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 11:25:56.948	11
891	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:06:42.012	11
892	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:07:07.928	11
893	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:08:24.009	11
894	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:09:18.838	11
895	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:09:31.412	11
896	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:10:39.435	11
897	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:12:20.024	5
898	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:12:21.236	5
899	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:12:30.657	5
900	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:12:36.055	5
901	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:12:45.656	5
902	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 12:12:55.497	5
903	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 14:02:46.516	11
904	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 14:02:47.56	11
905	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 14:07:49.922	27
906	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 14:07:50.964	27
907	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 17:38:35.892	11
908	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 17:38:36.758	11
909	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 17:38:47.77	11
910	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 17:41:32.654	11
911	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:02:12.555	11
912	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:02:13.403	11
913	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:02:32.428	11
914	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:44:47.986	11
915	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:46:10.775	11
916	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:53:36.485	11
917	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:54:01.041	11
918	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:54:50.071	11
919	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:54:51.157	11
920	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:54:59.667	11
921	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:55:43.506	11
922	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:55:57.205	11
923	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:09.228	11
924	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:10.064	11
925	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:15.675	11
926	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:15.678	11
927	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:15.727	11
928	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:17.127	11
929	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:56:31.743	11
930	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:58:38.881	11
931	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:58:39.89	11
932	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 18:59:06.122	11
933	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:00:28.978	11
934	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:01:04.16	11
935	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:01:05.03	11
936	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:03:20.422	11
937	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:05:16.6	11
938	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:07:17.513	11
939	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:07:18.258	11
940	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:08:34.849	11
941	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:08:35.724	11
942	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:11:09.239	11
943	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:12:54.272	11
944	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:13:31.154	11
945	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:13:32.021	11
946	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:15:33.296	11
947	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:15:34.205	11
948	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:16:29.893	11
949	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:16:29.953	11
950	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:16:40.514	11
951	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:16:49.196	11
952	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:18:16.233	11
953	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:19:13.099	11
954	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:25:31.484	11
955	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:27:11.025	11
956	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:28:07.971	11
957	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:28:08.855	11
958	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:28:29.839	11
959	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:28:29.851	11
960	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:28:42.176	11
961	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:29:11.847	11
962	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:29:12.582	11
963	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:29:39.064	11
964	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:31:21.358	11
965	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:32:05.62	11
966	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 19:32:06.497	11
967	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 20:13:58.512	11
968	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 20:13:59.293	11
969	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 20:17:19.683	11
970	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 20:17:20.497	11
971	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 21:45:09.05	11
972	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 21:45:09.118	11
973	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 22:36:59.44	11
974	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-15 22:37:00.278	11
975	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:00:54.397	11
976	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:11:24.519	11
977	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:11:26.005	11
978	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:12:34.22	11
979	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:12:34.971	11
980	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:14:27.645	11
981	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:14:28.473	11
982	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:15:14.719	11
983	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:16:16.251	11
984	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:16:28.913	11
985	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:17:07.225	11
986	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:17:07.963	11
987	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:19:04.473	11
988	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:19:05.41	11
989	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:19:11.165	11
990	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:19:12.992	11
991	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:19:16.026	11
992	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:19:20.37	11
993	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:20:50.216	11
994	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:23:10.888	11
995	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:23:11.69	11
996	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:23:25.7	11
997	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:24:02.281	11
998	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:25:19.532	11
999	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:25:47.6	11
1000	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:26:24.112	11
1001	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:28:21.083	11
1002	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:43:32.781	11
1003	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:43:49.386	11
1004	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:45:01.263	11
1005	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:46:37.448	11
1006	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:50:58.911	11
1007	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:51:00.237	11
1008	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:54:25.059	11
1009	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 13:54:53.68	11
1010	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 17:41:57.756	11
1011	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 17:50:03.144	11
1012	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 17:51:15.115	11
1013	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 17:52:11.204	11
1014	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 17:52:12.446	11
1015	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:29:06.737	11
1016	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:29:16.297	11
1017	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:40:02.819	11
1018	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:41:10.301	11
1019	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:41:22.44	11
1020	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:43:04.461	11
1021	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:43:05.663	11
1022	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:43:24.434	11
1023	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:43:39.585	11
1024	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:50:55.352	11
1025	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:50:56.219	11
1026	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:52:33.483	11
1027	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:53:43.023	11
1028	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:53:43.746	11
1029	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:56:11.244	11
1030	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:56:32.357	11
1031	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:57:19.742	11
1032	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:57:21.003	11
1033	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 18:59:21.416	11
1034	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:00:54.814	11
1035	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:02:28.26	11
1036	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:02:54.75	11
1037	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:15:59.623	11
1038	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:16:00.497	11
1039	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:42:11.032	11
1040	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:42:40.743	11
1041	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:48:06.618	11
1042	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:48:24.666	11
1043	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:48:34.989	11
1044	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:48:40.808	11
1045	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:48:52.911	11
1046	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:49:16.94	11
1047	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:49:37.885	11
1048	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:49:44.628	11
1049	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:49:59.624	11
1050	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:50:08.659	11
1051	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:51:07.763	11
1052	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:51:18.642	11
1053	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:51:44.778	11
1054	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:52:18.758	11
1055	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:52:23.475	11
1056	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:53:35.01	11
1057	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:53:35.013	11
1058	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:53:35.124	11
1059	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:53:48.157	11
1060	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:54:26.17	11
1061	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:54:34.97	11
1062	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:56:21.744	11
1063	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:58:11.128	11
1064	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 19:58:25.636	11
1065	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:00:25.015	11
1066	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:00:45.465	11
1067	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:02:30.594	11
1068	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:02:39.827	11
2450	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:27:14.159	11
2452	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:27:17.188	11
2495	::1	VIEW_USER_INFO	2022-07-26 21:42:21.846	11
2501	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:18:48.979	11
2502	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:18:50.312	11
2506	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:19:27.055	11
2507	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:20:31.48	11
2508	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:20:31.892	11
2514	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:22:36.747	11
2518	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:24:31.636	11
2519	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:25:33.761	11
2521	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:25:34.248	11
2522	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:26:28.763	11
2523	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:26:29.203	11
2526	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:26:52.02	11
2530	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:28:02.67	11
2531	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:29:50.908	11
2532	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:29:51.254	11
2536	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:31:57.974	11
2537	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:34:21.748	11
2538	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:34:22.151	11
2574	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:09:57.632	11
2575	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:10:38.924	11
2577	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:10:39.921	11
2613	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:37:26.302	11
2614	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:37:26.488	11
2643	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:50:05.427	11
2682	::1	VIEW_USER_INFO	2022-07-29 21:56:12.686	11
2711	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:48:56.115	11
2739	::1	VIEW_USER_INFO	2022-07-30 20:38:08.767	11
2740	::1	VIEW_USER_INFO	2022-07-30 20:38:17.494	11
2776	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:24.874	11
2777	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:06:35.619	11
2779	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:01.77	11
2780	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:02.188	11
2880	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:30:46.457	11
2881	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:32:45.945	11
2883	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:32:46.513	11
2884	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:33:21.677	11
2885	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:33:22.206	11
2886	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:33:22.444	11
2887	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:34:44.637	11
2889	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:34:45.152	11
2935	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 10:52:06.924	11
2965	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:10:03.899	11
2966	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:10:04.295	11
2968	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:14:59.612	11
2990	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 17:51:02.634	11
2992	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 17:52:00.528	11
2993	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 17:52:00.589	11
2994	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 17:52:00.732	11
3014	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 15:30:11.193	11
3033	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 14:32:14.269	11
3034	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 14:32:14.382	11
3067	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:06:02.581	11
3068	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:06:02.615	11
3069	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:06:02.638	11
3070	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:09:55.113	11
3106	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:40:33.031	11
3109	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:44:15.604	11
3127	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:29:08.079	11
3130	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:32:49.218	11
3131	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:34:25.228	11
3138	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:18:20.62	11
3172	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 14:40:44.546	11
3174	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 14:44:31.861	11
3175	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 14:44:32.193	11
3216	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:24:42.923	11
3242	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:46:04.59	11
3276	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:25:45.043	11
3277	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:28:35.578	11
3278	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:28:35.776	11
3282	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:29:58.394	11
3322	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:32:42.649	11
3335	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:27:53.375	11
3336	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:28:05.401	11
3342	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:35:06.976	11
3344	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:38:41.261	11
3361	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:33:54.696	11
3363	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:35:31.741	11
3366	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:39:37.96	11
3370	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:47:01.582	11
3373	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:48:18.321	11
3382	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:03:58.256	11
3396	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 07:59:30.975	11
3398	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:00:05.956	11
3408	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:44:18.04	11
3427	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:58:43.147	11
3428	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:58:44.199	11
3464	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:05:02.364	11
3494	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 09:04:21.048	11
3508	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 18:28:38.908	11
3526	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:57:52.058	11
3527	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:58:04.934	11
3528	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:58:05.78	11
3529	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:58:46.904	11
1069	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:06:48.037	11
1070	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:09:30.962	11
1071	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:10:04.408	11
1072	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:10:13.654	11
1073	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:13:20.192	11
1074	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:16:15.563	11
1075	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:16:25.452	11
1076	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:25:22.156	11
1077	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:25:29.997	11
1078	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:25:59.27	11
1079	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:26:37.173	11
1080	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:27:22.078	11
1081	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:28:15.749	11
1082	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:30:42.754	11
1083	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:30:50.869	11
1084	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:34:35.001	11
1085	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 20:34:45.72	11
1086	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 21:23:02.054	11
1087	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 21:33:57.181	11
1088	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-16 21:33:58.31	11
1089	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-17 20:54:28.78	11
1090	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-17 20:54:29.852	11
1091	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-17 20:55:00.302	11
1092	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 13:14:30.123	11
1093	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 13:19:18.391	11
1094	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 13:20:19.02	11
1095	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 13:21:37.551	11
1096	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 15:16:43.291	11
1097	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 15:17:53.726	11
1098	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 15:21:15.185	11
1099	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 15:22:34.401	11
1100	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:17:43.376	11
1101	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:18:09.381	11
1102	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:19:56.293	11
1103	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:21:49.429	11
1104	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:22:06.44	11
1105	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:22:25.931	11
1106	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 16:25:19.625	11
1107	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:09:31.897	11
1108	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:14:28.777	11
1109	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:14:50.771	11
1110	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:15:57.578	11
1111	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:16:29.025	11
1112	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:16:34.01	11
1113	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:16:41.627	11
1114	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:17:08.507	11
1115	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:29:27.812	11
1116	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:30:09.937	11
1117	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:30:46.305	11
1118	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:32:08.192	11
1119	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:33:29.035	11
1120	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:34:33.49	11
1121	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:37:36.514	11
1122	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:40:55.792	11
1123	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:42:30.93	11
1124	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:43:52.394	11
1125	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:45:59.342	11
1126	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:46:52.767	11
1127	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:47:14.836	11
1128	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:47:35.303	11
1129	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:48:08.674	11
1130	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:48:44.074	11
1131	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:52:33.868	11
1132	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:55:52.324	11
1133	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:57:31.923	11
1134	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 17:58:07.211	11
1135	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:00:07.05	11
1136	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:02:47.354	11
1137	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:03:03.81	11
1138	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:03:38.786	11
1139	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:04:48.217	11
1140	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:05:02.414	11
1141	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:05:14.562	11
1142	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:05:44.638	11
1143	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:05:52.356	11
1144	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:06:34.275	11
1145	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:06:52.87	11
1146	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:13:52.554	11
1147	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:15:50.413	11
1148	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:17:07.142	11
1149	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:18:31.583	11
1150	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:20:13.575	11
1151	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:25:04.388	11
1152	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:27:02.819	11
1153	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:27:35.443	11
1154	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:30:47.779	11
1155	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:30:52.576	11
1156	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:33:33.341	11
1157	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:34:27.405	11
1158	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:35:54.677	11
1159	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:36:32.057	11
1160	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:36:35.054	11
1161	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:38:20.011	11
1162	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:39:19.367	11
1163	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:40:22.416	11
1164	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:40:55.761	11
1165	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:41:09.749	11
1166	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:42:57.831	11
1167	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:43:57.228	11
2451	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:27:17.044	11
2496	::1	VIEW_USER_INFO	2022-07-26 22:15:22.084	11
2497	::1	VIEW_USER_INFO	2022-07-26 22:15:22.359	11
2503	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:18:54.825	11
2504	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:19:26.672	11
2505	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:19:26.974	11
2509	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:20:31.983	11
2510	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:21:01.198	11
2511	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:21:01.671	11
2512	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:21:01.748	11
2513	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:22:36.365	11
2515	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:22:36.857	11
2516	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:24:30.538	11
2517	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:24:30.944	11
2520	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:25:34.155	11
2524	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:26:29.271	11
2525	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:26:51.573	11
2527	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:26:52.188	11
2528	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:28:02.183	11
2529	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:28:02.565	11
2533	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:29:51.315	11
2534	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:31:57.358	11
2535	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:31:57.795	11
2539	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:34:22.289	11
2578	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:30:24.217	11
2580	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:30:25.144	11
2584	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:33:29.148	11
2586	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:33:29.656	11
2615	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:43:33.272	11
2616	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:43:35.451	11
2617	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:45:42.777	11
2618	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:45:57.665	11
2619	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 11:47:29.995	11
2645	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:50:11.9	11
2646	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:50:56.097	11
2648	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:51:00.541	11
2649	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:51:00.76	11
2653	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:55:08.181	11
2655	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:55:11.607	11
2683	::1	VIEW_USER_INFO	2022-07-29 21:56:12.848	11
2712	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:48:56.617	11
2713	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:48:56.671	11
2741	::1	VIEW_USER_INFO	2022-07-30 20:38:33.734	11
2783	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:19.993	11
2784	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:20.09	11
2785	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:27.518	11
2786	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:08:27.99	11
2789	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:11:47.516	11
2794	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:16.313	11
2796	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:45.507	11
2797	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:47.837	11
2798	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:47.909	11
2799	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:48.019	11
2800	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:51.807	11
2801	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:51.861	11
2802	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:51.921	11
2803	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:53.764	11
2804	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:53.806	11
2805	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:53.839	11
2806	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:55.543	11
2807	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:55.58	11
2808	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:55.625	11
2809	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:57.927	11
2810	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:57.971	11
2811	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:58	11
2812	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:13:00.925	11
2813	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:13:01.054	11
2814	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:13:02.255	11
2815	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:13:03.675	11
2816	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:13:04.978	11
2890	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:26:25.946	11
2936	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 10:52:07.081	11
2967	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:10:26.339	11
2991	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 17:51:14.374	11
3015	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 16:42:46.227	11
3016	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 16:42:47.521	11
3035	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:13:11.198	11
3036	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:13:11.448	11
3071	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:14:23.529	11
3110	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 14:51:58.561	11
3128	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:29:12.707	11
3129	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:32:47.324	11
3139	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:18:32.477	11
3140	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:21:43.41	11
3176	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 14:44:32.412	11
3217	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:24:44.08	11
3219	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:25:41.648	11
3220	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:25:41.948	11
3224	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:29:56.241	11
3225	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:35:28.254	11
3226	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:35:28.53	11
3243	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:46:05.045	11
3244	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:46:05.156	11
3245	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:47:52.192	11
1168	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:45:22.79	11
2453	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:35:42.511	11
2454	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:35:43.187	11
2458	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:37:40.976	11
2498	::1	VIEW_USER_INFO	2022-07-26 22:15:22.681	11
2540	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 11:39:23.399	11
2579	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:30:24.731	11
2585	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:33:29.601	11
2587	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:34:18.894	11
2588	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:34:19.492	11
2591	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:34:31.603	11
2620	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:08:22.927	11
2621	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:08:51.564	11
2623	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:08:51.82	11
2624	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:09:24.422	11
2625	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:09:48.172	11
2650	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:52:30.962	11
2651	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:52:31.413	11
2652	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:52:31.496	11
2684	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:06:09.946	11
2690	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:09:29.716	11
2691	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:09:30.07	11
2692	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:09:30.125	11
2714	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:05:09.112	11
2716	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:05:13.345	11
2742	::1	VIEW_USER_INFO	2022-07-30 20:38:33.839	11
2790	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:11:52.676	11
2817	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:14:22.169	11
2819	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:14:24.685	11
2820	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:14:38.921	11
2937	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:04:10.01	11
2938	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:04:10.446	11
2941	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:05:25.359	11
2943	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:05:34.123	11
2969	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:15:31.744	11
2970	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:15:39.463	11
2971	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:15:39.689	11
2972	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:15:39.745	11
2995	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 17:52:43.383	11
3017	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 17:28:16.176	11
3037	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:13:11.553	11
3072	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:16:19.357	11
3073	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:16:19.468	11
3074	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:16:19.596	11
3111	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:00:56.607	11
3118	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:03:33.066	11
3119	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:03:33.171	11
3132	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 13:53:52.905	11
3141	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:23:31.046	11
3177	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 15:38:15.24	11
3218	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:24:51.856	11
3221	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:25:42.071	11
3222	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:29:55.784	11
3223	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:29:56.189	11
3246	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:48:19.863	11
3247	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:48:26.692	11
3283	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:36:08.264	11
3284	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:36:08.581	11
3287	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:36:59.195	11
3323	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:33:17.489	11
3337	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:28:17.757	11
3348	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:49:30.964	11
3354	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:54:07.703	11
3362	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:34:48.703	11
3365	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:38:37.38	11
3383	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:04:39.803	11
3386	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:09:01.306	11
3399	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:00:09.289	11
3409	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 09:35:10.979	11
3429	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 12:52:12.588	11
3465	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:05:42.587	11
3495	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 10:22:40.282	11
3509	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 18:29:48.315	11
3510	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 18:30:16.529	11
3530	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:59:05.019	11
3531	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:59:44.309	11
3532	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:00:59.868	11
3533	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:01:11.941	11
3535	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:02:31.273	11
3536	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 18:02:58.552	11
3555	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 17:37:06.602	11
3570	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 13:16:39.422	11
3571	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 13:16:45.594	11
3577	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:42:03.904	11
3591	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:22.215	11
3595	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:37.025	11
3597	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:37.413	11
3602	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:42:34.384	11
3610	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:19:27.499	11
3614	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:20:08.723	11
3620	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:22:13.024	11
3621	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:22:13.137	11
3626	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:29.439	11
3627	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:29.483	11
3628	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:41.948	11
3632	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:27:26.888	11
1169	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:46:11.543	11
1170	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:47:24.814	11
1171	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 18:47:46.163	11
1172	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:13:01.238	11
1173	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:15:22.47	11
1174	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:24:40.37	11
1175	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:25:58.125	11
1176	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:31:13.782	11
1177	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:33:17.308	11
1178	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:36:04.203	11
1179	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 19:36:51.801	11
1180	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:11:35.84	11
1181	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:13:17.231	11
1182	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:14:48.077	11
1183	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:15:47.14	11
1184	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:17:15.805	11
1185	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:17:20.346	11
1186	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:19:10.915	11
1187	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:20:16.437	11
1188	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:21:40.067	11
1189	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:22:59.731	11
1190	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:24:54.598	11
1191	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:26:15.997	11
1192	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:26:59.795	11
1193	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-18 20:37:33.06	11
1194	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 11:56:45.072	11
1195	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:00:22.612	11
1196	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:06:44.696	11
1197	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:11:13.196	11
1198	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:16:38.034	11
1199	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:17:16.127	11
1200	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:17:38.243	11
1201	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:17:41.586	11
1202	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:18:01.682	11
1203	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:18:15.174	11
1204	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 12:22:50.256	11
1205	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 13:26:39.421	11
1206	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 13:27:05.02	11
1207	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 13:27:40.345	11
1208	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 13:39:56.647	11
1209	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:23:26.146	11
1210	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:23:27.446	11
1211	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:24:19.929	11
1212	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:24:20.027	11
1213	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:24:34.625	11
1214	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:25:34.366	11
1215	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 14:25:35.225	11
1216	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:00:18.1	11
1217	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:04:50.943	11
1218	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:10:38.341	11
1219	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:10:57.13	11
1220	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:10:58.07	11
1221	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:11:23.622	11
1222	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:11:36.425	11
1223	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:12:38.356	11
1224	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:12:39.145	11
1225	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:16:18.801	11
1226	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:18:47.675	11
1227	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:19:08.042	11
1228	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:19:08.955	11
1229	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 18:19:32.662	11
1230	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:13:35.064	11
1231	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:13:50.839	11
1232	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:17:12.511	11
1233	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:17:49.727	11
1234	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:21:36.424	11
1235	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:22:04.374	11
1236	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:22:16.155	11
1237	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:22:26.607	11
1238	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:23:53.852	11
1239	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:24:13.341	11
1240	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:24:22.433	11
1241	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:24:39.266	11
1242	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:25:22.117	11
1243	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:26:32.256	11
1244	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:27:17.036	11
1245	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:27:37.612	11
1246	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:28:00.459	11
1247	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:28:53.711	11
1248	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:31:56.383	11
1249	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:32:01.232	11
1250	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:33:31.706	11
1251	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:34:06.793	11
1252	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:34:08.027	11
1253	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:34:39.592	11
1254	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:37:55.956	11
1255	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:37:58.256	11
1256	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:38:15.735	11
1257	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:38:25.166	11
1258	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:40:49.296	11
1259	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:41:06.73	11
1260	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:41:07.655	11
1261	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:43:41.537	11
1262	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:45:33.64	11
1263	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:49:54.83	11
1264	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:50:22.975	11
1265	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:50:55.62	11
1266	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:53:10.305	11
2455	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:35:43.576	11
2456	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:37:40.122	11
2457	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:37:40.682	11
2541	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:13:01.091	11
2542	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:13:01.411	11
2544	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:15:44.229	11
2581	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:32:03.543	11
2582	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:32:04.154	11
2583	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:32:04.341	11
2589	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:34:19.602	11
2590	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:34:31.11	11
2592	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:34:31.725	11
2622	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:08:51.571	11
2657	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 14:00:22.067	11
2659	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 14:00:22.974	11
2685	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:06:25.96	11
2686	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:06:26.096	11
2687	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:08:28.091	11
2689	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:08:28.612	11
2715	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:05:12.89	11
2717	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:05:13.425	11
2743	::1	VIEW_USER_INFO	2022-07-31 11:36:34.727	11
2744	::1	VIEW_USER_INFO	2022-07-31 11:36:43.228	11
2791	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:11:55.673	11
2792	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:11:56.045	11
2793	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:07.735	11
2795	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:12:26.546	11
2818	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:14:24.557	11
2821	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:14:45.067	11
2939	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:04:10.614	11
2940	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:05:11.272	11
2942	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:05:31.672	11
2944	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:05:34.501	11
2973	::1	VIEW_USER_INFO	2022-08-01 12:33:03.888	11
2975	::1	VIEW_USER_INFO	2022-08-01 12:33:20.711	11
2996	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:14:10.512	11
3018	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 17:28:23.824	11
3038	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:57:22.969	11
3039	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:57:24.367	11
3075	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:19:50.272	11
3076	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:20:43.806	11
3077	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:20:51.301	11
3078	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:21:00.107	11
3079	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:21:02.897	11
3080	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:21:02.938	11
3112	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:01:55.871	11
3113	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:01:55.954	11
3114	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:01:56.137	11
3116	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:03:19.724	11
3117	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:03:32.991	11
3133	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 15:05:32.53	11
3134	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 15:05:35.99	11
3135	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 15:05:40.106	11
3136	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-10 15:05:57.258	11
3142	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:32:54.699	11
3178	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:10:16.097	11
3180	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:10:16.544	11
3181	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:13:24.031	11
3182	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:13:24.467	11
3184	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:14:38.388	11
3227	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 18:35:28.728	11
3248	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:50:49.904	11
3285	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:36:08.737	11
3286	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:36:58.919	11
3288	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:36:59.415	11
3324	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:34:00.155	11
3338	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:29:03.34	11
3364	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:38:20.917	11
3374	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:48:41.726	11
3384	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:05:43.258	11
3400	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:01:05.367	11
3410	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 09:38:00.602	11
3430	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 12:52:59.229	11
3466	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:27:19.953	11
3496	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:18:39.796	11
3511	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:05:13.58	11
3513	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:08:04.486	11
3514	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:08:06.94	11
3515	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:08:23.185	11
3539	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:07:41.859	11
3540	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:07:45.752	11
3541	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:09:32.422	11
3545	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:16:05.968	11
3546	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:16:22.449	11
3547	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:16:23.46	11
3549	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:18:19.695	11
3556	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:25:28.761	11
3557	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:25:31.311	11
3558	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:25:34.581	11
3572	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 13:17:06.425	11
1267	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:53:43.364	11
1268	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:56:50.641	11
1269	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:57:16.183	11
1270	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:58:09.6	11
1271	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:58:40.058	11
1272	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:58:43.426	11
1273	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:58:55.913	11
1274	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 20:59:02.623	11
1275	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:00:30.095	11
1276	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:00:40.389	11
1277	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:00:50.144	11
1278	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:00:59.786	11
1279	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:01:09.753	11
1280	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:01:36.488	11
1281	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:03:47.187	11
1282	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:03:52.302	11
1283	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:04:02.316	11
1284	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:06:40.005	11
1285	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:08:05.995	11
1286	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:08:23.349	11
1287	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:10:46.743	11
1288	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:12:31.742	11
1289	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:13:03.455	11
1290	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:13:45.354	11
1291	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:18:19.792	11
1292	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:18:23.775	11
1293	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:19:29.713	11
1294	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:19:40.395	11
1295	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:21:32.186	11
1296	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-19 21:21:51.187	11
1297	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 10:55:25.624	11
1298	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 10:55:39.317	11
1299	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 10:55:45.175	11
1300	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 10:59:47.494	11
1301	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 10:59:53.144	11
1302	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:03:00.344	11
1303	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:03:21.947	11
1304	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:04:15.409	11
1305	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:05:15.718	11
1306	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:23:17.362	11
1307	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:23:18.626	11
1308	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:23:37.363	11
1309	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:32:52.051	11
1310	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:47:16.09	11
1311	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:48:44.576	11
1312	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:49:39.506	11
1313	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:50:02.158	11
1314	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:50:08.709	11
1315	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:54:23.392	11
1316	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 11:54:24.496	11
1317	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 22:21:32.277	11
1318	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 22:21:33.61	11
1319	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 22:22:25.214	11
1320	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 22:22:25.293	11
1321	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 22:22:55.394	11
1322	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-20 22:22:55.501	11
1323	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 11:31:20.293	11
1324	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 11:31:27.49	11
1325	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 11:31:29.854	11
1326	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:23:29.949	11
1327	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:23:29.994	11
1328	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:23:30.067	11
1329	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:25:04.987	11
1330	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:25:04.989	11
1331	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:25:05.076	11
1332	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:25:40.35	11
1333	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:25:40.353	11
1334	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:25:40.453	11
1335	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:28:50.56	11
1336	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:28:50.562	11
1337	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:28:50.63	11
1338	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:41:57.015	11
1339	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:41:57.878	11
1340	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:01.49	11
1341	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:01.531	11
1342	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:21.456	11
1343	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:21.459	11
1344	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:22.335	11
1345	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:22.383	11
1346	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:25.176	11
1347	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:25.192	11
1348	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:25.358	11
1349	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 13:42:28.744	11
1350	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:06:55.605	11
1351	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:06:55.676	11
1352	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:06:57.892	11
1353	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:06:57.897	11
1354	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:07:00.636	11
1355	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:07:00.675	11
1356	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:27:51.144	11
1357	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:27:51.145	11
1358	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:27:51.428	11
1359	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:34:25.962	11
1360	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:34:25.964	11
1361	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:34:26.18	11
1362	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:35:27.581	11
1363	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:35:27.582	11
1364	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:35:27.712	11
1365	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:48:51.295	11
1366	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:48:51.298	11
1367	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:48:51.629	11
1368	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:50:07.2	11
1369	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:50:07.202	11
1370	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:50:07.578	11
1371	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:50:27.84	11
1372	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:50:27.844	11
1373	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:50:27.949	11
1374	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:54:07.562	11
1375	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:54:07.563	11
1376	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:54:07.771	11
1377	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:55:27.088	11
1378	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:55:27.09	11
1379	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 19:55:27.267	11
1380	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:33:08.124	11
1381	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:33:08.125	11
1382	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:33:08.324	11
1383	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:35:49.812	11
1384	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:35:49.816	11
1385	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:35:49.906	11
1386	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:37:08.391	11
1387	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:37:08.392	11
1388	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:37:08.478	11
1389	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:37:55.693	11
1390	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:37:55.746	11
1391	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:37:55.802	11
1392	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:39:20.797	11
1393	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:39:20.8	11
1394	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:39:20.929	11
1395	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:42:16.118	11
1396	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:42:16.146	11
1397	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:42:16.224	11
1398	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:42:18.068	11
1399	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:42:30.634	11
1400	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:42:30.635	11
1401	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:43:06.906	11
1402	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:43:06.907	11
1403	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:43:18.716	11
1404	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:43:18.717	11
1405	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:45:14.886	11
1406	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:45:14.888	11
1407	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:45:14.99	11
1408	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:45:29.605	11
1409	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:45:29.607	11
1410	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:45:29.717	11
1411	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:39.37	11
1412	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:39.373	11
1413	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:39.568	11
1414	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:41.73	11
1415	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:53.915	11
1416	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:53.917	11
1417	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:53.986	11
1418	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:49:56.406	11
1419	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:50:04.795	11
1420	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:50:04.797	11
1421	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:50:04.949	11
1422	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:50:07.8	11
1423	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:50:07.801	11
1424	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:50:07.863	11
1425	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:56:20.964	11
1426	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:56:20.967	11
1427	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:56:21.137	11
1428	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:56:24.127	11
1429	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:57:53.023	11
1430	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:57:53.046	11
1431	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:57:53.122	11
1432	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:57:56.381	11
1433	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:58:02.401	11
1434	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:58:02.868	11
1435	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-21 20:58:06.545	11
1436	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:55:42.279	11
1437	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:55:50.614	11
1438	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:55:53.376	11
1439	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:55:56.751	11
1440	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:55:57.911	11
1441	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:56:03.886	11
1442	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:56:03.888	11
1443	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 10:56:03.987	11
1444	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:05:31.951	11
1445	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:05:31.952	11
1446	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:05:32.149	11
1447	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:06:11.469	11
1448	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:06:11.473	11
1449	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:06:11.547	11
1450	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:08:26.893	11
1451	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:08:26.895	11
1452	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:08:26.978	11
1453	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:11:59.439	11
1454	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:12:33.461	11
1455	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:12:33.465	11
1456	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:12:33.532	11
1457	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:13.116	11
1458	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:13.117	11
1459	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:13.308	11
1460	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:40.747	11
1461	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:44.993	11
1462	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:44.996	11
1463	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:18:45.104	11
1464	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:20:55.913	11
1465	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:20:55.919	11
1466	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:20:56.032	11
1467	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:21:02.663	11
1468	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:21:02.666	11
1469	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:21:02.766	11
1470	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:21:19.498	11
1471	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:21:19.499	11
1472	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:21:19.601	11
1473	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:22:08.841	11
1474	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:22:08.842	11
1475	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 11:22:08.969	11
1476	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:09:58.091	11
1477	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:09:58.093	11
1478	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:09:58.288	11
1479	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:11:38.309	11
1480	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:11:38.311	11
1481	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:11:38.383	11
1482	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:12:10.103	11
1483	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:12:10.104	11
1484	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:12:10.189	11
1485	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:12:45.4	11
1486	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:12:45.397	11
1487	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:12:45.52	11
1488	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:15:56.667	11
1489	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:15:56.668	11
1490	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:15:56.778	11
1491	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:18:08.603	11
1492	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:18:08.605	11
1493	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:18:08.726	11
1494	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:21:53.027	11
1495	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:21:53.028	11
1496	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:21:53.164	11
1497	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:22:47.772	11
1498	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:22:47.776	11
1499	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:22:47.866	11
1500	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:23:45.544	11
1501	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:23:45.545	11
1502	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:23:45.633	11
1503	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:23:50.234	11
1504	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:05.719	11
1505	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:05.72	11
1506	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:05.786	11
1507	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:17.39	11
1508	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:17.391	11
1509	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:17.454	11
1510	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:26.535	11
1511	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:24:33.765	11
1512	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:26:26.739	11
1513	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:26:26.743	11
1514	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:26:26.841	11
1515	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:27:08.75	11
1516	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:27:19.021	11
1517	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:27:20.009	11
1518	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:29:32.576	11
1519	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:29:43.608	11
1520	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:29:43.609	11
1521	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:29:43.689	11
1522	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:30:12.707	11
1523	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:17.134	11
1524	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:22.819	11
1525	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:28.165	11
1526	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:37.666	11
1527	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:57.891	11
1528	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:57.893	11
1529	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:32:58.096	11
1530	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:35:11.135	11
1531	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:35:14.412	11
1532	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:35:14.415	11
1533	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:35:14.545	11
1534	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:35:33.497	11
1535	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:12.261	11
1536	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:12.269	11
1537	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:12.376	11
1538	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:20.704	11
1539	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:31.014	11
1540	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:31.015	11
1541	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:36:31.125	11
1542	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:38:12.319	11
1543	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:38:13.39	11
1544	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:38:22.757	11
1545	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:38:22.76	11
1546	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:38:22.947	11
1547	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:38:29.108	11
1548	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:40:00.505	11
1549	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:40:00.516	11
1550	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:40:00.58	11
1551	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:40:24.205	11
1552	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:05.205	11
1553	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:05.208	11
1554	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:05.282	11
1555	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:12.554	11
1556	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:19.803	11
1557	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:19.805	11
1558	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:41:19.891	11
1559	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:42:50.38	11
1560	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:42:53.05	11
1561	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:42:53.055	11
1562	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:42:53.169	11
1563	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:02.924	11
1564	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:25.158	11
1565	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:34.944	11
1566	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:35.285	11
1567	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:42.943	11
1568	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:42.947	11
2459	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:46:08.594	11
2461	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:46:09.442	11
2462	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:46:53.634	11
2464	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:46:54.491	11
2465	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:48:13.24	11
2466	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:48:13.836	11
2470	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:52:22.607	11
2471	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:54:35.897	11
2472	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:54:36.607	11
2476	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:56:13.373	11
2543	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:13:01.457	11
2593	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:44:57.283	11
2595	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:44:58.02	11
2626	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:09:54.917	11
2658	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 14:00:22.851	11
2688	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 17:08:28.561	11
2718	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:13:04.457	11
2719	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:13:04.807	11
2721	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:14:18.339	11
2722	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:14:19.096	11
2745	::1	VIEW_USER_INFO	2022-07-31 11:36:59.8	11
2822	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 12:50:05.009	11
2823	::1	VIEW_USER_INFO	2022-07-31 12:52:50.219	11
2824	::1	VIEW_USER_INFO	2022-07-31 12:52:55.258	11
2901	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:52:43.282	11
2907	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:53:12.421	11
2908	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:54:03.705	11
2909	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:54:04.422	11
2915	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:55:31.94	11
2919	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:57:27.245	11
2920	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:58:15.784	11
2921	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:58:16.318	11
2923	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:59:57.598	11
2945	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:33:04.322	11
2974	::1	VIEW_USER_INFO	2022-08-01 12:33:20.651	11
2976	::1	VIEW_USER_INFO	2022-08-01 12:35:58.387	11
2997	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:31:09.554	11
3019	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 17:29:46.085	11
3040	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:58:49.106	11
3081	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:22:33.339	11
3115	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:03:08.917	11
3143	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:33:32.367	11
3179	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:10:16.378	11
3183	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:13:24.584	11
3187	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:17:38.48	11
3188	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:17:38.748	11
3228	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:04:04.904	11
3229	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:04:05.284	11
3249	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:50:53.766	11
3250	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:51:06.22	11
3251	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 21:51:41.646	11
3289	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:42:03.569	11
3291	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:42:04.133	11
3294	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:43:53.037	11
3295	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:45:30.122	11
3296	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:45:30.515	11
3298	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:51:59.82	11
3299	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:52:00.036	11
3300	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:52:00.136	11
3325	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:41:16.682	11
3326	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 10:45:59.245	11
3339	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:31:32.694	11
3345	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:40:45.506	11
3346	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:44:46.647	11
3367	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:40:56.299	11
3369	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:46:25.921	11
3385	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:08:10.781	11
3401	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:01:36.579	11
3411	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 09:38:04.49	11
3412	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 09:38:54.066	11
3413	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 09:41:37.4	11
3431	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 12:53:31.744	11
3432	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 12:54:45.903	11
3467	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:53:47.325	11
3497	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:29:05.129	11
3512	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:08:04.288	11
3542	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:09:47.153	11
3543	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:11:21.918	11
3548	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:16:36.112	11
3559	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:25:55.05	11
3560	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:25:55.118	11
3561	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:25:55.177	11
3562	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 18:26:10.49	11
3573	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 14:54:22.403	11
3578	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:47:04.353	11
3592	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:27.678	11
3593	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:28.1	11
1569	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:43:43.038	11
1570	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:45:21.861	11
1571	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:45:21.876	11
1572	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:45:21.937	11
1573	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:45:33.582	11
1574	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:45:51.954	11
1575	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:46:44.248	11
1576	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:46:44.27	11
1577	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 12:46:44.38	11
1578	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:15.132	11
1579	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:15.134	11
1580	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:15.42	11
1581	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:42.003	11
1582	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:42.006	11
1583	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:42.088	11
1584	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:48.986	11
1585	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:05:58.686	11
1586	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:06:08.757	11
1587	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:06:24.831	11
1588	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:06:49.316	11
1589	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:06:49.318	11
1590	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:06:49.377	11
1591	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:06:58.509	11
1592	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:07:15.54	11
1593	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:08:55.186	11
1594	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:08:55.189	11
1595	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:08:55.284	11
1596	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:09:16.077	11
1597	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:09:35.79	11
1598	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:10:36.595	11
1599	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:10:36.596	11
1600	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:10:36.761	11
1601	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:10:41.995	11
1602	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:10:48.815	11
1603	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:12:20.509	11
1604	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:12:20.511	11
1605	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:12:20.587	11
1606	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:12:25.386	11
1607	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:12:34.325	11
1608	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:14:37.981	11
1609	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:14:37.982	11
1610	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:14:38.075	11
1611	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:14:43.694	11
1612	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:14:53.176	11
1613	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:16:44.699	11
1614	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:16:44.702	11
1615	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:16:44.809	11
1616	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:16:50.08	11
1617	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:16:54.572	11
1618	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:17:09.305	11
1619	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:17:19.333	11
1620	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:17:30.223	11
1621	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:17:34.338	11
1622	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:17:34.341	11
1623	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:17:34.436	11
1624	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:18:09.234	11
1625	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:18:09.235	11
1626	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:18:09.563	11
1627	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:18:15.182	11
1628	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:19:09.05	11
1629	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:20:00.351	11
1630	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:20:00.353	11
1631	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:20:00.525	11
1632	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:20:58.507	11
1633	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:20:58.508	11
1634	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:20:58.621	11
1635	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:21:03.85	11
1636	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:21:10.973	11
1637	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:21:28.775	11
1638	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:12.639	11
1639	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:15.868	11
1640	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:15.87	11
1641	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:15.958	11
1642	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:34.57	11
1643	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:37.814	11
1644	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:37.815	11
1645	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:24:37.932	11
1646	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:25:40.009	11
1647	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:25:43.949	11
1648	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:25:43.95	11
1649	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:25:44.073	11
1650	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:25:46.266	11
1651	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:25:49.003	11
1652	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:27:13.966	11
1653	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:27:16.651	11
1654	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:27:16.655	11
1655	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:27:16.752	11
1656	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:27:22.667	11
1657	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:27:58.947	11
1658	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:28:15.469	11
1659	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:28:28.246	11
1660	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:32:00.816	11
1661	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:15.895	11
1662	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:15.897	11
1663	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:16.054	11
1664	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:34.225	11
1665	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:34.228	11
1666	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:34.329	11
1667	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:35.79	11
1668	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:44:50.428	11
1669	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:46:14.05	11
1671	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:46:14.132	11
1672	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:46:29.742	11
1673	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:46:40.838	11
1674	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:06.643	11
1675	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:14.223	11
1676	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:16.107	11
1677	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:22.734	11
1678	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:22.736	11
1679	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:22.804	11
1680	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:24.917	11
1681	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:47:32.121	11
1682	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:48:28.704	11
1683	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:48:49.542	11
1684	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:49:02.481	11
1685	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:49:13.88	11
1686	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:54:08.209	11
2460	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:46:09.263	11
2463	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:46:54.028	11
2467	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:48:14.015	11
2468	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:52:21.901	11
2469	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:52:22.427	11
2473	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:54:36.874	11
2474	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:56:12.467	11
2475	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 20:56:13.309	11
2545	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:15:47.265	11
2546	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:15:47.567	11
2594	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:44:57.833	11
2627	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 12:09:55.019	11
2660	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:40:50.642	11
2661	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:41:05.368	11
2693	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:27:31.301	11
2695	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:27:35.956	11
2697	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:28:14.87	11
2698	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:28:14.995	11
2720	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:13:04.942	11
2746	::1	VIEW_USER_INFO	2022-07-31 11:36:59.894	11
2825	::1	VIEW_USER_INFO	2022-07-31 12:53:05.739	11
2902	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:52:44.026	11
2946	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:33:04.862	11
2947	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:33:04.936	11
2977	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:56:02.726	11
2998	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:36:54.225	11
2999	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:40:22.84	11
3020	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 17:31:48.612	11
3021	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-02 17:35:44.996	11
3041	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:58:49.163	11
3042	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 15:58:49.209	11
3043	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:02:36.063	11
3082	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:22:33.43	11
3083	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:22:33.508	11
3120	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:15:19.428	11
3144	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:37:02.419	11
3146	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:37:08.833	11
3185	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:14:38.86	11
3186	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:14:39.093	11
3189	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:17:38.788	11
3190	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-12 22:18:32.546	11
3230	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:04:05.443	11
3252	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:16:41.185	11
3253	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:16:53.489	11
3261	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:00:50.001	11
3262	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:00:51.153	11
3290	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:42:03.904	11
3292	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:43:52.507	11
3293	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:43:52.843	11
3297	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 16:45:30.673	11
3327	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 13:21:56.433	11
3341	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:33:59.571	11
3352	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:53:04.283	11
3356	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:55:36.853	11
3371	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:47:28.992	11
3387	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:17:24.267	11
3402	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:01:49	11
3414	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 09:52:25.149	11
3433	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 12:56:32.581	11
3434	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:01:33.321	11
3468	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:57:07.824	11
3469	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:57:08.917	11
3472	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:58:31.297	11
3473	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:58:31.593	11
3474	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:59:36.059	11
3476	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:59:36.644	11
3477	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:00:01.868	11
3483	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:03:32.311	11
3484	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:04:26.779	11
3485	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:04:26.883	11
3486	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:04:51.353	11
3498	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:29:06.315	11
3516	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:41:33.572	11
3517	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:42:50.409	11
3518	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:44:46.965	11
3544	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:12:17.656	11
3563	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:03:04.514	11
1670	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 13:46:14.054	11
1687	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:46.564	11
1688	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:46.566	11
1689	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:50.55	11
1690	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:50.55	11
1691	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:51.445	11
1692	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:57.372	11
1693	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:57.374	11
1694	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:23:57.488	11
1695	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:26:36.588	11
1696	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:26:36.629	11
1697	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:26:36.756	11
1698	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:27:36.342	11
1699	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:27:36.343	11
1700	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:27:36.419	11
1701	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:28:46.771	11
1702	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:28:46.772	11
1703	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:28:46.855	11
1704	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:29:53.449	11
1705	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:29:53.45	11
1706	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:29:53.579	11
1707	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:30:05.704	11
1708	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:30:05.705	11
1709	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:30:05.783	11
1710	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:30:44.643	11
1711	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:30:44.644	11
1712	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:30:44.715	11
1713	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:31:33.734	11
1714	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:31:33.735	11
1715	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:31:33.814	11
1716	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:31:51.831	11
1717	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:31:51.853	11
1718	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:31:51.918	11
1719	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:32:35.166	11
1720	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:32:35.168	11
1721	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:32:35.439	11
1722	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:32:44.421	11
1723	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:32:44.422	11
1724	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:32:44.574	11
1725	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:34:41.916	11
1726	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:34:41.92	11
1727	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:34:41.996	11
1728	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:34:56.219	11
1729	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:34:56.221	11
1730	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:34:56.355	11
1731	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:35:07.254	11
1732	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:35:07.255	11
1733	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:35:07.339	11
1734	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:36:25.388	11
1735	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:36:25.39	11
1736	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:36:25.49	11
1737	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:36:47.873	11
1738	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:36:47.874	11
1739	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:36:47.949	11
1740	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:37:14.791	11
1741	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:37:14.792	11
1742	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:37:14.89	11
1743	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:37:54.563	11
1744	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:37:54.57	11
1745	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:37:54.654	11
1746	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:38:03.824	11
1747	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:39:43.77	11
1748	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:40:08.438	11
1749	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:40:34.545	11
1750	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:07.703	11
1751	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:17.517	11
1752	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:19.526	11
1753	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:21.127	11
1754	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:35.878	11
1755	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:35.879	11
1756	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:36.049	11
1757	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:41.783	11
1758	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:52.839	11
1759	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:53.767	11
1760	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:42:59.504	11
1761	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:45:07.484	11
1762	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:45:10.652	11
1763	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:45:32.74	11
1764	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:46:33.167	11
1765	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:46:52.029	11
1766	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 16:47:36.151	11
1767	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:19:37.623	11
1768	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:19:37.623	11
1769	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:24:47.984	11
1770	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:24:47.99	11
1771	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:24:48.232	11
1772	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:24:57.753	11
1773	::ffff:127.0.0.1	CHANGE_EMAIL	2022-07-22 17:24:57.755	11
1774	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:25:54.687	11
1775	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:25:54.689	11
1776	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:25:54.741	11
1777	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:26:16.939	11
1778	::ffff:127.0.0.1	CHANGE_EMAIL	2022-07-22 17:26:16.942	11
1779	::ffff:127.0.0.1	CHANGE_EMAIL	2022-07-22 17:27:01.243	11
1780	::ffff:127.0.0.1	CHANGE_EMAIL	2022-07-22 17:27:05.832	11
1781	::ffff:127.0.0.1	CHANGE_EMAIL	2022-07-22 17:27:07.341	11
1782	::ffff:127.0.0.1	CHANGE_EMAIL	2022-07-22 17:27:08.528	11
1783	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:27:23.149	11
1784	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:27:23.15	11
1785	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:37:05.794	11
1786	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:37:05.796	11
1787	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:37:43.001	11
1788	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:37:43.002	11
1789	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:37:43.072	11
1790	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:37:50.207	11
1791	::ffff:127.0.0.1	CHANGE_PASSWORD	2022-07-22 17:37:50.252	11
1792	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:38:18.79	11
1793	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 17:38:18.914	11
1794	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:39:03.764	11
1795	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:39:03.768	11
1796	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:39:16.919	11
1797	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:39:16.925	11
1798	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:39:43.558	11
1799	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:39:43.56	11
1800	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:48:31.984	11
1801	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:48:38.064	11
1802	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 18:49:03.949	11
1803	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:13:57.973	11
1804	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:14:07.737	11
1805	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:21:42.516	11
1806	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:21:59.703	11
1807	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:22:45.856	11
1808	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:23:23.988	11
1809	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:24:01.084	11
1810	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:24:02.105	11
1811	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:35:59.319	11
1812	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:36:33.986	11
1813	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:36:35.026	11
1814	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:38:51.544	11
1815	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:38:52.323	11
1816	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:55:21.822	11
1817	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 19:58:17.425	11
1818	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:04:24.155	11
1819	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:05:01.908	11
1820	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:06:07.21	11
1821	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:06:39.822	11
1822	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:08:24.586	11
1823	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:34:28.723	11
1824	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:50:03.687	11
1825	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:50:33.16	11
1826	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:51:12.879	11
1827	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:51:23.543	11
1828	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:53:25.043	11
1829	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:53:47.196	11
1830	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:54:52.878	11
1831	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:55:41.742	11
1832	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:57:29.532	11
1833	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:57:42.342	11
1834	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:58:03.154	11
1835	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:58:15.696	11
1836	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 20:58:32.244	11
1837	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 21:03:08.347	11
1838	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 21:03:38.02	11
1839	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-22 21:04:33.203	11
1840	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 10:46:40.246	11
1841	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 10:59:40.222	11
1842	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 10:59:54.153	11
1843	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:00:19.801	11
1844	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:06:51.143	11
1845	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:12.925	11
1846	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:12.931	11
1847	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:13.058	11
1848	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:17.42	11
1849	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:17.422	11
1850	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:17.541	11
1851	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:35.695	11
1852	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:41.913	11
1853	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:07:57.963	11
1854	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:08:20.392	11
1855	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:08:20.405	11
1856	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:08:20.489	11
1857	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:10:40.229	11
1858	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:11:35.308	11
1859	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:12:30.869	11
1860	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:13:10.77	11
1861	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:16:39.843	11
1862	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:16:54.547	11
1863	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:17:16.288	11
1864	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:17:27.818	11
1865	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:18:00.307	11
1866	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:18:27.866	11
1867	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:18:52.531	11
1868	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:20:55.66	11
1869	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:21:08.249	11
1870	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:21:44.052	11
1871	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:22:11.561	11
1872	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:22:34.136	11
1873	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:22:57.725	11
1874	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:23:08.49	11
1875	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:23:57.293	11
1876	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:25:11.798	11
1877	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:25:19.659	11
1878	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:25:45.702	11
1879	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:25:49.85	11
1880	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:25:55.635	11
1881	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:25:58.757	11
1882	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:26:03.102	11
1883	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:26:07.176	11
1884	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:34:31.4	11
1885	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:34:46.588	11
1886	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:35:23.096	11
1887	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:35:31.123	11
1888	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:36:03.775	11
1889	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:38:01.662	11
1890	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:41:24.778	11
1891	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:42:02.282	11
1892	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:48:04.03	11
1893	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:48:12.5	11
1894	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:48:49.276	11
1895	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:49:29.993	11
1896	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:51:30.816	11
1897	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:52:14.711	11
1898	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:54:34.715	11
1899	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 11:54:35.525	11
1900	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 12:15:09.661	11
1901	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 12:28:43.139	11
1902	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 12:51:13.619	11
1903	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:11:56.018	11
1904	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:14:03.647	11
1905	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:14:55.588	11
1906	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:35:09.965	11
1907	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:35:45.926	11
1908	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:36:27.035	11
1909	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 13:37:48.253	11
1910	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:21:47.212	11
1911	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:26:33.796	11
1912	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:26:33.847	11
1913	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:26:40.969	11
1914	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:29:47.981	11
1915	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:29:48.965	11
1916	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:30:01.653	11
1917	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:30:22.58	11
1918	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:31:32.95	11
1919	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:31:33.739	11
1920	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:31:38.922	11
1921	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:38:45.71	28
1922	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:38:51.453	28
1923	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:38:54.249	28
1924	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:38:55.978	28
1925	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:38:57.482	28
1926	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:38:58.513	28
1927	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:39:12.297	28
1928	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:39:13.829	28
1929	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:40:40.483	29
1930	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:40:41.456	29
1931	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:40:51.155	29
1932	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:40:51.156	29
1933	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:41:01.447	29
1934	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:41:01.457	29
1935	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:45:02.438	11
1936	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:53:02.788	11
1937	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:53:12.206	11
1938	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:54:50.571	11
1939	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:55:12.372	11
1940	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 16:59:56.238	11
1941	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 17:02:44.026	11
1942	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 17:03:11.116	11
1943	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:29:03.898	11
1944	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:29:10.147	11
1945	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:31:04.346	11
1946	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:54:37.17	11
1947	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:54:50.236	11
1948	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:55:14.744	11
1949	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:55:25.859	11
1950	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:56:54.839	11
1951	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:57:00.074	11
1952	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:57:13.683	11
1953	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:57:39.903	11
1954	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 19:59:45.81	11
1955	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:00:15.905	11
1956	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:02:53.906	11
1957	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:03:57.259	11
1958	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:06:16.074	11
1959	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:07:11.591	11
1960	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:10:13.044	11
1961	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:10:56.617	11
1962	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:13:08.983	11
1963	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:13:24.975	11
1964	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:13:58.289	11
1965	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:14:08.997	11
1966	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:14:22.937	11
1967	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:14:27.626	11
1968	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:23:06.001	11
1969	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:23:24.954	11
1970	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:23:57.093	11
1971	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:25:31.691	11
1972	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:26:15.45	11
1973	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:26:35.389	11
1974	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:27:55.226	11
1975	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:28:25.448	11
1976	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:29:37.657	11
1977	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:29:51.604	11
1979	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:31:09.772	11
1981	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:32:16.807	11
1983	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:33:13.609	11
2477	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:08:41.347	11
2479	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:08:42.418	11
2480	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:09:02.142	11
2481	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:09:03.06	11
2484	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:09:31.59	11
2485	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:09:31.795	11
2547	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:31:02.877	11
2548	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:31:04.088	11
2559	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:38.45	11
2560	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:39:31.512	11
2562	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:39:35.84	11
2596	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 18:45:54.204	11
2628	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 15:11:09.881	11
2629	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 15:14:40.587	11
2662	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:41:06.237	11
2663	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:41:06.35	11
2694	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:27:35.867	11
2696	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:28:14.197	11
2701	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:28:38.253	11
2723	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:14:19.143	11
2747	::1	VIEW_USER_INFO	2022-07-31 11:42:09.537	11
2748	::1	VIEW_USER_INFO	2022-07-31 11:44:57.864	11
2749	::1	VIEW_USER_INFO	2022-07-31 11:46:05.014	11
2750	::1	VIEW_USER_INFO	2022-07-31 11:46:51.22	11
2826	::1	VIEW_USER_INFO	2022-07-31 12:53:05.828	11
2903	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:52:48.401	11
2904	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:52:48.449	11
2905	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:53:12.037	11
2906	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:53:12.352	11
2910	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:54:05.44	11
2911	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:54:48.195	11
2912	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:54:48.649	11
2913	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:54:48.829	11
2914	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:55:31.567	11
2916	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:55:32.081	11
2917	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:57:26.678	11
2918	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:57:27.106	11
2922	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:58:16.429	11
2948	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:36:16.704	11
2950	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:36:17.119	11
2978	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:56:27.891	11
2979	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:56:27.947	11
2980	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 12:56:28.041	11
3000	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:42:03.709	11
3001	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:46:41.042	11
3022	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 09:08:40.828	11
3044	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:02:56.675	11
3047	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:03:26.541	11
3049	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:03:26.941	11
3050	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:04:22.708	11
3051	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:04:23.196	11
3084	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:24:06.835	11
3121	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:54:31.984	11
3145	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:37:08.749	11
3191	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 09:23:44.966	11
3231	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:08:14.983	11
3233	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:08:19.626	11
3254	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:18:20.229	11
3255	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:18:22.431	11
3256	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:18:25.799	11
3263	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:31:54.533	11
3264	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:33:32.872	11
3265	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:34:10.913	11
3301	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:41:09.066	11
3302	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:41:09.384	11
3328	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 13:29:25.301	11
3343	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:35:15.669	11
3349	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:50:05.035	11
3350	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:50:20.816	11
3372	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:47:57.172	11
3388	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:17:53.568	11
3391	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:19:17.748	11
3403	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:06:30.291	11
3415	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:00:39.465	11
3435	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:03:12.416	11
3436	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:05:19.408	11
3437	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:06:03.627	11
3438	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:06:57.956	11
3439	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:15:08.805	11
3470	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:57:13.633	11
3471	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:58:30.922	11
3475	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:59:36.515	11
3478	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:01:16.734	11
3479	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:02:26.973	11
3480	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:02:58.93	11
3481	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:03:01.802	11
3482	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:03:32.248	11
3487	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 15:04:51.443	11
3499	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:35:53.005	30
3500	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:35:53.928	30
3501	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:36:07.711	30
3519	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 10:53:30.994	11
3550	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:35:54.801	11
3551	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 10:37:05.387	11
1978	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:30:55.131	11
1980	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:31:51.199	11
1982	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:33:02.895	11
1984	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:34:01.191	11
1985	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:34:35.086	11
1986	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:35:14.535	11
1987	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:36:41.843	11
1988	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:36:52.584	11
1989	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:38:00.205	11
1990	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:38:12.889	11
1991	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:41:12.098	11
1992	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:46:44.742	11
1993	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:47:58.483	11
1994	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:48:20.798	11
1995	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 20:50:09.955	11
1996	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-23 21:39:22.024	11
1997	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:22:29.34	11
1998	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:23:20.978	11
1999	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:25:04.714	11
2000	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:25:06.488	11
2001	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:08.749	11
2002	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:09.787	11
2003	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:16.398	11
2004	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:31.977	11
2005	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:57.587	11
2006	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:57.593	11
2007	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:27:57.933	11
2008	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:35.532	11
2009	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:35.612	11
2010	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:35.944	11
2011	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:44.471	11
2012	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:49.38	11
2013	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:49.383	11
2014	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:28:49.74	11
2015	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:32:42.578	11
2016	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:32:42.717	11
2017	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:32:42.936	11
2018	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:33:25.472	11
2019	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:33:29.525	11
2020	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:33:29.578	11
2021	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:33:29.74	11
2022	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:34:58.212	11
2023	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:35:41.453	11
2024	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:35:42.681	11
2025	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:35:45.653	11
2026	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:35:45.707	11
2027	::1	VIEW_USER_INFO	2022-07-24 21:37:42.133	11
2028	::1	VIEW_USER_INFO	2022-07-24 21:40:22.312	11
2029	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:41:55.909	11
2030	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:42:00.646	11
2031	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:42:13.422	11
2032	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:44:26.803	11
2033	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:44:29.181	11
2034	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-24 21:44:29.231	11
2035	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:19:21.742	11
2036	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:19:45.435	11
2037	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:19:46.754	11
2038	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:20:14.897	11
2039	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:20:14.961	11
2040	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:20:23.345	11
2041	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:20:24.076	11
2042	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:22:22.838	11
2043	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:22:22.841	11
2044	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:22:37.228	11
2045	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:22:38.045	11
2046	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:23:02.986	11
2047	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:23:02.989	11
2048	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:23:06.814	11
2049	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:23:06.88	11
2050	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:23:50.319	11
2051	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:23:50.927	11
2052	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:24:13.71	11
2053	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:24:14.635	11
2054	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:24:54.898	11
2055	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:24:54.899	11
2056	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:25:01.785	11
2057	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:25:02.562	11
2058	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:26:33.851	11
2059	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:26:33.853	11
2060	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:26:33.996	11
2061	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:26:54.815	11
2062	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:26:55.542	11
2063	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:27:14.629	11
2064	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:27:14.747	11
2065	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:29:39.552	11
2066	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:29:40.464	11
2067	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:29:51.67	11
2068	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:29:51.731	11
2069	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:30:27.356	11
2070	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:30:28.219	11
2071	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:30:36.146	11
2072	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:34:09.137	11
2073	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:34:10.351	11
2074	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:36:32.305	11
2075	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:36:33.242	11
2076	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:36:55.115	11
2077	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:37:11.81	11
2078	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:37:48.787	11
2079	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:37:51.338	11
2080	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:38:03.587	11
2081	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:39:46.341	11
2082	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:39:47.263	11
2083	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:42:02.655	11
2084	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:42:03.659	11
2085	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:42:12.179	11
2086	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:43:50.565	11
2087	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:43:50.984	11
2088	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:43:51.067	11
2089	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:44:13.514	11
2090	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:44:14.017	11
2091	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:44:14.136	11
2092	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:47:25.4	11
2093	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:47:29.791	11
2094	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:47:31.874	11
2095	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:48:05.971	11
2096	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:48:06.013	11
2097	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:48:17.352	11
2098	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:48:23.221	11
2099	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:48:32.951	11
2100	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:55:50.86	11
2101	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:18.328	11
2102	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:20.108	11
2103	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:20.463	11
2104	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:36.817	11
2105	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:41.756	11
2106	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:42.157	11
2107	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 10:56:42.279	11
2108	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:03:53.737	11
2109	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:03:56.787	11
2110	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:03:56.9	11
2111	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:09:42.591	11
2112	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:11:05.271	11
2113	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:13:05.113	11
2114	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:15:10.797	11
2115	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:15:14.984	11
2116	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:15:15.228	11
2117	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:15:40.71	11
2118	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:15:46.07	11
2119	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:19:36.073	11
2120	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:19:36.462	11
2121	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:19:36.673	11
2122	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:21:04.794	11
2123	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:41:40.206	11
2124	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:41:49.996	11
2125	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:41:54.292	11
2126	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:41:54.539	11
2127	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:41:54.647	11
2128	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:42:03.914	11
2129	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:42:06.177	11
2130	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:42:06.345	11
2131	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:47:40.154	11
2132	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:47:40.418	11
2133	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:47:40.671	11
2134	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:48:06.499	11
2135	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:48:06.74	11
2136	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:48:06.786	11
2137	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:49:44.56	11
2138	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:49:44.958	11
2139	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:49:45.079	11
2140	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:51:39.205	11
2141	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:51:39.533	11
2142	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:51:39.716	11
2143	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:53:18.698	11
2144	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:53:18.923	11
2145	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:53:19.046	11
2146	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:57:52.032	11
2147	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:57:52.387	11
2148	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 11:57:52.501	11
2149	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:11:27.472	11
2150	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:11:27.692	11
2151	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:11:27.786	11
2152	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:18:20.404	11
2153	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:18:20.866	11
2154	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:18:21.024	11
2155	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:00.412	11
2156	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:03.338	11
2157	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:07.602	11
2158	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:08.895	11
2159	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:10.215	11
2160	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:15.945	11
2161	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:17.388	11
2162	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:18.74	11
2163	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:19.974	11
2164	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:23:30.054	11
2165	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:24:31.782	11
2166	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:24:32.102	11
2167	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:24:32.16	11
2168	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:32:02.76	11
2169	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:32:03.116	11
2170	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:32:03.19	11
2171	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:34:09.167	11
2172	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:34:54.093	11
2173	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:28.14	11
2174	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:28.505	11
2175	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:28.561	11
2176	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:34.071	11
2178	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:34.642	11
2179	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:58.137	11
2181	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:36:18.113	11
2184	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:36:31.481	11
2478	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:08:42.076	11
2482	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:09:03.239	11
2483	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:09:30.703	11
2549	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:32:11.679	11
2550	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:34:54.419	11
2551	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:34:58.539	11
2553	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:21.05	11
2554	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:21.915	11
2597	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 19:49:34.414	11
2599	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 19:49:35.319	11
2630	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 15:14:48.368	11
2631	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-28 15:14:48.552	11
2664	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:47:13.631	11
2665	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:47:14.082	11
2699	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:28:37.388	11
2700	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:28:37.589	11
2724	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:19:49.112	11
2725	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:22:09.482	11
2751	::1	VIEW_USER_INFO	2022-07-31 11:46:51.477	11
2752	::1	VIEW_USER_INFO	2022-07-31 11:46:51.783	11
2827	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:06:17.399	11
2831	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:11:24.235	11
2841	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:36.56	11
2924	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:59:57.939	11
2925	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:59:58.083	11
2949	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:36:17.034	11
2981	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 13:08:34.884	11
3002	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:54:02.677	11
3023	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 09:08:47.291	11
3045	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:02:56.77	11
3046	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:02:56.839	11
3048	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:03:26.884	11
3052	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:04:23.265	11
3053	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:08:52.095	11
3054	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:08:53.273	11
3085	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:24:06.875	11
3086	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:24:06.978	11
3122	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:55:31.785	11
3123	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 15:56:09.351	11
3147	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:46:49.376	11
3148	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:46:49.711	11
3192	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 09:23:48.404	11
3193	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 09:23:48.514	11
3196	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 09:26:43.163	11
3232	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:08:19.509	11
3257	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:21:47.609	11
3258	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:23:05.722	11
3259	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:23:07.994	11
3260	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-14 09:23:08.024	11
3266	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:39:08.497	11
3303	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:41:09.509	11
3304	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:47:10.198	11
3307	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:54:59.19	11
3329	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 13:33:37.687	11
3347	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:48:45.461	11
3375	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:49:25.89	11
3389	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:18:25.413	11
3390	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:18:53.266	11
3404	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:15:40.478	11
3416	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:01:57.37	11
3417	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:02:49.616	11
3440	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:27:23.654	11
3442	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:29:24.684	11
3443	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:30:03.855	11
3446	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:06.858	11
3451	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:45.323	11
3454	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:33:36.723	11
3455	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:34:15.806	11
3456	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:34:24.767	11
3488	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 21:34:45.859	11
3502	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 14:36:07.822	30
3520	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 14:17:40.796	11
3552	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 12:29:48.517	11
3564	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:03:14.866	11
3565	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:03:25.84	11
3566	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:03:39.404	11
3574	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:24:29.566	11
3579	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:57:06.25	11
3580	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:57:07.531	11
3582	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:58:30.828	11
3583	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:58:31.269	11
3587	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:59:38.652	11
3588	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:59:39.384	11
3589	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:59:41.902	11
3594	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:28.252	11
3596	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:37.284	11
3598	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:09:45.044	11
3603	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:01:42.942	11
3611	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:15:02.479	11
3622	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:09.921	11
3623	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:10.088	11
2177	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:35:34.556	11
2180	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:36:17.818	11
2182	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:36:18.203	11
2183	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:36:31.187	11
2185	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:36:31.554	11
2186	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:47:09.515	11
2187	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:47:27.927	11
2188	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:47:28.246	11
2189	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:47:28.399	11
2190	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:06.262	11
2191	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:07.426	11
2192	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:10.231	11
2193	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:10.269	11
2194	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:14.424	11
2195	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:14.678	11
2196	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:14.82	11
2197	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:42.654	11
2198	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:43.513	11
2199	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:47.046	11
2200	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:47.145	11
2201	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:50.775	11
2202	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:51.299	11
2203	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:48:51.412	11
2204	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:49:13.05	11
2205	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:55:20.083	11
2206	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 12:55:20.169	11
2207	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 15:35:58.237	11
2208	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 15:36:01.947	11
2209	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 15:36:02.496	11
2210	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 15:36:02.569	11
2211	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 15:47:03.45	11
2212	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:00:27.957	11
2213	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:00:28.361	11
2214	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:12:41.084	11
2215	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:12:41.457	11
2216	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:12:41.509	11
2217	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:14.856	11
2218	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:15.252	11
2219	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:15.35	11
2220	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:33.237	11
2221	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:44	11
2222	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:44.384	11
2223	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:44.484	11
2224	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:52.259	11
2225	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:54.208	11
2226	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:56.427	11
2227	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:14:58.412	11
2228	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 16:15:06.004	11
2229	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 17:49:43.777	11
2230	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 17:49:43.994	11
2231	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:01:18.092	11
2232	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:01:18.465	11
2233	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:01:18.603	11
2234	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:28:51.067	11
2235	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:28:51.431	11
2236	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:28:51.5	11
2237	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:29:12.399	11
2238	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:29:12.799	11
2239	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:29:12.866	11
2240	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:30:00.845	11
2241	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:30:01.29	11
2242	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:30:01.363	11
2243	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:31:44.276	11
2244	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:31:44.72	11
2245	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:31:44.8	11
2246	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:32:53.899	11
2247	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:32:54.133	11
2248	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:32:54.203	11
2249	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:33:45.092	11
2250	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:33:45.35	11
2251	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:33:45.411	11
2252	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:35:50.56	11
2253	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:35:50.996	11
2254	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:35:51.139	11
2255	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:36:39.039	11
2256	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:36:39.331	11
2257	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:36:39.447	11
2258	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:37:04.65	11
2259	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:37:04.916	11
2260	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:37:05.068	11
2261	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:37:53.383	11
2262	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:37:53.747	11
2263	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:37:53.804	11
2264	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:38:24.648	11
2265	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:38:24.946	11
2266	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:38:25.075	11
2267	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:38:28.937	11
2268	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:40:53.039	11
2269	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:40:53.376	11
2270	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:40:53.44	11
2271	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:41:45.103	11
2272	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:41:45.394	11
2273	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:41:45.563	11
2274	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:42:53.875	11
2275	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:42:54.281	11
2276	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:42:54.353	11
2277	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:58:29.364	11
2278	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:58:30.864	11
2279	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:58:47.297	11
2280	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:58:50.316	11
2281	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:59:53.157	11
2282	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:59:55.1	11
2283	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 18:59:57.1	11
2486	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:19:36.192	11
2552	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:34:58.609	11
2598	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 19:49:35.238	11
2632	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:40:27.336	11
2635	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:40:47.428	11
2666	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:48:05.062	11
2667	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:48:22.262	11
2668	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:48:22.729	11
2669	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:48:22.845	11
2674	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:55:19.451	11
2702	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:41:49.632	11
2726	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:49:29.209	11
2729	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:51:46.678	11
2730	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:51:46.848	11
2753	::1	VIEW_USER_INFO	2022-07-31 11:49:52.915	11
2828	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:06:32.022	11
2830	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:11:21.77	11
2838	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:16:29.324	11
2839	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:16:29.415	11
2840	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:31.619	11
2926	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:25:40.476	11
2951	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:47:58.459	11
2952	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:47:59.005	11
2956	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:48:26.662	11
2982	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 13:14:36.192	11
3003	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:54:06.363	11
3024	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 09:51:12.542	11
3055	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:09:56.59	11
3087	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:34:16.376	11
3090	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:36:09.326	11
3091	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:36:21.523	11
3094	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:37:13.979	11
3149	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 09:46:49.826	11
3194	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 09:26:42.764	11
3195	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 09:26:43.101	11
3234	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:16:20.962	11
3235	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:16:39.288	11
3267	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:49:52.377	11
3269	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:51:12.413	11
3270	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:51:21.974	11
3305	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:47:10.61	11
3306	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 22:47:10.721	11
3330	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 13:34:00.632	11
3332	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 13:37:39.036	11
3351	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:51:28.105	11
3353	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 14:53:37.66	11
3376	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 17:23:11.532	11
3377	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 17:25:04.142	11
3392	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:23:37.794	11
3393	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-27 13:24:38.286	11
3405	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:18:53.914	11
3418	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:05:47.61	11
3441	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:27:42.538	11
3444	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:30:11.888	11
3445	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:01.029	11
3447	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:27.615	11
3448	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:33.498	11
3449	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:37.791	11
3450	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:32:42.121	11
3452	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:33:25.768	11
3453	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:33:29.753	11
3457	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:34:37.619	11
3458	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 13:35:36.868	11
3489	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 21:34:45.861	11
3503	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 16:03:18.454	30
3506	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 16:03:25.722	11
3521	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 15:16:19.953	11
3553	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 17:31:00.414	11
3567	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:04:37.098	11
3568	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-31 22:04:54.831	11
3575	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:30:13.64	11
3581	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:57:17.485	11
3584	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:58:31.32	11
3585	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:58:56.671	11
3586	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 15:59:04.657	11
3599	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:36:04.061	11
3600	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 16:37:16.377	11
3604	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:01:44.381	11
3605	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:01:59.761	11
3606	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:01:59.762	11
3607	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:02:07.632	11
3608	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-01 17:02:07.687	11
3612	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:15:02.53	11
3624	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:10.112	11
3625	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:28.944	11
3629	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:26:42.01	11
3630	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:27:15.978	11
3633	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:27:26.936	11
3636	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:28:39.397	11
3637	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:28:39.446	11
3638	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:28:59.398	11
2284	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:00:09.044	11
2285	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:00:27.189	11
2286	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:00:27.538	11
2287	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:00:27.689	11
2288	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:18:35.257	11
2289	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:18:37.498	11
2290	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:18:38.98	11
2291	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:18:41.792	11
2292	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:18:45.072	11
2293	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:19:04.355	11
2294	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:19:23.621	11
2295	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:19:23.972	11
2296	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:19:24.097	11
2297	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:20:09.462	11
2298	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:20:11.311	11
2299	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:20:12.868	11
2300	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:20:15.201	11
2301	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:20:19.155	11
2302	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-25 19:20:28.198	11
2303	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:52:57.272	11
2304	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:53:04.572	11
2305	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:53:15.053	11
2306	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:53:15.502	11
2307	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:53:15.586	11
2308	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:53:30.51	11
2309	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:55:03.241	11
2310	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:57:08.322	11
2311	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:59:09.197	11
2312	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:59:12.488	11
2313	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:59:12.865	11
2314	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 10:59:12.969	11
2315	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:07:32.005	11
2316	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:08:37.984	11
2317	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:08:39.287	11
2318	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:08:42.392	11
2319	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:08:42.453	11
2320	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:09:15.555	11
2321	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:16:47.897	11
2322	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:16:49.776	11
2323	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:16:49.832	11
2324	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:03.865	11
2325	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:06.472	11
2326	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:06.9	11
2327	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:06.979	11
2328	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:31.721	11
2329	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:32.139	11
2330	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:20:32.276	11
2331	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:23:55.3	11
2332	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:23:55.702	11
2333	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:23:55.771	11
2334	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:25:54.791	11
2335	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:25:55.212	11
2336	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:25:55.319	11
2337	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:26:53.039	11
2338	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:26:53.647	11
2339	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:26:53.73	11
2340	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:27:24.12	11
2341	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:27:24.454	11
2342	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:27:24.529	11
2343	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:28:44.048	11
2344	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:28:44.544	11
2345	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:28:44.65	11
2346	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:31:42.921	11
2347	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:31:44.199	11
2348	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:31:48.568	11
2349	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:32:26.772	11
2350	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:32:27.754	11
2351	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:32:30.466	11
2352	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 11:32:30.791	11
2353	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:41:25.536	11
2354	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:41:33.805	11
2355	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:41:38.46	11
2356	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:41:39.262	11
2357	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:41:39.912	11
2358	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:50:22.806	11
2359	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:50:23.104	11
2360	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:50:23.181	11
2361	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:50:49.316	11
2362	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 13:50:55.107	11
2363	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:04:20.479	11
2364	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:04:24.197	11
2365	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:35:06.511	11
2366	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:35:07.175	11
2367	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:35:10.8	11
2368	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:35:10.914	11
2369	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:37:16.128	11
2370	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:37:16.401	11
2371	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:37:16.598	11
2372	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:37:44.225	11
2373	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:37:44.822	11
2374	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:37:45.183	11
2375	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:39:55.699	11
2376	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:39:56.86	11
2377	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:39:56.969	11
2378	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:41:53.659	11
2379	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:41:54.411	11
2380	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:41:54.474	11
2381	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:43:30.511	11
2382	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:43:31.208	11
2386	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:44:02.145	11
2387	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:45:29.218	11
2389	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:45:30.164	11
2390	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:46:23.28	11
2391	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:46:24.196	11
2395	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:46:37.53	11
2487	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:19:39.959	11
2555	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:24.296	11
2556	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:24.344	11
2557	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:37.844	11
2558	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:35:38.398	11
2561	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:39:35.469	11
2563	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 12:39:35.891	11
2600	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 20:35:52.449	11
2601	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 20:35:54.279	11
2602	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 20:36:12.097	11
2603	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 20:39:21.934	11
2604	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 20:39:22.453	11
2633	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:40:38.671	11
2670	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:50:28.683	11
2671	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:50:29.074	11
2672	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:50:29.197	11
2673	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:55:18.795	11
2675	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 15:55:19.509	11
2703	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:41:50.379	11
2704	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:41:50.435	11
2727	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:51:06.065	11
2728	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:51:46.344	11
2731	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:52:07.774	11
2754	::1	VIEW_USER_INFO	2022-07-31 11:52:48.333	11
2829	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:06:32.154	11
2834	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:11:47.02	11
2844	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:46.876	11
2845	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:17:47.383	11
2848	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:18:38.838	11
2855	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:19:32.42	11
2856	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:21:05.179	11
2857	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:21:05.775	11
2927	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:26:01.221	11
2953	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:47:59.191	11
2954	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:48:26.087	11
2955	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:48:26.511	11
2957	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:49:46.257	11
2983	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 13:25:36.76	11
2984	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 13:25:40.134	11
3004	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:55:04.148	11
3005	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:55:04.302	11
3006	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:55:04.415	11
3025	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 13:55:33.388	11
3026	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 13:55:33.946	11
3028	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 13:56:28.212	11
3029	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 13:56:28.54	11
3056	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 16:09:56.679	11
3088	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:34:16.826	11
3089	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:34:16.94	11
3092	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:36:21.675	11
3093	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:36:21.824	11
3095	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:37:14.374	11
3096	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:37:14.533	11
3150	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:00:26.449	11
3152	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:00:26.847	11
3159	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:08:35.22	11
3160	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:08:35.528	11
3161	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:08:35.769	11
3197	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:36:48.611	11
3198	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:36:48.936	11
3209	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:41:01.794	11
3210	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:42:23.066	11
3211	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:42:23.406	11
3236	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 19:17:57.442	11
3268	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:50:09.151	11
3271	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-25 14:52:05.454	11
3308	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:51:17.173	11
3313	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:57:37.533	11
3314	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:57:37.645	11
3317	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 09:57:53.677	11
3331	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 13:37:21.327	11
3357	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 15:04:17.998	11
3378	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 17:38:29.689	11
3379	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 17:38:30.779	11
3380	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-26 17:38:38.136	11
3394	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 07:50:50.884	11
3406	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 08:24:46.287	11
3419	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:24:14.337	11
3420	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:24:23.52	11
3421	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 10:25:27.865	11
3459	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:00:44.92	11
3460	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:02:16.309	11
3463	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 14:02:40.401	11
3490	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 21:54:18.129	11
3491	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-28 21:54:48.359	11
3504	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 16:03:19.34	30
3505	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-29 16:03:25.671	11
3522	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:56:58.19	11
3523	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-30 17:56:59.309	11
2383	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:43:31.349	11
2384	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:44:01.236	11
2385	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:44:01.755	11
2388	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:45:29.819	11
2392	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:46:24.357	11
2393	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:46:36.506	11
2394	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:46:37.346	11
2396	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:53:10.716	11
2397	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:53:11.598	11
2398	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:53:11.756	11
2399	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:55:19.822	11
2400	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:55:20.665	11
2401	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:55:20.946	11
2402	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:55:38.205	11
2403	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:55:38.966	11
2404	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:55:39.127	11
2405	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:58:55.027	11
2406	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:58:55.623	11
2407	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:58:55.966	11
2408	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:59:14.725	11
2409	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:59:15.269	11
2410	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 16:59:15.512	11
2411	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:01:05.057	11
2412	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:01:05.807	11
2413	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:01:06.123	11
2414	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:01:32.249	11
2415	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:01:32.939	11
2416	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:01:33.191	11
2417	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:05:50.315	11
2418	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:05:51.234	11
2419	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:05:51.65	11
2420	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:06:55.872	11
2421	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:06:56.506	11
2422	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:06:56.879	11
2423	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:08:07.432	11
2424	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:08:07.954	11
2425	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:08:08.442	11
2426	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:08:51.617	11
2427	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:08:52.452	11
2428	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:08:52.864	11
2429	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:11:27.801	11
2430	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:11:28.536	11
2431	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:11:29.101	11
2432	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:13:04.385	11
2433	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:13:05.216	11
2434	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:13:05.489	11
2435	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:18:16.64	11
2436	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:18:17.744	11
2437	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:18:17.887	11
2438	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:20:27.642	11
2439	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:20:28.574	11
2440	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 17:20:28.703	11
2488	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:19:40.073	11
2489	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-26 21:26:18.546	11
2564	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 13:33:30.02	11
2565	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 13:33:30.482	11
2605	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-27 20:39:22.675	11
2634	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 13:40:47.022	11
2676	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-29 21:46:17.517	11
2705	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 18:42:51.062	11
2732	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:52:08.312	11
2733	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-30 19:52:08.388	11
2755	::1	VIEW_USER_INFO	2022-07-31 11:54:08.459	11
2756	::1	VIEW_USER_INFO	2022-07-31 11:54:46.185	11
2757	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:57:31.787	11
2758	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:57:41.8	11
2759	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:57:43.483	11
2760	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:57:43.535	11
2761	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:57:49.893	11
2762	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:57:54.094	11
2763	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 11:58:00.412	11
2832	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:11:24.32	11
2833	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:11:45.056	11
2835	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:11:47.09	11
2836	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:16:22.016	11
2837	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 13:16:23.463	11
2928	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:26:09.261	11
2929	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:26:09.333	11
2930	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 21:26:09.39	11
2958	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 11:49:59.497	11
2985	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 14:10:21.602	11
3007	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-01 19:56:10.597	11
3027	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 13:55:34.056	11
3057	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 22:30:55.356	11
3058	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 22:33:37.487	11
3059	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 22:33:37.569	11
3061	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-04 22:35:51.02	11
3097	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:42:57.88	11
3101	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-05 09:45:29.811	11
3151	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:00:26.658	11
3156	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:05:07.558	11
3157	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:05:07.982	11
3158	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:05:08.065	11
3163	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-11 10:12:04.025	11
3199	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:36:49.093	11
3203	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:40:21.299	11
3204	::ffff:127.0.0.1	VIEW_USER_INFO	2022-08-13 13:40:22.275	11
3639	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:28:59.473	11
3640	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:16.671	11
3641	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:16.675	11
3642	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:40.473	11
3643	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:40.474	11
3644	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:40.57	11
3645	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:53.72	11
3646	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:29:53.764	11
3648	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:11.465	11
3649	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:26.594	11
3650	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:26.641	11
3651	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:42.692	11
3652	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:42.702	11
3656	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:33:02.271	11
3657	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:33:18.661	11
3662	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:34:49.424	11
3663	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:35:10.421	11
3664	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:35:10.433	11
3647	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:11.445	11
3653	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:53.115	11
3654	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:32:53.131	11
3655	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:33:02.237	11
3658	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:33:18.69	11
3659	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:33:47.717	11
3660	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:33:47.755	11
3661	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:34:49.422	11
3665	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:36:46.066	11
3666	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:36:46.099	11
3667	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:37:58.494	11
3668	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:37:58.523	11
3669	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:38:08.049	11
3670	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:38:20.986	11
3671	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:38:50.007	11
3672	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:38:50.034	11
3673	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:39:18.951	11
3674	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:39:18.999	11
3675	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:43:23.855	11
3676	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:43:23.887	11
3677	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:44:11.938	11
3678	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:45:45.583	11
3679	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:51:21.132	11
3680	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:54:49.703	11
3681	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:55:15.479	11
3682	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:55:17.664	11
3683	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 09:55:17.756	11
3684	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:36:10.683	11
3685	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:36:15.796	11
3686	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:37:24.576	11
3687	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:37:45.619	11
3688	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:38:16.185	11
3689	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:38:30.563	11
3690	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:39:28.379	11
3691	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 12:51:17.955	11
3692	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 13:03:43.212	11
3693	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 13:29:56.427	11
3694	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 13:43:03.553	11
3695	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 13:43:04.237	11
3696	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 13:43:04.307	11
3697	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-02 13:51:47.711	11
3698	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 09:55:21.196	11
3699	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 09:56:15.127	11
3700	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 09:56:24.262	11
3701	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 09:56:40.242	11
3702	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 10:12:51.628	11
3703	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 10:12:51.676	11
3704	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:34:31.057	11
3705	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:34:31.1	11
2891	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:26:52.312	\N
2892	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:26:53.777	\N
2893	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:27:49.881	\N
2894	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:29:51.534	\N
2895	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:29:54.223	\N
2896	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:30:13.431	\N
2897	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:30:13.514	\N
2898	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:30:32.045	\N
2899	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:30:34.936	\N
2900	::ffff:127.0.0.1	VIEW_USER_INFO	2022-07-31 19:30:52.772	\N
3706	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:36:13.547	31
3707	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:36:14.361	31
3708	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:36:50.827	31
3709	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:36:50.876	31
3710	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:37:02.285	31
3711	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 11:37:02.311	31
3712	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:05:44.255	31
3713	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:05:49.43	31
3714	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:06:56.245	31
3715	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:19:58.006	31
3716	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:19:59.989	31
3717	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:28:15.789	31
3718	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 13:34:36.588	31
3719	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:21:52.359	11
3720	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:21:53.281	11
3721	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:21:57.598	11
3722	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:22:00.897	11
3723	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:22:03.525	11
3724	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:22:04.344	11
3725	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:24:48.16	31
3726	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:24:48.211	31
3727	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:24:56.533	31
3728	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:24:56.593	31
3729	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 14:26:31.446	31
3730	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 19:09:41.826	31
3731	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 19:10:53.584	31
3732	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 19:26:29.895	31
3733	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-04 19:30:44.556	31
3734	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 09:59:58.42	31
3735	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 09:59:59.651	31
3736	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 18:22:23.339	31
3737	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 18:23:01.319	31
3738	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 18:27:45.761	31
3739	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 18:50:28.997	31
3740	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-05 19:50:59.693	31
3741	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 10:09:24.081	31
3742	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 10:09:25.982	31
3743	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 10:28:02.9	31
3744	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 10:38:20.486	31
3745	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 12:09:42.715	31
3746	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 12:18:58.603	31
3747	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 12:20:07.538	31
3748	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 13:26:26.852	31
3749	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 14:07:59.781	31
3750	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 14:11:08.194	31
3751	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 14:11:15.194	31
3752	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 14:20:59.208	31
3753	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 14:26:39.262	31
3754	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 18:52:08.129	31
3755	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:01:25.947	31
3756	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:04:09.981	31
3757	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:04:13.479	31
3758	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:04:30.529	31
3759	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:06:20.034	31
3760	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:09:00.632	31
3761	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:47:03.845	31
3762	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:47:54.272	31
3763	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:48:47.798	31
3764	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 19:48:51.962	31
3765	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:20:01.49	31
3766	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:21:30.341	31
3767	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:22:52.817	31
3768	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:27:01.159	31
3769	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:27:47.738	31
3770	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:27:51.218	31
3771	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 20:31:21.99	31
3772	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 21:30:00.016	31
3773	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-06 21:31:55.423	31
3774	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 09:55:26.446	31
3775	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 09:55:27.676	31
3776	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 10:58:21.507	31
3777	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:26:12.912	11
3778	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:26:13.959	11
3779	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:26:19.842	11
3780	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:26:20.728	11
3781	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:26:28.913	31
3782	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:26:29.13	31
3783	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:27:42.09	31
3784	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:27:53.142	31
3785	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:29:47.423	31
3786	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:32:29.509	11
3787	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:40:10.647	31
3788	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 12:40:16.02	31
3789	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 17:27:52.773	31
3790	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 19:40:47.764	31
3791	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 19:40:48.457	31
3792	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 19:42:07.767	31
3793	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-07 20:05:18.19	31
3794	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 15:38:44.929	31
3795	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 15:38:49.255	31
3796	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 15:52:46.171	31
3797	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:25:34.336	31
3798	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:26:31.91	31
3799	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:27:45.184	31
3800	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:28:18.065	31
3801	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:30:58.206	31
3802	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:31:30.301	31
3803	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:37:20.77	31
3804	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 17:51:06.195	31
3805	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:02:19.069	31
3806	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:07:41.122	31
3807	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:28:26.44	31
3808	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:31:11.718	31
3809	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:31:33.131	31
3810	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:40:49.906	31
3811	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:40:56.862	31
3812	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:41:10.211	31
3813	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:41:50.006	31
3814	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:46:24.907	31
3815	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:47:23.889	31
3816	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:50:15.344	31
3817	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:50:59.508	31
3818	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:51:43.969	31
3819	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:52:08.764	31
3820	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 18:59:43.02	31
3821	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 19:00:27.855	31
3822	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 19:21:24.003	31
3823	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 19:22:32.933	31
3824	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 19:35:26.132	31
3825	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 20:33:38.455	31
3826	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-08 20:34:31.734	31
3827	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 12:05:34.288	31
3828	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 12:28:48.814	31
3829	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 13:34:23.573	31
3830	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 14:08:49.083	31
3831	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 14:09:01.297	31
3832	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 14:09:07.854	31
3833	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 14:09:48.303	31
3834	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 14:09:51.462	31
3835	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 16:42:27.847	31
3836	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 16:42:29.919	31
3837	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 16:44:06.938	31
3838	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 16:57:46.675	31
3839	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:10:07.757	31
3840	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:16:38.615	31
3841	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:16:43.153	31
3842	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:17:48.581	31
3843	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:17:54.97	31
3844	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:18:30.578	31
3845	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:18:36.031	31
3846	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:21:44.061	31
3847	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 18:23:50.888	31
3848	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:16:50.404	31
3849	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:16:56.579	31
3850	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:17:12.106	31
3851	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:19:39.71	31
3852	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:19:39.742	31
3853	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:20:25.637	31
3854	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 19:28:34.612	31
3855	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 20:03:00.1	11
3856	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 20:03:01.181	11
3857	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 20:06:15.175	11
3858	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 20:06:17.575	11
3859	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 20:13:48.155	11
3860	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 21:36:54.459	31
3861	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 21:39:25.463	31
3862	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 22:05:29.593	11
3863	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-09 22:05:55.512	31
3864	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:01:15.578	31
3865	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:01:17.832	31
3866	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:15:19.962	31
3867	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:21:42.033	31
3868	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:44:28.018	31
3869	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:44:36.133	11
3870	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:44:47.092	11
3871	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:46:09.101	11
3872	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:47:47.533	32
3873	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:48:16.783	32
3874	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:48:58.164	32
3875	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:49:02.765	32
3876	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:49:43.785	32
3877	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 11:50:06.854	31
3878	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:05:13.879	31
3879	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:06:23.185	31
3880	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:41:45.119	11
3881	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:41:46.724	11
3882	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:42:12.125	32
3883	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:42:26.771	31
3884	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 13:49:49.915	31
3885	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 17:18:06.107	31
3886	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 17:31:54.24	31
3887	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 19:37:10.306	11
3888	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 19:37:11.141	11
3889	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 21:57:30.784	31
3890	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 21:58:11.334	31
3891	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:01:12.773	31
3892	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:01:51.227	31
3893	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:09:46.295	31
3894	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:09:49.164	11
3895	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:10:34.541	11
3896	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:11:16.793	11
3897	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:11:45.842	31
3898	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:12:44.142	31
3899	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:13:58.078	11
3900	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:13:58.991	11
3901	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-10 22:19:11.985	31
3902	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:20:18.179	31
3903	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:20:20.455	31
3904	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:21:27.97	31
3905	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:22:38.53	31
3906	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:23:51.75	31
3907	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:26:26.874	31
3908	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:29:16.848	31
3909	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:33:25.634	31
3910	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:54:24.439	31
3911	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 10:54:41.318	31
3912	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 11:21:41.094	31
3913	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 12:02:23.493	11
3914	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 12:02:39.835	32
3915	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 12:04:55.145	32
3916	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 12:15:12.533	32
3917	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 12:15:22.821	31
3918	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 12:18:07.958	31
3919	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 16:36:17.014	31
3920	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 16:36:55.85	11
3921	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 16:37:15.858	11
3922	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 16:38:19.852	11
3923	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 16:38:32.979	31
3924	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 17:03:46.271	31
3925	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 17:47:17.164	31
3926	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 18:15:48.06	31
3927	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 18:18:56.891	31
3928	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 18:21:29.969	31
3929	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 18:22:14.363	31
3930	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 18:29:24.413	31
3931	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 19:29:01.356	31
3932	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 19:45:29.281	31
3933	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 19:45:34.164	31
3934	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 19:47:23.309	31
3935	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 19:48:01.148	31
3936	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 19:48:51.399	31
3937	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 21:01:09.155	31
3938	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 21:01:20.825	31
3939	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-11 21:47:56.191	31
3940	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 10:39:24.566	31
3941	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 10:39:27.061	31
3942	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 10:44:50.627	31
3943	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:39:35.405	31
3944	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:41:16.642	31
3945	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:42:40.528	31
3946	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:48:06.49	31
3947	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:53:08.062	31
3948	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:55:43.16	31
3949	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:55:44.362	31
3950	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 13:58:51.809	31
3951	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 15:46:55.431	31
3952	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 16:13:22.611	31
3953	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 16:13:55.754	31
3954	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 16:26:20.217	31
3955	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 16:26:46.184	31
3956	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 17:28:11.395	31
3957	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 17:50:27.32	31
3958	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 17:53:42.194	31
3959	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:03:26.814	31
3960	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:36:09.65	31
3961	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:38:05.976	31
3962	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:39:14.735	31
3963	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:39:17.464	31
3964	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:41:20.847	31
3965	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:50:28.025	31
3966	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:57:22.606	31
3967	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 18:57:43.68	31
3968	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:17:29.025	31
3969	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:17:31.465	31
3970	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:17:52.723	31
3971	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:18:06.329	11
3972	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:18:06.332	11
3973	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:35:07.514	11
3974	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:35:13.432	11
3975	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:35:18.413	11
3976	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:35:25.993	31
3977	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:35:26.035	31
3978	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:36:19.389	31
3979	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:37:06.912	31
3980	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:37:07.057	31
3981	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:38:46.536	31
3982	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:39:41.798	31
3983	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:40:57.119	31
3984	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:40:57.98	31
3985	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:54:42.706	31
3986	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:54:45.802	31
3987	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:55:46.436	31
3988	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:03.572	31
3989	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:06.016	31
3990	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:12.237	31
3991	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:15.934	31
3992	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:44.387	31
3993	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:46.118	31
3994	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:56:55.368	31
3995	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:57:12.064	31
3996	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:57:15.684	31
3997	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:57:17.238	31
3998	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 19:57:18.599	31
3999	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:19:30.248	31
4000	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:23:23.541	31
4001	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:23:25.045	31
4002	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:23:28.997	31
4003	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:23:31.039	31
4004	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:23:33.974	31
4005	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:24:22.092	31
4006	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:24:23.346	31
4007	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:24:42.208	31
4008	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:24:43.718	31
4009	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:24:58.389	31
4010	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:07.575	31
4011	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:09.61	31
4012	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:11.455	31
4013	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:14.391	31
4014	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:20.881	31
4015	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:20.91	31
4016	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:56.105	31
4017	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:57.827	31
4018	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:27:59.07	31
4019	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:28:00.559	31
4020	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:35:45.422	31
4021	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:35:46.44	31
4022	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:37:18.568	31
4023	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:37:20.068	31
4024	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:37:21.864	31
4025	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:37:55.91	31
4026	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:37:56.83	31
4027	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:37:57.965	31
4028	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:38:03.354	31
4029	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:38:05.771	31
4030	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:38:07.177	31
4031	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:38:08.452	31
4032	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:38:49.118	31
4033	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:40:05.972	31
4034	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:40:12.207	31
4035	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:40:33.798	31
4036	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:46:09.59	31
4037	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:46:12.55	31
4038	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:46:19.75	31
4039	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:46:42.982	31
4040	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:47:06.441	31
4041	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:47:07.731	31
4042	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:47:09.363	31
4043	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:47:10.912	31
4044	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:47:15.054	31
4045	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:47:26.442	31
4046	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:49:36.335	31
4047	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:49:37.495	31
4048	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:54:56.724	31
4049	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:55:03.26	31
4050	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 20:55:29.686	31
4051	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:00:23.031	31
4052	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:00:37.195	11
4053	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:00:37.318	11
4054	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:07:36.869	11
4055	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:07:36.914	11
4056	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:07:55.541	11
4057	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:07:55.731	11
4058	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:13.204	11
4059	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:13.411	11
4060	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:17.416	11
4061	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:17.546	11
4062	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:25.903	31
4063	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:25.947	31
4064	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:08:41.278	31
4065	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:17:18.664	31
4066	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:17:49.602	31
4067	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:17:51.076	31
4068	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-12 21:17:52.362	31
4069	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 11:43:45.582	31
4070	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 11:43:50.699	31
4071	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 11:44:19.001	31
4072	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 11:45:44.993	31
4073	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 12:56:10.133	31
4074	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 13:46:01.086	31
4075	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 13:48:14.894	31
4076	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 13:50:16.017	31
4077	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 13:55:07.095	31
4078	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 13:55:09.847	31
4079	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:01:27.362	31
4080	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:01:39.689	31
4081	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:04:18.676	31
4082	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:04:31.781	31
4083	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:05:17.938	31
4084	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:06:09.528	31
4085	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:07:05.486	31
4086	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:32:15.68	31
4087	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:34:42.163	31
4088	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:43:14.351	31
4089	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:51:03.755	31
4090	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:51:40.93	31
4091	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:52:22.241	31
4092	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:53:59.425	31
4093	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:54:12.539	31
4094	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:54:26.834	31
4095	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 18:59:04.912	31
4096	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 19:01:43.304	31
4097	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-13 19:05:50.087	31
4098	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-14 16:17:02.159	31
4099	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-14 16:17:08.214	31
4100	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-14 16:25:10.912	31
4101	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-14 16:25:14.251	31
4102	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:05:33.724	11
4103	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:05:40.024	11
4104	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:06:15.896	11
4105	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:11:47.218	11
4106	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:12:03.393	11
4107	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:12:37.251	11
4108	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:13:04.749	11
4109	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:14:08.51	11
4110	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:19:13.534	11
4111	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:19:56.207	11
4112	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:20:16.515	11
4113	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:20:56.656	11
4114	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:24:00.18	11
4115	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:24:00.244	11
4116	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:24:12.555	31
4117	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 18:26:16.112	31
4118	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 22:51:05.393	31
4119	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-17 22:51:05.591	31
4120	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 10:51:21.753	31
4121	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 10:58:40.096	31
4122	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 10:58:44.471	31
4123	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 10:59:00.636	11
4124	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 10:59:25.477	11
4125	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:00:07.463	11
4126	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:00:15.18	11
4127	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:01:48.939	11
4128	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:04:18.253	11
4129	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:04:37.053	11
4130	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:04:45.83	11
4131	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:05:02.791	31
4132	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:05:02.883	31
4133	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:12:11.005	31
4134	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:12:20.898	31
4135	::ffff:127.0.0.1	VIEW_USER_INFO	2022-09-18 11:13:01.366	31
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, price_total, shipping_cost, datetime, archive, status, user_id, vat_total, phone_number, reference, receipt_number, type, delivered) FROM stdin;
pi_3Lgbt3ILFxyKM1ma1cZY6RF8	70.02	0	2022-09-10 22:10:53.296	{"shipping_address":{"city":"London","first_address":"1 Yeo Street","postcode":"E3 3AE","second_address":"Caspian Wharf 40","notes":null},"billing_address":{"country":"Italy","city":"Campi Bisenzio","first_address":"Via Guido Mammoli","postcode":"50013","second_address":null,"notes":null},"items":[{"item_id":16,"name":"LupuT8","amount":1,"amount_available":31,"price_per_unit":3.71,"price_unit":"LT","price_total":3.71,"photo_loc":"/condimentum/curabitur.json","vat":20},{"item_id":20,"name":"bN9A7XO3Jkol","amount":1,"amount_available":36,"price_per_unit":18.15,"price_unit":"unit","price_total":18.15,"photo_loc":"/ut/tellus.jpg","vat":5},{"item_id":22,"name":"nhCgXM","amount":1,"amount_available":20,"price_per_unit":19.34,"price_unit":"KG","price_total":19.34,"photo_loc":"/risus.xml","vat":5},{"item_id":75,"name":"Qt2JzeR","amount":3,"amount_available":25,"price_per_unit":2.98,"price_unit":"unit","price_total":8.94,"photo_loc":"/orci/luctus/et/ultrices/posuere/cubilia/curae.json","vat":20},{"item_id":77,"name":"XuI1DRXw1OU","amount":1,"amount_available":20,"price_per_unit":19.88,"price_unit":"KG","price_total":19.88,"photo_loc":"/sapien/urna/pretium.aspx","vat":20}]}	REFUNDED	11	8.38	+44 7723 093701	03d90474-3211-4936-931d-4e8c49e5aae3	1	STRIPE	t
pi_3Lgp3jILFxyKM1ma13xWJsSJ	49.44	0	2022-09-11 12:14:47.682	{"shipping_address":{"city":"London","first_address":"Zopley Street","postcode":"E16 1YG","second_address":"Discovery Tower 24","notes":null},"billing_address":{"country":"United Kingdom","city":"London","first_address":"Zopley Street","postcode":"E16 1YG","second_address":"Discovery Tower 24","notes":null},"items":[{"item_id":30,"name":"PFthAqQ","amount":1,"amount_available":27,"price_per_unit":19,"price_unit":"unit","price_total":19,"photo_loc":"/praesent.png","vat":0},{"item_id":44,"name":"gT2623mTZ2Sy","amount":2,"amount_available":36,"price_per_unit":15.22,"price_unit":"KG","price_total":30.44,"photo_loc":"/vestibulum.png","vat":20}]}	REFUNDED	32	6.09	+44 7823 692258	644e8d85-20f9-44ac-b2c1-85dc41bbaf44	2	STRIPE	t
pi_3LgtA9ILFxyKM1ma1qtKgYKA	46.47	0	2022-09-11 16:37:41.353	{"shipping_address":{"city":"London","first_address":"1 Yeo Street","postcode":"E3 3AE","second_address":"Caspian Wharf 40","notes":null},"billing_address":{"country":"United Kingdom","city":"London","first_address":"1 Yeo Street","postcode":"E3 3AE","second_address":"Caspian Wharf 40","notes":null},"items":[{"item_id":13,"name":"MDAFOZvCp","amount":1,"amount_available":19,"price_per_unit":11.3,"price_unit":"KG","price_total":11.3,"photo_loc":"/vel/sem.jpg","vat":0},{"item_id":36,"name":"rolwnU","amount":1,"amount_available":17,"price_per_unit":7.88,"price_unit":"unit","price_total":7.88,"photo_loc":"/curabitur/gravida/nisi/at.xml","vat":20},{"item_id":58,"name":"V2R07QhrB","amount":1,"amount_available":25,"price_per_unit":12.22,"price_unit":"unit","price_total":12.22,"photo_loc":"/amet/cursus/id/turpis/integer/aliquet/massa.jpg","vat":5},{"item_id":82,"name":"alRvuSkv73","amount":1,"amount_available":22,"price_per_unit":15.07,"price_unit":"KG","price_total":15.07,"photo_loc":"/nisi/vulputate/nonummy/maecenas/tincidunt/lacus/at.aspx","vat":20}]}	CANCELLED	11	5.2	+44 7425 986578	cfb5a9fe-2fcc-4e24-868b-7fa3751a0d9c	3	STRIPE	f
pi_3Lj5OkILFxyKM1ma1hcBUjNr	43.12	0	2022-09-17 18:05:50.822	{"shipping_address":{"city":"London","first_address":"1 Yeo Street","postcode":"E3 3AE","second_address":"Caspian Wharf 40","notes":null},"billing_address":{"country":"United Kingdom","city":"London","first_address":"1 Yeo Street","postcode":"E3 3AE","second_address":"Caspian Wharf 40","notes":null},"items":[{"item_id":101,"name":"this is a test","amount":2,"amount_available":15,"price_per_unit":8.82,"price_unit":"KG","price_total":17.64,"photo_loc":"/images/ragu_funghi_300x.webp","vat":5},{"item_id":13,"name":"MDAFOZvCp","amount":1,"amount_available":18,"price_per_unit":11.3,"price_unit":"KG","price_total":11.3,"photo_loc":"/images/ragu_funghi_300x.webp","vat":0},{"item_id":36,"name":"rolwnU","amount":1,"amount_available":16,"price_per_unit":7.88,"price_unit":"unit","price_total":7.88,"photo_loc":"/images/ragu_funghi_300x.webp","vat":20},{"item_id":75,"name":"TEST PRODUCT","amount":2,"amount_available":22,"price_per_unit":3.15,"price_unit":"unit","price_total":6.3,"photo_loc":"/images/ragu_funghi_300x.webp","vat":20}]}	CANCELLED	11	3.72	+44 7723 093701	07bd79b2-9371-4dd8-98a7-6b8c46944e47	5	STRIPE	f
pi_3Lj5crILFxyKM1ma1pxWIViP	43.12	0	2022-09-17 18:20:26.527	{"shipping_address":{"city":"London","first_address":"1 Yeo Street","postcode":"E3 3AE","second_address":"Caspian Wharf 40","notes":null},"billing_address":{"country":"Italy","city":"Campi Bisenzio","first_address":"Via Guido Mammoli","postcode":"50013","second_address":null,"notes":null},"items":[{"item_id":101,"name":"this is a test","amount":2,"amount_available":15,"price_per_unit":8.82,"price_unit":"KG","price_total":17.64,"photo_loc":"/images/ragu_funghi_300x.webp","vat":5},{"item_id":13,"name":"MDAFOZvCp","amount":1,"amount_available":18,"price_per_unit":11.3,"price_unit":"KG","price_total":11.3,"photo_loc":"/images/ragu_funghi_300x.webp","vat":0},{"item_id":36,"name":"rolwnU","amount":1,"amount_available":16,"price_per_unit":7.88,"price_unit":"unit","price_total":7.88,"photo_loc":"/images/ragu_funghi_300x.webp","vat":20},{"item_id":75,"name":"TEST PRODUCT","amount":2,"amount_available":22,"price_per_unit":3.15,"price_unit":"unit","price_total":6.3,"photo_loc":"/images/ragu_funghi_300x.webp","vat":20}]}	REFUNDED	11	3.72	+44 7458 986985	04ea2740-90cb-4f71-9ed5-bf0d89cb33e8	6	STRIPE	t
pi_3LjLExILFxyKM1ma1GjlDRt0	47.3	0	2022-09-18 11:00:48.424	{"shipping_address":{"city":"London","first_address":"Canter Way","postcode":"E1 8PS","second_address":"Neroli House 3","notes":null},"billing_address":{"country":"United Kingdom","city":"London","first_address":"Canter Way","postcode":"E1 8PS","second_address":"Neroli House 3","notes":null},"items":[{"item_id":40,"name":"PLxMZ7ac","amount":1,"amount_available":24,"price_per_unit":13.48,"price_unit":"LT","price_total":13.48,"photo_loc":"/images/ragu_funghi_300x.webp","vat":5},{"item_id":64,"name":"SDCpwP0lCCM","amount":1,"amount_available":25,"price_per_unit":15.45,"price_unit":"unit","price_total":15.45,"photo_loc":"/images/ragu_funghi_300x.webp","vat":0},{"item_id":87,"name":"VfFs3gyPIB","amount":1,"amount_available":40,"price_per_unit":18.37,"price_unit":"KG","price_total":18.37,"photo_loc":"/images/ragu_funghi_300x.webp","vat":20}]}	REQUIRES_PAYMENT	11	4.35	+44 7458 698523	c8a99c57-0184-4283-8222-82d54721026e	7	STRIPE	f
1HT87057RB174554A	47.3	0	2022-09-18 11:01:16.632	{"shipping_address":{"city":"London","first_address":"Canter Way","postcode":"E1 8PS","second_address":"Neroli House 3","notes":null},"billing_address":{"country":"United Kingdom","city":"London","first_address":"Canter Way","postcode":"E1 8PS","second_address":"Neroli House 3","notes":null},"items":[{"item_id":40,"name":"PLxMZ7ac","amount":1,"amount_available":24,"price_per_unit":13.48,"price_unit":"LT","price_total":13.48,"photo_loc":"/images/ragu_funghi_300x.webp","vat":5},{"item_id":64,"name":"SDCpwP0lCCM","amount":1,"amount_available":25,"price_per_unit":15.45,"price_unit":"unit","price_total":15.45,"photo_loc":"/images/ragu_funghi_300x.webp","vat":0},{"item_id":87,"name":"VfFs3gyPIB","amount":1,"amount_available":40,"price_per_unit":18.37,"price_unit":"KG","price_total":18.37,"photo_loc":"/images/ragu_funghi_300x.webp","vat":20}]}	REFUNDED	11	4.35	+44 7458 698523	f481d1df-53d4-48db-82fe-15ea6414727b	8	PAYPAL	t
\.


--
-- Data for Name: orders_delivery; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders_delivery (order_delivery_id, suggested, actual, reference, confirmed) FROM stdin;
1	Hi dear bartoli	2022-09-11 11:34:00+01	03d90474-3211-4936-931d-4e8c49e5aae3	\N
2	ciao bello	2022-09-11 10:17:00+01	644e8d85-20f9-44ac-b2c1-85dc41bbaf44	\N
3	tomorrow from 15 to 18	\N	cfb5a9fe-2fcc-4e24-868b-7fa3751a0d9c	\N
5	\N	\N	07bd79b2-9371-4dd8-98a7-6b8c46944e47	\N
6	\N	2022-09-17 19:24:00+01	04ea2740-90cb-4f71-9ed5-bf0d89cb33e8	tomorrow\n
7	tomorrow at 14:00	\N	c8a99c57-0184-4283-8222-82d54721026e	\N
8	tomorrow at 14:00	2022-09-18 12:05:00+01	f481d1df-53d4-48db-82fe-15ea6414727b	ok tomorrow at 14:00
\.


--
-- Data for Name: payment_intents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_intents (payment_intent_id, hash, expiry_datetime) FROM stdin;
37G75852VL4661727	fa397c2fee2a0f197bcdc7f1b7db9ae938dd0d21	2022-09-02 15:30:11.147+01
pi_3LgS7PILFxyKM1ma1MAaoD2u	d20c97be194a747ef4fc68a3d1ea296db9d2892c	2022-09-10 13:45:03.521+01
pi_3LjLExILFxyKM1ma1GjlDRt0	71014b12e2d3e23e466133015089c6d84ec588c0	2022-09-18 13:00:48.409+01
\.


--
-- Data for Name: payment_methods; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payment_methods (reference, type, account) FROM stdin;
03d90474-3211-4936-931d-4e8c49e5aae3	CARD	3220
644e8d85-20f9-44ac-b2c1-85dc41bbaf44	CARD	4242
04ea2740-90cb-4f71-9ed5-bf0d89cb33e8	CARD	4242
f481d1df-53d4-48db-82fe-15ea6414727b	PAYPAL	2CNRCRCTMEHA6
\.


--
-- Data for Name: recover_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recover_tokens (token_id, secret, user_id, status, expiry) FROM stdin;
71	5EQGJiEUGVNFxA925iZP4a7HzFidg5ZUmK74eLB7M6Fwa3gW8DzOv3HN9ij31Yci	11	PENDING	2022-09-17 20:23:39.894+01
13	VSPL9dElS4wX2BnvEyyuehaWFECFa52IRc5NNQ78zg4gucIkIGev03jgFbB8rTTn	12	PENDING	2022-07-11 11:17:05.765478+01
14	unTUSdOk055M6y1lbkiGtuIZKBBTtQi6B3Jew4CgLa6RTHpECAgak5dPay5p5NKN	13	AUTHORIZED	2022-07-11 11:17:05.765478+01
15	M53CRPjhfdx01V9kpEyf36Lkzvt4Cg8n8GvhA6MMCINe29YNFE9III00by847Umv	14	AUTHORIZED	2022-07-11 11:17:05.765478+01
16	JjdUPHQ2ESWs2xOaWsKoXSZNJPgF6GSaSSiDOTGSk5WQYfppERzAmi8VhLwS7TIp	15	AUTHORIZED	2022-07-11 11:17:05.765478+01
17	t6myhclwYL39pOCufL2R5hfBfhk0fdDtVt7QnGy1cUEYx21gpCAOL43PWKEjjxHZ	16	AUTHORIZED	2022-07-11 11:17:05.765478+01
18	nLBvnDBbeKZLdYg5pltfXdnXJVp7mr1O6wEE4cA3Eu3gfEQeE8KzYVl8sDZ5zril	17	AUTHORIZED	2022-07-11 11:17:05.765478+01
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (token_id, version, user_id, auth_level) FROM stdin;
78	4	11	standard
145	2	11	standard
21	1	5	standard
100	15	11	standard
20	7	5	standard
101	2	11	standard
102	2	11	standard
22	5	5	standard
79	10	11	standard
23	5	5	standard
24	2	5	standard
150	2	11	standard
103	3	26	standard
80	6	5	standard
25	7	5	standard
62	4	11	standard
34	4	11	standard
50	24	11	standard
51	1	11	standard
52	1	11	standard
53	1	11	standard
54	1	11	standard
1	1	5	standard
2	1	5	standard
3	1	5	standard
4	1	5	standard
5	1	5	standard
6	1	5	standard
7	1	5	standard
8	1	5	standard
9	1	5	standard
14	1	5	standard
15	2	5	standard
16	2	5	standard
17	6	5	standard
55	1	11	standard
63	3	11	standard
81	2	11	standard
82	2	5	standard
64	5	11	standard
56	8	11	standard
65	2	11	standard
26	25	5	standard
27	2	5	standard
28	3	5	standard
29	1	5	standard
83	3	5	standard
84	1	18	standard
66	6	11	standard
67	3	11	standard
57	13	11	standard
58	3	11	standard
85	2	19	standard
33	11	11	standard
161	4	11	standard
35	1	11	standard
59	4	11	standard
36	2	11	standard
86	3	5	standard
37	2	11	standard
38	2	11	standard
151	3	11	standard
39	2	11	standard
104	5	11	standard
40	2	11	standard
68	7	11	standard
41	2	11	standard
42	1	11	standard
43	1	11	standard
44	1	11	standard
45	2	11	standard
87	4	20	standard
61	1	11	standard
69	4	11	standard
46	6	11	standard
88	2	20	standard
89	3	11	standard
90	2	11	standard
70	8	11	standard
91	2	21	standard
71	4	11	standard
72	2	11	standard
73	2	11	standard
74	2	11	standard
75	2	11	standard
76	2	11	standard
92	2	21	standard
77	4	11	standard
157	4	11	standard
147	10	11	standard
93	5	22	standard
105	6	11	standard
94	5	23	standard
152	4	11	standard
95	4	24	standard
96	2	25	standard
97	2	11	standard
98	2	11	standard
203	22	11	standard
106	7	11	standard
107	2	11	standard
148	6	11	standard
108	4	5	standard
169	2	11	standard
162	4	11	standard
158	7	11	standard
109	35	11	standard
110	3	5	standard
143	2	5	standard
153	9	11	standard
163	2	11	standard
164	2	11	standard
159	5	11	standard
154	6	5	standard
144	8	11	standard
155	2	11	standard
149	18	11	standard
156	2	27	standard
165	2	11	standard
160	4	11	standard
166	2	11	standard
167	2	11	standard
168	2	11	standard
170	10	11	standard
174	2	11	standard
172	4	11	standard
171	4	11	standard
173	2	11	standard
175	2	11	standard
176	2	11	standard
177	3	11	standard
190	11	11	standard
191	81	11	standard
192	2	11	standard
193	129	11	standard
194	3	11	standard
195	5	11	standard
196	6	11	standard
197	5	11	standard
198	5	11	standard
199	148	11	standard
200	5	11	standard
201	2	11	standard
231	3	11	standard
232	2	11	standard
233	2	11	standard
207	16	11	standard
208	3	11	standard
209	2	11	standard
210	2	11	standard
211	2	11	standard
234	2	11	standard
212	3	11	standard
282	19	11	standard
298	2	11	standard
213	5	28	standard
246	6	11	standard
184	14	11	standard
214	4	29	standard
283	3	11	standard
236	3	11	standard
202	530	11	standard
215	6	11	standard
204	4	11	standard
205	3	11	standard
284	2	11	standard
285	2	11	standard
273	23	11	standard
216	6	11	standard
217	2	11	standard
218	3	11	standard
330	51	31	standard
299	3	11	standard
333	2	11	standard
327	11	31	standard
315	39	31	standard
316	3	31	standard
276	217	11	standard
271	173	11	standard
311	11	31	standard
269	2	11	standard
223	4	11	standard
259	1	11	standard
261	1	11	standard
206	201	11	standard
328	2	11	standard
317	3	11	standard
312	5	11	standard
287	10	11	standard
286	13	11	standard
288	2	11	standard
248	1	11	standard
249	1	11	standard
289	2	30	standard
313	2	31	standard
290	3	30	standard
250	6	11	standard
251	1	11	standard
252	1	11	standard
253	1	11	standard
300	20	11	standard
224	2	11	standard
225	2	11	standard
226	3	11	standard
329	2	32	standard
227	3	11	standard
228	2	11	standard
229	2	11	standard
230	3	11	standard
318	5	31	standard
305	20	11	standard
268	7	11	standard
306	2	11	standard
307	1	11	standard
308	1	11	standard
314	7	31	standard
280	79	11	standard
309	3	11	standard
301	15	11	standard
260	37	11	standard
263	1	11	standard
264	2	11	standard
258	106	11	standard
319	2	11	standard
302	5	11	standard
331	15	11	standard
320	4	31	standard
291	28	11	standard
342	100	31	standard
324	16	11	standard
321	4	11	standard
292	6	11	standard
293	2	11	standard
294	2	11	standard
295	3	11	standard
296	2	11	standard
297	3	11	standard
343	2	31	standard
277	149	11	standard
338	1	11	standard
323	111	31	standard
332	3	11	standard
322	7	31	standard
334	8	32	standard
325	7	11	standard
337	101	31	standard
310	84	11	standard
335	10	31	standard
326	10	32	standard
339	6	11	standard
346	12	31	standard
336	8	11	standard
340	82	31	standard
349	15	11	standard
347	3	31	standard
341	7	11	standard
344	18	11	standard
348	3	31	standard
345	2	11	standard
350	20	31	standard
\.


--
-- Data for Name: refunds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refunds (refund_id, archive, order_ref, notes, datetime) FROM stdin;
5	[{"item_id":44,"name":"gT2623mTZ2Sy","amount_refunded":1,"price_per_unit":15.22,"price_total":15.22,"taxes":0}]	644e8d85-20f9-44ac-b2c1-85dc41bbaf44	because yes	2022-09-11 18:48:06.621+01
6	[{"item_id":30,"name":"PFthAqQ","amount_refunded":1,"price_per_unit":19,"price_total":19,"taxes":0},{"item_id":44,"name":"gT2623mTZ2Sy","amount_refunded":1,"price_per_unit":15.22,"price_total":15.22,"taxes":0}]	644e8d85-20f9-44ac-b2c1-85dc41bbaf44	oh yes	2022-09-11 18:49:37.49+01
10	[{"item_id":75,"name":"Qt2JzeR","amount_refunded":3,"price_per_unit":2.98,"price_total":8.94,"taxes":0}]	03d90474-3211-4936-931d-4e8c49e5aae3	defected	2022-09-11 21:48:31.124+01
11	[{"item_id":16,"name":"LupuT8","amount_refunded":1,"price_per_unit":3.71,"price_total":3.71,"taxes":0}]	03d90474-3211-4936-931d-4e8c49e5aae3	oh noooo	2022-09-12 22:17:34.111+01
12	[{"item_id":20,"name":"bN9A7XO3Jkol","amount_refunded":1,"price_per_unit":18.15,"price_total":18.15,"taxes":0}]	03d90474-3211-4936-931d-4e8c49e5aae3	ciao	2022-09-14 17:21:07.577+01
13	[{"item_id":77,"name":"XuI1DRXw1OU","amount_refunded":1,"price_per_unit":19.88,"price_total":19.88,"taxes":0}]	03d90474-3211-4936-931d-4e8c49e5aae3	ciao	2022-09-14 17:21:22.731+01
14	[{"item_id":36,"name":"rolwnU","amount_refunded":1,"price_per_unit":7.88,"price_total":7.88,"taxes":0}]	04ea2740-90cb-4f71-9ed5-bf0d89cb33e8	because asked 	2022-09-17 19:24:45.816+01
15	[{"item_id":75,"name":"TEST PRODUCT","amount_refunded":1,"price_per_unit":3.15,"price_total":3.15,"taxes":0}]	04ea2740-90cb-4f71-9ed5-bf0d89cb33e8	sfsf	2022-09-17 19:26:23.114+01
16	[{"item_id":40,"name":"PLxMZ7ac","amount_refunded":1,"price_per_unit":13.48,"price_total":13.48,"taxes":0}]	f481d1df-53d4-48db-82fe-15ea6414727b	because yes	2022-09-18 12:06:40.371+01
17	[{"item_id":40,"name":"PLxMZ7ac","amount_refunded":0,"price_per_unit":13.48,"price_total":0,"taxes":0},{"item_id":64,"name":"SDCpwP0lCCM","amount_refunded":1,"price_per_unit":15.45,"price_total":15.45,"taxes":0},{"item_id":87,"name":"VfFs3gyPIB","amount_refunded":1,"price_per_unit":18.37,"price_total":18.37,"taxes":0}]	f481d1df-53d4-48db-82fe-15ea6414727b	oh yes i like it	2022-09-18 12:07:40.573+01
\.


--
-- Data for Name: shipping_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_addresses (address_id) FROM stdin;
17
32
37
\.


--
-- Data for Name: sub_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_categories (sub_category_id, name, notes, category_id) FROM stdin;
1	Intuitive executive protocol	Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum ru	5
3	Self-enabling didactic challenge	Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.	3
5	Devolved client-server open architecture	Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condi	4
6	Optional neutral focus group	Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Ae	5
7	Diverse actuating emulation	Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.	4
8	Reduced disintermediate framework	Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.	3
9	Grass-roots tangible orchestration	Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare impe	5
11	Enterprise-wide system-worthy extranet	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a od	5
12	Open-source stable help-desk	Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis 	4
13	Decentralized mission-critical leverage	Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam por	4
14	Re-contextualized zero defect methodology	Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.	5
4	Future-proofed radical capacity	Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.	2
17	Grass-roots executive framework	Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.	7
18	Secured multi-state paradigm	Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	3
22	Digitized solution-oriented neural-net	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.	5
23	Function-based asynchronous definition	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a od	8
25	Future-proofed content-based definition	Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	4
10	Digitized disintermediate customer loyalty	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.	2
15	Ergonomic eco-centric access	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Viv	2
26	test1	\N	1
16	Multi-tiered mobile leverage	Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2
19	User-friendly tangible interface	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.	2
24	Exclusive zero tolerance standardization	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien a	2
31	ahahahhah	\N	11
\.


--
-- Data for Name: sub_categories_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_categories_items (sub_category_id, item_id) FROM stdin;
23	2
18	3
17	3
14	4
22	4
11	4
18	4
7	4
13	5
14	5
9	5
22	5
18	5
25	6
3	6
23	6
23	7
4	8
12	8
25	8
1	8
24	9
11	10
24	11
6	11
15	11
4	11
15	12
19	12
7	12
23	12
13	12
7	13
8	13
4	13
23	13
16	14
12	14
23	14
10	14
13	15
3	15
4	16
15	16
19	16
10	17
16	17
24	18
12	18
14	18
13	18
14	19
18	19
11	19
13	20
16	20
10	20
18	20
18	21
12	21
3	21
3	22
17	22
8	22
6	23
24	24
9	25
19	25
17	25
4	25
23	26
7	26
5	26
14	26
18	26
14	27
23	27
13	27
1	28
24	29
10	29
10	30
16	30
7	30
9	30
1	31
4	31
24	32
25	33
4	33
3	33
24	33
11	33
25	34
19	34
5	34
13	34
24	36
12	36
17	36
10	37
17	37
15	38
9	39
6	39
25	39
7	39
1	40
9	41
4	41
12	42
19	42
10	42
24	42
4	43
19	43
24	43
11	43
9	44
1	44
5	44
8	44
25	45
12	46
1	46
17	46
3	47
23	47
10	47
1	48
11	48
6	48
3	48
23	48
11	49
7	50
14	50
8	51
13	51
12	51
5	51
8	52
3	52
4	52
25	52
10	52
19	53
10	53
12	53
17	53
9	54
18	54
1	54
7	55
17	56
18	56
19	56
9	56
3	56
10	57
14	57
22	58
4	58
14	58
10	59
25	59
19	59
13	59
24	60
3	60
4	60
8	61
18	61
9	61
13	62
16	62
7	62
8	62
16	63
19	63
16	64
19	64
24	64
9	64
12	64
6	65
5	65
3	65
18	65
6	66
24	67
6	67
19	67
7	67
17	68
1	68
12	69
25	69
10	70
1	70
3	70
11	70
18	70
25	71
19	71
11	71
1	71
17	71
22	72
3	72
19	72
4	74
13	74
17	75
6	75
22	76
5	76
6	76
19	77
8	77
13	77
25	78
11	78
17	78
1	78
8	79
24	79
9	79
23	79
18	79
22	80
11	80
12	80
16	80
16	81
7	81
4	81
1	82
7	82
12	82
17	82
17	83
3	83
14	83
24	84
8	85
9	85
14	85
3	86
15	86
25	87
22	87
19	87
8	87
6	88
18	88
9	89
24	90
4	90
23	90
15	91
3	91
13	91
25	92
18	92
23	92
11	93
22	93
14	93
5	94
10	95
5	95
23	96
1	96
22	96
11	97
8	97
12	97
13	98
18	98
16	98
11	99
18	100
5	1
6	1
15	101
16	101
4	101
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, surname, dob, email, password, role, email_to_verify, entry_date, stripe_customer_id) FROM stdin;
23	Ciao3	Bello3	2004-07-09	test14@gmail.com	$2b$10$Ja/Fdmd0BcQyttsOxJoWc.ONDR5456kRHtGRmTX3x8lNkkHJFOHLa	client	\N	2022-07-11 12:41:14.531+01	cus_M2PqLQYSh8Jftg
24	Ciao4	Bello4	2001-04-01	test15@gmail.com	$2b$10$rVolg3wqwxxDFKaGuAV8lOH9BtBU9NvVHwxp9RiXCmWtZzTxunhHG	client	\N	2022-07-11 13:39:40.157+01	cus_M2QlY9eYDVaMY2
25	Ciao6	Bello6	2000-01-01	test16@gmail.com	$2b$10$Qbz1qs6dGj5MEeFgEk/nGeNQXMKekP0TX1UlOyERelNpbMZ1aq/Uy	client	\N	2022-07-11 15:56:37.55+01	cus_M2SzdFdT9ZEYi2
26	Ciao7	Bello7	2004-07-05	test17@gmail.com	$2b$10$ya.aLu6nG0qv6t/nbWW1uu/Z2K7Ut7aGcwyGadfqPtloKEoFQoQQG	client	\N	2022-07-11 18:31:47.435+01	cus_M2VZCG9nQfbjDr
27	Test2	Testsurname2	2004-06-30	test18@gmail.com	$2b$10$1wyTph4gTNENjQIQgPxuAeWvg6W9knZdUcqy4XgTWOJC4NQFGIlhK	client	\N	2022-07-15 15:06:30.843+01	cus_M3x5Jbcx7WLVRR
5	Giovanni	Calome	2000-06-25	simone.bartoli01@gmail.com	$2b$10$lzjEO.7kh0Aw92ipxWDAOuS1neKCsNDF2qZhWWULsjECNBBSYppmC	client	\N	2022-07-01 12:28:16.8281+01	\N
1	Simone	Bartoli	2022-06-01	test@test.com	12345	client	\N	2022-07-01 12:28:16.8281+01	\N
2	Luca	Ostato	2022-06-01	test1@test.com	hello123	client	\N	2022-07-01 12:28:16.8281+01	\N
4	ssfsf	sf1	2000-06-25	test2@test.com	ssdsdf2323	client	\N	2022-07-01 12:28:16.8281+01	\N
11	Matteo	Ostati	1980-06-01	lucaostato@gmail.com	$2b$10$VAMe71cP3JxsqBZrVx2v6.v/DNxUW.Eieq0ycYfCKOsp24KiVOe8S	client	\N	2022-07-05 17:35:45.91+01	cus_M0FEqxTSKFhO7f
12	Myname	Mysurname	2004-07-07	\N	$2b$10$yHFrR9B5Nw0nypXR/5EWfexdNxfarxC5u9sXb/zPZXO5kuhBCHY66	client	test3@gmail.com	2022-07-10 21:11:11.187+01	\N
13	Ciao	Ciao	2004-07-07	\N	$2b$10$/A6uaUAHF52pBd0ZHFy5Gusjsjoa/yT.4.PNBSAWlLdVItPnq4kXS	client	test4@gmail.com	2022-07-10 21:20:11.546+01	\N
14	Ciao2	Ciao2	2004-07-01	\N	$2b$10$OsUau1vntGbOfapdar/73uYbGOx0GnHUgjjcSE5apkERZXbLBdS.K	client	test5@gmail.com	2022-07-10 21:24:29.519+01	\N
15	Matteo	Ostati	1980-06-01	\N	$2b$10$ek6oCaxV8ljqVXaE/ExE4OiVsOrhqi3o2qzTDt74Dtv1Ds4eHJEq.	client	test6@gmail.com	2022-07-10 21:31:40.835+01	\N
16	Matteo	Ostati	1980-06-01	\N	$2b$10$sFYwgqKTh6wb8I1pvNwhyee7sw8RgPKaF0xv9qfYLpUns4j6aXvwC	client	test7@gmail.com	2022-07-10 21:38:08.82+01	\N
17	Matteo	Ostati	1980-06-01	\N	$2b$10$oe4H.Yb6bQWVBQwy.3lYlOW4DBlRneHwXMtF3bzw3c89XFPi2jR/.	client	test8@gmail.com	2022-07-10 21:41:03.394+01	\N
18	Matteo	Ostati	1980-06-01	test9@gmail.com	$2b$10$4LL3DKhApmN9ADB.nK45a.azxb0CYsN4o1hEcpNkoyJzOYwLzfCIO	client	\N	2022-07-10 21:54:12.729+01	cus_M2BWMVpsfHz6ss
19	Matteo	Bello	2004-06-28	test10@gmail.com	$2b$10$dZkRqzi9Jj5kVHrsayGrAuPI/XljICHa78flaqwxjjQqECFEj1ibi	client	\N	2022-07-10 21:55:37.269+01	cus_M2BXVX82vVpNjW
20	Matteo	Bello	2004-07-07	test11@gmail.com	$2b$10$e3dVaTv5dlzUp/11RynRoeWkL0w7iAxdcNql1aDT3kzicy.XuU.qS	client	\N	2022-07-11 11:41:31.639+01	cus_M2OxkO9KQC4ZAQ
21	Ciao	Bello	2004-06-29	test12@gmail.com	$2b$10$WRQCaoiKCJyUfRDkk7S.ZeEm1166Sl8AzBL2sLSExYyYtVI4GXzRO	client	\N	2022-07-11 12:35:52.165+01	cus_M2Pkekyd4BrEdK
22	Ciao2	Bello2	2004-07-08	test13@gmail.com	$2b$10$AntDWJ.mhDu.M.eUyMBrruWAF1Bs2YlwA4feg97yeLOQx2OC.S84i	client	\N	2022-07-11 12:38:43.078+01	cus_M2PmbZINxJPXcY
28	Test30	Test30	2004-06-28	test30@gmail.com	$2b$10$GLTJB30rlnCHtUSIm6IT4./aHMCij.wegid2lKU028jX2PIrQUb/a	client	\N	2022-07-23 17:38:24.929+01	cus_M6zKUV6v7nPLBv
29	Test31@gmail.com	Test31@gmail.com	2004-06-28	test31@gmail.com	$2b$10$uBVtFm8QTjWa3DEgJi.E2u9GxEK/v9VVfEJzgozB1ItDbI35JLIki	client	\N	2022-07-23 17:40:05.958+01	cus_M6zMMvMTRDkIuq
30	Matteo	Bello	2004-08-02	matteo@yahoo.com	$2b$10$f/4csJ.Ho1BhANUW6sryuuvMGqFAp23UbC13Dhhlki1pL15nmLKhO	client	\N	2022-08-29 15:35:09.048+01	cus_MKohQ5eJiB66OJ
31	Simone	Bartoli	2001-04-01	info@bartolisimone.com	$2b$10$d9/BC6zT8eyqbhjqgxJvGuSC.DMjMZ1d28jYyyLKOZ/Pz4cSiXNkG	admin	\N	2022-09-04 12:35:55.986+01	cus_MN19AiVBASrDHU
32	Matteo	Gennai	1995-11-01	lucathebest2019@libero.it	$2b$10$El7YxAeSuxueSsXnlzdrmOY7o.jpAcsN/Wybh9CybwEQ/fRgb2BZC	client	\N	2022-09-10 12:47:27.45+01	cus_MPGh4eSVunE3WO
\.


--
-- Data for Name: vat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vat (vat_id, percentage) FROM stdin;
3	20
1	0
2	5
\.


--
-- Name: access_token_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_token_token_id_seq', 4594, true);


--
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 40, true);


--
-- Name: bundles_bundle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bundles_bundle_id_seq', 1, false);


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 11, true);


--
-- Name: contact_contact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contact_contact_id_seq', 2, true);


--
-- Name: discounts_discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discounts_discount_id_seq', 17, true);


--
-- Name: emails_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emails_email_id_seq', 1, false);


--
-- Name: items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_item_id_seq', 103, true);


--
-- Name: list_items_list_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.list_items_list_item_id_seq', 31, true);


--
-- Name: log_accesses_log_access_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_accesses_log_access_id_seq', 4135, true);


--
-- Name: orders_delivery_order_delivery_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_delivery_order_delivery_id_seq', 8, true);


--
-- Name: orders_receipt_number_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_receipt_number_seq', 8, true);


--
-- Name: refresh_tokens_refresh_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refresh_tokens_refresh_token_id_seq', 350, true);


--
-- Name: refunds_refund_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refunds_refund_id_seq', 17, true);


--
-- Name: tokens_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokens_token_id_seq', 103, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 32, true);


--
-- Name: vat_vat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vat_vat_id_seq', 3, true);


--
-- Name: access_token access_token_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token
    ADD CONSTRAINT access_token_pk PRIMARY KEY (token_id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (address_id);


--
-- Name: billing_addresses billing_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_addresses
    ADD CONSTRAINT billing_addresses_pkey PRIMARY KEY (address_id);


--
-- Name: bundles_items bundles_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles_items
    ADD CONSTRAINT bundles_items_pkey PRIMARY KEY (bundle_id, item_id);


--
-- Name: bundles bundles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles
    ADD CONSTRAINT bundles_pkey PRIMARY KEY (bundle_id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (user_id, item_id);


--
-- Name: categories_items categories_items_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories_items
    ADD CONSTRAINT categories_items_pk PRIMARY KEY (category_id, item_id);


--
-- Name: categories categories_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pk PRIMARY KEY (category_id);


--
-- Name: contact contact_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contact
    ADD CONSTRAINT contact_pk PRIMARY KEY (contact_id);


--
-- Name: discounts discounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discounts
    ADD CONSTRAINT discounts_pkey PRIMARY KEY (discount_id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (email_id);


--
-- Name: holidays holidays_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_pk PRIMARY KEY (start_date, end_date);


--
-- Name: items_hold items_hold_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_hold
    ADD CONSTRAINT items_hold_pk PRIMARY KEY (payment_intent_id, item_id);


--
-- Name: items items_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_name_key UNIQUE (name);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (item_id);


--
-- Name: keywords keywords_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keywords
    ADD CONSTRAINT keywords_pk PRIMARY KEY (keyword, item_id);


--
-- Name: sub_categories list_items_category_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories
    ADD CONSTRAINT list_items_category_key UNIQUE (name);


--
-- Name: sub_categories list_items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories
    ADD CONSTRAINT list_items_pkey PRIMARY KEY (sub_category_id);


--
-- Name: log_accesses log_accesses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_accesses
    ADD CONSTRAINT log_accesses_pkey PRIMARY KEY (log_access_id);


--
-- Name: orders_delivery orders_delivery_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_delivery
    ADD CONSTRAINT orders_delivery_pk PRIMARY KEY (order_delivery_id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: payment_intents payment_intents_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_intents
    ADD CONSTRAINT payment_intents_pk PRIMARY KEY (payment_intent_id);


--
-- Name: payment_methods payment_methods_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_pk PRIMARY KEY (reference);


--
-- Name: recover_tokens recover_tokens_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recover_tokens
    ADD CONSTRAINT recover_tokens_pk UNIQUE (secret, expiry);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (token_id);


--
-- Name: refunds refunds_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_pk PRIMARY KEY (refund_id);


--
-- Name: refunds refunds_pk_2; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_pk_2 UNIQUE (datetime, order_ref);


--
-- Name: shipping_addresses shipping_addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_addresses
    ADD CONSTRAINT shipping_addresses_pkey PRIMARY KEY (address_id);


--
-- Name: sub_categories_items sub_categories_items_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories_items
    ADD CONSTRAINT sub_categories_items_pk PRIMARY KEY (sub_category_id, item_id);


--
-- Name: recover_tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recover_tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (token_id);


--
-- Name: recover_tokens tokens_secret_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recover_tokens
    ADD CONSTRAINT tokens_secret_key UNIQUE (secret);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: vat vat_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vat
    ADD CONSTRAINT vat_pk PRIMARY KEY (vat_id);


--
-- Name: categories_category_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX categories_category_uindex ON public.categories USING btree (name);


--
-- Name: orders_delivery_actual_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX orders_delivery_actual_uindex ON public.orders_delivery USING btree (actual);


--
-- Name: orders_delivery_reference_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX orders_delivery_reference_uindex ON public.orders_delivery USING btree (reference);


--
-- Name: orders_reference_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX orders_reference_uindex ON public.orders USING btree (reference);


--
-- Name: payment_intents_hash_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX payment_intents_hash_uindex ON public.payment_intents USING btree (hash);


--
-- Name: users_email_to_verify_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_to_verify_uindex ON public.users USING btree (email_to_verify);


--
-- Name: users_stripe_customer_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_stripe_customer_id_uindex ON public.users USING btree (stripe_customer_id);


--
-- Name: vat_percentage_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX vat_percentage_uindex ON public.vat USING btree (percentage);


--
-- Name: access_token access_token_refresh_tokens_token_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_token
    ADD CONSTRAINT access_token_refresh_tokens_token_id_fk FOREIGN KEY (refresh_token_id) REFERENCES public.refresh_tokens(token_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: categories_items categories_items_categories_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories_items
    ADD CONSTRAINT categories_items_categories_category_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: categories_items categories_items_items_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories_items
    ADD CONSTRAINT categories_items_items_item_id_fk FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: addresses fkaddresses857531; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT fkaddresses857531 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: billing_addresses fkbilling_ad507106; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.billing_addresses
    ADD CONSTRAINT fkbilling_ad507106 FOREIGN KEY (address_id) REFERENCES public.addresses(address_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: bundles_items fkbundles_it21538; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles_items
    ADD CONSTRAINT fkbundles_it21538 FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: bundles_items fkbundles_it784788; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bundles_items
    ADD CONSTRAINT fkbundles_it784788 FOREIGN KEY (bundle_id) REFERENCES public.bundles(bundle_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: carts fkcarts255711; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fkcarts255711 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: carts fkcarts400421; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT fkcarts400421 FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: emails fkemails453837; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT fkemails453837 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: items fkitems605249; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT fkitems605249 FOREIGN KEY (discount_id) REFERENCES public.discounts(discount_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sub_categories_items fklist_items450170; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories_items
    ADD CONSTRAINT fklist_items450170 FOREIGN KEY (sub_category_id) REFERENCES public.sub_categories(sub_category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sub_categories_items fklist_items683058; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories_items
    ADD CONSTRAINT fklist_items683058 FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: log_accesses fklog_access736030; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.log_accesses
    ADD CONSTRAINT fklog_access736030 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: orders fkorders458716; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fkorders458716 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: refresh_tokens fkrefresh_to114230; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT fkrefresh_to114230 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: shipping_addresses fkshipping_a233077; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shipping_addresses
    ADD CONSTRAINT fkshipping_a233077 FOREIGN KEY (address_id) REFERENCES public.addresses(address_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: recover_tokens fktokens874970; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recover_tokens
    ADD CONSTRAINT fktokens874970 FOREIGN KEY (user_id) REFERENCES public.users(user_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: items_hold items_hold_items_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items_hold
    ADD CONSTRAINT items_hold_items_item_id_fk FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: items items_vat_vat_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_vat_vat_id_fk FOREIGN KEY (vat_id) REFERENCES public.vat(vat_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: keywords keywords_items_item_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.keywords
    ADD CONSTRAINT keywords_items_item_id_fk FOREIGN KEY (item_id) REFERENCES public.items(item_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: orders_delivery orders_delivery_orders_reference_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders_delivery
    ADD CONSTRAINT orders_delivery_orders_reference_fk FOREIGN KEY (reference) REFERENCES public.orders(reference) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: payment_methods payment_methods_orders_reference_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payment_methods
    ADD CONSTRAINT payment_methods_orders_reference_fk FOREIGN KEY (reference) REFERENCES public.orders(reference) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: refunds refunds_orders_reference_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refunds
    ADD CONSTRAINT refunds_orders_reference_fk FOREIGN KEY (order_ref) REFERENCES public.orders(reference) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sub_categories sub_categories_categories_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories
    ADD CONSTRAINT sub_categories_categories_category_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

