--
-- PostgreSQL database dump
--

-- Dumped from database version 12.4
-- Dumped by pg_dump version 12.4

-- Started on 2021-06-03 13:17:35

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
-- TOC entry 10 (class 2615 OID 33787)
-- Name: jiodata; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA jiodata;


ALTER SCHEMA jiodata OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 33788)
-- Name: menudata; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA menudata;


ALTER SCHEMA menudata OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 33789)
-- Name: miscellaneous; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA miscellaneous;


ALTER SCHEMA miscellaneous OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 205 (class 1259 OID 33790)
-- Name: jios; Type: TABLE; Schema: jiodata; Owner: postgres
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


ALTER TABLE jiodata.jios OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 33798)
-- Name: modifiers; Type: TABLE; Schema: jiodata; Owner: postgres
--

CREATE TABLE jiodata.modifiers (
    id integer NOT NULL,
    order_id integer NOT NULL,
    level integer NOT NULL,
    name character varying(40) NOT NULL,
    price integer DEFAULT 0
);


ALTER TABLE jiodata.modifiers OWNER TO postgres;

--
-- TOC entry 207 (class 1259 OID 33802)
-- Name: modifiers_id_seq; Type: SEQUENCE; Schema: jiodata; Owner: postgres
--

CREATE SEQUENCE jiodata.modifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jiodata.modifiers_id_seq OWNER TO postgres;

--
-- TOC entry 2918 (class 0 OID 0)
-- Dependencies: 207
-- Name: modifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: jiodata; Owner: postgres
--

ALTER SEQUENCE jiodata.modifiers_id_seq OWNED BY jiodata.modifiers.id;


--
-- TOC entry 208 (class 1259 OID 33804)
-- Name: orders; Type: TABLE; Schema: jiodata; Owner: postgres
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


ALTER TABLE jiodata.orders OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 33807)
-- Name: orderid_seq; Type: SEQUENCE; Schema: jiodata; Owner: postgres
--

CREATE SEQUENCE jiodata.orderid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE jiodata.orderid_seq OWNER TO postgres;

--
-- TOC entry 2919 (class 0 OID 0)
-- Dependencies: 209
-- Name: orderid_seq; Type: SEQUENCE OWNED BY; Schema: jiodata; Owner: postgres
--

ALTER SEQUENCE jiodata.orderid_seq OWNED BY jiodata.orders.order_id;


--
-- TOC entry 210 (class 1259 OID 33809)
-- Name: al_amaans; Type: TABLE; Schema: menudata; Owner: postgres
--

CREATE TABLE menudata.al_amaans (
    item_id integer NOT NULL,
    parent_id integer NOT NULL,
    item_name character varying(255) NOT NULL,
    price integer,
    mod_group integer
);


ALTER TABLE menudata.al_amaans OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 33812)
-- Name: al_amaans_mod; Type: TABLE; Schema: menudata; Owner: postgres
--

CREATE TABLE menudata.al_amaans_mod (
    mod_id integer NOT NULL,
    "group" integer NOT NULL,
    name character varying(40) NOT NULL,
    price integer DEFAULT 0,
    level integer DEFAULT 0
);


ALTER TABLE menudata.al_amaans_mod OWNER TO postgres;

--
-- TOC entry 212 (class 1259 OID 33817)
-- Name: al_amaans_mod_id_seq; Type: SEQUENCE; Schema: menudata; Owner: postgres
--

CREATE SEQUENCE menudata.al_amaans_mod_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE menudata.al_amaans_mod_id_seq OWNER TO postgres;

--
-- TOC entry 2920 (class 0 OID 0)
-- Dependencies: 212
-- Name: al_amaans_mod_id_seq; Type: SEQUENCE OWNED BY; Schema: menudata; Owner: postgres
--

ALTER SEQUENCE menudata.al_amaans_mod_id_seq OWNED BY menudata.al_amaans_mod.mod_id;


--
-- TOC entry 213 (class 1259 OID 33819)
-- Name: koi; Type: TABLE; Schema: menudata; Owner: postgres
--

CREATE TABLE menudata.koi (
    item_id integer NOT NULL,
    parent_id integer NOT NULL,
    item_name character varying(255) NOT NULL,
    price integer,
    mod_group integer
);


ALTER TABLE menudata.koi OWNER TO postgres;

--
-- TOC entry 214 (class 1259 OID 33822)
-- Name: koi_mod; Type: TABLE; Schema: menudata; Owner: postgres
--

CREATE TABLE menudata.koi_mod (
    mod_id integer NOT NULL,
    "group" integer NOT NULL,
    name character varying NOT NULL,
    price integer NOT NULL,
    level integer NOT NULL
);


ALTER TABLE menudata.koi_mod OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 33828)
-- Name: xing_long_fish_soup; Type: TABLE; Schema: menudata; Owner: postgres
--

CREATE TABLE menudata.xing_long_fish_soup (
    item_id integer NOT NULL,
    parent_id integer NOT NULL,
    item_name character varying(255) NOT NULL,
    price integer,
    mod_group integer
);


ALTER TABLE menudata.xing_long_fish_soup OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 33831)
-- Name: xing_long_fish_soup_mod; Type: TABLE; Schema: menudata; Owner: postgres
--

CREATE TABLE menudata.xing_long_fish_soup_mod (
    mod_id integer NOT NULL,
    "group" integer NOT NULL,
    name character varying NOT NULL,
    price integer NOT NULL,
    level integer NOT NULL
);


ALTER TABLE menudata.xing_long_fish_soup_mod OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 33837)
-- Name: cache; Type: TABLE; Schema: miscellaneous; Owner: postgres
--

CREATE TABLE miscellaneous.cache (
    key bigint NOT NULL,
    data text NOT NULL,
    "time" timestamp with time zone NOT NULL
);


ALTER TABLE miscellaneous.cache OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 33843)
-- Name: helper; Type: TABLE; Schema: miscellaneous; Owner: postgres
--

CREATE TABLE miscellaneous.helper (
    string text NOT NULL,
    count integer NOT NULL,
    "time" timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE miscellaneous.helper OWNER TO postgres;

--
-- TOC entry 2742 (class 2604 OID 33850)
-- Name: modifiers id; Type: DEFAULT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.modifiers ALTER COLUMN id SET DEFAULT nextval('jiodata.modifiers_id_seq'::regclass);


--
-- TOC entry 2743 (class 2604 OID 33851)
-- Name: orders order_id; Type: DEFAULT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.orders ALTER COLUMN order_id SET DEFAULT nextval('jiodata.orderid_seq'::regclass);


--
-- TOC entry 2746 (class 2604 OID 33852)
-- Name: al_amaans_mod mod_id; Type: DEFAULT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.al_amaans_mod ALTER COLUMN mod_id SET DEFAULT nextval('menudata.al_amaans_mod_id_seq'::regclass);


--
-- TOC entry 2899 (class 0 OID 33790)
-- Dependencies: 205
-- Data for Name: jios; Type: TABLE DATA; Schema: jiodata; Owner: postgres
--

COPY jiodata.jios (chat_id, creator_id, creator_name, "time", duration, menu, message_id, description, listener_ids, text, inline_keyboard) FROM stdin;
\.


--
-- TOC entry 2900 (class 0 OID 33798)
-- Dependencies: 206
-- Data for Name: modifiers; Type: TABLE DATA; Schema: jiodata; Owner: postgres
--

COPY jiodata.modifiers (id, order_id, level, name, price) FROM stdin;
\.


--
-- TOC entry 2902 (class 0 OID 33804)
-- Dependencies: 208
-- Data for Name: orders; Type: TABLE DATA; Schema: jiodata; Owner: postgres
--

COPY jiodata.orders (order_id, chat_id, user_id, user_name, item_id, message_id, remarks) FROM stdin;
\.


--
-- TOC entry 2904 (class 0 OID 33809)
-- Dependencies: 210
-- Data for Name: al_amaans; Type: TABLE DATA; Schema: menudata; Owner: postgres
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
25	4	D57 Iced Milo	180	1
101	10	N29 Chicken Muglai	810	\N
109	11	N37 Kashmiri Pulao	410	\N
88	9	N16 Kashmiri Naan	400	\N
90	9	N18 Kheema Naan	400	\N
93	9	N21 Garlic & Onion Kulcha	350	\N
27	4	D70 Iced Limau	130	1
28	4	Iced Neslo	180	1
30	4	Iced Milo Cino	250	1
85	9	N13 Plain Naan	170	\N
86	9	N14 Butter Naan	200	\N
87	9	N15 Garlic Naan	270	\N
89	9	N17 Cheese Naan	350	\N
91	9	N19 Aloo Pratha	270	\N
92	9	N20 Poodina Pratha	220	\N
94	9	N22 Tandoori Roti	170	\N
95	9	N23 Paneer Kulcha	350	\N
96	10	N24 Chicken Korma	710	\N
97	10	N25 Chicken Spinach	710	\N
98	10	N26 Chicken Masala	710	\N
99	10	N27 Chicken Vartha	710	\N
100	10	N28 Chicken Jalfrazzi	810	\N
103	10	N31 Chicken Tikka Masala	710	\N
104	10	N32 Kadai Chicken	910	\N
105	11	N33 Chicken Briyani	710	\N
106	11	N34 Mutton Briyani	710	\N
107	11	N35 Prawn Briyani	810	\N
108	11	N36 Vegetable Briyani	510	\N
110	11	N38 Jeera Rice (Basmati)	360	\N
111	11	N39 Plain White Rice (Basmati)	160	\N
112	12	N40 Mutton Masala	710	\N
113	12	N41 Mutton Do Piaza	810	\N
114	12	N42 Mutton Spinach	810	\N
115	12	N43 Kadai Mutton	910	\N
116	12	N44 Mutton Kheema	510	\N
117	12	N45 Mutton Korma	710	\N
118	12	N46 Mutton Rogan Josh	810	\N
119	12	N47 Mutton Vindaloo	810	\N
120	13	N48 Kadai Fish	810	\N
121	13	N49 Fish Vindaloo	810	\N
122	13	N50 Madras Fish Curry	710	\N
123	13	N51 Fish Masala	710	\N
124	13	N52 Kadai Prawn	810	\N
178	18	W23 Kebab (Original)	400	\N
179	18	W24 Kebab (w/ Cheese)	450	\N
180	19	W25 Roti John	400	\N
181	19	W26 Roti John (Cheese)	450	\N
182	19	W27 Roti John (Mushroom)	450	\N
183	19	W28 Roti John (Black Pepper)	450	\N
184	19	W29 Roti John (Mushroom & Cheese)	480	\N
154	15	W01 Mushroom Soup (Cream)	360	\N
155	15	W02 French Fries	310	\N
156	15	W03 Mashed Potato	210	\N
157	15	W04 Coleslaw	160	\N
158	15	W05 Chicken Nuggets (6pcs)	410	\N
159	15	W06 Chicken Wing Set (2pcs)	360	\N
160	15	W07 Chicken Wing Set (3pcs)	460	\N
161	15	W08 Cheese Fries (Regular)	460	\N
163	15	W09 Garlic Bread	310	\N
164	15	W10 Hot Wings (min 2pcs)	170	\N
165	15	W11 Spring Chicken	1210	\N
166	16	W12 Chicken Pasta	610	\N
167	16	W13 Beef Bologonaise	660	\N
168	16	W14 Seafood Marinara	660	\N
169	16	W15 Mushroom & Chicken Pasta	660	\N
170	16	W16 Mushroom Olio (Regular)	510	\N
171	16	W16 Mushroom Olio (Large)	860	\N
172	16	W17 Seafood Olio	710	\N
173	16	W18 Sausage Carbonara (Regular)	660	\N
174	17	W19 Garden Salad	410	\N
175	17	W20 Green Pleasure Salad	410	\N
176	17	W21 Chicken Salad	610	\N
177	17	W22 Prawn Salad	610	\N
185	19	W30 Roti John (Combo)	700	\N
186	20	W31 Fried Fish Burger	710	\N
187	20	W32 Grilled Chicken Burger	710	\N
188	20	W33 Grilled Beef Burger	710	\N
189	20	W34 Grilled Lamb Burger	710	\N
190	21	W35 Fish & Chips	810	\N
191	21	W36 Grilled Fish	810	\N
192	21	W37 Garlic Fish	810	\N
193	22	W38 BBQ Lamb	910	\N
194	22	W39 Black Pepper Lamb	960	\N
195	22	W40 Mushroom Lamb	960	\N
196	22	W41 Medina Lamb	810	\N
197	23	W42 Mushroom Steak	960	\N
198	23	W43 Black Pepper Steak	910	\N
199	23	W44 Sirloin Steak	910	\N
200	23	W45 Al Amaan Sirloin Steak	1010	\N
201	23	W46 Al Amaan All Time Specials Mix Grill	1410	\N
202	24	W47 Grilled Mushroom Chicken	960	\N
203	24	W48 Grilled Black Pepper Chicken	910	\N
204	24	W49 Grilled Chicken Chop	910	\N
205	24	W50 Chicken Cutlet	910	\N
206	32	T30 Tomyam (Beef Mee)	710	\N
207	32	T30 Tomyam (Beef Beehoon)	710	\N
208	32	T30 Tomyam (Beef Kwayteow)	710	\N
209	32	T30 Tomyam (Beef Maggie)	710	\N
210	32	T30 Tomyam (Chicken Mee)	710	\N
211	32	T30 Tomyam (Chicken Beehoon)	710	\N
212	32	T30 Tomyam (Chicken Kwayteow)	710	\N
213	32	T30 Tomyam (Chicken Maggie)	710	\N
214	32	T30 Tomyam (Seafood Mee)	710	\N
215	32	T30 Tomyam (Seafood Beehoon)	710	\N
216	32	T30 Tomyam (Seafood Kwayteow)	710	\N
217	32	T30 Tomyam (Seafood Maggie)	710	\N
218	33	T31 Bandung Soup (Mee)	560	\N
219	33	T31 Bandung Soup (Beehoon)	560	\N
220	33	T31 Bandung Soup (Kwayteow)	560	\N
221	33	T31 Bandung Soup (Maggie)	560	\N
222	34	T32 Hong Kong (Mee)	560	\N
223	34	T32 Hong Kong (Beehoon)	560	\N
224	34	T32 Hong Kong (Kwayteow)	560	\N
225	34	T32 Hong Kong (Maggie)	560	\N
226	35	T33 Hailam (Mee)	560	\N
227	35	T33 Hailam (Beehoon)	560	\N
48	8	T47 FR Chinese Style w/ Chicken	510	\N
49	8	T48 FR Thai Style w/ Chicken Prawn Cuttlefish	560	\N
50	8	T49 FR Ikan Bilis & Egg	460	\N
51	8	T50 FR Tomato & Chicken	510	\N
52	8	T51 FR Fried Chicken w/ Chilli Sauce	560	\N
53	8	T52 FR Salted Fish	510	\N
54	8	T53 FR Kampong Style (Regular)	590	\N
56	8	T54 FR Cockles	530	\N
57	8	T55 FR Pataya (Chicken)	610	\N
58	8	T55 FR Pataya (Beef)	610	\N
59	8	T55 FR Pataya (Seafood)	610	\N
60	8	T56 FR Chinese Style w/ Red Chilli Beef	610	\N
61	8	T56 FR Thai Style w/ Red Chilli Beef	610	\N
62	8	T57 FR Chinese Style Hot & Spicy (Chicken)	610	\N
63	8	T57 FR Chinese Style Hot & Spicy (Seafood)	610	\N
64	8	T58 FR Thai Style Hot & Spicy (Chicken)	610	\N
65	8	T58 FR Thai Style Hot & Spicy (Seafood)	610	\N
66	8	T59 FR Chinese Style w/ Black Oyster Sauce (Beef)	610	\N
67	8	T59 FR Chinese Style w/ Black Oyster Sauce (Chicken)	610	\N
68	8	T60 FR Button Mushroom & Egg	510	\N
69	8	T61 FR Sambal Mushroom & Chicken	660	\N
70	8	T62 FR 3 Tastes (Sweet Sour Spicy) w/ Chicken & Seafood	710	\N
71	8	T63 FR Sambal w/ Fried Sambal Chicken	660	\N
72	8	T64 FR Black Pepper (Chicken)	660	\N
73	8	T64 FR Black Pepper (Beef)	660	\N
74	8	T65 FR Pineapple w/ Chicken & Seafood	610	\N
75	8	T66 FR Chinese Style w/ Sweet & Sour (Chicken)	660	\N
76	8	T66 FR Chinese Style w/ Sweet & Sour (Sliced Fish)	660	\N
77	8	T67 FR Chinese Style w/ Ginger Brown Sauce (Chicken)	660	\N
78	8	T67 FR Chinese Style w/ Ginger Brown Sauce (Beef)	660	\N
79	8	T68 FR Thai Style w/ Crispy Ginger Yellow Chicken & Egg	710	\N
80	8	T69 FR Bush (Yellow FR w/ Egg Hot & Spicy Chicken)	710	\N
81	8	T70 FR Obama (Yellow FR w/ Egg Hot & Spicy Beef)	710	\N
82	8	T71 FR Thai Style w/ Chicken Egg Sambal	610	\N
83	8	T71 FR Chinese Style w/ Chicken Egg Sambal	610	\N
84	8	T72 FR Al Amaan (Special)	760	\N
125	13	N53 Prawn Vindaloo	810	\N
126	13	N54 Prawn Masala	710	\N
127	13	N55 Prawn Curry	710	\N
128	13	N56 Prawn Do Piaza	810	\N
129	13	N57 Chilli Prawn	810	\N
130	13	N58 Fish Head Curry	2500	\N
131	14	N59 Paneer Butter Masala	810	\N
132	14	N60 Palak Paneer	810	\N
133	14	N61 Kadai Paneer	910	\N
134	14	N62 Shai Paneer	810	\N
135	14	N63 Mattar Paneer	810	\N
136	14	N64 Aloo Mattar Makhani	510	\N
137	14	N65 Mix Vegetable Curry	510	\N
138	14	N66 Vegetable Makhani	610	\N
139	14	N67 Channa Masala	610	\N
140	14	N68 Dal Makhani	510	\N
141	14	N69 Yellow Dal	410	\N
142	14	N70 Dal Palak	510	\N
143	14	N71 Bhindi Masala	510	\N
248	40	T38 Fried w/ Seafood (Kwayteow)	560	\N
249	40	T38 Fried w/ Seafood (Maggie)	560	\N
144	14	N72 Brinjal Masala	510	\N
145	14	N73 Mixed Raita	410	\N
146	14	N74 Plain Yoghurt	310	\N
147	14	N75 Navrattan Korma	610	\N
148	14	N76 Malai Kofta	610	\N
149	14	N77 Paneer Tikka Masala	810	\N
150	14	N78 Green Indian Salad	310	\N
151	14	N79 Gobi Manchurian	710	\N
152	14	N80 Chilli Paneer	1010	\N
153	14	N81 Aloo Gobi	510	\N
55	8	T53 FR Kampong Style (Large)	660	\N
162	15	W08 Cheese Fries (Large)	610	\N
228	35	T33 Hailam (Kwayteow)	560	\N
229	35	T33 Hailam (Maggie)	560	\N
230	36	T34 Thai Style Fried (Mee)	590	\N
231	36	T34 Thai Style Fried (Beehoon)	590	\N
232	36	T34 Thai Style Fried (Kwayteow)	590	\N
233	36	T34 Thai Style Fried (Maggie)	590	\N
234	37	T35 Sambal Style Fried (Mee)	560	\N
235	37	T35 Sambal Style Fried (Beehoon)	560	\N
236	37	T35 Sambal Style Fried (Kwayteow)	560	\N
237	37	T35 Sambal Style Fried (Maggie)	560	\N
238	38	T36 Chinese Style Fried (Mee)	560	\N
239	38	T36 Chinese Style Fried (Beehoon)	560	\N
240	38	T36 Chinese Style Fried (Kwayteow)	560	\N
241	38	T36 Chinese Style Fried (Maggie)	560	\N
242	39	T37 Fried w/ Beef (Mee)	560	\N
243	39	T37 Fried w/ Beef (Beehoon)	560	\N
244	39	T37 Fried w/ Beef (Kwayteow)	560	\N
245	39	T37 Fried w/ Beef (Maggie)	560	\N
246	40	T38 Fried w/ Seafood (Mee)	560	\N
247	40	T38 Fried w/ Seafood (Beehoon)	560	\N
250	41	T39 Pattaya (Beef Mee)	610	\N
251	41	T39 Pattaya (Beef Beehoon)	610	\N
252	41	T39 Pattaya (Beef Kwayteow)	610	\N
253	41	T39 Pattaya (Beef Maggie)	610	\N
254	41	T39 Pattaya (Chicken Mee)	610	\N
256	41	T39 Pattaya (Chicken Kwayteow)	610	\N
257	41	T39 Pattaya (Chicken Maggie)	610	\N
258	41	T39 Pattaya (Seafood Mee)	610	\N
259	41	T39 Pattaya (Seafood Beehoon)	610	\N
260	41	T39 Pattaya (Seafood Kwayteow)	610	\N
261	41	T39 Pattaya (Seafood Maggie)	610	\N
262	42	T40 Fried with Cockles (Mee)	560	\N
263	42	T40 Fried with Cockles (Beehoon)	560	\N
264	42	T40 Fried with Cockles (Kwayteow)	560	\N
265	42	T40 Fried with Cockles (Maggie)	560	\N
266	43	T41 Steam Rice w/ Chicken (Hot & Spicy)	590	\N
267	43	T42 Steam Rice w/ Chicken (Black Oyster Sauce)	590	\N
268	43	T43 Steam Rice w/ Chicken (Sweet & Sour)	590	\N
269	43	T44 Steam Rice w/ Chicken (Black Pepper)	590	\N
270	43	T45 Steam Rice w/ Chicken (Ginger Brown Sauce)	590	\N
271	43	T46 Steam Rice w/ Chicken (Mui Fan)	590	\N
272	44	T41 Steam Rice w/ Beef (Hot & Spicy)	590	\N
273	44	T42 Steam Rice w/ Beef (Black Oyster Sauce)	590	\N
274	44	T43 Steam Rice w/ Beef (Sweet & Sour)	590	\N
275	44	T44 Steam Rice w/ Beef (Black Pepper)	590	\N
276	44	T45 Steam Rice w/ Beef (Ginger Brown Sauce)	590	\N
277	44	T46 Steam Rice w/ Beef (Mui Fan)	590	\N
278	45	T41 Steam Rice w/ Sliced Fish (Hot & Spicy)	590	\N
279	45	T42 Steam Rice w/ Sliced Fish (Black Oyster Sauce)	590	\N
280	45	T43 Steam Rice w/ Sliced Fish (Sweet & Sour)	590	\N
281	45	T44 Steam Rice w/ Sliced Fish (Black Pepper)	590	\N
282	45	T45 Steam Rice w/ Sliced Fish (Ginger Brown Sauce)	590	\N
283	45	T46 Steam Rice w/ Sliced Fish (Mui Fan)	590	\N
284	46	T41 Steam Rice w/ Cuttlefish (Hot & Spicy)	590	\N
285	46	T42 Steam Rice w/ Cuttlefish (Black Oyster Sauce)	590	\N
286	46	T43 Steam Rice w/ Cuttlefish (Sweet & Sour)	590	\N
287	46	T44 Steam Rice w/ Cuttlefish (Black Pepper)	590	\N
288	46	T45 Steam Rice w/ Cuttlefish (Ginger Brown Sauce)	590	\N
289	46	T46 Steam Rice w/ Cuttlefish (Mui Fan)	590	\N
290	47	T41 Steam Rice w/ Prawn (Hot & Spicy)	590	\N
291	47	T42 Steam Rice w/ Prawn (Black Oyster Sauce)	590	\N
292	47	T43 Steam Rice w/ Prawn (Sweet & Sour)	590	\N
293	47	T44 Steam Rice w/ Prawn (Black Pepper)	590	\N
294	47	T45 Steam Rice w/ Prawn (Ginger Brown Sauce)	590	\N
295	47	T46 Steam Rice w/ Prawn (Mui Fan)	590	\N
255	41	T39 Pattaya (Chicken Beehoon)	610	\N
297	10	N30 Butter Chicken (large)	1710	\N
296	10	N30 Butter Chicken (medium)	1210	\N
102	10	N30 Butter Chicken (small)	710	\N
\.


--
-- TOC entry 2905 (class 0 OID 33812)
-- Dependencies: 211
-- Data for Name: al_amaans_mod; Type: TABLE DATA; Schema: menudata; Owner: postgres
--

COPY menudata.al_amaans_mod (mod_id, "group", name, price, level) FROM stdin;
1	1	no ice	20	0
2	1	hot	0	0
3	1	normal	0	0
\.


--
-- TOC entry 2907 (class 0 OID 33819)
-- Dependencies: 213
-- Data for Name: koi; Type: TABLE DATA; Schema: menudata; Owner: postgres
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
-- TOC entry 2908 (class 0 OID 33822)
-- Dependencies: 214
-- Data for Name: koi_mod; Type: TABLE DATA; Schema: menudata; Owner: postgres
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
-- TOC entry 2909 (class 0 OID 33828)
-- Dependencies: 215
-- Data for Name: xing_long_fish_soup; Type: TABLE DATA; Schema: menudata; Owner: postgres
--

COPY menudata.xing_long_fish_soup (item_id, parent_id, item_name, price, mod_group) FROM stdin;
18	0	Ban Mian (Dry) 板面 （干捞）	550	\N
19	0	Spicy Koka Noodle 香辣可口面	650	\N
1	0	Fried Fish Bee Hoon 炸鱼米粉	650	1
3	0	Twin Mix Soup 双鱼汤	790	1
4	0	Fish Porridge 鱼糜	650	3
2	0	Sliced Fish Soup / Bee Hoon 鱼片汤 / 米粉	650	2
5	0	Seafood Soup 海鲜汤	720	3
6	0	Thai Style Tom Yam Soup 泰式冬炎汤	790	3
7	0	Sliced Fish Mee Sua 鱼片面线	650	1
8	0	Fried Fish Ee Mian 炸鱼伊面	650	1
9	0	Bittergourd Sliced Fish Soup 苦瓜鱼片汤	650	3
10	0	Spinach Minced Meat Sliced Fish Soup 苋菜肉碎鱼片汤	720	3
11	0	Fried Fish Macaroni 炸鱼通心粉	650	1
12	0	Minced Meat Sliced Fish Porridge 肉碎鱼片粥	720	3
14	0	Tom Yam Ban Mian 冬炎板面	650	3
15	0	Fresh Prawn Ban Mian 鲜虾板面	720	3
17	0	Sliced Fish U-Mian 鱼片幼面	650	3
13	0	Mee Hoon Kway / Ban Mian / U-Mian 面粉粿/板面/幼面	500	4
16	0	Dumpling Noodle 饺子面	650	5
0	0	delivery_fee	400	\N
\.


--
-- TOC entry 2910 (class 0 OID 33831)
-- Dependencies: 216
-- Data for Name: xing_long_fish_soup_mod; Type: TABLE DATA; Schema: menudata; Owner: postgres
--

COPY menudata.xing_long_fish_soup_mod (mod_id, "group", name, price, level) FROM stdin;
1	1	With Milk	0	0
2	1	Without Milk	0	0
4	1	Add Bittergourd	80	1
5	1	Add Beancurd	80	1
6	1	Add Minced Meat	150	1
7	1	Add Sliced Fish	280	1
8	1	Add Fried Fish	280	1
9	1	Add Prawns	280	1
10	1	Add Dumplings 3x	280	1
11	1	Add Noodle	70	1
12	1	Add Rice	70	1
13	1	No Additionals	0	1
3	1	Add Vegetables	80	1
14	2	Soup	0	0
15	2	Bee Hoon	0	0
16	2	With Milk	0	1
17	2	Without Milk	0	1
18	2	Add Vegetables	80	2
19	2	Add Bittergourd	80	2
20	2	Add Beancurd	80	2
21	2	Add Minced Meat	150	2
22	2	Add Sliced Fish	280	2
23	2	Add Fried Fish	280	2
24	2	Add Prawns	280	2
25	2	Add Dumplings 3x	280	2
26	2	Add Noodle	70	2
27	2	Add Rice	70	2
29	3	Add Vegetables	80	0
30	3	Add Bittergourd	80	0
31	3	Add Beancurd	80	0
32	3	Add Minced Meat	150	0
33	3	Add Sliced Fish	280	0
34	3	Add Fried Fish	280	0
35	3	Add Prawns	280	0
36	3	Add Dumplings 3x	280	0
37	3	Add Noodle	70	0
38	3	Add Rice	70	0
39	3	No Additionals	0	0
40	4	Mee Hoon Kway (Handmade Pieces of "Noodle". Dish Consists of Minced Meat and Vegetables)	0	0
41	4	Ban Mian (Handmade Noodle. Made by Cutting Noodles Into Straight Thick Strands. Consist of Minced Meat and Vegetables)	0	0
42	4	U-Mian (Handmade Noodle. Made by Pulling the Noodle Into Thin Long Strands, Dish Consist of Minced Meat and Vegetables)	0	0
43	4	Add Vegetables	80	1
44	4	Add Bittergourd	80	1
45	4	Add Beancurd	80	1
46	4	Add Minced Meat	150	1
47	4	Add Sliced Fish	280	1
48	4	Add Fried Fish	280	1
49	4	Add Prawns	280	1
50	4	Add Dumplings 3x	280	1
51	4	Add Noodle	70	1
52	4	Add Rice	70	1
53	4	No Additionals	0	1
54	5	Dry with Chili	0	0
55	5	Dry without Chili	0	0
56	5	Soup	0	0
57	5	Add Vegetables	80	1
58	5	Add Bittergourd	80	1
59	5	Add Beancurd	80	1
60	5	Add Minced Meat	150	1
61	5	Add Sliced Fish	280	1
62	5	Add Fried Fish	280	1
63	5	Add Prawns	280	1
64	5	Add Dumplings 3x	280	1
65	5	Add Noodle	70	1
66	5	Add Rice	70	1
67	5	No Additionals	0	1
\.


--
-- TOC entry 2911 (class 0 OID 33837)
-- Dependencies: 217
-- Data for Name: cache; Type: TABLE DATA; Schema: miscellaneous; Owner: postgres
--

COPY miscellaneous.cache (key, data, "time") FROM stdin;
\.


--
-- TOC entry 2912 (class 0 OID 33843)
-- Dependencies: 218
-- Data for Name: helper; Type: TABLE DATA; Schema: miscellaneous; Owner: postgres
--

COPY miscellaneous.helper (string, count, "time") FROM stdin;
\.


--
-- TOC entry 2921 (class 0 OID 0)
-- Dependencies: 207
-- Name: modifiers_id_seq; Type: SEQUENCE SET; Schema: jiodata; Owner: postgres
--

SELECT pg_catalog.setval('jiodata.modifiers_id_seq', 86, true);


--
-- TOC entry 2922 (class 0 OID 0)
-- Dependencies: 209
-- Name: orderid_seq; Type: SEQUENCE SET; Schema: jiodata; Owner: postgres
--

SELECT pg_catalog.setval('jiodata.orderid_seq', 191, true);


--
-- TOC entry 2923 (class 0 OID 0)
-- Dependencies: 212
-- Name: al_amaans_mod_id_seq; Type: SEQUENCE SET; Schema: menudata; Owner: postgres
--

SELECT pg_catalog.setval('menudata.al_amaans_mod_id_seq', 6, true);


--
-- TOC entry 2749 (class 2606 OID 33854)
-- Name: jios jios_pkey; Type: CONSTRAINT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.jios
    ADD CONSTRAINT jios_pkey PRIMARY KEY (chat_id);


--
-- TOC entry 2752 (class 2606 OID 33856)
-- Name: modifiers modifiers_pkey; Type: CONSTRAINT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.modifiers
    ADD CONSTRAINT modifiers_pkey PRIMARY KEY (id);


--
-- TOC entry 2754 (class 2606 OID 33858)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 2758 (class 2606 OID 33860)
-- Name: al_amaans_mod al_amaans_mod_pkey; Type: CONSTRAINT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.al_amaans_mod
    ADD CONSTRAINT al_amaans_mod_pkey PRIMARY KEY (mod_id);


--
-- TOC entry 2756 (class 2606 OID 33862)
-- Name: al_amaans alamaans_pkey; Type: CONSTRAINT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.al_amaans
    ADD CONSTRAINT alamaans_pkey PRIMARY KEY (item_id);


--
-- TOC entry 2762 (class 2606 OID 33864)
-- Name: koi_mod koi_mod_pkey; Type: CONSTRAINT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.koi_mod
    ADD CONSTRAINT koi_mod_pkey PRIMARY KEY (mod_id);


--
-- TOC entry 2760 (class 2606 OID 33866)
-- Name: koi koi_pkey; Type: CONSTRAINT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.koi
    ADD CONSTRAINT koi_pkey PRIMARY KEY (item_id);


--
-- TOC entry 2766 (class 2606 OID 33868)
-- Name: xing_long_fish_soup_mod xing_long_fish_soup_mod_pkey; Type: CONSTRAINT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.xing_long_fish_soup_mod
    ADD CONSTRAINT xing_long_fish_soup_mod_pkey PRIMARY KEY (mod_id);


--
-- TOC entry 2764 (class 2606 OID 33870)
-- Name: xing_long_fish_soup xing_long_fish_soup_pkey; Type: CONSTRAINT; Schema: menudata; Owner: postgres
--

ALTER TABLE ONLY menudata.xing_long_fish_soup
    ADD CONSTRAINT xing_long_fish_soup_pkey PRIMARY KEY (item_id);


--
-- TOC entry 2768 (class 2606 OID 33872)
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: miscellaneous; Owner: postgres
--

ALTER TABLE ONLY miscellaneous.cache
    ADD CONSTRAINT cache_pkey PRIMARY KEY (key);


--
-- TOC entry 2770 (class 2606 OID 33874)
-- Name: helper helper_pkey; Type: CONSTRAINT; Schema: miscellaneous; Owner: postgres
--

ALTER TABLE ONLY miscellaneous.helper
    ADD CONSTRAINT helper_pkey PRIMARY KEY (string);


--
-- TOC entry 2750 (class 1259 OID 33875)
-- Name: modifiers_order_id_level_idx; Type: INDEX; Schema: jiodata; Owner: postgres
--

CREATE UNIQUE INDEX modifiers_order_id_level_idx ON jiodata.modifiers USING btree (order_id, level);


--
-- TOC entry 2772 (class 2606 OID 33876)
-- Name: orders chat_id; Type: FK CONSTRAINT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.orders
    ADD CONSTRAINT chat_id FOREIGN KEY (chat_id) REFERENCES jiodata.jios(chat_id) ON DELETE CASCADE;


--
-- TOC entry 2771 (class 2606 OID 33881)
-- Name: modifiers order_id_fkey; Type: FK CONSTRAINT; Schema: jiodata; Owner: postgres
--

ALTER TABLE ONLY jiodata.modifiers
    ADD CONSTRAINT order_id_fkey FOREIGN KEY (order_id) REFERENCES jiodata.orders(order_id) ON DELETE CASCADE NOT VALID;


-- Completed on 2021-06-03 13:17:35

--
-- PostgreSQL database dump complete
--

