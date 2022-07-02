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
-- Name: ivaldi-db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "ivaldi-db" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Italian_Italy.1252';


ALTER DATABASE "ivaldi-db" OWNER TO postgres;

\connect -reuse-previous=on "dbname='ivaldi-db'"

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
-- Name: DATABASE "ivaldi-db"; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE "ivaldi-db" IS 'This is the main database SQL for Ivaldi Italian Food';


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
    user_id integer NOT NULL
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
    notes character varying(511),
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
    discount_id integer
);


ALTER TABLE public.items OWNER TO postgres;

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
    order_id integer NOT NULL,
    price_total double precision NOT NULL,
    shipping_cost double precision DEFAULT 0 NOT NULL,
    datetime timestamp without time zone NOT NULL,
    archive text NOT NULL,
    status character varying(255) NOT NULL,
    user_id integer NOT NULL,
    vat_total double precision NOT NULL
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_order_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_order_id_seq OWNER TO postgres;

--
-- Name: orders_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_order_id_seq OWNED BY public.orders.order_id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipts (
    receipt_id integer NOT NULL,
    price_total double precision NOT NULL,
    vat_total double precision NOT NULL,
    datetime timestamp without time zone NOT NULL,
    payment_method character varying(255) NOT NULL,
    archive text NOT NULL,
    status character varying(255) NOT NULL,
    order_id integer NOT NULL,
    payment_account character varying(255) NOT NULL
);


ALTER TABLE public.receipts OWNER TO postgres;

--
-- Name: receipts_receipt_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.receipts_receipt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.receipts_receipt_id_seq OWNER TO postgres;

--
-- Name: receipts_receipt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.receipts_receipt_id_seq OWNED BY public.receipts.receipt_id;


--
-- Name: recover_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.recover_tokens (
    token_id integer NOT NULL,
    secret character varying(511) NOT NULL,
    user_id integer NOT NULL,
    status character varying(63) DEFAULT 'PENDING'::character varying NOT NULL
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
-- Name: shipping_addresses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shipping_addresses (
    address_id integer NOT NULL,
    notes character varying(511)
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
    entry_date timestamp with time zone DEFAULT now() NOT NULL
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
-- Name: orders order_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN order_id SET DEFAULT nextval('public.orders_order_id_seq'::regclass);


--
-- Name: receipts receipt_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts ALTER COLUMN receipt_id SET DEFAULT nextval('public.receipts_receipt_id_seq'::regclass);


--
-- Name: recover_tokens token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.recover_tokens ALTER COLUMN token_id SET DEFAULT nextval('public.tokens_token_id_seq'::regclass);


--
-- Name: refresh_tokens token_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens ALTER COLUMN token_id SET DEFAULT nextval('public.refresh_tokens_refresh_token_id_seq'::regclass);


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
11	::1	PostmanRuntime/7.29.0	15	standard
13	::1	PostmanRuntime/7.29.0	17	standard
14	::1	PostmanRuntime/7.29.0	17	standard
15	::1	PostmanRuntime/7.29.0	17	standard
16	::1	PostmanRuntime/7.29.0	17	standard
26	::1	PostmanRuntime/7.29.0	20	standard
28	::1	PostmanRuntime/7.29.0	20	standard
29	::1	PostmanRuntime/7.29.0	20	standard
30	::1	PostmanRuntime/7.29.0	20	standard
31	::1	PostmanRuntime/7.29.0	20	standard
32	::1	PostmanRuntime/7.29.0	22	standard
33	::1	PostmanRuntime/7.29.0	22	standard
34	::1	PostmanRuntime/7.29.0	22	standard
35	::1	PostmanRuntime/7.29.0	22	standard
36	::1	PostmanRuntime/7.29.0	23	standard
37	::1	PostmanRuntime/7.29.0	23	standard
38	::1	PostmanRuntime/7.29.0	23	standard
39	::1	PostmanRuntime/7.29.0	23	standard
40	::1	PostmanRuntime/7.29.0	24	standard
42	::1	PostmanRuntime/7.29.0	25	standard
43	::1	PostmanRuntime/7.29.0	25	standard
44	::1	PostmanRuntime/7.29.0	25	standard
45	::1	PostmanRuntime/7.29.0	25	standard
46	::1	PostmanRuntime/7.29.0	25	standard
47	::1	PostmanRuntime/7.29.0	26	standard
48	::1	PostmanRuntime/7.29.0	26	standard
49	::1	PostmanRuntime/7.29.0	26	standard
50	::1	PostmanRuntime/7.29.0	26	standard
51	::1	PostmanRuntime/7.29.0	26	standard
52	::1	PostmanRuntime/7.29.0	26	standard
53	::1	PostmanRuntime/7.29.0	26	standard
54	::1	PostmanRuntime/7.29.0	26	standard
55	::1	PostmanRuntime/7.29.0	26	standard
56	::1	PostmanRuntime/7.29.0	26	standard
57	::1	PostmanRuntime/7.29.0	26	standard
58	::1	PostmanRuntime/7.29.0	26	standard
59	::1	PostmanRuntime/7.29.0	26	standard
60	::1	PostmanRuntime/7.29.0	26	standard
61	::1	PostmanRuntime/7.29.0	26	standard
62	::1	PostmanRuntime/7.29.0	26	standard
63	::1	PostmanRuntime/7.29.0	26	standard
64	::1	PostmanRuntime/7.29.0	26	standard
65	::1	PostmanRuntime/7.29.0	26	standard
66	::1	PostmanRuntime/7.29.0	26	standard
67	::1	PostmanRuntime/7.29.0	26	standard
68	::1	PostmanRuntime/7.29.0	26	standard
69	::1	PostmanRuntime/7.29.0	26	standard
70	::1	PostmanRuntime/7.29.0	26	standard
71	::1	PostmanRuntime/7.29.0	27	standard
72	::1	PostmanRuntime/7.29.0	28	standard
73	::1	PostmanRuntime/7.29.0	28	standard
\.


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addresses (address_id, city, first_address, second_address, postcode, user_id) FROM stdin;
1	London	1 Yeo Street	Caspian Wharf 40	E3 3AE	5
2	Manchester	Sunset blvd	\N	W3A A3ER	5
3	Florence	Via Mammoli 38/d	\N	50013	5
\.


--
-- Data for Name: billing_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.billing_addresses (address_id, notes, country) FROM stdin;
1	This is my main fiscal address	United Kingdom
3	This is my fiscal bad place	Italy
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
4	3	2
1	3	6
2	25	1
5	10	17
5	1	8
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (category_id, name, notes) FROM stdin;
1	Stand-alone	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis 
2	Future-proofed	Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.
3	bandwidth-monitored	Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus 
4	algorithm	Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum e
5	Robust	Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.
6	Customer-focused	Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, solli
7	Adaptive	Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.
8	asynchronous	Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.
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
\.


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.emails (email_id, trigger, datetime, user_id) FROM stdin;
\.


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.items (item_id, name, description, price_total, vat_id, amount_available, price_unit, photo_loc, entry_date, discount_id) FROM stdin;
1	CYE9r3H	dui nec nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed	18.74	1	0	LT	/tempus/semper/est.png	2022-06-27 21:19:55.757144	\N
8	2aNtyJlgZjZ	sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla	18	1	24	unit	/volutpat/quam/pede/lobortis.js	2022-06-27 21:19:55.757144	6
2	7EiedwtL	neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim	2.43	3	24	KG	/et/ultrices/posuere/cubilia/curae/donec.jpg	2022-06-27 21:19:55.757144	\N
3	17C8Be1RxUd	amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu	3.56	3	31	unit	/erat/quisque/erat/eros/viverra/eget.html	2022-06-27 21:19:55.757144	\N
4	tXjwhKL	lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet sapien urna pretium nisl ut	13.49	1	28	LT	/egestas/metus/aenean/fermentum.aspx	2022-06-27 21:19:55.757144	\N
5	xFXXvXXNXR	sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum	4.54	2	34	KG	/tristique.xml	2022-06-27 21:19:55.757144	\N
6	1teuGYJ4JHmM	justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque	18.05	1	24	unit	/arcu.jpg	2022-06-27 21:19:55.757144	1
7	dDEmvtXHh8	accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat	3.08	1	38	KG	/accumsan/tellus/nisi/eu/orci.jsp	2022-06-27 21:19:55.757144	\N
9	jHDjVM4	sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar	17.5	3	21	LT	/vel/nisl.png	2022-06-27 21:19:55.757144	\N
10	0bjYItN6	a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices	12.46	3	39	KG	/eget/nunc/donec/quis/orci/eget.aspx	2022-06-27 21:19:55.757144	\N
11	DeepzB7DCn9E	neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel	18.87	1	20	LT	/amet/cursus/id/turpis/integer.jsp	2022-06-27 21:19:55.757144	\N
12	NfIs5RClAdp	iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate	15.53	2	36	LT	/nullam.xml	2022-06-27 21:19:55.757144	\N
13	MDAFOZvCp	amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere	11.3	1	20	KG	/vel/sem.jpg	2022-06-27 21:19:55.757144	4
14	iHGksA	sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra	17.2	2	38	unit	/sit/amet/eleifend/pede.js	2022-06-27 21:19:55.757144	\N
15	ysoV02urNI	quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien	5.65	3	32	unit	/molestie/nibh/in/lectus/pellentesque/at.jpg	2022-06-27 21:19:55.757144	\N
16	LupuT8	nulla neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim	3.71	3	31	LT	/condimentum/curabitur.json	2022-06-27 21:19:55.757144	\N
17	efCQeGKq	adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante	5.88	2	24	unit	/potenti.aspx	2022-06-27 21:19:55.757144	\N
18	TdwKPMIs26J	vel sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede	2.69	1	21	LT	/sed/interdum/venenatis/turpis/enim.json	2022-06-27 21:19:55.757144	\N
19	xjfgqR	vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia	11.15	1	39	KG	/blandit/mi/in/porttitor.html	2022-06-27 21:19:55.757144	\N
20	bN9A7XO3Jkol	sem sed sagittis nam congue risus semper porta volutpat quam pede lobortis ligula sit amet eleifend pede libero	18.15	2	36	unit	/ut/tellus.jpg	2022-06-27 21:19:55.757144	2
21	d9U4mlMeyKk	sit amet eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec	10.25	2	34	unit	/mus.json	2022-06-27 21:19:55.757144	\N
22	nhCgXM	sed accumsan felis ut at dolor quis odio consequat varius integer ac leo pellentesque ultrices mattis odio	19.34	2	20	KG	/risus.xml	2022-06-27 21:19:55.757144	\N
23	jdTxMCwbjMV	sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate	15.75	1	35	unit	/praesent/blandit.json	2022-06-27 21:19:55.757144	5
24	A0pZ0Q	vulputate ut ultrices vel augue vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere	4.21	2	32	KG	/sit/amet.xml	2022-06-27 21:19:55.757144	5
25	rudfljHLA0vs	mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue	13.23	1	27	LT	/aliquam/quis.jsp	2022-06-27 21:19:55.757144	\N
26	E8hhHg8Np5	habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum	16.08	2	23	unit	/sed/magna.jpg	2022-06-27 21:19:55.757144	\N
27	aaT7fpX0wQ	magna at nunc commodo placerat praesent blandit nam nulla integer pede justo lacinia eget tincidunt	16.51	2	36	KG	/a/feugiat/et/eros/vestibulum.jpg	2022-06-27 21:19:55.757144	\N
28	2yvFTLO5hE8	a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio	12.44	2	21	KG	/in/faucibus/orci/luctus/et/ultrices/posuere.png	2022-06-27 21:19:55.757144	2
29	x0LHbTf	lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed tristique in tempus sit amet sem	13.9	3	33	LT	/duis/ac/nibh/fusce/lacus/purus.js	2022-06-27 21:19:55.757144	\N
30	PFthAqQ	morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis ac	19	1	27	unit	/praesent.png	2022-06-27 21:19:55.757144	\N
31	uq9SftZRGyK	pretium iaculis justo in hac habitasse platea dictumst etiam faucibus cursus urna ut tellus nulla ut erat id mauris vulputate	14.37	2	40	LT	/quisque.jsp	2022-06-27 21:19:55.757144	\N
32	BWrYrw5	convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet	13.97	2	39	KG	/nec/condimentum/neque/sapien/placerat/ante/nulla.png	2022-06-27 21:19:55.757144	1
33	7l428YDHXq	penatibus et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean	18.56	3	31	unit	/luctus/nec/molestie/sed/justo/pellentesque.js	2022-06-27 21:19:55.757144	\N
34	lHmuVGrArEof	luctus rutrum nulla tellus in sagittis dui vel nisl duis ac nibh fusce lacus purus aliquet	4.74	1	35	KG	/etiam/faucibus/cursus.js	2022-06-27 21:19:55.757144	3
35	RArlwG	donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed vestibulum sit	11.32	3	25	unit	/turpis/sed/ante/vivamus/tortor/duis/mattis.html	2022-06-27 21:19:55.757144	\N
36	rolwnU	mi pede malesuada in imperdiet et commodo vulputate justo in blandit ultrices enim lorem ipsum	7.86	3	25	unit	/curabitur/gravida/nisi/at.xml	2022-06-27 21:19:55.757144	4
37	qDuuIC3	non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci	14.12	3	21	unit	/consequat.aspx	2022-06-27 21:19:55.757144	6
38	Ugm2MvBb	vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at turpis a pede posuere	18.82	2	32	LT	/turpis/enim/blandit.js	2022-06-27 21:19:55.757144	\N
39	eAtr3zbznd	ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit ligula in lacus curabitur at	19.18	2	26	LT	/consequat.json	2022-06-27 21:19:55.757144	6
40	PLxMZ7ac	rutrum at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna	13.48	2	24	LT	/amet/diam/in/magna/bibendum.xml	2022-06-27 21:19:55.757144	\N
41	TwcKbbx	interdum mauris ullamcorper purus sit amet nulla quisque arcu libero rutrum ac lobortis vel dapibus at diam nam	18.99	2	38	unit	/lectus/pellentesque/eget/nunc/donec.json	2022-06-27 21:19:55.757144	\N
42	hePxXVVV8	nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede	16.07	3	31	LT	/urna/pretium/nisl/ut.js	2022-06-27 21:19:55.757144	5
43	vVMQBD	nulla justo aliquam quis turpis eget elit sodales scelerisque mauris sit amet eros suspendisse accumsan	18.03	3	31	LT	/nunc/vestibulum/ante/ipsum/primis.jsp	2022-06-27 21:19:55.757144	\N
44	gT2623mTZ2Sy	pellentesque eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa	15.22	3	36	KG	/vestibulum.png	2022-06-27 21:19:55.757144	1
45	mdOAYPOLci	aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam congue risus semper porta volutpat quam	15.41	1	34	LT	/mauris/eget/massa/tempor/convallis/nulla.json	2022-06-27 21:19:55.757144	5
46	zQVSHPvXxq	a ipsum integer a nibh in quis justo maecenas rhoncus aliquam lacus morbi quis tortor	6.54	1	26	LT	/tincidunt/nulla/mollis.aspx	2022-06-27 21:19:55.757144	\N
47	spUlXgTtnIij	ultrices posuere cubilia curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec	17.21	1	25	LT	/proin/risus/praesent/lectus/vestibulum/quam/sapien.xml	2022-06-27 21:19:55.757144	\N
48	cbNidJ8	nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at	5.97	3	34	LT	/facilisi/cras/non.xml	2022-06-27 21:19:55.757144	\N
49	BEI726rFOop	blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices	2.78	1	27	unit	/morbi/sem/mauris/laoreet/ut.aspx	2022-06-27 21:19:55.757144	2
50	UfdzXYkfl	posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel	10.6	3	30	unit	/enim/sit/amet/nunc/viverra.aspx	2022-06-27 21:19:55.757144	\N
51	8ownjVQ1UD2Q	lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis	17.96	3	26	KG	/in/hac/habitasse.html	2022-06-27 21:19:55.757144	\N
52	jIm3OhqF	donec dapibus duis at velit eu est congue elementum in hac habitasse platea dictumst morbi vestibulum velit id pretium iaculis	7.2	2	22	unit	/nec/nisi.js	2022-06-27 21:19:55.757144	\N
53	UsGIDLCqii	ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper	3.59	2	40	LT	/convallis/nunc/proin.jsp	2022-06-27 21:19:55.757144	\N
54	AgswyaWl	morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam	11.2	3	37	KG	/nam/dui/proin/leo.xml	2022-06-27 21:19:55.757144	\N
55	7VnurlD5f7W	erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus in felis	13.77	3	21	unit	/luctus.xml	2022-06-27 21:19:55.757144	\N
56	68HJOt	sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa tempor convallis	6.45	1	20	unit	/nec/condimentum.js	2022-06-27 21:19:55.757144	\N
57	vVtkhTu2T	odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis	7.31	2	31	unit	/volutpat.aspx	2022-06-27 21:19:55.757144	\N
58	V2R07QhrB	montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa	12.22	2	25	unit	/amet/cursus/id/turpis/integer/aliquet/massa.jpg	2022-06-27 21:19:55.757144	4
59	fERBI3NCG	turpis a pede posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum	7.98	1	25	LT	/amet/erat/nulla.jpg	2022-06-27 21:19:55.757144	6
60	7CwqGZuouh	adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum	18.05	2	31	KG	/sem/mauris/laoreet/ut.jpg	2022-06-27 21:19:55.757144	\N
61	ip1FUPvR	eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in est risus auctor sed	14.97	1	24	LT	/libero/non/mattis/pulvinar.jsp	2022-06-27 21:19:55.757144	5
62	OOYA8XE	feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse	15.64	3	29	LT	/gravida.jsp	2022-06-27 21:19:55.757144	\N
63	pAWv3U6AIBv	odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet erat	6.36	1	32	LT	/in/tempor/turpis/nec/euismod.xml	2022-06-27 21:19:55.757144	\N
64	SDCpwP0lCCM	eget nunc donec quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio odio	15.45	1	25	unit	/lobortis/sapien/sapien/non/mi/integer/ac.jsp	2022-06-27 21:19:55.757144	1
65	RUoH0gpSJoav	at lorem integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit	4.16	1	35	unit	/in/magna/bibendum.html	2022-06-27 21:19:55.757144	\N
66	66L2kQ4	accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget	10.06	1	27	unit	/ultrices/posuere/cubilia.aspx	2022-06-27 21:19:55.757144	\N
67	76MckC	diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget	5.43	2	31	KG	/posuere/metus/vitae/ipsum/aliquam/non.json	2022-06-27 21:19:55.757144	3
68	GmeStIiA	dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien	4.49	1	38	LT	/ut/nunc.jsp	2022-06-27 21:19:55.757144	\N
69	IsalJbB2	quis orci eget orci vehicula condimentum curabitur in libero ut massa volutpat convallis morbi odio	7.23	3	31	unit	/proin.jsp	2022-06-27 21:19:55.757144	4
70	1Zy58y3co3AY	feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut massa	10.56	3	27	LT	/ante.js	2022-06-27 21:19:55.757144	5
71	aTiARaO	cursus id turpis integer aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus nisi eu orci mauris	9.15	3	32	KG	/elit/proin.json	2022-06-27 21:19:55.757144	2
72	NvSvUB	sed ante vivamus tortor duis mattis egestas metus aenean fermentum donec ut mauris eget massa	15.62	2	38	KG	/nulla/sed/accumsan/felis/ut.aspx	2022-06-27 21:19:55.757144	\N
73	rUXTOB3n	eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque	6.27	2	20	KG	/porta/volutpat/erat/quisque.jsp	2022-06-27 21:19:55.757144	6
74	1Mq3UGob85K	vestibulum quam sapien varius ut blandit non interdum in ante vestibulum ante ipsum primis in faucibus orci	5.03	3	33	LT	/aliquam/erat/volutpat/in/congue/etiam.xml	2022-06-27 21:19:55.757144	\N
75	Qt2JzeR	phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu	2.98	3	27	unit	/orci/luctus/et/ultrices/posuere/cubilia/curae.json	2022-06-27 21:19:55.757144	5
76	b9jj08Tx8mJ	ac enim in tempor turpis nec euismod scelerisque quam turpis adipiscing lorem vitae mattis nibh ligula nec sem	7.3	1	39	KG	/cum/sociis/natoque.jpg	2022-06-27 21:19:55.757144	\N
77	XuI1DRXw1OU	nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in porttitor pede justo	19.88	3	32	KG	/sapien/urna/pretium.aspx	2022-06-27 21:19:55.757144	2
78	MEzPczUQuF	commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula	10.01	3	34	unit	/nisl/duis/bibendum/felis/sed.html	2022-06-27 21:19:55.757144	\N
79	l4MFHCbB	platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien	17.61	1	32	LT	/lacus/morbi/sem/mauris/laoreet/ut.jpg	2022-06-27 21:19:55.757144	4
80	fwuPQIHDAUB	suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu	14.61	2	29	unit	/ligula/in/lacus/curabitur/at/ipsum/ac.jsp	2022-06-27 21:19:55.757144	5
81	Ndoe31Yme	convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum	3.33	2	37	unit	/tempus.xml	2022-06-27 21:19:55.757144	1
82	alRvuSkv73	metus sapien ut nunc vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae mauris viverra	15.07	3	22	KG	/nisi/vulputate/nonummy/maecenas/tincidunt/lacus/at.aspx	2022-06-27 21:19:55.757144	3
83	ghwb5TOD	lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit	11.64	1	26	LT	/pretium/iaculis.aspx	2022-06-27 21:19:55.757144	6
84	qDP8bdZCGE	phasellus sit amet erat nulla tempus vivamus in felis eu sapien cursus vestibulum proin eu mi nulla ac	11.85	3	34	LT	/ultrices.aspx	2022-06-27 21:19:55.757144	\N
85	Tdsgh0ePPOhV	justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque	11.38	3	23	KG	/amet/sem/fusce/consequat/nulla/nisl.jsp	2022-06-27 21:19:55.757144	6
86	majMp8x	sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl	17.44	1	40	KG	/rutrum/at/lorem/integer/tincidunt/ante.xml	2022-06-27 21:19:55.757144	\N
87	VfFs3gyPIB	congue eget semper rutrum nulla nunc purus phasellus in felis donec semper sapien a libero nam	18.37	3	40	KG	/natoque.xml	2022-06-27 21:19:55.757144	2
88	4YGGwpWVVo	lacinia aenean sit amet justo morbi ut odio cras mi pede malesuada in imperdiet et commodo vulputate	13.6	2	31	KG	/consequat/in/consequat/ut.jsp	2022-06-27 21:19:55.757144	\N
89	pHB0e7	vivamus metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis	7.86	3	22	LT	/sed/tristique/in/tempus/sit/amet.js	2022-06-27 21:19:55.757144	\N
90	2WeSX08fOl1	integer tincidunt ante vel ipsum praesent blandit lacinia erat vestibulum sed magna at nunc commodo placerat praesent blandit nam	8.75	3	29	KG	/pede/justo/lacinia/eget/tincidunt/eget.jsp	2022-06-27 21:19:55.757144	\N
91	XZDbDf9dvrA	urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit	19.53	1	33	KG	/massa/id/nisl/venenatis/lacinia.json	2022-06-27 21:19:55.757144	\N
92	VYbzbwxu7gG	donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet diam in magna bibendum imperdiet	2.39	2	23	KG	/proin.js	2022-06-27 21:19:55.757144	1
93	jF1H5rhapH	nulla suscipit ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper purus sit amet nulla	5.71	2	34	LT	/risus/semper/porta/volutpat/quam/pede/lobortis.js	2022-06-27 21:19:55.757144	\N
94	KPxoq0RO	potenti nullam porttitor lacus at turpis donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit	18.14	3	26	LT	/posuere/cubilia/curae/duis.jpg	2022-06-27 21:19:55.757144	\N
95	9vyGFL	diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in congue etiam	13.02	3	32	unit	/scelerisque/quam/turpis/adipiscing/lorem/vitae/mattis.jsp	2022-06-27 21:19:55.757144	3
96	NRr1ExTXeh	dis parturient montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque penatibus et magnis dis parturient	15.56	3	27	KG	/nisi/eu/orci/mauris/lacinia/sapien.jpg	2022-06-27 21:19:55.757144	\N
97	9EbG3Az	non mattis pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim	2.23	1	38	KG	/massa/id/lobortis/convallis/tortor/risus.js	2022-06-27 21:19:55.757144	\N
98	Q73GuAi	eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum ante ipsum primis	2.94	3	40	unit	/nisi/at/nibh.jpg	2022-06-27 21:19:55.757144	\N
99	HQuWEX	vulputate elementum nullam varius nulla facilisi cras non velit nec nisi vulputate nonummy maecenas tincidunt lacus at	9.18	3	27	LT	/praesent/id/massa/id/nisl/venenatis/lacinia.jsp	2022-06-27 21:19:55.757144	6
100	LgxBPswCt	convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit amet	9.28	3	39	KG	/non/mi/integer/ac.png	2022-06-27 21:19:55.757144	\N
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
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, price_total, shipping_cost, datetime, archive, status, user_id, vat_total) FROM stdin;
1	445.63	4.53	2022-06-30 20:11:40.496	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"IsalJbB2","amount":2,"price_per_unit":7.23,"price_unit":"unit","price_total":14.46,"vat":20},{"name":"efCQeGKq","amount":2,"price_per_unit":5.88,"price_unit":"unit","price_total":11.76,"vat":10},{"name":"PFthAqQ","amount":4,"price_per_unit":19,"price_unit":"unit","price_total":76,"vat":5},{"name":"nhCgXM","amount":4,"price_per_unit":19.34,"price_unit":"KG","price_total":77.36,"vat":10},{"name":"cbNidJ8","amount":3,"price_per_unit":5.97,"price_unit":"LT","price_total":17.91,"vat":20},{"name":"HQuWEX","amount":2,"price_per_unit":9.18,"price_unit":"LT","price_total":18.36,"vat":20},{"name":"9vyGFL","amount":4,"price_per_unit":13.02,"price_unit":"unit","price_total":52.08,"vat":20},{"name":"TdwKPMIs26J","amount":3,"price_per_unit":2.69,"price_unit":"LT","price_total":8.07,"vat":5},{"name":"TwcKbbx","amount":3,"price_per_unit":18.99,"price_unit":"unit","price_total":56.97,"vat":10},{"name":"jdTxMCwbjMV","amount":3,"price_per_unit":15.75,"price_unit":"unit","price_total":47.25,"vat":5},{"name":"gT2623mTZ2Sy","amount":4,"price_per_unit":15.22,"price_unit":"KG","price_total":60.88,"vat":20}]}	PENDING	1	53.91
2	263.5	1.01	2022-06-30 20:11:40.521	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"RUoH0gpSJoav","amount":1,"price_per_unit":4.16,"price_unit":"unit","price_total":4.16,"vat":5},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20},{"name":"rUXTOB3n","amount":2,"price_per_unit":6.27,"price_unit":"KG","price_total":12.54,"vat":10},{"name":"IsalJbB2","amount":3,"price_per_unit":7.23,"price_unit":"unit","price_total":21.69,"vat":20},{"name":"d9U4mlMeyKk","amount":2,"price_per_unit":10.25,"price_unit":"unit","price_total":20.5,"vat":10},{"name":"UsGIDLCqii","amount":2,"price_per_unit":3.59,"price_unit":"LT","price_total":7.18,"vat":10},{"name":"CYE9r3H","amount":2,"price_per_unit":18.74,"price_unit":"LT","price_total":37.48,"vat":5},{"name":"qDuuIC3","amount":4,"price_per_unit":14.12,"price_unit":"unit","price_total":56.48,"vat":20},{"name":"lHmuVGrArEof","amount":2,"price_per_unit":4.74,"price_unit":"KG","price_total":9.48,"vat":5},{"name":"jdTxMCwbjMV","amount":1,"price_per_unit":15.75,"price_unit":"unit","price_total":15.75,"vat":5},{"name":"ysoV02urNI","amount":3,"price_per_unit":5.65,"price_unit":"unit","price_total":16.95,"vat":20}]}	PENDING	1	38.45
3	386.68	4.96	2022-06-30 20:11:40.525	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"BWrYrw5","amount":3,"price_per_unit":13.97,"price_unit":"KG","price_total":41.91,"vat":10},{"name":"IsalJbB2","amount":3,"price_per_unit":7.23,"price_unit":"unit","price_total":21.69,"vat":20},{"name":"qDP8bdZCGE","amount":4,"price_per_unit":11.85,"price_unit":"LT","price_total":47.4,"vat":20},{"name":"uq9SftZRGyK","amount":4,"price_per_unit":14.37,"price_unit":"LT","price_total":57.48,"vat":10},{"name":"fwuPQIHDAUB","amount":2,"price_per_unit":14.61,"price_unit":"unit","price_total":29.22,"vat":10},{"name":"b9jj08Tx8mJ","amount":3,"price_per_unit":7.3,"price_unit":"KG","price_total":21.9,"vat":5},{"name":"rUXTOB3n","amount":1,"price_per_unit":6.27,"price_unit":"KG","price_total":6.27,"vat":10},{"name":"7EiedwtL","amount":4,"price_per_unit":2.43,"price_unit":"KG","price_total":9.72,"vat":20},{"name":"gT2623mTZ2Sy","amount":2,"price_per_unit":15.22,"price_unit":"KG","price_total":30.44,"vat":20},{"name":"mdOAYPOLci","amount":3,"price_per_unit":15.41,"price_unit":"LT","price_total":46.23,"vat":5},{"name":"fERBI3NCG","amount":3,"price_per_unit":7.98,"price_unit":"LT","price_total":23.94,"vat":5},{"name":"Tdsgh0ePPOhV","amount":4,"price_per_unit":11.38,"price_unit":"KG","price_total":45.52,"vat":20}]}	DELIVERED	1	49.05
4	338.81	1.57	2022-06-30 20:11:40.529	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"efCQeGKq","amount":1,"price_per_unit":5.88,"price_unit":"unit","price_total":5.88,"vat":10},{"name":"hePxXVVV8","amount":4,"price_per_unit":16.07,"price_unit":"LT","price_total":64.28,"vat":20},{"name":"76MckC","amount":2,"price_per_unit":5.43,"price_unit":"KG","price_total":10.86,"vat":10},{"name":"rolwnU","amount":3,"price_per_unit":7.86,"price_unit":"unit","price_total":23.58,"vat":20},{"name":"nhCgXM","amount":4,"price_per_unit":19.34,"price_unit":"KG","price_total":77.36,"vat":10},{"name":"dDEmvtXHh8","amount":2,"price_per_unit":3.08,"price_unit":"KG","price_total":6.16,"vat":5},{"name":"7CwqGZuouh","amount":2,"price_per_unit":18.05,"price_unit":"KG","price_total":36.1,"vat":10},{"name":"7EiedwtL","amount":4,"price_per_unit":2.43,"price_unit":"KG","price_total":9.72,"vat":20},{"name":"BEI726rFOop","amount":1,"price_per_unit":2.78,"price_unit":"unit","price_total":2.78,"vat":5},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20}]}	CANCELLED	1	47.05
5	297.18	2.66	2022-06-30 20:11:40.533	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"2yvFTLO5hE8","amount":2,"price_per_unit":12.44,"price_unit":"KG","price_total":24.88,"vat":10},{"name":"MEzPczUQuF","amount":3,"price_per_unit":10.01,"price_unit":"unit","price_total":30.03,"vat":20},{"name":"x0LHbTf","amount":3,"price_per_unit":13.9,"price_unit":"LT","price_total":41.7,"vat":20},{"name":"0bjYItN6","amount":4,"price_per_unit":12.46,"price_unit":"KG","price_total":49.84,"vat":20},{"name":"ip1FUPvR","amount":2,"price_per_unit":14.97,"price_unit":"LT","price_total":29.94,"vat":5},{"name":"BEI726rFOop","amount":1,"price_per_unit":2.78,"price_unit":"unit","price_total":2.78,"vat":5},{"name":"aaT7fpX0wQ","amount":4,"price_per_unit":16.51,"price_unit":"KG","price_total":66.04,"vat":10},{"name":"d9U4mlMeyKk","amount":1,"price_per_unit":10.25,"price_unit":"unit","price_total":10.25,"vat":10},{"name":"VfFs3gyPIB","amount":1,"price_per_unit":18.37,"price_unit":"KG","price_total":18.37,"vat":20},{"name":"VYbzbwxu7gG","amount":4,"price_per_unit":2.39,"price_unit":"KG","price_total":9.56,"vat":10},{"name":"LupuT8","amount":3,"price_per_unit":3.71,"price_unit":"LT","price_total":11.13,"vat":20}]}	PENDING	1	42.92
6	329.27	4.25	2022-06-30 20:11:40.537	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"rolwnU","amount":4,"price_per_unit":7.86,"price_unit":"unit","price_total":31.44,"vat":20},{"name":"9EbG3Az","amount":1,"price_per_unit":2.23,"price_unit":"KG","price_total":2.23,"vat":5},{"name":"tXjwhKL","amount":3,"price_per_unit":13.49,"price_unit":"LT","price_total":40.47,"vat":5},{"name":"RArlwG","amount":4,"price_per_unit":11.32,"price_unit":"unit","price_total":45.28,"vat":20},{"name":"GmeStIiA","amount":4,"price_per_unit":4.49,"price_unit":"LT","price_total":17.96,"vat":5},{"name":"majMp8x","amount":4,"price_per_unit":17.44,"price_unit":"KG","price_total":69.76,"vat":5},{"name":"BEI726rFOop","amount":2,"price_per_unit":2.78,"price_unit":"unit","price_total":5.56,"vat":5},{"name":"rudfljHLA0vs","amount":3,"price_per_unit":13.23,"price_unit":"LT","price_total":39.69,"vat":5},{"name":"1Mq3UGob85K","amount":3,"price_per_unit":5.03,"price_unit":"LT","price_total":15.09,"vat":20},{"name":"eAtr3zbznd","amount":3,"price_per_unit":19.18,"price_unit":"LT","price_total":57.54,"vat":10}]}	PENDING	1	32.9
7	140.24	4.66	2022-06-30 20:11:40.542	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"efCQeGKq","amount":1,"price_per_unit":5.88,"price_unit":"unit","price_total":5.88,"vat":10},{"name":"ysoV02urNI","amount":1,"price_per_unit":5.65,"price_unit":"unit","price_total":5.65,"vat":20},{"name":"GmeStIiA","amount":4,"price_per_unit":4.49,"price_unit":"LT","price_total":17.96,"vat":5},{"name":"NfIs5RClAdp","amount":2,"price_per_unit":15.53,"price_unit":"LT","price_total":31.06,"vat":10},{"name":"tXjwhKL","amount":1,"price_per_unit":13.49,"price_unit":"LT","price_total":13.49,"vat":5},{"name":"qDP8bdZCGE","amount":1,"price_per_unit":11.85,"price_unit":"LT","price_total":11.85,"vat":20},{"name":"76MckC","amount":1,"price_per_unit":5.43,"price_unit":"KG","price_total":5.43,"vat":10},{"name":"dDEmvtXHh8","amount":2,"price_per_unit":3.08,"price_unit":"KG","price_total":6.16,"vat":5},{"name":"SDCpwP0lCCM","amount":2,"price_per_unit":15.45,"price_unit":"unit","price_total":30.9,"vat":5},{"name":"jIm3OhqF","amount":1,"price_per_unit":7.2,"price_unit":"unit","price_total":7.2,"vat":10}]}	DELIVERED	2	11.88
8	345.48	0.22	2022-06-30 20:11:40.546	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"l4MFHCbB","amount":1,"price_per_unit":17.61,"price_unit":"LT","price_total":17.61,"vat":5},{"name":"pHB0e7","amount":2,"price_per_unit":7.86,"price_unit":"LT","price_total":15.72,"vat":20},{"name":"Ndoe31Yme","amount":3,"price_per_unit":3.33,"price_unit":"unit","price_total":9.99,"vat":10},{"name":"UsGIDLCqii","amount":3,"price_per_unit":3.59,"price_unit":"LT","price_total":10.77,"vat":10},{"name":"DeepzB7DCn9E","amount":2,"price_per_unit":18.87,"price_unit":"LT","price_total":37.74,"vat":5},{"name":"aaT7fpX0wQ","amount":3,"price_per_unit":16.51,"price_unit":"KG","price_total":49.53,"vat":10},{"name":"XZDbDf9dvrA","amount":3,"price_per_unit":19.53,"price_unit":"KG","price_total":58.59,"vat":5},{"name":"4YGGwpWVVo","amount":3,"price_per_unit":13.6,"price_unit":"KG","price_total":40.8,"vat":10},{"name":"VYbzbwxu7gG","amount":2,"price_per_unit":2.39,"price_unit":"KG","price_total":4.78,"vat":10},{"name":"1teuGYJ4JHmM","amount":1,"price_per_unit":18.05,"price_unit":"unit","price_total":18.05,"vat":5},{"name":"XuI1DRXw1OU","amount":1,"price_per_unit":19.88,"price_unit":"KG","price_total":19.88,"vat":20},{"name":"SDCpwP0lCCM","amount":4,"price_per_unit":15.45,"price_unit":"unit","price_total":61.8,"vat":5}]}	PENDING	2	28.4
9	300.04	1.92	2022-06-30 20:11:40.552	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"pAWv3U6AIBv","amount":1,"price_per_unit":6.36,"price_unit":"LT","price_total":6.36,"vat":5},{"name":"qDP8bdZCGE","amount":4,"price_per_unit":11.85,"price_unit":"LT","price_total":47.4,"vat":20},{"name":"lHmuVGrArEof","amount":1,"price_per_unit":4.74,"price_unit":"KG","price_total":4.74,"vat":5},{"name":"mdOAYPOLci","amount":2,"price_per_unit":15.41,"price_unit":"LT","price_total":30.82,"vat":5},{"name":"Q73GuAi","amount":1,"price_per_unit":2.94,"price_unit":"unit","price_total":2.94,"vat":20},{"name":"Tdsgh0ePPOhV","amount":2,"price_per_unit":11.38,"price_unit":"KG","price_total":22.76,"vat":20},{"name":"aaT7fpX0wQ","amount":4,"price_per_unit":16.51,"price_unit":"KG","price_total":66.04,"vat":10},{"name":"1teuGYJ4JHmM","amount":2,"price_per_unit":18.05,"price_unit":"unit","price_total":36.1,"vat":5},{"name":"0bjYItN6","amount":4,"price_per_unit":12.46,"price_unit":"KG","price_total":49.84,"vat":20},{"name":"NRr1ExTXeh","amount":2,"price_per_unit":15.56,"price_unit":"KG","price_total":31.12,"vat":20}]}	PENDING	2	41.32
10	416.78	0.76	2022-06-30 20:11:40.555	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"TwcKbbx","amount":1,"price_per_unit":18.99,"price_unit":"unit","price_total":18.99,"vat":10},{"name":"2yvFTLO5hE8","amount":1,"price_per_unit":12.44,"price_unit":"KG","price_total":12.44,"vat":10},{"name":"gT2623mTZ2Sy","amount":3,"price_per_unit":15.22,"price_unit":"KG","price_total":45.66,"vat":20},{"name":"vVMQBD","amount":4,"price_per_unit":18.03,"price_unit":"LT","price_total":72.12,"vat":20},{"name":"jF1H5rhapH","amount":3,"price_per_unit":5.71,"price_unit":"LT","price_total":17.13,"vat":10},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20},{"name":"cbNidJ8","amount":2,"price_per_unit":5.97,"price_unit":"LT","price_total":11.94,"vat":20},{"name":"DeepzB7DCn9E","amount":4,"price_per_unit":18.87,"price_unit":"LT","price_total":75.48,"vat":5},{"name":"pHB0e7","amount":3,"price_per_unit":7.86,"price_unit":"LT","price_total":23.58,"vat":20},{"name":"hePxXVVV8","amount":4,"price_per_unit":16.07,"price_unit":"LT","price_total":64.28,"vat":20},{"name":"qDuuIC3","amount":1,"price_per_unit":14.12,"price_unit":"unit","price_total":14.12,"vat":20}]}	PENDING	2	67.03
11	341.29	4.22	2022-06-30 20:11:40.559	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"7EiedwtL","amount":2,"price_per_unit":2.43,"price_unit":"KG","price_total":4.86,"vat":20},{"name":"tXjwhKL","amount":4,"price_per_unit":13.49,"price_unit":"LT","price_total":53.96,"vat":5},{"name":"76MckC","amount":3,"price_per_unit":5.43,"price_unit":"KG","price_total":16.29,"vat":10},{"name":"XZDbDf9dvrA","amount":2,"price_per_unit":19.53,"price_unit":"KG","price_total":39.06,"vat":5},{"name":"LgxBPswCt","amount":3,"price_per_unit":9.28,"price_unit":"KG","price_total":27.84,"vat":20},{"name":"rolwnU","amount":1,"price_per_unit":7.86,"price_unit":"unit","price_total":7.86,"vat":20},{"name":"TwcKbbx","amount":4,"price_per_unit":18.99,"price_unit":"unit","price_total":75.96,"vat":10},{"name":"2WeSX08fOl1","amount":2,"price_per_unit":8.75,"price_unit":"KG","price_total":17.5,"vat":20},{"name":"b9jj08Tx8mJ","amount":1,"price_per_unit":7.3,"price_unit":"KG","price_total":7.3,"vat":5},{"name":"7CwqGZuouh","amount":4,"price_per_unit":18.05,"price_unit":"KG","price_total":72.2,"vat":10},{"name":"17C8Be1RxUd","amount":4,"price_per_unit":3.56,"price_unit":"unit","price_total":14.24,"vat":20}]}	DELIVERED	2	35.92
12	394.46	3.33	2022-06-30 20:11:40.563	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"dDEmvtXHh8","amount":1,"price_per_unit":3.08,"price_unit":"KG","price_total":3.08,"vat":5},{"name":"vVtkhTu2T","amount":2,"price_per_unit":7.31,"price_unit":"unit","price_total":14.62,"vat":10},{"name":"fwuPQIHDAUB","amount":3,"price_per_unit":14.61,"price_unit":"unit","price_total":43.83,"vat":10},{"name":"Ugm2MvBb","amount":3,"price_per_unit":18.82,"price_unit":"LT","price_total":56.46,"vat":10},{"name":"TwcKbbx","amount":4,"price_per_unit":18.99,"price_unit":"unit","price_total":75.96,"vat":10},{"name":"rudfljHLA0vs","amount":4,"price_per_unit":13.23,"price_unit":"LT","price_total":52.92,"vat":5},{"name":"8ownjVQ1UD2Q","amount":3,"price_per_unit":17.96,"price_unit":"KG","price_total":53.88,"vat":20},{"name":"PLxMZ7ac","amount":1,"price_per_unit":13.48,"price_unit":"LT","price_total":13.48,"vat":10},{"name":"NfIs5RClAdp","amount":2,"price_per_unit":15.53,"price_unit":"LT","price_total":31.06,"vat":10},{"name":"b9jj08Tx8mJ","amount":4,"price_per_unit":7.3,"price_unit":"KG","price_total":29.2,"vat":5},{"name":"RUoH0gpSJoav","amount":4,"price_per_unit":4.16,"price_unit":"unit","price_total":16.64,"vat":5}]}	PENDING	4	39.41
13	400.4	2.45	2022-06-30 20:11:40.566	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"nhCgXM","amount":2,"price_per_unit":19.34,"price_unit":"KG","price_total":38.68,"vat":10},{"name":"NvSvUB","amount":4,"price_per_unit":15.62,"price_unit":"KG","price_total":62.48,"vat":10},{"name":"PFthAqQ","amount":4,"price_per_unit":19,"price_unit":"unit","price_total":76,"vat":5},{"name":"0bjYItN6","amount":2,"price_per_unit":12.46,"price_unit":"KG","price_total":24.92,"vat":20},{"name":"efCQeGKq","amount":3,"price_per_unit":5.88,"price_unit":"unit","price_total":17.64,"vat":10},{"name":"7CwqGZuouh","amount":3,"price_per_unit":18.05,"price_unit":"KG","price_total":54.15,"vat":10},{"name":"RArlwG","amount":1,"price_per_unit":11.32,"price_unit":"unit","price_total":11.32,"vat":20},{"name":"rolwnU","amount":4,"price_per_unit":7.86,"price_unit":"unit","price_total":31.44,"vat":20},{"name":"68HJOt","amount":3,"price_per_unit":6.45,"price_unit":"unit","price_total":19.35,"vat":5},{"name":"ghwb5TOD","amount":4,"price_per_unit":11.64,"price_unit":"LT","price_total":46.56,"vat":5},{"name":"mdOAYPOLci","amount":1,"price_per_unit":15.41,"price_unit":"LT","price_total":15.41,"vat":5}]}	PENDING	4	38.7
14	365.74	1.77	2022-06-30 20:11:40.57	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"2WeSX08fOl1","amount":2,"price_per_unit":8.75,"price_unit":"KG","price_total":17.5,"vat":20},{"name":"VfFs3gyPIB","amount":3,"price_per_unit":18.37,"price_unit":"KG","price_total":55.11,"vat":20},{"name":"7CwqGZuouh","amount":2,"price_per_unit":18.05,"price_unit":"KG","price_total":36.1,"vat":10},{"name":"2yvFTLO5hE8","amount":2,"price_per_unit":12.44,"price_unit":"KG","price_total":24.88,"vat":10},{"name":"majMp8x","amount":2,"price_per_unit":17.44,"price_unit":"KG","price_total":34.88,"vat":5},{"name":"VYbzbwxu7gG","amount":3,"price_per_unit":2.39,"price_unit":"KG","price_total":7.17,"vat":10},{"name":"BEI726rFOop","amount":4,"price_per_unit":2.78,"price_unit":"unit","price_total":11.12,"vat":5},{"name":"rudfljHLA0vs","amount":4,"price_per_unit":13.23,"price_unit":"LT","price_total":52.92,"vat":5},{"name":"PLxMZ7ac","amount":3,"price_per_unit":13.48,"price_unit":"LT","price_total":40.44,"vat":10},{"name":"ysoV02urNI","amount":1,"price_per_unit":5.65,"price_unit":"unit","price_total":5.65,"vat":20},{"name":"7l428YDHXq","amount":1,"price_per_unit":18.56,"price_unit":"unit","price_total":18.56,"vat":20},{"name":"XuI1DRXw1OU","amount":3,"price_per_unit":19.88,"price_unit":"KG","price_total":59.64,"vat":20}]}	DELIVERED	4	47.1
15	261.08	2.87	2022-06-30 20:11:40.574	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"7CwqGZuouh","amount":3,"price_per_unit":18.05,"price_unit":"KG","price_total":54.15,"vat":10},{"name":"fwuPQIHDAUB","amount":1,"price_per_unit":14.61,"price_unit":"unit","price_total":14.61,"vat":10},{"name":"pAWv3U6AIBv","amount":2,"price_per_unit":6.36,"price_unit":"LT","price_total":12.72,"vat":5},{"name":"l4MFHCbB","amount":4,"price_per_unit":17.61,"price_unit":"LT","price_total":70.44,"vat":5},{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"1Mq3UGob85K","amount":1,"price_per_unit":5.03,"price_unit":"LT","price_total":5.03,"vat":20},{"name":"BEI726rFOop","amount":1,"price_per_unit":2.78,"price_unit":"unit","price_total":2.78,"vat":5},{"name":"d9U4mlMeyKk","amount":1,"price_per_unit":10.25,"price_unit":"unit","price_total":10.25,"vat":10},{"name":"pHB0e7","amount":3,"price_per_unit":7.86,"price_unit":"LT","price_total":23.58,"vat":20},{"name":"TdwKPMIs26J","amount":1,"price_per_unit":2.69,"price_unit":"LT","price_total":2.69,"vat":5},{"name":"76MckC","amount":4,"price_per_unit":5.43,"price_unit":"KG","price_total":21.72,"vat":10}]}	PENDING	4	22.24
16	265.88	1.45	2022-06-30 20:11:40.577	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"xjfgqR","amount":2,"price_per_unit":11.15,"price_unit":"KG","price_total":22.3,"vat":5},{"name":"7l428YDHXq","amount":1,"price_per_unit":18.56,"price_unit":"unit","price_total":18.56,"vat":20},{"name":"eAtr3zbznd","amount":4,"price_per_unit":19.18,"price_unit":"LT","price_total":76.72,"vat":10},{"name":"uq9SftZRGyK","amount":2,"price_per_unit":14.37,"price_unit":"LT","price_total":28.74,"vat":10},{"name":"Tdsgh0ePPOhV","amount":2,"price_per_unit":11.38,"price_unit":"KG","price_total":22.76,"vat":20},{"name":"fwuPQIHDAUB","amount":2,"price_per_unit":14.61,"price_unit":"unit","price_total":29.22,"vat":10},{"name":"ysoV02urNI","amount":1,"price_per_unit":5.65,"price_unit":"unit","price_total":5.65,"vat":20},{"name":"HQuWEX","amount":3,"price_per_unit":9.18,"price_unit":"LT","price_total":27.54,"vat":20},{"name":"pHB0e7","amount":1,"price_per_unit":7.86,"price_unit":"LT","price_total":7.86,"vat":20},{"name":"rUXTOB3n","amount":4,"price_per_unit":6.27,"price_unit":"KG","price_total":25.08,"vat":10}]}	DELIVERED	4	33.56
17	320.68	4.01	2022-06-30 20:11:40.581	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"ip1FUPvR","amount":3,"price_per_unit":14.97,"price_unit":"LT","price_total":44.91,"vat":5},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20},{"name":"RUoH0gpSJoav","amount":2,"price_per_unit":4.16,"price_unit":"unit","price_total":8.32,"vat":5},{"name":"spUlXgTtnIij","amount":1,"price_per_unit":17.21,"price_unit":"LT","price_total":17.21,"vat":5},{"name":"d9U4mlMeyKk","amount":1,"price_per_unit":10.25,"price_unit":"unit","price_total":10.25,"vat":10},{"name":"mdOAYPOLci","amount":3,"price_per_unit":15.41,"price_unit":"LT","price_total":46.23,"vat":5},{"name":"4YGGwpWVVo","amount":3,"price_per_unit":13.6,"price_unit":"KG","price_total":40.8,"vat":10},{"name":"PFthAqQ","amount":3,"price_per_unit":19,"price_unit":"unit","price_total":57,"vat":5},{"name":"7EiedwtL","amount":1,"price_per_unit":2.43,"price_unit":"KG","price_total":2.43,"vat":20},{"name":"vVtkhTu2T","amount":4,"price_per_unit":7.31,"price_unit":"unit","price_total":29.24,"vat":10}]}	CANCELLED	4	29.25
18	318.11	4.05	2022-06-30 20:11:40.585	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"AgswyaWl","amount":1,"price_per_unit":11.2,"price_unit":"KG","price_total":11.2,"vat":20},{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"lHmuVGrArEof","amount":3,"price_per_unit":4.74,"price_unit":"KG","price_total":14.22,"vat":5},{"name":"LupuT8","amount":3,"price_per_unit":3.71,"price_unit":"LT","price_total":11.13,"vat":20},{"name":"OOYA8XE","amount":1,"price_per_unit":15.64,"price_unit":"LT","price_total":15.64,"vat":20},{"name":"7EiedwtL","amount":4,"price_per_unit":2.43,"price_unit":"KG","price_total":9.72,"vat":20},{"name":"l4MFHCbB","amount":2,"price_per_unit":17.61,"price_unit":"LT","price_total":35.22,"vat":5},{"name":"1Mq3UGob85K","amount":2,"price_per_unit":5.03,"price_unit":"LT","price_total":10.06,"vat":20},{"name":"alRvuSkv73","amount":1,"price_per_unit":15.07,"price_unit":"KG","price_total":15.07,"vat":20},{"name":"vVMQBD","amount":4,"price_per_unit":18.03,"price_unit":"LT","price_total":72.12,"vat":20},{"name":"efCQeGKq","amount":3,"price_per_unit":5.88,"price_unit":"unit","price_total":17.64,"vat":10},{"name":"SDCpwP0lCCM","amount":4,"price_per_unit":15.45,"price_unit":"unit","price_total":61.8,"vat":5}]}	PENDING	4	38.33
19	471.63	3.95	2022-06-30 20:11:40.588	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"jIm3OhqF","amount":1,"price_per_unit":7.2,"price_unit":"unit","price_total":7.2,"vat":10},{"name":"E8hhHg8Np5","amount":3,"price_per_unit":16.08,"price_unit":"unit","price_total":48.24,"vat":10},{"name":"CYE9r3H","amount":4,"price_per_unit":18.74,"price_unit":"LT","price_total":74.96,"vat":5},{"name":"A0pZ0Q","amount":3,"price_per_unit":4.21,"price_unit":"KG","price_total":12.63,"vat":10},{"name":"OOYA8XE","amount":4,"price_per_unit":15.64,"price_unit":"LT","price_total":62.56,"vat":20},{"name":"aTiARaO","amount":2,"price_per_unit":9.15,"price_unit":"KG","price_total":18.3,"vat":20},{"name":"UfdzXYkfl","amount":4,"price_per_unit":10.6,"price_unit":"unit","price_total":42.4,"vat":20},{"name":"2WeSX08fOl1","amount":1,"price_per_unit":8.75,"price_unit":"KG","price_total":8.75,"vat":20},{"name":"ghwb5TOD","amount":3,"price_per_unit":11.64,"price_unit":"LT","price_total":34.92,"vat":5},{"name":"jHDjVM4","amount":4,"price_per_unit":17.5,"price_unit":"LT","price_total":70,"vat":20},{"name":"TwcKbbx","amount":4,"price_per_unit":18.99,"price_unit":"unit","price_total":75.96,"vat":10},{"name":"Q73GuAi","amount":4,"price_per_unit":2.94,"price_unit":"unit","price_total":11.76,"vat":20}]}	PENDING	5	62.65
20	214.92	3.43	2022-06-30 20:11:40.592	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"TwcKbbx","amount":1,"price_per_unit":18.99,"price_unit":"unit","price_total":18.99,"vat":10},{"name":"qDP8bdZCGE","amount":1,"price_per_unit":11.85,"price_unit":"LT","price_total":11.85,"vat":20},{"name":"IsalJbB2","amount":2,"price_per_unit":7.23,"price_unit":"unit","price_total":14.46,"vat":20},{"name":"xFXXvXXNXR","amount":4,"price_per_unit":4.54,"price_unit":"KG","price_total":18.16,"vat":10},{"name":"pAWv3U6AIBv","amount":2,"price_per_unit":6.36,"price_unit":"LT","price_total":12.72,"vat":5},{"name":"V2R07QhrB","amount":1,"price_per_unit":12.22,"price_unit":"unit","price_total":12.22,"vat":10},{"name":"BEI726rFOop","amount":2,"price_per_unit":2.78,"price_unit":"unit","price_total":5.56,"vat":5},{"name":"Tdsgh0ePPOhV","amount":2,"price_per_unit":11.38,"price_unit":"KG","price_total":22.76,"vat":20},{"name":"Q73GuAi","amount":1,"price_per_unit":2.94,"price_unit":"unit","price_total":2.94,"vat":20},{"name":"ip1FUPvR","amount":3,"price_per_unit":14.97,"price_unit":"LT","price_total":44.91,"vat":5},{"name":"OOYA8XE","amount":3,"price_per_unit":15.64,"price_unit":"LT","price_total":46.92,"vat":20}]}	DELIVERED	5	27.88
21	305.79	1.97	2022-06-30 20:11:40.595	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"TwcKbbx","amount":2,"price_per_unit":18.99,"price_unit":"unit","price_total":37.98,"vat":10},{"name":"1Zy58y3co3AY","amount":3,"price_per_unit":10.56,"price_unit":"LT","price_total":31.68,"vat":20},{"name":"Qt2JzeR","amount":4,"price_per_unit":2.98,"price_unit":"unit","price_total":11.92,"vat":20},{"name":"8ownjVQ1UD2Q","amount":3,"price_per_unit":17.96,"price_unit":"KG","price_total":53.88,"vat":20},{"name":"pHB0e7","amount":2,"price_per_unit":7.86,"price_unit":"LT","price_total":15.72,"vat":20},{"name":"HQuWEX","amount":4,"price_per_unit":9.18,"price_unit":"LT","price_total":36.72,"vat":20},{"name":"nhCgXM","amount":1,"price_per_unit":19.34,"price_unit":"KG","price_total":19.34,"vat":10},{"name":"x0LHbTf","amount":1,"price_per_unit":13.9,"price_unit":"LT","price_total":13.9,"vat":20},{"name":"GmeStIiA","amount":4,"price_per_unit":4.49,"price_unit":"LT","price_total":17.96,"vat":5},{"name":"rudfljHLA0vs","amount":3,"price_per_unit":13.23,"price_unit":"LT","price_total":39.69,"vat":5},{"name":"Ndoe31Yme","amount":2,"price_per_unit":3.33,"price_unit":"unit","price_total":6.66,"vat":10},{"name":"VfFs3gyPIB","amount":1,"price_per_unit":18.37,"price_unit":"KG","price_total":18.37,"vat":20}]}	DELIVERED	5	45.72
22	389.73	4.18	2022-06-30 20:11:40.599	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"spUlXgTtnIij","amount":4,"price_per_unit":17.21,"price_unit":"LT","price_total":68.84,"vat":5},{"name":"LgxBPswCt","amount":4,"price_per_unit":9.28,"price_unit":"KG","price_total":37.12,"vat":20},{"name":"rudfljHLA0vs","amount":4,"price_per_unit":13.23,"price_unit":"LT","price_total":52.92,"vat":5},{"name":"vVMQBD","amount":4,"price_per_unit":18.03,"price_unit":"LT","price_total":72.12,"vat":20},{"name":"hePxXVVV8","amount":3,"price_per_unit":16.07,"price_unit":"LT","price_total":48.21,"vat":20},{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"MDAFOZvCp","amount":1,"price_per_unit":11.3,"price_unit":"KG","price_total":11.3,"vat":5},{"name":"lHmuVGrArEof","amount":1,"price_per_unit":4.74,"price_unit":"KG","price_total":4.74,"vat":5},{"name":"UfdzXYkfl","amount":1,"price_per_unit":10.6,"price_unit":"unit","price_total":10.6,"vat":20},{"name":"Qt2JzeR","amount":4,"price_per_unit":2.98,"price_unit":"unit","price_total":11.92,"vat":20},{"name":"7VnurlD5f7W","amount":2,"price_per_unit":13.77,"price_unit":"unit","price_total":27.54,"vat":20}]}	PENDING	5	50.4
23	354.26	4.9	2022-06-30 20:11:40.603	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"UfdzXYkfl","amount":4,"price_per_unit":10.6,"price_unit":"unit","price_total":42.4,"vat":20},{"name":"17C8Be1RxUd","amount":3,"price_per_unit":3.56,"price_unit":"unit","price_total":10.68,"vat":20},{"name":"xjfgqR","amount":2,"price_per_unit":11.15,"price_unit":"KG","price_total":22.3,"vat":5},{"name":"aaT7fpX0wQ","amount":2,"price_per_unit":16.51,"price_unit":"KG","price_total":33.02,"vat":10},{"name":"MDAFOZvCp","amount":4,"price_per_unit":11.3,"price_unit":"KG","price_total":45.2,"vat":5},{"name":"jdTxMCwbjMV","amount":4,"price_per_unit":15.75,"price_unit":"unit","price_total":63,"vat":5},{"name":"NfIs5RClAdp","amount":2,"price_per_unit":15.53,"price_unit":"LT","price_total":31.06,"vat":10},{"name":"nhCgXM","amount":2,"price_per_unit":19.34,"price_unit":"KG","price_total":38.68,"vat":10},{"name":"hePxXVVV8","amount":1,"price_per_unit":16.07,"price_unit":"LT","price_total":16.07,"vat":20},{"name":"majMp8x","amount":1,"price_per_unit":17.44,"price_unit":"KG","price_total":17.44,"vat":5},{"name":"68HJOt","amount":4,"price_per_unit":6.45,"price_unit":"unit","price_total":25.8,"vat":5},{"name":"LupuT8","amount":1,"price_per_unit":3.71,"price_unit":"LT","price_total":3.71,"vat":20}]}	PENDING	5	33.54
24	266.38	3.77	2022-06-30 20:11:40.606	{"shipping_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"BWrYrw5","amount":2,"price_per_unit":13.97,"price_unit":"KG","price_total":27.94,"vat":10},{"name":"rolwnU","amount":1,"price_per_unit":7.86,"price_unit":"unit","price_total":7.86,"vat":20},{"name":"GmeStIiA","amount":2,"price_per_unit":4.49,"price_unit":"LT","price_total":8.98,"vat":5},{"name":"A0pZ0Q","amount":2,"price_per_unit":4.21,"price_unit":"KG","price_total":8.42,"vat":10},{"name":"76MckC","amount":3,"price_per_unit":5.43,"price_unit":"KG","price_total":16.29,"vat":10},{"name":"x0LHbTf","amount":3,"price_per_unit":13.9,"price_unit":"LT","price_total":41.7,"vat":20},{"name":"spUlXgTtnIij","amount":1,"price_per_unit":17.21,"price_unit":"LT","price_total":17.21,"vat":5},{"name":"Tdsgh0ePPOhV","amount":1,"price_per_unit":11.38,"price_unit":"KG","price_total":11.38,"vat":20},{"name":"dDEmvtXHh8","amount":4,"price_per_unit":3.08,"price_unit":"KG","price_total":12.32,"vat":5},{"name":"1Mq3UGob85K","amount":3,"price_per_unit":5.03,"price_unit":"LT","price_total":15.09,"vat":20},{"name":"2yvFTLO5hE8","amount":4,"price_per_unit":12.44,"price_unit":"KG","price_total":49.76,"vat":10},{"name":"gT2623mTZ2Sy","amount":3,"price_per_unit":15.22,"price_unit":"KG","price_total":45.66,"vat":20}]}	DELIVERED	5	36.5
\.


--
-- Data for Name: receipts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipts (receipt_id, price_total, vat_total, datetime, payment_method, archive, status, order_id, payment_account) FROM stdin;
1	445.63	53.91	2022-06-30 20:11:40.496	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"IsalJbB2","amount":2,"price_per_unit":7.23,"price_unit":"unit","price_total":14.46,"vat":20},{"name":"efCQeGKq","amount":2,"price_per_unit":5.88,"price_unit":"unit","price_total":11.76,"vat":10},{"name":"PFthAqQ","amount":4,"price_per_unit":19,"price_unit":"unit","price_total":76,"vat":5},{"name":"nhCgXM","amount":4,"price_per_unit":19.34,"price_unit":"KG","price_total":77.36,"vat":10},{"name":"cbNidJ8","amount":3,"price_per_unit":5.97,"price_unit":"LT","price_total":17.91,"vat":20},{"name":"HQuWEX","amount":2,"price_per_unit":9.18,"price_unit":"LT","price_total":18.36,"vat":20},{"name":"9vyGFL","amount":4,"price_per_unit":13.02,"price_unit":"unit","price_total":52.08,"vat":20},{"name":"TdwKPMIs26J","amount":3,"price_per_unit":2.69,"price_unit":"LT","price_total":8.07,"vat":5},{"name":"TwcKbbx","amount":3,"price_per_unit":18.99,"price_unit":"unit","price_total":56.97,"vat":10},{"name":"jdTxMCwbjMV","amount":3,"price_per_unit":15.75,"price_unit":"unit","price_total":47.25,"vat":5},{"name":"gT2623mTZ2Sy","amount":4,"price_per_unit":15.22,"price_unit":"KG","price_total":60.88,"vat":20}]}	COMPLETED	1	XXXX XXXX XXXX 5323
2	263.5	38.45	2022-06-30 20:11:40.521	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"RUoH0gpSJoav","amount":1,"price_per_unit":4.16,"price_unit":"unit","price_total":4.16,"vat":5},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20},{"name":"rUXTOB3n","amount":2,"price_per_unit":6.27,"price_unit":"KG","price_total":12.54,"vat":10},{"name":"IsalJbB2","amount":3,"price_per_unit":7.23,"price_unit":"unit","price_total":21.69,"vat":20},{"name":"d9U4mlMeyKk","amount":2,"price_per_unit":10.25,"price_unit":"unit","price_total":20.5,"vat":10},{"name":"UsGIDLCqii","amount":2,"price_per_unit":3.59,"price_unit":"LT","price_total":7.18,"vat":10},{"name":"CYE9r3H","amount":2,"price_per_unit":18.74,"price_unit":"LT","price_total":37.48,"vat":5},{"name":"qDuuIC3","amount":4,"price_per_unit":14.12,"price_unit":"unit","price_total":56.48,"vat":20},{"name":"lHmuVGrArEof","amount":2,"price_per_unit":4.74,"price_unit":"KG","price_total":9.48,"vat":5},{"name":"jdTxMCwbjMV","amount":1,"price_per_unit":15.75,"price_unit":"unit","price_total":15.75,"vat":5},{"name":"ysoV02urNI","amount":3,"price_per_unit":5.65,"price_unit":"unit","price_total":16.95,"vat":20}]}	COMPLETED	2	XXXX XXXX XXXX 8982
3	386.68	49.05	2022-06-30 20:11:40.525	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"BWrYrw5","amount":3,"price_per_unit":13.97,"price_unit":"KG","price_total":41.91,"vat":10},{"name":"IsalJbB2","amount":3,"price_per_unit":7.23,"price_unit":"unit","price_total":21.69,"vat":20},{"name":"qDP8bdZCGE","amount":4,"price_per_unit":11.85,"price_unit":"LT","price_total":47.4,"vat":20},{"name":"uq9SftZRGyK","amount":4,"price_per_unit":14.37,"price_unit":"LT","price_total":57.48,"vat":10},{"name":"fwuPQIHDAUB","amount":2,"price_per_unit":14.61,"price_unit":"unit","price_total":29.22,"vat":10},{"name":"b9jj08Tx8mJ","amount":3,"price_per_unit":7.3,"price_unit":"KG","price_total":21.9,"vat":5},{"name":"rUXTOB3n","amount":1,"price_per_unit":6.27,"price_unit":"KG","price_total":6.27,"vat":10},{"name":"7EiedwtL","amount":4,"price_per_unit":2.43,"price_unit":"KG","price_total":9.72,"vat":20},{"name":"gT2623mTZ2Sy","amount":2,"price_per_unit":15.22,"price_unit":"KG","price_total":30.44,"vat":20},{"name":"mdOAYPOLci","amount":3,"price_per_unit":15.41,"price_unit":"LT","price_total":46.23,"vat":5},{"name":"fERBI3NCG","amount":3,"price_per_unit":7.98,"price_unit":"LT","price_total":23.94,"vat":5},{"name":"Tdsgh0ePPOhV","amount":4,"price_per_unit":11.38,"price_unit":"KG","price_total":45.52,"vat":20}]}	COMPLETED	3	XXXX XXXX XXXX 5181
4	338.81	47.05	2022-06-30 20:11:40.529	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"efCQeGKq","amount":1,"price_per_unit":5.88,"price_unit":"unit","price_total":5.88,"vat":10},{"name":"hePxXVVV8","amount":4,"price_per_unit":16.07,"price_unit":"LT","price_total":64.28,"vat":20},{"name":"76MckC","amount":2,"price_per_unit":5.43,"price_unit":"KG","price_total":10.86,"vat":10},{"name":"rolwnU","amount":3,"price_per_unit":7.86,"price_unit":"unit","price_total":23.58,"vat":20},{"name":"nhCgXM","amount":4,"price_per_unit":19.34,"price_unit":"KG","price_total":77.36,"vat":10},{"name":"dDEmvtXHh8","amount":2,"price_per_unit":3.08,"price_unit":"KG","price_total":6.16,"vat":5},{"name":"7CwqGZuouh","amount":2,"price_per_unit":18.05,"price_unit":"KG","price_total":36.1,"vat":10},{"name":"7EiedwtL","amount":4,"price_per_unit":2.43,"price_unit":"KG","price_total":9.72,"vat":20},{"name":"BEI726rFOop","amount":1,"price_per_unit":2.78,"price_unit":"unit","price_total":2.78,"vat":5},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20}]}	REFUNDED	4	simone.bartoli01@gmail.com
5	297.18	42.92	2022-06-30 20:11:40.533	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"2yvFTLO5hE8","amount":2,"price_per_unit":12.44,"price_unit":"KG","price_total":24.88,"vat":10},{"name":"MEzPczUQuF","amount":3,"price_per_unit":10.01,"price_unit":"unit","price_total":30.03,"vat":20},{"name":"x0LHbTf","amount":3,"price_per_unit":13.9,"price_unit":"LT","price_total":41.7,"vat":20},{"name":"0bjYItN6","amount":4,"price_per_unit":12.46,"price_unit":"KG","price_total":49.84,"vat":20},{"name":"ip1FUPvR","amount":2,"price_per_unit":14.97,"price_unit":"LT","price_total":29.94,"vat":5},{"name":"BEI726rFOop","amount":1,"price_per_unit":2.78,"price_unit":"unit","price_total":2.78,"vat":5},{"name":"aaT7fpX0wQ","amount":4,"price_per_unit":16.51,"price_unit":"KG","price_total":66.04,"vat":10},{"name":"d9U4mlMeyKk","amount":1,"price_per_unit":10.25,"price_unit":"unit","price_total":10.25,"vat":10},{"name":"VfFs3gyPIB","amount":1,"price_per_unit":18.37,"price_unit":"KG","price_total":18.37,"vat":20},{"name":"VYbzbwxu7gG","amount":4,"price_per_unit":2.39,"price_unit":"KG","price_total":9.56,"vat":10},{"name":"LupuT8","amount":3,"price_per_unit":3.71,"price_unit":"LT","price_total":11.13,"vat":20}]}	COMPLETED	5	simone.bartoli01@gmail.com
6	329.27	32.9	2022-06-30 20:11:40.537	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"rolwnU","amount":4,"price_per_unit":7.86,"price_unit":"unit","price_total":31.44,"vat":20},{"name":"9EbG3Az","amount":1,"price_per_unit":2.23,"price_unit":"KG","price_total":2.23,"vat":5},{"name":"tXjwhKL","amount":3,"price_per_unit":13.49,"price_unit":"LT","price_total":40.47,"vat":5},{"name":"RArlwG","amount":4,"price_per_unit":11.32,"price_unit":"unit","price_total":45.28,"vat":20},{"name":"GmeStIiA","amount":4,"price_per_unit":4.49,"price_unit":"LT","price_total":17.96,"vat":5},{"name":"majMp8x","amount":4,"price_per_unit":17.44,"price_unit":"KG","price_total":69.76,"vat":5},{"name":"BEI726rFOop","amount":2,"price_per_unit":2.78,"price_unit":"unit","price_total":5.56,"vat":5},{"name":"rudfljHLA0vs","amount":3,"price_per_unit":13.23,"price_unit":"LT","price_total":39.69,"vat":5},{"name":"1Mq3UGob85K","amount":3,"price_per_unit":5.03,"price_unit":"LT","price_total":15.09,"vat":20},{"name":"eAtr3zbznd","amount":3,"price_per_unit":19.18,"price_unit":"LT","price_total":57.54,"vat":10}]}	COMPLETED	6	simone.bartoli01@gmail.com
7	140.24	11.88	2022-06-30 20:11:40.542	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"efCQeGKq","amount":1,"price_per_unit":5.88,"price_unit":"unit","price_total":5.88,"vat":10},{"name":"ysoV02urNI","amount":1,"price_per_unit":5.65,"price_unit":"unit","price_total":5.65,"vat":20},{"name":"GmeStIiA","amount":4,"price_per_unit":4.49,"price_unit":"LT","price_total":17.96,"vat":5},{"name":"NfIs5RClAdp","amount":2,"price_per_unit":15.53,"price_unit":"LT","price_total":31.06,"vat":10},{"name":"tXjwhKL","amount":1,"price_per_unit":13.49,"price_unit":"LT","price_total":13.49,"vat":5},{"name":"qDP8bdZCGE","amount":1,"price_per_unit":11.85,"price_unit":"LT","price_total":11.85,"vat":20},{"name":"76MckC","amount":1,"price_per_unit":5.43,"price_unit":"KG","price_total":5.43,"vat":10},{"name":"dDEmvtXHh8","amount":2,"price_per_unit":3.08,"price_unit":"KG","price_total":6.16,"vat":5},{"name":"SDCpwP0lCCM","amount":2,"price_per_unit":15.45,"price_unit":"unit","price_total":30.9,"vat":5},{"name":"jIm3OhqF","amount":1,"price_per_unit":7.2,"price_unit":"unit","price_total":7.2,"vat":10}]}	COMPLETED	7	XXXX XXXX XXXX 9616
8	345.48	28.4	2022-06-30 20:11:40.546	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"l4MFHCbB","amount":1,"price_per_unit":17.61,"price_unit":"LT","price_total":17.61,"vat":5},{"name":"pHB0e7","amount":2,"price_per_unit":7.86,"price_unit":"LT","price_total":15.72,"vat":20},{"name":"Ndoe31Yme","amount":3,"price_per_unit":3.33,"price_unit":"unit","price_total":9.99,"vat":10},{"name":"UsGIDLCqii","amount":3,"price_per_unit":3.59,"price_unit":"LT","price_total":10.77,"vat":10},{"name":"DeepzB7DCn9E","amount":2,"price_per_unit":18.87,"price_unit":"LT","price_total":37.74,"vat":5},{"name":"aaT7fpX0wQ","amount":3,"price_per_unit":16.51,"price_unit":"KG","price_total":49.53,"vat":10},{"name":"XZDbDf9dvrA","amount":3,"price_per_unit":19.53,"price_unit":"KG","price_total":58.59,"vat":5},{"name":"4YGGwpWVVo","amount":3,"price_per_unit":13.6,"price_unit":"KG","price_total":40.8,"vat":10},{"name":"VYbzbwxu7gG","amount":2,"price_per_unit":2.39,"price_unit":"KG","price_total":4.78,"vat":10},{"name":"1teuGYJ4JHmM","amount":1,"price_per_unit":18.05,"price_unit":"unit","price_total":18.05,"vat":5},{"name":"XuI1DRXw1OU","amount":1,"price_per_unit":19.88,"price_unit":"KG","price_total":19.88,"vat":20},{"name":"SDCpwP0lCCM","amount":4,"price_per_unit":15.45,"price_unit":"unit","price_total":61.8,"vat":5}]}	COMPLETED	8	simone.bartoli01@gmail.com
9	300.04	41.32	2022-06-30 20:11:40.552	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"pAWv3U6AIBv","amount":1,"price_per_unit":6.36,"price_unit":"LT","price_total":6.36,"vat":5},{"name":"qDP8bdZCGE","amount":4,"price_per_unit":11.85,"price_unit":"LT","price_total":47.4,"vat":20},{"name":"lHmuVGrArEof","amount":1,"price_per_unit":4.74,"price_unit":"KG","price_total":4.74,"vat":5},{"name":"mdOAYPOLci","amount":2,"price_per_unit":15.41,"price_unit":"LT","price_total":30.82,"vat":5},{"name":"Q73GuAi","amount":1,"price_per_unit":2.94,"price_unit":"unit","price_total":2.94,"vat":20},{"name":"Tdsgh0ePPOhV","amount":2,"price_per_unit":11.38,"price_unit":"KG","price_total":22.76,"vat":20},{"name":"aaT7fpX0wQ","amount":4,"price_per_unit":16.51,"price_unit":"KG","price_total":66.04,"vat":10},{"name":"1teuGYJ4JHmM","amount":2,"price_per_unit":18.05,"price_unit":"unit","price_total":36.1,"vat":5},{"name":"0bjYItN6","amount":4,"price_per_unit":12.46,"price_unit":"KG","price_total":49.84,"vat":20},{"name":"NRr1ExTXeh","amount":2,"price_per_unit":15.56,"price_unit":"KG","price_total":31.12,"vat":20}]}	COMPLETED	9	XXXX XXXX XXXX 9696
10	416.78	67.03	2022-06-30 20:11:40.555	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"TwcKbbx","amount":1,"price_per_unit":18.99,"price_unit":"unit","price_total":18.99,"vat":10},{"name":"2yvFTLO5hE8","amount":1,"price_per_unit":12.44,"price_unit":"KG","price_total":12.44,"vat":10},{"name":"gT2623mTZ2Sy","amount":3,"price_per_unit":15.22,"price_unit":"KG","price_total":45.66,"vat":20},{"name":"vVMQBD","amount":4,"price_per_unit":18.03,"price_unit":"LT","price_total":72.12,"vat":20},{"name":"jF1H5rhapH","amount":3,"price_per_unit":5.71,"price_unit":"LT","price_total":17.13,"vat":10},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20},{"name":"cbNidJ8","amount":2,"price_per_unit":5.97,"price_unit":"LT","price_total":11.94,"vat":20},{"name":"DeepzB7DCn9E","amount":4,"price_per_unit":18.87,"price_unit":"LT","price_total":75.48,"vat":5},{"name":"pHB0e7","amount":3,"price_per_unit":7.86,"price_unit":"LT","price_total":23.58,"vat":20},{"name":"hePxXVVV8","amount":4,"price_per_unit":16.07,"price_unit":"LT","price_total":64.28,"vat":20},{"name":"qDuuIC3","amount":1,"price_per_unit":14.12,"price_unit":"unit","price_total":14.12,"vat":20}]}	COMPLETED	10	XXXX XXXX XXXX 8785
11	341.29	35.92	2022-06-30 20:11:40.559	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"7EiedwtL","amount":2,"price_per_unit":2.43,"price_unit":"KG","price_total":4.86,"vat":20},{"name":"tXjwhKL","amount":4,"price_per_unit":13.49,"price_unit":"LT","price_total":53.96,"vat":5},{"name":"76MckC","amount":3,"price_per_unit":5.43,"price_unit":"KG","price_total":16.29,"vat":10},{"name":"XZDbDf9dvrA","amount":2,"price_per_unit":19.53,"price_unit":"KG","price_total":39.06,"vat":5},{"name":"LgxBPswCt","amount":3,"price_per_unit":9.28,"price_unit":"KG","price_total":27.84,"vat":20},{"name":"rolwnU","amount":1,"price_per_unit":7.86,"price_unit":"unit","price_total":7.86,"vat":20},{"name":"TwcKbbx","amount":4,"price_per_unit":18.99,"price_unit":"unit","price_total":75.96,"vat":10},{"name":"2WeSX08fOl1","amount":2,"price_per_unit":8.75,"price_unit":"KG","price_total":17.5,"vat":20},{"name":"b9jj08Tx8mJ","amount":1,"price_per_unit":7.3,"price_unit":"KG","price_total":7.3,"vat":5},{"name":"7CwqGZuouh","amount":4,"price_per_unit":18.05,"price_unit":"KG","price_total":72.2,"vat":10},{"name":"17C8Be1RxUd","amount":4,"price_per_unit":3.56,"price_unit":"unit","price_total":14.24,"vat":20}]}	COMPLETED	11	simone.bartoli01@gmail.com
12	394.46	39.41	2022-06-30 20:11:40.563	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"dDEmvtXHh8","amount":1,"price_per_unit":3.08,"price_unit":"KG","price_total":3.08,"vat":5},{"name":"vVtkhTu2T","amount":2,"price_per_unit":7.31,"price_unit":"unit","price_total":14.62,"vat":10},{"name":"fwuPQIHDAUB","amount":3,"price_per_unit":14.61,"price_unit":"unit","price_total":43.83,"vat":10},{"name":"Ugm2MvBb","amount":3,"price_per_unit":18.82,"price_unit":"LT","price_total":56.46,"vat":10},{"name":"TwcKbbx","amount":4,"price_per_unit":18.99,"price_unit":"unit","price_total":75.96,"vat":10},{"name":"rudfljHLA0vs","amount":4,"price_per_unit":13.23,"price_unit":"LT","price_total":52.92,"vat":5},{"name":"8ownjVQ1UD2Q","amount":3,"price_per_unit":17.96,"price_unit":"KG","price_total":53.88,"vat":20},{"name":"PLxMZ7ac","amount":1,"price_per_unit":13.48,"price_unit":"LT","price_total":13.48,"vat":10},{"name":"NfIs5RClAdp","amount":2,"price_per_unit":15.53,"price_unit":"LT","price_total":31.06,"vat":10},{"name":"b9jj08Tx8mJ","amount":4,"price_per_unit":7.3,"price_unit":"KG","price_total":29.2,"vat":5},{"name":"RUoH0gpSJoav","amount":4,"price_per_unit":4.16,"price_unit":"unit","price_total":16.64,"vat":5}]}	COMPLETED	12	XXXX XXXX XXXX 5834
13	400.4	38.7	2022-06-30 20:11:40.566	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"nhCgXM","amount":2,"price_per_unit":19.34,"price_unit":"KG","price_total":38.68,"vat":10},{"name":"NvSvUB","amount":4,"price_per_unit":15.62,"price_unit":"KG","price_total":62.48,"vat":10},{"name":"PFthAqQ","amount":4,"price_per_unit":19,"price_unit":"unit","price_total":76,"vat":5},{"name":"0bjYItN6","amount":2,"price_per_unit":12.46,"price_unit":"KG","price_total":24.92,"vat":20},{"name":"efCQeGKq","amount":3,"price_per_unit":5.88,"price_unit":"unit","price_total":17.64,"vat":10},{"name":"7CwqGZuouh","amount":3,"price_per_unit":18.05,"price_unit":"KG","price_total":54.15,"vat":10},{"name":"RArlwG","amount":1,"price_per_unit":11.32,"price_unit":"unit","price_total":11.32,"vat":20},{"name":"rolwnU","amount":4,"price_per_unit":7.86,"price_unit":"unit","price_total":31.44,"vat":20},{"name":"68HJOt","amount":3,"price_per_unit":6.45,"price_unit":"unit","price_total":19.35,"vat":5},{"name":"ghwb5TOD","amount":4,"price_per_unit":11.64,"price_unit":"LT","price_total":46.56,"vat":5},{"name":"mdOAYPOLci","amount":1,"price_per_unit":15.41,"price_unit":"LT","price_total":15.41,"vat":5}]}	COMPLETED	13	simone.bartoli01@gmail.com
14	365.74	47.1	2022-06-30 20:11:40.57	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"2WeSX08fOl1","amount":2,"price_per_unit":8.75,"price_unit":"KG","price_total":17.5,"vat":20},{"name":"VfFs3gyPIB","amount":3,"price_per_unit":18.37,"price_unit":"KG","price_total":55.11,"vat":20},{"name":"7CwqGZuouh","amount":2,"price_per_unit":18.05,"price_unit":"KG","price_total":36.1,"vat":10},{"name":"2yvFTLO5hE8","amount":2,"price_per_unit":12.44,"price_unit":"KG","price_total":24.88,"vat":10},{"name":"majMp8x","amount":2,"price_per_unit":17.44,"price_unit":"KG","price_total":34.88,"vat":5},{"name":"VYbzbwxu7gG","amount":3,"price_per_unit":2.39,"price_unit":"KG","price_total":7.17,"vat":10},{"name":"BEI726rFOop","amount":4,"price_per_unit":2.78,"price_unit":"unit","price_total":11.12,"vat":5},{"name":"rudfljHLA0vs","amount":4,"price_per_unit":13.23,"price_unit":"LT","price_total":52.92,"vat":5},{"name":"PLxMZ7ac","amount":3,"price_per_unit":13.48,"price_unit":"LT","price_total":40.44,"vat":10},{"name":"ysoV02urNI","amount":1,"price_per_unit":5.65,"price_unit":"unit","price_total":5.65,"vat":20},{"name":"7l428YDHXq","amount":1,"price_per_unit":18.56,"price_unit":"unit","price_total":18.56,"vat":20},{"name":"XuI1DRXw1OU","amount":3,"price_per_unit":19.88,"price_unit":"KG","price_total":59.64,"vat":20}]}	COMPLETED	14	XXXX XXXX XXXX 6256
15	261.08	22.24	2022-06-30 20:11:40.574	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"7CwqGZuouh","amount":3,"price_per_unit":18.05,"price_unit":"KG","price_total":54.15,"vat":10},{"name":"fwuPQIHDAUB","amount":1,"price_per_unit":14.61,"price_unit":"unit","price_total":14.61,"vat":10},{"name":"pAWv3U6AIBv","amount":2,"price_per_unit":6.36,"price_unit":"LT","price_total":12.72,"vat":5},{"name":"l4MFHCbB","amount":4,"price_per_unit":17.61,"price_unit":"LT","price_total":70.44,"vat":5},{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"1Mq3UGob85K","amount":1,"price_per_unit":5.03,"price_unit":"LT","price_total":5.03,"vat":20},{"name":"BEI726rFOop","amount":1,"price_per_unit":2.78,"price_unit":"unit","price_total":2.78,"vat":5},{"name":"d9U4mlMeyKk","amount":1,"price_per_unit":10.25,"price_unit":"unit","price_total":10.25,"vat":10},{"name":"pHB0e7","amount":3,"price_per_unit":7.86,"price_unit":"LT","price_total":23.58,"vat":20},{"name":"TdwKPMIs26J","amount":1,"price_per_unit":2.69,"price_unit":"LT","price_total":2.69,"vat":5},{"name":"76MckC","amount":4,"price_per_unit":5.43,"price_unit":"KG","price_total":21.72,"vat":10}]}	COMPLETED	15	XXXX XXXX XXXX 8420
16	265.88	33.56	2022-06-30 20:11:40.577	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"xjfgqR","amount":2,"price_per_unit":11.15,"price_unit":"KG","price_total":22.3,"vat":5},{"name":"7l428YDHXq","amount":1,"price_per_unit":18.56,"price_unit":"unit","price_total":18.56,"vat":20},{"name":"eAtr3zbznd","amount":4,"price_per_unit":19.18,"price_unit":"LT","price_total":76.72,"vat":10},{"name":"uq9SftZRGyK","amount":2,"price_per_unit":14.37,"price_unit":"LT","price_total":28.74,"vat":10},{"name":"Tdsgh0ePPOhV","amount":2,"price_per_unit":11.38,"price_unit":"KG","price_total":22.76,"vat":20},{"name":"fwuPQIHDAUB","amount":2,"price_per_unit":14.61,"price_unit":"unit","price_total":29.22,"vat":10},{"name":"ysoV02urNI","amount":1,"price_per_unit":5.65,"price_unit":"unit","price_total":5.65,"vat":20},{"name":"HQuWEX","amount":3,"price_per_unit":9.18,"price_unit":"LT","price_total":27.54,"vat":20},{"name":"pHB0e7","amount":1,"price_per_unit":7.86,"price_unit":"LT","price_total":7.86,"vat":20},{"name":"rUXTOB3n","amount":4,"price_per_unit":6.27,"price_unit":"KG","price_total":25.08,"vat":10}]}	COMPLETED	16	XXXX XXXX XXXX 5866
17	320.68	29.25	2022-06-30 20:11:40.581	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"ip1FUPvR","amount":3,"price_per_unit":14.97,"price_unit":"LT","price_total":44.91,"vat":5},{"name":"alRvuSkv73","amount":4,"price_per_unit":15.07,"price_unit":"KG","price_total":60.28,"vat":20},{"name":"RUoH0gpSJoav","amount":2,"price_per_unit":4.16,"price_unit":"unit","price_total":8.32,"vat":5},{"name":"spUlXgTtnIij","amount":1,"price_per_unit":17.21,"price_unit":"LT","price_total":17.21,"vat":5},{"name":"d9U4mlMeyKk","amount":1,"price_per_unit":10.25,"price_unit":"unit","price_total":10.25,"vat":10},{"name":"mdOAYPOLci","amount":3,"price_per_unit":15.41,"price_unit":"LT","price_total":46.23,"vat":5},{"name":"4YGGwpWVVo","amount":3,"price_per_unit":13.6,"price_unit":"KG","price_total":40.8,"vat":10},{"name":"PFthAqQ","amount":3,"price_per_unit":19,"price_unit":"unit","price_total":57,"vat":5},{"name":"7EiedwtL","amount":1,"price_per_unit":2.43,"price_unit":"KG","price_total":2.43,"vat":20},{"name":"vVtkhTu2T","amount":4,"price_per_unit":7.31,"price_unit":"unit","price_total":29.24,"vat":10}]}	REFUNDED	17	simone.bartoli01@gmail.com
18	318.11	38.33	2022-06-30 20:11:40.585	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"AgswyaWl","amount":1,"price_per_unit":11.2,"price_unit":"KG","price_total":11.2,"vat":20},{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"lHmuVGrArEof","amount":3,"price_per_unit":4.74,"price_unit":"KG","price_total":14.22,"vat":5},{"name":"LupuT8","amount":3,"price_per_unit":3.71,"price_unit":"LT","price_total":11.13,"vat":20},{"name":"OOYA8XE","amount":1,"price_per_unit":15.64,"price_unit":"LT","price_total":15.64,"vat":20},{"name":"7EiedwtL","amount":4,"price_per_unit":2.43,"price_unit":"KG","price_total":9.72,"vat":20},{"name":"l4MFHCbB","amount":2,"price_per_unit":17.61,"price_unit":"LT","price_total":35.22,"vat":5},{"name":"1Mq3UGob85K","amount":2,"price_per_unit":5.03,"price_unit":"LT","price_total":10.06,"vat":20},{"name":"alRvuSkv73","amount":1,"price_per_unit":15.07,"price_unit":"KG","price_total":15.07,"vat":20},{"name":"vVMQBD","amount":4,"price_per_unit":18.03,"price_unit":"LT","price_total":72.12,"vat":20},{"name":"efCQeGKq","amount":3,"price_per_unit":5.88,"price_unit":"unit","price_total":17.64,"vat":10},{"name":"SDCpwP0lCCM","amount":4,"price_per_unit":15.45,"price_unit":"unit","price_total":61.8,"vat":5}]}	COMPLETED	18	XXXX XXXX XXXX 8349
19	471.63	62.65	2022-06-30 20:11:40.588	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"jIm3OhqF","amount":1,"price_per_unit":7.2,"price_unit":"unit","price_total":7.2,"vat":10},{"name":"E8hhHg8Np5","amount":3,"price_per_unit":16.08,"price_unit":"unit","price_total":48.24,"vat":10},{"name":"CYE9r3H","amount":4,"price_per_unit":18.74,"price_unit":"LT","price_total":74.96,"vat":5},{"name":"A0pZ0Q","amount":3,"price_per_unit":4.21,"price_unit":"KG","price_total":12.63,"vat":10},{"name":"OOYA8XE","amount":4,"price_per_unit":15.64,"price_unit":"LT","price_total":62.56,"vat":20},{"name":"aTiARaO","amount":2,"price_per_unit":9.15,"price_unit":"KG","price_total":18.3,"vat":20},{"name":"UfdzXYkfl","amount":4,"price_per_unit":10.6,"price_unit":"unit","price_total":42.4,"vat":20},{"name":"2WeSX08fOl1","amount":1,"price_per_unit":8.75,"price_unit":"KG","price_total":8.75,"vat":20},{"name":"ghwb5TOD","amount":3,"price_per_unit":11.64,"price_unit":"LT","price_total":34.92,"vat":5},{"name":"jHDjVM4","amount":4,"price_per_unit":17.5,"price_unit":"LT","price_total":70,"vat":20},{"name":"TwcKbbx","amount":4,"price_per_unit":18.99,"price_unit":"unit","price_total":75.96,"vat":10},{"name":"Q73GuAi","amount":4,"price_per_unit":2.94,"price_unit":"unit","price_total":11.76,"vat":20}]}	COMPLETED	19	simone.bartoli01@gmail.com
20	214.92	27.88	2022-06-30 20:11:40.592	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"TwcKbbx","amount":1,"price_per_unit":18.99,"price_unit":"unit","price_total":18.99,"vat":10},{"name":"qDP8bdZCGE","amount":1,"price_per_unit":11.85,"price_unit":"LT","price_total":11.85,"vat":20},{"name":"IsalJbB2","amount":2,"price_per_unit":7.23,"price_unit":"unit","price_total":14.46,"vat":20},{"name":"xFXXvXXNXR","amount":4,"price_per_unit":4.54,"price_unit":"KG","price_total":18.16,"vat":10},{"name":"pAWv3U6AIBv","amount":2,"price_per_unit":6.36,"price_unit":"LT","price_total":12.72,"vat":5},{"name":"V2R07QhrB","amount":1,"price_per_unit":12.22,"price_unit":"unit","price_total":12.22,"vat":10},{"name":"BEI726rFOop","amount":2,"price_per_unit":2.78,"price_unit":"unit","price_total":5.56,"vat":5},{"name":"Tdsgh0ePPOhV","amount":2,"price_per_unit":11.38,"price_unit":"KG","price_total":22.76,"vat":20},{"name":"Q73GuAi","amount":1,"price_per_unit":2.94,"price_unit":"unit","price_total":2.94,"vat":20},{"name":"ip1FUPvR","amount":3,"price_per_unit":14.97,"price_unit":"LT","price_total":44.91,"vat":5},{"name":"OOYA8XE","amount":3,"price_per_unit":15.64,"price_unit":"LT","price_total":46.92,"vat":20}]}	COMPLETED	20	simone.bartoli01@gmail.com
21	305.79	45.72	2022-06-30 20:11:40.595	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"TwcKbbx","amount":2,"price_per_unit":18.99,"price_unit":"unit","price_total":37.98,"vat":10},{"name":"1Zy58y3co3AY","amount":3,"price_per_unit":10.56,"price_unit":"LT","price_total":31.68,"vat":20},{"name":"Qt2JzeR","amount":4,"price_per_unit":2.98,"price_unit":"unit","price_total":11.92,"vat":20},{"name":"8ownjVQ1UD2Q","amount":3,"price_per_unit":17.96,"price_unit":"KG","price_total":53.88,"vat":20},{"name":"pHB0e7","amount":2,"price_per_unit":7.86,"price_unit":"LT","price_total":15.72,"vat":20},{"name":"HQuWEX","amount":4,"price_per_unit":9.18,"price_unit":"LT","price_total":36.72,"vat":20},{"name":"nhCgXM","amount":1,"price_per_unit":19.34,"price_unit":"KG","price_total":19.34,"vat":10},{"name":"x0LHbTf","amount":1,"price_per_unit":13.9,"price_unit":"LT","price_total":13.9,"vat":20},{"name":"GmeStIiA","amount":4,"price_per_unit":4.49,"price_unit":"LT","price_total":17.96,"vat":5},{"name":"rudfljHLA0vs","amount":3,"price_per_unit":13.23,"price_unit":"LT","price_total":39.69,"vat":5},{"name":"Ndoe31Yme","amount":2,"price_per_unit":3.33,"price_unit":"unit","price_total":6.66,"vat":10},{"name":"VfFs3gyPIB","amount":1,"price_per_unit":18.37,"price_unit":"KG","price_total":18.37,"vat":20}]}	COMPLETED	21	XXXX XXXX XXXX 2388
22	389.73	50.4	2022-06-30 20:11:40.599	Debit Card	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"spUlXgTtnIij","amount":4,"price_per_unit":17.21,"price_unit":"LT","price_total":68.84,"vat":5},{"name":"LgxBPswCt","amount":4,"price_per_unit":9.28,"price_unit":"KG","price_total":37.12,"vat":20},{"name":"rudfljHLA0vs","amount":4,"price_per_unit":13.23,"price_unit":"LT","price_total":52.92,"vat":5},{"name":"vVMQBD","amount":4,"price_per_unit":18.03,"price_unit":"LT","price_total":72.12,"vat":20},{"name":"hePxXVVV8","amount":3,"price_per_unit":16.07,"price_unit":"LT","price_total":48.21,"vat":20},{"name":"66L2kQ4","amount":4,"price_per_unit":10.06,"price_unit":"unit","price_total":40.24,"vat":5},{"name":"MDAFOZvCp","amount":1,"price_per_unit":11.3,"price_unit":"KG","price_total":11.3,"vat":5},{"name":"lHmuVGrArEof","amount":1,"price_per_unit":4.74,"price_unit":"KG","price_total":4.74,"vat":5},{"name":"UfdzXYkfl","amount":1,"price_per_unit":10.6,"price_unit":"unit","price_total":10.6,"vat":20},{"name":"Qt2JzeR","amount":4,"price_per_unit":2.98,"price_unit":"unit","price_total":11.92,"vat":20},{"name":"7VnurlD5f7W","amount":2,"price_per_unit":13.77,"price_unit":"unit","price_total":27.54,"vat":20}]}	COMPLETED	22	XXXX XXXX XXXX 4778
23	354.26	33.54	2022-06-30 20:11:40.603	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"UfdzXYkfl","amount":4,"price_per_unit":10.6,"price_unit":"unit","price_total":42.4,"vat":20},{"name":"17C8Be1RxUd","amount":3,"price_per_unit":3.56,"price_unit":"unit","price_total":10.68,"vat":20},{"name":"xjfgqR","amount":2,"price_per_unit":11.15,"price_unit":"KG","price_total":22.3,"vat":5},{"name":"aaT7fpX0wQ","amount":2,"price_per_unit":16.51,"price_unit":"KG","price_total":33.02,"vat":10},{"name":"MDAFOZvCp","amount":4,"price_per_unit":11.3,"price_unit":"KG","price_total":45.2,"vat":5},{"name":"jdTxMCwbjMV","amount":4,"price_per_unit":15.75,"price_unit":"unit","price_total":63,"vat":5},{"name":"NfIs5RClAdp","amount":2,"price_per_unit":15.53,"price_unit":"LT","price_total":31.06,"vat":10},{"name":"nhCgXM","amount":2,"price_per_unit":19.34,"price_unit":"KG","price_total":38.68,"vat":10},{"name":"hePxXVVV8","amount":1,"price_per_unit":16.07,"price_unit":"LT","price_total":16.07,"vat":20},{"name":"majMp8x","amount":1,"price_per_unit":17.44,"price_unit":"KG","price_total":17.44,"vat":5},{"name":"68HJOt","amount":4,"price_per_unit":6.45,"price_unit":"unit","price_total":25.8,"vat":5},{"name":"LupuT8","amount":1,"price_per_unit":3.71,"price_unit":"LT","price_total":3.71,"vat":20}]}	COMPLETED	23	simone.bartoli01@gmail.com
24	266.38	36.5	2022-06-30 20:11:40.606	Paypal	{"billing_address":{"first_address":"1 Yeo Street","second_address":"Caspian Wharf 40","postcode":"E3 3AE","city":"London","notes":null},"items":[{"name":"BWrYrw5","amount":2,"price_per_unit":13.97,"price_unit":"KG","price_total":27.94,"vat":10},{"name":"rolwnU","amount":1,"price_per_unit":7.86,"price_unit":"unit","price_total":7.86,"vat":20},{"name":"GmeStIiA","amount":2,"price_per_unit":4.49,"price_unit":"LT","price_total":8.98,"vat":5},{"name":"A0pZ0Q","amount":2,"price_per_unit":4.21,"price_unit":"KG","price_total":8.42,"vat":10},{"name":"76MckC","amount":3,"price_per_unit":5.43,"price_unit":"KG","price_total":16.29,"vat":10},{"name":"x0LHbTf","amount":3,"price_per_unit":13.9,"price_unit":"LT","price_total":41.7,"vat":20},{"name":"spUlXgTtnIij","amount":1,"price_per_unit":17.21,"price_unit":"LT","price_total":17.21,"vat":5},{"name":"Tdsgh0ePPOhV","amount":1,"price_per_unit":11.38,"price_unit":"KG","price_total":11.38,"vat":20},{"name":"dDEmvtXHh8","amount":4,"price_per_unit":3.08,"price_unit":"KG","price_total":12.32,"vat":5},{"name":"1Mq3UGob85K","amount":3,"price_per_unit":5.03,"price_unit":"LT","price_total":15.09,"vat":20},{"name":"2yvFTLO5hE8","amount":4,"price_per_unit":12.44,"price_unit":"KG","price_total":49.76,"vat":10},{"name":"gT2623mTZ2Sy","amount":3,"price_per_unit":15.22,"price_unit":"KG","price_total":45.66,"vat":20}]}	REFUNDED	24	simone.bartoli01@gmail.com
\.


--
-- Data for Name: recover_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.recover_tokens (token_id, secret, user_id, status) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (token_id, version, user_id, auth_level) FROM stdin;
21	1	5	standard
20	7	5	standard
22	5	5	standard
23	5	5	standard
24	2	5	standard
25	7	5	standard
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
26	25	5	standard
27	2	5	standard
28	3	5	standard
29	1	5	standard
\.


--
-- Data for Name: shipping_addresses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shipping_addresses (address_id, notes) FROM stdin;
1	Ring the bell
2	Watch the dog
\.


--
-- Data for Name: sub_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_categories (sub_category_id, name, notes, category_id) FROM stdin;
1	Intuitive executive protocol	Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum ru	5
2	Multi-tiered 4th generation website	In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl.	1
3	Self-enabling didactic challenge	Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.	3
4	Future-proofed radical capacity	Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis.	2
5	Devolved client-server open architecture	Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condi	4
6	Optional neutral focus group	Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Ae	5
7	Diverse actuating emulation	Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla.	4
8	Reduced disintermediate framework	Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.	3
9	Grass-roots tangible orchestration	Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare impe	5
10	Digitized disintermediate customer loyalty	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit.	2
11	Enterprise-wide system-worthy extranet	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a od	5
12	Open-source stable help-desk	Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis 	4
13	Decentralized mission-critical leverage	Morbi a ipsum. Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam por	4
14	Re-contextualized zero defect methodology	Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla.	5
15	Ergonomic eco-centric access	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Viv	2
16	Multi-tiered mobile leverage	Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2
17	Grass-roots executive framework	Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis.	7
18	Secured multi-state paradigm	Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	3
19	User-friendly tangible interface	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue.	2
20	Re-engineered motivating core	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.	1
21	Self-enabling modular hardware	In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.	1
22	Digitized solution-oriented neural-net	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi.	5
23	Function-based asynchronous definition	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a od	8
24	Exclusive zero tolerance standardization	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien a	2
25	Future-proofed content-based definition	Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede. Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	4
\.


--
-- Data for Name: sub_categories_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sub_categories_items (sub_category_id, item_id) FROM stdin;
25	1
16	1
13	1
3	1
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
2	11
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
2	19
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
2	22
3	22
20	22
17	22
8	22
21	23
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
2	30
7	30
9	30
1	31
4	31
24	32
21	32
25	33
4	33
3	33
24	33
11	33
25	34
19	34
5	34
13	34
20	35
24	36
12	36
17	36
10	37
20	37
17	37
15	38
9	39
6	39
25	39
7	39
1	40
20	40
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
21	44
25	45
2	46
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
20	50
7	50
14	50
8	51
13	51
12	51
5	51
21	51
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
21	59
24	60
3	60
2	60
4	60
8	61
18	61
9	61
13	62
16	62
7	62
8	62
16	63
2	63
19	63
16	64
19	64
24	64
9	64
12	64
6	65
21	65
5	65
3	65
18	65
6	66
2	66
24	67
6	67
19	67
7	67
17	68
1	68
12	69
20	69
21	69
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
4	73
4	74
13	74
17	75
6	75
22	76
21	76
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
20	81
7	81
4	81
1	82
7	82
12	82
17	82
2	82
17	83
3	83
14	83
20	83
2	84
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
20	94
5	94
10	95
5	95
23	96
1	96
22	96
11	97
8	97
12	97
2	98
20	98
13	98
18	98
16	98
11	99
18	100
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, name, surname, dob, email, password, role, email_to_verify, entry_date) FROM stdin;
5	Giovanni	Calome	2000-06-25	simone.bartoli01@gmail.com	$2b$10$lzjEO.7kh0Aw92ipxWDAOuS1neKCsNDF2qZhWWULsjECNBBSYppmC	client	\N	2022-07-01 12:28:16.8281+01
1	Simone	Bartoli	2022-06-01	test@test.com	12345	client	\N	2022-07-01 12:28:16.8281+01
2	Luca	Ostato	2022-06-01	test1@test.com	hello123	client	\N	2022-07-01 12:28:16.8281+01
4	ssfsf	sf1	2000-06-25	test2@test.com	ssdsdf2323	client	\N	2022-07-01 12:28:16.8281+01
8	Giovanni	Belli	2001-06-01	\N	$2b$10$mYvuVmhe5729r25YswZBFei87k91ytIYZUdaq/QB7cZr5FZMlSMum	client	lucaostato@libero.it	2022-07-01 23:22:16.523+01
9	Cosimo	Arturi	2002-06-01	\N	$2b$10$Y3B9A1L.iR3EelZIRmU83eRS8.bh6djbh.q3b79JC5QfUrIHiv.Jq	client	info@bartolisimone.com	2022-07-01 23:29:17.27+01
\.


--
-- Data for Name: vat; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vat (vat_id, percentage) FROM stdin;
1	5
2	10
3	20
\.


--
-- Name: access_token_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.access_token_token_id_seq', 73, true);


--
-- Name: addresses_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addresses_address_id_seq', 3, true);


--
-- Name: bundles_bundle_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bundles_bundle_id_seq', 1, false);


--
-- Name: categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_category_id_seq', 1, false);


--
-- Name: discounts_discount_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discounts_discount_id_seq', 1, false);


--
-- Name: emails_email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.emails_email_id_seq', 1, false);


--
-- Name: items_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_item_id_seq', 100, true);


--
-- Name: list_items_list_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.list_items_list_item_id_seq', 1, false);


--
-- Name: log_accesses_log_access_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.log_accesses_log_access_id_seq', 49, true);


--
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 24, true);


--
-- Name: receipts_receipt_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.receipts_receipt_id_seq', 24, true);


--
-- Name: refresh_tokens_refresh_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refresh_tokens_refresh_token_id_seq', 29, true);


--
-- Name: tokens_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokens_token_id_seq', 9, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 9, true);


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
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (receipt_id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (token_id);


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
-- Name: users_email_to_verify_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_email_to_verify_uindex ON public.users USING btree (email_to_verify);


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
-- Name: receipts fkreceipts115011; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT fkreceipts115011 FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON UPDATE CASCADE ON DELETE RESTRICT;


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
-- Name: items items_vat_vat_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_vat_vat_id_fk FOREIGN KEY (vat_id) REFERENCES public.vat(vat_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: sub_categories sub_categories_categories_category_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sub_categories
    ADD CONSTRAINT sub_categories_categories_category_id_fk FOREIGN KEY (category_id) REFERENCES public.categories(category_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

