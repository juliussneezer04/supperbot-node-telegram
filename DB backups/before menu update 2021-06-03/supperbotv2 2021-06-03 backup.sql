--
-- PostgreSQL database dump
--

-- Dumped from database version 12.7 (Ubuntu 12.7-1.pgdg16.04+1)
-- Dumped by pg_dump version 12.4

-- Started on 2021-06-03 13:07:19

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
-- TOC entry 12 (class 2615 OID 22707399)
-- Name: jiodata; Type: SCHEMA; Schema: -; Owner: prasowycsjjunh
--

CREATE SCHEMA jiodata;


ALTER SCHEMA jiodata OWNER TO prasowycsjjunh;

--
-- TOC entry 11 (class 2615 OID 25490308)
-- Name: master; Type: SCHEMA; Schema: -; Owner: prasowycsjjunh
--

CREATE SCHEMA master;


ALTER SCHEMA master OWNER TO prasowycsjjunh;

--
-- TOC entry 6 (class 2615 OID 22701682)
-- Name: menudata; Type: SCHEMA; Schema: -; Owner: prasowycsjjunh
--

CREATE SCHEMA menudata;


ALTER SCHEMA menudata OWNER TO prasowycsjjunh;

--
-- TOC entry 7 (class 2615 OID 24033993)
-- Name: miscellaneous; Type: SCHEMA; Schema: -; Owner: prasowycsjjunh
--

CREATE SCHEMA miscellaneous;


ALTER SCHEMA miscellaneous OWNER TO prasowycsjjunh;

--
-- TOC entry 3 (class 2615 OID 25490309)
-- Name: stations; Type: SCHEMA; Schema: -; Owner: prasowycsjjunh
--

CREATE SCHEMA stations;


ALTER SCHEMA stations OWNER TO prasowycsjjunh;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 22707401)
-- Name: jios; Type: TABLE; Schema: jiodata; Owner: prasowycsjjunh
--

CREATE TABLE jiodata.jios (
    chat_id bigint NOT NULL,
    creator_id integer NOT NULL,
    creator_name character varying(255) NOT NULL,
    "time" timestamp with time zone DEFAULT now() NOT NULL,
    duration character varying(255),
    menu integer NOT NULL,
    message_id bigint,
    description character varying(255),
    listener_ids integer[] DEFAULT ARRAY[]::integer[],
    text text,
    inline_keyboard text
);


ALTER TABLE jiodata.jios OWNER TO prasowycsjjunh;

--
-- TOC entry 211 (class 1259 OID 22707408)
-- Name: modifiers; Type: TABLE; Schema: jiodata; Owner: prasowycsjjunh
--

CREATE TABLE jiodata.modifiers (
    id integer NOT NULL,
    order_id integer NOT NULL,
    level integer NOT NULL,
    name character varying(40) NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE jiodata.modifiers OWNER TO prasowycsjjunh;

--
-- TOC entry 212 (class 1259 OID 22707412)
-- Name: modifiers_id_seq; Type: SEQUENCE; Schema: jiodata; Owner: prasowycsjjunh
--

CREATE SEQUENCE jiodata.modifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jiodata.modifiers_id_seq OWNER TO prasowycsjjunh;

--
-- TOC entry 4072 (class 0 OID 0)
-- Dependencies: 212
-- Name: modifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER SEQUENCE jiodata.modifiers_id_seq OWNED BY jiodata.modifiers.id;


--
-- TOC entry 213 (class 1259 OID 22707414)
-- Name: orders; Type: TABLE; Schema: jiodata; Owner: prasowycsjjunh
--

CREATE TABLE jiodata.orders (
    order_id integer NOT NULL,
    chat_id bigint,
    user_id integer,
    user_name character varying(40),
    item_id integer,
    message_id integer,
    remarks character varying(60)
);


ALTER TABLE jiodata.orders OWNER TO prasowycsjjunh;

--
-- TOC entry 214 (class 1259 OID 22707417)
-- Name: orderid_seq; Type: SEQUENCE; Schema: jiodata; Owner: prasowycsjjunh
--

CREATE SEQUENCE jiodata.orderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jiodata.orderid_seq OWNER TO prasowycsjjunh;

--
-- TOC entry 4073 (class 0 OID 0)
-- Dependencies: 214
-- Name: orderid_seq; Type: SEQUENCE OWNED BY; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER SEQUENCE jiodata.orderid_seq OWNED BY jiodata.orders.order_id;


--
-- TOC entry 219 (class 1259 OID 25490310)
-- Name: participants; Type: TABLE; Schema: master; Owner: prasowycsjjunh
--

CREATE TABLE master.participants (
    "userID" bigint NOT NULL,
    station text NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE master.participants OWNER TO prasowycsjjunh;

--
-- TOC entry 220 (class 1259 OID 25490316)
-- Name: stations; Type: TABLE; Schema: master; Owner: prasowycsjjunh
--

CREATE TABLE master.stations (
    name text NOT NULL,
    "groupID" bigint NOT NULL,
    "timeEach" double precision DEFAULT 10 NOT NULL,
    "frontMessage" text,
    "maxQueueLength" integer DEFAULT 10 NOT NULL,
    description text DEFAULT 'none provided'::text NOT NULL
);


ALTER TABLE master.stations OWNER TO prasowycsjjunh;

--
-- TOC entry 4074 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN stations."timeEach"; Type: COMMENT; Schema: master; Owner: prasowycsjjunh
--

COMMENT ON COLUMN master.stations."timeEach" IS 'estimated time per person in minutes';


--
-- TOC entry 4075 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN stations."frontMessage"; Type: COMMENT; Schema: master; Owner: prasowycsjjunh
--

COMMENT ON COLUMN master.stations."frontMessage" IS 'message to be sent to front participant';


--
-- TOC entry 207 (class 1259 OID 22701692)
-- Name: al_amaans; Type: TABLE; Schema: menudata; Owner: prasowycsjjunh
--

CREATE TABLE menudata.al_amaans (
    item_id integer NOT NULL,
    parent_id integer NOT NULL,
    item_name character varying(255) NOT NULL,
    price integer,
    mod_group integer
);


ALTER TABLE menudata.al_amaans OWNER TO prasowycsjjunh;

--
-- TOC entry 208 (class 1259 OID 22701695)
-- Name: al_amaans_mod; Type: TABLE; Schema: menudata; Owner: prasowycsjjunh
--

CREATE TABLE menudata.al_amaans_mod (
    mod_id integer NOT NULL,
    "group" integer NOT NULL,
    name character varying(40) NOT NULL,
    price integer DEFAULT 0,
    level integer DEFAULT 0
);


ALTER TABLE menudata.al_amaans_mod OWNER TO prasowycsjjunh;

--
-- TOC entry 209 (class 1259 OID 22701700)
-- Name: al_amaans_mod_id_seq; Type: SEQUENCE; Schema: menudata; Owner: prasowycsjjunh
--

CREATE SEQUENCE menudata.al_amaans_mod_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE menudata.al_amaans_mod_id_seq OWNER TO prasowycsjjunh;

--
-- TOC entry 4076 (class 0 OID 0)
-- Dependencies: 209
-- Name: al_amaans_mod_id_seq; Type: SEQUENCE OWNED BY; Schema: menudata; Owner: prasowycsjjunh
--

ALTER SEQUENCE menudata.al_amaans_mod_id_seq OWNED BY menudata.al_amaans_mod.mod_id;


--
-- TOC entry 217 (class 1259 OID 24285540)
-- Name: koi; Type: TABLE; Schema: menudata; Owner: prasowycsjjunh
--

CREATE TABLE menudata.koi (
    item_id integer NOT NULL,
    parent_id integer NOT NULL,
    item_name character varying(255) NOT NULL,
    price integer,
    mod_group integer
);


ALTER TABLE menudata.koi OWNER TO prasowycsjjunh;

--
-- TOC entry 218 (class 1259 OID 24285543)
-- Name: koi_mod; Type: TABLE; Schema: menudata; Owner: prasowycsjjunh
--

CREATE TABLE menudata.koi_mod (
    mod_id integer NOT NULL,
    "group" integer NOT NULL,
    name character varying NOT NULL,
    price integer NOT NULL,
    level integer NOT NULL
);


ALTER TABLE menudata.koi_mod OWNER TO prasowycsjjunh;

--
-- TOC entry 215 (class 1259 OID 24033994)
-- Name: cache; Type: TABLE; Schema: miscellaneous; Owner: prasowycsjjunh
--

CREATE TABLE miscellaneous.cache (
    key bigint NOT NULL,
    data text NOT NULL,
    "time" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE miscellaneous.cache OWNER TO prasowycsjjunh;

--
-- TOC entry 216 (class 1259 OID 24034000)
-- Name: helper; Type: TABLE; Schema: miscellaneous; Owner: prasowycsjjunh
--

CREATE TABLE miscellaneous.helper (
    string text NOT NULL,
    count integer NOT NULL,
    "time" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE miscellaneous.helper OWNER TO prasowycsjjunh;

--
-- TOC entry 221 (class 1259 OID 25490325)
-- Name: Thor's Body; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Thor's Body" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Thor's Body" OWNER TO prasowycsjjunh;

--
-- TOC entry 222 (class 1259 OID 25490328)
-- Name: Thor''s Body_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Thor's Body" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Thor''s Body_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 25490330)
-- Name: Thor's Linguistic; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Thor's Linguistic" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Thor's Linguistic" OWNER TO prasowycsjjunh;

--
-- TOC entry 224 (class 1259 OID 25490333)
-- Name: Thor''s Linguistic_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Thor's Linguistic" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Thor''s Linguistic_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 25490335)
-- Name: Thor's Musical; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Thor's Musical" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Thor's Musical" OWNER TO prasowycsjjunh;

--
-- TOC entry 226 (class 1259 OID 25490338)
-- Name: Thor''s Musical_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Thor's Musical" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Thor''s Musical_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 25490340)
-- Name: Thor's Existential; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Thor's Existential" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Thor's Existential" OWNER TO prasowycsjjunh;

--
-- TOC entry 228 (class 1259 OID 25490343)
-- Name: Thor's Existential_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Thor's Existential" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Thor's Existential_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 229 (class 1259 OID 25490345)
-- Name: Tue Station 1; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Tue Station 1" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Tue Station 1" OWNER TO prasowycsjjunh;

--
-- TOC entry 230 (class 1259 OID 25490348)
-- Name: Tue Station 1_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Tue Station 1" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Tue Station 1_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 231 (class 1259 OID 25490350)
-- Name: Tue Station 2; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Tue Station 2" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Tue Station 2" OWNER TO prasowycsjjunh;

--
-- TOC entry 232 (class 1259 OID 25490353)
-- Name: Tue Station 2_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Tue Station 2" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Tue Station 2_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 233 (class 1259 OID 25490355)
-- Name: Tue Station 3; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Tue Station 3" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Tue Station 3" OWNER TO prasowycsjjunh;

--
-- TOC entry 234 (class 1259 OID 25490358)
-- Name: Tue Station 3_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Tue Station 3" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Tue Station 3_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 235 (class 1259 OID 25490360)
-- Name: Wed Linguistic; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Wed Linguistic" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Wed Linguistic" OWNER TO prasowycsjjunh;

--
-- TOC entry 236 (class 1259 OID 25490363)
-- Name: Wed Linguistic_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Wed Linguistic" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Wed Linguistic_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 237 (class 1259 OID 25490365)
-- Name: Wed Music; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Wed Music" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Wed Music" OWNER TO prasowycsjjunh;

--
-- TOC entry 238 (class 1259 OID 25490368)
-- Name: Wed Music Station Admin_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Wed Music" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Wed Music Station Admin_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 239 (class 1259 OID 25490370)
-- Name: Wed Personal; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Wed Personal" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Wed Personal" OWNER TO prasowycsjjunh;

--
-- TOC entry 240 (class 1259 OID 25490373)
-- Name: Wed Personal 2; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations."Wed Personal 2" (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations."Wed Personal 2" OWNER TO prasowycsjjunh;

--
-- TOC entry 241 (class 1259 OID 25490376)
-- Name: Wed Personal 2_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Wed Personal 2" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Wed Personal 2_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 242 (class 1259 OID 25490378)
-- Name: Wed Personal_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations."Wed Personal" ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."Wed Personal_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 25490380)
-- Name: station1; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations.station1 (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations.station1 OWNER TO prasowycsjjunh;

--
-- TOC entry 244 (class 1259 OID 25490383)
-- Name: station1_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations.station1 ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."station1_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 245 (class 1259 OID 25490385)
-- Name: station2; Type: TABLE; Schema: stations; Owner: prasowycsjjunh
--

CREATE TABLE stations.station2 (
    "userID" bigint NOT NULL,
    "queueNumber" integer NOT NULL
);


ALTER TABLE stations.station2 OWNER TO prasowycsjjunh;

--
-- TOC entry 246 (class 1259 OID 25490388)
-- Name: station2_queueNumber_seq; Type: SEQUENCE; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE stations.station2 ALTER COLUMN "queueNumber" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME stations."station2_queueNumber_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 3842 (class 2604 OID 24285549)
-- Name: modifiers id; Type: DEFAULT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.modifiers ALTER COLUMN id SET DEFAULT nextval('jiodata.modifiers_id_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 24285550)
-- Name: orders order_id; Type: DEFAULT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.orders ALTER COLUMN order_id SET DEFAULT nextval('jiodata.orderid_seq'::regclass);


--
-- TOC entry 3838 (class 2604 OID 24285551)
-- Name: al_amaans_mod mod_id; Type: DEFAULT; Schema: menudata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY menudata.al_amaans_mod ALTER COLUMN mod_id SET DEFAULT nextval('menudata.al_amaans_mod_id_seq'::regclass);


--
-- TOC entry 4029 (class 0 OID 22707401)
-- Dependencies: 210
-- Data for Name: jios; Type: TABLE DATA; Schema: jiodata; Owner: prasowycsjjunh
--

COPY jiodata.jios (chat_id, creator_id, creator_name, "time", duration, menu, message_id, description, listener_ids, text, inline_keyboard) FROM stdin;
-475082174	501440245	Jacinda	2020-10-07 15:54:05.924874+00	-1	0	44471	\N	{18,20,21}	Jacinda created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-437699088	653601805	Nicktohzyu	2020-07-25 09:02:30.002028+00	-1	1	744	Nicktohzyu says: we added a description feature\n\n	{1,2,1,2,3}	Nicktohzyu created a jio for Koi. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001193695854	65046542	codey🗿	2021-03-18 05:39:28.923061+00	-1	0	19322	\N	{1,2,3}	codey🗿 created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-326077557	680149729	Sih-Zau	2020-10-31 11:11:18.40049+00	-1	0	61705	\N	{1,117}	Sih-Zau created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001324459299	166564498	reubst	2020-08-04 07:59:41.911937+00	-1	1	89	\N	{1,2}	reubst created a jio for Koi. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001191834744	269313006	Shafeeq	2020-08-06 15:46:02.001809+00	-1	0	8346	\N	{1,2,3}	Shafeeq created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-460387375	544277567	Lucas	2020-08-06 11:36:41.901509+00	-1	0	14008	\N	{1,2}	Lucas created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-466604336	255967344	chrawrmaine	2020-10-09 13:59:42.330032+00	-1	1	46202	\N	{4,5}	chrawrmaine created a jio for Koi. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-245000001	986254313	Kieron	2020-09-11 17:06:11.838446+00	-1	0	\N	\N	{}	Kieron created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-452485944	653601805	Nicktohzyu	2020-09-10 15:32:17.557119+00	-1	0	24964	\N	{12}	Nicktohzyu created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-364802324	74122931	Jin Ming	2020-09-13 04:51:49.598825+00	-1	0	26173	\N	{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20}	Jin Ming created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-332972347	152505712	Luke	2021-01-13 15:00:36.717654+00	-1	1	82776	\N	{28}	Luke created a jio for Koi. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-499716691	873852340	vishnu	2020-10-17 03:09:52.882593+00	-1	0	50557	\N	{1}	vishnu created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001204237600	276075063	Raihan Mohamad	2021-02-15 13:48:54.677302+00	-1	0	1014	\N	{14,15,16,17,18,19,20,22,23,26,29,30}	Raihan Mohamad created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-493565704	822361457	Nicholas	2020-10-17 03:34:46.380508+00	-1	0	50579	\N	{5,6}	Nicholas created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001387632285	72171277	Yi Jia	2021-02-23 14:36:09.475062+00	-1	0	625	\N	{46,47,48,49,50,28}	Yi Jia created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-379804862	754575985	Jolene Yu	2021-02-17 05:26:45.351816+00	-1	0	94118	\N	{4,7,9}	Jolene Yu created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-543767824	268150607	Jeff	2021-03-11 16:56:51.883032+00	-1	0	102502	\N	{53,54,55,56}	Jeff created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-422354637	99764173	shreya	2021-02-22 03:32:21.824607+00	-1	0	96444	\N	{1}	shreya created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001170412386	756704696	gheslynn	2021-04-29 12:03:31.28494+00	-1	0	10329	\N	{9,10,11,12,13,14,13}	gheslynn created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-368578532	225300229	Chen Xi	2020-10-13 11:55:19.8468+00	-1	1	47770	\N	{4,5}	Chen Xi created a jio for Koi. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-411700705	737650079	Edward	2021-02-24 09:19:26.156628+00	-1	0	97576	\N	{31}	Edward created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-362614765	333496579	Yash	2020-10-17 13:27:31.667577+00	-1	0	50639	\N	{1,16}	Yash created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-404962201	194825125	Chee	2021-01-13 03:46:52.663885+00	-1	0	82403	\N	{1}	Chee created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001433658382	125150375	sneha	2021-01-28 12:55:33.597784+00	-1	0	126754	\N	{1,2}	sneha created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-525098356	246173119	Jofoo	2021-05-26 07:49:17.140776+00	-1	0	123934	\N	{1}	Jofoo created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-417720172	1085172129	Minh Hai	2020-11-08 07:31:27.184987+00	-1	0	67957	\N	{1,2}	Minh Hai created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-389999154	1125010500	Kashyfi	2021-02-11 11:11:03.088933+00	-1	0	92569	\N	{1,2,3,4,5,6,7,8,9,10,11,12,13}	Kashyfi created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001190318684	1125010500	Kashyfi	2021-03-12 13:41:53.813542+00	-1	0	692	\N	{1,2,3,4,5,6,7,8,19,20,21,22,23,24,25,26,27,1,1,2,3,4,5,6,7}	Kashyfi created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-413769689	512260321	dorine	2021-02-20 13:05:27.035073+00	-1	1	95687	\N	{1,2}	dorine created a jio for Koi. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001136185162	323509307	Alyssa 🌿	2021-04-22 13:16:45.136293+00	-1	0	178754	\N	{1,2,3,4,5}	Alyssa 🌿 created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-438923838	189580139	Tim	2021-03-17 13:58:30.393728+00	-1	0	103663	\N	{5}	Tim created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-445611003	278917634	Samuel	2021-04-01 09:57:31.85785+00	-1	0	107566	\N	{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}	Samuel created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-357178908	367913189	yunze	2021-04-09 11:00:10.348625+00	-1	0	110507	\N	{1,2,3}	yunze created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
-1001327052623	189580139	Tim	2021-05-06 11:20:57.49941+00	-1	0	7771	\N	{1}	Tim created a jio for Al Amaans. Click on "add item", and I will message you directly to take your order. You may want to pin this message so users can find it easily.\n\n	{"reply_markup":{"inline_keyboard":[[{"text":"add item","callback_data":"{\\"cmd\\": \\"additem\\"}"}],[{"text":"remove item","callback_data":"{\\"cmd\\": \\"removeitem\\"}"}],[{"text":"view my orders","callback_data":"{\\"cmd\\": \\"viewmyorders\\"}"}],[{"text":"close jio","callback_data":"{\\"cmd\\": \\"closejio\\"}"}]]}}
\.


--
-- TOC entry 4030 (class 0 OID 22707408)
-- Dependencies: 211
-- Data for Name: modifiers; Type: TABLE DATA; Schema: jiodata; Owner: prasowycsjjunh
--

COPY jiodata.modifiers (id, order_id, level, name, price) FROM stdin;
356	798	0	Sugar Level 120%	0
357	798	1	less ice	0
358	798	2	Taro Q	160
960	2114	0	normal	0
961	2114	1	50% sugar	0
1023	2255	0	Sugar Level 25%	0
1024	2255	1	less ice	0
1025	2255	2	Golden Bubble	60
967	2121	0	hot	0
968	2121	1	50% sugar	0
1189	2610	0	normal	0
1190	2610	1	50% sugar	0
115	209	0	Sugar Level 50%	0
116	209	1	less ice	0
117	209	2	Konjac Jelly	120
1191	2612	0	normal	0
1192	2613	0	normal	0
1193	2612	1	50% sugar	0
402	858	0	Sugar Level 50%	0
1194	2613	1	50% sugar	0
1195	2614	0	normal	0
1196	2614	1	50% sugar	0
1197	2615	0	normal	0
403	858	1	normal	0
404	858	2	Golden Bubble	60
1198	2615	1	75% sugar	0
1038	2312	0	normal	0
1039	2312	1	25% sugar	0
185	412	0	normal	0
72	185	0	Sugar Level 25%	0
73	185	1	less ice	0
74	185	2	No Toppings	0
75	186	0	Sugar Level 120%	0
76	186	1	no ice	0
77	186	2	No Toppings	0
78	187	0	Sugar Level 100%	0
79	187	1	no ice	0
80	187	2	No Toppings	0
81	188	0	Sugar Level 70%	0
82	188	1	no ice	0
83	188	2	Konjac Jelly	160
186	412	1	25% sugar	0
187	418	0	normal	0
1199	2616	0	normal	0
1200	2616	1	75% sugar	0
190	418	1	25% sugar	0
191	425	0	normal	0
192	425	1	50% sugar	0
950	2094	0	normal	0
951	2094	1	25% sugar	0
1181	2587	0	normal	0
1182	2587	1	75% sugar	0
1183	2588	0	normal	0
1184	2588	1	50% sugar	0
1411	3347	0	normal	0
1412	3347	1	75% sugar	0
\.


--
-- TOC entry 4032 (class 0 OID 22707414)
-- Dependencies: 213
-- Data for Name: orders; Type: TABLE DATA; Schema: jiodata; Owner: prasowycsjjunh
--

COPY jiodata.orders (order_id, chat_id, user_id, user_name, item_id, message_id, remarks) FROM stdin;
2941	-445611003	278917634	Samuel	86	107567	\N
2255	-413769689	512260321	dorine	50	95688	\N
185	-437699088	653601805	Nicktohzyu	54	747	\N
186	-437699088	449277033	De Xun	30	750	\N
187	-437699088	449277033	De Xun	55	756	\N
188	-437699088	312768840	James	35	759	\N
2579	-543767824	384175110	Jon	245	102503	\N
2580	-543767824	268150607	Jeff	54	102506	\N
2581	-543767824	253269698	Joshua	249	102513	\N
2582	-1001190318684	1125010500	Kashyfi	180	102681	\N
2583	-1001190318684	484335567	sabrina	247	102695	\N
2584	-1001190318684	136923730	siti syuhaida	172	102700	\N
2585	-1001190318684	870912456	Md	64	102728	\N
2586	-1001190318684	20229193	mirza	231	102731	no chilli no vege
407	-364802324	340972458	janifer	102	26175	\N
408	-364802324	74122931	Jin Ming	96	26184	\N
409	-364802324	790145840	Angie	191	26189	\N
410	-364802324	340972458	janifer	161	26188	\N
411	-364802324	340972458	janifer	87	26207	\N
412	-364802324	74122931	Jin Ming	28	26208	\N
413	-364802324	340972458	janifer	87	26209	\N
414	-364802324	203660574	CL	96	26200	\N
415	-364802324	581653235	Claire Faustina	85	26206	\N
416	-364802324	147436656	Henry	49	26182	\N
417	-364802324	57791193	Natasha	54	26205	\N
418	-364802324	340972458	janifer	26	26213	\N
2587	-1001190318684	20229193	mirza	26	102735	\N
420	-364802324	581653235	Claire Faustina	85	26216	\N
421	-364802324	736230301	Trixie	75	26212	\N
422	-364802324	581653235	Claire Faustina	85	26218	\N
423	-364802324	581653235	Claire Faustina	87	26220	\N
424	-364802324	340972458	janifer	88	26217	\N
425	-364802324	581653235	Claire Faustina	26	26226	\N
209	-1001324459299	452111447	Kaitlyn	26	6432	\N
210	-460387375	544277567	Lucas	87	14009	\N
2588	-1001190318684	20229193	mirza	27	102736	\N
2942	-445611003	278917634	Samuel	86	107568	\N
2943	-445611003	278917634	Samuel	86	107569	\N
2944	-445611003	278917634	Samuel	86	107570	\N
2945	-445611003	278917634	Samuel	86	107571	\N
2946	-445611003	278917634	Samuel	85	107572	\N
2947	-445611003	278917634	Samuel	85	107573	\N
2948	-445611003	278917634	Samuel	85	107574	\N
2949	-445611003	278917634	Samuel	85	107575	\N
2950	-445611003	278917634	Samuel	85	107576	\N
2951	-445611003	278917634	Samuel	102	107579	\N
2952	-445611003	278917634	Samuel	132	107580	\N
2953	-445611003	278917634	Samuel	162	107581	\N
2599	-1001190318684	744398812	mariah	246	102803	\N
2600	-1001190318684	365221731	izzah	62	102721	\N
967	-493565704	822361457	Nicholas	104	50580	\N
2601	-1001190318684	69495723	farahnabs	248	102809	no taugeh please
2954	-445611003	278917634	Samuel	102	107583	\N
2603	-1001190318684	409059683	kamilia	244	102815	(no tomato sauce or chilli sauce)
2604	-1001190318684	356405493	syahirah	181	102707	\N
2605	-1001190318684	652239802	Aminah	65	102704	\N
2606	-1001190318684	608287238	Hannan	65	102818	\N
2607	-1001190318684	288989082	sharizmxn	260	102835	\N
2608	-1001190318684	1296646638	Ilias	181	102872	\N
2955	-445611003	278917634	Samuel	132	107587	\N
797	-466604336	255967344	chrawrmaine	31	46203	\N
798	-466604336	255967344	chrawrmaine	55	46208	\N
2610	-1001190318684	484335567	sabrina	26	102877	\N
1223	-417720172	1085172129	Minh Hai	162	67958	\N
2611	-1001190318684	323004668	iffah ishak	64	102882	\N
982	-362614765	333496579	Yash	90	50640	\N
2612	-1001190318684	1125010500	Kashyfi	25	102883	\N
2613	-1001190318684	136923730	siti syuhaida	30	102720	\N
2614	-1001190318684	1125010500	Kashyfi	25	102884	\N
2615	-1001190318684	1125010500	Kashyfi	27	102886	\N
2616	-1001190318684	1125010500	Kashyfi	27	102887	\N
1722	-475082174	501440245	Jacinda	87	44480	\N
2083	-389999154	1125010500	Kashyfi	57	92570	\N
2084	-389999154	276075063	Raihan Mohamad	56	92575	\N
3297	-1001136185162	323509307	Alyssa 🌿	87	114489	\N
2086	-389999154	276075063	Raihan Mohamad	173	92581	\N
2087	-389999154	186961538	Izzah	162	92579	\N
1941	-1001433658382	125150375	sneha	89	87514	\N
2088	-389999154	186961538	Izzah	170	92587	\N
2089	-389999154	276075063	Raihan Mohamad	214	92585	\N
2090	-389999154	186961538	Izzah	72	92588	\N
2091	-389999154	186961538	Izzah	170	92592	\N
2092	-389999154	276075063	Raihan Mohamad	58	92589	\N
858	-368578532	225300229	Chen Xi	42	47772	\N
2093	-389999154	1125010500	Kashyfi	57	92605	\N
1648	-326077557	875444329	jay	86	61709	\N
2094	-389999154	1125010500	Kashyfi	27	92606	\N
3298	-1001136185162	323509307	Alyssa 🌿	87	114489	\N
2312	-1001387632285	72171277	Yi Jia	25	97236	\N
2313	-1001387632285	28256775	Justin O	161	97238	\N
2314	-1001387632285	636947582	Dani	161	97254	\N
3347	-1001170412386	271573494	chelsea	26	116967	\N
2110	-1001204237600	312957333	syafiq	172	93209	\N
2111	-1001204237600	676176295	Arif Z	179	93214	\N
2112	-1001204237600	280475172	Maisarah Syazwina	244	93211	\N
2114	-1001204237600	676176295	Arif Z	25	93224	\N
3351	-1001170412386	376313483	Sally Teo	89	116983	\N
2117	-1001204237600	663664180	Hamidd	72	93231	\N
2121	-1001204237600	384686753	Faris	26	93244	\N
2641	-1001193695854	18004473	Monalisa	128	103739	\N
2124	-1001204237600	384686753	Faris	173	93247	\N
2125	-1001204237600	276075063	Raihan Mohamad	72	93235	\N
2642	-1001193695854	388945744	Sebin	186	103740	\N
2657	-475082174	256307101	Si Jing	102	44479	\N
3299	-1001136185162	323509307	Alyssa 🌿	102	114490	\N
3349	-1001170412386	756704696	gheslynn	102	116971	\N
3352	-1001170412386	756704696	gheslynn	86	116980	\N
3296	-1001136185162	323509307	Alyssa 🌿	87	114488	\N
3350	-1001170412386	756704696	gheslynn	86	116977	\N
3387	-1001170412386	942702210	Nehal	86	118410	\N
3103	-357178908	136725868	Joshua	49	110517	\N
3104	-357178908	728748932	Viktor	210	110535	\N
\.


--
-- TOC entry 4038 (class 0 OID 25490310)
-- Dependencies: 219
-- Data for Name: participants; Type: TABLE DATA; Schema: master; Owner: prasowycsjjunh
--

COPY master.participants ("userID", station, "queueNumber") FROM stdin;
70681348	Wed Music	7
340628101	Wed Music	8
499898543	Wed Music	9
646785010	Wed Music	10
348939716	Wed Personal	8
126913124	Wed Linguistic	4
653421992	Wed Linguistic	5
542451018	Wed Personal	9
356312836	Wed Linguistic	6
740489610	Wed Linguistic	7
448252759	Thor's Musical	2
571587629	Thor's Musical	3
376289946	Thor's Musical	4
367913189	Thor's Existential	2
790145840	Thor's Existential	3
678101743	Thor's Existential	4
\.


--
-- TOC entry 4039 (class 0 OID 25490316)
-- Dependencies: 220
-- Data for Name: stations; Type: TABLE DATA; Schema: master; Owner: prasowycsjjunh
--

COPY master.stations (name, "groupID", "timeEach", "frontMessage", "maxQueueLength", description) FROM stdin;
station1	-440049325	5	you're next	5	none provided
station2	-495549072	5	you're next2	999	none provided
Wed Linguistic	-469688493	10	\N	10	none provided
Thor's Linguistic	-473066704	10	\N	10	none provided
Thor's Existential	-492711691	10	\N	10	none provided
Tue Station 1	-338776699	10	\N	10	none provided
Tue Station 2	-470598822	10	\N	10	none provided
Tue Station 3	-339213979	10	\N	10	none provided
Wed Personal	-472564065	10	\N	10	none provided
Wed Music	-435377964	10	\N	10	none provided
Wed Personal 2	-468020530	20	\N	10	none provided
Thor's Body	-350918507	10	\N	10	none provided
Thor's Musical	-420749114	5	\N	10	none provided
\.


--
-- TOC entry 4026 (class 0 OID 22701692)
-- Dependencies: 207
-- Data for Name: al_amaans; Type: TABLE DATA; Schema: menudata; Owner: prasowycsjjunh
--

COPY menudata.al_amaans (item_id, parent_id, item_name, price, mod_group) FROM stdin;
26	4	D64 Iced Teh Cino	200	1
0	0	undefined	300	\N
29	4	Iced Bandung	150	1
1	0	Thai Kitchen	\N	\N
2	0	Indian Kitchen	\N	\N
3	0	Western Kitchen	\N	\N
4	0	Drinks	\N	\N
5	0	Desserts	\N	\N
6	1	Mee / Beehoon / Kwayteow / Maggie	\N	\N
7	1	Steam Rice w/ Chicken / Beef / Sliced Fish / Cuttlefish / Prawn	\N	\N
8	1	Fried Rice	\N	\N
9	2	Breads & Naans	\N	\N
10	2	Chicken	\N	\N
11	2	Rice	\N	\N
12	2	Mutton	\N	\N
13	2	Seafood	\N	\N
14	2	Vegetables	\N	\N
15	3	Finger Food	\N	\N
16	3	Pasta	\N	\N
17	3	Salad	\N	\N
18	3	Kebab	\N	\N
19	3	Roti John	\N	\N
20	3	Burger	\N	\N
21	3	Fish	\N	\N
22	3	Lamb	\N	\N
23	3	Steak	\N	\N
24	3	Chicken	\N	\N
31	5	Red Bean Ice Kachang	300	\N
32	6	Tomyam	\N	\N
33	6	Bandung Soup	\N	\N
34	6	Hong Kong	\N	\N
35	6	Hailam	\N	\N
36	6	Thai Style Fried w/ Chicken Prawn and Cuttlefish	\N	\N
37	6	Sambal Style Fried w/ Chicken	\N	\N
38	6	Chinese Style Fried	\N	\N
39	6	Fried w/ Beef	\N	\N
40	6	Fried w/ Seafood	\N	\N
41	6	Pataya	\N	\N
42	6	Fried with Cockles	\N	\N
43	7	Steam Rice w/ Chicken	\N	\N
44	7	Steam Rice w/ Beef	\N	\N
45	7	Steam Rice w/ Sliced Fish	\N	\N
46	7	Steam Rice w/ Cuttlefish	\N	\N
47	7	Steam Rice w/ Prawn	\N	\N
48	8	T47 FR Chinese Style w/ Chicken	400	\N
49	8	T48 FR Thai Style w/ Chicken Prawn Cuttlefish	480	\N
50	8	T49 FR Ikan Bilis & Egg	450	\N
51	8	T50 FR Tomato & Chicken	450	\N
52	8	T51 FR Fried Chicken w/ Chilli Sauce	450	\N
53	8	T52 FR Salted Fish	400	\N
54	8	T53 FR Kampong Style (Regular)	480	\N
55	8	T53 FR Kampong Style (Large)	600	\N
56	8	T54 FR Cockles	450	\N
57	8	T55 FR Pataya (Chicken)	550	\N
58	8	T55 FR Pataya (Beef)	550	\N
59	8	T55 FR Pataya (Seafood)	550	\N
60	8	T56 FR Chinese Style w/ Red Chilli Beef	550	\N
61	8	T56 FR Thai Style w/ Red Chilli Beef	550	\N
62	8	T57 FR Chinese Style Hot & Spicy (Chicken)	550	\N
63	8	T57 FR Chinese Style Hot & Spicy (Seafood)	550	\N
64	8	T58 FR Thai Style Hot & Spicy (Chicken)	550	\N
65	8	T58 FR Thai Style Hot & Spicy (Seafood)	550	\N
66	8	T59 FR Chinese Style w/ Black Oyster Sauce (Beef)	550	\N
67	8	T59 FR Chinese Style w/ Black Oyster Sauce (Chicken)	550	\N
68	8	T60 FR Button Mushroom & Egg	450	\N
69	8	T61 FR Sambal Mushroom & Chicken	550	\N
70	8	T62 FR 3 Tastes (Sweet Sour Spicy) w/ Chicken & Seafood	600	\N
71	8	T63 FR Sambal w/ Fried Sambal Chicken	550	\N
72	8	T64 FR Black Pepper (Chicken)	550	\N
73	8	T64 FR Black Pepper (Beef)	550	\N
74	8	T65 FR Pineapple w/ Chicken & Seafood	500	\N
75	8	T66 FR Chinese Style w/ Sweet & Sour (Chicken)	550	\N
76	8	T66 FR Chinese Style w/ Sweet & Sour (Sliced Fish)	550	\N
77	8	T67 FR Chinese Style w/ Ginger Brown Sauce (Chicken)	550	\N
78	8	T67 FR Chinese Style w/ Ginger Brown Sauce (Beef)	550	\N
79	8	T68 FR Thai Style w/ Crispy Ginger Yellow Chicken & Egg	600	\N
80	8	T69 FR Bush (Yellow FR w/ Egg Hot & Spicy Chicken)	600	\N
81	8	T70 FR Obama (Yellow FR w/ Egg Hot & Spicy Beef)	600	\N
82	8	T71 FR Thai Style w/ Chicken Egg Sambal	550	\N
83	8	T71 FR Chinese Style w/ Chicken Egg Sambal	550	\N
84	8	T72 FR Al Amaan (Special)	700	\N
85	9	N13 Plain Naan	150	\N
86	9	N14 Butter Naan	170	\N
87	9	N15 Garlic Naan	250	\N
88	9	N16 Kashmiri Naan	400	\N
89	9	N17 Cheese Naan	300	\N
90	9	N18 Kheema Naan	400	\N
91	9	N19 Aloo Pratha	250	\N
92	9	N20 Poodina Pratha	200	\N
93	9	N21 Garlic & Onion Kulcha	350	\N
94	9	N22 Tandoori Roti	150	\N
95	9	N23 Paneer Kulcha	300	\N
96	10	N24 Chicken Korma	700	\N
97	10	N25 Chicken Spinach	700	\N
98	10	N26 Chicken Masala	700	\N
99	10	N27 Chicken Vartha	700	\N
100	10	N28 Chicken Jalfrazzi	800	\N
101	10	N29 Chicken Muglai	700	\N
102	10	N30 Butter Chicken	700	\N
103	10	N31 Chicken Tikka Masala	700	\N
104	10	N32 Kadai Chicken	800	\N
105	11	N33 Chicken Briyani	600	\N
106	11	N34 Mutton Briyani	600	\N
107	11	N35 Prawn Briyani	700	\N
108	11	N36 Vegetable Briyani	500	\N
109	11	N37 Kashmiri Pulao	400	\N
110	11	N38 Jeera Rice (Basmati)	350	\N
111	11	N39 Pain White Rice (Basmati)	150	\N
112	12	N40 Mutton Masala	700	\N
113	12	N41 Mutton Do Piaza	800	\N
114	12	N42 Mutton Spinach	800	\N
25	4	D57 Iced Milo	150	1
27	4	D70 Iced Limau	130	1
28	4	Iced Neslo	180	1
30	4	Iced Milo Cino	250	1
115	12	N43 Kadai Mutton	800	\N
116	12	N44 Mutton Kheema	500	\N
117	12	N45 Mutton Korma	700	\N
118	12	N46 Mutton Rogan Josh	700	\N
119	12	N47 Mutton Vindaloo	800	\N
120	13	N48 Kadai Fish	800	\N
121	13	N49 Fish Vindaloo	800	\N
122	13	N50 Madras Fish Curry	700	\N
123	13	N51 Fish Masala	700	\N
124	13	N52 Kadai Prawn	800	\N
125	13	N53 Prawn Vindaloo	800	\N
126	13	N54 Prawn Masala	700	\N
127	13	N55 Prawn Curry	700	\N
128	13	N56 Prawn Do Piaza	800	\N
129	13	N57 Chilli Prawn	800	\N
130	13	N58 Fish Head Curry	1500	\N
131	14	N59 Paneer Butter Masala	700	\N
132	14	N60 Palak Paneer	700	\N
133	14	N61 Kadai Paneer	800	\N
134	14	N62 Shai Paneer	700	\N
135	14	N63 Mattar Paneer	700	\N
136	14	N64 Aloo Mattar Makani	500	\N
137	14	N65 Mix Vegetable Curry	500	\N
138	14	N66 Vegetable Makani	500	\N
139	14	N67 Channa Masala	500	\N
140	14	N68 Dal Makani	500	\N
141	14	N69 Yellow Dal	300	\N
142	14	N70 Dal Palak	500	\N
143	14	N71 Bhindi Masala	500	\N
144	14	N72 Brinjal Masala	500	\N
145	14	N73 Mixed Raita	400	\N
146	14	N74 Plain Yoghurt	300	\N
147	14	N75 Navrattan Korma	600	\N
148	14	N76 Malai Kofta	500	\N
149	14	N77 Paneer Tikka Masala	800	\N
150	14	N78 Green Indian Salad	300	\N
151	14	N79 Gobi Manchurian	600	\N
152	14	N80 Chilli Panner	800	\N
153	14	N81 Aloo Gobi	500	\N
154	15	W01 Mushroom Soup (Cream)	300	\N
155	15	W02 French Fries	300	\N
156	15	W03 Mashed Potato	200	\N
157	15	W04 Coleslaw	150	\N
158	15	W05 Chicken Nuggets (7pcs)	400	\N
159	15	W06 Chicken Wing Set (2pcs)	350	\N
160	15	W07 Chicken Wing Set (3pcs)	450	\N
161	15	W08 Cheese Fries (Regular)	400	\N
163	15	W09 Garlic Bread	200	\N
164	15	W10 Hot Wings (min 2pcs)	150	\N
165	15	W11 Spring Chicken	900	\N
166	16	W12 Chicken Pasta	600	\N
167	16	W13 Beef Bologonaise	650	\N
168	16	W14 Seafood Marinara	650	\N
169	16	W15 Mushroom & Chicken Pasta	650	\N
170	16	W16 Mushroom Olio (Regular)	500	\N
171	16	W16 Mushroom Olio (Large)	800	\N
172	16	W17 Seafood Olio	600	\N
173	16	W18 Sausage Carbonara (Regular)	650	\N
174	17	W19 Garden Salad	400	\N
175	17	W20 Green Pleasure Salad	400	\N
176	17	W21 Chicken Salad	600	\N
177	17	W22 Prawn Salad	600	\N
178	18	W23 Kebab (Original)	400	\N
179	18	W24 Kebab (w/ Cheese)	450	\N
180	19	W25 Roti John	400	\N
181	19	W26 Roti John (Cheese)	450	\N
182	19	W27 Roti John (Mushroom)	450	\N
183	19	W28 Roti John (Black Pepper)	450	\N
184	19	W29 Roti John (Mushroom & Cheese)	480	\N
185	19	W30 Roti John (Combo)	500	\N
186	20	W31 Fried Fish Burger	600	\N
187	20	W32 Grilled Chicken Burger	600	\N
188	20	W33 Grilled Beef Burger	600	\N
189	20	W34 Grilled Lamb Burger	600	\N
190	21	W35 Fish & Chips	700	\N
191	21	W36 Grilled Fish	700	\N
192	21	W37 Garlic Fish	700	\N
193	22	W38 BBQ Lamb	800	\N
194	22	W39 Black Pepper Lamb	800	\N
195	22	W40 Mushroom Lamb	800	\N
196	22	W41 Medina Lamb	900	\N
197	23	W42 Mushroom Steak	800	\N
198	23	W43 Black Pepper Steak	800	\N
199	23	W44 Sirloin Steak	800	\N
200	23	W45 Al Amaan Sirloin Steak	900	\N
201	23	W46 Al Amaan All Time Specials Mix Grill	1200	\N
202	24	W47 Grilled Mushroom Chicken	800	\N
203	24	W48 Grilled Black Pepper Chicken	800	\N
204	24	W49 Grilled Chicken Chop	800	\N
205	24	W50 Chicken Cutlet	800	\N
206	32	T30 Tomyam (Beef Mee)	650	\N
207	32	T30 Tomyam (Beef Beehoon)	650	\N
208	32	T30 Tomyam (Beef Kwayteow)	650	\N
209	32	T30 Tomyam (Beef Maggie)	650	\N
210	32	T30 Tomyam (Chicken Mee)	650	\N
211	32	T30 Tomyam (Chicken Beehoon)	650	\N
212	32	T30 Tomyam (Chicken Kwayteow)	650	\N
213	32	T30 Tomyam (Chicken Maggie)	650	\N
214	32	T30 Tomyam (Seafood Mee)	650	\N
215	32	T30 Tomyam (Seafood Beehoon)	650	\N
216	32	T30 Tomyam (Seafood Kwayteow)	650	\N
217	32	T30 Tomyam (Seafood Maggie)	650	\N
218	33	T31 Bandung Soup (Mee)	450	\N
219	33	T31 Bandung Soup (Beehoon)	450	\N
220	33	T31 Bandung Soup (Kwayteow)	450	\N
221	33	T31 Bandung Soup (Maggie)	450	\N
222	34	T32 Hong Kong (Mee)	450	\N
223	34	T32 Hong Kong (Beehoon)	450	\N
224	34	T32 Hong Kong (Kwayteow)	450	\N
225	34	T32 Hong Kong (Maggie)	450	\N
226	35	T33 Hailam (Mee)	450	\N
227	35	T33 Hailam (Beehoon)	450	\N
228	35	T33 Hailam (Kwayteow)	450	\N
229	35	T33 Hailam (Maggie)	450	\N
230	36	T34 Thai Style Fried (Mee)	480	\N
231	36	T34 Thai Style Fried (Beehoon)	480	\N
232	36	T34 Thai Style Fried (Kwayteow)	480	\N
233	36	T34 Thai Style Fried (Maggie)	480	\N
234	37	T35 Sambal Style Fried (Mee)	450	\N
235	37	T35 Sambal Style Fried (Beehoon)	450	\N
236	37	T35 Sambal Style Fried (Kwayteow)	450	\N
237	37	T35 Sambal Style Fried (Maggie)	450	\N
238	38	T36 Chinese Style Fried (Mee)	450	\N
239	38	T36 Chinese Style Fried (Beehoon)	450	\N
240	38	T36 Chinese Style Fried (Kwayteow)	450	\N
241	38	T36 Chinese Style Fried (Maggie)	450	\N
242	39	T37 Fried w/ Beef (Mee)	450	\N
243	39	T37 Fried w/ Beef (Beehoon)	450	\N
244	39	T37 Fried w/ Beef (Kwayteow)	450	\N
245	39	T37 Fried w/ Beef (Maggie)	450	\N
246	40	T38 Fried w/ Seafood (Mee)	450	\N
247	40	T38 Fried w/ Seafood (Beehoon)	450	\N
248	40	T38 Fried w/ Seafood (Kwayteow)	450	\N
249	40	T38 Fried w/ Seafood (Maggie)	450	\N
250	41	T39 Pataya (Beef Mee)	550	\N
251	41	T39 Pataya (Beef Beehoon)	550	\N
252	41	T39 Pataya (Beef Kwayteow)	550	\N
253	41	T39 Pataya (Beef Maggie)	550	\N
254	41	T39 Pataya (Chicken Mee)	550	\N
255	41	T39 Pataya (Chicken Beehoon)	550	\N
256	41	T39 Pataya (Chicken Kwayteow)	550	\N
257	41	T39 Pataya (Chicken Maggie)	550	\N
258	41	T39 Pataya (Seafood Mee)	550	\N
259	41	T39 Pataya (Seafood Beehoon)	550	\N
260	41	T39 Pataya (Seafood Kwayteow)	550	\N
261	41	T39 Pataya (Seafood Maggie)	550	\N
262	42	T40 Fried with Cockles (Mee)	450	\N
263	42	T40 Fried with Cockles (Beehoon)	450	\N
264	42	T40 Fried with Cockles (Kwayteow)	450	\N
265	42	T40 Fried with Cockles (Maggie)	450	\N
266	43	T41 Steam Rice w/ Chicken (Hot & Spicy)	480	\N
267	43	T42 Steam Rice w/ Chicken (Black Oyster Sauce)	480	\N
268	43	T43 Steam Rice w/ Chicken (Sweet & Sour)	480	\N
269	43	T44 Steam Rice w/ Chicken (Black Pepper)	480	\N
270	43	T45 Steam Rice w/ Chicken (Ginger Brown Sauce)	480	\N
271	43	T46 Steam Rice w/ Chicken (Mui Fan)	450	\N
272	44	T41 Steam Rice w/ Beef (Hot & Spicy)	480	\N
273	44	T42 Steam Rice w/ Beef (Black Oyster Sauce)	480	\N
274	44	T43 Steam Rice w/ Beef (Sweet & Sour)	480	\N
275	44	T44 Steam Rice w/ Beef (Black Pepper)	480	\N
276	44	T45 Steam Rice w/ Beef (Ginger Brown Sauce)	480	\N
277	44	T46 Steam Rice w/ Beef (Mui Fan)	450	\N
278	45	T41 Steam Rice w/ Sliced Fish (Hot & Spicy)	480	\N
279	45	T42 Steam Rice w/ Sliced Fish (Black Oyster Sauce)	480	\N
280	45	T43 Steam Rice w/ Sliced Fish (Sweet & Sour)	480	\N
281	45	T44 Steam Rice w/ Sliced Fish (Black Pepper)	480	\N
282	45	T45 Steam Rice w/ Sliced Fish (Ginger Brown Sauce)	480	\N
283	45	T46 Steam Rice w/ Sliced Fish (Mui Fan)	450	\N
284	46	T41 Steam Rice w/ Cuttlefish (Hot & Spicy)	480	\N
285	46	T42 Steam Rice w/ Cuttlefish (Black Oyster Sauce)	480	\N
286	46	T43 Steam Rice w/ Cuttlefish (Sweet & Sour)	480	\N
287	46	T44 Steam Rice w/ Cuttlefish (Black Pepper)	480	\N
288	46	T45 Steam Rice w/ Cuttlefish (Ginger Brown Sauce)	480	\N
289	46	T46 Steam Rice w/ Cuttlefish (Mui Fan)	450	\N
290	47	T41 Steam Rice w/ Prawn (Hot & Spicy)	480	\N
291	47	T42 Steam Rice w/ Prawn (Black Oyster Sauce)	480	\N
292	47	T43 Steam Rice w/ Prawn (Sweet & Sour)	480	\N
293	47	T44 Steam Rice w/ Prawn (Black Pepper)	480	\N
294	47	T45 Steam Rice w/ Prawn (Ginger Brown Sauce)	480	\N
295	47	T46 Steam Rice w/ Prawn (Mui Fan)	450	\N
162	15	W08 Cheese Fries (Large)	600	\N
\.


--
-- TOC entry 4027 (class 0 OID 22701695)
-- Dependencies: 208
-- Data for Name: al_amaans_mod; Type: TABLE DATA; Schema: menudata; Owner: prasowycsjjunh
--

COPY menudata.al_amaans_mod (mod_id, "group", name, price, level) FROM stdin;
1	1	no ice	20	0
2	1	hot	0	0
3	1	normal	0	0
4	1	25% sugar	0	1
5	1	50% sugar	0	1
6	1	75% sugar	0	1
\.


--
-- TOC entry 4036 (class 0 OID 24285540)
-- Dependencies: 217
-- Data for Name: koi; Type: TABLE DATA; Schema: menudata; Owner: prasowycsjjunh
--

COPY menudata.koi (item_id, parent_id, item_name, price, mod_group) FROM stdin;
0	0	delivery_fee	0	\N
1	0	Flavoured Tea	\N	\N
2	0	Milk Tea	\N	\N
3	0	Signature Macchiato	\N	\N
4	0	Tea Latte	\N	\N
5	0	Healthy Juice	\N	\N
8	1	Green Tea(M)	270	1
9	1	Green Tea(L)	350	2
10	1	Black Tea(M)	270	1
11	1	Black Tea(L)	350	2
12	1	Golden Oolong Tea(M)	270	1
13	1	Golden Oolong Tea(L)	350	2
14	1	Honey Green Tea(M)	330	1
15	1	Honey Green Tea(L)	430	2
16	1	Honey Oolong Tea(M)	330	1
17	1	Honey Oolong Tea(L)	430	2
18	1	Lemon Green Tea(M)	370	1
19	1	Lemon Green Tea(L)	490	2
20	1	Lime Green Tea(M)	370	1
21	1	Lime Green Tea(L)	490	2
22	1	Plum Green Tea(M)	370	1
23	1	Plum Green Tea(L)	490	2
24	1	Peach Green Tea(M)	370	1
25	1	Peach Green Tea(L)	490	2
26	1	Lemon Lime Green Tea(M)	370	1
27	1	Lemon Lime Green Tea(L)	490	2
28	1	Lemon Plum Green Tea(M)	370	1
29	1	Lemon Plum Green Tea(L)	490	2
30	1	Yakult Green Tea(M)	400	1
31	1	Yakult Green Tea(L)	530	2
32	1	Passion Fruit Green Tea(M)	400	1
33	1	Passion Fruit Green Tea(L)	530	2
34	1	Grapefruit Green Tea(M)	460	1
35	1	Grapefruit Green Tea(L)	610	2
36	2	Milk Tea(M)	340	1
37	2	Milk Tea(L)	450	2
38	2	Green Milk Tea(M)	340	1
39	2	Green Milk Tea(L)	450	2
40	2	Oolong Milk Tea(M)	340	1
41	2	Oolong Milk Tea(L)	340	2
42	2	Golden Bubble Milk Tea(M)	400	1
43	2	Golden Bubble Milk Tea(L)	530	2
44	2	Hazelnut Milk Tea(M)	400	1
45	2	Hazelnut Milk Tea(L)	530	2
46	2	Caramel Tea(M)	400	1
47	2	Caramel Tea(L)	530	2
48	2	Honey Milk Tea(M)	400	1
49	2	Honey Milk Tea(L)	530	2
50	2	Honey Oolong Milk Tea(M)	400	1
51	2	Honey Oolong Milk Tea(L)	530	2
52	2	Chocolate Milk(M)	400	1
53	2	Chocolate Milk(L)	530	2
54	2	Cacao Barry(M)	400	1
55	2	Cacao Barry(L)	530	2
56	2	Ovaltine(M)	340	1
57	2	Ovaltine(L)	340	2
70	4	Ceylon Black Tea Latte(M)	400	1
71	4	Ceylon Black Tea Latte(L)	530	2
72	4	Green Tea Latte(M)	400	1
73	4	Green Tea Latte(L)	530	2
74	4	Oolong Tea Latte(M)	400	1
75	4	Oolong Tea Latte(L)	530	2
76	4	Cacao Barry Latte(M)	460	1
77	4	Cacao Barry Latte(L)	610	2
78	4	Hazelnut Ceylon Black Tea Latte(M)	460	1
79	4	Hazelnut Ceylon Black Tea Latte(L)	610	2
80	5	Lemon Juice(M)	340	1
81	5	Lemon Juice(L)	450	2
82	5	Lime Juice(M)	340	1
83	5	Lime Juice(L)	450	2
84	5	No.8 Juice(M)	340	1
85	5	No.8 Juice(L)	450	2
86	5	Ice Honey(M)	340	1
87	5	Ice Honey(L)	450	2
88	5	Lemon Plum Juice(M)	340	1
89	5	Lemon Plum Juice(L)	450	2
90	5	Honey Lemon Lime Juice(M)	400	1
91	5	Honey Lemon Lime Juice(L)	530	2
92	5	Grapefruit Juice(M)	460	1
93	5	Grapefruit Juice(L)	610	2
58	3	Black Tea Macchiato(M)	330	3
59	3	Black Tea Macchiato(L)	430	3
60	3	Green Tea Macchiato(M)	330	3
61	3	Green Tea Macchiato(L)	430	3
62	3	Oolong Tea Macchiato(M)	330	3
63	3	Oolong Tea Macchiato(L)	430	3
64	3	Caramel Black Tea Macchiato(M)	440	3
65	3	Caramel Black Tea Macchiato(L)	590	3
66	3	Cacao Barry Macchiato(M)	440	3
67	3	Cacao Barry Macchiato(L)	590	3
68	3	Ovaltine Macchiato(M)	440	3
69	3	Ovaltine Macchiato(L)	590	3
\.


--
-- TOC entry 4037 (class 0 OID 24285543)
-- Dependencies: 218
-- Data for Name: koi_mod; Type: TABLE DATA; Schema: menudata; Owner: prasowycsjjunh
--

COPY menudata.koi_mod (mod_id, "group", name, price, level) FROM stdin;
1	1	Sugar Level 120%	0	0
2	1	Sugar Level 100%	0	0
3	1	Sugar Level 70%	0	0
4	1	Sugar Level 50%	0	0
5	1	Sugar Level 25%	0	0
6	1	Sugar Level 0%	0	0
7	2	Sugar Level 120%	0	0
8	2	Sugar Level 100%	0	0
9	2	Sugar Level 70%	0	0
10	2	Sugar Level 50%	0	0
11	2	Sugar Level 25%	0	0
12	2	Sugar Level 0%	0	0
13	1	Golden Bubble	60	2
14	1	Coconut Ice Cream	80	2
15	1	Aloe Vera	120	2
16	1	Grass Jelly	120	2
17	1	Konjac Jelly	120	2
18	1	Taro Q	120	2
19	2	Golden Bubble	80	2
20	2	Coconut Ice Cream	120	2
21	2	Aloe Vera	160	2
22	2	Grass Jelly	160	2
23	2	Konjac Jelly	160	2
24	2	Taro Q	160	2
25	1	No Toppings	0	2
26	2	No Toppings	0	2
27	1	no ice	0	1
28	1	less ice	0	1
29	1	normal	0	1
30	2	no ice	0	1
31	2	less ice	0	1
32	2	normal	0	1
33	3	Sugar Level 120%	0	0
34	3	Sugar Level 100%	0	0
35	3	Sugar Level 70%	0	0
36	3	Sugar Level 50%	0	0
37	3	Sugar Level 25%	0	0
38	3	Sugar Level 0%	0	0
39	3	no ice	0	1
40	3	less ice	0	1
41	3	normal	0	1
\.


--
-- TOC entry 4034 (class 0 OID 24033994)
-- Dependencies: 215
-- Data for Name: cache; Type: TABLE DATA; Schema: miscellaneous; Owner: prasowycsjjunh
--

COPY miscellaneous.cache (key, data, "time") FROM stdin;
-335192059	{"message_id":124420}	2021-06-01 03:47:26.944606+00
\.


--
-- TOC entry 4035 (class 0 OID 24034000)
-- Dependencies: 216
-- Data for Name: helper; Type: TABLE DATA; Schema: miscellaneous; Owner: prasowycsjjunh
--

COPY miscellaneous.helper (string, count, "time") FROM stdin;
-1001260374311/happybirthdaysengleng	47	2021-06-01 07:51:37.526135+00
-1001260374311/happybirthdaysengleng@SupperJio_v2_bot	1	2021-05-31 16:42:40.307586+00
-1001260374311/happybirthdaysenglengandben@SupperJio_v2_bot	1	2021-06-01 08:47:58.161852+00
-1001260374311/happybirthdayyitching	50	2021-06-02 11:17:31.328714+00
-1001260374311/happybirthdaysenglengandben	31	2021-06-01 11:43:04.82524+00
-1001419588496/happybirthdaysengleng	8	2021-06-01 01:12:25.746472+00
\.


--
-- TOC entry 4040 (class 0 OID 25490325)
-- Dependencies: 221
-- Data for Name: Thor's Body; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Thor's Body" ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4046 (class 0 OID 25490340)
-- Dependencies: 227
-- Data for Name: Thor's Existential; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Thor's Existential" ("userID", "queueNumber") FROM stdin;
367913189	2
790145840	3
678101743	4
\.


--
-- TOC entry 4042 (class 0 OID 25490330)
-- Dependencies: 223
-- Data for Name: Thor's Linguistic; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Thor's Linguistic" ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4044 (class 0 OID 25490335)
-- Dependencies: 225
-- Data for Name: Thor's Musical; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Thor's Musical" ("userID", "queueNumber") FROM stdin;
448252759	2
571587629	3
376289946	4
\.


--
-- TOC entry 4048 (class 0 OID 25490345)
-- Dependencies: 229
-- Data for Name: Tue Station 1; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Tue Station 1" ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4050 (class 0 OID 25490350)
-- Dependencies: 231
-- Data for Name: Tue Station 2; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Tue Station 2" ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4052 (class 0 OID 25490355)
-- Dependencies: 233
-- Data for Name: Tue Station 3; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Tue Station 3" ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4054 (class 0 OID 25490360)
-- Dependencies: 235
-- Data for Name: Wed Linguistic; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Wed Linguistic" ("userID", "queueNumber") FROM stdin;
126913124	4
653421992	5
356312836	6
740489610	7
\.


--
-- TOC entry 4056 (class 0 OID 25490365)
-- Dependencies: 237
-- Data for Name: Wed Music; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Wed Music" ("userID", "queueNumber") FROM stdin;
70681348	7
340628101	8
499898543	9
646785010	10
\.


--
-- TOC entry 4058 (class 0 OID 25490370)
-- Dependencies: 239
-- Data for Name: Wed Personal; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Wed Personal" ("userID", "queueNumber") FROM stdin;
348939716	8
542451018	9
\.


--
-- TOC entry 4059 (class 0 OID 25490373)
-- Dependencies: 240
-- Data for Name: Wed Personal 2; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations."Wed Personal 2" ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4062 (class 0 OID 25490380)
-- Dependencies: 243
-- Data for Name: station1; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations.station1 ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4064 (class 0 OID 25490385)
-- Dependencies: 245
-- Data for Name: station2; Type: TABLE DATA; Schema: stations; Owner: prasowycsjjunh
--

COPY stations.station2 ("userID", "queueNumber") FROM stdin;
\.


--
-- TOC entry 4077 (class 0 OID 0)
-- Dependencies: 212
-- Name: modifiers_id_seq; Type: SEQUENCE SET; Schema: jiodata; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('jiodata.modifiers_id_seq', 1543, true);


--
-- TOC entry 4078 (class 0 OID 0)
-- Dependencies: 214
-- Name: orderid_seq; Type: SEQUENCE SET; Schema: jiodata; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('jiodata.orderid_seq', 3667, true);


--
-- TOC entry 4079 (class 0 OID 0)
-- Dependencies: 209
-- Name: al_amaans_mod_id_seq; Type: SEQUENCE SET; Schema: menudata; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('menudata.al_amaans_mod_id_seq', 6, true);


--
-- TOC entry 4080 (class 0 OID 0)
-- Dependencies: 222
-- Name: Thor''s Body_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Thor''''s Body_queueNumber_seq"', 3, true);


--
-- TOC entry 4081 (class 0 OID 0)
-- Dependencies: 224
-- Name: Thor''s Linguistic_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Thor''''s Linguistic_queueNumber_seq"', 4, true);


--
-- TOC entry 4082 (class 0 OID 0)
-- Dependencies: 226
-- Name: Thor''s Musical_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Thor''''s Musical_queueNumber_seq"', 4, true);


--
-- TOC entry 4083 (class 0 OID 0)
-- Dependencies: 228
-- Name: Thor's Existential_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Thor''s Existential_queueNumber_seq"', 4, true);


--
-- TOC entry 4084 (class 0 OID 0)
-- Dependencies: 230
-- Name: Tue Station 1_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Tue Station 1_queueNumber_seq"', 1, true);


--
-- TOC entry 4085 (class 0 OID 0)
-- Dependencies: 232
-- Name: Tue Station 2_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Tue Station 2_queueNumber_seq"', 1, false);


--
-- TOC entry 4086 (class 0 OID 0)
-- Dependencies: 234
-- Name: Tue Station 3_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Tue Station 3_queueNumber_seq"', 1, false);


--
-- TOC entry 4087 (class 0 OID 0)
-- Dependencies: 236
-- Name: Wed Linguistic_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Wed Linguistic_queueNumber_seq"', 7, true);


--
-- TOC entry 4088 (class 0 OID 0)
-- Dependencies: 238
-- Name: Wed Music Station Admin_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Wed Music Station Admin_queueNumber_seq"', 10, true);


--
-- TOC entry 4089 (class 0 OID 0)
-- Dependencies: 241
-- Name: Wed Personal 2_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Wed Personal 2_queueNumber_seq"', 11, true);


--
-- TOC entry 4090 (class 0 OID 0)
-- Dependencies: 242
-- Name: Wed Personal_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."Wed Personal_queueNumber_seq"', 9, true);


--
-- TOC entry 4091 (class 0 OID 0)
-- Dependencies: 244
-- Name: station1_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."station1_queueNumber_seq"', 42, true);


--
-- TOC entry 4092 (class 0 OID 0)
-- Dependencies: 246
-- Name: station2_queueNumber_seq; Type: SEQUENCE SET; Schema: stations; Owner: prasowycsjjunh
--

SELECT pg_catalog.setval('stations."station2_queueNumber_seq"', 2, true);


--
-- TOC entry 3854 (class 2606 OID 22707976)
-- Name: jios jios_pkey; Type: CONSTRAINT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.jios
    ADD CONSTRAINT jios_pkey PRIMARY KEY (chat_id);


--
-- TOC entry 3857 (class 2606 OID 22707978)
-- Name: modifiers modifiers_pkey; Type: CONSTRAINT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.modifiers
    ADD CONSTRAINT modifiers_pkey PRIMARY KEY (id);


--
-- TOC entry 3859 (class 2606 OID 22707980)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 3871 (class 2606 OID 25490391)
-- Name: stations master_pkey; Type: CONSTRAINT; Schema: master; Owner: prasowycsjjunh
--

ALTER TABLE ONLY master.stations
    ADD CONSTRAINT master_pkey PRIMARY KEY (name);


--
-- TOC entry 3869 (class 2606 OID 25490393)
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: master; Owner: prasowycsjjunh
--

ALTER TABLE ONLY master.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY ("userID");


--
-- TOC entry 3852 (class 2606 OID 22701708)
-- Name: al_amaans_mod al_amaans_mod_pkey; Type: CONSTRAINT; Schema: menudata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY menudata.al_amaans_mod
    ADD CONSTRAINT al_amaans_mod_pkey PRIMARY KEY (mod_id);


--
-- TOC entry 3850 (class 2606 OID 22701710)
-- Name: al_amaans alamaans_pkey; Type: CONSTRAINT; Schema: menudata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY menudata.al_amaans
    ADD CONSTRAINT alamaans_pkey PRIMARY KEY (item_id);


--
-- TOC entry 3867 (class 2606 OID 24285553)
-- Name: koi_mod koi_mod_pkey; Type: CONSTRAINT; Schema: menudata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY menudata.koi_mod
    ADD CONSTRAINT koi_mod_pkey PRIMARY KEY (mod_id);


--
-- TOC entry 3865 (class 2606 OID 24285555)
-- Name: koi koi_pkey; Type: CONSTRAINT; Schema: menudata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY menudata.koi
    ADD CONSTRAINT koi_pkey PRIMARY KEY (item_id);


--
-- TOC entry 3861 (class 2606 OID 24034010)
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: miscellaneous; Owner: prasowycsjjunh
--

ALTER TABLE ONLY miscellaneous.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- TOC entry 3863 (class 2606 OID 24034012)
-- Name: helper helper_pkey; Type: CONSTRAINT; Schema: miscellaneous; Owner: prasowycsjjunh
--

ALTER TABLE ONLY miscellaneous.helper
    ADD CONSTRAINT helper_pkey PRIMARY KEY (string);


--
-- TOC entry 3873 (class 2606 OID 25490395)
-- Name: Thor's Body Thor''s Body_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Thor's Body"
    ADD CONSTRAINT "Thor''s Body_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3875 (class 2606 OID 25490397)
-- Name: Thor's Linguistic Thor''s Linguistic_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Thor's Linguistic"
    ADD CONSTRAINT "Thor''s Linguistic_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3877 (class 2606 OID 25490399)
-- Name: Thor's Musical Thor''s Musical_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Thor's Musical"
    ADD CONSTRAINT "Thor''s Musical_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3879 (class 2606 OID 25490401)
-- Name: Thor's Existential Thor's Existential_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Thor's Existential"
    ADD CONSTRAINT "Thor's Existential_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3881 (class 2606 OID 25490403)
-- Name: Tue Station 1 Tue Station 1_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Tue Station 1"
    ADD CONSTRAINT "Tue Station 1_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3883 (class 2606 OID 25490405)
-- Name: Tue Station 2 Tue Station 2_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Tue Station 2"
    ADD CONSTRAINT "Tue Station 2_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3885 (class 2606 OID 25490407)
-- Name: Tue Station 3 Tue Station 3_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Tue Station 3"
    ADD CONSTRAINT "Tue Station 3_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3887 (class 2606 OID 25490409)
-- Name: Wed Linguistic Wed Linguistic_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Wed Linguistic"
    ADD CONSTRAINT "Wed Linguistic_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3889 (class 2606 OID 25490411)
-- Name: Wed Music Wed Music Station Admin_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Wed Music"
    ADD CONSTRAINT "Wed Music Station Admin_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3893 (class 2606 OID 25490413)
-- Name: Wed Personal 2 Wed Personal 2_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Wed Personal 2"
    ADD CONSTRAINT "Wed Personal 2_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3891 (class 2606 OID 25490415)
-- Name: Wed Personal Wed Personal_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations."Wed Personal"
    ADD CONSTRAINT "Wed Personal_pkey" PRIMARY KEY ("queueNumber");


--
-- TOC entry 3895 (class 2606 OID 25490417)
-- Name: station1 station1_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations.station1
    ADD CONSTRAINT station1_pkey PRIMARY KEY ("queueNumber");


--
-- TOC entry 3897 (class 2606 OID 25490419)
-- Name: station2 station2_pkey; Type: CONSTRAINT; Schema: stations; Owner: prasowycsjjunh
--

ALTER TABLE ONLY stations.station2
    ADD CONSTRAINT station2_pkey PRIMARY KEY ("queueNumber");


--
-- TOC entry 3855 (class 1259 OID 22707981)
-- Name: modifiers_order_id_level_idx; Type: INDEX; Schema: jiodata; Owner: prasowycsjjunh
--

CREATE UNIQUE INDEX modifiers_order_id_level_idx ON jiodata.modifiers USING btree (order_id, level);


--
-- TOC entry 3899 (class 2606 OID 22707982)
-- Name: orders chat_id; Type: FK CONSTRAINT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.orders
    ADD CONSTRAINT chat_id FOREIGN KEY (chat_id) REFERENCES jiodata.jios(chat_id) ON DELETE CASCADE;


--
-- TOC entry 3898 (class 2606 OID 23133257)
-- Name: modifiers order_id_fkey; Type: FK CONSTRAINT; Schema: jiodata; Owner: prasowycsjjunh
--

ALTER TABLE ONLY jiodata.modifiers
    ADD CONSTRAINT order_id_fkey FOREIGN KEY (order_id) REFERENCES jiodata.orders(order_id) ON DELETE CASCADE NOT VALID;


--
-- TOC entry 4071 (class 0 OID 0)
-- Dependencies: 759
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO prasowycsjjunh;


-- Completed on 2021-06-03 13:08:22

--
-- PostgreSQL database dump complete
--

