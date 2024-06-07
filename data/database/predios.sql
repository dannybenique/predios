--
-- PostgreSQL database dump
--

-- Dumped from database version 12.11
-- Dumped by pg_dump version 12.11

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
-- Name: tablefunc; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS tablefunc WITH SCHEMA public;


--
-- Name: EXTENSION tablefunc; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION tablefunc IS 'functions that manipulate whole tables, including crosstab';


--
-- Name: sp_maestro(character varying, integer, character varying, character varying, character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sp_maestro(ptarea character varying, pid integer, pcodigo character varying, pnombre character varying, pabrevia character varying, pid_padre integer, psysuser integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
begin
	if(ptarea='INS') then
		select coalesce(max(id)+1,1) into pid from maestro;
		insert into maestro values(pid,pcodigo,pnombre,pabrevia,pid_padre,1,psysuser,now());
		return pid;
	end if;
	if(ptarea='UPD') then
		update maestro set
			codigo=pcodigo,
			nombre=pnombre,
			abrevia=pabrevia,
			id_padre=pid_padre,
			sysuser=psysuser,
			sysfecha=now()
		where id=pid;
		return pid;
	end if;
end;
$$;


ALTER FUNCTION public.sp_maestro(ptarea character varying, pid integer, pcodigo character varying, pnombre character varying, pabrevia character varying, pid_padre integer, psysuser integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: config_perfil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_perfil (
    id integer NOT NULL,
    nombre character varying(50),
    id_padre integer,
    id_tabla integer,
    sel character(1),
    ins character(1),
    upd character(1),
    del character(1)
);


ALTER TABLE public.config_perfil OWNER TO postgres;

--
-- Name: config_tablas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config_tablas (
    id integer NOT NULL,
    nombre character varying(50)
);


ALTER TABLE public.config_tablas OWNER TO postgres;

--
-- Name: igl_iglesias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.igl_iglesias (
    id integer NOT NULL,
    codigo character varying(6),
    nombre character varying(50),
    abrevia character varying(10),
    id_ubigeo integer,
    id_padre integer,
    direccion text,
    observac text,
    tipo smallint,
    activo smallint,
    estado smallint,
    sysuser bigint,
    sysfecha timestamp without time zone
);


ALTER TABLE public.igl_iglesias OWNER TO postgres;

--
-- Name: igl_usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.igl_usuarios (
    id integer NOT NULL,
    id_iglesia integer,
    login character varying(100),
    passw character varying(100),
    name character varying(100),
    lastname character varying(100),
    estado smallint,
    admin smallint,
    sysuser integer,
    sysfecha timestamp without time zone
);


ALTER TABLE public.igl_usuarios OWNER TO postgres;

--
-- Name: igl_usuarios_perfil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.igl_usuarios_perfil (
    id_usuario integer,
    id_tabla integer,
    sel character(1),
    ins character(1),
    upd character(1),
    del character(1)
);


ALTER TABLE public.igl_usuarios_perfil OWNER TO postgres;

--
-- Name: maestro; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.maestro (
    id integer NOT NULL,
    codigo character varying(5),
    nombre character varying(70),
    abrevia character varying(5),
    id_padre integer,
    estado smallint,
    sysuser integer,
    sysfecha timestamp without time zone
);


ALTER TABLE public.maestro OWNER TO postgres;

--
-- Name: predios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios (
    id integer NOT NULL,
    id_clase integer,
    id_iglesia integer,
    codigo character varying(50),
    per_juridica character varying(50),
    mision character varying(50),
    nombre character varying(80),
    telefono character varying(20),
    correo character varying(80),
    id_distrito integer,
    sector character varying(100),
    avenida character varying(100),
    nro character varying(5),
    dpto character varying(5),
    mza character varying(5),
    lote character varying(5),
    maps character varying(50),
    observac text,
    estado smallint,
    sysuser integer,
    sysfecha timestamp without time zone
);


ALTER TABLE public.predios OWNER TO postgres;

--
-- Name: predios_archivos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_archivos (
    id integer NOT NULL,
    id_predio integer,
    nombre character varying,
    url character varying,
    tipo smallint,
    estado smallint,
    sysuser integer,
    sysfecha timestamp without time zone
);


ALTER TABLE public.predios_archivos OWNER TO postgres;

--
-- Name: predios_deprec; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_deprec (
    id integer NOT NULL,
    id_predio integer,
    nivel integer,
    anti integer,
    categ integer,
    valunit_m2 money,
    deprec_perc money,
    deprec money,
    valunit_deprec money,
    areaconst_m2 money,
    areaconst_val money
);


ALTER TABLE public.predios_deprec OWNER TO postgres;

--
-- Name: predios_docum; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_docum (
    id_predio integer NOT NULL,
    conditerreno integer,
    valordocum numeric(15,4),
    id_modo integer,
    id_moneda integer,
    transdocum character varying(200),
    adquidocum character varying(200),
    id_titulo integer,
    nro_titulo character varying(20),
    id_fedatario integer,
    nombrefedatario character varying(200),
    fechadocum date,
    foliodocum character varying(200)
);


ALTER TABLE public.predios_docum OWNER TO postgres;

--
-- Name: predios_fiscal; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_fiscal (
    id_predio integer NOT NULL,
    arbifecha date,
    arbicodigo character varying(50),
    arbiresol character varying(50),
    impufecha date,
    impucodigo character varying(50),
    impuresol character varying(50),
    luzfecha date,
    luzcodigo character varying(50),
    aguafecha date,
    aguacodigo character varying(50),
    construfecha date,
    construtexto character varying(50),
    declarafecha date,
    declaratexto character varying(50)
);


ALTER TABLE public.predios_fiscal OWNER TO postgres;

--
-- Name: predios_medidas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_medidas (
    id_predio integer NOT NULL,
    ubizona character varying(50),
    arancel character varying(15),
    area_total character varying(15),
    area_const character varying(15),
    frent_medi character varying(15),
    frent_colin character varying(50),
    right_medi character varying(15),
    right_colin character varying(50),
    left_medi character varying(15),
    left_colin character varying(50),
    back_medi character varying(15),
    back_colin character varying(50)
);


ALTER TABLE public.predios_medidas OWNER TO postgres;

--
-- Name: predios_registral; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_registral (
    id_predio integer NOT NULL,
    fecha1 date,
    fecha2 date,
    ficha character varying(50),
    libro character varying(50),
    folio character varying(50),
    asiento character varying(50),
    titular character varying(50),
    municipio character varying(50),
    zonareg character varying(50)
);


ALTER TABLE public.predios_registral OWNER TO postgres;

--
-- Name: predios_usos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.predios_usos (
    id_predio integer NOT NULL,
    id_principal integer,
    id_tercero integer,
    fecha date,
    modo character varying(50),
    periodo character varying(50),
    pertenece character varying(100),
    otros character varying(100)
);


ALTER TABLE public.predios_usos OWNER TO postgres;

--
-- Name: sis_ubigeo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sis_ubigeo (
    id integer NOT NULL,
    codigo character varying(6),
    nombre character varying(80),
    tipo smallint,
    id_padre integer,
    estado smallint,
    sysuser integer,
    sysfecha timestamp without time zone
);


ALTER TABLE public.sis_ubigeo OWNER TO postgres;

--
-- Name: vw_predios; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_predios AS
 SELECT p.id,
    p.codigo,
    p.nombre AS predio,
    p.mision,
    p.per_juridica,
    p.telefono,
    p.correo,
    c.nombre AS clase,
    p.id_iglesia,
    d.nombre AS dmisionero,
    ur.nombre AS region,
    up.nombre AS provincia,
    ud.nombre AS distrito,
    p.sector,
    p.avenida,
    p.nro,
    p.dpto,
    p.mza,
    p.lote,
    p.estado,
    p.observac,
    date_part('year'::text, pf.arbifecha) AS arbifecha,
    to_char(p.sysfecha, 'DD/MM/YYYY'::text) AS sysfecha,
    us.login
   FROM public.predios p,
    public.maestro c,
    public.igl_iglesias d,
    public.sis_ubigeo ud,
    public.sis_ubigeo up,
    public.sis_ubigeo ur,
    public.predios_fiscal pf,
    public.igl_usuarios us
  WHERE ((p.id_clase = c.id) AND (p.id_iglesia = d.id) AND (p.id_distrito = ud.id) AND (ud.id_padre = up.id) AND (up.id_padre = ur.id) AND (p.sysuser = us.id) AND (pf.id_predio = p.id));


ALTER TABLE public.vw_predios OWNER TO postgres;

--
-- Name: vw_predios_nofiscal; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_predios_nofiscal AS
 SELECT p.id,
    p.codigo,
    p.nombre AS predio,
    p.mision,
    p.per_juridica,
    p.telefono,
    p.correo,
    c.nombre AS clase,
    p.id_iglesia,
    d.nombre AS dmisionero,
    ur.nombre AS region,
    up.nombre AS provincia,
    ud.nombre AS distrito,
    p.sector,
    p.avenida,
    p.nro,
    p.dpto,
    p.mza,
    p.lote,
    p.estado,
    p.observac,
    to_char(p.sysfecha, 'DD/MM/YYYY'::text) AS sysfecha,
    us.login
   FROM public.predios p,
    public.maestro c,
    public.igl_iglesias d,
    public.sis_ubigeo ud,
    public.sis_ubigeo up,
    public.sis_ubigeo ur,
    public.igl_usuarios us
  WHERE ((p.id_clase = c.id) AND (p.id_iglesia = d.id) AND (p.id_distrito = ud.id) AND (ud.id_padre = up.id) AND (up.id_padre = ur.id) AND (p.sysuser = us.id));


ALTER TABLE public.vw_predios_nofiscal OWNER TO postgres;

--
-- Name: vw_ubigeo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.vw_ubigeo AS
 SELECT d.id AS id_distrito,
    d.nombre AS distrito,
    p.id AS id_provincia,
    p.nombre AS provincia,
    r.id AS id_region,
    r.nombre AS region
   FROM public.sis_ubigeo d,
    public.sis_ubigeo p,
    public.sis_ubigeo r
  WHERE ((d.id_padre = p.id) AND (p.id_padre = r.id));


ALTER TABLE public.vw_ubigeo OWNER TO postgres;

--
-- Data for Name: config_perfil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_perfil (id, nombre, id_padre, id_tabla, sel, ins, upd, del) FROM stdin;
101	\N	1	1	1	1	1	1
102	\N	1	2	1	1	1	1
104	\N	1	4	1	1	1	1
105	\N	1	5	1	1	1	1
103	\N	1	3	1	1	1	1
1	super	\N	\N	\N	\N	\N	\N
2	admin	\N	\N	\N	\N	\N	\N
3	usuario	\N	\N	\N	\N	\N	\N
106	\N	1	6	1	1	1	1
120	\N	3	6	1	0	0	0
118	\N	3	4	0	0	0	0
119	\N	3	5	1	0	0	0
117	\N	3	3	0	0	0	0
116	\N	3	2	0	0	0	0
115	\N	3	1	0	0	0	0
114	\N	2	7	0	0	0	0
121	\N	3	7	0	0	0	0
113	\N	2	6	1	1	1	1
112	\N	2	5	1	1	1	1
111	\N	2	4	0	0	0	0
110	\N	2	3	0	0	0	0
109	\N	2	2	1	0	0	0
108	\N	2	1	0	0	0	0
107	\N	1	7	1	1	1	1
\.


--
-- Data for Name: config_tablas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config_tablas (id, nombre) FROM stdin;
1	ubigeo
2	maestro
3	misiones
4	usuarios
5	dist. misio.
6	predios
7	archivos predios
\.


--
-- Data for Name: igl_iglesias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.igl_iglesias (id, codigo, nombre, abrevia, id_ubigeo, id_padre, direccion, observac, tipo, activo, estado, sysuser, sysfecha) FROM stdin;
1007	M007	Gregorio Albarracin	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:51:28.786125
1016	M016	Moquegua A	\N	280303	101	\N	\N	5	0	1	1	2021-02-03 16:44:01.216927
1017	M017	Moquegua B	\N	280303	101	\N	\N	5	0	1	1	2021-02-03 16:44:21.191073
1009	M009	Ilo - A	\N	280303	101	\N	\N	5	0	1	1	2021-02-03 16:46:16.164284
1005	M005	Ciudad Nueva - A	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:47:25.639423
1010	M010	Jorge Basadre	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:48:04.498229
1006	M006	El Faro	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:48:17.807901
1001	M001	Augusto B. Leguia	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:48:58.881609
1013	M013	Miller	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:50:26.20315
1011	M011	La Victoria	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:51:49.035271
1012	M012	Majes - A	\N	140101	101	\N	\N	5	0	1	1	2021-02-03 16:56:55.255381
1023	M023	Zamacola - A	\N	140101	101	\N	\N	5	0	1	1	2021-02-03 16:57:52.055946
1025	M025	Mariano Melgar	\N	140101	101	\N	\N	5	0	1	2	2021-09-01 15:25:44.882941
1003	M003	Camana	\N	140101	101	\N	\N	5	0	1	2	2022-01-26 17:40:12.099626
102	M00102	Mision del Oriente Peruano	MOP	350205	20	Av. Centenario Km. 4,700		4	0	1	1	2020-10-23 09:10:01.691565
103	M00103	Mision del Lago Titicaca	MLT	310912	20	....		4	0	1	1	2020-10-23 22:26:53.633533
104	M00104	Mision Andina Central	MAC	200504	20	...		4	0	1	1	2020-10-23 22:28:11.023668
105	M00105	Mision Sur Oriental del Peru	MSOP	180702	20	...		4	0	1	1	2020-10-23 22:30:23.802905
106	M00106	Mision Peruana Central Sur	MPCS	140101	20	...		4	0	1	1	2020-10-23 22:32:21.452111
107	M00107	Asociacion Peruana Central	APC	140101	20	...		4	0	1	1	2020-10-23 22:33:58.759494
1002	M002	Alto Selva Alegre	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1004	M004	Cayma	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1008	M008	Hunter	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1014	M014	Miraflores	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1015	M015	Mollendo	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1018	M018	Parra	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1019	M019	Paucarpata	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1020	M020	Socabaya	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1021	M021	Tiabaya	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1022	M022	Umacollo	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1024	M024	Yura	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1026	M026	Aplao	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
20	U00010	Union Peruana Sur	UPS	140101	2			3	1	1	1	2020-09-29 23:35:54.287786
101	M00101	Mision Peruana del Sur	MPS	140124	20	Alameda 2 de Mayo - Tingo		4	1	1	1	2021-01-18 18:44:50.353633
1047	M047	Alto de la Alianza	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:50:46.031687
1043	M043	Valle del Colca	\N	140505	101	\N	\N	5	0	1	1	2021-02-03 16:56:36.835459
1060	M060	Majes - B	\N	140101	101	\N	\N	5	0	1	1	2021-02-03 16:57:02.594701
1059	M059	Zamacola - B	\N	140101	101	\N	\N	5	0	1	1	2021-02-03 16:57:59.399428
1039	M039	AEAPS Colegio	\N	140101	101	\N	\N	5	0	1	2	2022-01-27 08:58:16.274592
1028	M028	Caylloma	\N	140504	101	\N	\N	5	0	1	2	2022-03-02 19:22:58.985523
1033	M033	Tarata	\N	330406	101	\N	\N	5	0	1	2	2022-04-15 10:10:12.884441
1027	M027	Chala	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1038	M038	Oficinas MPS	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1042	M042	Jose Luis Bustamante y Rivero	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1048	M048	Pachacutec	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1054	M054	La Joya	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1057	M057	Cono Norte	\N	140101	101	\N	\N	5	0	1	1	2020-08-26 14:00:12.064504
1	AG0001	Asociacion General	AGG	140101	\N	 	 	1	1	1	1	2020-10-23 22:33:58.759494
2	DSA001	Division Sudamericana	DSA	140101	1	 	 	2	1	1	1	2020-10-23 22:33:58.759494
1056	M056	Moquegua San Antonio	\N	280303	101	\N	\N	5	0	1	1	2021-02-03 16:44:39.219164
1034	M034	Ilo - B	\N	280303	101	\N	\N	5	0	1	1	2021-02-03 16:46:30.832324
1030	M030	Ciudad Nueva - B	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:47:46.681296
1031	M031	Nueva Tacna	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:48:38.249386
1032	M032	Cono Sur	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:49:10.528522
1055	M055	La Yarada	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:49:35.555502
1040	M040	Pocollay	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:49:49.426324
1029	M029	Getsemani	\N	330310	101	\N	\N	5	0	1	1	2021-02-03 16:50:10.530724
\.


--
-- Data for Name: igl_usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.igl_usuarios (id, id_iglesia, login, passw, name, lastname, estado, admin, sysuser, sysfecha) FROM stdin;
26	1008	humbertorequejoguerra@gmail.com	\N	Humberto	Requejo Guerra	1	0	1	2021-02-01 09:52:17.650589
27	1028	jeremy.upeu@gmail.com	\N	Jeremy	Samame Vera	1	0	1	2021-02-01 09:53:07.249686
28	1018	freddyyruchi29@gmail.com	\N	Freddy	Uruchi Huayhua	1	0	1	2021-02-01 09:53:43.979021
29	1026	gersonbejarano@gmail.com	\N	Gerson	Bejarano	1	0	1	2021-02-01 09:54:25.853084
30	1025	tvr_23@hotmail.com	\N	Teodoro	Velasquez Rojas	1	0	1	2021-02-01 09:54:57.638049
31	1060	ahora_esmiguel@hotmail.com	\N	Jesus	Vivanco Caceres	1	0	1	2021-02-01 09:55:26.067112
32	1034	elmermago@hotmail.com	\N	Elmer	Mamani Gomez	1	0	1	2021-02-01 09:56:18.028368
33	1056	angelpm144@yahoo.es	\N	Angel Marcos	Peña Medina	1	0	1	2021-02-01 09:57:01.695062
34	1016	juansilloca@teologia.edu.pe	\N	Juan	Silloca Zarabia	1	0	1	2021-02-01 09:57:43.29083
35	1017	dart73@hotmail.com	\N	Jilmer Darguin	Suxe Torres	1	0	1	2021-02-01 09:58:25.245292
36	1009	ricvargasflores@hotmail.com	\N	Ricardo	Vargas Flores	1	0	1	2021-02-01 09:58:52.914335
37	1030	teal_09@hotmail.com	\N	Estuardo	Alva Leon	1	0	1	2021-02-01 10:00:09.634862
38	1010	apazachambi7@hotmail.com	\N	Pedro	Apaza Chambi	1	0	1	2021-02-01 10:00:41.158821
39	1006	luisbazan123@hotmail.com	\N	Luis	Bazan Sandoval	1	0	1	2021-02-01 10:01:22.621725
40	1031	colportorc@hotmail.com	\N	Eli	Campos Hernandez	1	0	1	2021-02-01 10:02:10.254458
41	1001	joaquinrivas@gmail.com	\N	Joaquin	Rivas	1	0	1	2021-02-01 10:02:41.250231
42	1055	josemartoscarrera@gmail.com	\N	Jose Luis	Martos Carrera	1	0	1	2021-02-01 10:03:12.082495
43	1040	pr.marcelonunez@hotmail.com	\N	Roberto	Nuñez Bautista	1	0	1	2021-02-01 10:03:52.501872
44	1029	victor2000_3@hotmail.com	\N	Victor	Querevalu Mere	1	0	1	2021-02-01 10:04:35.285511
45	1011	agus24_9@hotmail.com	\N	Agustin	Quispe Leonardo	1	0	1	2021-02-01 10:05:17.60668
46	1005	jocesito_12@hotmail.com	\N	Jose	Ticona Tintaya	1	0	1	2021-02-01 10:06:25.114904
1	101	dannybenique@msn.com	D033E22AE348AEB5660FC2140AEC35850C4DA997	admin	admin	1	1	1	2020-01-01 00:00:00
2	101	lconde	7110EDA4D09E062AA5E4A390B0A572AC0D2C0220	laureano	conde	1	0	1	2020-09-30 15:04:51.660208
4	101	joelguimac@gmail.com	7C4A8D09CA3762AF61E59520943DC26494F8941B	Joel	Guimac Tafur	1	0	1	2021-01-15 17:52:25.169867
5	101	freddy.j.robles.l@gmail.com	7C4A8D09CA3762AF61E59520943DC26494F8941B	Freddy	Robles Lirio	1	0	1	2021-01-15 17:53:05.075487
47	1007	rafaeltinoco_777@hotmail.com	\N	Tito Rafael	Tinoco Cerna	1	0	1	2021-02-01 10:07:02.629353
48	1013	royvaca80@gmail.com	\N	Roy	Vaca Espino	1	0	1	2021-02-01 10:07:33.261636
3	101	daniel_villar@icloud.com	7C4A8D09CA3762AF61E59520943DC26494F8941B	Daniel	Villar Espinoza	1	0	1	2021-01-15 17:51:59.450646
49	1032	henval33@gmail.com	\N	Elmer	Valenzuela Ore	1	0	1	2021-02-01 10:08:03.413371
50	1047	hugoevc@hotmail.com	\N	Hugo	Villca Camargo	1	0	1	2021-02-01 10:08:31.539309
17	1043	ludena2019.iasd@gmail.com	\N	Luis Armando	Ludeña Quispe	1	0	1	2021-02-03 17:00:33.967958
6	1004	empe17@hotmail.com	7C4A8D09CA3762AF61E59520943DC26494F8941B	Percy	Alarico Apaza	1	0	1	2021-01-28 19:07:42.218789
7	1023	nury	7C4A8D09CA3762AF61E59520943DC26494F8941B	nury	benique	1	0	1	2021-01-28 23:51:39.892409
8	1021	Imacotacnatacna@gmail.com	7C4A8D09CA3762AF61E59520943DC26494F8941B	Ismael	Cruz Ucharico	1	0	1	2021-01-29 18:09:31.337657
9	1019	ezbenavente@hotmail.com	\N	Edivin Zenon	Benavente Ibañez	1	0	1	2021-01-29 18:11:23.732484
10	1012	cjbp_04@hotmail.com	\N	Cesar Jose	Briceño Peve	1	0	1	2021-02-01 09:37:21.107413
11	1054	pastor.en.accion@hotmail.com	\N	Roberth	Caceres Choque	1	0	1	2021-02-01 09:38:00.5391
12	1002	calderonzozimo@live.com	\N	Zozimo	Calderon Diaz	1	0	1	2021-02-01 09:38:39.244595
13	1042	pastorwccari@hotmail.com	\N	Wilberth	Ccari Mamani	1	0	1	2021-02-01 09:39:25.012209
14	1057	kirem_13@hotmail.com	\N	Bernardo	Chirinos Paricahua	1	0	1	2021-02-01 09:40:11.230567
15	1023	bernabecq04 @gmail.com	\N	Cerenio	Condori Quispe	1	0	1	2021-02-01 09:40:54.561449
16	1020	jexcontreras20@gmail.com	\N	John	Contreras Condori	1	0	1	2021-02-01 09:42:06.376878
18	1022	diazleroy@gmail.com	\N	Ramiro	Diaz Mamani	1	0	1	2021-02-01 09:45:54.660609
19	1048	dguevara61@hotmail.com	\N	Dionisio	Guevara Huanacuni	1	0	1	2021-02-01 09:46:47.506106
20	1015	pastorharo@gmail.com	\N	Caleb Yonattan Moisés	Haro Rodriguez	1	0	1	2021-02-01 09:47:28.304486
21	1003	iglenden@hotmail.com	\N	Janusz Glenden	Isidro Torres	1	0	1	2021-02-01 09:48:57.140076
22	1024	edu_aventur@hotmail.com	\N	Eduardo	Maquera Ventura	1	0	1	2021-02-01 09:49:36.239156
23	1027	hernannarca@upeu.edu.pe	\N	Hernan	Marca Cotrado	1	0	1	2021-02-01 09:50:06.585707
24	1059	johncito1003@gmail.com	\N	John	Martinez Flores	1	0	1	2021-02-01 09:50:43.221856
25	1014	eq7551606@gmail.com 	\N	Edgar	Quispe Laurente	1	0	1	2021-02-01 09:51:37.484534
\.


--
-- Data for Name: igl_usuarios_perfil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.igl_usuarios_perfil (id_usuario, id_tabla, sel, ins, upd, del) FROM stdin;
7	1	0	0	0	0
7	2	0	0	0	0
7	3	0	0	0	0
7	4	0	0	0	0
7	5	0	0	0	0
7	6	1	0	0	0
9	1	0	0	0	0
9	2	0	0	0	0
9	3	0	0	0	0
9	4	0	0	0	0
9	5	0	0	0	0
9	6	1	0	0	0
2	2	0	0	0	0
2	3	0	0	0	0
2	4	0	0	0	0
2	5	1	1	1	1
2	6	1	1	1	1
4	1	0	0	0	0
4	2	0	0	0	0
4	3	0	0	0	0
4	4	0	0	0	0
4	5	1	0	0	0
4	6	1	0	0	0
5	1	0	0	0	0
5	2	0	0	0	0
5	3	0	0	0	0
5	4	0	0	0	0
5	5	1	0	0	0
5	6	1	0	0	0
3	1	0	0	0	0
3	2	0	0	0	0
3	3	0	0	0	0
3	4	0	0	0	0
3	5	1	0	0	0
3	6	1	0	0	0
6	1	0	0	0	0
6	2	0	0	0	0
6	3	0	0	0	0
6	4	0	0	0	0
6	5	0	0	0	0
6	6	1	0	0	0
29	1	0	0	0	0
10	1	0	0	0	0
10	2	0	0	0	0
10	3	0	0	0	0
10	4	0	0	0	0
10	5	0	0	0	0
8	1	0	0	0	0
8	2	0	0	0	0
8	3	0	0	0	0
8	4	0	0	0	0
8	5	0	0	0	0
8	6	1	0	0	0
10	6	1	0	0	0
11	1	0	0	0	0
11	2	0	0	0	0
11	3	0	0	0	0
11	4	0	0	0	0
11	5	0	0	0	0
11	6	1	0	0	0
12	1	0	0	0	0
12	2	0	0	0	0
12	3	0	0	0	0
12	4	0	0	0	0
12	5	0	0	0	0
12	6	1	0	0	0
13	1	0	0	0	0
13	2	0	0	0	0
13	3	0	0	0	0
13	4	0	0	0	0
13	5	0	0	0	0
13	6	1	0	0	0
14	1	0	0	0	0
14	2	0	0	0	0
14	3	0	0	0	0
14	4	0	0	0	0
14	5	0	0	0	0
14	6	1	0	0	0
15	1	0	0	0	0
15	2	0	0	0	0
15	3	0	0	0	0
15	4	0	0	0	0
15	5	0	0	0	0
15	6	1	0	0	0
16	1	0	0	0	0
16	2	0	0	0	0
16	3	0	0	0	0
16	4	0	0	0	0
16	5	0	0	0	0
16	6	1	0	0	0
18	1	0	0	0	0
18	2	0	0	0	0
18	3	0	0	0	0
18	4	0	0	0	0
18	5	0	0	0	0
18	6	1	0	0	0
19	1	0	0	0	0
19	2	0	0	0	0
19	3	0	0	0	0
19	4	0	0	0	0
19	5	0	0	0	0
19	6	1	0	0	0
20	1	0	0	0	0
20	2	0	0	0	0
20	3	0	0	0	0
20	4	0	0	0	0
20	5	0	0	0	0
20	6	1	0	0	0
21	1	0	0	0	0
21	2	0	0	0	0
21	3	0	0	0	0
21	4	0	0	0	0
21	5	0	0	0	0
21	6	1	0	0	0
17	1	0	0	0	0
17	2	0	0	0	0
17	3	0	0	0	0
17	4	0	0	0	0
17	5	0	0	0	0
17	6	1	0	0	0
22	1	0	0	0	0
29	2	0	0	0	0
29	3	0	0	0	0
29	4	0	0	0	0
29	5	0	0	0	0
29	6	1	0	0	0
22	2	0	0	0	0
22	3	0	0	0	0
22	4	0	0	0	0
22	5	0	0	0	0
22	6	1	0	0	0
23	1	0	0	0	0
23	2	0	0	0	0
23	3	0	0	0	0
23	4	0	0	0	0
23	5	0	0	0	0
23	6	1	0	0	0
24	1	0	0	0	0
24	2	0	0	0	0
24	3	0	0	0	0
24	4	0	0	0	0
24	5	0	0	0	0
24	6	1	0	0	0
25	1	0	0	0	0
25	2	0	0	0	0
25	3	0	0	0	0
25	4	0	0	0	0
25	5	0	0	0	0
25	6	1	0	0	0
26	1	0	0	0	0
26	2	0	0	0	0
26	3	0	0	0	0
26	4	0	0	0	0
26	5	0	0	0	0
26	6	1	0	0	0
27	1	0	0	0	0
27	2	0	0	0	0
27	3	0	0	0	0
27	4	0	0	0	0
27	5	0	0	0	0
27	6	1	0	0	0
28	1	0	0	0	0
28	2	0	0	0	0
28	3	0	0	0	0
28	4	0	0	0	0
28	5	0	0	0	0
28	6	1	0	0	0
30	1	0	0	0	0
30	2	0	0	0	0
30	3	0	0	0	0
30	4	0	0	0	0
30	5	0	0	0	0
30	6	1	0	0	0
31	1	0	0	0	0
31	2	0	0	0	0
31	3	0	0	0	0
31	4	0	0	0	0
31	5	0	0	0	0
31	6	1	0	0	0
32	1	0	0	0	0
32	2	0	0	0	0
32	3	0	0	0	0
32	4	0	0	0	0
32	5	0	0	0	0
32	6	1	0	0	0
33	1	0	0	0	0
33	2	0	0	0	0
33	3	0	0	0	0
33	4	0	0	0	0
33	5	0	0	0	0
33	6	1	0	0	0
34	1	0	0	0	0
34	2	0	0	0	0
34	3	0	0	0	0
34	4	0	0	0	0
34	5	0	0	0	0
34	6	1	0	0	0
35	1	0	0	0	0
35	2	0	0	0	0
35	3	0	0	0	0
35	4	0	0	0	0
35	5	0	0	0	0
35	6	1	0	0	0
36	1	0	0	0	0
36	2	0	0	0	0
36	3	0	0	0	0
36	4	0	0	0	0
36	5	0	0	0	0
36	6	1	0	0	0
37	1	0	0	0	0
37	2	0	0	0	0
37	3	0	0	0	0
37	4	0	0	0	0
37	5	0	0	0	0
37	6	1	0	0	0
38	1	0	0	0	0
38	2	0	0	0	0
38	3	0	0	0	0
38	4	0	0	0	0
38	5	0	0	0	0
38	6	1	0	0	0
39	1	0	0	0	0
39	2	0	0	0	0
39	3	0	0	0	0
39	4	0	0	0	0
39	5	0	0	0	0
39	6	1	0	0	0
40	1	0	0	0	0
40	2	0	0	0	0
40	3	0	0	0	0
40	4	0	0	0	0
40	5	0	0	0	0
40	6	1	0	0	0
42	1	0	0	0	0
42	2	0	0	0	0
42	3	0	0	0	0
42	4	0	0	0	0
42	5	0	0	0	0
42	6	1	0	0	0
43	1	0	0	0	0
43	2	0	0	0	0
43	3	0	0	0	0
43	4	0	0	0	0
43	5	0	0	0	0
43	6	1	0	0	0
44	1	0	0	0	0
44	2	0	0	0	0
44	3	0	0	0	0
44	4	0	0	0	0
44	5	0	0	0	0
44	6	1	0	0	0
45	1	0	0	0	0
45	2	0	0	0	0
45	3	0	0	0	0
45	4	0	0	0	0
45	5	0	0	0	0
45	6	1	0	0	0
41	1	0	0	0	0
41	2	0	0	0	0
41	3	0	0	0	0
41	4	0	0	0	0
41	5	0	0	0	0
41	6	1	0	0	0
46	1	0	0	0	0
46	2	0	0	0	0
46	3	0	0	0	0
46	4	0	0	0	0
46	5	0	0	0	0
46	6	1	0	0	0
47	1	0	0	0	0
47	2	0	0	0	0
47	3	0	0	0	0
47	4	0	0	0	0
47	5	0	0	0	0
47	6	1	0	0	0
48	1	0	0	0	0
48	2	0	0	0	0
48	3	0	0	0	0
48	4	0	0	0	0
48	5	0	0	0	0
48	6	1	0	0	0
49	1	0	0	0	0
49	2	0	0	0	0
49	3	0	0	0	0
49	4	0	0	0	0
49	5	0	0	0	0
49	6	1	0	0	0
50	1	0	0	0	0
50	2	0	0	0	0
50	3	0	0	0	0
50	4	0	0	0	0
50	5	0	0	0	0
50	6	1	0	0	0
1	1	1	1	1	1
1	2	1	1	1	1
1	3	1	1	1	1
1	4	1	1	1	1
1	5	1	1	1	1
1	6	1	1	1	1
2	1	0	0	0	0
7	7	1	0	0	0
8	7	1	0	0	0
9	7	1	0	0	0
10	7	1	0	0	0
11	7	1	0	0	0
12	7	1	0	0	0
13	7	1	0	0	0
14	7	1	0	0	0
15	7	1	0	0	0
16	7	1	0	0	0
17	7	1	0	0	0
18	7	1	0	0	0
19	7	1	0	0	0
20	7	1	0	0	0
21	7	1	0	0	0
22	7	1	0	0	0
23	7	1	0	0	0
24	7	1	0	0	0
25	7	1	0	0	0
26	7	1	0	0	0
27	7	1	0	0	0
28	7	1	0	0	0
29	7	1	0	0	0
30	7	1	0	0	0
31	7	1	0	0	0
32	7	1	0	0	0
33	7	1	0	0	0
34	7	1	0	0	0
35	7	1	0	0	0
36	7	1	0	0	0
37	7	1	0	0	0
38	7	1	0	0	0
39	7	1	0	0	0
40	7	1	0	0	0
41	7	1	0	0	0
42	7	1	0	0	0
43	7	1	0	0	0
44	7	1	0	0	0
45	7	1	0	0	0
46	7	1	0	0	0
47	7	1	0	0	0
48	7	1	0	0	0
49	7	1	0	0	0
50	7	1	0	0	0
1	7	1	1	1	1
2	7	1	1	1	1
4	7	1	0	0	0
5	7	1	0	0	0
3	7	1	0	0	0
6	7	1	0	0	0
\.


--
-- Data for Name: maestro; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.maestro (id, codigo, nombre, abrevia, id_padre, estado, sysuser, sysfecha) FROM stdin;
1	\N	clases	\N	\N	\N	\N	\N
2	\N	fedatarios	\N	\N	\N	\N	\N
3	\N	modos	\N	\N	\N	\N	\N
4	\N	monedas	\N	\N	\N	\N	\N
5	\N	titulos	\N	\N	\N	\N	\N
6	\N	usos	\N	\N	\N	\N	\N
7	\N	condicion terreno	\N	\N	\N	\N	\N
101	C1	Iglesia		1	1	1	2020-09-27 13:59:28.748767
102	C2	Grupo		1	1	1	2020-09-27 13:59:28.748767
103	C3	Filial		1	0	1	2020-09-27 13:59:28.748767
105	C5	Nva Cong/Filial		1	0	1	2020-09-27 13:59:28.748767
106	C6	Oficina ADRA		1	1	1	2020-09-27 13:59:28.748767
107	C7	AEPS		1	1	1	2020-09-27 13:59:28.748767
108	C8	SEHS		1	1	1	2020-09-27 13:59:28.748767
109	F1	Notario		2	1	1	2020-09-27 13:59:28.748767
110	F2	Juez de paz		2	1	1	2020-09-27 13:59:28.748767
111	F3	Abogado		2	1	1	2020-09-27 13:59:28.748767
112	F4	Otros		2	1	1	2020-09-27 13:59:28.748767
113	A1	Compra/Venta		3	1	1	2020-09-27 13:59:28.748767
114	A2	Donacion		3	1	1	2020-09-27 13:59:28.748767
115	A3	Transferencia		3	1	1	2020-09-27 13:59:28.748767
116	A4	Permuta		3	1	1	2020-09-27 13:59:28.748767
117	A5	Sesion Uso		3	1	1	2020-09-27 13:59:28.748767
118	A6	Comodato		3	1	1	2020-09-27 13:59:28.748767
119	A7	Adjudicacion		3	1	1	2020-09-27 13:59:28.748767
120	A9	Certificado de Posesion		3	1	1	2020-09-27 13:59:28.748767
121	MON01	Soles de Oro	S ORO	4	1	1	2020-09-27 13:59:28.748767
122	MON02	Intis	INT	4	1	1	2020-09-27 13:59:28.748767
123	MON03	Nuevos Soles	PEN	4	1	1	2020-09-27 13:59:28.748767
124	MON04	Dolares	US$	4	1	1	2020-09-27 13:59:28.748767
125	MON05	Ninguno	---	4	1	1	2020-09-27 13:59:28.748767
126	A	Escritura Publica de Compra-Venta		5	1	1	2020-09-27 13:59:28.748767
127	B	Escritura Publica Promesa Compra-Venta		5	1	1	2020-09-27 13:59:28.748767
128	C	Escritura Publica Cesion Derechos		5	1	1	2020-09-27 13:59:28.748767
129	D	Contrato Particular Promesa Compra-Venta		5	1	1	2020-09-27 13:59:28.748767
130	E	Contrato Particular Cesion Derechos y/o Uso		5	1	1	2020-09-27 13:59:28.748767
131	F	Recibo Inicio Pago / Prestaciones		5	1	1	2020-09-27 13:59:28.748767
132	G	Posee por Escritura Publica		5	1	1	2020-09-27 13:59:28.748767
133	H	Posee por Contr. Particular		5	1	1	2020-09-27 13:59:28.748767
134	I	Posee Consentida (sin titulo)		5	1	1	2020-09-27 13:59:28.748767
135	J	Escritura Publica Permuta		5	1	1	2020-09-27 13:59:28.748767
136	K	Contrato Particular Promesa Permuta		5	1	1	2020-09-27 13:59:28.748767
137	L	Inmueble sin Documentacion		5	1	1	2020-09-27 13:59:28.748767
138	M	Escritura Publica Donacion		5	1	1	2020-09-27 13:59:28.748767
139	N	Adjudicacion en Proceso		5	1	1	2020-09-27 13:59:28.748767
140	Ñ	Escritura Publica Imperfecta		5	1	1	2020-09-27 13:59:28.748767
141	O	Resolucion Municipal		5	1	1	2020-09-27 13:59:28.748767
142	P	Formulario de Transferencia RPU		5	1	1	2020-09-27 13:59:28.748767
143	Q	Contrato Privado de Compra-Venta		5	1	1	2020-09-27 13:59:28.748767
144	R	Afectacion en Uso por COFOPRI		5	1	1	2020-09-27 13:59:28.748767
145	S	Escritura Publica Cesion en Uso		5	1	1	2020-09-27 13:59:28.748767
146	T	Protocolizacion de Esc. Imperf.		5	1	1	2020-09-27 13:59:28.748767
147	U	Escritura Publica de Adjudicacion		5	1	1	2020-09-27 13:59:28.748767
148	V	Sin Titulos		5	1	1	2020-09-27 13:59:28.748767
149	U1	Templo		6	1	1	2020-09-27 13:59:28.748767
150	U1	Colegio		6	1	1	2020-09-27 13:59:28.748767
151	U3	Policlinico		6	1	1	2020-09-27 13:59:28.748767
152	U4	Radio		6	1	1	2020-09-27 13:59:28.748767
153	U5	Casa Pastoral		6	1	1	2020-09-27 13:59:28.748767
154	U6	Templo/Colegio		6	1	1	2020-09-27 13:59:28.748767
155	U7	Templo/Colegio/Radio		6	1	1	2020-09-27 13:59:28.748767
156	U8	Templo/Casa Pastoral		6	1	1	2020-09-27 13:59:28.748767
157	U9	Centro de Ayuda Social		6	1	1	2020-09-27 13:59:28.748767
158	U10	Colegio/Radio		6	1	1	2020-09-27 13:59:28.748767
159	U11	Asoc. Edu. A.P.S.		6	1	1	2020-09-27 13:59:28.748767
160	U12	Campo para uso Multiples		6	1	1	2020-09-27 13:59:28.748767
161	U13	Administracion		6	1	1	2020-09-27 13:59:28.748767
162	U14	Nido		6	1	1	2020-09-27 13:59:28.748767
163	U15	Jardin		6	1	1	2020-09-27 13:59:28.748767
164	U16	Colegio I,P & S		6	0	1	2020-09-27 13:59:28.748767
165	U17	Instituto		6	1	1	2020-09-27 13:59:28.748767
166	U18	Universidad		6	1	1	2020-09-27 13:59:28.748767
167	U19	Condominio/Ofic.		6	1	1	2020-09-27 13:59:28.748767
168	U20	Ninguno		6	1	1	2020-09-27 13:59:28.748767
169	U21	Libreria SEHS		6	1	1	2020-09-27 13:59:28.748767
170	CT1	Terreno Propio		7	1	1	2020-09-27 13:59:28.748767
171	CT2	Casa Alquilada		7	1	1	2020-09-27 13:59:28.748767
172	CT3	Casa de Hermano		7	1	1	2020-09-27 13:59:28.748767
173	CT4	En Posesion		7	1	1	2020-09-27 13:59:28.748767
104	C4	Casa Pastoral		1	1	1	2020-09-27 18:41:21.042731
174	DAN	DANNY xxx	DB	2	0	1	2020-09-27 19:13:24.98889
175	DVD	ejemplo de	SS	2	0	1	2020-09-27 19:13:24.991027
\.


--
-- Data for Name: predios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios (id, id_clase, id_iglesia, codigo, per_juridica, mision, nombre, telefono, correo, id_distrito, sector, avenida, nro, dpto, mza, lote, maps, observac, estado, sysuser, sysfecha) FROM stdin;
596	102	1013	20220320-00002-00000596	IASD	MPS	Viñani Renacer	983544202 salome		330304	sector 27 viñani				162	01			1	2	2022-04-15 09:58:08.32929
597	102	1054	20220415-00002-00000597	IASD	MPS	La Cano	950252361		140109	Asoc. de Vivienda Pueblo Joven Alto la Cano				"V"	04			1	2	2022-04-15 15:09:45.145739
321	101	1047	1-00000321	IASD	MPS	Siloe	966311540		330301	Ampliacion Mariscal Miller				J	13		Tes#988348004	1	2	2022-04-25 09:58:50.935162
464	107	1039	1-00000464	IASD	MPS	San Martin			140102	Zona de Vallecito	Calle Garcia Carbajal	111		D	13			1	2	2021-01-28 20:20:50.019145
171	101	1008	1-00000171	IASD	MPS	ALTO ALIANZA			140107	CORONEL ARIAS ARAGUEZ	asentamiento poblacional  Urbanizadora Coronel Araguez			B	2		958144895	1	2	2021-02-24 14:05:46.32379
598	101	1060	20220610-00002-00000598	IASD	MPS	n	959460354		140514	asoc.agroindustrial vivienda granja la primavera	los olivos			B	10			1	2	2022-06-10 19:27:13.337478
423	102	1017	1-00000423	IASD	MPS	Tumilaca	Dario-968395837		280303	centro poblado el molino	raul rueda							1	2	2021-03-02 18:51:28.28232
376	102	1034	1-00000376	IASD	MPS	Nueva Victoria Siglo XXI-	951836834 926831622		280202	Promuvi  III Nueva Victoria Mz. 11 Lote 25	Siglo XXI			11	25		se compro a nombre de Hno. falta tranferir a nombre de Iglesia  951287378- 950380331	1	2	2021-03-20 18:04:26.079653
90	102	1034	1-00000090	IASD	MPS	Villa Llbertad N. Jerusalem	980698852		280202	AA. HH. Asociacion	Pro Vivienda Villa la Libertad			L	9		falta transferencia a la Iglesia          943222245	1	2	2021-03-20 18:07:19.264232
66	101	1006	1-00000066	IASD	MPS	Faro Central y Coleg	923896686- 968014603		330301	sector Cono norte Carretera Tacna Tarata	Av Tarata	1454			17		952625081 jorge flores anciano	1	2	2021-04-15 09:57:55.712293
118	101	1057	1-00000118	IASD	MPS	CUIDAD MUNICIPAL I	991305967-958975729		140104	ASENTAMIENTO POBLACIONAL ASOC. DE VIVIENDA CUIDAD MUNICIPAL	ZONA IV			G	20		EL PREDIO ESTA INSCRITO EN REGISTROS NOMBRE DE LA IGLESIA SOLO FALTARIA EL LOTE 19	1	2	2021-04-27 08:14:04.037962
23	102	1017	1-00000023	IASD	MPS	Los Angeles	953649080		280303	CENTRO POBLADO LOS ANGELES	Urb.Villa los Angeles	2		A	12		Chura Huanacuni Elizabeth Noemi-elinemi7@hotmail.com 40falta hacer la ecritura por la cancelacion  y registralo  urgente  PADRE DEL ANGEL VENDEDOR DEL PREDIO  EL PAPA SE LLAMA lORENZO ASISTE A LA IGLESIA DE LOS ANGELES  953944034	1	2	2021-10-12 16:48:57.685787
262	102	1030	1-00000262	IASD	MPS	los  gereanios	976405348 graciela		330308	asoc. de vivienda los geranios				28	7		July-cantor_2100@hotmail.com 993030242    FALTA ACTULIZAR LOS PAGOS DE AUTOAVALUO  ELEVARA ESCRITURA PUBLICA LA MINITA PARA PROCEDER ALA INSCRIPCION	1	2	2022-04-13 17:56:30.944347
217	102	1013	1-00000217	IASD	MPS	CRISTO VIENE	986977283 carmen	moncal_30@hotmail.com	330310	Centro Poblado La Natividad -referencia  av Jorge Basadre	Sector Pago Ayca B- pasaje sol de Oro-  asoc.de vivienda Miguel Iglesias				B		Johana Soledad-948027103-johanayomar@hotmail.com-omar Calderón-52246002-978006872    ARCHIVO SIN NINGUN TIPO DE DOCUMENTO  dueña MARGARITA 952942303	1	2	2022-04-15 09:57:10.999591
2	101	1002	1-00000002	IASD	MPS	Alto Selva Alegre "B" terreno 	263319		140101	PP.JJ. Alto Selva Alegre  ( cancha esta vacio el terreno )	Av. Argentina	402		18	31		1-cancha Desucupado 	1	1	2020-09-22 08:16:17
155	101	1034	1-00000155	IASD	MPS	Nuevo Ilo	964002054-942629520		280202	IV PROGRAMA MUNICIPAL DE VIVIENDA NUEVO ILO				32	9		-ado-huichi@hotmail.com .04652175   974421144- 950879454	1	2	2021-03-20 18:16:59.516282
307	101	1030	1-00000307	IASD	MPS	Galilea	995710178 jesus		330303	A.H.M.Ampliacion ciudad nueva Comite 49				166	11		Teodora.052310847.mariela123_17@hotmail.com Ivan.052310793.#952697778 tomas.7k_like@hotmail.com  952525311 Timoteo	1	2	2022-04-13 17:54:39.201803
599	101	1060	20220610-00002-00000599	IASD	MPS	Ciudad Nueva	959460354		140514	asoc.agroind.vivienda granja	los olivos			B	10			1	2	2022-06-10 19:33:53.66948
69	101	1032	1-00000069	IASD	MPS	Vista Alegre	995522991-966287709		330304	asentamiento humano asociacion de vivienda vista alegre				44	10		Dina-becksmer@hotmail.com    -falta pago de arbitrios y autovaluo  frine	1	2	2022-06-15 19:35:35.426458
43	101	1025	1-00000043	IASD	MPS	Mariano Melgar	958346676		140110	pueblo joven Generalisimo Jose de san Martin zona c	av. Peru 	130		1	16		falta pago de Arbitrios	1	1	2020-11-13 17:30:46
251	101	1023	1-00000251	IASD	MPS	Zamacola  Central	993520314 940369039		140104	zamacola	CALLE URUBAMBA	111		R	5		958653588	1	1	2021-01-25 00:15:53.220542
72	101	1032	1-00000072	IASD	MPS	Campo Marte 1			330304	 Habilitacion urbana promuvi Viñani II				211	34			1	1	2020-11-24 19:16:53
549	107	1039	1-00000549	IASD	MPS	Majes			140514	Habilitacion urbano centro poblado Basico el pedregal				A10	9			1	2	2021-01-25 13:48:31.592139
113	102	1056	1-00000113	IASD	MPS	ALAS DORADAS			280303	sector 2 de las pampas de San Antonio N° 07	Centro Poblado San Antonio			D	1			1	2	2021-10-18 20:52:03.652046
580	101	1021	1-00000580	IASD	MPS	CORAZON DE JESUS	945031019-	940961379	140118	Pueblo Joven sector 1	asentamientos poblacional asoc. de vivienda de inters social corazon de Jesus			K	4			1	2	2021-01-25 19:28:08.720047
164	101	1008	1-00000164	IASD	MPS	LA MERCED	989813938-989813938		140107	ASENTAMIENTO HUMANO LA MERCED	comite 02 MZ-E , L 4			E	4		ES UN TERRENO NUEVO 	1	1	2020-11-03 10:15:33
45	101	1025	1-00000045	IASD	MPS	Progresista	982570879-958555129		140113	Jorge Chavez	Junin	106		39	8		1- falta pago arbitrios y autovaluo  verificar en Registros públicos  2- falta Los linderos y medidas peremetricas  3- falta escritura Publica original no esta en archivos	1	2	2021-01-28 12:34:13.150339
202	101	1048	1-00000202	IASD	MPS	ALTO LIBERTAD	959333065		140104	pueblo joven alto libertad	Lampa			19	12			1	2	2021-04-27 08:17:01.903183
219	104	1013	1-00000219	IASD	MPS	CASA PASTORAL	mps		330310	Agrupacion Viv. Francisco Antonio de Zela  B -08				B	8			1	2	2022-04-15 09:58:51.149649
215	101	1022	1-00000215	IASD	MPS	UMACOLLO	959743139-95906710		140102	URB. BARRIO MAGISTERIAL II Yanahuara	Cercado	2		H	6			1	1	2020-12-01 12:23:43
216	102	1021	1-00000216	IASD	MPS	CERRO VERDE	982535732		140125	PAMPAS NUEVAS DE CONGATA	Asociacion Rosales			F	1		moriam_9hotmail.com	1	1	2019-08-07 22:35:30
495	101	1007	1-00000494	IASD	MPS	EL BUEN PASTOR	925390188- 959796969	jvalentíno2004@hotmail.com	330304	Asociacion Villa Santa Fe    Cono Sur				A	19		-edgar_tacna@hotmail.com	1	2	2022-06-16 16:54:31.577889
292	101	1043	1-00000292	IASD	MPS	Valle del Colca 3			140505	Centro poblado Chivay	sector B hanansaya			N	8		dueña es Isabel figueroa 958155977  dueño del seguiente lote  955638489	1	1	2020-10-21 19:58:04
338	102	1027	1-00000338	IASD	MPS	Acari	955734097		140301	Asentamientos Humanos Acari 							falta docuemntos	1	1	2019-06-23 04:53:52
339	102	1027	1-00000339	IASD	MPS	Atico	958952230		140302		AA.HH.PJ La Florida Atico			14	7		falta docuemento	1	1	2020-09-25 12:56:58
595	101	1060	20220304-00002-00000595	IASD	MPS	B-3			140514	centro de servicios asentamiento B-3 de la seccionB	promera etapa del proyecto Majes			"J"	05			1	2	2022-03-04 08:15:00.328556
438	102	1020	1-00000438	IASD	MPS	Coripata			140123		Coripata			L	42			1	1	2019-05-18 00:40:05
505	102	1029	1-00000505	IASD	MPS	Proter			330309	Asociacion Vivienda Proter Sama				D	2			1	1	2018-12-15 10:26:31
15	102	1003	1-00000015	IASD	MPS	San Juan de Chorunga	971141966		140201	Cerro Colorado	(Ultima Casa)	s/n						0	1	2019-06-05 03:32:15
402	102	1015	1-00000402	IASD	MPS	Alto Tambo	956470242		140701		Carrizales 							0	1	2020-09-09 22:50:28
1	101	1002	1-00000001	IASD	MPS	ASA.Igl.Central y Casa Pastoral	959681280 263319		140101	PP.JJ. Alto Selva Alegre	Av. Argentina	404		18	30		FALTA PAGO DE ARBITRIOS Y AUTOVALUO  1- FALTA VERIFICAR MEDIDA NO ESTA DE ACUERDO CON ESCRITURA NI CON REGISTRO PUBLICOS  NI CON EL CONSEJO CATASTRO	1	1	2020-07-11 18:30:52
3	101	1002	1-00000003	IASD	MPS	Independencia	959727041 993392747 		140101	AA.HH. Primero de Enero sector A	Jiron Alfonso Ugarte	-	-	H	11		959727041   942126440	1	1	2020-02-20 20:55:37
4	101	1002	1-00000004	IASD	MPS	Leones del Misti	980980712		140101	PP.JJ. Leones del Misti	Calle Progreso	104		K	12		1- Pago de arbitrios y pago de autovaluo  	1	1	2020-07-08 18:31:59
5	101	1002	1-00000005	IASD	MPS	Betel	959453229  992897730		140101	PP. JJ. pampa de polancos sector villa arequipa		-	-	H	5		1- falta pago de arbitrios y autovaluo  2. medidas no esta correctas co escritura y registros publicos  959453229  	1	1	2020-12-01 12:32:48
7	102	1002	1-00000007	IASD	MPS	Tres Balcones	958702010-957979921		140101	Programa Municipal alto Selva Alegre 1  Zona A				H	2		1-celular  957978921 965889687  957978921  	1	1	2020-12-01 12:33:11
8	101	1003	1-00000008	IASD	MPS	Camana	953268061		140201	Cerasentamiento humano pueblo joven centro poblado	Av. Mariscal Castilla	602	-	B1	3			1	1	2020-10-15 13:58:59
9	101	1003	1-00000009	IASD	MPS	Eben Ezer	958803647- 993103154		140208	Urb. Juan Pablo	Via Paisajista s/n (entre 28 julio y Juan Pablo)	-	-	-	-			1	1	2019-06-05 03:19:18
12	101	1003	1-00000012	IASD	MPS	Pucchun	958261703- 950723973		140204	Km.804 Carret. Panamericana centro poblado pucchun	zona C 	-	-	R	1		910381253 alan  929475983	1	1	2020-10-08 13:45:11
14	102	1003	1-00000014	IASD	MPS	San Jose	913770150 987590025 		140204	Centro Poblado San Jose		s/n		B	2B		hno leon 913770150	1	1	2020-11-05 17:13:08
16	101	1004	1-00000016	IASD	MPS	Buenos Aires	930274377 958017682		140103	Proyecto Alto Cayma Sector I Programa prog.Tepro Zona A	Pasaje F	-	-	D	5			1	1	2020-10-20 09:03:49
17	101	1004	1-00000017	IASD	MPS	Cayma Central	944032963 959641600		140103	AA.HH. Asoc. Provivienda Interes Social Villa El Mirador	Asoc. Villa El Mirador Av Arequipa	110		C	1		944032963	1	1	2020-11-24 09:28:05
586	101	1054	1-00000586	IASD	MPS	Villa Hermosa			140109		Villa Hermosa			M	48			1	1	2019-09-09 18:14:01
587	101	1028	1-00000587	IASD	MPS	caylloma 2			140504									1	1	2020-10-13 23:22:07
18	101	1023	1-00000018	IASD	MPS	Villa Continental	958205205- 966600797		140103	Proyecto Alto Cayma Sector 1 programa Tepro Zona C	Asoc.Villa Continental Comite 2, Pasaje sin nombre			X	14			1	1	2020-10-20 09:05:15
24	102	1020	1-00000024	IASD	MPS	Belen	978542829 mariela		140108	frente a la propiedad del estado -frente urb sol y luna av Rivera	Av. Rivera						falta hacer la desmenbracion del predio presentar plano y menoria descriptiva.  presentar y saniar ante la Municipalidad y pagar Arbitrios y pedir exoneracion de autovaluo,hacre con la esctitura.  falta incribir a registros Publicos  hno. 974346581    	1	1	2020-11-27 16:23:12
25	102	1001	1-00000025	IASD	MPS	predio sin ocupar (7000 metros ) 			330310	Terreno Rustico Ubic.Rural Demominado para 					24-B1		esta con escritura y registrado en registros publicos   falta inscribir en Municipio  falta pago de Autovaluo   falta pagar arbitrios	1	1	2020-11-09 12:16:02
26	102	1011	1-00000026	IASD	MPS	Nueva tacna Leoncio prado	952836618		330310	AA. HH. Leoncio Prado	PP.JJ. Leoncio Prado 26 de Mayo 1425			8	13		Ticahuanca Lope Julio-llantasjt_78@hotmail.com-    falta cambio de nombre recibos de Agua-#952836618	1	1	2020-11-09 14:33:58
28	101	1024	1-00000028	IASD	MPS	Los Angeles	983814593- 959994949	lidianpe@gmail.com	140129	Asentamientos Poblacional asociacion Urbanizadora Ciudad de Dios	sector A zona 2			E´	7		esta inscrito en registros    falta pago arbitrios  falta autovaluo	1	1	2020-07-09 17:02:00
29	102	1022	1-00000029	IASD	MPS	Guaranguito	992592883		140104	Pachacutec	Huaranguito (Urb. Mariscal Castilla Calle San Martin S/N						solo cuenta con escritura  falta Inscripcion a Registros  Falta pago autovaluo  falta cambio de uso	1	1	2020-12-08 13:45:34
30	102	1001	1-00000030	IASD	MPS	predio sin ocupar (Calderon)			330310	 Sector Para Grande	C.P. Parc. 9_3608000_01958						falta hacer rectificacion de la escritura   pago de autovaluo   cambio de uso	1	1	2020-11-09 09:40:10
37	102	1040	1-00000037	IASD	MPS	terreno sin uso			330308	La cruz-calle Jades Sector peaña 	La cruz B-4 valle de Tacna c.p.parc.9_3708005_01399 U.C.01399						Falta sanear  medidas   falta sacar registros publico y revisar   falta inscripcion Municipio Pocollay   Falta pago de Autovaluo   Falta Arbitrios	1	1	2020-10-05 21:02:35
39	102	1055	1-00000039	IASD	MPS	Pueblo Libre	980133637		330310	Programa de Vivienda				Z	1-10		el tereno esta Nombre de educacion del Estado En Bienes Nacionales 951506702 992838483 	1	1	2019-12-26 15:38:04
40	102	1015	1-00000040	IASD	MPS	Nuevo Arenal - Avis el frisco	985237424 971650815		140702	AA.HH. el Frisco	el Frisco			A	4		falta inscripcion a registros publico  falta registrar en la Municipalidad  falta pagos de autovaluo y Arbitrios	1	1	2020-10-13 18:56:49
44	102	1025	1-00000044	IASD	MPS	nueva Jerusalem	957875244		140110	Asoc. de Vivienda Las Dalias 				c	26		1- corregir la escritura publica y registros públicos rectificación dice lote 26 manzana A calle botaderos  debe decir lote 26 Manzana c y también falta agregar la aria de 180 metros.    2- falta medidas de Linderos y medidas peremetricas	1	1	2020-10-15 12:33:19
47	101	1025	1-00000047	IASD	MPS	Villa Hermosa	958025518 979728777		140113	Pueblo Joven Miguel Grau zona D				32	8h		1- falta pago de arbitrios y autovaluo  	1	1	2019-04-23 20:39:19
48	102	1017	1-00000048	IASD	MPS	Omate			280107	Sector San Isidro				L	7		1- falta de pago de Arbitrios y autovaluo  2-falta visitar si esta ocupando o esta vacio	1	1	2019-10-15 19:59:42
50	102	1017	1-00000050	IASD	MPS	Quinistaquilla			280303								falta documentos no tiene nada de nada	1	1	2019-10-15 12:25:13
52	102	1002	1-00000052	IASD	MPS	Villa Ecologica	973661773 944985141		140101	Villa Ecologica Zona D , MZ E, L 7				E"	7		falta docuemntos	1	1	2020-12-01 12:33:35
88	101	1027	1-00000088	IASD	MPS	Chala	997604578- 988321488		140307	AA. HH. Manuel Prado-KM.567 Carretera Panamericana,Urb.Manuel Pardo	Av 8 de Diciembre			16	08-A			1	1	2020-12-01 12:34:43
19	101	1059	1-00000019	IASD	MPS	Villa Esperanza	984418113 960328720		140104	15 de Octubre	AA.HH.Asociacion de vivienda de interes Social 15 de octubre	-	-	A	8			1	2	2021-03-03 17:51:13.853529
21	101	1004	1-00000021	IASD	MPS	Rafael Belaunde	978313071-961303273		140103	AA.HH. Rafael Belaunde	Zona B			F	2			1	2	2021-03-08 18:32:20.331717
51	102	1002	1-00000051	IASD	MPS	Villa Confraternidad	958174531 960295747		140101	Independencia							esta en  casa de herm  977354722	0	1	2018-12-14 21:13:50
588	102	1055	1-00000588	IASD	MPS	4 Suyos			330310	-.--	asentamientos humanos asoc. agro industrial 4 suyos			B	3		asencio 924454252 -23	1	2	2023-10-08 16:30:49.945648
13	102	1003	1-00000013	IASD	MPS	San Gregorio	927040398		140205	asentamiento humano san gregorio  zona A	Av. Jacinto Pastor	1511		L	9		encragado  percy celular 950740564	1	2	2024-03-05 06:40:05.728816
35	102	1040	1-00000035	IASD	MPS	PACHIA	961517237-Teresa		330306	Sector Miculla	carretera calientes kilometro 22						Virgin-danielsanchez@teologia.edu.pe-Quispe Asqui Teresa-961517237    falta registrar en Registros Publicos  falta registrar Municipio  Falta Desmenbrar terreno  falta tramitar para agua y Luz	1	2	2022-04-13 17:13:27.284623
41	104	1009	1-00000041	IASD	MPS	Casa pastoral			280202	Upis alto Ilo zona norte				K	28		falta Autovaluo                                    se cambio de denominacion IASD 21-06-2019	1	2	2021-04-23 09:46:21.678142
32	102	1034	1-00000032	IASD	MPS	Villa Primavera  ( antes Enersur)	985032677-927572769		280202	Asentamientos Humanos Promuvi Pampa Inalambrica	Sector Promuvi VII			29	4		929440630	1	2	2021-03-21 19:12:19.837997
27	102	1001	1-00000027	IASD	MPS	Iglesia la Victoria Nazaret y Oficinas	993667745		330310	Para Chico U.C. 02549	los Olivos						falta Inscripcion en la Municipaliadad y pago de arbitrios y Autovaluo   falta Inscripcion en los registrso Publicos.  terreno para oficinas 948642700	1	2	2022-04-13 17:40:47.412374
33	101	1034	1-00000033	IASD	MPS	Villa Paraiso	952725711-9883368566		280202	AA. HH. Promuvi V sector A				36	10		falta inscripcion en la Municipalidad  Cambio Nombre agua y Luz  - 938103330	1	2	2021-11-28 18:32:14.147017
34	101	1006	1-00000034	IASD	MPS	Belen			330301	Asoc.Vivienda San Pedro y San Pablo Zona A-1 cono norte	pasaje san Felipe 130			F	22			1	2	2021-07-14 13:21:38.529091
22	101	1004	1-00000022	IASD	MPS	La Tomilla	999902709		140103		Micaela Bastidas	271	-	-	-			0	1	2018-12-15 08:01:23
46	102	1025	1-00000046	IASD	MPS	Eben Ezer	993637145		140110	PP.JJ. San Andres	Av Garcilazo de la Vega	317		A	9		esta con solo contrato de transferencia de dominio anombre Jose Miguel  Escarcena Yaguno falta documentos de adjudicación y de compra  1- falta hacer tranferencia a nombre de la Iglesia( escrtura)  2- falta pagar arbitrios y autovaluo	0	1	2019-10-15 17:36:03
53	101	1029	1-00000053	IASD	MPS	Global 2000	974461497-952945164	dapava.777@hotmail.com	330310		calle zela 610-616	616					Armando-armando2151@hotmail.com- Ruben -990957075    1- falta pagar arbitrios y autovaluo  2-falta datos de colindantes 	1	1	2020-11-09 19:19:35
54	101	1029	1-00000054	IASD	MPS	Getsemani	956928070 952991926 		330310	Cercado	calle Ordonel Vargas 365-375	375					Luis .052603313-luismamanitapia@hotmail.com Hermenegildo-990399114    1- Falta pago de Arbitrios y autovaluo  2- falta medidas de colindantes	1	1	2020-11-05 17:52:48
55	102	1029	1-00000055	IASD	MPS	Tomasiri	910578744 952910636 		330305	Sector Nuevo Tomasiri				N	1-2		 encargado Hno Gutierrez  95291063)6Eliseo Jinez Mquera-952806679-eliseo_jinez@hotm  2- se persento a cofopri urgente  	1	1	2020-12-01 16:10:15
57	102	1029	1-00000057	IASD	MPS	sector Berlin	951968739		330305	sector  alto Berlin 	parte alta calle 2			unica	S/n		-falta titular   -inscribir a cofopri  esta como terreno	1	1	2019-05-06 22:57:39
58	101	1029	1-00000058	IASD	MPS	Sama Inclan	Nain-964533192		330305	Chacra parte baja 	unico lote y manzana				1		1-falta titulación  2- falta pago de arbitrios autovaluo  3- terreno vacio  	1	1	2020-12-01 16:12:31
59	101	1029	1-00000059	IASD	MPS	Sama Inclan 1	951968739		330305	Sama Inclan	asoc. Santo Bartolome Alto Rayo						 falta datos del terreno que ocupa la Iglesia actualmente  es donado por el hermano es pequeño  pero los hermanos se están tarsladando al terreno mas grande de 8695 12 metros  	1	1	2020-11-09 15:30:41
60	101	1047	1-00000060	IASD	MPS	Sinai	949554463		330301	AA. HH. La Esperanza 	Av. Tupac Amaru 	248		48	13		1-falta pago autovaluo arbitrios-952800690	1	1	2020-11-04 21:43:30
61	101	1047	1-00000061	IASD	MPS	San Martin	952604673		330301	PP. JJ. Jose San Martin	calle Oscar Carbajal Soto 730			I	20		1- falta titulación  2- pago de autovaluo y arbitrios  3.-EN archivo no hay escritura publica Y/O tipo de documento alguno del predio	1	1	2020-12-01 15:13:24
62	101	1047	1-00000062	IASD	MPS	Canaan	Gumercindo-959636510		330301	Asociacion de Vivienda Mariscal Miller	Calle Victor Fajardo N° 220			F	7		innkkk_20@hotmail.com gumercindo.camasita     1-Falta pago de RBITRIOS Y AUt    2.-EN archivo no hay escritura publica Y/O tipo de documento alguno del predio	1	1	2020-11-05 01:08:38
64	102	1047	1-00000064	IASD	MPS	 Alto Faro Intiorko	935124011		330301	Asentamiento Humano Frente Unico de Asociaciones de vivienda del cono norte	sector 10 Asocicaciion Intiorko			P	7		Alicia Chávez Villanueva-947028679-aliz_bella@hotmail.com    1-falta tramites  de agua y Luz  2- falta medida de colindantes sacar de registros publicos 9965607105 Bernardo  3.- en archivo no hay escritura publica 	1	1	2020-11-09 15:34:32
65	104	1006	1-00000065	IASD	MPS	Casa Pastoral			330301	Cooperativa de Vivienda Gregorio Albarracin LTDA 003	Pasaje Chimu 165			D	4			1	1	2019-06-22 17:55:21
67	101	1055	1-00000067	IASD	MPS	Nuevo Amanecer 	997868856		330310	Asociacion  Rural  de vivienda fronteras los Palos				I	14		Huber Ismael-952959089-hismael015@gmail.com-Tito Copari Pilco-968297461    1-son 2 lotes   2-falta pago de arbitrios .autovaluo Telefonos9529337960 pedro maq	1	1	2019-07-25 03:46:25
42	102	1025	1-00000042	IASD	MPS	Monte de los Olivos	960183024		140110	AA.HH. Los Olivos Zona 1				U 1	2		falta sacar titulo	1	2	2021-01-12 14:05:38.382559
70	101	1007	1-00000070	IASD	MPS	Filadelfia	984720604 -975975281		330304	Asentamientos Humanos Asociacion De vivienda villa	villa 28 de Agosto 			12	25		Miguel Chique-#952624424-edgar_tacna@hotmail.com     1- falta pafo se arbitrios y autovaluo  2- inscripción en consejo catastro y rentas  3- falta linderos no se sabe	1	1	2020-12-08 08:41:42
71	101	1007	1-00000071	IASD	MPS	Los Tres Angeles	952315042		330304	Asociacion de Vivienda Jose  carlos  Mariategui	Urbanizacionpopular asociacion con fines			37	44		Torres verguiere Arturo Humberto -artur2323_1@hotmail.com    1- falta pago arbitrios y autovaluo   2- falta registrar en consejo catastro y Rentas	1	1	2020-11-24 18:57:27
73	101	1007	1-00000073	IASD	MPS	San Francisco	983		330304	Asent.Humanos Asoc. De Viv.San Francisco				117	11		-sonnia_ca@hotmail.com-sonia.carrillo- Jannet Blanca-952841206 jeanet_b118@hotmail.com  	1	1	2020-11-24 18:58:49
74	101	1032	1-00000074	IASD	MPS	Campo Marte  2	924639711		330304	 Habilitacion Urbana promuvi Viñani II				211	5		-Marca Pacohuaraco-947678740    titulo domingo  rp987843698	1	1	2020-12-08 08:35:37
75	101	1032	1-00000075	IASD	MPS	campo Marte 3			330304	promuvi Viñani II				211	6		falta transferencia ala mision	1	1	2020-11-24 19:17:48
77	101	1010	1-00000077	IASD	MPS	HUANUARA	994115480	956439816 jhons vargas	330105	DENOMINADO TAPIAL	DENTRO DE LA CAMPIÑA	-	-	V	1		1- FALTA REGISTRATRA REGISTRSO PUBLICOS   2- FALTA PAGO AUTOVALUO Y ARBITRIOS  3- LINDERROS	1	2	2023-09-03 18:28:49.441564
76	101	1010	1-00000076	IASD	MPS	CAIRANI	925649919 928192904	900031463	330101	Sector Pucarane	Sector Pucarane Faja de Agua del Rio Cairane	-	-	-	-		1- Falta registrar registros públicos  2- Falta linderos  3- Falta pago autovaluo y arbitrios\n\n996337269 saul lopez 2023	1	2	2023-09-03 18:30:45.05744
82	104	1010	1-00000082	IASD	MPS	CASA PASTORAL			330201	ASNTAMIENTO HUMANO MIRAVE				E	4		1.FALTA REGISTRAR EN REGISTROS PUBLICOS   2- PAGO DE ARBITRIOS AUTOVALUO	1	1	2018-12-15 11:29:53
85	102	1011	1-00000085	IASD	MPS	Susapaya			330405		Calle Arequipa ,esquina con la calle Miraflores 						1-falata pago de arbitrios y autovaluo	1	1	2020-12-03 07:20:55
87	101	1027	1-00000087	IASD	MPS	Chaparra	953220970 tes		140308	los perale del pueblo de chaparra				Y	4		anciano 974777299	1	1	2020-09-25 12:42:53
89	102	1011	1-00000089	IASD	MPS	Sitajara			330404		Calle  Ayacucho						1- falta titulo	1	1	2020-12-03 06:52:55
68	102	1032	1-00000068	IASD	MPS	Viñani I	953426819		330304	asoc c artesanos Habilitacionurbana promuvi viñani IV				392	1-59		949887055-mocherive@hotmail.com    1- falta documentos no tiene #955601077	1	2	2021-12-03 11:52:09.615726
100	101	1011	1-00000100	IASD	MPS	NATIVIDAD	955929500		330310	El Pago de Uchusuma Sector de Capanique	P.J. La Natividad.Cristina Vildoso san Francisco	2180			22		Hno.Victor cerpa 952362884 -952845010-Toribio  Contreras Soledad-solcona@hotmail.com 952845010. 952672193  	1	1	2020-11-23 22:51:00
101	101	1011	1-00000101	IASD	MPS	LA VICTORIA	952808099		330310	Urb. La Viña	CALLE MARIANO MELGAR 	910		A	1		Acero Chambi Braulio- jeluav@hotmail.com-    ACTUALIZAR LOS PAGOS DE IMPUESTO PREDIAL Y LOS ARBITRIOS, TODAVIA NO ESTA INSCRIOTA EN REGISTROS PUBLICOS, NO SE TIEN DATOS DE LASCOLINDANCIAS EN METROS 990077080-952874477	1	1	2020-11-18 12:27:18
102	101	1011	1-00000102	IASD	MPS	LA ALBORADA	952660980		330310	URBANIZACION RAMON CASTILLA	Jiron Amazonas			E	14		Fredy-fredyac65@gmail.com    ACTUALIZAR LOS PAGOS D LOS ARBITRIOS E IMPUESTOS 952660980-982603170	1	1	2020-11-11 16:19:10
103	101	1031	1-00000103	IASD	MPS	NUEVA TACNA	995076687- 973643476		330304	Programa de Vivienda Alfonso Ugarte III	8 DE DICIEMBRE			A3	22		edith_14_1@hotmail.com edith.mamani-Flores Vildoso Alberto-952906690- 952946170      SON TRES LOTES QUE CORRESPONDE A AL IGLESIA NUEVA TACNA LOTE 22, 23 Y 24.  hay que acumular    	1	1	2020-12-08 08:44:35
104	101	1031	1-00000104	IASD	MPS	NUEVA TACNA			330304	Programa de Vivienda Alfonso Ugarte  III	Asociacion 8 Diciembre			A3	23		hay que acumular	1	1	2020-12-08 09:00:30
105	101	1031	1-00000105	IASD	MPS	NUEVA TACNA			330304	Programa de Vivienda Alfonso Ugarte III	MZ A3, L24			A3	24		acumular	1	1	2020-12-08 09:00:40
106	101	1016	1-00000106	IASD	MPS	BUENOS AIRES	953913876		280303	Municiplaidad Centro Poblado San Francisco	PASAJE JERUSALEN PP.J.J San Francisco comite 20			B"	9		953637164 940827959 	1	1	2020-10-22 20:44:48
107	102	1016	1-00000107	IASD	MPS	 colegio Parte Baja F.E			280303	Cercado	Calle CUZCO	388-A					EN EL LINK CLASE NO HAY COLEGIO	1	1	2020-10-20 08:21:22
159	101	1042	1-00000159	IASD	MPS	VALDENSES	958149460		140113	Urb.. CESAR VALLEJO				F	9		ACTUALIZAR LOS PAGOS DE AUTOAVALUO E IMPUESTOS PREDIALES 	1	1	2020-02-27 11:32:22
112	104	1016	1-00000112	IASD	MPS	Casa pastoral			280303	Municipalidad Centro Poblado San Francisco	 P.J San Francisco calle 28 de Julio	575		Z"	10		tenemos que levantar la craga de deuda banco Materiale  1- escrito  2- titulo archivado 08A3002257  3-escritura de compra  4- vigencia de poder   5- ficha registros certificada     	1	1	2020-10-13 16:39:53
114	102	1024	1-00000114	IASD	MPS	DIVINA LUZ	931181278- 958695734		140129	URBANIZACION CUIDAD DE DIOS ZONA I , SECTOR C COMITE 30	MZ H, L6  ZONA 1 SECTOR C			H	6		LA PRTOPIEDAD SE ENCUENTRA REGISTRADA   NO SE TIEN DOCUMENTOS DEL PAGO DE IMPUESTOS ,ARBITRIOS MUNICIPALES	1	1	2020-10-20 09:00:07
115	101	1024	1-00000115	IASD	MPS	PERUARBO	997321240#988527723 		140104	SECTOR PERU ZONA II				G-3	6		tramitar documentos   1.-CERTIFICADO DE posesion de Municipio cerro coleorado  encargada de patrimonio Hna. Francisca 938409899 #988527723 -2016	1	1	2020-12-04 19:33:10
116	101	1024	1-00000116	IASD	MPS	MONTE SION	958142929-981861665		140129	ZONA 4 SECTOR A  ASOC. URBANIZACIÓN CUIDAD DE DIOS	calle 38			C	18		tesorera rosmery13-mp@hotmail.com	1	1	2020-11-05 10:58:06
117	102	1057	1-00000117	IASD	MPS	EL BUEN PASTOR	910150004		140129	ASOC. URBANIZACION SOR ANA  DE LOS ANGELES  Y MONTEAGUADO 	ZONA II			E"	7		EL PREDIO TIEN TITULO DE PROPIEDAD , PERO NO A NOMBRE DE LA IGLESIA ES NECESARIO REGISTRA CON LA ESCRITURA DECOMPRA VENTA 	1	1	2019-10-07 15:44:57
119	101	1057	1-00000119	IASD	MPS	CUIDAD MUNICIPAL II			140104	ASENTAMIENTO POBLACIONAL ASOC. DE VIVIENDA CUIDAD MUNICIPAL 	zona VI			G	19			1	1	2020-02-06 20:03:28
129	101	1028	1-00000129	IASD	MPS	CAYLLOMA CENTRAL	987887527 958384892		140504	Centro poblado Caylloma	sector barrio Diego Cristobal Tupac Amaru			C3	4		984484154 958078651 	1	1	2020-10-13 23:15:52
130	101	1028	1-00000130	IASD	MPS	PUENTE TOLCONI	939866709		140603	MARGEN IZQUIERDA  DEL RIO LLATATOYO JUNTO AL PUENETE MOLLOCO							EL DOCUMENTO DE ADQUISISCION ES DE UN CONTRATO DE DONACION 932883122 969041685 	1	1	2019-06-08 23:18:27
131	101	1028	1-00000131	IASD	MPS	CHUIRE	944094634		140504	RAJADA APACHETA								1	1	2020-07-10 14:43:06
134	101	1028	1-00000134	IASD	MPS	NUEVO AMANECER	974760576 972449729 		140504	URBANIZACION AZUL MAYO								1	1	2019-03-30 14:58:44
135	101	1026	1-00000135	IASD	MPS	APLAO	959661862		140402	Costado de cementerio	CALLE LA LIBERTAD	801		R	7		ANGELA ENCARNACION LIZARRAGA NUÑES existe un aescritura 2664  de compra y venta en 900 intis con frcha 18-12-1986 notario norky oviedo este es como referncia ya esta titulado por cofopri a nombre de IASD	1	1	2020-09-17 19:15:26
137	101	1026	1-00000137	IASD	MPS	 Viraco JES. ES MI PASTO	941181514		140414	SOLAR URBANO 	CALLE LIMA Y SAN ANTONIO DEL BARRIO MASACRA 							1	1	2020-07-10 14:35:43
108	101	1016	1-00000108	IASD	MPS	MOQUEGUA Central	953934342		280101	cercado	ILO	333					-josenina22@hotmail.com .    Ojo Ver hay 2 codigo del predio    953934342	1	2	2021-03-08 19:26:55.320036
120	101	1057	1-00000120	IASD	MPS	CANTERAS CAPNA	971197767		140104	ASENTAMIENTO POBLACIONAL  ASOC. CENTRO INDUSTRIAL LAS CANTERAS				F	4		987528735- 951346122	1	2	2021-04-27 08:13:00.83797
111	101	1056	1-00000111	IASD	MPS	Fuerte Esperanza	968740792-945346367		280303	PROYECT.HABILITAC URB. PAMPAS S.ANTONIO 15 SECT. A	Calle- 14-Centro poblado San Antonio el trebol			U2	15		anciano de Iglesia#953970601 985615613	1	2	2021-05-21 09:48:18.247454
109	102	1016	1-00000109	IASD	MPS	Moquegua costado Igl.oficinas AEAPS			280303	terreno sin construccion	Calle Ilo	335						1	2	2021-11-01 09:41:52.5826
92	101	1016	1-00000092	IASD	MPS	Luz del Alba	968001515		280303	Municipalidad Centro Poblado San Francisco	Asoc.Virgen de chapi, centro poblado menor san francisco			E	7-8-9		--percy.beltran@hotmail.com   Jose 999095682  Ysabel 938524301  Marino 953505253	1	2	2022-11-16 21:31:41.501998
80	102	1010	1-00000080	IASD	MPS	YARABAMBA	925435184 988384488	988384488-917328804	330101	C.P. DE YARABAMBA	-	-	-	-	-		1- FALTA ESRITURA PUBLICA  2-PAGO DE AUTOVALUO ARBITRIOS	1	2	2023-09-03 18:35:57.896729
81	102	1010	1-00000081	IASD	MPS	CAMILACA	952012515 971941966	944817273-926002714-931983076	330102	ALTO CAMILACA	-	-	-	P	11		1-HAY 2 MEDIDAS DIFERENTES 10000 Y 11000	1	2	2023-09-03 18:39:20.744319
132	102	1028	1-00000132	IASD	MPS	ARCATA	969516027-964867085		140602	centro poblado arcata sector arcata				F	8		 985564749 983697391	0	1	2020-09-25 13:09:29
138	102	1026	1-00000138	IASD	MPS	CENTRAL ORONGO	927045647		140402	ASENTAMIENTO HUMANO LA CENTRAL	ZONA 2			P	10		tramite cofopr	1	2	2021-11-05 06:35:46.65407
110	101	1056	1-00000110	IASD	MPS	NUEVA VISION	929928817		280303	centro poblado San Antonio N° 11	Programa municipal  de Vivienda PAMPAS SAN ANTONIO promuvi			w2	4		secretaria de iglesia 961998842	1	2	2021-11-21 11:03:14.079582
139	101	1028	1-00000139	IASD	MPS	ORCOPAMPA	955324376		140409	URBANIZACIÓN  VISTA ALEGRE	10-11-12-13-	108		D 4	4		ELEL PREDIO COMPRENDE LOS LOTES 10,11,12,13  cofopri p06211174   975136086 957975653	1	1	2020-10-21 12:02:55
140	102	1028	1-00000140	IASD	MPS	LA LAGUNA	920507796		140409	URBANIZACION LA LAGUNA CENTRO POBLADO DE ORCOPAMPA	CALLE CUSCO			B2	8A		998002758	1	1	2020-10-20 11:16:15
141	101	1026	1-00000141	IASD	MPS	COTAHUASI	939625172		140803	SECTOR DE CHACAYLLA  DENOMINADO LA QUEBRADA								1	1	2019-06-13 16:58:26
142	102	1026	1-00000142	IASD	MPS	CORIRE	943178989 957932019		140402	SECTOR DE URACA VALLE DE MAJES	banda			C	7,8			1	1	2019-08-17 23:02:47
143	102	1026	1-00000143	IASD	MPS	LA REAL	957932019		140402	ANEXO LA REAL	asentamiento humano la real zona A			B	5			1	1	2019-09-22 19:06:55
144	101	1026	1-00000144	IASD	MPS	CASTILLO	 928663658 959754996		140402	ASENTAMIENTO HUMANO  AMPLIACION EL CASTILLO				M	3			1	1	2020-11-24 11:21:52
145	102	1028	1-00000145	IASD	MPS	ANDAGUA	983131200 995036651		140401	URBANIZACION VIRGEN DEL ROSARIO				E	7			1	1	2020-09-25 13:02:47
146	102	1003	1-00000146	IASD	MPS	INDEPENDENCIA A	 925491767 996010133		140201	URBANIZACION FRANCO				F	2			1	1	2019-07-04 19:43:24
149	102	1003	1-00000149	IASD	MPS	HUACAPUY	928018253  996999331		140202	H.U. PROGRESIVA CONCOSNTRUCCION SIMULTANEA  RICARDO ARMANDO	centro poblado el puente huacapuy el puente			J	4		el dueño es martinez llerena adalberto miguel casado  flores hala juana felicitas casado   p06176736	1	1	2020-10-15 14:06:44
153	101	1009	1-00000153	IASD	MPS	18 DE MAYO	953948998		280202	ASENTAMIENTO HUMANO 18 DE MAYO				LL	2		averiguar a cofopri  cofopri visito 21-12-99  partida P08016892	1	1	2020-09-30 20:53:27
158	101	1042	1-00000158	IASD	MPS	MI PERU	998899198		140108	PP.JJ MI PERU 	ZONA A			K	4		ACTULIZAR LOS PASGOS DE AUTOAVALUO ALA FECHA EL PREDIO ESRA DEBIDAMENETE INSCRITO EN REGISTROS  Casimiro Rodriguez cut. correo crekasi@gmail.com  957986098 	1	1	2020-02-27 11:32:10
160	101	1042	1-00000160	IASD	MPS	SALAVERRY	958312426		140123		1er de mayo - Pasaje Cerro Juli			B	11		el predio esta a nombre de Drae  ver recibo de Agua no tienes ruc esta a nombre C:A:IGLESIA ADVENTISTA 	1	1	2020-10-15 10:59:53
162	101	1022	1-00000162	IASD	MPS	JERUSALEN	958952230 958599394		140102		CALLE JERUSALEN 	600					ACTUALIZAR LOS PAGOSDE AUTOAVALUO VERIFICAR TAMBIEN LOS LINDEROS CORRESPONDIENTES, Y VER CUAL ES EL AREA ACTUAL.	1	1	2020-12-01 12:25:09
168	101	1008	1-00000168	IASD	MPS	HUNTER colegio			140107	COOP URB.EL CARMEN	CALLE JERUSALEN  	202						1	1	2020-12-01 12:30:08
169	101	1008	1-00000169	IASD	MPS	AGUSTO FREYRE- MARANATHA	958684838		140123	CC. PAMPAS VIEJAS PARCELA 		1163			2		LA ESCRITURA PUBLICA de compra venta  N° 655-2003 presenta dos lotes 	1	1	2020-10-29 15:06:58
170	101	1008	1-00000170	IASD	MPS	AUGUSTO FREYRE- MARANATHA	978818383		140123	CC. PAMPAS VIEJAS PARCELA		1163			3			1	1	2020-10-29 15:07:09
172	101	1008	1-00000172	IASD	MPS	VALPARAISO	980761267		140107	ZONA A	CALLE VALAPARAISO	305		26	14		Juan carlos Vargas Gonzales 982982908 claro  959207226	1	1	2020-12-02 19:05:49
174	102	1054	1-00000174	IASD	MPS	La Joya	973622880		140109	ASENTAMIENTO HUMANO ,URB. POPULAR DE INTERESES  SOCIAL VILLA  LA JOYA 	SECTOR 1 			K1	2			1	1	2020-11-13 19:11:46
175	102	1054	1-00000175	IASD	MPS	Cerrito La Joya	984841619		140109	URBANIZACION VISTA ALEGRE					7		ACTUALIZAR LOS PAGOS DE AUTOAVALUO   FALTA INSCRIBIR EL PREDIO EN REGSITROS	1	1	2019-09-09 18:14:46
179	102	1060	1-00000179	IASD	MPS	PIONERO	958509918 959460354		140514	AUTODEMA	CENTRO POBLADO EL PIONERO DISTRITO DE LLUTA ELPIONERO			F	2		ACTUALIZAR LOS PAGOS DE LOS ARBITRIOS Y AUTOAVALUO  958509918  	1	1	2020-10-15 17:24:00
181	102	1060	1-00000181	IASD	MPS	B1 Majes	950784056 959404068		140514	AUTODEMA             Municipio Central	CENTRO DE SERVICIOS B1			H	3			1	1	2020-03-15 20:18:40
182	102	1054	1-00000182	IASD	MPS	 SAN ISIDRO	966707933 926086414		140109	El Paraiso del Campesino  San Isidro  Centro Poblado- La Joya	-			M	2			1	1	2020-03-20 17:10:24
183	102	1054	1-00000183	IASD	MPS	VITOR	959393619 949672648		140126	SECTOR BARRIO NUEVO VITOR Zona B 	asentamiento Poblacional Barrio nuevo			E	1		E PREDIO NO CUENTA CON NINGUN TIPO DE DOCUMENTACION EN ARCHIVOS	1	1	2019-09-09 18:14:09
156	102	1034	1-00000156	IASD	MPS	Alto chiribaya	954013191- 979427425		280202	SECTOR PROMUVI  VII PAMAP INALAMBRICA				83	1		sacra  servicios basicos  celular 959585007 jaime	1	2	2021-03-20 17:59:13.184659
152	101	1009	1-00000152	IASD	MPS	Arenal	932741740		280202	URB. ALTO ILO ZONA ARENAL				H	14		Pillco Ayma Joselyn Paola-#990528983-dulce_magicoamor@hotmail.com-47907094      982515307 990528983	1	2	2021-03-20 18:18:18.757538
150	101	1009	1-00000150	IASD	MPS	GLOBAL	959304687-998794587		280202	CALLES DOS DE MAYO MIRAVE E ILO	Jiron dos de mayo 652	305						1	2	2021-03-20 18:19:19.633485
165	102	1008	1-00000165	IASD	MPS	13 DE MAYO	927338082 951019306-		140107	Asentamientos Humanos Trce de Mayo P.J.13 DE MAYO				H	5		falta pago de Arbitrios y autovaluo	1	2	2021-04-13 15:33:13.761465
151	101	1009	1-00000151	IASD	MPS	Miramar	953661900 silvia		280202	SECTOR BAJA PUEBLO JOVEN MIRAMAR	Asentamiento humano urbanizacion popular de interes social miramar Parte Baja			L	4		-rosmery160@hotmail.com .04646614-.053482425-953644486-brilibra@hotail.com	1	2	2021-03-20 18:20:36.012138
163	102	1008	1-00000163	IASD	MPS	NUEVA ESPERANZA	927434792		140123	C.P ASOC. DE VIVIENDA LA MANSION DE SOCABAYA	Mansion 1			M	11		992380416  992380416  952827055    Dueño el Hno Choquehuanca Puma Fabian  celular 922578482	1	2	2021-11-30 07:15:54.292401
180	102	1060	1-00000180	IASD	MPS	C2	999214527		140514	HABILITACION URBANA CENTRO DE SERVICIOS BASICOS ASENTAMIENTO C2	SECCION C			M	17		ACTUALIZAR LOS PAGOS DE LOS ARBITRIOS Y AUTOA 999214527	1	2	2022-02-17 17:29:40.835998
177	101	1060	1-00000177	IASD	MPS	GLOBAL	959648488 958530771		140514	HABILITACION URBANA AREA NORTE AV.DIAGONAL	CENTRO POBLADO EL PEDREGAL  ZONZ II			D	3		959648488	1	2	2022-03-28 19:42:54.250444
173	101	1054	1-00000173	IASD	MPS	Cruce La Joya	992257892 921343339		140109	AA.HH.el triunfo PUEBLO JOVEN SECTOR 1  ZONA C				S	1			1	2	2022-04-26 14:59:13.764749
184	102	1012	1-00000184	IASD	MPS	TAMBILLO	974586973		140119	ASENTAMIENTO HUMANO LOS GEREANIOS	SAN JUAN DE SIGUAS			C	19		950131183  993510417	1	2	2022-04-29 00:19:43.083517
178	102	1012	1-00000178	IASD	MPS	LA COLINA	985016599		140514	CENTRO POBLADO MENOR SANTA MARIA de servicios Basicos  LA COLINA	la  parte alta			K1	20		EN ARCHIVOS SOLO SE ENCUENTRA UN DOCUMENTO DE ADJUDICACIO QUE NO ESTA ANOMBRE DE LA IGLESIA	1	2	2022-05-02 10:27:38.521999
185	101	1012	1-00000185	IASD	MPS	IGLES.CENTRAL de Majes con colegio	966077776		140514	Ubicado en el Pedregal Distrito de Lluta,				A,10	48		acumular solo tiene escritura no esta en registrso	1	1	2020-02-27 11:45:08
186	102	1019	1-00000186	IASD	MPS	Santa Maria ( Alborada)	972280606-918316012		140113	AA.HH. SANTA MARIA 				G	11		ACTUALIZAR LOS PASO DE ARBIRIOS Y AUTOAVALUO   p06082844   910658473 959660874	1	1	2020-03-20 18:07:18
188	101	1019	1-00000188	IASD	MPS	CALIFORNIA	940227982-		140113	PP.JJ CALIFORNIA Zona A calle 2	Av. San Martin 100-B Urbanizacion California 	2025		C	1-B		959897763 952715427	1	1	2020-10-17 11:01:41
189	102	1019	1-00000189	IASD	MPS	LOS PORTALES - CHIGUATA	958998235-958998235		140106	CENTRO POBLADO LOS PORTALES  DE CHIGUATA 	SECCION A  ZONA A 			P	23		falta inscripción al Municipio 933396415 931122032	1	1	2020-10-08 17:14:29
192	101	1015	1-00000192	IASD	MPS	LA PUNTA Bombon	942969365 937620592		140706	La Punta de Bombon CENTRO POBLAADO	 CENTRO POBLADO MZ V1 , L6 -CALLE SAN ISIDRO			v1	10			1	1	2020-10-15 16:13:17
193	101	1015	1-00000193	IASD	MPS	COCACHACRA	982937889 957941099		140701	CALLE LIBERTAD		S/N						1	1	2020-09-09 22:52:01
194	101	1015	1-00000194	IASD	MPS	MATARANI	959859789		140703	Centro ¨Poblado 1er de Mayo 	Calle Primero de Mayo S/N- zona B			T	10			1	1	2020-09-25 13:52:30
195	104	1015	1-00000195	IASD	MPS	CASA PASTORAL			140705	URB MARISCAAL CASTILLA 	CALLE AURELIO DE LA FUENTE	217		2	4			1	1	2019-03-24 21:17:25
196	101	1019	1-00000196	IASD	MPS	VICTORIA	958939396 959615878		140113	ASENTAMIENTO HUMANO NICARAGUA	dpto.secc.2 edif.piso 0-2			E	5		930865898 959329723 	1	1	2020-09-23 23:25:44
197	101	1019	1-00000197	IASD	MPS	CIUDAD BLANCA	969382393-974974877		140113	COMITE VILLA N°3 CUIDAD BLANCA 	ZONA B			C-7	4		958531428 958236824	1	1	2019-06-07 03:43:48
198	101	1019	1-00000198	IASD	MPS	MIGUEL GRAU	958985025-947055677		140113	PP.JJ. MIGUEL GRAU Zona B	El Sol			27	5		hay que armar expediente para sustentar a cofopri para Titulacion esta echo un enredo pero si se puede  959602000 958985025	1	1	2020-06-11 17:52:03
199	101	1014	1-00000199	IASD	MPS	MIRAFLORES central	959401050 959315466		140111	Pueblo Tradicional Miraflores	av Mariscal Castilla	601		I	16			1	2	2021-01-14 17:40:21.641198
223	101	1021	1-00000223	IASD	MPS	VILLA EL TRIUNFO 	969737815		140118	AA.HH. VILLA EL TRIUNFO	ZONA A SACHACA			Ñ	6			1	1	2020-02-13 11:18:24
224	102	1021	1-00000224	IASD	MPS	JOSE MARIA ARGUEDAS			140118	ASENTAMIENTO HUMANO ASOC. JOSE MARIA ARGUEDAS	ZONA A MZ C, L4			C	4			1	1	2020-10-20 08:58:42
225	102	1021	1-00000225	IASD	MPS	PEDRO VILCA APAZA	931134813		140118	AA.HH. PEDRO VILCA APAZA 	ZONA B 			B	3		ACTUALIZAR LOS PAGOS DE AUTOA   hno pedro vilcapaza  951917087	1	1	2020-10-20 08:59:31
226	102	1021	1-00000226	IASD	MPS	CORAZON DE JESUS	988665044 945031019		140118	PUEBLO JOVEN CORAZON DE JESUS 	COMITE 02			K	3		son 2 lotes   el lote K-3 esta como lote sin dueño en cofopri P06090390  el lote K-4 esta como lote a nombre de la Ilgesia Adventista P06090390  Acumular 	1	1	2020-10-19 18:32:41
230	101	1020	1-00000230	IASD	MPS	HORACIO ZEBALLOS	951110674-		140123	AA. URBANO MUNICIPAL HORACIO ZEBALLOS	Av.9 de Diciembre			19	3		se gano el terreno por prescripcion ad. a nombre de IASD 	1	1	2020-10-20 09:06:59
232	102	1020	1-00000232	IASD	MPS	PEREGRINOS	973528665 958375852		140116	ASOC. VIVIENDA LOS PEREGRINOS  DE CHAPI	Acero Industriales Quequeña quebrada Onda			G	7		hay otro  terreno aparte de este  era 1000 metros ahora queda 600 metro para Iglesias    juan caceres anciano de peregrimos  957811682	1	1	2019-05-18 00:39:45
233	102	1020	1-00000233	IASD	MPS	BETHEL	996978118 966693336		140123	PUEBLO TRADICIONAL  EL PUEBLO DE SOCABAYA	calle Miguel Grau MZ D , L6			D	6A		EXISTE UN N° DE PARTIDA P06093818EN DONDE SE INDICA UN AREA DE 433.150 M2 SINN EMBARGO LA IGLESIA SOLO ES DUEÑA DE 407 M2  PRA SANEAR EL TERRENO HAY QUE LEVANTAR UN NUEVO PLANO CON LAS ACTUALES MEDIDAS Y COLINDANCIAS  PARA QUE ESTE PUEDA SER INNSCRITA EN REGISTROS PUBLICOS 	1	1	2020-12-04 14:18:23
234	101	1016	1-00000234	IASD	MPS	SAN FRANCISCO	995936635		280303	Municipalidad Centro Poblado San Francisco	SECTOR COMITE 21			ALFA	2		dicen que paso al muniicpio central 	1	1	2020-09-25 18:37:51
235	102	1017	1-00000235	IASD	MPS	BELLA VISTA	Rufino-953749517		280303	Distrito san Cristobal calacoa comunidad bellavista	esquina entre las calles san martin  y junin 						FALATA ACTUAILZAR LOS PAGOS DE AUTOAVALUO  FALTA REGISTRAR EN SUNARP   SE TIEN TESTIMONIODE LA DONACION 	1	1	2020-10-16 07:02:51
187	102	1019	1-00000187	IASD	MPS	ISRAEL	-958791936		140113	PP.JJ ISRAEL ZONA B				V	8		958791936 983029661	1	2	2021-06-09 18:41:43.482808
239	101	1040	1-00000239	IASD	MPS	VILLA EL SALVADOR	952659331 susana		330308	JUNTA DE COMPARDORES VILLA EL SALVADOR				B	4		Susan-952659331 susi_nadi1@hotmail.com Youshel Viviana 952918981-yusi16@hotmail.com    FALTA PAGAR autoavaluo   el predio solo cuenta con un contrato de traspaso   y no tien colindancias	1	2	2022-04-13 17:24:10.706953
222	101	1021	1-00000222	IASD	MPS	TIABAYA	939624727		140124	URB. SAN ISISDRO DE TIABAYA				C	7-8			1	2	2022-01-11 18:37:41.017706
221	101	1021	1-00000221	IASD	MPS	SAN JOSE DE TIABAYA	929880681		140124	AA.HH SAN JOSE DE TIABAYA	ZONA A			I	5			1	2	2022-01-11 18:38:23.52133
191	101	1015	1-00000191	IASD	MPS	EL ARENAL	938725086 958050188		140705	CENTRO POBLADO EL ARENAL DEAN VALDIVIA	ZONA C			K	3			1	2	2022-07-24 14:26:17.574518
238	101	1040	1-00000238	IASD	MPS	POCOLLAY PEAÑAS	943218480		330308	Asoc. junta de compradores Peañas	los sapiros			E	3		el recibo de agua esta a nombre de Aguilar Flores Manuela  codigo contrato 21268    EN ARCHIVOS NOSE HA ENCONTRADO NINGUN DOCUMENTO	1	2	2022-04-13 17:20:38.745093
237	101	1040	1-00000237	IASD	MPS	pocollay central central	952944201		330308	VALLE DE TACNA SECTOR  POCOLLAY	Pago Chorrillos- Prolongacion Hnos. reynoso 15	1008					Jorge-#952944201-jojumaqui@gmail.com Cynthia 964321200 / 97001269-richar_bh_@hotmai	1	2	2022-04-13 17:21:59.803579
218	102	1013	1-00000218	IASD	MPS	PEREGRINOS	mps		330310	Fundo Ubic.En la Av Litoral A la Playa	KM.2      ( referncia Antes de Magollo)			A	4		fanny rodriguez 952999132 fanny605_@hotmail.com	1	2	2022-04-15 10:00:48.401838
240	102	1040	1-00000240	IASD	MPS	NUEVO SANTA RITA	958274869 Nancy		330308	Asent. Humano Asoc.de Vivienda .Nueva Santa Rita	Comite 5			D	10		Sofia Causa Mamani-952906052 931383810 danielsanchez@teologia.edu.pe	1	2	2022-04-18 23:45:13.445842
248	101	1020	1-00000248	IASD	MPS	SAN MARTIN DE SOCABAYA	958230020 944636020		140123	ZONA C AMPLIACION ASOC. URBANIZADORA SAN MARTIN	Calle Paita			H	16		FALTA ACTUALIZAR LOS PAGOS DE AUTOAVALUO   	1	1	2019-04-24 05:35:47
250	101	1020	1-00000250	IASD	MPS	CORAZON DE JESUS	958383472 958089824		140123	BALNEARIO ASOC.  CORAZON DE JESUS				I	9		FALTA  ACTUALIZAR LOS PAGOS DE AUTOAVALUO   958089824   054431820   YA SE CAMBIO A DE DENOMNACION A IASD    	1	1	2020-12-01 12:24:18
254	101	1059	1-00000254	IASD	MPS	 LAS FLORES FE Y ESPERANZA	 953250993 984407432		140104	ASENTAMINETO POBLACIONAL ASOC PROVIVIENDA LAS FLORES	ZONA 1			A	6		984407432	1	1	2020-11-18 18:25:38
255	104	1023	1-00000255	IASD	MPS	Casa pastoral			140104	PUEBLO TRADICONAL ZAMACOLA	Inambari  204 (147-206)	204		W	30			1	1	2020-10-14 22:28:47
256	101	1005	1-00000256	IASD	MPS	SION CUIDAD	952646359 Marco		330303	ASENTAMIENTO HUMANO MARGINAL AMPLIACION CUIDAD NUEVA 				121	7		Ccalani Quispe Maria Elena-952512947  	1	1	2020-11-03 21:34:19
258	101	1005	1-00000258	IASD	MPS	BETANIA	Maria 952805733		330303	AA.HH. AMPLIACION CUIDAD NUEVA				41	1		Maria-kayalcole@gmail.com-maria.solis-Poco Miranda Maria Auror  	1	1	2020-11-03 21:13:24
190	101	1015	1-00000190	IASD	MPS	MOLLENDO	959463525 958998532		140703	CALLE	CALLE IQUITOS	901		E1	9			1	2	2024-03-28 08:19:16.837164
259	101	1005	1-00000259	IASD	MPS	EBEN EZER	antonio 971004977		330303	AA.HH. AMPLIACION CUIDAD NUEVA				37	30		Machaca Alanoca Valentina-kayalcole@gmail.com-machaca.alanoca  	1	1	2020-11-03 21:15:59
260	101	1005	1-00000260	IASD	MPS	GETSEMANI	 Rodigo-952989020		330303	AA.HH. AMPLIACION CUIDAD NUEVA				145	2		Luis -lrodrigo.tc@gmail.com-luis.turpo,Aquino Escobar Angel Daniel-948432138-dany-tlv-15@hotmail.com  	1	1	2020-11-03 21:24:00
261	101	1005	1-00000261	IASD	MPS	MARANATHA			330303	AA.HH. MARGINAL CUIDAD NUEVA				61	27		 Leidy elizabeth-sheccid__989@hotmail.com-leidy.laqui-Guevara Cotrado Leroy.052312245-idesign@hotmail.com  	1	1	2020-11-11 11:04:50
267	101	1030	1-00000267	IASD	MPS	NUEVA JERUSALEN	969999796		330308	SECTOR 28 DE AGOSTO  PROMUVI ZONA cono  norte	Avenida proyectada E			40	1		Edgar-952264300 atlantic.tacna@hotmail.com  Edgar-952264300	1	1	2020-11-27 13:44:13
269	101	1030	1-00000269	IASD	MPS	NUEVA JERUSALEN			330308	SECTOR PROMUVI	av  proyectada E			40	2			1	1	2020-11-20 15:00:24
273	102	1059	1-00000273	IASD	MPS	VILLA EL SALVADOR	933866438 924953226 		140104	ASOC. DE VIVIENDA DE INTERES SOCIAL  VILLA CERRILLOS 	alberto Fujimori ZONA B 			J	4		EL PREDIO NO CUENTA CON DOCUMENTACION A NOMBRE DE LA IGLESIA    EXISTE UN CERTIFICADO DE POSESION A NOMBRE DEL SR VICENTE  NOHAY INFORMACION ACRECA DE AREA Y LIND  	1	1	2019-08-31 14:47:17
274	102	1011	1-00000274	IASD	MPS	CHUCATAMANI			330103	SECTOR SAUSINE							FALTA INFORMACION DEL AREA   FALTA INSCRIBIR EL PREDIO  FALTA ACTUALIZAR PAGOS DE AUTOAVALUO	1	1	2020-12-03 21:56:47
275	102	1033	1-00000275	IASD	MPS	SANTA CRUZ			330103	CENTRO POBLADO SANTA CRUZ	CALLE YUCAMANI			P	5		SOLO SE TIEN CERTIFICADO DE POSECION QUE NO ESTA ANOMBRE DE LA IGLESIA   FALTA DOCUMENTO DE TRASPASO A NOMBRE DE LA OIIGLESIA	1	1	2019-02-03 13:51:44
276	102	1033	1-00000276	IASD	MPS	PALLATA			330106	ANEXO PALLATA	centro piblado pallata			E	1		FALTA PAGOS DE AUTOAVALUO  FALTA INSCRIBIREL PREDIO ANOMBRE DE LA IGLESIA 	1	1	2020-12-01 16:35:39
279	101	1011	1-00000279	IASD	MPS	TARATA CENTRAL	952355967		330406	SACHAJAÑA	Campiña de Tarata Seccion Lupaja Av. Tacna						FALTA PAGOS autovaluo    Hermanos de Iglesia Lideres Floidy Yufra Rpc 983308680   floidy@hotmail.com  	1	1	2020-12-01 16:50:58
252	102	1059	1-00000252	IASD	MPS	Bedoya	973827240-975171060		140104	Asociacion Vivienda talleres Herman Bedoya Forga II				K	22		falta que lo titulen	1	2	2021-04-27 08:22:52.891329
249	101	1042	1-00000249	IASD	MPS	pedro Diaz Canseco	977317064 yaneth		140108	URB. GENERAL PEDRO RUIZ DIEZ CANSECO PROGRAMA FONDOS TESOROS PUBLICOS				P	12			1	2	2021-04-23 09:57:49.128513
272	102	1048	1-00000272	IASD	MPS	Ampliacion Pachacutec	959455460-967070789		140104	CENTRO POBLADO SEMI RURAL PACHACUTEC Grupo Zonal 16 y 17 y 18	2 ZONA E MZ 25, L 2			25	2			1	2	2021-04-27 08:15:50.705381
227	102	1021	1-00000227	IASD	MPS	7 DE JUNIO	983778405		140118	PP.JJ. 7 DE JUNIO				R	11		902317251 llamar a hno que sabe de autoridad	1	2	2021-05-08 19:42:38.148762
280	102	1001	1-00000280	IASD	MPS	CALLAO CRISOLtodos para cristo	996656752		330310	URB. SAN ROQUE				P	23,24			1	2	2022-04-13 17:36:54.951232
281	101	1001	1-00000281	IASD	MPS	NUEVA ESPERANZA	990007334 hernan		330310	Central de Coop.Las Vilcas Ltda. Cecoavi	MZ 47, LOTE 10-TACNA			47	10		Hernan Justo Huanacune  998462748-hernan.hy@hotmai  #975491003ruperto	1	2	2022-04-13 17:43:33.470475
270	101	1001	1-00000270	IASD	MPS	REMANENTE	929673461 952915121		330310	ASOC. DE VIVIENDA PARAGRANDE				6	5-A		Henry Alfredo Calderon-#999905582-henry_620@hotmail.com    calderon Henry #999905582  998716317   952812883 96466603	1	2	2022-04-13 17:44:40.968768
257	102	1005	1-00000257	IASD	MPS	GEDEONES	958884088 Froilan		330303	AA.HH. AMPLIACION CUIDAD NUEVA				152	17 A		Ticona Froilan.052310805-kayalcole@gmail.com froilan.ticona Ticona Flores Luz Giamna	1	2	2022-04-13 18:14:23.363067
265	101	1030	1-00000265	IASD	MPS	MONTE HOREB	951128127 lucia		330303	Asentamientos Humanos Proyecto Norte  Etapa II	Asociacion de vivienda 28 de agosto			378	17		Lucia-952283007/ 984812990-benito2528@hotmail-Plio-952962315-Jessica Mendoza  #952831992	1	2	2022-04-13 17:57:20.441238
268	101	1030	1-00000268	IASD	MPS	NUEVA JERUSALEN	969999796 edgar		330308	SECTOR PROMUVI Cono Norte	calle 38			40	15			1	2	2022-04-13 17:58:20.521881
263	101	1030	1-00000263	IASD	MPS	NUEVA REDENCION	989078242 angel		330303	AAHH PROYECTO NORTE I ETAPA	Asoc. Villa el Triunfo			324	15		910211247-990130750	1	2	2022-04-13 17:59:31.242078
266	101	1030	1-00000266	IASD	MPS	ENMANUEL NEISER	921959414 julio		330303	ASOC. NEICER LLACSA ARCE .AA.HH PROYECTO NORTE	SECTOR 2			B	5		geovana_adela@hotmail.com- Ruth 952606390    FALTA PAGOS DE AUTOAVALUO 952623223 Llaca  VER CON EL NUMERO DE PARTIDA SI SE PROCEDIO CON LA INSCRIPCION DEL PREDIO A NOMBRE DE LA IGLESIA-Delia 955660545	1	2	2022-04-13 18:11:00.376427
284	101	1031	1-00000284	IASD	MPS	Alfonso Ugarte 	966807990		330304	Conjunto HabitacionalAlfonso Ugarte III etapa				M4	20		falta Autovaluo 952507911 Maquera  	1	1	2020-11-18 20:48:02
285	101	1031	1-00000285	IASD	MPS	Los Heraldo	976544156 952809273		330304	Programa de Vivienda Cono Sur II Las Americas 				Q	4		952543770	1	1	2020-12-08 10:43:15
286	101	1043	1-00000286	IASD	MPS	Chivay			140505		Garcilazo de la Vega 	808					celular Hipolita 971797113	1	1	2020-10-13 18:23:01
287	101	1043	1-00000287	IASD	MPS	Lari	978626836Mateo Lopez		140510	Canto Pampa Lari	Ucayali							1	1	2018-12-15 09:09:29
288	101	1028	1-00000288	IASD	MPS	Pusa Pusa	939304496 945181816 		140504	Pio Huito  Pusa pusa	av 28 de Julio Barrio Huyllas 							1	1	2019-06-17 17:54:42
289	102	1028	1-00000289	IASD	MPS	Checotaña	942649747		140603	distrito de chachas	Centro poblado Checotañia							1	1	2019-03-30 15:00:11
291	101	1043	1-00000291	IASD	MPS	Valle del Colca 2			140505	centro poblado vhivay	sector B hanansaya			N	7		acumular	1	1	2020-11-13 20:33:32
293	101	1043	1-00000293	IASD	MPS	Ichupampa	920310211		140509		calle ugarte S/N Ichupampa			M	1		falta documenot	1	1	2020-11-05 14:26:35
295	102	1043	1-00000295	IASD	MPS	Sacsayhuaman	958852092 marcial		140505	Sacsayhuaman	Pueblo Joven Sol de Sacsayhuaman Zona B			H	1B			1	1	2019-09-23 11:43:37
296	102	1043	1-00000296	IASD	MPS	Tuti			140505	Provincia de caylloma centro pobladoi tuti	Calle de Cusco Distrito de Tuti			A	2		encargado Hno Concepcion Mamani   celular 946696578 hay que hacer tranferencia de Propietario    esta en cofopri con nombre Jesus Quispe CCapira falta dividir	1	1	2020-09-25 13:48:40
298	102	1043	1-00000298	IASD	MPS	Yanque	944814447		140505	Urinsaya	Calle Lima  sub lote			F1	5A		ACCUONES Y DERECHOS  FALTA DESMEBRAR  wwillart_248@hotmail.com	1	1	2020-09-23 15:04:47
277	102	1010	1-00000277	IASD	MPS	QUILLAHUANI	Julián-957742163	952943928-979970585	330106	ANEXO ARICOTA	-	-	-	-	-		la hna es juez de paz  Cahuana Laura Darlene DNI 42761245  año 2021	1	2	2023-09-03 18:40:30.61341
294	102	1043	1-00000294	IASD	MPS	Cabanaconde	958288721 97350943		140505	Cabanaconde	San Juan Ccoto						958062492 mario caceres            958288721  #944469262  Urgente sanear me envio carta para coordinar con dueño del predio de 90 años numero telefono 054 760653 o al 958062492 mario caceres	1	2	2023-11-03 19:55:01.616684
300	101	1012	1-00000300	IASD	MPS	IGLES.CENTRAL de Majes con colegio			140514	Habilitacion Urb.c.publ.de serv.Bas.el Pedregal 				A10	49		p06140025 falta	1	1	2020-10-15 16:32:25
301	102	1009	1-00000301	IASD	MPS	ITE			330202	Asentamiento Humanos las vilcas	calle 5			D	13			1	1	2020-09-30 15:22:13
302	104	1038	1-00000302	IASD	MPS	Oficinas Viv. Administracion MPS			140102	centro poblado Zona B	Alameda Dos De Mayo 110 Tingo 			H	11			1	1	2020-10-19 18:11:32
304	102	1003	1-00000304	IASD	MPS	Ocoña	991857406		140206	 carretera Panamericana Sur 				3	3-B			1	1	2020-10-15 13:34:59
308	102	1026	1-00000308	IASD	MPS	Pampamarca	915037520		140412	Centro Poblado Pampamarca provincia la Union							se cambio de terreno  no tiene documentos	1	1	2020-10-13 22:59:28
309	101	1018	1-00000309	IASD	MPS	parra	956331344		140102	Fundo Urbano Boulevard Parra 	av Parra 100 Con Av salaverry 214  cercado	100						1	1	2020-10-19 18:07:08
311	102	1003	1-00000311	IASD	MPS	PampaSarrea Terreno no ocupado			140208	Distrito Samuel Pastor ,la Pampa				A	3			1	1	2018-12-15 07:03:28
314	102	1027	1-00000314	IASD	MPS	Agua salada TERRENO SI OCUPAR			140307								no tiene documentos	1	1	2019-06-23 04:50:42
315	102	1027	1-00000315	IASD	MPS	la Aguadita 	953492914		140307		a.h imperial aguadita			16	8		falta Documentos 	1	1	2020-10-01 19:53:27
317	101	1008	1-00000317	IASD	MPS	-ADRA			140107	Chilpinilla	Calle Piura 203-205 ZONA CHIMPINILLA							1	1	2020-10-29 19:02:51
318	101	1019	1-00000318	IASD	MPS	chiguata	958536153-958536153		140106		calle 14 de octubre						989590040	1	1	2020-10-08 17:13:45
319	101	1047	1-00000319	IASD	MPS	Alto Tacna	922523462		330301	Asoc. Jorge Basadrdre 	Ubic rur sector Cerro Intiorko jorge Basadre C.p/Parc. A 02 Area Ha 011000 			A	2		985882021-9725124  no tienes docuemntos Genoveva-985882021  EN archivo no hay escritura publica Y/O tipo de documento alguno del predio	1	1	2020-11-09 15:35:03
320	102	1047	1-00000320	IASD	MPS	Alto Bellavista	95262007-921205419		330301	Asoc. Alto Bellavista	sector 8	520		F	4		Juan Coaquira-952002234 Manual Edith Calizaya-946723619    falta cambio de agua y luz952616458-  En archivo falta  ESCRITURA PUBLICA       	1	1	2020-11-05 09:32:10
323	102	1026	1-00000323	IASD	MPS	Cerro Rico	979060116  958639113		140402								falta documentos	1	1	2019-06-13 16:36:27
324	102	1028	1-00000324	IASD	MPS	Huancarama	981743877		140409								falta docuemntos 974033368	1	1	2019-03-30 15:07:50
325	102	1026	1-00000325	IASD	MPS	Oyolo Aplao			140402	Oyolo Paucar del Sara Sara  -Aplo Condesuyos							falta docuemntos	1	1	2018-12-15 06:41:04
306	102	1054	1-00000306	IASD	MPS	Santa Rita	959846935-973582873		140122	Santa Rita de Siguas Zona A	Asoc.Vivienda Talleres Nueva Juventud			A	16		tiene contrato de transferencia de acciones y derechos	1	2	2021-03-16 16:30:13.253676
283	101	1001	1-00000283	IASD	MPS	NAZARETH	952258840 yhoana		330310	ASOC DE VIVIENDA BELLA VISTA				D	7		Johana Chata Chata-952982334-j_a_n_aa@hotmail  Johana Chata 952978894   #952204817 948175929	1	2	2022-04-13 17:41:49.461668
303	101	1006	1-00000303	IASD	MPS	Colegio  El Faro oficinas	Ruth-949567952		330301	Asoc. Pobl.San Juan de Dios	Juan Butron	108		G	3			1	2	2021-09-20 13:53:33.675545
282	101	1001	1-00000282	IASD	MPS	NUEVO EDEN	916649853 -		330310	AA.HH. PUEBLO LIBRE				11	9		Herminia Vargas-945392239-herminia1b2@gmail.com-Atemio Ruth -952626781  # 952528476	1	2	2022-04-13 17:49:29.671979
331	102	1003	1-00000331	IASD	MPS	La Curva 	959088394 990242548 		140204		Ampliacion San Francisco 			F	3-4			1	1	2019-06-05 03:27:57
332	102	1003	1-00000332	IASD	MPS	Misky	996780870		140201	Mariano Nicolas Valcarcel-	Calle Misky						falta docuemntos	1	1	2019-06-05 03:31:11
334	101	1003	1-00000334	IASD	MPS	Villa Linares terreno sin ocupar	999960298 raul		140208		(Lote 06-Mz.) F (Lote 07 Mz. F) (Lote 17- Mz. F) (lote 18 Mz,F)						falta documentos  vendedor de este predio señor uyen rpc 948326793	1	1	2020-07-11 18:24:31
336	102	1028	1-00000336	IASD	MPS	Pampa Achaco	978135820		140603	Pampa Achaco							falta docuemntos 996603263	1	1	2019-03-30 15:02:53
340	102	1027	1-00000340	IASD	MPS	Caraveli			140306		Jose Pedro Tordoya			F	11		falta docuemntos	1	1	2018-12-15 08:57:33
342	102	1027	1-00000342	IASD	MPS	Huanca	998570579		140307	Dpartamento de Ayacucho Pro. Lucanas Distrito Santa Lucia	Centro poblado Huanca 			M	34			1	1	2019-06-23 04:54:20
343	101	1027	1-00000343	IASD	MPS	Mollehuaca	992282933-Martin		140309	calle 3	Centro poblado Nuevo Mollehuaca 			9	7-8-9		ya tiene titulo A nombre de Martin Montañez -Fuentes Montes  son 2 titulos que ya estan en cofopri p06244057-p06244058-p06244059	1	1	2020-09-25 09:29:34
344	102	1027	1-00000344	IASD	MPS	Puerto Lomas			140307		Pasaje 3  Nro 153   sector 2	153					falta docuemntos	1	1	2018-12-15 09:02:50
345	102	1027	1-00000345	IASD	MPS	Relave			140307	Centro poblado 2da calle	centro poblado 2da calle						falta documento	1	1	2019-06-23 04:52:12
346	102	1027	1-00000346	IASD	MPS	Tierra Blancas			140307	Quicacha-Tierra Blanca- Q	3er Calle 							1	1	2019-06-23 04:52:19
347	102	1043	1-00000347	IASD	MPS	Achoma			140501	Centro Poblado Achoma								1	1	2018-12-15 09:06:57
349	101	1005	1-00000349	IASD	MPS	Fuerte pregon	Edinson-952382099		330303	Ciudad Nueva	comite 10			48	19		Fernandez Arce Edinson-edfagarr@hotmail.com edinson.fernandez    Falta docuemntos	1	1	2020-12-01 16:05:17
353	101	1024	1-00000353	IASD	MPS	 Bustamante	997798850		140104	Asoc. Urbanizadora Jose Luis Bustamante y Rivero 	Super Manzana 02			C	13			1	1	2019-10-20 18:54:59
354	101	1055	1-00000354	IASD	MPS	26 de Octubre	952881477		330310	Centro poblado menor Los palos	Asoc. 26 de Octubre			1	5		942967119	1	1	2020-12-01 16:19:15
355	101	1032	1-00000355	IASD	MPS	Caplina	930795021		330304	Urb Habilitacion urbana Asociacion de vivienda	Villa Caplina 2da Etapa 			B	30		952681820 Francisco 	1	1	2020-11-24 19:18:40
356	102	1032	1-00000356	IASD	MPS	Emanuel	951727083		330304	Habilitacion Urbana Promuvi Viñani II	Asoc. 4 Suyos 			116	4		Fernando Davalos Ibañez -fdavalos197@hotmail.com  	1	1	2020-11-24 20:30:16
341	102	1027	1-00000341	IASD	MPS	Chala Sur			140307	av circunvalacion	Av. Industria			1"	13-14		falta docuemntos	1	2	2023-04-26 18:52:15.530397
310	102	1060	1-00000310	IASD	MPS	La Quebradita	950085725 957950941		140514	2	ciudad majes -Modulo C -sector 2			D-7	6		950085725	1	2	2022-10-21 19:50:13.618096
328	102	1055	1-00000328	IASD	MPS	Nueva Jerusalem	952077791		330310	Yarada Alta Ruta a la Playa Litoral copare KM. 13							victor calizaya  952077791-23	1	2	2023-10-08 16:12:35.270362
305	102	1054	1-00000305	IASD	MPS	Paraiso			140109	Asoc. de vivienda  El paraiso del Campesino San Isidro				"L"	"1"			1	2	2023-11-11 18:56:07.754111
326	101	1055	1-00000326	IASD	MPS	Asentamiento 4	9304472792		330310	Yarada Baja -asentamiento 4							Carlos mam930472792-23	1	2	2023-10-08 16:32:00.888406
357	102	1055	1-00000357	IASD	MPS	Las Palmeras	972430146		330310	Las Palmeras  (Distrito yarada Baja)	Barrio el pacifico			o	9		970883457-  952304968 958312448-952074588	1	1	2020-12-01 16:17:42
359	102	1032	1-00000359	IASD	MPS	Mensajeros de Esperanza	951141688		330304	Habilitacion Urbana Promuvi 	Viñani Viñani			244	2		969809993 976542115 	1	1	2020-12-08 08:25:19
363	101	1006	1-00000363	IASD	MPS	Castillo Fuerte			330301	Asociacion de Vivienda la Florida	calle los Lirios  	115		B	28			1	1	2020-02-22 07:29:02
364	101	1006	1-00000364	IASD	MPS	Emanuel Milagros			330301	Asoc. Urbanizadora Ramon Copaja 	Asoc. Ramon Copaja B-2 			B	2		Reymundo Coaquira-reymundo-30@hotmail.com- Rudy-953904719-josias_rudy@hotmail.com  #952894539  Reymundo	1	1	2020-05-11 13:25:03
370	102	1029	1-00000370	IASD	MPS	Alto Poquera	952620937-952289652		330305	 distrito de Sama Inclan	Asentamientos Humanos Alto Poquera			G	11-12		Hno encargado 952962852 Catacora  falta constancia de posesion	1	1	2020-12-01 16:57:59
335	102	1028	1-00000335	IASD	MPS	Cayarani	958145399		140602	Cayarani							faltadocuemntos	0	1	2019-03-30 15:01:27
351	101	1030	1-00000351	IASD	MPS	Ad Venir	980894456 mary		330303	Asentamiento Humano Marginal Ampliacion Ciudad Nueva				224	1		-nelson_parati616@hotmail.com Miguel- 949439782 956011928	1	2	2022-04-13 17:50:47.507442
362	102	1006	1-00000362	IASD	MPS	Balconcillo			330301	Asoc. Cristo Morado	Asoc. Cristo Morado			117	9		Fjorge Freyre asociado-jorge.freyre  	0	1	2018-12-15 10:17:24
361	102	1006	1-00000361	IASD	MPS	Alto Alianza Pesqueros	 Pathi-968561701		330301	Asoc. Virgen del Carmen 	Asoc. Virgen del Carmen			D	5		-julia.marca-Quispe Guevara Ruth Elizabeth-952505961	0	1	2020-02-22 07:31:42
371	102	1029	1-00000371	IASD	MPS	Viñani	940239075 #952009322	reyfabri2@gmail.com	330310		Calle Mariano Melgar	925					Melany-952343826-melanyprolife@gmail.com  	0	1	2018-12-15 10:30:15
333	102	1003	1-00000333	IASD	MPS	Secocha	974618184-983789366		140203	Secocha	calle los Angeles s/n secocha						falta docuemntos	1	2	2022-03-10 21:28:45.80865
378	102	1010	1-00000378	IASD	MPS	Chejaya	952213650 952213650		330201		Anexo Chejaya-Ilabaya - Jorge Basadre							1	1	2018-12-15 11:30:48
379	102	1010	1-00000379	IASD	MPS	Chulibaya	927580122 927580122		330201		Anexo Chulibaya 							1	1	2018-12-15 11:31:35
400	101	1015	1-00000400	IASD	MPS	Alto Inclan	957958624  54 533379		140705		Los Olivos 			U	10-11			1	1	2020-09-09 22:51:30
401	102	1015	1-00000401	IASD	MPS	Alto Inclan B	968613588		140705	Zona A Pueblo joven alto Inclan				D	4			1	1	2020-09-09 22:51:37
405	102	1015	1-00000405	IASD	MPS	La curva	969815535 958878464		140702	Dean Valdivia	Upis Guardiola			S"	1			1	1	2020-09-22 18:04:31
408	101	1056	1-00000408	IASD	MPS	Bello Horizonte	998795208-978118289		280303	 Centro Poblado San Antonio el Paraiso ITE 	Subsector pampas de San Francisco			C	22		solo tiene el acuerdo de junat de Ilgesia que transfieren los terrenos a la Iglesia	1	1	2020-06-09 19:03:05
413	101	1016	1-00000413	IASD	MPS	Sion 	953967916		280303	Urb. Santa Rosa 	av La Paz 	100 B		D	12B		Luis Alberto Chura.01889129  953967916#953967916  	1	1	2020-10-20 08:36:20
419	102	1017	1-00000419	IASD	MPS	Cuchumbaya			280303									1	1	2018-12-15 13:45:13
421	102	1017	1-00000421	IASD	MPS	Sacuaya	Delfin-973647154		280303								Delfin-973647154  	1	1	2019-03-21 04:40:05
422	102	1017	1-00000422	IASD	MPS	San Cristobal			280303	centro poblado menor san Cristobal 				s	1		Ortega Belito Lilian-lilian_ortega@hotmail.com  	1	1	2020-10-13 15:26:46
425	102	1017	1-00000425	IASD	MPS	Yacango	Cristina-953952867		280303									1	1	2018-12-15 13:51:47
377	102	1034	1-00000377	IASD	MPS	Vista Alegre	982727073-982727073		280202	del VII Programa Municipal de vivienda U.PI.S. Vista Alegre	Vista Alegre			74	24		982727073- 959585007	1	2	2021-03-20 18:13:58.084963
398	101	1014	1-00000398	IASD	MPS	Miraflores B	959869974		140111	Pueblo Joven Union Edificadores Misti Zona D	Av San Martin MZ L, SUB LOTE 21A-PUEBLO JOVEN UNION EDIFICADORES MISTI			L	21A		de los 57000dolares   28500 dio los hnos y la MPS 28500 para la compra	1	2	2021-04-27 16:22:23.477861
414	101	1056	1-00000414	IASD	MPS	Vista Alegre	975784623-975784623		280303	centro Poblado San Antonio N°	URB.California			M-7	6		Ramos Ramos Josefina-jovio412@hotmail.com.04431587	1	2	2021-05-21 09:47:33.226746
391	102	1012	1-00000390	IASD	MPS	C3 Majes			140514	AA.HH.C-3	AAHH.C3 Parcela 79- Majes							0	1	2020-10-15 14:31:27
409	101	1016	1-00000409	IASD	MPS	Continental	958649270-950185747		280303	Municipalidad de Centro Poblado San Francisco	pasaje San Valentin JJ. JJ. San Francisco			M"	1			1	2	2022-05-29 20:37:30.039062
389	102	1060	1-00000389	IASD	MPS	Bloque 5	955963345		140514	CENTRO POBLADO LA COLINA	Modulo D-Zona C			E	8			1	2	2022-09-24 08:17:43.769665
411	102	1056	1-00000411	IASD	MPS	Litoral	Pedro-956955200		280303		San Antonio Norte						-Pedro-4433833-956955200	0	1	2018-12-15 14:08:31
412	102	1056	1-00000412	IASD	MPS	Luz de Esperanza			280303		Luz de Esperanza							0	1	2018-12-15 14:09:11
375	102	1009	1-00000375	IASD	MPS	Kennedy	#968999390 Maria 		280202	Urba. Jhon F Kennedy 	Calle Apurimac 	H13					-flor_de_maria777@hotmail.com-00487109-Lucia Huayta 953937310    	0	1	2020-09-30 15:23:37
383	102	1010	1-00000383	IASD	MPS	Toquepala	996726001 961671844		330201	Asentamientos Minero Toquepala-   Moquegua Gral Sanchez C.								0	1	2018-12-15 11:36:22
352	101	1030	1-00000352	IASD	MPS	Heraldos de Sion	952811501 hilda		330303	Asentamiento Humano Proyecto Norte				306	22		anciano 2017-  996811501	1	2	2023-07-07 07:43:09.368453
368	101	1029	1-00000367	IASD	MPS	Buena Vista	921262883-935197994		330309	Sama Las Yaras	Anexos Buena  av. Adres avelino pamo			2	1			1	2	2023-11-10 07:31:25.914423
382	101	1010	1-00000382	IASD	MPS	Pampasitana	952881937 952871850	952881937 moises mamani	330203	-	Centro Poblado Menor Pampasitana	-	-	32	1			1	2	2023-09-03 18:33:49.490109
381	102	1010	1-00000381	IASD	MPS	Locumba	979415922 952213647	952213647 mariano R	330203	Distrito de locumba Jorge Basadres	Asoc.Viña del Sur	-	-	B	1		Encargado eliseo Ramos Sosa celular #949465757    falta tramitar luz y certificado de posesion\n\nangel lujan 2023 -959042484	1	2	2023-09-03 18:33:09.760321
372	101	1029	1-00000372	IASD	MPS	Samas las Yaras	952830981		330309	Sama Las Yaras	Av. Los Heroes de la Guerra del Pacifico			35	2-3			1	2	2023-12-15 22:15:25.417381
358	101	1055	1-00000358	IASD	MPS	10 DE MAYO	941320452		330310	Asentamientos Humanos 10 de Mayo Yarada Baja	Los Olivos -Yarada Baja			N	5-7-8		Marca Pacohuaraco-947678740  Wilma-959899770	1	2	2024-02-21 21:43:38.006277
394	101	1054	1-00000394	IASD	MPS	Villa Esperanza	942987145 948527142		140514	Asociacion de granjeros casa huerta villa esperanza san Jose II	sector 1			E	04			1	2	2024-03-21 20:42:26.276583
399	102	1015	1-00000399	IASD	MPS	Alto Ensenada			140702	UPIS Alto Ensenada				K	2		Cari Quispe Gerardo Bartolome DNI 30847333	1	2	2024-03-25 17:51:56.086667
403	102	1015	1-00000403	IASD	MPS	Aris el Fiscal	973116348		140701	fiscal	Fiscal			M	9-10			1	2	2024-03-25 21:21:17.208134
406	102	1015	1-00000406	IASD	MPS	Los Pinos	974386100 974386100		140705	Asoc. los Pinos	Asoc. los Pinos 			M	13			0	1	2019-03-24 21:17:40
407	102	1015	1-00000407	IASD	MPS	Villa Lourdes			140705		Avis la Victoria 			C	17			0	1	2018-12-15 13:21:49
417	102	1017	1-00000417	IASD	MPS	Cambrune			280303									0	1	2018-12-15 13:53:32
392	102	1012	1-00000392	IASD	MPS	Ciudad Majes	RPM :999722684		140514	programa Municipal de vivienda General Juan Velasco	Ciudad Majes Modulo A sector 3			E-6	18		dueño del predio Hno Ruben 999722684  Hno Edgar 984454127	1	2	2022-07-07 18:44:43.567356
428	101	1031	1-00000428	IASD	MPS	Roca Eterna Rio Bravo	946986947-968655470		330304		Asoc.Vivienda Rio Bravo			B	4		estelacarmen21@hotmail.comest  este predio no e puede titular por la region no cuenta con sertificado de defensa civil por estar cerca al rio estamo en espera    	1	1	2019-08-06 00:30:13
441	101	1011	1-00000441	IASD	MPS	Betehel 	964499270		330406		San Benedicto							1	1	2020-02-19 16:27:03
442	102	1010	1-00000442	IASD	MPS	Callapuma			330406	Distrito de Tarata	Anexo Callapuma 							1	1	2019-02-03 13:49:32
445	102	1033	1-00000443	IASD	MPS	Jirata			330406		Centro Poblado Menor de Jirata							1	1	2020-12-03 22:18:58
446	102	1010	1-00000446	IASD	MPS	Mullini			330101		Comunidad Mullini			B	2			1	1	2020-12-01 16:43:45
447	101	1010	1-00000447	IASD	MPS	Nuevo Jerusalen Rio Caño			330406		Centro Poblado Rio Caño Distrito Palca							1	1	2019-02-03 13:48:20
448	102	1033	1-00000448	IASD	MPS	Villa Eden Pampa Uyuni			330406		Anexo Pampa Uyuni-Distrito Tarata 							1	1	2019-02-03 13:51:35
452	101	1022	1-00000452	IASD	MPS	Cerro Colorado	952800735 959144800		140104		Calle Chachani 224 INTERIOR Cerrito Los Alvarez 	224					952800735   950390790	1	1	2020-12-08 13:51:43
453	102	1059	1-00000453	IASD	MPS	Los Angeles			140104	Asociacion  de Vivienda Talleres Los Angeles del sur 	Taller de Vivienda Los angeles del sur  Zona B			Q	7		hernesto anacleto nina  lider de iglesia 	1	1	2020-10-15 00:32:29
454	102	1008	1-00000454	IASD	MPS	Huasacache	958890948-948036836		140107								981655078	1	1	2019-04-05 16:46:27
468	102	1043	1-00000468	ADRA	MPS	Urinsaya Jerusalem	948126948 998000955		140505		Francisco Bolognesi	1015		L	2		958081541	1	1	2020-11-13 17:48:49
472	102	1043	1-00000472	IASD	MPS	MACA			140512	Maca								1	1	2019-06-30 04:15:17
473	102	1017	1-00000473	IASD	MPS	LA VICTORIA	983876507		280303	Asoc. Selva Alegrecalle N°11				H	18			1	1	2020-10-13 12:50:30
477	102	1016	1-00000477	IASD	MPS	Radio N.T			280303	Municipalidad Centro Poblado San Francisco	 asentamientos HH. Margilan san Francisco comite 28			H8	4		 los recibod de luz  esta a nombre de Asoc. cultural radio  nuevo tiempo   ruc 20505337434    no tiene docuemntos el predio	1	1	2020-10-31 07:21:39
479	102	1020	1-00000479	IASD	MPS	Polobaya			140123	Polobaya								1	1	2019-05-18 00:39:33
480	102	1054	1-00000480	IASD	MPS	yuramayo	960463867 941237057		140119	CENTRO POBLADO VILLA HERMOSA IV PAMPA YURAMAYO				C	3			1	1	2020-10-07 14:36:45
482	102	1026	1-00000482	IASD	MPS	Secsincalla			140402									1	1	2018-12-15 06:41:24
484	102	1043	1-00000483	IASD	MPS	Larata			140504		Larata							1	1	2018-12-15 09:09:16
487	102	1043	1-00000485	IASD	MPS	Huaytapalca	benito		140404									1	1	2018-12-15 09:08:28
493	102	1024	1-00000493	IASD	MPS	La Amistad	974370088		140104	Asoc Urbanizadora Jose Luis Bustamante y Rivero	sector 8			1 B	19			1	1	2020-03-20 16:38:19
497	101	1011	1-00000497	IASD	MPS	NUEVA JERUSALEN Tarata			330406									1	1	2020-11-18 17:21:04
478	102	1023	1-00000478	IASD	MPS	Rio Jordan	958653588-959415512		140104	Rio Seco	PP.JJ Rio Seco.Psj. Arequipa A-11			A	11		1-Falta titulo  2-Patrimonio Hna. Rosa #958653588	1	2	2021-04-27 08:18:24.187039
436	102	1040	1-00000436	IASD	MPS	Calana	902732430		330302	Asoc. Virgen del Carmen	Asoc. Virgen del Rosario   Calana			D	6		-danielsanchez@teologia.edu.pe-victoria.alicia-Paredes Sotelo Julio Raúl-952994672	1	2	2022-04-13 17:09:36.003153
467	101	1030	1-00000467	IASD	MPS	Centinelas de Sion	958734444		330303	Asentamiento Humano proyecto norte	comite 15- 28 de Agosto			365	7		JuanaLimache-969447474-marycita_dcn@hotmail.com hno Le0 952828297	1	2	2022-04-13 17:51:42.7306
499	101	1055	1-00000499	IASD	MPS	Nuevo Amanecer	981927678		330310	Asoc Rural de Vivienda Fronteras Los Palos				I	15			1	2	2021-05-29 15:34:10.490496
460	101	1013	1-00000460	IASD	MPS	Miller  Colegio x Gral Suarez	coleg. 28		330310	Cercado	Cercado Gral Suarez	174					se pago de los años 2012 al 2014  segun recibo 003302104918 fecha  16 de Agosto 2107 falta pagar 2015 -2016 y 2017	1	2	2022-04-15 09:59:23.673076
427	101	1031	1-00000427	IASD	MPS	Aposento Alto	952912285 952522068		330304	Cono Sur Tacna	segunda etapa Asoc. primero de Julio 1° etapa			I	3y 4		sayda_28_07@hotmail.com  Sayda .05440315-96254316	1	2	2021-06-10 21:25:20.229581
458	101	1013	1-00000458	IASD	MPS	Iglesia Miller y Colegio 28 de Julio.	952536650 vicente	pepelarosa@gmail.com	330310	cercado	Miller 176-178-180	176						1	2	2022-04-15 09:56:13.008869
463	102	1012	1-00000463	IASD	MPS	3er Elias			140514	Centro poblado la Colina Ciudad Majes	Ubicado en la Habilitacion Urbana Modulo B sector 2			E.01	10			1	2	2022-04-28 23:55:45.067796
455	101	1012	1-00000455	IASD	MPS	Nuevo Horizonte			140514	Asociacion Vivienda Talleres Nuevo Horizonte				K	9			0	1	2020-10-15 14:30:28
429	102	1031	1-00000429	IASD	MPS	Sol de Justicia	Nora-959438146 		330310	El Pedregal	Av. Simon Bolivar 			G	5		Nora-igp.nora@hotmail.com   ora.quelloo Roger Steven 978850558-garelkkzhq@gmail.com  	0	1	2019-07-15 03:58:00
451	102	1021	1-00000451	IASD	MPS	Las Peñas de Tiabaya	9908615333 979097011		140124	virgen chapi	Asentamiento Humano Virgen de las Peñas  Zona B-			J	9			1	2	2022-03-09 18:32:03.799063
496	101	1012	1-00000496	IASD	MPS	Pedregal Sur	978287784		140514	Habilitacion Urbana	lote 491-A			F-4	9		958682344	1	2	2022-07-07 17:52:25.05468
581	101	1024	1-00000581	IASD	MPS	La Cabaña	42938670- 988527723		140104	Asoc. la Cabaña Granja								1	1	2019-09-23 22:47:35
507	102	1043	1-00000507	IASD	MPS	Coporaque	939179744		140506		ubicado rural Janac-Canto sector coporaque  valle del colca 							1	1	2020-10-15 17:52:24
513	102	1028	1-00000513	IASD	MPS	Coraza			140603	anexo Coraza entre Tolconi y caylloma	Desvio Coraza							1	1	2018-12-15 07:10:08
514	102	1028	1-00000514	IASD	MPS	Huayta Palca			140603	anexo huayta palca 	entre Tolconi y pampa Chaco 							1	1	2018-12-15 07:11:04
475	102	1017	1-00000475	IASD	MPS	Cristo Viene -2	955687162		280101	chanchan	asociacion pro vivienda ciudad magisterial23 de junio			"A-2"	26-40			1	2	2023-11-28 07:01:15.851653
440	101	1010	1-00000440	IASD	MPS	Aricota	916719809	929434663 alberto ramos	330106	-	Centro Poblado Menor de Aricota	-	-	-	-			1	2	2023-09-03 18:24:15.409466
474	102	1017	1-00000474	IASD	MPS	Cristo Viene -1			280303	aosciacion pro vivienda 23 junio	asentamientos humanos asoc. agro industrial 4 suyos			"A-2"	27-39			1	2	2024-02-21 22:48:25.407709
515	102	1028	1-00000515	IASD	MPS	Senjuyo			140504	Estancia Senjuyo	entre Caylloma y Chuire							1	1	2019-08-17 04:17:25
516	102	1028	1-00000516	IASD	MPS	Chuaña	971174327		140504	Estancia Chuaña- entre Jachaña y Chinosiri	desvio Espinar 							1	1	2019-03-30 15:00:50
517	102	1028	1-00000517	IASD	MPS	Poccacasa			140504	Estancia Pocaccasa y chinosiri								1	1	2019-08-17 04:17:44
518	102	1028	1-00000518	IASD	MPS	Chocñiwaqui			140603									1	1	2019-08-17 04:27:42
519	102	1028	1-00000519	IASD	MPS	Corasa			140603	Estanca Santa Rosa 	desvio Coraza y Carretera Tolconi							1	1	2018-12-15 07:09:30
527	102	1025	1-00000527	IASD	MPS	Terreno no Ocupado			140106	terreno Rustico comunidad campesina de Chiguata 				B	24			1	1	2018-12-15 12:30:40
535	101	1008	1-00000535	IASD	MPS	Iglesia Hunter	952047568		140107		Jerusalen	202					959223665	1	1	2020-12-01 12:31:07
538	107	1039	1-00000538	IASD	MPS	terreno Asoc. Educ Adventista			280202	Asociacion Granjeros Ramiro priale	Rural parcela numero 61 							1	1	2019-10-04 11:43:10
545	101	1020	1-00000545	IASD	MPS	HORACIO ZEBALLOS GAMEZ  	958303690		140123	Asentamientos urbano municipal Horacio Zeballos Gamez	sector 1 sector A sector 1 sector C			19	4			1	1	2020-01-27 15:21:35
551	102	1010	1-00000551	IASD	MPS	Totorales	974437688 972409432		330201									1	1	2018-12-15 11:37:14
555	101	1014	1-00000555	IASD	MPS	Galaxia			140111	ASENTAMIENTO HUMANO URBANIZACION POPULAR DE INTERES SOCIAL GALAXIA	AAHH Urbanizacion Popular de inter Social  Zona A			T	8			1	1	2020-10-07 15:29:23
556	101	1021	1-00000556	IASD	MPS	Buenos Aires			140125	ASENTAMIENTO HUMANO BUENOS AIRES	Asentamiento Humano Buenos Aires 			H	1A3			1	1	2020-07-11 17:56:11
557	101	1026	1-00000557	IASD	MPS	terreno sin uso			140806	anexo ocoruro Distrito de Puica  provincia de de la Union								1	1	2019-08-08 21:52:40
560	101	1003	1-00000560	IASD	MPS	Villa Linares 	921103881		140201	H:H. Bella Union	Centro Poblado Villa Linares Samuel Pastor	8666		A	10			1	1	2020-11-05 17:11:25
561	101	1027	1-00000561	IASD	MPS	Oyolo			140307									1	1	2019-06-23 04:52:04
563	102	1031	1-00000563	IASD	MPS	Frontera sur	920253820 Daniel 		330304	Asoc, San Antonio 				I	1			1	1	2019-08-06 00:28:39
567	102	1025	1-00000567	IASD	MPS	la Esperanza 	991157615 988841092-		140110	Zona A de la Asociacion de vivienda Ssn Jeronimo				Z	3		988841092	1	1	2019-06-09 19:43:22
568	101	1057	1-00000568	IASD	MPS	Bustamante cono  Norte B			140104	Asociacion Urbanizadora Jose Luis Bustamante y Rivero  sector XII				1-3-	30			1	1	2020-11-03 16:46:07
569	101	1056	1-00000569	IASD	MPS	Bello horizonte			280303		sector 1B de las pampas de San Francisco 			C	21			1	1	2019-07-01 03:06:39
506	102	1001	1-00000506	IASD	MPS	Habita	974250975		330310	programa de vivienda  Regional San Jose Obrera				A	10		Hno Benjamin Ticona Gutierrez  970066611	1	2	2022-04-13 17:37:30.738096
548	102	1057	1-00000548	IASD	MPS	Apipa	978158645-		140104	Asociacion APIPA sector III,				C	4		927042875- 950441828	1	2	2021-04-27 08:11:28.739849
553	101	1060	1-00000553	IASD	MPS	Epinarenses	959602632 975660204		140514	Habilitacion Urbana Espinarences  Zona 1 distrito Majes				Q2	10			1	2	2022-07-18 08:56:27.626764
533	101	1011	1-00000533	IASD	MPS	Natividad	952845010		330310	Pueblo Joven la Natividad	Victor Raul Haya de la Torre y San Francisco	1825		39 A	1		falta inscripcion en municipio  hno cerpa 916977791- 955929500 toribio	1	2	2021-06-12 19:38:50.570561
503	101	1006	1-00000503	IASD	MPS	NUEVA JERUSALEN	952331757		330301								Ruth Jaquelyne Yufra- jacquie.yu.4@gmail.com   927575547	0	1	2020-05-11 13:22:09
524	102	1030	1-00000524	IASD	MPS	Colmenas sion	948704094		330308	28 de Agosto del promuvi zona norte Pocollay				81	13			1	2	2022-05-25 07:31:11.346423
520	102	1055	1-00000520	IASD	MPS	Asentamiento 5 y 6	955267731		330309									0	1	2019-03-30 14:42:49
512	102	1019	1-00000512	IASD	MPS	MIGUEL GRAU B	956257286-956257286		140110									0	1	2019-03-30 15:22:27
529	102	1021	1-00000529	IASD	MPS	Alto Cerro Verde tiabaya Uchumayo	973144158		140125	Asoc. de pequeños Granjeros casa- el Arenal				E	1A			1	2	2021-09-21 21:48:21.580975
10	101	1003	1-00000010	IASD	MPS	Bella Union	929815236 984443590		140208	pueblo tradicional  distrito bella union		-	-	05	17		973528665	1	2	2020-12-17 09:52:02.849698
86	102	1027	1-00000086	IASD	MPS	Bella Union	984874964 Hna		140304	PUEBLO TRADICIONAL  EL PUEBLO	Av Angel Escalante			5	17		1- falta titulación  hay 2 predios manzana 05 lote 17 p06182378\n\nel otro predio manzana 5 lote 10  p06182371	1	2	2020-12-27 13:46:31.805102
534	101	1042	1-00000534	IASD	MPS	J.L Bust. R. iglesia 1er	974320850		140108	Urbanizacion la Esperanza Adepa	seccion 01 la Esperanza			M	4			1	2	2020-12-30 21:51:26.476954
133	102	1028	1-00000133	IASD	MPS	JACHAÑA	968912287 944813861		140504	CENTRO POBLADO JACHAÑA	AVENIDACAYLLOMA CAYARANI			G	10			1	2	2021-01-10 11:31:36.999128
161	101	1042	1-00000161	IASD	MPS	CAMPO MARTE			140113	PP.JJ. CAMPO MARTE Zona B	8 de Enero B			D	7		970827636	1	2	2021-01-10 12:05:14.43434
236	101	1017	1-00000236	IASD	MPS	SAMEGUA	99500479 949038742		280304	Pueblo Joven Samegua	Av Micaela Bastidas			Q"	1		Cosi Blancas Lidia Iris-cosita2611@hotmail.com.04400440	1	2	2021-02-26 19:31:44.312319
297	102	1043	1-00000297	IASD	MPS	Nido de Alcon			140505	chilcapampa distrito de coporaque	Sector de Chilcapampa distrito de coporaque			s	5		predro Emiliano  persona encargado del predio	1	2	2021-05-03 13:41:38.942882
241	101	1040	1-00000241	IASD	MPS	BETHEL (Santa Rita )	957474690 rosa		330302	COOP. AGRARIA  DE PRODUCCION SANTA RITA							Isabel-952858517 / *888517-imarca@aruntasac.com    EL PREDIO NO CUENTA CON DOCUMENTOS   SOLO TIEN UN CERTIFICACION  EN DONDE NO HACE MENCIO LAS MEDIDAS Y COLINDANCIAS DEL TERRENO  SE TIENE QUE REALIZAR LE VANTAMIENTO DE PLANO PARA PODER INSCRIBIRLO	1	2	2022-04-13 17:25:27.325555
337	101	1023	1-00000337	IASD	MPS	Villa Paraiso			140104	Asentamientos Humano Programa Municipal  la tierra prometida el Eden				B	7		falta docuemntos	1	2	2022-04-22 09:32:44.674942
594	101	1003	20201217-00002-00000594	Iglesia adventista  del setptimo dia	MPS	pampa sarrea			140201	pampa sarrea  Samuel Pastor				A	03			0	2	2020-12-17 10:02:14.526823
404	101	1015	1-00000404	IASD	MPS	Crucero	950529813- 959040003		140706	PUNTA DE BOMBON	C.R. San Juan Catas  crucero chico U.C.010661						terreno Agricula	1	2	2022-07-29 19:48:50.585538
600	101	1032	20220826-00002-00000600	IASD	MPS	sobre las rocas	918397538		330304	habilitacion urbana promuvi viñani III				438	24			1	2	2022-08-26 07:03:13.30382
601	101	1003	20220911-00002-00000601	IASD	MPS	Bella Union MZ 05 - Lote 10	997628833		140304	pueblo tradicional Bella Union	av dos  de Mayo			05	10			1	2	2022-09-11 19:38:24.302489
522	101	1021	1-00000522	IASD	MPS	Buenos aire	941617261 bruno		140125	ASENTAMIENTO BUENOS AIRES	UCHUMAYO MZ H , L1A2			H	1A2			1	2	2022-09-24 18:37:57.757488
525	102	1010	1-00000525	IASD	MPS	Cinto	952288585 952682418	952288585-957145455	330201	-	Distrito de Ilabaya	-	-	-	-			1	2	2023-09-03 18:37:26.32821
528	102	1024	1-00000528	IASD	MPS	yura solo terreno	940870392 David		140129	Asociacion pro vivienda Urbanizacion de interes Social				N	8			0	1	2020-09-09 17:44:32
350	101	1005	1-00000350	IASD	MPS	26 de mayo -	lorena 931737198		330303	Asociacion de Vivienda 26 de Mayo -	Maria Parado de Bellido			B	17		Ortega Diana-diana_oc294@hotmail.com-ruth.noemi-Cortez Adonia Ruth-971773304  los Hnos pagaron en su totalidad el predio la cantidad de 15,000 dolares Ruth-949438431	1	2	2022-09-24 12:30:05.026484
393	102	1060	1-00000393	IASD	MPS	SECTOR 4 Caleb	951520459 958509918		140514	Programa Municipal de vivienda General Juan Velasco Alvarado	Ciudad Majes Modulo A sector 4			C4	5		959834494  951520459	1	2	2022-09-25 11:31:56.495731
410	102	1016	1-00000410	IASD	MPS	La Esperanza es Jesus	999293344		280303	PP.JJ.Mariscal Nieto	Calle Prolongacion  el Siglo	1697		T	17		-erikita@hotmail.com 40904490Milagros .053634699-953620133 milagritos_love1990@hotmail.com	1	2	2022-09-26 14:07:03.082652
290	101	1043	1-00000290	IASD	MPS	Valle del Colca 1	951027272 995638489		140505	Centro poblado Chivay	sector B Hanamsaya			N	9		Acumular  pedro sulca 995638489	1	2	2022-11-06 21:56:17.189941
136	102	1026	1-00000136	IASD	MPS	CHUQUIBAMBA	956396966		140402	Centro poblado Chuquibamba Zona B				E1	2			1	2	2022-11-14 17:52:57.044518
36	101	1048	1-00000036	IASD	MPS	Cural	942811921 953445447		140104	Asoc. de pequeños Industriales vivienda  El Crucero La Estrela	en lateral 6 Zona Vivienda			H	5			1	2	2023-01-04 17:07:09.027531
200	101	1014	1-00000200	IASD	MPS	ALTO MISTI	923225517 -958686523		140111	P.J. UNION EDIFICADORES DEL MISTI	Av. Leoncio  prado 502  ZONA E			G	20-B			1	2	2023-06-24 08:10:49.806167
603	101	1055	20230727-00002-00000603	IADS	MPS	12 DE OCTUBRE	925330116		330310	la yarada	12 de mayo							1	2	2023-07-27 16:24:20.2887
604	101	1055	20230728-00002-00000604	IASD	MPS	5 y 6 la Yarada	952503713		330301	5 y 6 La Yarada								1	2	2023-07-28 19:45:35.725153
605	101	1001	20230731-00002-00000605	IASD	MPS	Villa Del Mar	952296771		330310	Agusto B Leguia	asentamientos humanos aosc de vivienda verdaderos hijos  de Leguia			D	4			1	2	2023-07-31 16:21:39.569635
606	101	1020	20230801-00002-00000606	IASD	MPS	Agua buena			140115	pueblo tradicional de agua buena		"1"		M				1	2	2023-08-01 07:39:23.045589
607	101	1015	20230801-00002-00000607	IASD	MPS	Laas palmeras	976352603		140705	las palmeras				A	13			1	2	2023-08-20 21:13:31.033693
608	102	1047	20230827-00002-00000608	IASD	MPS	Nuevo amanecer	926176070		330301	Pueblo Joven alto de la Alianza				E	10			1	2	2023-08-27 23:19:15.010564
78	101	1010	1-00000078	IASD	MPS	MIRAVE Iglesia Central Y  colegio	9755186652-910603828	945934025 marcelino condori	330201	TERRENO DE CULTIVO UBICADO EM MIRAVE	Av Tacna			c	1		adan_vencedor_15@hotmail.com-Vilca Ccama Jonathan-995623283    1 FALTA INSCRIPCION EN E¿REGISTROS PUBLICOS  2 FALTA PAGO ARBITRIOS Y AUTOVALUO  3 LINDEREOS FALTA 921133622	1	2	2023-09-03 18:10:07.799931
278	101	1010	1-00000278	IASD	MPS	CANDARAVE	939096661	952212921 antonio chipana	330103	BARRIO QUILLAPAMPA	-	-	-	26	11		FALTA PAGOS DE AUTOAVALUO  FALTA INSCRIBIREL PREDIO ANOMBRE DE LA IGLESIA	1	2	2023-09-03 18:25:57.75945
504	102	1010	1-00000504	IASD	MPS	Ticapampa	935046615 988312821	918134476-931110154 agustin colque	330201	anexo ticapampa	-	-	-	D	8		935046615  -935046615  acciones y derechos la compar es 2000.00 MPS pago iglesia Ticapampa Hnos                                     3000.00 pago la Iglesia de ticapampa	1	2	2023-09-03 18:34:49.973681
79	101	1010	1-00000079	IASD	MPS	ANCOCALA	952930233	952930233 mateo	330101	centro Poblado ANEXO ANCOCALA				L	3		1- FALTA INSCRIPCION A REGISTROS PUBLICOS  2- FALTA PAGAR AUTOVALUO Y ARBITRIOS	1	2	2023-09-03 18:37:58.96334
609	101	1010	20230903-00002-00000609	IASD	MPS	Alto Mirave			330201	Mirave	alto mirave	-	-	Q	04			1	2	2023-09-03 22:56:58.310432
610	101	1032	20230915-00002-00000610	IASD	MPS	Sector Viñani			330304	Viñani	sector viñani			176	05			1	2	2023-09-15 12:56:48.234752
611	101	1020	20231103-00002-00000611	IASD	MPS	Ebenezer	960292074		140123	anexo de chuca	sub lote 3							1	2	2023-11-03 07:15:38.057352
612	101	1060	20231110-00002-00000612	IASD	MPS	El Bosque			140514	asoc.de vivienda  nuevo horizonte AVPNHDM				33	15			1	2	2023-11-10 20:39:05.69239
613	101	1004	20231125-00002-00000613	IASD	MPS	embajada de Japon			140103	Sector B				"Z3"	18		contrato privado a nonbre de hna y Iglesia  no tiene mucha valides	1	2	2023-11-25 22:04:49.463873
614	101	1017	20231128-00002-00000614	IASD	MPS	Cristo viene-3			280303	pampas de chenchen sub sector 2B-2				C	25-41			1	2	2023-11-28 07:17:14.56754
615	101	1032	20231201-00002-00000615	IASD	MPS	altiplano	963913314		330304	altiplano								1	2	2023-12-01 06:26:40.612259
616	101	1055	20231214-00002-00000616	IASD	MPS	Pueblo Libre 02			330301	sector la Yarada U.C 1211								1	2	2023-12-14 22:07:15.494708
617	101	1054	20231220-00002-00000617	IASD	MPS	Asoc. Agro.In la joya nueva vida	959353866		140109	asoc.org. agroin dustrial la Joya  Nueva Vida				N	8			1	2	2023-12-20 23:10:30.007394
602	101	1047	20220924-00002-00000602	IASD	MPS	Alto Tacna 02			330301	cerro intiorko Jorge Basadre	C.Parc. A 02							1	2	2024-01-02 14:31:10.110327
619	101	1055	20240221-00002-00000619	IASD	MPS	los olivos			330310	-	-	-	-	-	-			1	2	2024-02-21 21:51:57.015324
618	101	1054	20231220-00002-00000618	IASD	MPS	Agro in la Joya			140109	Asoc. Org. Agroindustrial  la Joya	Nueva vida			N	8			0	2	2023-12-20 23:08:59.326041
620	101	1054	20240321-00002-00000620	IASD	MPS	2da  Villa esperanza	-	-	140109	sector 3 del centro poblado	asociacion de granjeros casa Huertas Villa Esperanza			"O"	03			1	2	2024-03-21 21:19:48.190359
\.


--
-- Data for Name: predios_archivos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_archivos (id, id_predio, nombre, url, tipo, estado, sysuser, sysfecha) FROM stdin;
27	110	Titulo Cofopri  Afectacion en Uso, Asoc U.P.IASD	data/archivos/110_27.pdf	1	1	1	2018-04-13 00:00:00
28	110	plano de ubicacion del predio	data/archivos/110_28.pdf	1	1	1	2018-04-13 00:00:00
36	111	Escritura publica Donacion IASD	data/archivos/111_36.pdf	1	1	1	2018-04-13 00:00:00
81	238	Iglesia  pocollay peañas 03-11-2018	data/archivos/238_81.jpg	2	1	1	2018-11-03 00:00:00
82	238	pcollay peañas 03-11-2018	data/archivos/238_82.jpg	2	1	1	2018-11-03 00:00:00
109	376	Ficha Registral copia informativa	data/archivos/376_109.pdf	1	1	1	2019-03-02 00:00:00
111	60	ESCRITURA PUBLICA	data/archivos/60_111.pdf	1	1	1	2019-03-05 00:00:00
112	60	CONSTANCIA  DE INSCRIPCIÓN DE TRANSFERENCIA	data/archivos/60_112.pdf	1	1	1	2019-03-05 00:00:00
115	321	ESCRITURA PUBLICA	data/archivos/321_115.pdf	1	1	1	2019-03-05 00:00:00
117	2	INSCRIPCIÓN DE COMPRA VENTA	data/archivos/2_117.pdf	1	1	1	2019-03-05 00:00:00
118	1	ESCRITURA PUBLICA	data/archivos/1_118.pdf	1	1	1	2019-03-05 00:00:00
119	1	PARTIDA REGISTRAL	data/archivos/1_119.pdf	1	1	1	2019-03-05 00:00:00
120	5	ESCRITURA PUBLICA	data/archivos/5_120.pdf	1	1	1	2019-03-05 00:00:00
121	5	PARTIDA REGISTRAL	data/archivos/5_121.pdf	1	1	1	2019-03-05 00:00:00
122	3	ESCRITURA PUBLICA	data/archivos/3_122.pdf	1	1	1	2019-03-06 00:00:00
123	3	ESCRITURA DE ACLARACIÓN	data/archivos/3_123.pdf	1	1	1	2019-03-06 00:00:00
124	3	PARTIDA REGISTRAL	data/archivos/3_124.pdf	1	1	1	2019-03-06 00:00:00
125	4	ESCRITURA PUBLICA	data/archivos/4_125.pdf	1	1	1	2019-03-07 00:00:00
126	4	PARTIDA REGISTRAL	data/archivos/4_126.pdf	1	1	1	2019-03-07 00:00:00
128	52	ESCRITURA PUBLICA	data/archivos/52_128.pdf	1	1	1	2019-03-07 00:00:00
129	135	ESCRITURA PUBLICA	data/archivos/135_129.pdf	1	1	1	2019-03-07 00:00:00
130	142	ESCRITURA PUBLICA	data/archivos/142_130.pdf	1	1	1	2019-03-07 00:00:00
131	141	CONTRATO PRIVADO 	data/archivos/141_131.pdf	1	1	1	2019-03-07 00:00:00
132	144	CONSTANCIA DE ADJUDICACIÓN	data/archivos/144_132.pdf	1	1	1	2019-03-07 00:00:00
135	143	CONTRATO PRIVADO 	data/archivos/143_135.pdf	1	1	1	2019-03-07 00:00:00
136	308	TITULO REGISTRADO DE PROPIEDAD	data/archivos/308_136.pdf	1	1	1	2019-03-07 00:00:00
137	138	ESCRITURA PUBLICA	data/archivos/138_137.pdf	1	1	1	2019-03-07 00:00:00
138	138	ESCRITURA PUBLICA	data/archivos/138_138.pdf	1	1	1	2019-03-07 00:00:00
139	137	ESCRITURA PUBLICA	data/archivos/137_139.pdf	1	1	1	2019-03-07 00:00:00
140	136	ESCRITURA PUBLICA	data/archivos/136_140.pdf	1	1	1	2019-03-07 00:00:00
141	145	ESCRITURA PUBLICA	data/archivos/145_141.pdf	1	1	1	2019-03-07 00:00:00
142	270	ESCRITURA PUBLICA	data/archivos/270_142.pdf	1	1	1	2019-03-07 00:00:00
143	270	PARTIDA REGISTRAL	data/archivos/270_143.pdf	1	1	1	2019-03-07 00:00:00
144	282	ESCRITURA PUBLICA	data/archivos/282_144.pdf	1	1	1	2019-03-07 00:00:00
145	282	PARTIDA REGISTRAL	data/archivos/282_145.pdf	1	1	1	2019-03-07 00:00:00
146	281	ESCRITURA PUBLICA	data/archivos/281_146.pdf	1	1	1	2019-03-08 00:00:00
147	281	PARTIDA REGISTRAL	data/archivos/281_147.pdf	1	1	1	2019-03-08 00:00:00
148	283	CONTRATO PRIVADO 	data/archivos/283_148.pdf	1	1	1	2019-03-08 00:00:00
149	311	ESCRITURA PUBLICA	data/archivos/311_149.pdf	1	1	1	2019-03-08 00:00:00
150	146	ESCRITURA PUBLICA	data/archivos/146_150.pdf	1	1	1	2019-03-08 00:00:00
151	14	ESCRITURA PUBLICA	data/archivos/14_151.pdf	1	1	1	2019-03-08 00:00:00
152	14	ESCRITURA PUBLICA	data/archivos/14_152.pdf	1	1	1	2019-03-08 00:00:00
153	10	CONSTANCIA DE POSESIÓN	data/archivos/10_153.pdf	1	1	1	2019-03-08 00:00:00
154	149	ESCRITURA PUBLICA	data/archivos/149_154.pdf	1	1	1	2019-03-08 00:00:00
156	8	ESCRITURA PUBLICA	data/archivos/8_156.pdf	1	1	1	2019-03-08 00:00:00
157	13	CONSTANCIA DE POSESIÓN	data/archivos/13_157.pdf	1	1	1	2019-03-08 00:00:00
158	133	ESCRITURA IMPERFECTA	data/archivos/133_158.pdf	1	1	1	2019-03-08 00:00:00
159	129	ESCRITURA PUBLICA	data/archivos/129_159.pdf	1	1	1	2019-03-08 00:00:00
160	131	ESCRITURA PUBLICA	data/archivos/131_160.pdf	1	1	1	2019-03-08 00:00:00
161	131	ESCRITURA PUBLICA	data/archivos/131_161.pdf	1	1	1	2019-03-08 00:00:00
162	408	Ficha Registral copia informativa	data/archivos/408_162.pdf	1	1	1	2019-03-16 00:00:00
163	569	Ficha Registral copia informativa	data/archivos/569_163.pdf	1	1	1	2019-03-16 00:00:00
167	78	ESCRITURA PUBLICA	data/archivos/78_167.pdf	1	1	1	2019-03-18 00:00:00
169	78	Escritura publica donacion Asoc Union P 	data/archivos/78_169.pdf	1	1	1	2019-03-18 00:00:00
170	82	ESCRITURA PUBLICA	data/archivos/82_170.pdf	1	1	1	2019-03-18 00:00:00
171	319	Ficha Registral copia informativa	data/archivos/319_171.pdf	1	1	1	2019-03-23 00:00:00
172	504	Ficha Registral copia informativa	data/archivos/504_172.pdf	1	1	1	2019-03-23 00:00:00
173	269	PARTIDA REGISTRAL	data/archivos/269_173.pdf	1	1	1	2019-03-23 00:00:00
175	538	PARTIDA REGISTRAL	data/archivos/538_175.pdf	1	1	1	2019-03-24 00:00:00
176	33	PARTIDA REGISTRAL	data/archivos/33_176.pdf	1	1	1	2019-03-24 00:00:00
177	555	PARTIDA REGISTRAL	data/archivos/555_177.pdf	1	1	1	2019-03-24 00:00:00
179	17	Resolucion de exoneracion de Arbitrios	data/archivos/17_179.pdf	1	1	1	2019-03-24 00:00:00
182	106	PARTIDA REGISTRAL	data/archivos/106_182.pdf	1	1	1	2019-03-24 00:00:00
184	106	PARTIDA REGISTRAL manual	data/archivos/106_184.pdf	1	1	1	2019-03-24 00:00:00
187	236	municipio adjudicacion 	data/archivos/236_187.pdf	1	1	1	2019-03-24 00:00:00
190	549	ESCRITURA PUBLICA	data/archivos/549_190.pdf	1	1	1	2019-04-12 00:00:00
193	568	otorgamiento de poder LCQ por Registros	data/archivos/568_193.pdf	1	1	1	2019-05-01 00:00:00
195	32	ESCRITURA PUBLICA	data/archivos/32_195.pdf	1	1	1	2019-05-06 00:00:00
196	506	documento de propietario  acta adjudicacion renunc	data/archivos/506_196.pdf	1	1	1	2019-05-12 00:00:00
197	506	contrato de traspaso de terreno 	data/archivos/506_197.pdf	1	1	1	2019-05-12 00:00:00
198	119	PARTIDA REGISTRAL	data/archivos/119_198.pdf	1	1	1	2019-05-15 00:00:00
199	32	PARTIDA REGISTRAL	data/archivos/32_199.pdf	1	1	1	2019-05-15 00:00:00
200	32	PARTIDA REGISTRAL	data/archivos/32_200.pdf	1	1	1	2019-05-18 00:00:00
201	522	asiento de inscripcion sunarp	data/archivos/522_201.pdf	1	1	1	2019-05-18 00:00:00
202	522	PARTIDA REGISTRAL	data/archivos/522_202.pdf	1	1	1	2019-05-18 00:00:00
203	556	PARTIDA REGISTRAL	data/archivos/556_203.pdf	1	1	1	2019-05-18 00:00:00
204	556	Ficha Registral copia informativa	data/archivos/556_204.pdf	1	1	1	2019-05-18 00:00:00
208	189	ESCRITURA PUBLICA	data/archivos/189_208.pdf	1	1	1	2019-05-24 00:00:00
209	184	ESCRITURA PUBLICA	data/archivos/184_209.pdf	1	1	1	2019-05-25 00:00:00
210	280	ESCRITURA PUBLICA	data/archivos/280_210.pdf	1	1	1	2019-05-25 00:00:00
211	168	Licencia de apertura de establecimiento coleg.	data/archivos/168_211.pdf	1	1	1	2019-06-08 00:00:00
213	28	PARTIDA REGISTRAL	data/archivos/28_213.pdf	1	1	1	2019-06-08 00:00:00
215	139	pago de autovaluo arbitrios 2010	data/archivos/139_215.pdf	1	1	1	2019-06-13 00:00:00
219	261	Reolcucion de alcaldia inafectacion predial 2004	data/archivos/261_219.pdf	1	1	1	2019-06-13 00:00:00
220	139	ESCRITURA PUBLICA	data/archivos/139_220.pdf	1	1	1	2019-06-13 00:00:00
222	113	Licencia de posesion y licencia de edificacion	data/archivos/113_222.pdf	1	1	1	2019-06-18 00:00:00
225	184	Ficha Registral copia informativa	data/archivos/184_225.pdf	1	1	1	2019-06-19 00:00:00
226	319	contrato de compromiso de venta y compra	data/archivos/319_226.pdf	1	1	1	2019-06-22 00:00:00
227	135	plano de ubicacion	data/archivos/135_227.pdf	1	1	1	2019-06-22 00:00:00
228	168	LICENCIA DE CONSTRUCCION  EDIFICACION	data/archivos/168_228.pdf	1	1	1	2019-06-22 00:00:00
229	86	plano ubicacion	data/archivos/86_229.pdf	1	1	1	2019-06-22 00:00:00
230	21	parametros urbanisticos 	data/archivos/21_230.pdf	1	1	1	2019-06-23 00:00:00
231	77	Acta compromiso alcalde y Pr .2009	data/archivos/77_231.pdf	1	1	1	2019-06-23 00:00:00
232	343	plano de ubicacion 	data/archivos/343_232.pdf	1	1	1	2019-06-23 00:00:00
233	458	oficio de iglesia peticion par ayuda saneamiento p	data/archivos/458_233.pdf	1	1	1	2019-06-23 00:00:00
235	279	Partida registral o ficha	data/archivos/279_235.pdf	1	1	1	2019-06-27 00:00:00
236	320	Anotacion de Inscripcion Sunarp	data/archivos/320_236.pdf	1	1	1	2019-06-28 00:00:00
239	129	ESCRITURA PUBLICA de la dueña 	data/archivos/129_239.pdf	1	1	1	2019-06-28 00:00:00
240	295	Anotacion de Inscripcion Sunarp	data/archivos/295_240.pdf	1	1	1	2019-06-30 00:00:00
241	468	croquix 	data/archivos/468_241.pdf	1	1	1	2019-06-30 00:00:00
242	317	Ficha Registral Sunarp 	data/archivos/317_242.pdf	1	1	1	2019-06-30 00:00:00
244	320	Impuesto de alcabala 11 marzo 2003	data/archivos/320_244.pdf	1	1	1	2019-06-30 00:00:00
245	112	croquix detallado	data/archivos/112_245.pdf	1	1	1	2019-06-30 00:00:00
246	106	croquix detallado	data/archivos/106_246.pdf	1	1	1	2019-06-30 00:00:00
247	92	croquix detallado	data/archivos/92_247.pdf	1	1	1	2019-06-30 00:00:00
249	408	acta acuerdo  junta de iglesia  	data/archivos/408_249.pdf	1	1	1	2019-07-01 00:00:00
250	560	PARTIDA REGISTRAL	data/archivos/560_250.pdf	1	1	1	2019-07-03 00:00:00
253	29	anotacion inscripcion a nombre Dueño predios 	data/archivos/29_253.pdf	1	1	1	2019-07-25 00:00:00
254	117	Resolucio de alcaldia	data/archivos/117_254.pdf	1	1	1	2019-07-29 00:00:00
255	27	constancia de inafecta al apgo de alcabala	data/archivos/27_255.pdf	1	1	1	2019-08-03 00:00:00
256	337	promesa de venta	data/archivos/337_256.pdf	1	1	1	2019-08-10 00:00:00
258	302	Ficha Registral Sunarp 	data/archivos/302_258.pdf	1	1	1	2019-08-10 00:00:00
259	151	adjudicacion  a nombre rosa cuentas	data/archivos/151_259.pdf	1	1	1	2019-08-11 00:00:00
260	557	CONSTANCIA DE POSESIÓN	data/archivos/557_260.pdf	1	1	1	2019-08-17 00:00:00
263	151	Anotacion de Inscripcion Sunarp	data/archivos/151_263.pdf	1	1	1	2019-08-30 00:00:00
267	71	ESCRITURA PUBLICA	data/archivos/71_267.pdf	1	1	1	2019-08-31 00:00:00
268	71	Ficha Registral Sunarp 	data/archivos/71_268.pdf	1	1	1	2019-08-31 00:00:00
269	233	PARTIDA REGISTRAL	data/archivos/233_269.pdf	1	1	1	2019-09-05 00:00:00
270	151	Anotacion de Inscripcion Sunarp	data/archivos/151_270.pdf	1	1	1	2019-09-07 00:00:00
271	151	inscripcion de cambio de datos del titular	data/archivos/151_271.pdf	1	1	1	2019-09-07 00:00:00
272	52	Anotacion de Inscripcion Sunarp	data/archivos/52_272.pdf	1	1	1	2019-09-10 00:00:00
273	52	ficha registral	data/archivos/52_273.pdf	1	1	1	2019-09-20 00:00:00
274	356	ficha registral	data/archivos/356_274.pdf	1	1	1	2019-09-21 00:00:00
276	101	contrato promesa de venta 2 contrato promesa	data/archivos/101_276.pdf	1	1	1	2019-09-21 00:00:00
277	101	plano ubicacion	data/archivos/101_277.pdf	1	1	1	2019-09-21 00:00:00
278	28	resolucion alcaldia inafectacion autovaluo	data/archivos/28_278.pdf	1	1	1	2019-09-21 00:00:00
279	151	ficha registral	data/archivos/151_279.pdf	1	1	1	2019-09-21 00:00:00
280	309	Certificado de numeracion  	data/archivos/309_280.pdf	1	1	1	2019-09-21 00:00:00
281	168	Licencia de funcionamiento resolucion 	data/archivos/168_281.pdf	1	1	1	2019-09-22 00:00:00
291	60	REGISTRO PREDIAL URBANO	data/archivos/60_291.jpg	2	1	1	2019-10-01 00:00:00
292	60	ESCRITURA PUBLICA	data/archivos/60_292.jpg	2	1	1	2019-10-01 00:00:00
293	60	escritura publica 02	data/archivos/60_293.jpg	2	1	1	2019-10-01 00:00:00
294	60	escritura publica03	data/archivos/60_294.jpg	2	1	1	2019-10-01 00:00:00
295	60	escritura publica04	data/archivos/60_295.jpg	2	1	1	2019-10-01 00:00:00
296	60	escritura publica05	data/archivos/60_296.jpg	2	1	1	2019-10-01 00:00:00
298	60	escritura publica06	data/archivos/60_298.jpg	2	1	1	2019-10-01 00:00:00
299	60	escritura publica07	data/archivos/60_299.jpg	2	1	1	2019-10-01 00:00:00
300	153	Acta Provicional de adjudicacion de lote	data/archivos/153_300.pdf	1	1	1	2019-10-13 00:00:00
301	48	ficha registral	data/archivos/48_301.pdf	1	1	1	2019-10-15 00:00:00
304	317	ficha registral actualizado	data/archivos/317_304.pdf	1	1	1	2019-10-16 00:00:00
305	168	ficha registral	data/archivos/168_305.pdf	1	1	1	2019-10-18 00:00:00
306	194	plano ubicacion	data/archivos/194_306.pdf	1	1	1	2019-10-24 00:00:00
307	194	menoria descriptiva	data/archivos/194_307.pdf	1	1	1	2019-10-24 00:00:00
308	194	resolucion adjudicacion municipio	data/archivos/194_308.pdf	1	1	1	2019-10-24 00:00:00
310	452	ficha registral	data/archivos/452_310.pdf	1	1	1	2019-11-12 00:00:00
311	29	anotacion de inscripcion	data/archivos/29_311.pdf	1	1	1	2019-11-28 00:00:00
312	254	anotacion de inscripcion de fabrica	data/archivos/254_312.pdf	1	1	1	2019-12-14 00:00:00
314	112	solitud inafectacion predial 	data/archivos/112_314.pdf	1	1	1	2019-12-14 00:00:00
405	43	Recibo de luz	data/archivos/43_405.jpg	1	1	1	2020-09-15 00:00:00
315	234	solicitud inafectacion  predial	data/archivos/234_315.pdf	1	1	1	2019-12-14 00:00:00
316	334	escritura publica	data/archivos/334_316.pdf	1	1	1	2019-12-25 00:00:00
318	254	constacia de fabrica	data/archivos/254_318.pdf	1	1	1	2020-01-28 00:00:00
319	196	anotacion de inscripcion	data/archivos/196_319.pdf	1	1	1	2020-01-29 00:00:00
320	5	anotacion de inscripcion	data/archivos/5_320.pdf	1	1	1	2020-01-29 00:00:00
283	321	ESCRITURA PUBLICA	data/archivos/321_283.pdf	1	1	1	2019-10-01 00:00:00
284	321	escritura publica 02	data/archivos/321_284.pdf	1	1	1	2019-10-01 00:00:00
285	321	escritura publica03	data/archivos/321_285.pdf	1	1	1	2019-10-01 00:00:00
286	321	escritura publica04	data/archivos/321_286.pdf	1	1	1	2019-10-01 00:00:00
287	321	escritura publica05	data/archivos/321_287.pdf	1	1	1	2019-10-01 00:00:00
288	321	escritura publica06	data/archivos/321_288.pdf	1	1	1	2019-10-01 00:00:00
289	321	escritura publica07	data/archivos/321_289.pdf	1	1	1	2019-10-01 00:00:00
290	321	escritura publica08	data/archivos/321_290.pdf	1	1	1	2019-10-01 00:00:00
321	158	solicitud sobre licencia de construccion	data/archivos/158_321.pdf	1	1	1	2020-02-01 00:00:00
323	29	ficha registral	data/archivos/29_323.pdf	1	1	1	2020-02-04 00:00:00
326	392	escritura publica	data/archivos/392_326.pdf	1	1	1	2020-02-16 00:00:00
331	257	pago de autovaluo 2005	data/archivos/257_331.pdf	1	1	1	2020-03-20 00:00:00
332	265	Certiifcado catastro 	data/archivos/265_332.pdf	1	1	1	2020-03-20 00:00:00
333	266	prediasl	data/archivos/266_333.pdf	1	1	1	2020-03-20 00:00:00
334	266	prediasl	data/archivos/266_334.pdf	1	1	1	2020-03-20 00:00:00
335	302	cruxi anterior oficina 	data/archivos/302_335.pdf	1	1	1	2020-03-20 00:00:00
336	108	escritura publica	data/archivos/108_336.pdf	1	1	1	2020-06-09 00:00:00
338	108	escritura publica	data/archivos/108_338.pdf	1	1	1	2020-06-09 00:00:00
339	108	escritura publica en Donacion año 2000	data/archivos/108_339.pdf	1	1	1	2020-06-09 00:00:00
340	108	plano ubicacion	data/archivos/108_340.pdf	1	1	1	2020-06-09 00:00:00
341	413	primer testimonio escritura publica	data/archivos/413_341.pdf	1	1	1	2020-06-09 00:00:00
342	413	ficha registral	data/archivos/413_342.pdf	1	1	1	2020-06-09 00:00:00
343	109	escritura publica	data/archivos/109_343.pdf	1	1	1	2020-06-09 00:00:00
344	107	escritura publica y croquis	data/archivos/107_344.pdf	1	1	1	2020-06-09 00:00:00
345	234	ficha registral antiguo	data/archivos/234_345.pdf	1	1	1	2020-06-09 00:00:00
346	234	Titulo de propiedad otorga Municipio  moquegua	data/archivos/234_346.pdf	1	1	1	2020-06-09 00:00:00
347	107	minuta	data/archivos/107_347.pdf	1	1	1	2020-06-09 00:00:00
352	377	contrato de comra venta otorgado Municipalidad 	data/archivos/377_352.pdf	1	1	1	2020-06-09 00:00:00
353	569	escritura publica	data/archivos/569_353.pdf	1	1	1	2020-06-09 00:00:00
354	408	escritura publica	data/archivos/408_354.pdf	1	1	1	2020-06-09 00:00:00
357	236	ficha registral IASD  lleva a municipio para corre	data/archivos/236_357.pdf	1	1	1	2020-06-12 00:00:00
358	113	acuerdo de adjudicacion Municipio	data/archivos/113_358.pdf	1	1	1	2020-06-12 00:00:00
359	113	Certificado de posesion 2017 IASD	data/archivos/113_359.pdf	1	1	1	2020-06-12 00:00:00
361	236	crokis antiguo y actual	data/archivos/236_361.pdf	1	1	1	2020-06-12 00:00:00
362	106	titulo municipio provincial 1992	data/archivos/106_362.pdf	1	1	1	2020-06-12 00:00:00
364	235	escritura  publica 	data/archivos/235_364.pdf	1	1	1	2020-06-14 00:00:00
365	235	Minuta 	data/archivos/235_365.pdf	1	1	1	2020-06-14 00:00:00
366	473	testimonio  escritura publica	data/archivos/473_366.pdf	1	1	1	2020-06-14 00:00:00
367	409	escritura publica	data/archivos/409_367.pdf	1	1	1	2020-06-14 00:00:00
368	23	escritura  publica 	data/archivos/23_368.pdf	1	1	1	2020-06-14 00:00:00
369	23	deposito bauher cancelacion BCP falta escritura po	data/archivos/23_369.pdf	1	1	1	2020-06-14 00:00:00
370	23	anotacion inscripcion sunarp IASD	data/archivos/23_370.pdf	1	1	1	2020-06-14 00:00:00
371	477	contrato de traspaso a anternor Lucas Catunta	data/archivos/477_371.pdf	1	1	1	2020-06-14 00:00:00
372	477	acta de adjudicacion a pedro ticons saci	data/archivos/477_372.pdf	1	1	1	2020-06-14 00:00:00
373	477	contrato de trasferencia Luis Alberto Mayorga	data/archivos/477_373.pdf	1	1	1	2020-06-14 00:00:00
374	477	crokis  ubicacion	data/archivos/477_374.pdf	1	1	1	2020-06-14 00:00:00
375	112	plano de ubicacion	data/archivos/112_375.pdf	1	1	1	2020-06-14 00:00:00
376	376	escritura  publica 	data/archivos/376_376.pdf	1	1	1	2020-06-14 00:00:00
377	33	anotacion de inscripcion  a sunarp IASD	data/archivos/33_377.pdf	1	1	1	2020-06-14 00:00:00
378	150	segundo  testimonio o escritura publica a corp Gen	data/archivos/150_378.pdf	1	1	1	2020-06-14 00:00:00
379	90	certificado no adeudo para levantar en sunarp 	data/archivos/90_379.pdf	1	1	1	2020-06-14 00:00:00
380	296	escrit. publica a favor salomon miranda	data/archivos/296_380.pdf	1	1	1	2020-06-16 00:00:00
381	297	documento de transferencia a favor ruben miranda	data/archivos/297_381.pdf	1	1	1	2020-06-16 00:00:00
382	468	escritura  publica 	data/archivos/468_382.pdf	1	1	1	2020-06-16 00:00:00
384	140	transferencia de derechos de posesion	data/archivos/140_384.pdf	1	1	1	2020-06-16 00:00:00
385	298	ficha registral  IASD	data/archivos/298_385.pdf	1	1	1	2020-06-16 00:00:00
386	298	plano croquix	data/archivos/298_386.pdf	1	1	1	2020-06-16 00:00:00
387	324	transferencia escritura p. inperfecta IASD	data/archivos/324_387.pdf	1	1	1	2020-06-16 00:00:00
388	294	escritura  publica imperfectaIASD	data/archivos/294_388.pdf	1	1	1	2020-06-16 00:00:00
389	180	Constancia Mamani Turpo Juana S.24-06-2009	data/archivos/180_389.pdf	1	1	1	2020-07-11 00:00:00
390	522	escritura  publica 	data/archivos/522_390.pdf	1	1	1	2020-07-11 00:00:00
391	162	ficha registral  con antecedentes	data/archivos/162_391.pdf	1	1	1	2020-07-11 00:00:00
392	506	deposito baucher BCP por el pago del predio	data/archivos/506_392.pdf	1	1	1	2020-08-21 00:00:00
393	414	escritura  publica 	data/archivos/414_393.pdf	1	1	1	2020-08-23 00:00:00
394	414	ficha registral	data/archivos/414_394.pdf	1	1	1	2020-08-23 00:00:00
401	109	ficha registros 	data/archivos/109_401.pdf	1	1	1	2020-09-14 00:00:00
403	309	recibos de agua	data/archivos/309_403.jpg	1	1	1	2020-09-15 00:00:00
404	309	Recibo de luz	data/archivos/309_404.jpg	1	1	1	2020-09-15 00:00:00
406	12	ficha registros 	data/archivos/12_406.pdf	1	1	1	2020-09-22 00:00:00
407	405	ficha registros 	data/archivos/405_407.pdf	1	1	1	2020-09-22 00:00:00
408	135	ficha registros 	data/archivos/135_408.pdf	1	1	1	2020-09-22 00:00:00
409	249	ficha registros 	data/archivos/249_409.pdf	1	1	1	2020-09-22 00:00:00
410	249	predial año 2020	data/archivos/249_410.pdf	1	1	1	2020-09-22 00:00:00
411	309	plano ubicacion memoria descriptiva	data/archivos/309_411.pdf	1	1	1	2020-09-23 00:00:00
412	405	plano de ubicacion	data/archivos/405_412.pdf	1	1	1	2020-09-23 00:00:00
413	405	Rcibo de agua	data/archivos/405_413.pdf	1	1	1	2020-09-23 00:00:00
414	168	certif compatibilidad de uso	data/archivos/168_414.pdf	1	1	1	2020-09-23 00:00:00
415	12	constancia de posesion	data/archivos/12_415.pdf	1	1	1	2020-09-23 00:00:00
416	298	ficha de inscripcion sunarp	data/archivos/298_416.pdf	1	1	1	2020-09-23 00:00:00
417	298	escritura publica	data/archivos/298_417.pdf	1	1	1	2020-09-23 00:00:00
418	298	ficha registros actualizado 2020	data/archivos/298_418.pdf	1	1	1	2020-09-23 00:00:00
419	185	Resolucion colegio majes secundaria 	data/archivos/185_419.pdf	1	1	1	2020-09-23 00:00:00
420	168	certificado resolucion defensa Civil Forga  2019	data/archivos/168_420.pdf	1	1	1	2020-09-23 00:00:00
422	464	certificado negativo de catastro	data/archivos/464_422.pdf	1	1	1	2020-09-24 00:00:00
423	504	baucher de Bcp pago por la compra terreno	data/archivos/504_423.pdf	1	1	1	2020-09-24 00:00:00
424	234	ficha registros 	data/archivos/234_424.pdf	1	1	1	2020-09-25 00:00:00
425	87	constancia posesion 2017	data/archivos/87_425.pdf	1	1	1	2020-09-25 00:00:00
426	87	constancia de posesion 2020	data/archivos/87_426.pdf	1	1	1	2020-09-25 00:00:00
428	321	ficha registros actualizado 	data/archivos/321_428.pdf	1	1	1	2020-09-25 00:00:00
430	284	ficha registros a nombre de Dueñp falta tarnsferir	data/archivos/284_430.pdf	1	1	1	2020-09-25 00:00:00
431	524	ficha registros 	data/archivos/524_431.pdf	1	1	1	2020-09-25 00:00:00
432	74	ficha registros 	data/archivos/74_432.pdf	1	1	1	2020-09-25 00:00:00
433	74	plano cruxis	data/archivos/74_433.pdf	1	1	1	2020-09-25 00:00:00
434	343	constancia de posesion 2020 	data/archivos/343_434.pdf	1	1	1	2020-09-28 00:00:00
436	27	informe terreno fotos yplanos costo saneamieto	data/archivos/27_436.pdf	1	1	1	2020-09-28 00:00:00
437	251	ficha registros  año 2020	data/archivos/251_437.pdf	1	1	1	2020-09-29 00:00:00
441	144	Ficha registral a nombre Municipio falta sanear	data/archivos/144_441.pdf	1	1	1	2020-09-29 00:00:00
442	538	planos  y cruxis de terreno	data/archivos/538_442.pdf	1	1	1	2020-09-30 00:00:00
443	41	ficha registros 2020	data/archivos/41_443.pdf	1	1	1	2020-09-30 00:00:00
444	41	escritura publica	data/archivos/41_444.pdf	1	1	1	2020-09-30 00:00:00
445	156	ficha registros 	data/archivos/156_445.pdf	1	1	1	2020-09-30 00:00:00
447	155	escritura publica	data/archivos/155_447.pdf	1	1	1	2020-09-30 00:00:00
448	33	ficha registros 	data/archivos/33_448.pdf	1	1	1	2020-09-30 00:00:00
451	152	escritura publica	data/archivos/152_451.pdf	1	1	1	2020-09-30 00:00:00
452	33	escritura publica	data/archivos/33_452.pdf	1	1	1	2020-09-30 00:00:00
453	153	impuesto predial1995	data/archivos/153_453.pdf	1	1	1	2020-09-30 00:00:00
454	90	anotacion de inscripcion	data/archivos/90_454.pdf	1	1	1	2020-09-30 00:00:00
455	156	minuta 2009	data/archivos/156_455.pdf	1	1	1	2020-09-30 00:00:00
456	464	levantamiento y cancelacion de hipoteca  2020	data/archivos/464_456.pdf	1	1	1	2020-10-01 00:00:00
457	120	recibo de Seal  2020	data/archivos/120_457.pdf	1	1	1	2020-10-01 00:00:00
458	152	ficha registros 	data/archivos/152_458.pdf	1	1	1	2020-10-01 00:00:00
459	150	ficha registros 2020	data/archivos/150_459.pdf	1	1	1	2020-10-01 00:00:00
460	155	ficha registros 2020	data/archivos/155_460.pdf	1	1	1	2020-10-01 00:00:00
461	255	escritura publica	data/archivos/255_461.pdf	1	1	1	2020-10-01 00:00:00
462	341	planos  y cruxis de terreno 2020  por cofopri 	data/archivos/341_462.pdf	1	1	1	2020-10-02 00:00:00
463	249	peritaje de casa pastoral	data/archivos/249_463.pdf	1	1	1	2020-10-02 00:00:00
465	173	adjudicacion  del municipio	data/archivos/173_465.pdf	1	1	1	2020-10-07 00:00:00
466	173	autovaluo 2001	data/archivos/173_466.pdf	1	1	1	2020-10-07 00:00:00
467	173	constancia posesion  de asoc.	data/archivos/173_467.pdf	1	1	1	2020-10-07 00:00:00
468	173	escritura publica	data/archivos/173_468.pdf	1	1	1	2020-10-07 00:00:00
469	305	certif posesion municipio 2088	data/archivos/305_469.pdf	1	1	1	2020-10-07 00:00:00
470	305	autovaluo 2006 a 2010	data/archivos/305_470.pdf	1	1	1	2020-10-07 00:00:00
471	305	expediente quinto juzgado	data/archivos/305_471.pdf	1	1	1	2020-10-07 00:00:00
472	480	contrato de compra y venta 	data/archivos/480_472.pdf	1	1	1	2020-10-07 00:00:00
474	398	ficha registros 	data/archivos/398_474.pdf	1	1	1	2020-10-07 00:00:00
475	398	escritura publica	data/archivos/398_475.pdf	1	1	1	2020-10-07 00:00:00
476	398	baucher por la compra y pago	data/archivos/398_476.pdf	1	1	1	2020-10-07 00:00:00
477	555	escritura publica	data/archivos/555_477.pdf	1	1	1	2020-10-07 00:00:00
478	291	escritura publica	data/archivos/291_478.pdf	1	1	1	2020-10-07 00:00:00
480	291	cruxis	data/archivos/291_480.pdf	1	1	1	2020-10-07 00:00:00
481	468	titulo de cofopri	data/archivos/468_481.pdf	1	1	1	2020-10-07 00:00:00
482	468	ficha registra 	data/archivos/468_482.pdf	1	1	1	2020-10-07 00:00:00
483	468	ficha registral 2020	data/archivos/468_483.pdf	1	1	1	2020-10-07 00:00:00
484	24	recibo de agua y luz 	data/archivos/24_484.pdf	1	1	1	2020-10-07 00:00:00
485	534	ficha registral 	data/archivos/534_485.pdf	1	1	1	2020-10-09 00:00:00
486	189	Recibo de luz	data/archivos/189_486.pdf	1	1	1	2020-10-09 00:00:00
487	186	constancia de posesion	data/archivos/186_487.pdf	1	1	1	2020-10-09 00:00:00
488	302	recibo de luz asoc educ  adv por la calle Bolognes	data/archivos/302_488.pdf	1	1	1	2020-10-09 00:00:00
489	189	ficha registral	data/archivos/189_489.pdf	1	1	1	2020-10-09 00:00:00
490	90	escritura publica	data/archivos/90_490.pdf	1	1	1	2020-10-12 00:00:00
491	227	Acta de constitucion	data/archivos/227_491.pdf	1	1	1	2020-10-12 00:00:00
492	227	acta de juez de paz	data/archivos/227_492.pdf	1	1	1	2020-10-12 00:00:00
493	556	certificado por damnificado	data/archivos/556_493.pdf	1	1	1	2020-10-12 00:00:00
494	216	escritura publica	data/archivos/216_494.pdf	1	1	1	2020-10-12 00:00:00
495	216	plano  ubicacion	data/archivos/216_495.pdf	1	1	1	2020-10-12 00:00:00
496	216	parte de escritura	data/archivos/216_496.pdf	1	1	1	2020-10-12 00:00:00
497	119	escritura publica	data/archivos/119_497.pdf	1	1	1	2020-10-12 00:00:00
498	118	escritura publica	data/archivos/118_498.pdf	1	1	1	2020-10-12 00:00:00
499	222	carta notarial dueño	data/archivos/222_499.pdf	1	1	1	2020-10-12 00:00:00
500	222	escritura publica	data/archivos/222_500.pdf	1	1	1	2020-10-12 00:00:00
501	222	plano ubicacion 	data/archivos/222_501.pdf	1	1	1	2020-10-12 00:00:00
502	222	escritura publica	data/archivos/222_502.pdf	1	1	1	2020-10-12 00:00:00
503	222	plano ubicacion 	data/archivos/222_503.pdf	1	1	1	2020-10-12 00:00:00
505	222	minuta	data/archivos/222_505.pdf	1	1	1	2020-10-12 00:00:00
506	222	plano ubicacion 	data/archivos/222_506.pdf	1	1	1	2020-10-12 00:00:00
507	160	ficha registral antiguo	data/archivos/160_507.pdf	1	1	1	2020-10-12 00:00:00
508	160	ficha registral año 2000	data/archivos/160_508.pdf	1	1	1	2020-10-12 00:00:00
509	224	escritura publica	data/archivos/224_509.pdf	1	1	1	2020-10-12 00:00:00
510	216	propuesta de la nima cerro verde valor de la const	data/archivos/216_510.pdf	1	1	1	2020-10-12 00:00:00
511	230	ficha registros 	data/archivos/230_511.pdf	1	1	1	2020-10-12 00:00:00
512	222	escritura publica	data/archivos/222_512.pdf	1	1	1	2020-10-12 00:00:00
515	223	contrato de tranferencia	data/archivos/223_515.pdf	1	1	1	2020-10-12 00:00:00
516	528	baucher por la compra y pago	data/archivos/528_516.pdf	1	1	1	2020-10-12 00:00:00
517	528	carta de renuncia	data/archivos/528_517.pdf	1	1	1	2020-10-12 00:00:00
518	528	constancia de posesion	data/archivos/528_518.pdf	1	1	1	2020-10-12 00:00:00
519	528	contrato de acciones  y derechos	data/archivos/528_519.pdf	1	1	1	2020-10-12 00:00:00
520	528	contrato privado	data/archivos/528_520.pdf	1	1	1	2020-10-12 00:00:00
521	528	contrato privado	data/archivos/528_521.pdf	1	1	1	2020-10-12 00:00:00
522	528	formulario impuesto privado	data/archivos/528_522.pdf	1	1	1	2020-10-12 00:00:00
523	528	inscripcion al padron	data/archivos/528_523.pdf	1	1	1	2020-10-12 00:00:00
524	528	plano croxis	data/archivos/528_524.pdf	1	1	1	2020-10-12 00:00:00
525	528	constancia de adjudicacion	data/archivos/528_525.pdf	1	1	1	2020-10-12 00:00:00
526	107	Resolucion de colegio 	data/archivos/107_526.pdf	1	1	1	2020-10-13 00:00:00
527	23	ficha registral con carga 	data/archivos/23_527.pdf	1	1	1	2020-10-13 00:00:00
528	23	autovaluo 2014	data/archivos/23_528.pdf	1	1	1	2020-10-13 00:00:00
529	92	partes y escritura publica lote 07	data/archivos/92_529.pdf	1	1	1	2020-10-13 00:00:00
530	92	parte de escritura lote 08	data/archivos/92_530.pdf	1	1	1	2020-10-13 00:00:00
531	92	parte de escritura lote 09	data/archivos/92_531.pdf	1	1	1	2020-10-13 00:00:00
532	113	croxis	data/archivos/113_532.pdf	1	1	1	2020-10-13 00:00:00
533	108	escritura publica	data/archivos/108_533.pdf	1	1	1	2020-10-13 00:00:00
534	108	escritura publica	data/archivos/108_534.pdf	1	1	1	2020-10-13 00:00:00
535	108	plano ubicacion 	data/archivos/108_535.pdf	1	1	1	2020-10-13 00:00:00
540	302	escritura publica 1919	data/archivos/302_540.pdf	1	1	1	2020-10-13 00:00:00
541	302	escritura publica	data/archivos/302_541.pdf	1	1	1	2020-10-13 00:00:00
545	24	constancia de posesion	data/archivos/24_545.pdf	1	1	1	2020-10-13 00:00:00
546	24	plano ubicacion 	data/archivos/24_546.pdf	1	1	1	2020-10-13 00:00:00
547	40	escritura publica	data/archivos/40_547.pdf	1	1	1	2020-10-13 00:00:00
548	405	constancia de posesion	data/archivos/405_548.pdf	1	1	1	2020-10-13 00:00:00
553	7	constancia de posesion 2009-2010-2016 varios	data/archivos/7_553.pdf	1	1	1	2020-10-13 00:00:00
554	270	plano ubicacion 	data/archivos/270_554.pdf	1	1	1	2020-10-13 00:00:00
555	270	ficha registral 	data/archivos/270_555.pdf	1	1	1	2020-10-13 00:00:00
556	392	anotacion de inscripcion 	data/archivos/392_556.pdf	1	1	1	2020-10-13 00:00:00
557	392	resumen ficha sunarp	data/archivos/392_557.pdf	1	1	1	2020-10-13 00:00:00
560	587	ficha registros 	data/archivos/587_560.pdf	1	1	1	2020-10-13 00:00:00
561	129	plano ubicacion 	data/archivos/129_561.pdf	1	1	1	2020-10-13 00:00:00
562	587	escritura imperfecta  municipio	data/archivos/587_562.pdf	1	1	1	2020-10-13 00:00:00
563	587	plano  ubicacion	data/archivos/587_563.pdf	1	1	1	2020-10-13 00:00:00
564	303	alcabala	data/archivos/303_564.pdf	1	1	1	2020-10-14 00:00:00
565	66	ficha registros 	data/archivos/66_565.pdf	1	1	1	2020-10-14 00:00:00
566	66	escritura publica	data/archivos/66_566.pdf	1	1	1	2020-10-14 00:00:00
567	66	escritura publica	data/archivos/66_567.pdf	1	1	1	2020-10-14 00:00:00
569	66	licencia de construccion	data/archivos/66_569.pdf	1	1	1	2020-10-14 00:00:00
570	66	resolucion alcaldia	data/archivos/66_570.pdf	1	1	1	2020-10-14 00:00:00
571	363	escritura publica	data/archivos/363_571.pdf	1	1	1	2020-10-14 00:00:00
572	363	baucher por la compra y pago	data/archivos/363_572.pdf	1	1	1	2020-10-14 00:00:00
573	64	escritura publica	data/archivos/64_573.pdf	1	1	1	2020-10-14 00:00:00
574	319	escritura publica acciones y derechos	data/archivos/319_574.pdf	1	1	1	2020-10-14 00:00:00
575	319	plano ubicacion 	data/archivos/319_575.pdf	1	1	1	2020-10-14 00:00:00
576	61	contrato privado	data/archivos/61_576.pdf	1	1	1	2020-10-14 00:00:00
577	61	certificado posesion	data/archivos/61_577.pdf	1	1	1	2020-10-14 00:00:00
578	61	certificado posesion	data/archivos/61_578.pdf	1	1	1	2020-10-14 00:00:00
579	61	pu  pago de predial2007	data/archivos/61_579.pdf	1	1	1	2020-10-14 00:00:00
580	151	escritura publica	data/archivos/151_580.pdf	1	1	1	2020-10-14 00:00:00
581	339	constancia de posesion	data/archivos/339_581.pdf	1	1	1	2020-10-14 00:00:00
582	339	autovaluo 2007	data/archivos/339_582.pdf	1	1	1	2020-10-14 00:00:00
583	339	contrato privado	data/archivos/339_583.pdf	1	1	1	2020-10-14 00:00:00
584	339	DNI del dueño del predio	data/archivos/339_584.pdf	1	1	1	2020-10-14 00:00:00
585	339	ficha registral 	data/archivos/339_585.pdf	1	1	1	2020-10-14 00:00:00
587	339	plano ubicacion 	data/archivos/339_587.pdf	1	1	1	2020-10-14 00:00:00
588	343	plano ubicacion 	data/archivos/343_588.pdf	1	1	1	2020-10-14 00:00:00
589	343	autovaluo 2010	data/archivos/343_589.pdf	1	1	1	2020-10-14 00:00:00
590	16	escritura publica	data/archivos/16_590.pdf	1	1	1	2020-10-14 00:00:00
591	16	ficha registros  2018	data/archivos/16_591.pdf	1	1	1	2020-10-14 00:00:00
592	17	ficha registral 2018	data/archivos/17_592.pdf	1	1	1	2020-10-14 00:00:00
593	21	ficha registral 2018	data/archivos/21_593.pdf	1	1	1	2020-10-14 00:00:00
594	18	ficha registral 2018	data/archivos/18_594.pdf	1	1	1	2020-10-14 00:00:00
595	79	escritura publica	data/archivos/79_595.pdf	1	1	1	2020-10-14 00:00:00
597	117	ficha registral 2018	data/archivos/117_597.pdf	1	1	1	2020-10-14 00:00:00
598	117	escritura publica	data/archivos/117_598.pdf	1	1	1	2020-10-14 00:00:00
599	117	resolucion alcaldia	data/archivos/117_599.pdf	1	1	1	2020-10-14 00:00:00
600	117	anotacion de inscripcion 	data/archivos/117_600.pdf	1	1	1	2020-10-14 00:00:00
602	114	ficha registral 2018	data/archivos/114_602.pdf	1	1	1	2020-10-14 00:00:00
603	120	escritura publica	data/archivos/120_603.pdf	1	1	1	2020-10-14 00:00:00
604	120	plano ubicacion 	data/archivos/120_604.pdf	1	1	1	2020-10-14 00:00:00
605	19	escritura publica	data/archivos/19_605.pdf	1	1	1	2020-10-14 00:00:00
606	202	escritura publica	data/archivos/202_606.pdf	1	1	1	2020-10-14 00:00:00
608	254	ficha registral 2019	data/archivos/254_608.pdf	1	1	1	2020-10-14 00:00:00
609	453	constancia de posesion	data/archivos/453_609.pdf	1	1	1	2020-10-14 00:00:00
610	255	ficha registral 2017	data/archivos/255_610.pdf	1	1	1	2020-10-14 00:00:00
611	19	ficha registral año 2018	data/archivos/19_611.pdf	1	1	1	2020-10-14 00:00:00
612	252	escritura publica	data/archivos/252_612.pdf	1	1	1	2020-10-14 00:00:00
613	252	constancia de posesion	data/archivos/252_613.pdf	1	1	1	2020-10-14 00:00:00
614	568	contrato privado de cesion de derecho de posesion	data/archivos/568_614.pdf	1	1	1	2020-10-14 00:00:00
615	202	ficha registral año 2017	data/archivos/202_615.pdf	1	1	1	2020-10-14 00:00:00
616	115	contrato privado de transferencia 	data/archivos/115_616.pdf	1	1	1	2020-10-14 00:00:00
617	115	certificado posesion	data/archivos/115_617.pdf	1	1	1	2020-10-14 00:00:00
618	548	contrato de tranferencia	data/archivos/548_618.pdf	1	1	1	2020-10-14 00:00:00
619	29	escritura publica	data/archivos/29_619.pdf	1	1	1	2020-10-14 00:00:00
620	272	escritura publica	data/archivos/272_620.pdf	1	1	1	2020-10-15 00:00:00
621	452	minuta	data/archivos/452_621.pdf	1	1	1	2020-10-15 00:00:00
622	478	escritura publica	data/archivos/478_622.pdf	1	1	1	2020-10-15 00:00:00
623	252	escritura publica	data/archivos/252_623.pdf	1	1	1	2020-10-15 00:00:00
624	254	escritura publica	data/archivos/254_624.pdf	1	1	1	2020-10-15 00:00:00
625	273	constancia de posesion	data/archivos/273_625.pdf	1	1	1	2020-10-15 00:00:00
626	273	certificado negativo Hno mullisaca	data/archivos/273_626.pdf	1	1	1	2020-10-15 00:00:00
629	273	contrato de acciones  y derechos	data/archivos/273_629.pdf	1	1	1	2020-10-15 00:00:00
630	273	autovaluo 2010	data/archivos/273_630.pdf	1	1	1	2020-10-15 00:00:00
631	251	escritura publica	data/archivos/251_631.pdf	1	1	1	2020-10-15 00:00:00
632	115	constancia de posesion	data/archivos/115_632.pdf	1	1	1	2020-10-15 00:00:00
633	36	recibo de pago del predio	data/archivos/36_633.pdf	1	1	1	2020-10-15 00:00:00
634	36	tarjeta de control	data/archivos/36_634.pdf	1	1	1	2020-10-15 00:00:00
635	36	certificado de posesion	data/archivos/36_635.pdf	1	1	1	2020-10-15 00:00:00
636	36	contrato de luz 	data/archivos/36_636.pdf	1	1	1	2020-10-15 00:00:00
637	548	constancia de posesion	data/archivos/548_637.pdf	1	1	1	2020-10-15 00:00:00
638	548	carta de renuncia	data/archivos/548_638.pdf	1	1	1	2020-10-15 00:00:00
639	18	plano ubicacion 	data/archivos/18_639.pdf	1	1	1	2020-10-15 00:00:00
640	252	carta de reuncia de dueño a favor IASD	data/archivos/252_640.pdf	1	1	1	2020-10-15 00:00:00
641	560	escritura publica	data/archivos/560_641.pdf	1	1	1	2020-10-15 00:00:00
642	353	constancia de posesion	data/archivos/353_642.pdf	1	1	1	2020-10-15 00:00:00
643	353	contrato privado	data/archivos/353_643.pdf	1	1	1	2020-10-15 00:00:00
644	251	licencia construccin año 1989	data/archivos/251_644.pdf	1	1	1	2020-10-15 00:00:00
645	478	plano ubicacion 	data/archivos/478_645.pdf	1	1	1	2020-10-15 00:00:00
646	478	observacion de sunarp	data/archivos/478_646.pdf	1	1	1	2020-10-15 00:00:00
648	252	plano ubicacion 	data/archivos/252_648.pdf	1	1	1	2020-10-15 00:00:00
649	115	contrato de luz 	data/archivos/115_649.pdf	1	1	1	2020-10-15 00:00:00
651	115	autovaluo 2006	data/archivos/115_651.pdf	1	1	1	2020-10-15 00:00:00
652	160	escritura publica 1999	data/archivos/160_652.pdf	1	1	1	2020-10-15 00:00:00
653	160	escritura publica 1968	data/archivos/160_653.pdf	1	1	1	2020-10-15 00:00:00
655	248	autovaluo  año 1995 hau mas pagado en archivoas	data/archivos/248_655.pdf	1	1	1	2020-10-15 00:00:00
656	24	escritura publica	data/archivos/24_656.pdf	1	1	1	2020-10-15 00:00:00
657	24	ficha actualizacion de municipio	data/archivos/24_657.pdf	1	1	1	2020-10-15 00:00:00
658	24	plano ubicacion 	data/archivos/24_658.pdf	1	1	1	2020-10-15 00:00:00
659	24	DNI Vecinos	data/archivos/24_659.pdf	1	1	1	2020-10-15 00:00:00
660	46	contrato de transferen de dominio  municip prov	data/archivos/46_660.pdf	1	1	1	2020-10-15 00:00:00
661	567	escritura publica	data/archivos/567_661.pdf	1	1	1	2020-10-15 00:00:00
662	44	constancia de posesion ficha registral i plano u	data/archivos/44_662.pdf	1	1	1	2020-10-15 00:00:00
663	527	escritura publica	data/archivos/527_663.pdf	1	1	1	2020-10-15 00:00:00
665	42	contrato privado	data/archivos/42_665.pdf	1	1	1	2020-10-15 00:00:00
666	42	plano de ubicacion	data/archivos/42_666.pdf	1	1	1	2020-10-15 00:00:00
667	138	pago de autovaluo año 2008 dueño	data/archivos/138_667.pdf	1	1	1	2020-10-15 00:00:00
668	138	ficha registral a nombre del dueño	data/archivos/138_668.pdf	1	1	1	2020-10-15 00:00:00
669	144	constancia de posesion año 2014	data/archivos/144_669.pdf	1	1	1	2020-10-15 00:00:00
670	138	escritura publica	data/archivos/138_670.pdf	1	1	1	2020-10-15 00:00:00
672	334	plano cruxis	data/archivos/334_672.pdf	1	1	1	2020-10-15 00:00:00
674	304	traspaso terreno juzgado 2011	data/archivos/304_674.pdf	1	1	1	2020-10-15 00:00:00
675	304	certificado posesion	data/archivos/304_675.pdf	1	1	1	2020-10-15 00:00:00
676	304	impuesto predial 2007	data/archivos/304_676.pdf	1	1	1	2020-10-15 00:00:00
677	331	licencia de edificacion  2015	data/archivos/331_677.pdf	1	1	1	2020-10-15 00:00:00
678	331	certificado posesion 2015	data/archivos/331_678.pdf	1	1	1	2020-10-15 00:00:00
679	393	escritura publica	data/archivos/393_679.pdf	1	1	1	2020-10-15 00:00:00
680	496	escritura publica	data/archivos/496_680.pdf	1	1	1	2020-10-15 00:00:00
681	496	foto de hermanos de la iglesia  año 2004	data/archivos/496_681.pdf	1	1	1	2020-10-15 00:00:00
682	309	ficha registral  enero 2020	data/archivos/309_682.pdf	1	1	1	2020-10-15 00:00:00
683	185	escritura publica año 1999	data/archivos/185_683.pdf	1	1	1	2020-10-15 00:00:00
685	300	contrato privado y  acta de enterga predio autonom	data/archivos/300_685.pdf	1	1	1	2020-10-15 00:00:00
686	300	pago de autovaluo año 2008 dueño	data/archivos/300_686.pdf	1	1	1	2020-10-15 00:00:00
688	399	contrato de luz 	data/archivos/399_688.pdf	1	1	1	2020-10-15 00:00:00
689	399	plano ubicacion 	data/archivos/399_689.pdf	1	1	1	2020-10-15 00:00:00
690	177	escritura publica	data/archivos/177_690.pdf	1	1	1	2020-10-15 00:00:00
691	179	escritura publica	data/archivos/179_691.pdf	1	1	1	2020-10-15 00:00:00
692	472	testimonio	data/archivos/472_692.pdf	1	1	1	2020-10-15 00:00:00
693	174	escritura publica 2020-10-16	data/archivos/174_693.pdf	1	1	1	2020-10-16 00:00:00
694	504	inscripcion  sunarp 2019	data/archivos/504_694.pdf	1	1	1	2020-10-19 00:00:00
696	359	ficha registral 2018	data/archivos/359_696.pdf	1	1	1	2020-10-19 00:00:00
697	269	escritura publica	data/archivos/269_697.pdf	1	1	1	2020-10-19 00:00:00
698	164	ficha registral 2019	data/archivos/164_698.pdf	1	1	1	2020-10-19 00:00:00
699	192	ficha registral 2018	data/archivos/192_699.pdf	1	1	1	2020-10-19 00:00:00
701	90	ficha registral 2019	data/archivos/90_701.pdf	1	1	1	2020-10-19 00:00:00
703	171	ficha registral 2019	data/archivos/171_703.pdf	1	1	1	2020-10-19 00:00:00
704	172	ficha registral 2018	data/archivos/172_704.pdf	1	1	1	2020-10-19 00:00:00
705	165	ficha registral 2017	data/archivos/165_705.pdf	1	1	1	2020-10-19 00:00:00
706	196	ficha registral 2019	data/archivos/196_706.pdf	1	1	1	2020-10-19 00:00:00
707	295	ficha registral 2018	data/archivos/295_707.pdf	1	1	1	2020-10-19 00:00:00
708	215	ficha registral 2018	data/archivos/215_708.pdf	1	1	1	2020-10-19 00:00:00
709	496	ficha registral 2018	data/archivos/496_709.pdf	1	1	1	2020-10-19 00:00:00
710	534	ficha registral 2018	data/archivos/534_710.pdf	1	1	1	2020-10-19 00:00:00
711	88	ficha registral 2018	data/archivos/88_711.pdf	1	1	1	2020-10-19 00:00:00
712	158	ficha registral 2018	data/archivos/158_712.pdf	1	1	1	2020-10-19 00:00:00
713	302	ficha registral 2019  febrero sin modificacion de 	data/archivos/302_713.pdf	1	1	1	2020-10-19 00:00:00
714	409	cambio denominacion 2020 octubre	data/archivos/409_714.pdf	1	1	1	2020-10-20 00:00:00
715	107	cambio de denominacio 2020 octubre	data/archivos/107_715.pdf	1	1	1	2020-10-20 00:00:00
716	236	cambio de denominacio 2020 octubre	data/archivos/236_716.pdf	1	1	1	2020-10-20 00:00:00
717	109	cambio de denominacion 2020 octubre	data/archivos/109_717.pdf	1	1	1	2020-10-20 00:00:00
718	413	cambio de denominacio 2020 octubre	data/archivos/413_718.pdf	1	1	1	2020-10-20 00:00:00
719	76	escritura publica	data/archivos/76_719.pdf	1	1	1	2020-10-21 00:00:00
720	292	escritura publica 13-01-1967 dueño	data/archivos/292_720.pdf	1	1	1	2020-10-21 00:00:00
721	292	escritura publica 21-09-1989 IADS	data/archivos/292_721.pdf	1	1	1	2020-10-21 00:00:00
723	290	escritura publica 23-09-1998 dueña	data/archivos/290_723.pdf	1	1	1	2020-10-21 00:00:00
724	290	contrato de promesa de venta  IASD	data/archivos/290_724.pdf	1	1	1	2020-10-21 00:00:00
725	8	escritura publica 19-01-1968 dueña	data/archivos/8_725.pdf	1	1	1	2020-10-21 00:00:00
728	106	cambio de denominacio 2020 octubre	data/archivos/106_728.pdf	1	1	1	2020-10-22 00:00:00
730	350	ficha registral año 2017	data/archivos/350_730.pdf	1	1	1	2020-10-23 00:00:00
731	262	escritura publica	data/archivos/262_731.pdf	1	1	1	2020-10-23 00:00:00
732	524	escritura publica año 2018 IASD	data/archivos/524_732.pdf	1	1	1	2020-10-23 00:00:00
733	524	baucher pago del predio BCP	data/archivos/524_733.pdf	1	1	1	2020-10-23 00:00:00
734	265	titulo cofopri afectacion en u.	data/archivos/265_734.pdf	1	1	1	2020-10-23 00:00:00
735	268	anotacion de inscripcion año 2017	data/archivos/268_735.pdf	1	1	1	2020-10-23 00:00:00
736	263	escritura publica 2005 IASD	data/archivos/263_736.pdf	1	1	1	2020-10-23 00:00:00
737	266	escritura publica 2006 IASD	data/archivos/266_737.pdf	1	1	1	2020-10-23 00:00:00
738	307	fotos recuerdo construccion	data/archivos/307_738.pdf	1	1	1	2020-10-23 00:00:00
739	352	titulo de cofopri dueño	data/archivos/352_739.pdf	1	1	1	2020-10-23 00:00:00
741	265	ficha registral 2018	data/archivos/265_741.pdf	1	1	1	2020-10-23 00:00:00
742	265	acta de adjuditacion  a dueño pero se acumulo	data/archivos/265_742.pdf	1	1	1	2020-10-23 00:00:00
744	350	escritura publica año 2017 IASD	data/archivos/350_744.pdf	1	1	1	2020-10-23 00:00:00
745	102	escritura publica 2001 IASD	data/archivos/102_745.pdf	1	1	1	2020-10-23 00:00:00
746	101	escritura publica 1988 IASD	data/archivos/101_746.pdf	1	1	1	2020-10-23 00:00:00
747	101	contrato privado promesa de venta	data/archivos/101_747.pdf	1	1	1	2020-10-23 00:00:00
748	73	ficha registros 2019 IASD	data/archivos/73_748.pdf	1	1	1	2020-10-23 00:00:00
749	69	ficha registral 2019 	data/archivos/69_749.pdf	1	1	1	2020-10-23 00:00:00
750	237	escritura publica 2001 IASD	data/archivos/237_750.pdf	1	1	1	2020-10-23 00:00:00
751	237	acta de constatacion  juez de paz 2016	data/archivos/237_751.pdf	1	1	1	2020-10-23 00:00:00
752	237	escritura publica dueño 1985 	data/archivos/237_752.pdf	1	1	1	2020-10-23 00:00:00
753	237	ficha registral del dueño 1991	data/archivos/237_753.pdf	1	1	1	2020-10-23 00:00:00
754	237	pago de autovaluo  1993	data/archivos/237_754.pdf	1	1	1	2020-10-23 00:00:00
758	372	resolucion alcaldia 1988 IASD	data/archivos/372_758.pdf	1	1	1	2020-10-23 00:00:00
759	372	certificado de habitabilidad 2002	data/archivos/372_759.pdf	1	1	1	2020-10-23 00:00:00
760	35	escritura publica 2004 IASD	data/archivos/35_760.pdf	1	1	1	2020-10-23 00:00:00
761	307	programa de dedicacion como Iglesia 2009	data/archivos/307_761.pdf	1	1	1	2020-10-27 00:00:00
763	351	adjudicacion munuc compra venta 18-09-1996	data/archivos/351_763.pdf	1	1	1	2020-10-27 00:00:00
764	307	adjudicacion munuc compra venta 18-09-1996	data/archivos/307_764.pdf	1	1	1	2020-10-27 00:00:00
765	256	adjudicacion munuc compra venta 18-09-1996	data/archivos/256_765.pdf	1	1	1	2020-10-27 00:00:00
766	265	ficha registral 2020	data/archivos/265_766.pdf	1	1	1	2020-10-27 00:00:00
767	268	dedicacion Iglesia  2010	data/archivos/268_767.pdf	1	1	1	2020-10-27 00:00:00
768	218	croxis	data/archivos/218_768.pdf	1	1	1	2020-10-27 00:00:00
769	372	constancia  de viviencia  juez de paz 2010	data/archivos/372_769.pdf	1	1	1	2020-10-27 00:00:00
770	270	escritura publica dueño 1999	data/archivos/270_770.pdf	1	1	1	2020-10-27 00:00:00
772	107	resolucion coleg. años 1995-1996-1998-1999	data/archivos/107_772.pdf	1	1	1	2020-10-29 00:00:00
773	64	ficha registral Noviembre 2020	data/archivos/64_773.pdf	1	1	1	2020-11-05 00:00:00
774	320	ficha registral Noviembre 2020	data/archivos/320_774.pdf	1	1	1	2020-11-05 00:00:00
775	319	ficha registral Noviembre 2020	data/archivos/319_775.pdf	1	1	1	2020-11-05 00:00:00
776	62	ficha registral Noviembre 2020	data/archivos/62_776.pdf	1	1	1	2020-11-05 00:00:00
777	60	ficha registral Noviembre 2020	data/archivos/60_777.pdf	1	1	1	2020-11-05 00:00:00
778	293	escritura  	data/archivos/293_778.pdf	1	1	1	2020-11-05 00:00:00
779	293	recibo de agua	data/archivos/293_779.pdf	1	1	1	2020-11-05 00:00:00
781	282	ficha registral 2010	data/archivos/282_781.pdf	1	1	1	2020-11-09 00:00:00
782	219	escritura publica año1994	data/archivos/219_782.pdf	1	1	1	2020-11-09 00:00:00
783	54	escritura publica año 2009	data/archivos/54_783.pdf	1	1	1	2020-11-09 00:00:00
784	54	ficha registral 2010	data/archivos/54_784.pdf	1	1	1	2020-11-09 00:00:00
786	458	certificado zonificador año 2017 y croxis	data/archivos/458_786.pdf	1	1	1	2020-11-09 00:00:00
787	26	minuta 2009 año 2014	data/archivos/26_787.pdf	1	1	1	2020-11-09 00:00:00
788	26	anotacion de inscripcion Sunarp año 2015	data/archivos/26_788.pdf	1	1	1	2020-11-09 00:00:00
789	458	certificado de numeracion  1994	data/archivos/458_789.pdf	1	1	1	2020-11-09 00:00:00
791	458	escritura publica año 1964	data/archivos/458_791.pdf	1	1	1	2020-11-09 00:00:00
794	218	escritura publica año 1994	data/archivos/218_794.pdf	1	1	1	2020-11-09 00:00:00
796	275	adjudicacion 2011	data/archivos/275_796.pdf	1	1	1	2020-11-09 00:00:00
797	59	acta de denuncia  2010	data/archivos/59_797.pdf	1	1	1	2020-11-09 00:00:00
798	78	constancia de posesion 2017	data/archivos/78_798.pdf	1	1	1	2020-11-09 00:00:00
799	307	constancia de cambio  de nombre 2009	data/archivos/307_799.pdf	1	1	1	2020-11-09 00:00:00
800	307	certificado catastral 2005	data/archivos/307_800.pdf	1	1	1	2020-11-09 00:00:00
801	307	cambio de zonificacion 1995	data/archivos/307_801.pdf	1	1	1	2020-11-09 00:00:00
802	307	constancia  Dirigencial 2005	data/archivos/307_802.pdf	1	1	1	2020-11-09 00:00:00
803	307	recibo de agua y luz 	data/archivos/307_803.pdf	1	1	1	2020-11-09 00:00:00
804	307	predial año 2009	data/archivos/307_804.pdf	1	1	1	2020-11-09 00:00:00
805	307	solicitud de itutlacion a Municipio	data/archivos/307_805.pdf	1	1	1	2020-11-09 00:00:00
806	279	cta de compromiso de municipio 2017 	data/archivos/279_806.pdf	1	1	1	2020-11-09 00:00:00
807	23	ficha registral 2018	data/archivos/23_807.pdf	1	1	1	2020-11-09 00:00:00
808	281	ficha registral 2020	data/archivos/281_808.pdf	1	1	1	2020-11-10 00:00:00
809	178	constancia posesion y acta  Juez- a nombre de sosa	data/archivos/178_809.pdf	1	1	1	2020-11-11 00:00:00
810	174	anotacion de  inscripcion sunarp noviembre 2020	data/archivos/174_810.pdf	1	1	1	2020-11-13 00:00:00
811	174	asiento inscrip. compra predio noviembre 2020 	data/archivos/174_811.pdf	1	1	1	2020-11-13 00:00:00
812	142	ficha registral a nombre dueña del predio	data/archivos/142_812.pdf	1	1	1	2020-11-17 00:00:00
813	142	contrato del 2010	data/archivos/142_813.pdf	1	1	1	2020-11-17 00:00:00
814	13	autovaluo 1984	data/archivos/13_814.pdf	1	1	1	2020-11-17 00:00:00
815	13	autovaluo 1984	data/archivos/13_815.pdf	1	1	1	2020-11-17 00:00:00
816	13	titulo municipio 1989	data/archivos/13_816.pdf	1	1	1	2020-11-17 00:00:00
818	580	autovaluo 2000	data/archivos/580_818.pdf	1	1	1	2020-11-17 00:00:00
819	580	contrato 1998	data/archivos/580_819.pdf	1	1	1	2020-11-17 00:00:00
820	580	constancia  de asoc. 1994	data/archivos/580_820.pdf	1	1	1	2020-11-17 00:00:00
821	580	pago de recibo 2004 muniicpio	data/archivos/580_821.pdf	1	1	1	2020-11-17 00:00:00
822	580	inafectacion autovaluo  	data/archivos/580_822.pdf	1	1	1	2020-11-17 00:00:00
823	266	Ficha registral 2020 Noviembre	data/archivos/266_823.pdf	1	1	1	2020-11-19 00:00:00
824	233	Ficha registral 2020 Noviembre	data/archivos/233_824.pdf	1	1	1	2020-11-19 00:00:00
825	267	Ficha registral 2020 Noviembre Evaristo pomari	data/archivos/267_825.pdf	1	1	1	2020-11-19 00:00:00
826	284	Ficha registral 2020 Noviembre Dueño Maquera	data/archivos/284_826.pdf	1	1	1	2020-11-19 00:00:00
827	533	contrato privado  IASD 1987	data/archivos/533_827.pdf	1	1	1	2020-11-23 00:00:00
828	100	escritura publica 2002 dueño	data/archivos/100_828.pdf	1	1	1	2020-11-23 00:00:00
829	100	escritura publica 2003 dueño	data/archivos/100_829.pdf	1	1	1	2020-11-23 00:00:00
830	100	parte notarial 2002 dueño	data/archivos/100_830.pdf	1	1	1	2020-11-23 00:00:00
831	100	testimonio 1976 dueño	data/archivos/100_831.pdf	1	1	1	2020-11-23 00:00:00
832	100	testimonio  primejenia 1976 dueño 	data/archivos/100_832.pdf	1	1	1	2020-11-23 00:00:00
834	100	escritura publica primejenia  dueño	data/archivos/100_834.pdf	1	1	1	2020-11-23 00:00:00
835	100	escritura publica 2014 IASD	data/archivos/100_835.pdf	1	1	1	2020-11-23 00:00:00
836	100	parte 2014 IASD	data/archivos/100_836.pdf	1	1	1	2020-11-23 00:00:00
837	100	planos de ubicacion y resolucion	data/archivos/100_837.pdf	1	1	1	2020-11-23 00:00:00
839	27	ficha registral dueño	data/archivos/27_839.pdf	1	1	1	2020-11-23 00:00:00
840	27	escritura publica primejenia  dueño	data/archivos/27_840.pdf	1	1	1	2020-11-23 00:00:00
841	27	contrato 	data/archivos/27_841.pdf	1	1	1	2020-11-23 00:00:00
842	27	escritura publica IASD	data/archivos/27_842.pdf	1	1	1	2020-11-23 00:00:00
843	27	parte notarial IASD	data/archivos/27_843.pdf	1	1	1	2020-11-23 00:00:00
844	27	planos  y croxis de terreno	data/archivos/27_844.pdf	1	1	1	2020-11-23 00:00:00
845	27	resolucion de predio	data/archivos/27_845.pdf	1	1	1	2020-11-23 00:00:00
846	27	pago de baucher 	data/archivos/27_846.pdf	1	1	1	2020-11-23 00:00:00
847	309	Ficha registral 2020 Noviembre	data/archivos/309_847.pdf	1	1	1	2020-11-23 00:00:00
848	140	titulo adjudicacion Municipio a Dueña 1995	data/archivos/140_848.pdf	1	1	1	2020-11-24 00:00:00
850	74	escritura publica 2015	data/archivos/74_850.pdf	1	1	1	2020-11-25 00:00:00
851	75	escritura publica 2015	data/archivos/75_851.pdf	1	1	1	2020-11-25 00:00:00
852	72	escritura publica 2015	data/archivos/72_852.pdf	1	1	1	2020-11-25 00:00:00
853	355	escritura 2015	data/archivos/355_853.pdf	1	1	1	2020-11-25 00:00:00
854	356	escritura 2015	data/archivos/356_854.pdf	1	1	1	2020-11-25 00:00:00
855	69	titulo cofopri 2003	data/archivos/69_855.pdf	1	1	1	2020-11-25 00:00:00
856	359	descargo de propiedad  2016	data/archivos/359_856.pdf	1	1	1	2020-11-25 00:00:00
857	285	escritura publica 2009	data/archivos/285_857.pdf	1	1	1	2020-11-25 00:00:00
858	71	escritura publica 1999	data/archivos/71_858.pdf	1	1	1	2020-11-25 00:00:00
859	73	autovaluo 1999	data/archivos/73_859.pdf	1	1	1	2020-11-25 00:00:00
861	104	escritura publica1997	data/archivos/104_861.pdf	1	1	1	2020-11-25 00:00:00
863	103	escritura publica 1997 	data/archivos/103_863.pdf	1	1	1	2020-11-25 00:00:00
864	73	autovaluo de varias Iglesias  del año 2005 	data/archivos/73_864.pdf	1	1	1	2020-11-25 00:00:00
865	70	Ficha Registral 26-11-2020	data/archivos/70_865.pdf	1	1	1	2020-11-26 00:00:00
866	89	contrato privado  año 2000 IASD	data/archivos/89_866.pdf	1	1	1	2020-12-03 00:00:00
867	26	escritura publica	data/archivos/26_867.pdf	1	1	1	2020-12-03 00:00:00
868	101	descargo propiedad  IASD  2001	data/archivos/101_868.pdf	1	1	1	2020-12-03 00:00:00
869	101	parte 1988  Año IASD	data/archivos/101_869.pdf	1	1	1	2020-12-03 00:00:00
870	101	pago de autovaluo 1988 IASD	data/archivos/101_870.pdf	1	1	1	2020-12-03 00:00:00
871	274	escritura publica inperfecta Iasd  2002	data/archivos/274_871.pdf	1	1	1	2020-12-03 00:00:00
872	274	nota 	data/archivos/274_872.pdf	1	1	1	2020-12-03 00:00:00
873	81	resolucion alcaldia  parece titulo	data/archivos/81_873.pdf	1	1	1	2020-12-03 00:00:00
874	81	resolucion alcaldia a favor IASD 2001	data/archivos/81_874.pdf	1	1	1	2020-12-03 00:00:00
875	277	contrato privado 1987	data/archivos/277_875.pdf	1	1	1	2020-12-03 00:00:00
876	79	compromiso de venta de predio dueño 1969	data/archivos/79_876.pdf	1	1	1	2020-12-04 00:00:00
877	79	minuta a favor IASD sin firmar 1969	data/archivos/79_877.pdf	1	1	1	2020-12-04 00:00:00
878	79	 autovaluo Corporacion Asc  general IASD 1973 	data/archivos/79_878.pdf	1	1	1	2020-12-04 00:00:00
879	78	planos  y croxis de terreno	data/archivos/78_879.pdf	1	1	1	2020-12-04 00:00:00
880	278	contrato 1973 	data/archivos/278_880.pdf	1	1	1	2020-12-04 00:00:00
881	278	escritura publica inperfecta  año 1972  	data/archivos/278_881.pdf	1	1	1	2020-12-04 00:00:00
882	278	formulario de pago impuesto ministriot E. y Finanz	data/archivos/278_882.pdf	1	1	1	2020-12-04 00:00:00
883	278	escritura publica 2000 	data/archivos/278_883.pdf	1	1	1	2020-12-04 00:00:00
884	77	escritura publica inperfecta 1962	data/archivos/77_884.pdf	1	1	1	2020-12-04 00:00:00
885	77	autovaluo 1973	data/archivos/77_885.pdf	1	1	1	2020-12-04 00:00:00
886	77	escritura publica 2000 	data/archivos/77_886.pdf	1	1	1	2020-12-04 00:00:00
887	85	escritura publica inperfecta  año 2002  	data/archivos/85_887.pdf	1	1	1	2020-12-04 00:00:00
888	85	carta de Hno de iglesia susapaya	data/archivos/85_888.pdf	1	1	1	2020-12-04 00:00:00
889	85	escritura publica de dueños 2008	data/archivos/85_889.pdf	1	1	1	2020-12-04 00:00:00
890	85	titulo cofopri 2006 a dueños	data/archivos/85_890.pdf	1	1	1	2020-12-04 00:00:00
891	85	escritura publica 2012 IASD	data/archivos/85_891.pdf	1	1	1	2020-12-04 00:00:00
892	85	autovaluo pagado por dueño2012	data/archivos/85_892.pdf	1	1	1	2020-12-04 00:00:00
893	233	escritura publica terrno de hno Manuel mesmenbrado	data/archivos/233_893.pdf	1	1	1	2020-12-04 00:00:00
894	115	certificado de posesion de asoc. 2006	data/archivos/115_894.pdf	1	1	1	2020-12-04 00:00:00
895	115	ficha registral matriz 	data/archivos/115_895.pdf	1	1	1	2020-12-04 00:00:00
896	217	escritura publica 2003 dueño	data/archivos/217_896.pdf	1	1	1	2020-12-08 00:00:00
897	460	escritura publica 1er 2002	data/archivos/460_897.pdf	1	1	1	2020-12-08 00:00:00
898	460	escritura publica 2da escritura 2020	data/archivos/460_898.pdf	1	1	1	2020-12-08 00:00:00
899	460	ficha registral 2002	data/archivos/460_899.pdf	1	1	1	2020-12-08 00:00:00
900	53	escritura publica 2007	data/archivos/53_900.pdf	1	1	1	2020-12-08 00:00:00
901	262	ficha registral 2020	data/archivos/262_901.pdf	1	1	2	2020-12-16 17:49:56.397012
902	284	escritura aclaracion dueño 2002	data/archivos/284_902.pdf	1	1	2	2020-12-16 17:57:48.983204
903	284	escritura dueño 2020	data/archivos/284_903.pdf	1	1	2	2020-12-16 17:58:19.596038
904	284	ficha registral 2020 dueño	data/archivos/284_904.pdf	1	1	2	2020-12-16 17:58:55.554111
905	254	ficha registral 2020 declaracion de fabrica	data/archivos/254_905.pdf	1	1	2	2020-12-16 18:00:45.373103
906	269	ficha registral 2020	data/archivos/269_906.pdf	1	1	2	2020-12-16 18:02:49.012906
907	337	escritura publica 2020 IASD	data/archivos/337_907.pdf	1	1	2	2020-12-16 18:04:56.740404
908	24	ficha registral 2020 dueño	data/archivos/24_908.pdf	1	1	2	2020-12-16 18:41:21.106418
910	549	licencia de funcionamiento Marzo 2015	data/archivos/549_910.pdf	1	1	2	2020-12-16 19:45:58.202463
911	458	certificado de defensa civil hasta 2016	data/archivos/458_911.pdf	1	1	2	2020-12-16 19:52:38.146314
912	464	certificado de defensa civil hasta 2016	data/archivos/464_912.pdf	1	1	2	2020-12-16 19:54:46.172787
913	334	ficha registral matriz dueño 2016	data/archivos/334_913.pdf	1	1	2	2020-12-17 07:50:23.399181
914	594	escritura publica 2003 IASD	data/archivos/594_914.pdf	1	1	2	2020-12-17 10:16:36.801332
915	149	escritura 2011 dueño	data/archivos/149_915.pdf	1	1	2	2020-12-17 10:24:21.242936
916	149	antecedentes registrales Sunarp 2007	data/archivos/149_916.pdf	1	1	2	2020-12-17 10:27:47.795398
917	149	plano croxis	data/archivos/149_917.pdf	1	1	2	2020-12-17 10:29:24.995301
918	9	resolucion de alcaldia  2006 IADS	data/archivos/9_918.pdf	1	1	2	2020-12-17 10:42:32.066835
919	9	certificado negativo municipio 2006	data/archivos/9_919.pdf	1	1	2	2020-12-17 10:44:33.553208
920	9	menoria descriptiva plano  informe sunarp esquel observacion 2007	data/archivos/9_920.pdf	1	1	2	2020-12-17 10:49:11.430825
921	9	cargo de enterga documento y declaracion jurada 2006	data/archivos/9_921.pdf	1	1	2	2020-12-17 10:52:11.3077
922	304	pago de predial 2007 al 2011 a nombre de dueño	data/archivos/304_922.pdf	1	1	2	2020-12-17 11:00:38.006302
923	18	escritura 2000 IASD	data/archivos/18_923.pdf	1	1	2	2020-12-17 11:10:31.039827
924	21	resolucion muniicpalidad provincial U:I:IASD 1995	data/archivos/21_924.pdf	1	1	2	2020-12-17 11:19:19.029939
925	21	licencia de construccion 1997	data/archivos/21_925.pdf	1	1	2	2020-12-17 11:20:58.087532
926	17	escritura 1994 AUI IASD	data/archivos/17_926.pdf	1	1	2	2020-12-17 11:52:48.076586
927	17	resolucion inafectacion al predial 2009 de 4 predios	data/archivos/17_927.pdf	1	1	2	2020-12-17 11:55:39.589606
929	107	ficha registral 2020 diciembre	data/archivos/107_929.pdf	1	1	2	2020-12-23 23:44:45.416281
931	487	escritura imperfecta 1987 a.u. incaica IASD	data/archivos/487_931.pdf	1	1	2	2020-12-24 21:17:27.096609
932	287	escritura imperfecta	data/archivos/287_932.pdf	1	1	2	2020-12-24 22:22:58.292148
933	287	escritura 1988 dueños	data/archivos/287_933.pdf	1	1	2	2020-12-24 22:24:05.712871
934	287	autovaluo 2003	data/archivos/287_934.pdf	1	1	2	2020-12-24 22:24:42.616318
935	293	contrato privado dueños 2003	data/archivos/293_935.pdf	1	1	2	2020-12-24 22:48:39.824102
936	293	cata de medidor luz 2003 IASD	data/archivos/293_936.pdf	1	1	2	2020-12-24 22:49:19.994698
937	507	certificado de formalizacion dueño 2005	data/archivos/507_937.pdf	1	1	2	2020-12-24 23:11:03.544017
938	507	plano	data/archivos/507_938.pdf	1	1	2	2020-12-24 23:11:34.006486
939	507	ficha registral IASD 2015	data/archivos/507_939.pdf	1	1	2	2020-12-24 23:12:03.213325
940	298	acta de hnos acuerdo sobre predio 2009	data/archivos/298_940.pdf	1	1	2	2020-12-24 23:17:58.644971
941	295	escritura 2017 IASD	data/archivos/295_941.pdf	1	1	2	2020-12-24 23:34:08.585906
942	286	titulo afcetacion uso 2001 IASD	data/archivos/286_942.pdf	1	1	2	2020-12-24 23:53:48.039658
943	286	plano croxis	data/archivos/286_943.pdf	1	1	2	2020-12-24 23:54:13.019683
944	286	escritura  1978 A:U IASD	data/archivos/286_944.pdf	1	1	2	2020-12-24 23:55:18.506832
945	309	recibo agua 2020-12-	data/archivos/309_945.pdf	1	1	2	2020-12-25 19:25:55.4575
947	588	ficha registral a nombre dueños ojo ver	data/archivos/588_947.pdf	1	1	2	2020-12-26 22:02:07.724163
948	35	ficha registral a nombre de dueños	data/archivos/35_948.pdf	1	1	2	2020-12-26 22:06:53.290852
949	139	ficha registral  IASD	data/archivos/139_949.pdf	1	1	2	2020-12-26 22:19:30.055061
951	27	sentencia para inscribir a Registros publicos dueño	data/archivos/27_951.pdf	1	1	2	2020-12-26 23:06:48.933419
952	55	constancia de posesion 1997 y 2004 IASD y 2002 dueño	data/archivos/55_952.pdf	1	1	2	2020-12-26 23:39:02.961061
953	55	plano de ubicacion	data/archivos/55_953.pdf	1	1	2	2020-12-26 23:39:23.032498
954	129	escritura imperfecta  IASD 1969	data/archivos/129_954.pdf	1	1	2	2020-12-26 23:56:41.219542
955	557	contrato privado y DNI dueños	data/archivos/557_955.pdf	1	1	2	2020-12-27 00:09:35.770444
956	368	autovaluo dueña 1999	data/archivos/368_956.pdf	1	1	2	2020-12-27 00:19:05.652
957	57	certificado  IASD 2004	data/archivos/57_957.pdf	1	1	2	2020-12-27 00:23:40.597169
958	78	acta de reunion de Hnos de Iglesia acuerdo 2017	data/archivos/78_958.pdf	1	1	2	2020-12-27 00:30:49.403643
959	381	constancia de posesion IASD 2016	data/archivos/381_959.pdf	1	1	2	2020-12-27 00:37:58.039593
960	381	plano de localizacion	data/archivos/381_960.pdf	1	1	2	2020-12-27 00:39:45.969895
961	381	DNI del hno que estuvo en tramites del terreno	data/archivos/381_961.pdf	1	1	2	2020-12-27 00:40:49.159435
962	370	acta de entrega de predio 2014 iasd	data/archivos/370_962.pdf	1	1	2	2020-12-27 10:05:34.474308
963	39	acta de adjudicacion  2002 y acta de constatacion juez de paz 2010	data/archivos/39_963.pdf	1	1	2	2020-12-27 10:27:01.405511
964	39	autovaluo 2002-2005	data/archivos/39_964.pdf	1	1	2	2020-12-27 10:39:31.904707
965	276	contrato de compra y venta 1981 IASD	data/archivos/276_965.pdf	1	1	2	2020-12-27 10:44:51.994441
966	499	acta de adjudicacion  2004 IASD	data/archivos/499_966.pdf	1	1	2	2020-12-27 10:51:58.119626
968	505	contrato privado de traspaso de lote 2014 IASD	data/archivos/505_968.pdf	1	1	2	2020-12-27 10:59:30.804952
969	256	resolucion de alcaldia 2004 IASD	data/archivos/256_969.pdf	1	1	2	2020-12-27 11:04:34.150746
970	257	resolucion de lacaldia 2004 IASD	data/archivos/257_970.pdf	1	1	2	2020-12-27 11:05:17.844231
971	61	adjudicacion de compra  1996 IASD	data/archivos/61_971.pdf	1	1	2	2020-12-27 11:11:06.916529
972	283	pago de autovaluo 2000 -  2005 IASD	data/archivos/283_972.pdf	1	1	2	2020-12-27 11:25:20.734579
973	283	recibo de luz  dueño	data/archivos/283_973.pdf	1	1	2	2020-12-27 11:26:46.452575
974	382	acta de acuerdo asoc socios	data/archivos/382_974.pdf	1	1	2	2020-12-27 11:51:10.464397
975	382	constancia de posesion  2018-2018-2009 IASD	data/archivos/382_975.pdf	1	1	2	2020-12-27 11:54:47.928887
976	382	acta de constatacion de juez de paz 2011 IASD	data/archivos/382_976.pdf	1	1	2	2020-12-27 11:56:55.44582
977	382	plano catastral	data/archivos/382_977.pdf	1	1	2	2020-12-27 11:58:29.166445
978	382	respuesta de municipio  ver gob regional	data/archivos/382_978.pdf	1	1	2	2020-12-27 12:03:30.807374
979	140	certificado de posesion dueña  2009	data/archivos/140_979.pdf	1	1	2	2020-12-27 13:02:07.218961
980	140	autovaluo  dueño vivanco 2016	data/archivos/140_980.pdf	1	1	2	2020-12-27 13:04:39.699753
981	130	contrato de donacion 1986 IASD	data/archivos/130_981.pdf	1	1	2	2020-12-27 13:08:46.205625
982	86	certificado de posesion 2015 IASD	data/archivos/86_982.pdf	1	1	2	2020-12-27 13:34:40.607202
983	86	certificado posesion 2011 IAS	data/archivos/86_983.pdf	1	1	2	2020-12-27 13:36:13.006639
984	86	certificado posesion 2015 IASD	data/archivos/86_984.pdf	1	1	2	2020-12-27 13:38:05.97997
985	86	autovaluo 2015 IASD	data/archivos/86_985.pdf	1	1	2	2020-12-27 13:40:36.19732
986	86	plano ubicacion	data/archivos/86_986.pdf	1	1	2	2020-12-27 13:42:16.821886
987	186	escritura publica 2000 IASD	data/archivos/186_987.pdf	1	1	2	2020-12-27 14:09:06.102684
988	186	pago arbitrios IASD 2013	data/archivos/186_988.pdf	1	1	2	2020-12-27 14:10:46.206605
989	186	plano ubicacion	data/archivos/186_989.pdf	1	1	2	2020-12-27 14:12:23.043886
990	198	resolucion municipal 1991 IASD	data/archivos/198_990.pdf	1	1	2	2020-12-27 14:20:10.243976
991	198	certificado municipal 2000	data/archivos/198_991.pdf	1	1	2	2020-12-27 14:27:40.801493
992	198	autovaluo 1989-1999- 2000 IASD	data/archivos/198_992.pdf	1	1	2	2020-12-27 14:35:11.879871
993	463	escritura cesion de derecho Dueño 2013	data/archivos/463_993.pdf	1	1	2	2020-12-27 14:55:23.700114
994	463	escritura publica 2013 IASD	data/archivos/463_994.pdf	1	1	2	2020-12-27 14:58:52.967015
995	300	contrato de cancelacion levantamiento  hipoteca  Dueño	data/archivos/300_995.pdf	1	1	2	2020-12-27 15:25:50.383729
996	300	acta de entrega de lote  Autodema dueño 1990	data/archivos/300_996.pdf	1	1	2	2020-12-27 15:30:15.508225
997	300	autovaluo 2010 IASD	data/archivos/300_997.pdf	1	1	2	2020-12-27 15:32:06.999818
998	185	recibo de pago autodema 1989  dueña	data/archivos/185_998.pdf	1	1	2	2020-12-27 15:58:47.504983
999	179	contrato adjudicacion  dueña 1988 autodema	data/archivos/179_999.pdf	1	1	2	2020-12-27 16:03:41.511204
1000	179	recibos de pago autodema y impuesto de la tranferencia 1988	data/archivos/179_1000.pdf	1	1	2	2020-12-27 16:09:29.476163
1001	389	contrato de compra y venta 2017 IASD	data/archivos/389_1001.pdf	1	1	2	2020-12-27 16:24:52.873672
1002	389	contrato de cesiion de derechos  Dueña 2013	data/archivos/389_1002.pdf	1	1	2	2020-12-27 16:30:00.982536
1003	389	carta de renuncia de la dueña del predio a la asoc. a favor IASD	data/archivos/389_1003.pdf	1	1	2	2020-12-27 16:33:45.362115
1004	389	constancia de posesion2011- certif domiciliado -declaracion jurada Dueña	data/archivos/389_1004.pdf	1	1	2	2020-12-27 16:37:20.148176
1005	389	chueque por la compra a favro de dueña jesusa caucca	data/archivos/389_1005.pdf	1	1	2	2020-12-27 16:39:21.280278
1006	310	certificado de posesion  a dueños 2014	data/archivos/310_1006.pdf	1	1	2	2020-12-27 16:49:06.379849
1007	310	constancia  de posesion de juzgado   2014	data/archivos/310_1007.pdf	1	1	2	2020-12-27 16:53:07.021265
1008	310	denuncias de comisaria y fiscalia par desalojo	data/archivos/310_1008.pdf	1	1	2	2020-12-27 16:56:03.856672
1009	310	escritura a favor IASD 2017	data/archivos/310_1009.pdf	1	1	2	2020-12-27 17:10:44.230505
1010	180	contrato de adjudicacion de autodema a dueña	data/archivos/180_1010.pdf	1	1	2	2020-12-27 17:18:10.197904
1011	180	contrato de compra y venta  IASD 2009	data/archivos/180_1011.pdf	1	1	2	2020-12-27 17:21:25.644912
1012	455	constancia de posesion dueño 2013	data/archivos/455_1012.pdf	1	1	2	2020-12-27 17:33:56.695977
1013	455	ficha registral  anombre asoc granjeros	data/archivos/455_1013.pdf	1	1	2	2020-12-27 17:41:09.578148
1014	455	acta de instalacion  y acuerdo de la asoc	data/archivos/455_1014.pdf	1	1	2	2020-12-27 17:43:47.450957
1015	455	planos de ubicacion varios	data/archivos/455_1015.pdf	1	1	2	2020-12-27 17:48:55.170663
1016	181	acta de instalacion entrega y transferencia de del predio autodema	data/archivos/181_1016.pdf	1	1	2	2020-12-27 18:21:54.868112
1017	181	contrato de compra  venta de derecho y acciones  a chino colquehuanca	data/archivos/181_1017.pdf	1	1	2	2020-12-27 18:27:59.695867
1018	181	recibo de cancelacion a dueño del predio	data/archivos/181_1018.pdf	1	1	2	2020-12-27 18:30:21.801134
1019	181	pago a autodema recibo dueños	data/archivos/181_1019.pdf	1	1	2	2020-12-27 18:33:29.803599
1020	175	escritura publica de dueños 2000	data/archivos/175_1020.pdf	1	1	2	2020-12-28 21:37:58.439593
1021	175	ficha registral de dueños y certificado medico	data/archivos/175_1021.pdf	1	1	2	2020-12-28 21:39:59.249385
1022	175	escritura publica  2001 IASD	data/archivos/175_1022.pdf	1	1	2	2020-12-28 21:40:39.76465
1023	175	sunarp observacion a dueños  2000	data/archivos/175_1023.pdf	1	1	2	2020-12-28 21:43:03.970087
1024	69	solicitud terreno a alcalde 2000	data/archivos/69_1024.pdf	1	1	2	2020-12-29 08:16:57.518749
1025	69	fotos no se sabe si corresponde a la iglesia	data/archivos/69_1025.pdf	1	1	2	2020-12-29 08:18:38.686945
1026	284	primera junta directiva de la Iglesia IASD 2001	data/archivos/284_1026.pdf	1	1	2	2020-12-29 08:20:11.651712
1027	265	foto de lideres	data/archivos/265_1027.pdf	1	1	2	2020-12-29 08:23:41.695227
1028	68	reseña historica Igle. documentos y fotos primeros pioneros 2002	data/archivos/68_1028.pdf	1	1	2	2020-12-29 08:39:39.490522
1029	182	certificado municipio 2017--2012 IASD	data/archivos/182_1029.pdf	1	1	2	2020-12-29 09:02:16.369906
1030	182	autovaluo años 2014 -2010 IASD	data/archivos/182_1030.pdf	1	1	2	2020-12-29 09:03:06.970047
1031	182	recibos de agua y luz	data/archivos/182_1031.pdf	1	1	2	2020-12-29 09:03:28.013349
1032	305	certificado posesion 2012 IASD	data/archivos/305_1032.pdf	1	1	2	2020-12-29 09:25:06.678793
1033	305	autovaluo 2010 IASD	data/archivos/305_1033.pdf	1	1	2	2020-12-29 09:25:37.330936
1034	305	recibo de luz IASD	data/archivos/305_1034.pdf	1	1	2	2020-12-29 09:26:13.225345
1035	305	reseña historica  primeros lideres  Documentos	data/archivos/305_1035.pdf	1	1	2	2020-12-29 09:26:58.687368
1036	480	contrato privado donacion 2017 IASD	data/archivos/480_1036.pdf	1	1	2	2020-12-29 09:37:27.34205
1037	183	solicitud a cofopri 1999	data/archivos/183_1037.pdf	1	1	2	2020-12-29 09:46:00.214619
1038	183	planos de ubicacion elaborado por el hno luciano curo cayo	data/archivos/183_1038.pdf	1	1	2	2020-12-29 09:46:55.486476
1039	306	contrato de tranf acciones derech IASD 2009	data/archivos/306_1039.pdf	1	1	2	2020-12-29 09:54:32.8743
1040	173	ficha registral dueño	data/archivos/173_1040.pdf	1	1	2	2020-12-29 10:01:43.86107
1042	464	licencia de funcionamiento	data/archivos/464_1042.pdf	1	1	2	2020-12-30 20:26:18.659416
1043	464	certificdo defensa civil 2017 al 2019	data/archivos/464_1043.pdf	1	1	2	2020-12-30 20:26:56.127186
1044	464	resoluciones y ampliaciones de los años 1952 al 2014	data/archivos/464_1044.pdf	1	1	2	2020-12-30 20:28:05.522529
1045	161	escritura IASD 2006	data/archivos/161_1045.pdf	1	1	2	2020-12-30 20:43:36.164564
1046	161	contrato de tranferencia a IASD 1995	data/archivos/161_1046.pdf	1	1	2	2020-12-30 20:44:21.822595
1047	161	titulo otorgado por cofopri IASD 1998	data/archivos/161_1047.pdf	1	1	2	2020-12-30 20:45:01.6162
1048	159	escritura publica IASD 1985	data/archivos/159_1048.pdf	1	1	2	2020-12-30 21:15:50.951299
1050	534	escritura publica  IASD 2016	data/archivos/534_1050.pdf	1	1	2	2020-12-30 21:52:07.603438
1051	158	escritura publica IASD 1999	data/archivos/158_1051.pdf	1	1	2	2020-12-30 22:06:49.29287
1052	158	resolucion licencia edificacion 2015 IASD	data/archivos/158_1052.pdf	1	1	2	2020-12-30 22:07:50.883614
1053	160	escritura 1989 IASD	data/archivos/160_1053.pdf	1	1	2	2020-12-30 22:36:28.079265
1054	160	minuta del municipio a favor IASD 1990	data/archivos/160_1054.pdf	1	1	2	2020-12-30 22:38:17.606872
1055	285	contrato compra venta año 2000  IASD	data/archivos/285_1055.pdf	1	1	2	2021-01-06 20:42:49.57479
1056	285	Anotacion de Inscripcion 2009 IASD	data/archivos/285_1056.pdf	1	1	2	2021-01-06 20:43:26.393556
1057	50	Resolucion del alcaldia 2009 IASD	data/archivos/50_1057.pdf	1	1	2	2021-01-06 21:23:58.089134
1058	50	constancia de posesion de terreno  Poder judicial 2014	data/archivos/50_1058.pdf	1	1	2	2021-01-06 21:25:38.642111
1059	50	certificado de posesion  Municipalidad 2015 IASD	data/archivos/50_1059.pdf	1	1	2	2021-01-06 21:26:39.617574
1060	50	recibo de pago Municipio 2004 -IASD  S/ 100.00 soles	data/archivos/50_1060.pdf	1	1	2	2021-01-06 21:27:53.307496
1061	48	escritura publica 2010 IASD	data/archivos/48_1061.pdf	1	1	2	2021-01-06 21:48:27.550103
1062	112	escritura publica IASD 2008	data/archivos/112_1062.pdf	1	1	2	2021-01-06 22:14:24.104872
1064	35	certificado catastral positivo sunarp 2006	data/archivos/35_1064.pdf	1	1	2	2021-01-09 13:36:25.197926
1066	506	vigencia de poder que otorga dueño del predio a favror de L.conde	data/archivos/506_1066.pdf	1	1	2	2021-01-09 13:52:09.230828
1067	191	contrato transferencia 1988 IASD	data/archivos/191_1067.pdf	1	1	2	2021-01-09 14:32:22.328594
1068	191	pago de autovaluo  1988 IASD	data/archivos/191_1068.pdf	1	1	2	2021-01-09 14:33:03.823423
1069	191	parte notarial  2012 IASD	data/archivos/191_1069.pdf	1	1	2	2021-01-09 14:33:57.764313
1070	191	escritura publica  2012 IASD  Pr Abel supanta no tienes poder	data/archivos/191_1070.pdf	1	1	2	2021-01-09 14:35:21.934262
1071	190	Iglesia principal de mollendo escritura Publica 1976 IASD Pr Cayrus	data/archivos/190_1071.pdf	1	1	2	2021-01-09 14:51:05.298148
1072	195	escritura publica IASD 2002	data/archivos/195_1072.pdf	1	1	2	2021-01-09 15:16:43.305112
1073	195	anotacion de inscripcion sunarp IASD 2002	data/archivos/195_1073.pdf	1	1	2	2021-01-09 15:17:18.005672
1074	401	escritura publica 2014 nombre pr Valenzuela  falta trasnf. IASD	data/archivos/401_1074.pdf	1	1	2	2021-01-09 15:41:35.681026
1075	193	testimonio escrito a mano 1959 corporacion ASD	data/archivos/193_1075.pdf	1	1	2	2021-01-09 15:55:34.841369
1076	193	escritura a maquina sin firma aclaracion  de anterior escritura mano	data/archivos/193_1076.pdf	1	1	2	2021-01-09 15:57:20.636231
1077	193	autovaluo b 2001 IASD  y recibos de Agua Y Luz 2001	data/archivos/193_1077.pdf	1	1	2	2021-01-09 15:58:35.721046
1078	192	escritura publica 1976 IASD	data/archivos/192_1078.pdf	1	1	2	2021-01-09 16:10:35.425959
1079	192	autoavaluo 1996 IASD	data/archivos/192_1079.pdf	1	1	2	2021-01-09 16:11:57.052301
1080	404	parte notarial IASD  2016	data/archivos/404_1080.pdf	1	1	2	2021-01-09 16:21:55.113222
1081	404	escritura publica 2016 IASD	data/archivos/404_1081.pdf	1	1	2	2021-01-09 16:22:39.14705
1082	241	certificado otorga COOperativa a favor de IASD 1982	data/archivos/241_1082.pdf	1	1	2	2021-01-09 17:05:51.130396
1083	241	acta  de asamblea  acuerdo tranferencia predio a IASD 1982	data/archivos/241_1083.pdf	1	1	2	2021-01-09 17:10:02.509443
1084	241	planos y memoria decriptiva	data/archivos/241_1084.pdf	1	1	2	2021-01-09 17:12:13.767207
1085	240	contrato de traspaso  de propietario a pr edgar lizandro 2011	data/archivos/240_1085.pdf	1	1	2	2021-01-09 17:19:39.053804
1086	240	escritura publica  a IASD 2016	data/archivos/240_1086.pdf	1	1	2	2021-01-09 17:20:45.279068
1087	436	tranferencia posesion juzgado de paz a Lurdes a Victoria 2014	data/archivos/436_1087.pdf	1	1	2	2021-01-09 17:39:42.198372
1088	436	acta de constatacion de posesion maria juana 2015	data/archivos/436_1088.pdf	1	1	2	2021-01-09 17:41:02.983513
1089	436	constancia de socio 2019 victoria Maria  del Pino	data/archivos/436_1089.pdf	1	1	2	2021-01-09 17:41:59.845573
1090	436	memoria descriptiva y planos 2014	data/archivos/436_1090.pdf	1	1	2	2021-01-09 17:42:51.903901
1091	436	certificado negativo de propiedad a alicia del pino 2015	data/archivos/436_1091.pdf	1	1	2	2021-01-09 17:43:49.301041
1092	239	constancia  de Valentin  Cunurana  1996	data/archivos/239_1092.pdf	1	1	2	2021-01-09 17:57:57.939948
1093	239	carta de renuncia  valentin c. favor IASD 1997	data/archivos/239_1093.pdf	1	1	2	2021-01-09 17:59:07.687892
1094	239	contrato de traspaso  valentin a favro de IASD 1997	data/archivos/239_1094.pdf	1	1	2	2021-01-09 18:00:36.887311
1095	239	escritura publica  IASD 2015	data/archivos/239_1095.pdf	1	1	2	2021-01-09 18:01:29.659008
1096	37	certificado  catastral  y plano ubicacion	data/archivos/37_1096.pdf	1	1	2	2021-01-09 18:16:41.319229
1097	37	ficha registral IASD 1999	data/archivos/37_1097.pdf	1	1	2	2021-01-09 18:17:48.461989
1098	37	escritura publica  IASD 1997	data/archivos/37_1098.pdf	1	1	2	2021-01-09 18:18:56.796546
1099	317	acta de asamblea general de ooperativa 1992 a favor Adra	data/archivos/317_1099.pdf	1	1	2	2021-01-11 13:44:58.819729
1100	317	escritura publica 1980 a favor IASD	data/archivos/317_1100.pdf	1	1	2	2021-01-11 13:46:13.714294
1101	317	plano	data/archivos/317_1101.pdf	1	1	2	2021-01-11 13:46:42.510777
1102	165	oficio pedido de terreno  1991 ycertificado  afavor IASD	data/archivos/165_1102.pdf	1	1	2	2021-01-11 14:11:45.562005
1103	171	escritura publica dueñ  1994	data/archivos/171_1103.pdf	1	1	2	2021-01-11 14:37:52.71132
1104	171	escritura publica a favor IASD 1994	data/archivos/171_1104.pdf	1	1	2	2021-01-11 14:38:51.810542
1105	171	Anotacion inscripcion de sunarp IASD 2009	data/archivos/171_1105.pdf	1	1	2	2021-01-11 14:39:51.240706
1106	169	certificados de posesion de dueño 2000y 2002	data/archivos/169_1106.pdf	1	1	2	2021-01-11 15:41:27.251302
1107	169	transferencia  dueños  de chacra 2004	data/archivos/169_1107.pdf	1	1	2	2021-01-11 15:42:45.626681
1108	169	constancia de posesion de comunidad a IASD 2004	data/archivos/169_1108.pdf	1	1	2	2021-01-11 15:44:30.762014
1109	169	plano croxis	data/archivos/169_1109.pdf	1	1	2	2021-01-11 15:44:59.092007
1110	169	ficha registral sunarp comunidad campesimo	data/archivos/169_1110.pdf	1	1	2	2021-01-11 15:46:18.825917
1111	169	contrato de transferencia  IASD 2004	data/archivos/169_1111.pdf	1	1	2	2021-01-11 15:47:14.359806
1112	169	parte  escritura a favro IASD 2003	data/archivos/169_1112.pdf	1	1	2	2021-01-11 15:48:34.205073
1113	169	escritura poblica por la cancelacion de deuda IASD 2004	data/archivos/169_1113.pdf	1	1	2	2021-01-11 15:49:08.458696
1114	168	escritora publica  IASD 1978	data/archivos/168_1114.pdf	1	1	2	2021-01-11 16:24:46.104493
1115	168	ficha registral sunarp dueños	data/archivos/168_1115.pdf	1	1	2	2021-01-11 16:25:13.237037
1116	164	escritura publica  IASD 2014	data/archivos/164_1116.pdf	1	1	2	2021-01-11 16:36:41.002823
1117	164	transfrerencia reconocimiento sobre area desmenbrar posterior	data/archivos/164_1117.pdf	1	1	2	2021-01-11 16:37:51.880398
1118	163	titulo cofopri dueño 2000	data/archivos/163_1118.pdf	1	1	2	2021-01-11 17:02:32.03852
1119	163	escrituta publica permuta  IASD 2005	data/archivos/163_1119.pdf	1	1	2	2021-01-11 17:03:55.511228
1120	163	anotacion de inscripcion a favor IASD 2002	data/archivos/163_1120.pdf	1	1	2	2021-01-11 17:05:12.626936
1121	172	escritura publica IASD 2000	data/archivos/172_1121.pdf	1	1	2	2021-01-11 17:36:40.985047
1122	172	titulo cofopri IASD 1998	data/archivos/172_1122.pdf	1	1	2	2021-01-11 17:37:14.81707
1123	258	escritura publica IASD 2002	data/archivos/258_1123.pdf	1	1	2	2021-01-11 18:04:17.117903
1124	259	titulo de inscripcion IASD 2002	data/archivos/259_1124.pdf	1	1	2	2021-01-11 18:13:20.767115
1125	259	escritura publica IASD 2002	data/archivos/259_1125.pdf	1	1	2	2021-01-11 18:13:48.277187
1126	257	Registros publicos  IASD 2003	data/archivos/257_1126.pdf	1	1	2	2021-01-11 18:31:19.709405
1127	257	escritura publica IASD 2002	data/archivos/257_1127.pdf	1	1	2	2021-01-11 18:31:58.345308
1128	260	escritura  publica IASD 2003	data/archivos/260_1128.pdf	1	1	2	2021-01-11 18:39:13.194746
1129	260	anotacion de inscripcion  IASD 2005	data/archivos/260_1129.pdf	1	1	2	2021-01-11 18:39:52.226131
1130	256	constacia registrado en registros publicos  1999	data/archivos/256_1130.pdf	1	1	2	2021-01-11 18:55:02.196871
1131	256	titulo propiedad otorgdo municipio IASD 1999	data/archivos/256_1131.pdf	1	1	2	2021-01-11 18:55:54.417006
1135	42	certificados de poesesion años 2010-2012 -2013 IASD	data/archivos/42_1135.pdf	1	1	2	2021-01-11 20:05:08.815431
1136	44	escritura publica 1997 iasd	data/archivos/44_1136.pdf	1	1	2	2021-01-11 20:18:17.95849
1137	44	constancia de posesion  2013 con error	data/archivos/44_1137.pdf	1	1	2	2021-01-11 20:19:08.548781
1138	45	titulo provisorio dueño 1967	data/archivos/45_1138.pdf	1	1	2	2021-01-11 20:52:24.808896
1139	45	minuta de transferencia  de predio dueño 1972	data/archivos/45_1139.pdf	1	1	2	2021-01-11 20:53:27.220255
1140	45	acta de asamblea  de socios acuerdo aceptar a IASD como socio 1997	data/archivos/45_1140.pdf	1	1	2	2021-01-11 20:54:23.854483
1141	45	acta de asamblea  de socios acuerdo aceptar a IASD como socio 1997	data/archivos/45_1141.pdf	1	1	2	2021-01-11 20:54:25.879039
1142	45	minuta de compra  IASD 1990	data/archivos/45_1142.pdf	1	1	2	2021-01-11 20:55:28.443982
1143	45	docuemnto compromiso de honor Hijo del dueño y IASD 1999	data/archivos/45_1143.pdf	1	1	2	2021-01-11 20:56:20.917938
1145	47	contrato de transferencia dueños 1998	data/archivos/47_1145.pdf	1	1	2	2021-01-11 21:25:52.731412
1146	47	escritura publica IASD 2000	data/archivos/47_1146.pdf	1	1	2	2021-01-11 21:26:38.445479
1147	47	constancia de inscripcion a registros publico 2003	data/archivos/47_1147.pdf	1	1	2	2021-01-11 21:27:22.615224
1148	47	croxis  2000	data/archivos/47_1148.pdf	1	1	2	2021-01-11 21:27:51.26567
1149	43	resolucion municipio a favro IASD 1989	data/archivos/43_1149.pdf	1	1	2	2021-01-11 21:35:28.916901
1150	43	Parte  ingersado aregistros publicos a favor IASD 1989	data/archivos/43_1150.pdf	1	1	2	2021-01-11 21:37:28.759758
1151	252	vigencia poder otorgado de eleuterio  cari a favro L Conde q.	data/archivos/252_1151.pdf	1	1	2	2021-01-11 21:59:49.063134
1153	65	escritura publica  IASD 1998	data/archivos/65_1153.pdf	1	1	2	2021-01-12 07:49:45.146849
1154	65	escritura publica aclaracion  y confirmacion de acto IASD 1998	data/archivos/65_1154.pdf	1	1	2	2021-01-12 07:51:03.279954
1155	65	Ficha registral IASD antigua	data/archivos/65_1155.pdf	1	1	2	2021-01-12 07:51:43.204857
1156	303	escritura publica IASD 2011	data/archivos/303_1156.pdf	1	1	2	2021-01-12 08:06:00.630026
1157	303	anotacion de inscripcion Sunarp 2011 IASD	data/archivos/303_1157.pdf	1	1	2	2021-01-12 08:06:36.396814
1158	364	minuta de compra y venta  IASD 2000	data/archivos/364_1158.pdf	1	1	2	2021-01-12 08:18:49.460866
1159	364	escritura publica IASD 2006	data/archivos/364_1159.pdf	1	1	2	2021-01-12 08:19:52.109576
1160	364	escritura publica de aclaracion 2006 IASD	data/archivos/364_1160.pdf	1	1	2	2021-01-12 08:20:49.546439
1161	66	Resolucion de alcaldia  A nombre Municipio 1999	data/archivos/66_1161.pdf	1	1	2	2021-01-12 08:35:04.286002
1162	66	palno de ubicacion	data/archivos/66_1162.pdf	1	1	2	2021-01-12 08:35:30.115701
1163	66	foto de construccion IASD 2003	data/archivos/66_1163.pdf	1	1	2	2021-01-12 08:36:16.644455
1164	66	foto construccion 2003	data/archivos/66_1164.pdf	1	1	2	2021-01-12 08:36:41.829634
1165	34	titulo de propiedad  resolucion muniicpio IASD 1991	data/archivos/34_1165.pdf	1	1	2	2021-01-12 08:45:24.525935
1166	34	ficha registral Iasd  pasado 1999	data/archivos/34_1166.pdf	1	1	2	2021-01-12 08:46:07.362569
1167	64	planos ubicacion	data/archivos/64_1167.pdf	1	1	2	2021-01-12 08:59:37.327661
1168	62	acta de entrega a pr Saito predio 1984	data/archivos/62_1168.pdf	1	1	2	2021-01-12 11:30:40.566855
1169	62	escritura publica  IASD 1998	data/archivos/62_1169.pdf	1	1	2	2021-01-12 11:32:42.03782
1170	188	acta  acuerdo de Iglesia Donacion de predio Hna Eustaquia useda	data/archivos/188_1170.pdf	1	1	2	2021-01-12 12:07:24.318623
1171	188	minuta   IASD 1994	data/archivos/188_1171.pdf	1	1	2	2021-01-12 12:08:35.006335
1172	188	escritura publica  de donacion 2005 IASD	data/archivos/188_1172.pdf	1	1	2	2021-01-12 12:09:16.123978
1173	318	documento de trasferencia 1967 dueño	data/archivos/318_1173.pdf	1	1	2	2021-01-12 12:19:17.378465
1174	318	escritura publica IASD 2003	data/archivos/318_1174.pdf	1	1	2	2021-01-12 12:20:07.806381
1176	197	Impuesto alcabala IASD 1999	data/archivos/197_1176.pdf	1	1	2	2021-01-12 12:37:17.562838
1177	197	recibo de agua y luz 2001  IASD agua dueño 2001	data/archivos/197_1177.pdf	1	1	2	2021-01-12 12:38:30.718451
1178	197	predial IASD 1992 y 2005	data/archivos/197_1178.pdf	1	1	2	2021-01-12 12:39:20.51687
1179	197	contrato de transferencia de predio IASD 1995	data/archivos/197_1179.pdf	1	1	2	2021-01-12 12:40:14.526743
1180	187	escritura publica  IASD 1993	data/archivos/187_1180.pdf	1	1	2	2021-01-12 12:51:08.599312
1181	187	connstancia  registral  IASD 1998	data/archivos/187_1181.pdf	1	1	2	2021-01-12 12:51:43.975514
1182	187	anotacion de inscripcion  sunaro 2009 IASD	data/archivos/187_1182.pdf	1	1	2	2021-01-12 12:52:19.953082
1183	196	ficha de desmenbracion predio dueña Hna 2002	data/archivos/196_1183.pdf	1	1	2	2021-01-12 13:22:30.213566
1184	196	escritura publica IASD 200o	data/archivos/196_1184.pdf	1	1	2	2021-01-12 13:23:51.976753
1185	196	escritura publica aclaracion IASD 2000	data/archivos/196_1185.pdf	1	1	2	2021-01-12 13:24:24.956472
1186	196	asiento de inscripcion SunarpIASD 2000	data/archivos/196_1186.pdf	1	1	2	2021-01-12 13:25:16.650559
1187	351	titulo por cofopri afectacion en uso IASD 2018	data/archivos/351_1187.pdf	1	1	2	2021-01-12 13:36:00.713905
1188	467	escritura publica IASD 2005	data/archivos/467_1188.pdf	1	1	2	2021-01-12 13:53:32.60522
1189	467	croxis	data/archivos/467_1189.pdf	1	1	2	2021-01-12 13:54:29.126307
1190	352	escritura publica IASD 2006	data/archivos/352_1190.pdf	1	1	2	2021-01-12 14:26:05.499541
1191	352	escritura publica aclaracion IASD 2007	data/archivos/352_1191.pdf	1	1	2	2021-01-12 14:30:37.454979
1192	352	anotacion de inscripcion Sunarp 2006 IASD	data/archivos/352_1192.pdf	1	1	2	2021-01-12 14:31:27.883299
1193	268	escritura publica IASD 2017	data/archivos/268_1193.pdf	1	1	2	2021-01-12 15:00:17.96862
1194	250	escritura publica IASD 1994	data/archivos/250_1194.pdf	1	1	2	2021-01-12 15:24:09.757787
1195	250	anotacion de inscripcion IASD 2009	data/archivos/250_1195.pdf	1	1	2	2021-01-12 15:24:54.017953
1196	230	escritura publica IASD 2019 prescripcion	data/archivos/230_1196.pdf	1	1	2	2021-01-12 15:46:39.81855
1197	230	anotacion de inscripcion 2019 IASD	data/archivos/230_1197.pdf	1	1	2	2021-01-12 15:47:08.337922
1198	545	escritura publica IASD 2003	data/archivos/545_1198.pdf	1	1	2	2021-01-12 15:53:26.045531
1199	545	anotacion de inscripcion Sunarp IASD 2005	data/archivos/545_1199.pdf	1	1	2	2021-01-12 15:54:01.467579
1200	232	contrato de transferencia a favor de Abel Alfredo supanta 2010	data/archivos/232_1200.pdf	1	1	2	2021-01-12 15:58:59.033235
1201	479	escritura imperfecta  compra V. dueños anteriores 2002	data/archivos/479_1201.pdf	1	1	2	2021-01-12 16:13:44.339517
1202	479	impuesto predial  dueños 2002	data/archivos/479_1202.pdf	1	1	2	2021-01-12 16:14:25.699272
1203	479	escritura publica IASD 2003	data/archivos/479_1203.pdf	1	1	2	2021-01-12 16:15:41.11064
1204	248	constancia posesion otorga asoc urbanizadora IASD 1986	data/archivos/248_1204.pdf	1	1	2	2021-01-12 16:35:17.546097
1205	248	escritura IASD 1998	data/archivos/248_1205.pdf	1	1	2	2021-01-12 16:36:33.403379
1206	248	Licencia de construccion  1987 IASD	data/archivos/248_1206.pdf	1	1	2	2021-01-12 16:47:58.720956
1207	248	notificacion municipio IASD 2007	data/archivos/248_1207.pdf	1	1	2	2021-01-12 16:49:26.30551
1208	248	escritura publica IASD 1994	data/archivos/248_1208.pdf	1	1	2	2021-01-12 16:50:20.867585
1209	249	constancia de inscripcion de predio registros publicos IASD 2003	data/archivos/249_1209.pdf	1	1	2	2021-01-12 16:58:13.357806
1210	200	escritura publica IASD 1995	data/archivos/200_1210.pdf	1	1	2	2021-01-14 16:09:06.355196
1211	200	ficha registral  IASD 2009	data/archivos/200_1211.pdf	1	1	2	2021-01-14 16:10:27.257118
1212	352	anota de inscripcion cambio de titularidad 2021	data/archivos/352_1212.pdf	1	1	2	2021-01-14 16:12:33.762895
1213	199	Testimonio  de dueños 1946	data/archivos/199_1213.pdf	1	1	2	2021-01-14 17:46:39.550265
1214	199	escritura publica 1960 conferencia General IASD	data/archivos/199_1214.pdf	1	1	2	2021-01-14 17:48:47.981504
1215	199	escritura publica transcribirlo a limpio 1960 onferencia G IASD	data/archivos/199_1215.pdf	1	1	2	2021-01-14 17:50:52.666794
1216	199	certificado de numeracion Municipio IASD 2000	data/archivos/199_1216.pdf	1	1	2	2021-01-14 17:53:03.966232
1217	199	escritura P. General conference a  asoc union Peruana de IASD 2000	data/archivos/199_1217.pdf	1	1	2	2021-01-14 17:54:40.927335
1218	199	ficha registral  2015 IASD	data/archivos/199_1218.pdf	1	1	2	2021-01-14 17:56:03.423757
1219	114	escritura p dueños 2010	data/archivos/114_1219.pdf	1	1	2	2021-01-15 08:44:03.924751
1220	114	ficha registral dueños 2007	data/archivos/114_1220.pdf	1	1	2	2021-01-15 08:45:58.340344
1221	114	escritura publica IASD 2011	data/archivos/114_1221.pdf	1	1	2	2021-01-15 08:47:00.848246
1222	114	anotacion de inscripcion IASD 2011	data/archivos/114_1222.pdf	1	1	2	2021-01-15 08:48:54.100796
1223	28	convenio de enterga de predio Asoc urb. a IASD 1990	data/archivos/28_1223.pdf	1	1	2	2021-01-15 09:54:26.554644
1224	28	plano  ubicacion	data/archivos/28_1224.pdf	1	1	2	2021-01-15 09:56:26.807413
1225	28	ficha registral IASD 2018	data/archivos/28_1225.pdf	1	1	2	2021-01-15 09:58:23.930742
1226	28	declarcion jurada predial y acumulacion  2015	data/archivos/28_1226.pdf	1	1	2	2021-01-15 09:59:44.349156
1227	261	titulacion de cofopri 2000 IASD	data/archivos/261_1227.pdf	1	1	2	2021-01-15 10:06:47.027188
1228	116	titulacion cofopri  2000 dueño	data/archivos/116_1228.pdf	1	1	2	2021-01-15 10:17:24.413131
1229	116	escritura publica  IASD 2001	data/archivos/116_1229.pdf	1	1	2	2021-01-15 10:18:12.6767
1230	117	titulo cofopri dueño 2004	data/archivos/117_1230.pdf	1	1	2	2021-01-15 10:38:09.85582
1231	118	constancia cofopri 1999 y ficha registral 2009	data/archivos/118_1231.pdf	1	1	2	2021-01-15 10:54:34.076962
1232	120	escritura publica donacion en dinero 2003 IASD	data/archivos/120_1232.pdf	1	1	2	2021-01-15 11:32:45.037256
1233	120	planos de ubicacion memoria  descriptiva 2003	data/archivos/120_1233.pdf	1	1	2	2021-01-15 11:34:12.809868
1234	120	ficha registral IASD 2009	data/archivos/120_1234.pdf	1	1	2	2021-01-15 11:35:18.638528
1235	120	informe de municipalidad sobre areas ycolindante  2012 IASD	data/archivos/120_1235.pdf	1	1	2	2021-01-15 11:36:37.794813
1236	548	pago de cheque Hnos y MPS	data/archivos/548_1236.pdf	1	1	2	2021-01-15 11:49:47.737454
1237	548	pago de parbitrios  2017 dueño	data/archivos/548_1237.pdf	1	1	2	2021-01-15 11:50:57.228552
1238	548	pago de arbitrios y predial inafectado 2020IASD	data/archivos/548_1238.pdf	1	1	2	2021-01-15 11:52:14.838699
1239	548	constancia posesion a asoc apipa dueño 2012	data/archivos/548_1239.pdf	1	1	2	2021-01-15 11:53:16.050548
1240	568	poder especial Escritura  de eleuterio a favor Laureano conde 2019	data/archivos/568_1240.pdf	1	1	2	2021-01-15 12:12:08.481658
1241	568	pago deposito a Belizario propietario 2019	data/archivos/568_1241.pdf	1	1	2	2021-01-15 12:15:28.953086
1242	568	fotos del predio	data/archivos/568_1242.pdf	1	1	2	2021-01-15 12:16:05.243066
1243	568	constancia de posesion  dueño  2019	data/archivos/568_1243.pdf	1	1	2	2021-01-15 12:17:15.910756
1244	568	acta de constatacion dueño 2018	data/archivos/568_1244.pdf	1	1	2	2021-01-15 12:18:27.314101
1245	568	plano de ubicacion	data/archivos/568_1245.pdf	1	1	2	2021-01-15 12:19:15.520876
1246	568	pago de arbitrios dueño 2019	data/archivos/568_1246.pdf	1	1	2	2021-01-15 12:20:08.452996
1247	337	anotacion de inscripcion  2021-Enero IASD	data/archivos/337_1247.pdf	1	1	2	2021-01-24 12:44:53.674198
1248	337	asiento de inscripcion 2021 Enero IASD	data/archivos/337_1248.pdf	1	1	2	2021-01-24 12:45:20.341595
1249	464	inscripcion de registros AEAP 20121	data/archivos/464_1249.pdf	1	1	2	2021-01-28 20:14:05.887768
1251	464	anotacion de inscripcion acumulacion AEAPS 2021	data/archivos/464_1251.pdf	1	1	2	2021-01-28 20:16:36.586794
1252	464	inscripcion registros AEAPS 2021	data/archivos/464_1252.pdf	1	1	2	2021-01-28 20:17:32.579329
1253	495	recibo de agua y luz a nombre de dueños	data/archivos/495_1253.pdf	1	1	2	2021-02-06 21:40:29.032378
1255	292	plano de ubicacion	data/archivos/292_1255.pdf	1	1	2	2021-02-18 22:55:53.808925
1256	171	inscripcion de declaratoria de fabrica 2021 Febrero IASD	data/archivos/171_1256.pdf	1	1	2	2021-02-24 14:07:31.563914
1257	171	inscripcion asiento fabrica 2021 Febrero	data/archivos/171_1257.pdf	1	1	2	2021-02-24 14:08:09.446223
1258	392	certificado literal  IASD 2021 febrero	data/archivos/392_1258.pdf	1	1	2	2021-02-25 17:01:23.911998
1259	251	certificado literal IASD 2021 Febrero	data/archivos/251_1259.pdf	1	1	2	2021-02-25 20:52:37.477958
1260	152	certificado literal IASD 2021 febrero	data/archivos/152_1260.pdf	1	1	2	2021-02-25 20:57:22.912806
1261	337	docuemnto de hilda declaracion  ante sunat	data/archivos/337_1261.pdf	1	1	2	2021-03-02 18:55:35.266437
1262	337	pago de multa por no declara predio vendido sunat  hilda dueña	data/archivos/337_1262.pdf	1	1	2	2021-03-02 18:57:02.730196
1263	401	Ficha registral 2021 Dueño	data/archivos/401_1263.pdf	1	1	2	2021-03-23 15:24:52.266761
1264	165	ficha registral sunarp IASD sesion en uso cofopri 2021 Marzo	data/archivos/165_1264.pdf	1	1	2	2021-03-28 16:44:17.818176
1265	156	ficha registral IASD 2021 Febrero	data/archivos/156_1265.pdf	1	1	2	2021-03-28 20:40:11.916615
1266	376	ficha registral IASD 2021 Febrero	data/archivos/376_1266.pdf	1	1	2	2021-03-28 20:41:41.105533
1267	155	ficha registral IASD 2021 Febrero	data/archivos/155_1267.pdf	1	1	2	2021-03-28 20:42:49.321575
1268	90	ficha registral IASD 2021 Febrero	data/archivos/90_1268.pdf	1	1	2	2021-03-28 20:44:25.981262
1269	33	ficha registral IASD 2021 Febrero	data/archivos/33_1269.pdf	1	1	2	2021-03-28 20:45:35.454102
1270	32	ficha registral IASD 2021 febrero	data/archivos/32_1270.pdf	1	1	2	2021-03-28 20:47:00.175549
1271	41	ficha registral IASD 2021 febrero	data/archivos/41_1271.pdf	1	1	2	2021-03-28 20:51:51.858886
1272	150	ficha registral IASD 2021 febrero	data/archivos/150_1272.pdf	1	1	2	2021-03-28 20:52:50.720609
1273	151	ficha registral IASD 2021 Febrero	data/archivos/151_1273.pdf	1	1	2	2021-03-28 20:53:49.187726
1274	351	ficha registral IASD 2021 Febrero	data/archivos/351_1274.pdf	1	1	2	2021-03-28 21:48:38.879152
1276	19	ficha registral IASD 2021-02	data/archivos/19_1276.pdf	1	1	2	2021-03-30 15:54:28.879102
1277	279	pago predial Union Inacica 2021	data/archivos/279_1277.pdf	1	1	2	2021-04-06 20:36:18.138883
1278	279	pago predial 2021	data/archivos/279_1278.pdf	1	1	2	2021-04-06 20:36:55.441843
1279	279	pago predial 2021	data/archivos/279_1279.pdf	1	1	2	2021-04-06 20:37:26.144181
1280	284	escritura publica IASD 2020-12-22	data/archivos/284_1280.pdf	1	1	2	2021-04-07 13:41:01.195195
1281	105	ficha registral IASD 2021-04-14	data/archivos/105_1281.pdf	1	1	2	2021-04-14 19:02:33.438213
1282	285	ficha registral IASD 2021-04-14	data/archivos/285_1282.pdf	1	1	2	2021-04-14 22:25:33.747714
1283	103	ficha registral IASD 14-04-2021	data/archivos/103_1283.pdf	1	1	2	2021-04-14 22:33:09.163079
1284	66	recibo de agua	data/archivos/66_1284.pdf	1	1	2	2021-04-16 09:41:32.65553
1285	520	contrato a nombre de hno	data/archivos/520_1285.pdf	1	1	2	2021-05-03 13:11:18.898609
1286	520	ficha catastral a nombre IASD	data/archivos/520_1286.pdf	1	1	2	2021-05-03 13:11:52.771552
1287	520	plano de ubicacion y perimetrico memoria descriptiva	data/archivos/520_1287.pdf	1	1	2	2021-05-03 13:12:41.768863
1288	292	ficha registral IASD 21-01-2021	data/archivos/292_1288.pdf	1	1	2	2021-05-03 15:08:11.167754
1289	464	escritura compra de predio AEAPS	data/archivos/464_1289.pdf	1	1	2	2021-05-03 21:31:23.563882
1290	54	fotos iglesia	data/archivos/54_1290.pdf	1	1	2	2021-05-04 07:14:40.155093
1293	284	Ficha Registral IASD 2021-Mayo	data/archivos/284_1293.pdf	1	1	2	2021-05-08 18:42:44.621982
1294	107	memoria descriptiva de inicial 2021	data/archivos/107_1294.pdf	1	1	2	2021-05-08 20:26:27.019732
1295	458	foto de miller	data/archivos/458_1295.pdf	1	1	2	2021-05-08 23:10:23.850724
1296	260	ficha registral IASD 2021 Mayo	data/archivos/260_1296.pdf	1	1	2	2021-05-10 20:37:30.673507
1297	261	ficha registral IASD 2021 mayo cesion en uso	data/archivos/261_1297.pdf	1	1	2	2021-05-18 11:46:06.750655
1298	464	certificado de numeracion colegio	data/archivos/464_1298.pdf	1	1	2	2021-05-21 19:35:41.021608
1299	451	constancia de posesion municp. a favor del propietario 2021 mayo	data/archivos/451_1299.pdf	1	1	2	2021-05-25 11:02:48.619153
1300	451	recibos de agua y luz a favro del propietario	data/archivos/451_1300.pdf	1	1	2	2021-05-25 11:03:28.698511
1301	451	carta de renuncia del propietario 2021 mayo	data/archivos/451_1301.pdf	1	1	2	2021-05-25 11:04:23.719993
1302	451	contrato de traspaso a favor de IASD 20212 mayo	data/archivos/451_1302.pdf	1	1	2	2021-05-25 11:05:16.429283
1303	265	ficha registral IASD otros fines 2021 mayo	data/archivos/265_1303.pdf	1	1	2	2021-05-25 11:47:37.564183
1304	53	ficha registral IASD 2021 Junio	data/archivos/53_1304.pdf	1	1	2	2021-06-07 19:25:33.047606
1305	102	ficha registral asoc, union peruana IASD 2021 junio	data/archivos/102_1305.pdf	1	1	2	2021-06-09 08:50:43.282492
1306	427	autovaluo dueño 2019	data/archivos/427_1306.pdf	1	1	2	2021-06-10 21:23:37.449804
1307	427	autovaluo dueño 2019	data/archivos/427_1307.pdf	1	1	2	2021-06-10 21:24:10.704482
1308	533	croxis plano	data/archivos/533_1308.pdf	1	1	2	2021-06-14 10:38:26.359628
1309	533	Ordenanza Municipla cambio de uso 2006	data/archivos/533_1309.pdf	1	1	2	2021-06-14 10:39:37.279704
1310	533	boleta de pago arbitrios 2021	data/archivos/533_1310.pdf	1	1	2	2021-06-14 10:41:25.81008
1311	41	resolucion predial 2021 junio	data/archivos/41_1311.pdf	1	1	2	2021-06-24 21:26:12.737446
1312	41	resolucion predial junio 2021	data/archivos/41_1312.pdf	1	1	2	2021-06-24 21:26:51.651827
1313	155	Ficha catastral del predio (Municipio 20129)	data/archivos/155_1313.pdf	1	1	2	2021-06-25 07:25:09.802696
1314	156	ficha catastral del predio (municpio 2019	data/archivos/156_1314.pdf	1	1	2	2021-06-25 07:27:33.278866
1316	32	ficha catastral del predio (Municpio 2019)	data/archivos/32_1316.pdf	1	1	2	2021-06-25 07:36:38.023755
1317	152	fgicha catastral del predio (Muniicpio 2019)	data/archivos/152_1317.pdf	1	1	2	2021-06-25 07:41:35.170534
1318	41	ficha castastro del predio (Municipio 2019)	data/archivos/41_1318.pdf	1	1	2	2021-06-25 07:49:02.08682
1319	393	anotacion de inscripcion a IASD 18 de Julio 2018	data/archivos/393_1319.pdf	1	1	2	2021-07-09 11:31:25.280597
1320	393	ficha registral IASD Julio 2021	data/archivos/393_1320.pdf	1	1	2	2021-07-15 09:06:24.767324
1321	108	recibo de agua sera de Iglesea o colegio	data/archivos/108_1321.pdf	1	1	2	2021-07-15 17:10:40.362735
1322	109	recibo de agua	data/archivos/109_1322.pdf	1	1	2	2021-07-17 10:16:15.694966
1323	270	escritura de aclaracio primigenia de dueños	data/archivos/270_1323.pdf	1	1	2	2021-07-20 15:24:21.898649
1324	150	01 planos esctructura	data/archivos/150_1324.pdf	1	1	2	2021-08-02 14:43:34.797103
1325	150	plano 02	data/archivos/150_1325.pdf	1	1	2	2021-08-02 14:44:11.544577
1326	150	planos fachada 3	data/archivos/150_1326.pdf	1	1	2	2021-08-02 14:51:24.85665
1327	306	certificado de posesion IASD	data/archivos/306_1327.pdf	1	1	2	2021-08-21 21:45:22.816045
1328	306	croxi de presio	data/archivos/306_1328.pdf	1	1	2	2021-08-21 21:45:55.907551
1329	239	ficha registral  IASD 2021 Agosto	data/archivos/239_1329.pdf	1	1	2	2021-08-24 21:29:03.042094
1330	23	ficha registral del predio  2021 setiembre IASD	data/archivos/23_1330.pdf	1	1	2	2021-09-04 10:52:39.38836
1331	161	ficha registral IASD 2021 Setiembre	data/archivos/161_1331.pdf	1	1	2	2021-09-08 22:31:18.662355
1332	401	vigencia poder L conde setiembre  con facultades	data/archivos/401_1332.pdf	1	1	2	2021-09-20 10:46:15.350077
1333	66	ficha registral setiembre 2021	data/archivos/66_1333.pdf	1	1	2	2021-09-20 12:05:12.848002
1334	303	ficha registral setiembre 2021	data/archivos/303_1334.pdf	1	1	2	2021-09-20 12:06:07.282169
1335	261	fichar registral setiembre 2021	data/archivos/261_1335.pdf	1	1	2	2021-09-20 12:06:51.808597
1337	73	resolucion inafectacio predial 20212 setiembre de 15 predios	data/archivos/73_1337.pdf	1	1	2	2021-09-21 15:12:05.782216
1338	529	constancia de posesion de asoc.a nombre IASD20|16	data/archivos/529_1338.pdf	1	1	2	2021-09-22 15:54:01.624661
1339	529	contrato de venta IASD 2015	data/archivos/529_1339.pdf	1	1	2	2021-09-22 15:55:23.063448
1340	410	fichar registra a nombre de cofopri	data/archivos/410_1340.pdf	1	1	2	2021-10-12 15:25:13.378231
1341	495	buen pastor  acta de constatacion de posesion  IASD octubre 2021	data/archivos/495_1341.pdf	1	1	2	2021-10-16 23:23:55.938251
1342	401	escritura IASD 2021 octubre	data/archivos/401_1342.pdf	1	1	2	2021-10-16 23:57:29.186841
1343	549	resolucion de colegio majes	data/archivos/549_1343.pdf	1	1	2	2021-10-21 20:27:39.876573
1344	284	pago recibo de predial a nombre dueño  varios años cancelado	data/archivos/284_1344.pdf	1	1	2	2021-10-27 08:55:56.199388
1345	495	fotos de fachada de iglesia y interior 2021 octubre	data/archivos/495_1345.pdf	1	1	2	2021-10-27 15:45:07.545232
1346	106	ficha registral  IASD 2021 octubre	data/archivos/106_1346.pdf	1	1	2	2021-10-29 20:43:14.383144
1347	68	adjudicacion IASD atitulo gratuito notarial 2018	data/archivos/68_1347.pdf	1	1	2	2021-10-29 20:47:52.283865
1348	363	ficha registral IASD 2021 noviembre	data/archivos/363_1348.pdf	1	1	2	2021-11-03 12:56:37.040375
1349	410	plano de ubicaciions actual	data/archivos/410_1349.pdf	1	1	2	2021-11-05 20:05:37.837136
1350	8	datos generales de predio camana por cofopri	data/archivos/8_1350.pdf	1	1	2	2021-11-08 15:24:30.383155
1351	8	escritura de compar venta a nombre de General comferencia den sevent day adv	data/archivos/8_1351.pdf	1	1	2	2021-11-08 15:36:42.056599
1352	120	ficha registral 2021 noviembre	data/archivos/120_1352.pdf	1	1	2	2021-11-10 12:52:23.437802
1354	285	ficha registral noviembre 2021	data/archivos/285_1354.pdf	1	1	2	2021-11-10 14:09:37.625846
1355	401	inscripcion de predio IASD	data/archivos/401_1355.pdf	1	1	2	2021-11-17 18:12:25.315457
1356	401	ficha registral de Alto inclan B mollendo IASD 2021 noviembre	data/archivos/401_1356.pdf	1	1	2	2021-11-18 14:04:46.038282
1361	25	escritura publica  IASD	data/archivos/25_1361.pdf	1	1	2	2021-12-01 23:02:39.330406
1362	25	planos de ubicacion	data/archivos/25_1362.pdf	1	1	2	2021-12-01 23:06:40.04338
1363	25	baucher pago del predio	data/archivos/25_1363.pdf	1	1	2	2021-12-01 23:07:28.819625
1364	534	extincion de reclamento  y acumulacion de 2pisos	data/archivos/534_1364.pdf	1	1	2	2021-12-03 16:27:46.508629
1365	302	ficha registral 2021 didicembre corporacion sev	data/archivos/302_1365.pdf	1	1	2	2021-12-03 16:44:24.940328
1366	302	predial 2021	data/archivos/302_1366.pdf	1	1	2	2021-12-03 16:44:59.115606
1367	30	escritura publica  2003	data/archivos/30_1367.pdf	1	1	2	2021-12-03 16:53:58.799092
1368	30	escritura publica	data/archivos/30_1368.pdf	1	1	2	2021-12-03 16:56:26.583871
1369	30	escritura compra y venta	data/archivos/30_1369.pdf	1	1	2	2021-12-03 16:57:16.299113
1370	30	baucher pago compra terreno	data/archivos/30_1370.pdf	1	1	2	2021-12-03 16:58:11.711328
1371	30	plano y menoria	data/archivos/30_1371.pdf	1	1	2	2021-12-03 16:59:14.206806
1372	30	ficha registral colindante y nuestro predio	data/archivos/30_1372.pdf	1	1	2	2021-12-03 16:59:59.170936
1373	129	ficha registral 2021 diciembre	data/archivos/129_1373.pdf	1	1	2	2021-12-07 20:33:50.913627
1374	79	ficha registral diciembre 2021 IASD	data/archivos/79_1374.pdf	1	1	2	2021-12-07 20:56:55.878057
1376	109	ficha registral diciembre 2021-	data/archivos/109_1376.pdf	1	1	2	2021-12-28 12:18:49.285321
1378	107	ficha registral diciembre 2021	data/archivos/107_1378.pdf	1	1	2	2021-12-28 12:20:37.295868
1380	309	ficha registral	data/archivos/309_1380.pdf	1	1	2	2022-01-04 13:09:54.120966
1381	458	ficha registral 2021	data/archivos/458_1381.pdf	1	1	2	2022-01-04 13:10:52.74359
1382	363	predial 2021	data/archivos/363_1382.pdf	1	1	2	2022-01-06 09:08:34.040169
1383	199	autovaluos 2021	data/archivos/199_1383.pdf	1	1	2	2022-01-06 20:48:26.849156
1384	261	autovaluos de distrito ciudad Nueva 2021	data/archivos/261_1384.pdf	1	1	2	2022-01-06 20:51:07.005244
1385	237	autovaluos distrito pocollay de todas las iglesia 2021	data/archivos/237_1385.pdf	1	1	2	2022-01-06 20:53:15.822508
1386	535	autovaluos distrito de hunter de iglesias 2021	data/archivos/535_1386.pdf	1	1	2	2022-01-06 20:55:02.442574
1387	108	relacion de todas las iglesia municipio autovaluo 2021	data/archivos/108_1387.pdf	1	1	2	2022-01-06 20:56:32.463795
1388	66	autovaluos de municipio alto alianza 2021	data/archivos/66_1388.pdf	1	1	2	2022-01-06 20:58:56.467201
1390	464	ficha registral 2022 enero	data/archivos/464_1390.pdf	1	1	2	2022-01-12 17:51:16.502334
1391	55	contrato de transferencia de hno a otro hno	data/archivos/55_1391.pdf	1	1	2	2022-02-07 10:50:52.951645
1392	595	contrato de compra y venta 2022 marzo	data/archivos/595_1392.pdf	1	1	2	2022-03-04 08:23:49.24827
1393	595	poderes a L Conde	data/archivos/595_1393.pdf	1	1	2	2022-03-04 08:24:31.931077
1394	595	baucher pago del predio	data/archivos/595_1394.pdf	1	1	2	2022-03-04 08:25:13.852763
1395	364	recibo luz agua- predial 2021 arbitrios- esta a nombre IASD	data/archivos/364_1395.pdf	1	1	2	2022-03-10 07:37:28.623956
1396	333	contancia de posesion IASD	data/archivos/333_1396.pdf	1	1	2	2022-03-10 21:26:15.160898
1397	333	recibo de luz IASD	data/archivos/333_1397.pdf	1	1	2	2022-03-10 21:26:40.556401
1398	596	escritura publica dueños 2022	data/archivos/596_1398.pdf	1	1	2	2022-03-20 13:50:52.016398
1399	596	ficha registral dueños 2022	data/archivos/596_1399.pdf	1	1	2	2022-03-20 13:51:22.580431
1400	596	escritura publica  donacion IASD 2021 marzo 17	data/archivos/596_1400.pdf	1	1	2	2022-03-20 13:52:34.256926
1401	225	ficha registral  IASD2022 marzo	data/archivos/225_1401.pdf	1	1	2	2022-03-20 18:02:06.81922
1402	224	ficha registral IASD marzo 2022	data/archivos/224_1402.pdf	1	1	2	2022-03-20 18:11:45.785826
1403	272	ficha registral marzo 2022	data/archivos/272_1403.pdf	1	1	2	2022-03-22 20:40:01.604944
1404	363	PU Y RH 2022 marzo	data/archivos/363_1404.pdf	1	1	2	2022-03-27 15:03:57.021572
1405	62	PU-RH marzo 2022	data/archivos/62_1405.pdf	1	1	2	2022-03-27 15:18:04.136792
1406	65	PU-RH marzo 2022	data/archivos/65_1406.pdf	1	1	2	2022-03-27 15:19:17.185258
1407	218	fichas registral IASD 2022 marzo	data/archivos/218_1407.pdf	1	1	2	2022-03-28 16:38:40.065897
1408	173	ficha registral IASD 2022 Marzo	data/archivos/173_1408.pdf	1	1	2	2022-03-31 22:12:35.922432
1409	597	constancia de posesion IASD 2021	data/archivos/597_1409.pdf	1	1	2	2022-04-15 15:24:47.761504
1410	597	contrato de Luz a nombre otra persona  2021	data/archivos/597_1410.pdf	1	1	2	2022-04-15 15:25:25.611508
1411	238	predial 2022 abril	data/archivos/238_1411.pdf	1	1	2	2022-04-21 16:05:12.403264
1412	524	ficha registral 2022 abril	data/archivos/524_1412.pdf	1	1	2	2022-04-22 19:18:11.663398
1413	200	ficha registral abril2022	data/archivos/200_1413.pdf	1	1	2	2022-04-22 19:19:43.581007
1414	262	ficha registral abril2022	data/archivos/262_1414.pdf	1	1	2	2022-04-22 19:22:27.716218
1415	596	anotacion de inscripcion IASD 2022 abril	data/archivos/596_1415.pdf	1	1	2	2022-04-26 22:21:19.331641
1416	596	inscripcion de propedad Sunarp 2022 abril	data/archivos/596_1416.pdf	1	1	2	2022-04-26 22:22:04.910251
1417	549	certificado defensa civil 2022 abril	data/archivos/549_1417.pdf	1	1	2	2022-04-27 21:40:34.010891
1418	307	datos cofopri ficha actual	data/archivos/307_1418.pdf	1	1	2	2022-04-29 22:25:24.243031
1419	303	certificado defensa civil faro 2022 mayo	data/archivos/303_1419.pdf	1	1	2	2022-05-07 09:01:47.991696
1420	222	ficha registral de matriz de tiabaya  2022 mayo	data/archivos/222_1420.pdf	1	1	2	2022-05-07 09:10:28.865905
1421	319	plano y menoria descritiva de acciones y derecho	data/archivos/319_1421.pdf	1	1	2	2022-05-12 23:52:50.790479
1422	55	constancia de posesion 2022 mayo lote 02	data/archivos/55_1422.pdf	1	1	2	2022-05-12 23:58:09.296797
1424	55	constancia de posesion  lote 01 2022	data/archivos/55_1424.pdf	1	1	2	2022-05-13 00:03:45.918423
1425	55	constancia de posesion 2022 juez de paz	data/archivos/55_1425.pdf	1	1	2	2022-05-13 00:09:18.135553
1426	458	ficha registral preventiva  2022	data/archivos/458_1426.pdf	1	1	2	2022-05-13 20:58:06.026799
1427	464	anotacion de inscripcion cambio numero 2022	data/archivos/464_1427.pdf	1	1	2	2022-05-17 15:06:30.864205
1428	464	cambio de numeracion	data/archivos/464_1428.pdf	1	1	2	2022-05-17 21:12:12.837394
1429	319	escritura publica 2022 mayo	data/archivos/319_1429.pdf	1	1	2	2022-05-18 14:21:35.98668
1430	569	ficha registral 2022 mayo	data/archivos/569_1430.pdf	1	1	2	2022-05-31 21:42:47.338004
1431	408	ficha registral 2022 mayo	data/archivos/408_1431.pdf	1	1	2	2022-05-31 21:44:39.799169
1433	112	ficha registral 2022 mayo	data/archivos/112_1433.pdf	1	1	2	2022-05-31 21:50:25.589008
1434	409	ficha registral 2022 junio IASD	data/archivos/409_1434.pdf	1	1	2	2022-06-02 20:48:23.748238
1435	409	ficha registral 2022 junio IASD	data/archivos/409_1435.pdf	1	1	2	2022-06-02 20:48:27.253504
1437	112	ficha registral Junio 2022	data/archivos/112_1437.pdf	1	1	2	2022-06-02 20:50:20.862139
1439	596	ficha registral 2022 junio IASD	data/archivos/596_1439.pdf	1	1	2	2022-06-03 19:55:12.056556
1440	596	ficha registral 2022 junio IASD	data/archivos/596_1440.pdf	1	1	2	2022-06-03 19:55:14.682647
1441	464	licencia de funcionamiento 2022 junio	data/archivos/464_1441.pdf	1	1	2	2022-06-07 18:26:39.774065
1442	599	escritura cesion derechos  2021	data/archivos/599_1442.pdf	1	1	2	2022-06-10 20:20:12.639906
1443	599	carta de renuncia de propietario 2021	data/archivos/599_1443.pdf	1	1	2	2022-06-10 20:21:04.412405
1444	599	baucher compra 2021	data/archivos/599_1444.pdf	1	1	2	2022-06-10 20:21:51.938907
1445	599	poderes otorgado por el dueño a la IASD	data/archivos/599_1445.pdf	1	1	2	2022-06-10 20:23:09.900064
1446	73	autovaluo de distrito de gregosrio albarracin de todoto delos distritos 2022	data/archivos/73_1446.pdf	1	1	2	2022-06-27 11:51:26.21103
1447	73	autovaluo gregorio albarraci 2022	data/archivos/73_1447.pdf	1	1	2	2022-06-27 11:52:13.352506
1448	140	certificado de posesion 2022	data/archivos/140_1448.pdf	1	1	2	2022-06-27 14:22:15.8287
1449	140	certificado de posesion 2022	data/archivos/140_1449.pdf	1	1	2	2022-06-27 14:22:41.166169
1450	73	lista de iglesias  predial 2022	data/archivos/73_1450.pdf	1	1	2	2022-06-27 23:37:02.367238
1451	303	licencia de funcionamiento 2022 faroi	data/archivos/303_1451.pdf	1	1	2	2022-06-29 17:21:37.255759
1452	319	conmpra de predio inscripcion sunarp 2022	data/archivos/319_1452.pdf	1	1	2	2022-06-29 17:23:41.129234
1453	87	plano y documento 2022	data/archivos/87_1453.pdf	1	1	2	2022-07-03 18:47:08.029055
1454	87	constancia de posesion juez de paz 2022 junio	data/archivos/87_1454.pdf	1	1	2	2022-07-03 18:48:19.324371
1455	87	escritura publicxa chaparra	data/archivos/87_1455.pdf	1	1	2	2022-07-06 10:16:15.313797
1456	428	acta de constatacion de Juez  2013	data/archivos/428_1456.pdf	1	1	2	2022-07-14 08:44:54.208888
1458	428	plano y memoria descriptiva	data/archivos/428_1458.pdf	1	1	2	2022-07-14 08:49:06.930257
1459	495	plano y menoria 2022	data/archivos/495_1459.pdf	1	1	2	2022-07-14 09:21:04.949279
1460	464	ficha registral Julio 2022	data/archivos/464_1460.pdf	1	1	2	2022-07-16 21:41:02.566177
1461	285	ficha registral Julio2022	data/archivos/285_1461.pdf	1	1	2	2022-07-16 22:16:08.807024
1462	453	recibo de agua y luz para cambiar titular	data/archivos/453_1462.pdf	1	1	2	2022-07-17 16:53:17.520573
1463	404	pago predial 2022 IASD julio	data/archivos/404_1463.pdf	1	1	2	2022-07-29 20:05:15.073593
1464	40	plano de ubicacion	data/archivos/40_1464.pdf	1	1	2	2022-07-30 22:07:27.359986
1465	40	memoria descriptiva	data/archivos/40_1465.pdf	1	1	2	2022-07-30 22:08:39.525036
1466	40	perimetrico 1	data/archivos/40_1466.pdf	1	1	2	2022-07-30 22:09:39.882883
1467	40	perimetrico	data/archivos/40_1467.pdf	1	1	2	2022-07-30 22:11:10.708363
1468	68	inscripcion de registros 2022	data/archivos/68_1468.pdf	1	1	2	2022-08-05 08:14:56.274236
1469	68	ficha registral 2022	data/archivos/68_1469.pdf	1	1	2	2022-08-05 08:15:42.072085
1470	534	ficha registral 2022	data/archivos/534_1470.pdf	1	1	2	2022-08-05 08:16:39.821546
1471	458	ficha registral 2022 agosto	data/archivos/458_1471.pdf	1	1	2	2022-08-24 21:02:24.228494
1472	263	ficha registral 2022agosto	data/archivos/263_1472.pdf	1	1	2	2022-08-24 21:06:05.196919
1473	44	inscripcio registros cambio de denominacion	data/archivos/44_1473.pdf	1	1	2	2022-08-25 00:14:51.841289
1474	44	cambio denominacio incripcion	data/archivos/44_1474.pdf	1	1	2	2022-08-25 00:16:16.103058
1475	66	ficha registral 2022 setiembre	data/archivos/66_1475.pdf	1	1	2	2022-09-05 14:04:11.124693
1476	118	ficha registral 2022 setiembre	data/archivos/118_1476.pdf	1	1	2	2022-09-05 14:53:19.797047
1477	119	ficha registral 2022 setiembre	data/archivos/119_1477.pdf	1	1	2	2022-09-05 14:56:20.796578
1478	496	ficha registral 2022 setiembre	data/archivos/496_1478.pdf	1	1	2	2022-09-07 13:43:47.153245
1479	601	constancia de posesion 2015	data/archivos/601_1479.pdf	1	1	2	2022-09-11 19:44:26.036812
1480	600	escritura publica 2022 agosto IASD	data/archivos/600_1480.pdf	1	1	2	2022-09-25 08:02:07.756884
1481	600	inscripcion Sunarp 2022	data/archivos/600_1481.pdf	1	1	2	2022-09-25 08:02:56.994783
1482	600	baucher pago	data/archivos/600_1482.pdf	1	1	2	2022-09-25 08:04:04.36505
1483	600	ficha registral IASD 2022 Setiembre	data/archivos/600_1483.pdf	1	1	2	2022-09-25 18:48:33.516153
1484	458	ficha registral IADS setiembre Preventiva	data/archivos/458_1484.pdf	1	1	2	2022-09-25 18:50:15.082619
1486	270	anotacion de inscripcion	data/archivos/270_1486.pdf	1	1	2	2022-10-15 08:00:15.592071
1487	270	inscripcion anotacion	data/archivos/270_1487.pdf	1	1	2	2022-10-15 08:01:10.139963
1488	410	resolucion de adjudicacion	data/archivos/410_1488.pdf	1	1	2	2022-10-16 21:15:39.54966
1489	556	ficha registral 2022 octubre	data/archivos/556_1489.pdf	1	1	2	2022-10-25 21:44:15.734029
1490	522	ficha registral 2022 octubre	data/archivos/522_1490.pdf	1	1	2	2022-10-25 21:45:11.21838
1491	458	anotacion de inscripcion acumulado 2022 octubre	data/archivos/458_1491.pdf	1	1	2	2022-10-28 14:25:15.86719
1492	458	inscricion de propiedad 2022 cotubre acumulacion	data/archivos/458_1492.pdf	1	1	2	2022-10-28 14:26:13.368983
1493	136	ficha registral 2022 setiembre IASD	data/archivos/136_1493.pdf	1	1	2	2022-11-06 21:51:08.928897
1495	66	certificado de numeracion el Faro 2022 noviembre	data/archivos/66_1495.pdf	1	1	2	2022-11-12 12:10:29.219682
1496	217	escritura	data/archivos/217_1496.pdf	1	1	2	2022-11-13 12:41:28.076598
1497	217	certificado numeracion	data/archivos/217_1497.pdf	1	1	2	2022-11-13 12:42:00.287679
1498	217	certificado parametros	data/archivos/217_1498.pdf	1	1	2	2022-11-13 12:42:53.727386
1499	217	plano menoria descriptiva	data/archivos/217_1499.pdf	1	1	2	2022-11-13 12:43:30.723994
1500	217	visacion de planos	data/archivos/217_1500.pdf	1	1	2	2022-11-13 12:44:03.207479
1501	217	escritura primejenia	data/archivos/217_1501.pdf	1	1	2	2022-11-13 12:44:45.83266
1502	602	predia 2022 noviembre	data/archivos/602_1502.pdf	1	1	2	2022-11-14 06:48:58.336226
1503	427	plano de ubicacion y predia a nombre de dueños  2022	data/archivos/427_1503.pdf	1	1	2	2022-11-14 16:48:38.677317
1504	377	relacion de iglesias predial 2022	data/archivos/377_1504.pdf	1	1	2	2022-11-17 22:15:47.251455
1505	66	certificado numeracion 2022-11	data/archivos/66_1505.pdf	1	1	2	2022-11-26 09:12:01.212071
1506	66	certificado numeracion  2022-11	data/archivos/66_1506.pdf	1	1	2	2022-11-26 09:13:13.076514
1507	453	escritura publica 2022	data/archivos/453_1507.pdf	1	1	2	2022-11-28 17:28:46.973426
1508	453	parte notarial 2022	data/archivos/453_1508.pdf	1	1	2	2022-11-28 17:29:37.105953
1509	453	vigencia de poder a Lconde	data/archivos/453_1509.pdf	1	1	2	2022-11-28 17:30:15.580291
1510	32	ficha registral 2022 diciembre	data/archivos/32_1510.pdf	1	1	2	2022-12-03 18:23:55.104469
1511	549	ficha registral 2022 diciembre	data/archivos/549_1511.pdf	1	1	2	2022-12-04 20:16:20.768662
1512	136	ficha registral diciembre 2022	data/archivos/136_1512.pdf	1	1	2	2022-12-04 20:17:17.129443
1514	179	contrato de adjudicacion autodema 2022	data/archivos/179_1514.pdf	1	1	2	2022-12-06 17:54:31.863258
1515	549	autodema aDJUDICACION	data/archivos/549_1515.pdf	1	1	2	2022-12-06 20:12:41.130986
1516	41	predial ilo A y B  2022 noviembre	data/archivos/41_1516.pdf	1	1	2	2022-12-09 21:37:40.694014
1517	150	predial ilo A Y B 2022 Diciembre	data/archivos/150_1517.pdf	1	1	2	2022-12-09 21:39:24.337657
1518	36	escritura otorgamiento poder  a L.conde	data/archivos/36_1518.pdf	1	1	2	2022-12-13 21:10:42.245654
1519	255	ficha registral  2023 diciembre	data/archivos/255_1519.pdf	1	1	2	2023-01-12 21:55:29.793054
1520	5	ficha registral  2023	data/archivos/5_1520.pdf	1	1	2	2023-01-12 21:57:19.74454
1521	337	ficha registral 2023	data/archivos/337_1521.pdf	1	1	2	2023-02-07 16:08:55.925856
1523	458	Resoluciones de colegio	data/archivos/458_1523.pdf	1	1	2	2023-02-09 23:02:16.710305
1524	168	resoluciones  del colegio	data/archivos/168_1524.pdf	1	1	2	2023-02-09 23:03:52.050419
1525	168	resolucion colegio 02	data/archivos/168_1525.pdf	1	1	2	2023-02-09 23:05:14.971704
1526	303	resoluciones colegio  grupo 01	data/archivos/303_1526.pdf	1	1	2	2023-02-11 20:04:04.972312
1527	303	resoluciones colegio grupo02	data/archivos/303_1527.pdf	1	1	2	2023-02-11 20:05:07.957092
1528	109	Resoluciones colegio	data/archivos/109_1528.pdf	1	1	2	2023-02-11 20:07:07.720014
1529	261	resoluciones Inicial maranatha	data/archivos/261_1529.pdf	1	1	2	2023-02-11 20:09:32.022821
1530	300	resoluciones de colegio majes	data/archivos/300_1530.pdf	1	1	2	2023-02-11 20:10:52.574884
1531	403	constancia de posesion  2022 y dni	data/archivos/403_1531.pdf	1	1	2	2023-02-14 23:42:01.116577
1532	452	vigencia poder  a hijo de hno donante	data/archivos/452_1532.pdf	1	1	2	2023-02-19 09:16:46.7936
1533	73	ficha registral 3023	data/archivos/73_1533.pdf	1	1	2	2023-02-20 13:42:03.045889
1534	458	Predial Municipio 2022 resumen	data/archivos/458_1534.pdf	1	1	2	2023-02-26 23:06:09.179393
1535	150	predial 2023 febrero de toda las iglesias ILO B ILO A	data/archivos/150_1535.pdf	1	1	2	2023-02-28 23:11:22.317689
1536	112	rh y pu de casa pastoral y contenental 2023	data/archivos/112_1536.pdf	1	1	2	2023-03-04 00:03:59.736099
1537	400	contrato privado carta renuncia poderes  lote 10	data/archivos/400_1537.pdf	1	1	2	2023-03-05 18:11:19.552633
1538	400	certificado de posesion de municipio lote 10	data/archivos/400_1538.pdf	1	1	2	2023-03-05 18:11:58.503491
1539	400	contrato privado carta renucicia poderes lote 11	data/archivos/400_1539.pdf	1	1	2	2023-03-05 18:12:48.937332
1540	400	certificado de posesion lote 11	data/archivos/400_1540.pdf	1	1	2	2023-03-05 18:13:17.724856
1541	428	colsolidado de predia Municipio	data/archivos/428_1541.pdf	1	1	2	2023-03-06 00:30:30.943455
1542	248	predial relacion de iglesias	data/archivos/248_1542.pdf	1	1	2	2023-03-11 20:07:38.760319
1543	179	escritura 2023	data/archivos/179_1543.pdf	1	1	2	2023-03-22 14:16:31.61387
1544	10	ficha registra 2023 marzo	data/archivos/10_1544.pdf	1	1	2	2023-03-26 22:33:11.540954
1545	44	ficha registral 2023 marzo	data/archivos/44_1545.pdf	1	1	2	2023-03-29 17:58:12.164867
1546	538	ficha registral asoc educa marzo 2023	data/archivos/538_1546.pdf	1	1	2	2023-03-29 18:01:37.943312
1547	116	ficha registral 2023 marzo	data/archivos/116_1547.pdf	1	1	2	2023-04-02 21:43:38.741876
1548	180	parte expedido de munucipio majes 2023	data/archivos/180_1548.pdf	1	1	2	2023-04-13 21:43:17.039039
1549	464	resoluciones  del colegio	data/archivos/464_1549.pdf	1	1	2	2023-04-14 16:30:14.47047
1550	179	anotacion de inscripcion y asiento de inscripcion 24-04-2023	data/archivos/179_1550.pdf	1	1	2	2023-04-24 23:08:34.906139
1551	477	ficha registral del predio 2023	data/archivos/477_1551.pdf	1	1	2	2023-04-25 22:30:35.823486
1552	341	constancia de juez de paz chala lotes 13-14	data/archivos/341_1552.pdf	1	1	2	2023-04-26 18:43:34.879264
1553	43	ficha registral 2023	data/archivos/43_1553.pdf	1	1	2	2023-04-27 17:25:18.965215
1554	174	ficha registral 2023	data/archivos/174_1554.pdf	1	1	2	2023-04-27 17:26:32.360932
1555	174	pago arbitrios 2023	data/archivos/174_1555.pdf	1	1	2	2023-04-28 18:16:15.351885
1556	43	plano de ubicacion	data/archivos/43_1556.pdf	1	1	2	2023-05-03 20:37:10.610894
1557	240	ficha registral 2023 mayo	data/archivos/240_1557.pdf	1	1	2	2023-05-13 20:17:46.804118
1558	464	resoluicion del año 2023	data/archivos/464_1558.pdf	1	1	2	2023-06-05 18:02:20.338151
1559	194	pago de arbitrios y autovaluo 2023 junio	data/archivos/194_1559.pdf	1	1	2	2023-06-15 08:21:17.801904
1560	109	certificado defensa civil 2023 21 de junio	data/archivos/109_1560.pdf	1	1	2	2023-06-29 20:36:26.18305
1561	43	certificado de numeracion y resolucion de gerencia de desarrolo 2023 mayo	data/archivos/43_1561.pdf	1	1	2	2023-07-01 20:06:49.100194
1562	44	certificado numerancion 2023 mayo	data/archivos/44_1562.pdf	1	1	2	2023-07-01 20:20:24.814015
1563	326	constancia de posesion juez	data/archivos/326_1563.pdf	1	1	2	2023-07-27 08:34:59.152796
1564	605	constancia de posesion	data/archivos/605_1564.pdf	1	1	2	2023-07-31 16:23:03.601573
1565	605	acta de constatacion	data/archivos/605_1565.pdf	1	1	2	2023-07-31 16:24:24.745122
1566	605	carta de renuncia	data/archivos/605_1566.pdf	1	1	2	2023-07-31 16:25:12.502944
1567	605	ficha de cofopri	data/archivos/605_1567.pdf	1	1	2	2023-07-31 16:25:39.932527
1568	605	poderes por registro	data/archivos/605_1568.pdf	1	1	2	2023-07-31 16:26:44.335049
1569	605	contrato privado de transferencia	data/archivos/605_1569.pdf	1	1	2	2023-07-31 16:32:29.763145
1570	605	contrato privado de transferencia	data/archivos/605_1570.pdf	1	1	2	2023-07-31 16:32:29.803374
1571	606	certificado de posesion 2023 municipalidad	data/archivos/606_1571.pdf	1	1	2	2023-08-01 07:44:52.429104
1572	607	contrato privado dueños	data/archivos/607_1572.pdf	1	1	2	2023-08-01 08:54:42.346234
1573	607	contrato  de dueños	data/archivos/607_1573.pdf	1	1	2	2023-08-01 08:55:26.16926
1574	604	contrato privado	data/archivos/604_1574.pdf	1	1	2	2023-08-01 09:03:45.76312
1575	604	planos ubicacion	data/archivos/604_1575.pdf	1	1	2	2023-08-01 09:04:43.882276
1576	605	pago de arbitrios 2023	data/archivos/605_1576.pdf	1	1	2	2023-08-07 09:43:19.780838
1579	605	plano ubicacion	data/archivos/605_1579.pdf	1	1	2	2023-08-14 21:44:54.332274
1580	604	constancia de posesion  y sucesion instestada autovaluo 2023	data/archivos/604_1580.pdf	1	1	2	2023-08-20 20:13:59.586928
1581	605	inscripcion a nombre IASD 2023 en la Municiplaidad	data/archivos/605_1581.pdf	1	1	2	2023-08-20 20:30:07.39007
1582	604	autovaluo 2023 completo	data/archivos/604_1582.pdf	1	1	2	2023-08-20 20:40:48.594584
1583	399	plano ubicacion 2023	data/archivos/399_1583.pdf	1	1	2	2023-08-27 22:14:26.706869
1584	608	escritura 2023 de dueños	data/archivos/608_1584.pdf	1	1	2	2023-08-27 23:25:17.384858
1585	608	baucher y autovaluo 2023  dueños	data/archivos/608_1585.pdf	1	1	2	2023-08-27 23:28:16.450033
1586	595	escritura compra 2023 agosto	data/archivos/595_1586.pdf	1	1	2	2023-08-28 17:23:58.413522
1587	609	constancia de posesion y plano- ordenanza Municipal 2023	data/archivos/609_1587.pdf	1	1	2	2023-09-03 23:03:53.148922
1588	595	INSCRIPCION SUNARP IASD 2023 SETIEMBRE	data/archivos/595_1588.pdf	1	1	2	2023-09-04 22:27:30.798307
1589	595	MANIFIESTO SUNARP iasd 2023 SETIEMBRE	data/archivos/595_1589.pdf	1	1	2	2023-09-04 22:28:28.910192
1595	610	inscripcion de porpiedad 2023 setiembte	data/archivos/610_1595.pdf	1	1	2	2023-09-15 13:11:11.955245
1596	610	registrado 20223 setiembre	data/archivos/610_1596.pdf	1	1	2	2023-09-15 13:12:31.973277
1597	164	Ficha Inscripcion desmenbramientos de a favor IASD 2023 setiembre	data/archivos/164_1597.pdf	1	1	2	2023-09-16 08:26:55.63768
1598	164	desmenbramiento a favor de dueño 77.50 MT setiembre 2023	data/archivos/164_1598.pdf	1	1	2	2023-09-16 08:28:36.316713
1599	43	anotacion de inscripcion correccion de numeracio 2023 setiembre	data/archivos/43_1599.pdf	1	1	2	2023-09-17 20:08:05.809501
1600	318	recibo de luz	data/archivos/318_1600.pdf	1	1	2	2023-09-18 22:26:00.922252
1601	607	contrato privado donacion 2023 setiembre	data/archivos/607_1601.pdf	1	1	2	2023-09-27 12:57:20.75994
1602	458	ficha registral de miller 2023 octubre	data/archivos/458_1602.pdf	1	1	2	2023-10-17 18:04:48.19692
1603	160	plano de salaverry de ubicacion 2023	data/archivos/160_1603.pdf	1	1	2	2023-10-20 19:10:20.86359
1604	400	planos  predio	data/archivos/400_1604.pdf	1	1	2	2023-10-25 22:40:46.821852
1605	400	plano  predios	data/archivos/400_1605.pdf	1	1	2	2023-10-25 22:41:34.560789
1607	529	resolucion inafectacion predia 2023 octubre de 2 iglesias	data/archivos/529_1607.pdf	1	1	2	2023-10-26 08:33:14.820783
1608	216	resolucion inafectacion 2023 octubre	data/archivos/216_1608.pdf	1	1	2	2023-10-26 08:34:22.940619
1609	261	plan de seguridad de inicial 2014	data/archivos/261_1609.pdf	1	1	2	2023-10-27 19:17:30.430306
1610	261	planos de defensa civil inicial 2014	data/archivos/261_1610.pdf	1	1	2	2023-10-27 19:18:18.642775
1611	261	plano de evacuacion defensa civil inicial 2014	data/archivos/261_1611.pdf	1	1	2	2023-10-27 19:19:01.994747
1612	261	planos de inicial 2014	data/archivos/261_1612.pdf	1	1	2	2023-10-27 19:20:58.862301
1613	595	plano de ubicacion	data/archivos/595_1613.pdf	1	1	2	2023-10-28 08:34:20.830238
1614	29	plno ubicacion	data/archivos/29_1614.pdf	1	1	2	2023-10-28 08:41:30.261482
1615	174	contrato de luz 2023 corregir direccion	data/archivos/174_1615.pdf	1	1	2	2023-10-28 08:54:23.600666
1616	14	ficha registral 2023	data/archivos/14_1616.pdf	1	1	2	2023-10-28 21:36:37.321961
1617	14	autovaluo 2017	data/archivos/14_1617.pdf	1	1	2	2023-10-28 21:38:16.421428
1618	273	formulario de municipio figura  vicente mullisaca	data/archivos/273_1618.pdf	1	1	2	2023-10-28 21:48:41.387078
1619	341	certificado posesion 2023 de la municiplaidad lote 14	data/archivos/341_1619.pdf	1	1	2	2023-10-30 06:50:02.19908
1620	400	alto inclan 11 plano	data/archivos/400_1620.pdf	1	1	2	2023-10-30 17:47:48.383198
1621	400	menoria  lote 11	data/archivos/400_1621.pdf	1	1	2	2023-10-30 17:48:21.669308
1622	168	plano colindante con adra	data/archivos/168_1622.pdf	1	1	2	2023-11-02 06:07:07.539226
1623	317	plano colindante colegio y adra	data/archivos/317_1623.pdf	1	1	2	2023-11-02 06:07:45.767839
1624	596	plano ubicacion	data/archivos/596_1624.pdf	1	1	2	2023-11-02 06:16:12.647585
1625	611	escritura de compra 2023 octubre	data/archivos/611_1625.pdf	1	1	2	2023-11-03 07:28:55.322513
1626	261	resolucion municipla 00129-99  - año 17 diciembre 1999	data/archivos/261_1626.pdf	1	1	2	2023-11-03 19:33:43.48647
1627	196	ficha registral agosto 2023	data/archivos/196_1627.pdf	1	1	2	2023-11-03 19:44:21.887683
1628	354	constancia de posesion2010 asoc	data/archivos/354_1628.pdf	1	1	2	2023-11-03 20:25:53.0878
1629	331	constancia de posesion de la asoc	data/archivos/331_1629.pdf	1	1	2	2023-11-03 21:11:31.839016
1630	331	pago de recibo	data/archivos/331_1630.pdf	1	1	2	2023-11-03 21:12:05.291033
1631	40	resolucion municipal 2022	data/archivos/40_1631.pdf	1	1	2	2023-11-03 21:18:54.646829
1632	149	recibo agua local	data/archivos/149_1632.pdf	1	1	2	2023-11-03 21:26:11.646732
1633	119	CROXIS	data/archivos/119_1633.pdf	1	1	2	2023-11-05 18:00:01.337886
1634	118	CROXIS	data/archivos/118_1634.pdf	1	1	2	2023-11-05 18:01:00.104125
1635	549	ACTA INSPECCION PREDIAL 2023	data/archivos/549_1635.pdf	1	1	2	2023-11-05 19:22:54.398622
1636	310	CONSTANCIA NOTARIAL 2023	data/archivos/310_1636.pdf	1	1	2	2023-11-05 20:31:17.285384
1637	77	FOTOS DE LPREDIO	data/archivos/77_1637.pdf	1	1	2	2023-11-05 20:50:13.932765
1638	77	CROXIS DEL PREDIO	data/archivos/77_1638.pdf	1	1	2	2023-11-05 20:50:53.201722
1639	77	3 FICHA REGISTRALES	data/archivos/77_1639.pdf	1	1	2	2023-11-05 20:51:30.735942
1640	77	ESCRITURA INPERFECTA	data/archivos/77_1640.pdf	1	1	2	2023-11-05 20:52:20.927363
1641	610	ficha registral 2023  noviembre	data/archivos/610_1641.pdf	1	1	2	2023-11-10 07:52:09.99335
1642	610	ficha registral  2023	data/archivos/610_1642.pdf	1	1	2	2023-11-10 09:24:10.992315
1643	612	dueño autorizacion de pago 2022	data/archivos/612_1643.pdf	1	1	2	2023-11-10 20:50:20.81269
1644	612	contrato de 1re propietario	data/archivos/612_1644.pdf	1	1	2	2023-11-10 20:51:41.553624
1645	612	dni del transferiente	data/archivos/612_1645.pdf	1	1	2	2023-11-10 20:53:14.872513
1646	612	contrato de transferencia 2022	data/archivos/612_1646.pdf	1	1	2	2023-11-10 20:53:56.467859
1647	612	carta de renuncia	data/archivos/612_1647.pdf	1	1	2	2023-11-10 20:54:38.816049
1648	612	ficha registral de la asoc.	data/archivos/612_1648.pdf	1	1	2	2023-11-10 20:55:09.422827
1649	612	constancia de posesion	data/archivos/612_1649.pdf	1	1	2	2023-11-10 20:55:42.479731
1650	612	croxis	data/archivos/612_1650.pdf	1	1	2	2023-11-10 20:56:04.148961
1651	328	plano y menoria descriptiva	data/archivos/328_1651.pdf	1	1	2	2023-11-10 23:46:30.799126
1652	328	ficha registral 3	data/archivos/328_1652.pdf	1	1	2	2023-11-10 23:47:20.87524
1653	328	solicitud visacion de planos	data/archivos/328_1653.pdf	1	1	2	2023-11-10 23:48:10.924377
1654	328	contrato privado de tranferencia a IASD	data/archivos/328_1654.pdf	1	1	2	2023-11-10 23:49:16.060691
1655	328	ficha registral matriz	data/archivos/328_1655.pdf	1	1	2	2023-11-10 23:50:00.640901
1656	328	escritura publica del dueño	data/archivos/328_1656.pdf	1	1	2	2023-11-10 23:51:36.31345
1657	328	ficha registral 01  desmebracion	data/archivos/328_1657.pdf	1	1	2	2023-11-10 23:52:24.523646
1658	451	reolucion  recibido del municipio donde niega la prescripcion predial	data/archivos/451_1658.pdf	1	1	2	2023-11-11 16:30:37.373282
1659	42	ficha registrala n ombre de cofopri	data/archivos/42_1659.pdf	1	1	2	2023-11-11 18:41:24.620063
1660	42	pago de arbitrios predial formullariios de varios años	data/archivos/42_1660.pdf	1	1	2	2023-11-11 18:42:50.995209
1661	267	titulo a nombre de pr Pomari Evaristo	data/archivos/267_1661.pdf	1	1	2	2023-11-11 19:54:23.703836
1662	588	ficha de cofopri detalle de propietarios supuesto	data/archivos/588_1662.pdf	1	1	2	2023-11-11 20:03:28.064724
1663	611	escritura  primejenia de dueños	data/archivos/611_1663.pdf	1	1	2	2023-11-14 12:59:01.756333
1664	611	contrato de transferencia de	data/archivos/611_1664.pdf	1	1	2	2023-11-14 13:02:05.319644
1665	39	minuta de terreno se compro 2023 noviembre	data/archivos/39_1665.pdf	1	1	2	2023-11-24 07:18:03.953061
1666	368	ficha registral a nombre dueños 2023	data/archivos/368_1666.pdf	1	1	2	2023-11-24 07:25:28.898327
1667	368	autovaluo 2023	data/archivos/368_1667.pdf	1	1	2	2023-11-24 07:26:43.623112
1668	499	ficha registral 2023	data/archivos/499_1668.pdf	1	1	2	2023-11-25 08:51:55.660019
1669	67	ficha registral a dueño 2023	data/archivos/67_1669.pdf	1	1	2	2023-11-25 08:52:50.175084
1670	608	ficha registral dueños 2023	data/archivos/608_1670.pdf	1	1	2	2023-11-25 09:03:39.301717
1671	607	ficha registral material apoyo 2023	data/archivos/607_1671.pdf	1	1	2	2023-11-25 09:36:09.265745
1672	607	ficha registral material apoyo 2023	data/archivos/607_1672.pdf	1	1	2	2023-11-25 09:37:01.598901
1673	613	contrato no tiene mucha valides 2023	data/archivos/613_1673.pdf	1	1	2	2023-11-25 22:09:27.649445
1674	475	varios documentos de dueño certificados y ficha yresolucions	data/archivos/475_1674.pdf	1	1	2	2023-11-27 22:54:29.11669
1675	474	docuemntos del dueño varios constancias y resoluciones y registros	data/archivos/474_1675.pdf	1	1	2	2023-11-28 07:28:25.114527
1676	614	docuemntos del dueño constancias posesiony otros	data/archivos/614_1676.pdf	1	1	2	2023-11-28 07:45:32.364558
1677	39	minuta de compra 2023 noviembre	data/archivos/39_1677.pdf	1	1	2	2023-12-02 08:26:57.832846
1678	39	escritura de dueños	data/archivos/39_1678.pdf	1	1	2	2023-12-02 08:28:38.309372
1679	328	ficha registral del vecino	data/archivos/328_1679.pdf	1	1	2	2023-12-02 08:30:45.167357
1680	300	ficha registral 2022	data/archivos/300_1680.pdf	1	1	2	2023-12-10 20:19:32.615326
1681	39	testimonio 2023	data/archivos/39_1681.pdf	1	1	2	2023-12-14 22:00:18.676666
1682	372	palno de ubicacion	data/archivos/372_1682.pdf	1	1	2	2023-12-15 22:14:16.852797
1683	372	memoria decriptiva	data/archivos/372_1683.pdf	1	1	2	2023-12-15 22:14:59.272103
1684	616	testimonio 30 de noviembre 2023 IASD	data/archivos/616_1684.pdf	1	1	2	2023-12-15 23:00:06.160705
1685	368	TESTIMONIO 2023 TESTIMONIO IASD	data/archivos/368_1685.pdf	1	1	2	2023-12-15 23:22:24.133966
1686	617	contrato de transferencia en donacion  2023	data/archivos/617_1686.pdf	1	1	2	2023-12-20 23:12:25.170731
1687	617	recibo de pago por derecho de ingreso	data/archivos/617_1687.pdf	1	1	2	2023-12-20 23:13:24.126299
1688	617	constancia no adeudo del dueño	data/archivos/617_1688.pdf	1	1	2	2023-12-20 23:14:10.902393
1689	617	carta de renuncia del propietario	data/archivos/617_1689.pdf	1	1	2	2023-12-20 23:14:57.305131
1690	549	licencia de funcionamiento 2024	data/archivos/549_1690.pdf	1	1	2	2024-01-06 19:34:35.120199
1691	302	Licencia de funcionamiento 2024	data/archivos/302_1691.pdf	1	1	2	2024-01-06 19:36:14.348928
1692	302	resolucion de fucnciomaniento 2014	data/archivos/302_1692.pdf	1	1	2	2024-01-06 19:37:01.037024
1693	368	ficha registral 2024  IASD	data/archivos/368_1693.pdf	1	1	2	2024-02-05 20:33:11.640892
1694	368	ficha de inscripcion 2024	data/archivos/368_1694.pdf	1	1	2	2024-02-05 20:33:47.360205
1695	109	aforo colegio 2023	data/archivos/109_1695.pdf	1	1	2	2024-02-07 07:05:01.280841
1696	342	FICHA REGISTRAL 2024	data/archivos/342_1696.pdf	1	1	2	2024-02-28 20:23:14.734094
1697	495	pago de arbitrios 2022 IASD	data/archivos/495_1697.pdf	1	1	2	2024-03-04 06:42:32.671726
1698	8	escritura 1955	data/archivos/8_1698.pdf	1	1	2	2024-03-09 21:36:13.409315
1699	8	escritura 1986	data/archivos/8_1699.pdf	1	1	2	2024-03-09 21:36:44.272556
1700	615	escritura publica de dueños 2024	data/archivos/615_1700.pdf	1	1	2	2024-03-16 19:36:58.480782
1701	399	recibo de agua	data/archivos/399_1701.pdf	1	1	2	2024-03-16 20:04:53.171201
1702	193	ficha  de cofopri 2024	data/archivos/193_1702.pdf	1	1	2	2024-03-19 22:12:08.905253
1703	13	ficha de coofpri 2024	data/archivos/13_1703.pdf	1	1	2	2024-03-19 22:13:53.73885
1704	13	ficha de cofopri 2024 de hojas	data/archivos/13_1704.pdf	1	1	2	2024-03-19 22:15:18.933921
1705	8	ficha cofopri 2024	data/archivos/8_1705.pdf	1	1	2	2024-03-20 20:47:19.453836
1706	13	plano ubicacion 2024	data/archivos/13_1706.pdf	1	1	2	2024-03-24 18:58:31.778827
1707	190	plano de ubicacion 2024	data/archivos/190_1707.pdf	1	1	2	2024-03-24 19:15:59.609593
1708	194	posecion yotros	data/archivos/194_1708.pdf	1	1	2	2024-03-25 22:32:49.957407
1709	191	comprobante de pago municipio y otros	data/archivos/191_1709.pdf	1	1	2	2024-03-26 19:05:07.705694
1710	405	pago de arbitrios 2015	data/archivos/405_1710.pdf	1	1	2	2024-03-26 19:14:16.373327
1711	190	cofopri ficha registral	data/archivos/190_1711.pdf	1	1	2	2024-03-28 15:19:14.29173
1712	353	plano ubicacion	data/archivos/353_1712.pdf	1	1	2	2024-04-23 17:25:18.565844
1713	302	defensa civil 16 de mayo 2024	data/archivos/302_1713.pdf	1	1	2	2024-05-24 23:46:01.869326
1714	168	resolucion nombramiernto director forga 2024  mayo	data/archivos/168_1714.pdf	1	1	2	2024-05-24 23:53:48.115352
1715	615	ficha registral 2024 mayo	data/archivos/615_1715.pdf	1	1	2	2024-05-25 00:03:17.796592
1716	549	resolucion de inicial 2024 mayo	data/archivos/549_1716.pdf	1	1	2	2024-05-28 14:31:11.164684
\.


--
-- Data for Name: predios_deprec; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_deprec (id, id_predio, nivel, anti, categ, valunit_m2, deprec_perc, deprec, valunit_deprec, areaconst_m2, areaconst_val) FROM stdin;
\.


--
-- Data for Name: predios_docum; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_docum (id_predio, conditerreno, valordocum, id_modo, id_moneda, transdocum, adquidocum, id_titulo, nro_titulo, id_fedatario, nombrefedatario, fechadocum, foliodocum) FROM stdin;
46	171	0.0000	120	125			148		111		1900-08-31	
16	170	2000.0000	113	124	Luis Estuardo Barba Briceño - Petronila Elizabeth Barrantes Asenjo	 Iglesia Adventista del Septimo Dia	126	1414-2000	109	Miguel Angel Linares Riveros	2000-07-19	0
17	170	2000.0000	113	123	Alejandro Huaira Yauri - Hermelinda Meza Sarmiento	 Iglesia Adventista del Septimo Dia	126	3709	109	Cesar A. Fernandez Davila Barreda	1994-03-02	0
51	170	0.0000	113	125			133		112		2014-08-01	
37	170	1200.0000	113	124	Francisco Ticona Illachura	 Iglesia Adventista del Septimo Dia	126	993	109	Luis Vargas Beltran	1997-09-10	
23	170	58000.0000	113	123	Angel Salomon Pacho Aduvire	Iglesia Adventista del Septimo Dia	126	0285-2014	109	MIGUEL ANGEL LINARES RIVEROS	2014-03-14	
48	170	7500.0000	113	123	Zenon Vilaca flores	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	126	2140	109	Jose Luis Concha Revilla	2010-06-15	
89	170	1500.0000	113	123	Felipe Mamani Siña	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	143		110	Marcos H Quenta Rodriguez	2000-11-05	
85	170	800.0000	113	123	Juan Choque Mamani	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	140	102	110	German Lopez Quispe	2000-06-03	
29	170	242000.0000	113	124	Hilario Nicolas Nuñez Vilca	Iglesia Adventista del Septimo Dia	126	0485-2013	109	Linares Riveros	2013-04-25	
3	170	2000.0000	113	124	Zoila Huanca Ancco	Asoc. Union Peruana de la Iglesia Adventista del Septimo Dia	126	1356-2002	109	Miguel Angel Linares Riveros	2002-08-21	-
42	170	1700.0000	120	123	Edita Terrones Lopez	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	144	po6198763	112		2008-10-03	
41	170	16000.0000	113	124	Sabino Lorenzo Vizcarra Tumba	 Iglesia Adventista del Septimo Dia	126	1394-2002	109	Linares Rivero	2002-09-13	3424
36	170	15000.0000	119	123	Jhon Jackson Ponce Rodriguez y luisa Adela Apaza	Eulalia Calachua Condori de Mango	139		109	Linares Rivero	2013-10-21	
27	170	177135.0000	113	123	Juana Agripina Velarde Romero Viuda de Roque	Iglesia Adventista del Septimo Dia	126	1314	109		2013-07-15	
30	170	10000.0000	113	124	Domino Guzman Copa Francisca Calderon Charaña	 Iglesia Adventista del Septimo Dia	128	1020	109	Anguis Sayers  Viuda De Adawi, Elba Aurora	2016-06-23	
21	170	500.0000	113	121	Upis Rafael Belaunde Diez Canseco	Asociacion Union Incaica de la Iglesia Adventista del Septimo Dia	144		112	-	1994-03-21	0
5	170	14000.0000	113	124	-Luis Cristhoper Escobedo Clemente	 Iglesia Adventista del Septimo Dia	126	2457	109	Jose Luis Concha Revilla	2009-07-24	-
28	170	0.0000	117	125	Cofopri	Iglesia Adventista del Septimo Dia	144	2013-00074206	112		2013-06-25	
69	170	0.0000	117	125	cofopri	Iglesia adventista del septimo Dia	144		112		2003-09-08	
7	173	900.0000	120	123	Asoc.de Vivienda tres Balcones del Misti	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	137		112		2010-04-14	
18	170	5000.0000	113	124	Simon Arapa Ccasa	 Iglesia Adventista del Septimo Dia	126	3709	109	Cesar A. Fernandez Davila Barreda	2000-05-29	0
43	170	70670.0000	113	123	Municipalidad  provincial de Arequipa	asociacion union Peruana de la Iglesia Adventista del Septimo Dia	126	2361	111	Fernandez Davila Barreda	1989-12-29	
71	170	555.0000	113	123	Asociacion de Vivienda Jose Carlos Mariategui	 Iglesia Adventista del Septimo Dia	126	3177	109	E.Aurora Anguis de Adawi	1999-05-11	
76	170	6000.0000	114	123	General Conference Corporation Of  Seventh Day Adventists	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	138	216	109	Pablo Velasquez Julca	2000-08-29	
39	170	0.0000	119	125	CPM La Yarada	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	139	1455-97	112	Roberto Ticahuanca Arpasi ( Alcalde)	2002-01-01	
24	170	7557.0000	113	124	Juan Carlos Alvarez Garcia	Iglesia Adventista del Septimo Dia	126	1117-2012	109	MIGUEL ANGEL LINARES RIVEROS	2012-10-11	1117
25	170	175000.0000	113	124	Domingo Guzman Copa	Iglesia Adventista del Septimo Dia	126	10877	111	Patricia Graciela Aracelly Viacava Portugal	2013-09-18	
35	170	4000.0000	113	123	Ramona Inchuña Huanca	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126	232	109	Luis Vargas Beltran	2004-06-11	
1	170	300000.0000	113	121	Justo Miranda Quispe	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	126	2690	109	J. Guillermo Mayca Valverde	1978-08-25	8276
86	173	0.0000	120	125	Municipalidad Distrital de Bella Union	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	148	p06182378	112		2011-08-26	
2	170	9000.0000	113	124	Agripina Mojo Valeriano	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	126	0	111	Marcela Patricia Alvarez Portocarrero	1998-09-09	0
33	170	0.0000	114	125	Canahuri Jahuira Flora 	Iglesia Adventista del Septimo Dia	138		111	Soto Gamaro	2014-06-03	
8	170	8000.0000	114	123	General Conference Corporation of Sevenday Adventist	Asoc. Union Peruana de la Iglesia Adventista del Septimo Dia	138	174-2000	109	Pablo Velasquez Julca	2000-05-17	-
26	170	58000.0000	113	124	Ale Chura Veronica Fortunata	Iglesia Adventista del Septimo Dia	126	696	109	Dra. Prescila Mendez Payehuana	2014-07-25	
32	170	2000.0000	113	124	Grover Mario Flores Aro	 Iglesia Adventista del Septimo Dia	126	1731	109	Soto Gamaro	2007-11-30	
34	170	0.0000	114	125	Resolucion Municiplalidad 	Asoc.Union Incaica del la Iglesia Adventista Del Septimo Dia	141	2322-84-MPT.	112	Presidente  Antonio Garcia Ale	1991-12-20	
12	170	0.0000	119	125	Cofopri Uso otros fines	Iglesia Adventista del Septimo Dia	144	-	112	-	2020-03-12	-
19	170	7000.0000	113	123	Antonio Chavez Chavez	Iglesia Adventista del Septimo Dia	126	0481-2012	109	Miguel Angel Linares Riveros	2012-05-02	-
44	170	600.0000	113	123	victoria Serafina Calsina Portillo 	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	126	13445	109	Gorky Oviedo Alarcon 	1987-10-03	
45	170	0.0000	113	125	Juan  Ramon Chahuasonco Ccoa	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	126		109		1990-06-03	
4	170	580000.0000	113	122	Gerardo Pacheco Gonza, Juana Porfiria Quispe Baca	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	126	2331	109	Cesar Fernandez Davila Barreda	1989-12-29	-
13	173	0.0000	120	125	Municipio Distrital Nicolas de Pierola 	Asociacion Union Incaica de la Iglesia Adventista del Septimo Dia	134	0	112		1983-06-22	0
50	170	0.0000	119	125			141		112		1900-09-01	
58	170	0.0000	119	125			139		112		1900-09-02	
87	170	2500.0000	113	123	Lino Cupertino Tutacano Vilca	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	126	265	109	carlos Soto coaguila	2009-10-06	
134	170	84000.0000	113	122	CONSEJO DISTRITAL DE CAYLLOMA	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	140		110		1900-10-31	
417	172	0.0000	118	125			134		112		1990-02-22	
151	170	1195000.0000	114	121	BLANCA OROSCO CUENTAS	Iglesia Adventista del Septimo Dia	138	345	109	DORA RAMOS DE FLOR 	1984-11-16	
74	170	5120.0000	114	123	Alarcon Bartolome Juan Pablo	Iglesia Adventista del Septimo Dia	138	1679	109	ROSARIOBOHORQUEZ VEGA	2015-08-25	
59	170	0.0000	120	125	Municipalidad Distrital de Inclan	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	134		112		2002-11-16	
72	170	5120.0000	114	123	Rios Chavez Norma Yilma	Iglesia Adventista del Septimo Dia	138	1680	109	ROSARIOBOHORQUEZ VEGA	2015-08-13	
105	170	1100.0000	113	123	ANTONIO RAMOS DE BRITO	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	400	109	ALONSO DE RIVERO BUSTAMANTE	1998-07-06	1639
73	170	0.0000	117	125	asoc. Vivienda Villa Francisco	 Iglesia Adventista del Septimo Dia	145		112	 cofopri	1991-08-23	
152	170	4000.0000	113	124	FIDEL FRANCISCO NINA NINA	 Iglesia Adventista del Septimo Dia	126	163	109	JHON SOTO GAMERO	1999-06-08	
78	170	37800.0000	114	123	General Conference Corporation Of  Seventh Day Adventists	Asoc. Union Peruana de la iglesia Adventista del Septimo Dia	138	216	109	Pablo Velasquez Julca	2000-08-29	
100	170	300000.0000	113	122	SEVERIANO RIVERA PIZARRO	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	126	2840	109	Rosario C. Bohorquez Vega	2002-12-03	
90	170	10100.0000	114	123	Jose Fernando Lazarte Solorzano 	Iglesia Adventista del Septimo Dia	138		109		2018-09-18	
88	170	1500.0000	113	123	Rufina Condori Mamani 	 iglesia Adventista del Septimo Dia	126	772 - P06249201	109	carlos Soto coaguila	2010-06-23	
114	170	6000.0000	113	123	ALICIA VILCA CAMA	Iglesia Adventista del Septimo Dia	126	465-2011	109	MIGUEL ANGEL LINARES RIVEROS	2011-05-06	
101	170	10000.0000	113	122	CARLOS PINTO MUÑOZ	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	126	383-1988	109	JORGE BERRIOS VELARDE	1988-07-22	1631
57	170	0.0000	114	125			139		112		2014-09-02	
53	170	23000.0000	113	124	Guillermo Cacerez Ordoñez y otra	 Iglesia Adventista del Septimo Dia	126	1090	109	Luis Reinero Vargas Beltran	2007-08-27	
146	170	8187.6000	113	124	CARLOS FRANCO CASTILLO	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	771	109	carlos Soto coaguila	2010-06-23	
156	170	8000.0000	113	123	ESPOSOS RUIZ ZEGARRA	 Iglesia Adventista del septimo dia	126	3006	109	JOSE LUIS CONCHA REVILLA	2009-09-09	
119	170	400.0000	113	124	MARIA AURORA TICONA  MORALES	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	155-2001	109	MIGUEL ANGEL LINARES RIVEROS	2001-03-09	
70	170	9000.0000	113	124	Ernesto Choque Yapurasi 	 iglesia Adventista del Septimo Dia	126	685	109	Luis Vargas Beltran	2010-09-14	
75	170	5120.0000	114	123	Alarcon Bartolome Josue Jeremias	Iglesia Adventista del Septimo Dia	138	687	109	ROSARIOBOHORQUEZ VEGA	2015-08-13	
66	170	0.0000	117	125	Municipalidad provincial	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	145	834	109	Daisy Morales de Barrientos	1995-08-25	
55	170	0.0000	119	125	Municipalidad de Sama Inclan 		139		112		1997-09-11	
79	170	3840.0000	117	123	General Conference Corporation Of  Seventh Day Adventists	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	144	216	109	Pablo Velasquez Julca	2000-08-29	
65	170	10000.0000	113	121	Luciano Quispe de la Cruz 	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126	128	109	Alfonso de Riveros Bustamante	1998-02-20	
82	170	36157.5000	113	123	ADAN MAMANI GUTIERREZ	Iglesia Adventista del Septimo Dia	126	419	109	Luis Vargas Beltran	2011-05-22	
107	170	50000.0000	113	124	GLADYS VICENTA  CISNEROS  MOSQUERA	 Iglesia Adventista del septimo dia	126	0817	109	MIGUEL VILLAVICENCIO CARDENAS	2009-08-14	
52	170	0.0000	114	125	Quispe de Carcausto Juana	Iglesia Adventista del Septimo Dia	138		109		2015-02-20	
64	170	1024.0000	113	123	Consuelo Soledad Mamani Castro	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126	599	109	Luis Vargas Beltran	2011-07-15	
61	173	2000.0000	115	124	Vicencia Vargas Quispe	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	144		109	luis Gustavo Zegner Abarca	1993-11-18	
80	170	800.0000	113	121	MAMANI LOPEZ Y SUSANA LUBE JALIRE	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	140		110	VICTOR QUISPE VELASQUEZ	2002-04-05	
60	170	6500.0000	113	124	Robinson Felipe Pereira Tellez 	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126	431	109	Luis Vargas Beltran	2002-06-03	
136	170	5000.0000	113	123	ROSA ELENA SERRANO LLERENA VDA DE CONCHA	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	572	109	CESAR OMAR FLORES MONJE	2004-10-19	
138	170	2500.0000	113	123	LENADRO LERMA JAILA	Iglesia Adventista del Septimo Dia	126	636-p06279131	109	CESAR OMAR FLORES MONJE	2012-11-12	
112	170	11550.0000	113	123	LUIS ANGEL BENITES  CASTAÑEDA	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	429	109	GINO BARNUEVO CUELLAR	2008-03-27	
116	170	2000.0000	113	123	LUIS JACINTO MIRANDA	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	314-2001	109	MIGUEL ANGEL LINARES RIVEROS	2001-05-15	
117	170	3000.0000	113	123	FERNANDA GAVINA SEÑA QUISPE	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	1831-2004	109	MIGUEL ANGEL LINARES RIVEROS	2004-08-27	
102	170	4500.0000	113	124	BRIGIDA LLACHI  MAMANI	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	2578	109	DAISY MORALES DE BARRIENTOS	2001-06-07	9503
62	170	5000.0000	113	123	Asociacion  de vienda Mariscal Miller	 Iglesia Adventista del septimo dia	126	885	109	E.Aurora Anguis de Adawi	1998-06-17	
81	170	0.0000	119	125	MUNICIPALIDAD DISTRITAL DE CAMILACA	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	139		112		2001-03-23	
104	170	2000.0000	113	123	JUAN CARLOS TORREALVA CALLIRGOS	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	4661	109	GORKY OVIEDO ALARCON 	1997-08-19	
54	170	40000.0000	113	124	Alex Gregorio Grande Ale	 Iglesia Adventista del Septimo Dia	126	636	109	Luis Reinero Vargas Beltran	2009-11-17	
131	170	2400.0000	114	123	CORPORACION GENERAL DE LOS ADVENTISTAS	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	138	174	109	PABLO VELAZQUEZ JULCA	2000-08-29	564
139	170	20000.0000	113	121	CONSEJO DISTRITAL  DE ORCOPAMPA	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	144	172-po6211174	109	EDMUNDO BENVIDES BENAVENTE	1982-06-02	
181	170	4800.0000	113	124	JULIA NINA HUAMAN HUAL	JESUS ENRRIQUE GIL QUISPE	130		111	JORGE ASÍLCUETA CACERES	2009-07-03	
115	170	2500.0000	120	124	ASOC. URBANIZADORA PERUNAO -ARGENTINO -BOLIVIANO "PERUARBO"	Iglesia Adventista del Septimo Dia	143		112	ASOC. URBANIZADORA PERUARBO	2004-07-21	
223	170	600.0000	113	123	BASILIO QUISPE MAMANI	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	144	P06076834	112		1994-05-27	
133	170	0.0000	114	125	MUNICIPALIDAD CENTRO POBLADO DE JACHAÑA	Iglesia Adventista del Septimo Dia	140		110	ZENON VICTOR INFA CHAMPI	2004-09-01	
144	170	0.0000	120	125	MUNICIPALIDAD PROVINCIAL DE CASTILLA	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	139		112		2006-08-01	
132	173	0.0000	119	125	cofopri	Asoc Union Peruana de la Iglesia del septimo dia	144		112		1983-06-16	
111	170	47349.0000	114	123	Coaquera Cahui Francisco Pablo	Iglesia Adventista del Septimo Dia	126	424	109	Oscar Valencia Huisa	2016-05-13	
145	170	1000.0000	114	123	FIDEL CLAUDIO CONDORI QUISPE	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	138	1524-2000	109	MIGUEL ANGEL LINARES RIVEROS	2000-09-06	
113	170	0.0000	119	125	CONCEJO PROVINCIAL MARISCAL NIETO	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	141		112		1999-10-13	
155	170	1181.0000	114	123	ROSALIA MARGARITA CONDORI JAYO	 Iglesia Adventista del Septimo Dia	138		109	JHON SOTO GAMERO	2014-06-09	
110	170	3599.7500	119	123	COFOPRI	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	144		112	COFOPRI	2004-05-24	
150	170	3690.0000	114	123	uninio Incaica Iglesia adventista del Septimo Dia	 Iglesia Adventista del Septimo Dia	138	194	109	PABLO VELAZQUEZ JULCA	2000-08-29	645
143	173	1300.0000	113	123	JOSE SANTIAGO USCAMAYTA  TORRES	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	143		112		2005-08-31	
183	170	0.0000	119	125	cofopri		148		112		1900-11-10	
184	170	1800.0000	113	123	AGUSTIN QUISPE ARAPA	 Iglesia Adventista del Septimo Dia	126	1654-2006	109	MIGUEL ANGEL LINARES RIVEROS	2006-11-13	
118	170	340.0000	113	123	FRANCISCO HUAMANVILCA POZO	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	126	1166	109	MIGUEL ANGEL LINARES RIVEROS	1991-12-04	
193	170	6000.0000	114	123	CORPORACION  DE LA CONFERENCIA  GENERAL DE LOS ADVENTISTAS	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138	174	109	PABLO VELASAQUEZ JULCA	2000-08-29	
177	170	3100.0000	113	124	BANCO DE CREDITO DEL PERU	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	3415	109	GOMEZ DE LA TORRE	2000-11-23	12792V
168	170	900000.0000	113	121	NEMESIO JESUS LLANOS MAMANI	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	2672	109	GUILLERMO  MAYCA VALVERDE	1978-08-22	
140	170	20000.0000	120	123	MAURA JUSTINA ALVAREZ QUINTANA	JESUS VIVANCO CACERES-MPS	130	p06211098	109	Miguel Angel Linares Riveros	2012-08-02	
159	170	7000.0000	113	123	ABEL VILLA CABALLERO 	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	1187	109	EDUARDO BENAVIDES BENAVENTE	1999-12-29	
142	170	22080.0000	113	123	NATALI YOLANDA  ZEBALLOS NUÑEZ	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	1404	109	GORKY OVIEDO ALARCON 	2011-04-20	
216	170	4000.0000	113	124	JUVENAL BASURCO SALAS	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	0606-2007	109	MIGUEL ANGEL LINARES RIVEROS	2007-07-19	
141	173	180000.0000	113	122	GODOFREDO VALDEIGLESIAS ANGULO	MISION PREUANA DEL SUR DE LA IGLESIA ADVENTISTA	140		110		1990-11-01	
195	170	13000.0000	113	124	JUANJOSE AMPUERO BASURCO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	650	109	ALEJANDRO PAREDES ALI	2002-06-04	
221	170	200000.0000	113	122	FELIPE CHAMBI TURPO	 Iglesia Adventista del Septimo Dia	126		109	CESAR A. FERNANDEZ DAVILA BARRERA	1988-05-23	
149	170	7000.0000	113	123	NEMESIO TOMAS SOLIS CANO	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	1317	109	carlos Soto coaguila	2011-09-27	
129	170	16000.0000	114	123	CORPORACION GENERAL DE LOS ADVENTISTAS	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	138	174	109	PABLO VELASQUE JULCA	2000-08-29	564
160	170	66972.0000	113	122	Municipalidad  provincial de Arequipa	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	126	2223	109	Fernandez Davila Barreda	1989-12-11	
164	170	50000.0000	113	123	LEONIDAS GERARDO GARCIA MENDEZ	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	896-2014	109	MIGUEL ANGEL LINARES RIVEROS	2014-09-26	
120	170	12000.0000	113	124	JOSE ANTONIO GARCIA NIETO	 Iglesia Adventista del septimo dia	126	681	109	JAVIER RODRIGUEZ VELARDE	2003-04-15	
135	170	900.0000	119	122	Cofopri Uso otros fines	 Iglesia Adventista del Septimo Dia	144		112		2020-02-13	
162	170	550000.0000	113	122	ZOILA TEODORA ISABEL GUTIERREZ LEIVA	Iglesia Adventista del Septimo Dia	126	5055	109	CESAR A. FERNANDEZ DAVILA BARRERA 	1988-06-02	
194	170	0.0000	119	125	CONSEJO DISTRITAL DE ISLAY	IGLESIA ADVENTISTA DEL SEPTIMO DIA	141		112		1983-12-31	
215	170	2750000.0000	113	122	OTTO ENRRIQUE VARGAS	 Iglesia Adventista del Septimo Dia	126		109	CESAR A. FERNANDEZ DAVILA BARRERA	1991-02-18	
200	170	3500.0000	113	123	GENARO TURPO LOPEZ	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	2214	109	FRANCISCO  BANDA CHAVEZ	1995-12-27	
137	170	1700.0000	113	124	CORPORACION GENERAL DE LOS ADVENTISTAS	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	138	174	109	PABLO VELAZQUEZ JULCA	2000-08-29	
165	170	0.0000	119	125	P.J. ASENTAMIENTO HUMANO 13 DE MAYO 	ASOC. UNION PERUANA DE LA IGLESIA	144		112		2012-07-16	
161	170	235.1200	113	123	CONSEJO PROVINCIAL DE AREQUIPA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	141		112		1900-11-06	
202	170	5000.0000	113	123	CARLOS DANTE HUAMAN	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126		109	JORGE ORIHUELA IBERICO	2000-10-05	
182	170	0.0000	114	125	Lucio Luna Apaza		139		112		2012-01-24	
153	170	0.0000	119	125	CONSEJO PROVINCIAL 	Iglesia Adventista del Septimo Dia	144	p08016892	112		1984-10-04	
198	170	10000.0000	114	123	JOSIAS ROJAS MEJIA	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	144	p06027537	112	COFOPRI	2000-02-14	
187	170	1450.0000	113	124	MARCOS MORAN BORDA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126		109	CESAR A. FERNANDEZ DAVILA BARRERA	1993-03-12	
259	170	3000.0000	113	124	ANTONIO ICHUÑA ATENCIO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	419	109	LUIS REINERO VARGAS BELTRAN	2002-05-27	
180	170	1500.0000	113	123	JUANA SEGUNDINA MAMANI TURPO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	143	municipio adjudica	112		2023-07-20	
265	170	0.0000	117	125	 Comision de la formalizacion de la propirdad informal	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	144	p20014293	112	COFOPRI	2007-06-03	
267	170	0.0000	119	125	Municipalidad de Tacna 	EVARISTO POMARI QUIROZ	147		112		2005-11-07	
238	170	0.0000	119	125	Aguilar Flores Manuel	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138		112		2006-10-13	
219	170	230000.0000	113	122	MANUEL ARA BORDA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126		109	DAISY MORALES DE BARRIENTOS	1994-11-09	
222	170	7787.0000	113	124	ANGELICA VELAZCO LINARES	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	1231-2002	109	MIGUEL ANGEL LINARES RIVEROS	2002-07-11	
251	170	100000.0000	113	121	HONORIA ANGELICA ALVAREZ YANQUE	 Iglesia Adventista del Septimo Dia	126	1441-p06094720	109	GUILLERMO  MAYCA VALVERDE	1977-11-30	
189	170	6500.0000	113	123	Gonzales y Panca Alejandro 	 Iglesia Adventista del Septimo Dia	126	1487	109	Miguel Angel Linares Riveros	2003-03-27	
256	170	1500.0000	113	124	ALVARO WILFREDO HUANCA HUANCA	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	1064	109	LUIS REINERO VARGAS BELTRAN	2005-11-04	
190	170	1500.0000	113	123	MARIA IRMA VALENCIA DE CHAVEZ	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	2943	109	GUILLERMO  MAYCA VALVERDE	1976-09-24	
169	170	0.0000	115	125	FELIPE FROILAN CHIRINOS ROJAS	ASOC. UNION PERUANA DE LA IGLESIA	128		109	MIGUEL ANGEL LINARES RIVEROS	2004-04-22	
188	170	0.0000	114	125	Eustaquia Usedo Tintaya	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138	346-2001	109	MIGUEL ANGEL LINARES RIVEROS	1900-11-11	
254	170	6000.0000	113	123	CALOS ABRAHANGONZALES CHAVES	 Iglesia Adventista del Septimo Dia	126	7308	109	JAVIER DE TABOADA	2001-08-01	
236	170	0.0000	119	125	MUNICIPALIDAD DE MARISCAL NIETO	 LA IGLESIA ADVENTISTA	132	900-H00-0030	112	Alcalde Giuseppe Baldi Cogo	1987-03-11	
197	170	1000.0000	115	123	YANCI CASILDO LERMO	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	143		112		1995-10-23	
280	170	1500.0000	114	123	MARIA ELENA ELMA CHOQUE	ASOC. UNION PERUNA  DE LA IGLESIA ADVENTISTA	138	1172	109	LUIS VARGAS BELTRAN	2006-08-01	
270	170	4200.0000	113	124	MANUEL CHOQUECOTA ROQUE	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	129		109	Dayse Morales de Barrientos	2004-07-05	
224	170	20000.0000	113	123	MATIAS JOSE IHUI CHANI	Iglesia Adventista del Septimo Dia	126	1052-2011	109	Miguel Angel Linares Riveros	2011-11-21	
233	170	0.0000	119	125	Adjudicacion cofopri 	Iglesia Adventista del Septimo Dia	144		109	CESAR A. FERNANDEZ DAVILA BARRERA	2016-11-11	
230	170	0.0000	114	125	CARMEM ROSA SACACA DE CCASA prescripcion	Iglesia Adventista del Septimo Dia 	138	0268-2019/NC	109	MIGUEL ANGEL LINARES RIVEROS	2019-04-30	
255	170	18500.0000	113	124	SEGUNDO SANDRO RODRIGUEZ ORTIZ	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	139	0380-2003	109	MIGUEL ANGEL LINARES RIVEROS	2003-03-04	
170	170	4645.9000	113	124	FELIPE FROILAN CHIRINOS ROJAS	ASOC. UNION PERUANA DE LA IGLESIA	126	655	109	MIGUEL ANGEL LINARES RIVEROS	2003-12-15	
261	170	15742.8900	119	123	COFOPRI	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	144		112		2000-06-29	
172	170	220000.0000	113	122	ROSA VILLAFUERTEVDA DE VALDIVIA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	3711	109	JOSE LUIS CONCHA REVILLA	2000-08-18	
171	170	1800.0000	113	124	ALBERTO APAZA MACHACA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126		109	CESAR A. FERNANDEZ DAVILA BARRERA	1994-09-22	
276	170	5000.0000	113	121	LORENZA CHOQUE DE ZALAMANCA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	143		110	ALFONSO TELLERIA RAMOS	1981-06-15	
260	170	15000.0000	114	123	ELIAS MARCA COTRADO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138	1361	109	LUIS VARGAS BELTRAN	2003-12-01	
163	170	4000.0000	116	123	FABIAN CHOQUEHUANCA PUMA	ASOC. UNION PERUANA DE LA IGLESIA	135	1461	109	MIGUEL ANGEL LINARES RIVEROS	2002-10-15	
421	170	0.0000	119	125			137		112		1990-02-22	
250	170	1848.0000	119	123	ASOC. PROVIVIENDA DE INTERESES SOCIAL CORAZON DE JESUS	 Iglesia Adventista del Septimo Dia	147	008689	109	JAVIER DE TABOADA	1994-06-15	
178	170	0.0000	119	125	Felipe Miranda		148		112		1900-11-10	
258	170	2800.0000	113	124	ROBERTO MARTIN MAMANI LUCERO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	263	109	LUIS VARGAS BELTRAN	2002-03-27	
186	170	3500.0000	117	123	EMETERIO HUANCA MAMANI	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	145	1535-p06082844	109	MIGUEL ANGEL LINARES RIVEROS	2000-09-12	
241	170	0.0000	120	125	COOP. AGRARIA  DE PRODUCCION SANTA RITA N° 52	IGLESIA ADVENTISTA DEL SEPTIMO DIA	139		112		1982-03-05	
275	170	0.0000	120	125	Santos Llanpazo Pacci Dona a IASD		139		111		1900-11-19	
192	170	30000.0000	113	121	EVARISTA VELZ DE ARENAS	 Iglesia Adventista del Septimo Dia	126	70 p06158873	109	AGUSTO VALDIVIA	1976-04-21	
218	170	1000.0000	113	123	ALEJANDRO DOMINGUEZ LOPEZ	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	1160	109	DAISY MORALES DE BARRIENTOS	1994-09-06	
191	170	2900.0000	113	123	PERCY CABANA MAMANI	ABEL ALFREDO CABRERA SUPANTA	126	54	109	DAVID ALFREDO NEYRA SALOMON	2012-02-22	
240	170	7000.0000	114	123	Edagar Lizandro Quispe Laurente	Iglesia Adventista del Septimo Dia	138	585	109	Elba Aurora Anguie de adawi	2016-04-22	
423	170	0.0000	119	125			137		112		1990-02-22	
173	170	0.0000	115	125	PRESCRIPCION Adquisitiva de dominio	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	147	061-2002	109	MIGUEL ANGEL LINARES RIVEROS	2002-06-28	
263	170	10000.0000	114	124	PEDRO ANTONIO CHAVES LOPEZ	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138	625-2005	109	MIGUEL ANGEL LINARES RIVEROS	2005-09-05	
175	170	1040.0000	113	123	CARMEN GLORIA CHOQUEHUANCA MACEDO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	1509	109	FERNANDO D. BEGAZO DELGADO	2001-05-17	
174	170	30000.0000	113	123	GERONIMO APAZA CARLOS	Iglesia Adventista del Septimo Dia	126	6649	109	Ruben Bolivar Callata	2020-10-16	
274	170	1000.0000	113	123	SEVERINO VARGAS TICONA	ASOC. UNION PERUNA  DE LA IGLESIA ADVENTISTA	140		110	GUILLERMO CAIPA LUQUE	2002-09-20	
239	170	2300.0000	113	124	Lorenzo Chuquitaipe Cruz	Iglesia Adventista del Septimo Dia	147		109	 Anguis de adawi aurora	2015-10-16	
225	170	3000.0000	113	123	FREDY CAHUANA BUSTINZO 	 Iglesia Adventista del Septimo Dia	126	5233	109	JAVIER DE TABOADA	2010-06-08	
237	170	3000.0000	113	123	PETER ALBERT CONTRERAS RODRIGUEZ	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	1293	109	LUIS VARGAS BELTRAN	2001-12-03	
227	170	700.0000	119	123	DIRECTIVA Y LA POBLACION DEL PUEBLO	IGLESIA ADVENTISTA DEL SEPTIMO DIA	139		112		1900-01-16	
315	170	0.0000	119	125			139		112		2000-12-12	
314	170	0.0000	119	125			137		111		1999-12-12	
343	170	0.0000	119	125	Municipio	Montañez Ccorpuna Martin DNI 30400995	139		112		1990-02-22	
297	170	4500.0000	115	123	Cecilio Caceres Samayani	Ruben Salomon Miranda Flores 	139		111		2011-09-28	
287	170	80000.0000	119	122	Jorge Casas 	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	267	109	Carlos Gonzales Ibarcena	1988-11-14	
288	170	2500.0000	113	123	Jorge Gonzalo Tito del Mar	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126		109	carlos Soto coaguila Camana	2009-10-06	
338	170	0.0000	119	125			137		111		1900-02-22	
326	170	0.0000	119	125			137		112		1990-02-22	
304	170	3500.0000	113	123	TERESA MILAGROS MARTINEZ FALCON	ISMAEL DELFIN CRUZ	133		110	Leonardo Arenas Gamero 	2011-08-15	
296	170	8000.0000	113	123	Emigdio Casiano Cusi Yanque	Ruben Salomon Miranda Flores 	126	288	109	carlos Gonzales Ibarcena	2011-09-28	
332	170	0.0000	119	125			137		112		1900-02-22	
310	170	21000.0000	113	123	Marco Antonio Flores Flores	Iglesia Adventista del Septimo Dia	130	2765	109	Ruben Raul Bolivar Callata	2017-08-22	
290	170	2700.0000	113	123	Isabel Figueroa 		127	465	109	carlos Gonzales Ibarcena	1999-09-21	
325	173	0.0000	119	125			137		112		1900-02-22	
308	170	0.0000	119	125			137		112		2009-12-11	
249	170	12000.0000	113	124	QUENAYA MAMANI LUCAS	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	139		109	MIGUEL ANGEL LINARES RIVEROS	2010-03-10	
301	170	0.0000	117	125	COFOPRI	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	144		112		2008-06-24	
268	170	0.0000	113	125	Castro Pizarro Isaias Noe	Iglesia Adventista del Septimo Dia	126		109	Linares Riveros Miguel Angel	2017-10-25	
292	170	5000.0000	113	123	Isabel Figueroa Ynfa ver ojo	Abilio Osias Orihuela  ver ojo	129		109	Linares Rivero	2012-09-14	
294	170	3000.0000	113	123	Santiago Flores Benavides	Iglesia Adventista Eden 	140		110		2004-07-20	
306	170	7000.0000	115	123	Francisca Larico Ancco	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	130		110	Juan de la Cruz Castillo Camino	2009-03-03	
298	170	6000.0000	113	121	Juan de Dios HUaracha Inca	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	6323	109	HUGO J CABALLERO LAURA	2020-09-07	
272	170	15129.6700	114	123	Elena Quispe Calle	 Iglesia Adventista del Septimo Dia	138	0757	109	Miguel Angel Linares Riveros	2015-08-25	
283	170	1400.0000	113	124	RAUL CHAMBILLA HUERTA	ASOC. UNION PERUNA  DE LA IGLESIA ADVENTISTA	130		111	CLIMACO TUPA HUALLPA	1996-01-26	
323	173	0.0000	119	125			137		112		1990-02-22	
340	170	0.0000	119	125	Municipalidad Provincial de Caraveli	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	148		112		2000-02-22	
285	170	3230.0000	113	123	Rosario Rosa Chipana Telleria	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	720	109	Luis Vargas Beltran	2009-11-13	
266	170	1300.0000	113	124	SANTIAGO CACERES SALCO	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	127	04	109	LUIS REINERO VARGAS BELTRAN	2003-01-03	
331	173	0.0000	120	125			137		112		1900-02-22	
303	170	34000.0000	113	123	adela Llanos Cutipa	 Iglesia Adventista del septimo dia	126		111		2011-03-30	
333	173	0.0000	120	125			148		112		2007-02-22	
278	170	7200.0000	114	123	CORPORACION  DE LA CONFERENCIA  GENERAL DE LOS ADVENTISTAS	ASOC. UNION PERUNA  DE LA IGLESIA ADVENTISTA	138	216	109	PABLO VELASAQUEZ JULCA	2000-08-29	
273	170	6324.0000	120	123	 Nicasia Quispe Apaza	Vicente Mullisaca Mayta	130		109	Elsa Holgado de Carpio	2010-04-26	
342	170	0.0000	119	125	cofopri	Iglesia Adventista del Septimo Dia	138		112		2016-01-15	
291	170	2880.0000	113	123	Pedro Antonio Sulca Valdivia 	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	262	109	carlos Gonzales Ibarcena	2003-09-24	
252	170	0.0000	120	125	Qquenta Tturo Mauricia	Iglesia Adventista del Septimo Dia (falta titulo)	138		109	Julio E. Escarza Benites	2017-02-28	
293	170	0.0000	119	125	COFOPRI		148		112		1999-11-29	
277	170	0.0000	113	125	FRANCISCO GREGORIO MAMANI	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	143		110	LORENZO VARGAS LAURA	1987-08-01	
281	170	800.0000	113	124	LUCIANO QUISPE DE LA CRUZ	 IGLESIA ADVENTISTA DEL SEPTIMO DIA	127		109	ALONSO DE RIVERO BUSTAMANTE	1998-02-20	
232	170	6800.0000	113	123	JOSE ANTONIO PALOMINO AGUILAR 	ABEL ALFREDO CABRERA SUPANTA	130		112		2010-11-15	
279	170	20000.0000	113	123	JUANA SANJINEZ VDA DE VALDIVIA	UNION INCAICA DE LA ADVENTISTA DEL SEPTIMO DIA	146	169	109	luis Gustavo Zegner Abarca	1989-06-06	
257	170	1500.0000	113	124	FROILAN TICONA APAZA	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	507	109	ROSARIOBOHORQUEZ VEGA	2002-04-17	
234	170	0.0000	119	125	MUNICIPALIDAD DE MARISCAL NIETO	IGLESIA ADVENTISTA DEL SEPTIMO DIA	141		112		1987-12-11	
269	170	0.0000	114	125	VICTOR MANUEL QUEREVALU MERE	Iglesia Adventista del Septimo Dia	138	1425	109	E aurora Anguis Adawi	2018-10-03	
311	170	2300.0000	113	123	Jaime Florentino Hancco Calcina	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126		109	Manuel Pantigoso Quintanilla	2004-02-10	
262	170	0.0000	113	125	ender panduro panduro	Iglesia Adventista del Septimo Dia	138		109	Robert Joaquin Espinoza Lara	2018-09-25	
300	170	1000.0000	113	123	Timote Mamani Chise	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	144	Utoridad autonoma Ma	110	Teresa alave Choque	2001-06-05	
235	170	800.0000	113	123	pedro celerino cuayla mamani	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138	2095	109	VICTOR CUTIPE VARGAS ANGULO	1996-12-20	
341	170	0.0000	119	125			137		112		1990-02-22	
286	170	1558.0000	117	121	COFOPRI	Iglesia Adventista del Septimo Dia	145		112		2001-11-26	
295	170	0.0000	114	125	Marcial Huaycho Lopinta	 Iglesia Adventista del Septimo Dia	138	2256	109	escarza	2017-02-28	
383	170	0.0000	119	125			137		112		1990-02-22	
407	172	0.0000	118	125			134		112		1990-02-22	
362	170	0.0000	119	125			139		111		1990-02-22	
402	172	0.0000	118	125			134		112		1990-02-22	
361	170	0.0000	119	125			139		111		1990-02-22	
371	172	0.0000	118	125			134		112		1990-02-22	
406	172	0.0000	118	125			134		112		1990-02-22	
391	170	0.0000	119	125			139		111		1990-02-22	
347	170	0.0000	119	125			137		112		1990-02-22	
411	170	0.0000	119	125			139		112		1990-02-22	
398	170	57000.0000	113	124	Norma Ruth Apaza Paz	Iglesia Adventista del Septimo Dia	126	1949	109	Hugo J.Caballero Laura	2017-05-16	
409	170	5000.0000	113	123	Alberto Julio Romero Torres	 Iglesia Adventista del septimo dia	126	398	109	Guiselle Vera Kihien	2010-09-15	
392	170	8000.0000	114	123	centeno Rojas Ruben Gregorio	 Iglesia Adventista del septimo dia	138		109		2014-02-04	
328	173	0.0000	120	125			134		112		1990-02-22	
378	170	0.0000	119	125			137		112		1990-02-22	
399	170	0.0000	119	125			137		112		1990-02-22	
339	170	4000.0000	113	123	Crimaldo Condori Condori	Jorge Arturo Gonzales Tito del Mar	130		110	Atico	2011-09-21	
379	170	0.0000	119	125			137		112		1990-02-22	
364	170	1500.0000	113	124	Francisco Juan Hualpa Choque	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	333-356 aclara	109	Luis Vargas Beltran	2006-08-11	
318	170	1000.0000	113	123	Juan de la cruz Sahuanay Quispe	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	126	1155-2003	109	Linares Riveros	2003-12-16	
413	170	4500.0000	113	123	Genaro Mamani Flores	 IGLESIA ADVENTISTA	126	825	109	VICTOR CUTIPE VARGAS ANGULO	1997-10-06	
320	170	1440.0000	113	123	Atencio Huanacuni Demetria	 Iglesia Adventista del Septimo  Dia	126		109	Luis Vargas Beltran	2003-03-11	
337	170	151000.0000	113	123	Hilda Susana Chama Cuadros	IGLESIA ADVENTISTA DEL SEPTIMO DIA	133		109		2018-05-11	
282	170	34000.0000	113	123	ELENA MIRANDA VDA DE CHIPANA	ASOC. UNION PERUNA  DE LA IGLESIA ADVENTISTA	126	103	109	LUIS REINERO VARGAS BELTRAN	2010-02-12	
412	170	0.0000	119	125			139		112		1990-02-22	
319	170	0.0000	114	125	Virginia Manuela Castro Copa	Iglesia Adventista del Septimo Dia	138	1846	109	E aurora Anguis Adawi	2018-11-13	
408	170	1862.4000	119	123	Pedro Efrain La Torre Llasaca	Iglesia Adventista del Septimo Dia	126		109	Vera	2011-05-10	
414	170	0.0000	113	125	Eloy Paco Flores  y Esposa Indira Lindaura De Flores 	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	1311	109	Valencia Huisa Ing. Abogado	2007-01-26	
393	170	96630.0000	113	123	Elmer Genaro Arce Zevallos	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	1821	109	Hugo J. Caballero Laura	2018-04-19	
377	170	0.0000	113	125	Felipe Reynaldo Esteban Silva 	Falta Tranferir  a IASD.	139		112		2004-05-31	
363	170	50000.0000	113	124	Jorge Flores Balcona	Iglesia Adventista del Septimo Dia	126	915	109	Elba Aurora Anguis  de Adawi	2016-06-21	
307	170	0.0000	120	125	Municipalidad Distrital de Ciudad Nueva	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	139	007-2010 p20003613	112	COFOPRI 	2010-02-25	
410	170	0.0000	119	125	Resolucion Municiplalidad 	Asociacion Union Incaica de la Iglesia Adventista del Septimo Dia	141		112		1990-04-03	
351	170	0.0000	117	125	COFOPRI	IGLESIA ADVENTISTA DEL SEPTIMO DIA	144		112		2018-04-09	
356	170	54000.0000	113	123	Ramos Sanchez Jael Noemi	Iglesia Adventista del Septimo Dia	126	2495	109	Mendez Payehuanca Prescila	2015-09-17	
375	170	0.0000	119	125			139		112		1990-02-22	
321	170	2800.0000	113	124	Jose Aguilar Choquehuanca	 Iglesia Adventista del septimo dia	126	1081-99	109	Alonso de Riveros Bustamante	1999-06-03	
370	170	0.0000	114	125			144		112		2018-09-22	
354	170	0.0000	119	125			137		112		1990-02-22	
357	170	0.0000	119	125	cofopri	Iglesia Adventista del Septimo Dia	144	p20070655	112		2015-02-22	
352	170	6000.0000	113	124	 Roger Leo Mamani Juana Sarmiento Limache	 Iglesia Adventista del septimo dia	126	716	109	Luis Vargas Beltran	2007-01-02	
355	170	22188.1300	114	123	Mamani Huanca Avelina	Iglesia Adventistas del Septimo Dia	126	589	109	Priscila Mendez Payehuanca	2015-08-13	
334	170	75000.0000	113	123	Jorge Rolando Uyen Chehade	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	361	109	ANGEL MARTINEZ PALOMINO	2016-07-21	
353	170	15000.0000	113	123	arturo Marcelo Vilca Suarez	Rodolfo   Basilio zapana Mamani	139		111		1990-02-22	
372	170	0.0000	120	125	Certificado de Habitabilidad	Iglesia Adventista del Septimo  Dia	134		112		2002-06-10	
305	170	0.0000	114	125	Municipalidad  centro Poblado San ISIDRO La JOYA-AREQUIPA	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	139		112		2012-01-24	
419	170	0.0000	119	125			137		112		1990-02-22	
359	170	30000.0000	113	123	Avendaño Sucso Percy Alfredo	Iglesia Adventista del Septimo Dia	126	2027	109	Elba Aurora Anguis de Adawi	2016-12-05	
349	170	0.0000	119	125			139		112		1990-02-22	
317	170	900000.0000	113	121	Nemesio Jesus Llanos Mamani-Juana Trinidad Pacheco Milo de Ll.	 Iglesia Adventista del septimo dia	147		111	GUILLERMO  MAYCA VALVERDE	1980-01-18	
403	173	0.0000	120	125			139		112		2022-09-22	
381	173	0.0000	120	125			134		112		1990-02-22	
405	170	0.0000	117	125	 COFOPRI Otros fines uso	Iglesia Adventista del Septimo Dia	144		112		2020-03-12	
302	170	3333.3300	113	121	Maria Asuncion y Blanca Cornejo Iriarte	La General Conferencia Corpration Of Seventh Day Adventiste	126		109	Jose Maria Tejada 	1919-06-11	
401	170	23000.0000	113	123	Valenzuela ore Elmer Henry	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	141	109	Alejandro Predes Ali	2021-11-12	
422	170	0.0000	119	125			137		112		1990-02-22	
394	170	0.0000	119	125			137		112		2014-02-22	
400	173	0.0000	114	125			133		112		2023-01-23	
358	170	0.0000	119	125			137		111		1990-02-22	
425	170	0.0000	119	125			137		112		1990-02-22	
429	172	0.0000	118	125			134		112		1990-02-22	
447	170	0.0000	119	125			137		112		1990-02-22	
513	170	0.0000	119	125			137		112		1900-09-17	
519	170	0.0000	119	125			137		112		1900-10-17	
512	172	0.0000	118	125			134		112		1900-10-09	
520	172	0.0000	118	125			134		112		2015-10-09	
487	170	500.0000	113	122	Angel Fidel  Quispe Carhua	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	140		110	Weslao Panta Lupo	1987-11-26	
468	173	800.0000	118	123	Municipalidad Provincial de Caylloma 	Agencia Adventista de Desarrollo y Recursos Asistenciales	134		112	Municipalidad pronvincial de Caylloma	2001-11-26	
516	170	0.0000	119	125			137		112		1900-10-17	
514	170	0.0000	119	125			137		112		1900-10-17	
515	170	0.0000	119	125			137		112		1900-10-17	
446	170	0.0000	119	125			137		112		1990-02-22	
455	170	0.0000	114	125	Asoc. de vivienda Talleres Nuevo Horizonte	Willy Lenin Moroco Turpo	139		112		2014-03-29	
472	170	10000.0000	113	122	Eliseo Coaguila Flores  	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	47	111	carlos Gonzales Ibarcena	1989-06-26	
545	170	750000.0000	113	124	Mamani Sucapuca German	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	126	0750	109	Miguel Angel Linares	2003-08-06	
22	172	0.0000	118	125			134	-	112	-	\N	-
335	172	0.0000	118	125			134		112		\N	
15	171	0.0000	119	125			137	-	112	-	\N	-
130	170	0.0000	114	125	EUSTAQUIO ALCASIHUICHA CONDORI	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	138		112		1986-06-25	
561	170	0.0000	119	125			139		111		2018-07-10	
344	170	0.0000	119	125			137		112		\N	
346	170	0.0000	119	125			137		112		\N	
551	170	0.0000	119	125			139		111		1900-02-11	
452	170	0.0000	114	125	Delia Linares	Iglesia Adventista del Septimo Dia	139		112		2014-02-22	
479	170	1200.0000	113	123	Siles Fernandez Flor Roxana	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	1103-2003	109	Linares Rivero	2003-05-16	
451	173	0.0000	115	125	Abel Fernandez Champi	Iglesia Adventista del Septimo Dia	133		109	Bolivar	2021-05-24	
428	170	0.0000	119	125			139		112		1990-02-22	
478	170	9500.0000	113	124	cesar Supo Roman	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	211	109	JOSE LUIS CONCHA REVILLA	2009-01-26	
464	170	505000.0000	113	124	acumulado	Asociacion Educativa Adventista Peruana Del Sur	126	1733	109	Ruben Bolivar	2021-01-28	
463	170	0.0000	113	125	Manuel Sanchez Pizarro	Iglesia Adventista del Septimo Dia	138	1205	109	Ruben Bolivar Callata	2017-04-04	
569	170	1862.4000	113	123	Miguel Angel La Torre Llasaca	Iglesia adventista del septimo dia	126		109	Maria Isabel Guiselle Vera	2011-05-10	
442	170	0.0000	119	125			137		112		1990-02-22	
524	170	20000.0000	113	123	Jenny Luci Coaquira Copaja	Iglesia Adventista del Septimo Dia	126		109	Oscar Abel Caparachin Copaja	2018-09-03	
493	170	0.0000	114	125			139		112		2014-05-17	
525	170	0.0000	119	125			137		112		1901-10-17	
496	170	25000.0000	113	123	Mamani Cayani Juan Mesias	Iglesia Adventista del Septimo Dia	126		109	Ruben Bolivar Callata 	2018-09-21	
436	170	0.0000	119	125			137		112		1990-02-22	
454	170	0.0000	119	125			139		112		1900-03-23	
427	173	0.0000	119	125			148		112		1990-02-22	
473	170	3000.0000	113	123	Rosario Phala Phala	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	194	109	Valencia Huisa Ing. Abogado	2008-03-25	
556	170	25000.0000	113	123	Luis Condo Sencia	Iglesia Adventista del Septimo Dia	126	1822	109	Hugo J Caballero Laura	2018-04-19	
289	170	0.0000	119	125			137		112		\N	
324	170	0.0000	119	125			137		111		\N	
518	170	0.0000	119	125			137		112		1900-10-17	
10	170	0.0000	120	125			137	-	112	-	\N	-
522	170	18000.0000	113	123	Luis Condo Sencia	IGLESIA ADVENTISTA DEL SEPTIMO DIA	126	1822	109	Hugo J Caballero Laura	2018-04-19	
345	170	0.0000	119	125			137		112		\N	
460	170	26764.0000	113	122	JOSE HUMBERTO MANUEL JUDEO COVINOS TADDEY	Iglesia Adventista del Septimo Dia	126	1225-2002	111	Linares Rivero	2002-06-05	
467	170	1500.0000	113	124	Huanca Huanca Alvaro Wilfredo 	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126		109	Luis Vargas Beltran	2006-03-24	
477	170	0.0000	119	125	Luis Alberto Mayorga		139		109	Linares Rivero	2000-09-20	
538	170	335000.0000	113	123	Jorge Suarez Zaconett	Asoc. Educativa Adventista peruana del sur	126	0091	111	Jhon Jesus Soto Gamero	2016-02-29	
529	170	33000.0000	120	123	Elva Clementina Parisaca Apaza	Iglesia Adventista del Septimo Dia	143		109		2016-01-04	
445	170	0.0000	119	125			137		112		1990-02-22	
448	170	0.0000	119	125			137		112		1990-02-22	
482	173	0.0000	119	125			137		112		1900-05-14	
438	170	0.0000	119	125			137		112		1990-02-22	
506	173	5500.0000	115	123	Cristhian Edinson Ticona casas	Iglesia Adventista del Septimo Dia	139		112		2019-05-10	
527	170	0.0000	119	125	Salomon Pablo Benavente Vilca	Iglesia Adventista del Septimo Dia	147		111		2015-08-27	
480	170	0.0000	114	125	EDILBERTO ELIODORO CUTIPA QUISPE 	IGLESIA SADVENTISTA DEL SEPTIMO DIA	130		112	notario riveros	2017-07-31	
504	170	5500.0000	113	123	walter cesar miranda ccasa	Iglesia Adventista del Septimo Dia	126	1881	109	E aurora Anguis Adawi	2018-11-19	
505	170	0.0000	114	125	Alfredo Maquera Llanque	Iglesia Adventista del Septimo Dia 	130		110	E Teofilo Laqui Pinto	2015-10-20	
440	173	0.0000	119	125	cofipri		137		112		1990-02-22	
495	173	0.0000	119	125			139		111		1900-05-17	
475	173	0.0000	119	125	angela Rosa calluari Ramos		137		111		2010-01-30	
441	170	0.0000	119	125			137		112		1990-02-22	
497	170	0.0000	119	125			137		112		1900-05-17	
474	173	0.0000	119	125	chambi Pilco Nilton Cesar		137		111		2010-01-30	
503	170	0.0000	119	125			139		111		\N	
336	170	0.0000	119	125			137		112		\N	
517	170	0.0000	119	125			139		112		\N	
484	170	0.0000	114	125	Mariano vidal Calachua	Asoc. Union Incaica de la Iglesia Adventista del Septimo Dia	143		110	Uldarico Colque Llallaque 	1993-05-23	
507	170	9000.0000	113	123	Choquehuanca Mamani Zacarias MolloLlaza Eulogia Florea 	Iglesia Adventista del Septimo Dia	126	534	109	Javier Rosas Silva	2015-09-02	
594	171	0.0000	119	124			139		111		\N	
284	170	137325.0000	114	123	Gutierrez de Maquera Juana Ubaldina Maquera Ramos Mario	Iglesia Adventista del Septimo Dia	138	15160	109	E. Aurora Anguis de Adawi	2020-12-22	
534	170	160000.0000	113	124	Jose Raul Rodriguez Rodriguez	Iglesia Adventista del Septimo Dia	126	1285	109	Julio E. Escarza Benitez	2016-05-04	
185	170	170000000.0000	113	122	CARMEN ZEBALLOS CABRERA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126		109	CESAR A. FERNANDEZ DAVILA BARRERA	1990-11-08	
368	170	13000.0000	114	123	mamani ccama petronilla y marca M genaro	IASD	138		109	Aurora aguies	2024-01-12	
588	170	0.0000	119	125			139		112		1900-07-25	
581	170	0.0000	114	125			139		111		2019-06-02	
67	170	300.0000	113	124	La Asociacion  Rural de Vivienda  Fronteras los palos	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126	508	109	Luis Vargas Beltran	2004-12-10	
404	170	40000.0000	113	123	Eduardo Alberto Linares Arenas	Iglesia Adventista del Septimo Dia	126	308	109	Eduardo Alberto Linares Herrera	2016-07-18	
179	170	1700.0000	113	123	DOMINGA AHUATI SAPACAYO	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	126	2813	109	CESAR A. FERNANDEZ DAVILA BARRERA	1992-02-13	
597	173	0.0000	120	125		Iglesia Adventista Septimo Dia	134		111		2021-12-17	
196	170	500.0000	113	123	VICTORIA RAMOS RAMOS	 Iglesia Adventista del Septimo Dia	126	10460	109	JAVIER DE TABOADA	2003-02-05	
453	170	0.0000	119	125		Juana Titto de Quico	139		111		1990-02-22	
555	170	59000.0000	113	123	Teresa Moya de Rivera	Iglesia Adventista del Septimo Dia	126	1820	109	Hugo J.Caballero Laura	2018-04-18	
14	170	11613.6000	113	123	Prudencia Petronila Flores Zegarra	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	126	642-2003	109	Manuel Pantigoso Quintanilla	\N	1602V
248	170	0.0000	120	125	ASOC. URBANIZADORA SAN MARTIN DE SOCABAYA	ASOC. UNION INCAICA DE LA IGLESIA ADVENTISTA	133		111	ASOC. URBANIZADORA SAN MARTIN DE SOCABAYA 	1996-01-04	
376	170	16000.0000	113	123	Delfin Quispe Colque y Anastacio Calderon Mamani	Iglesia Adventista del Septimo Dia	126	0584	109	soto Gamero	2015-11-30	
557	170	0.0000	114	125	Victoria Alvarez Carlos 	Iglesia Adventista del Septimo Dia	130		112		2017-04-11	
382	173	0.0000	120	125	Municipio	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	134		112	constancia de posesion del Municipio	2002-02-22	
199	170	21000.0000	113	123	CORPORACION  DE LA CONFERENCIA  GENERAL DE LOS ADVENTISTAS	ASOC. UNION PERUANA DE LA IGLESIA ADVENTISTA	138	174	109	PABLO VELASAQUEZ JULCA	2000-08-29	
103	170	2000.0000	113	123	ANGELITA MARIA DEL PINO CHIRE .LOTE 22, ANTONIO RAMOS DE BRITO -LOTE 24 Y JUAN CARLOS TORREALBA CALLIRGOS - LOTE 23	 Iglesia Adventista del septimo dia	126	1428	109	 ALONSO DE RIVERO BUSTAMANTE	1997-11-10	5047v
567	170	12500.0000	113	123	Hermelinda Quispe Sucasaca	Iglesia Adventista del Septimo Dia	126	5937	109	Julio Escarza Benitez	2018-12-21	11941-11941
533	170	30000.0000	113	122	Severiano Rivera Pizarro	Asociacion Union Incaica de la Iglesia Adventista del Septimo Dia	129		109	Daisy Morales de Barrientos	1987-02-19	
106	170	0.0000	115	125	MUNICIPALIDAD P. DE MARISCAL NIETO	 iglesia adventista del septimo dia	141		112	MUNICIPALIDAD PROVINCIAL DE MARISCAL NIETO	1992-04-24	
595	170	19500.0000	113	123	Gilberto Guzman Cuayla	Iglesia Adventista del Septimo Dia	126	0852-2023	109	linares riveros	2023-08-16	
9	170	0.0000	119	125	Resolucion Municiplalidad 	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	139	-	112	-	\N	-
599	170	30000.0000	113	123	Dongo cantoral eulalia	IASD	126		109	Fidel Paredes Aliaga	2021-08-18	
587	170	0.0000	119	124			139		111		1900-07-01	
580	170	0.0000	119	124	tramitando en cofopri		144		112		1999-09-06	
108	170	25000.0000	113	123	GENERAL CONFERENCE CORPORATION OF SEVENTH DAY ADVENTIST	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	138	195-2000	109	PABLO VELAZQUEZ JULCA	2000-08-29	647V
560	170	0.0000	114	125	Huaman Huayta Fidel y Huamani Callo Pascuala	Iglesia Adventista del Septimo Dia	139		109	Manuel Pantigoso Quintanilla	2018-08-29	
158	170	4500.0000	113	124	EFRAIN RONALD COAGUILA CHORA	ASOC. UNION PERUANA DE LA IGLESIA	126	001	109	MIGUEL ANGEL LINARES RIVEROS	1999-01-04	
309	170	17000.0000	114	121	Conference Corporation Of Seventh Day Adventista 	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	138		109	PABLO VELASAQUEZ JULCA	2000-08-29	561
549	170	120000.0000	113	123	Medina Peralta Hilda Ynes	Asoc. Educ. Adventista Peruana Del Sur	126		109	Migel Angel Riveros 	2017-11-26	
528	170	16850.5000	113	123	Alyssa Tiffani Arana Luque	Iglesia Adventista del Septimo Dia	143		109	Linares Riveros Miguel Angel	2015-12-16	
596	170	0.0000	113	125	Gregorio sarmiento ponce	IASD	138	56166	109	Rosario Bohoruqez Vega	2022-03-17	
40	170	10000.0000	113	123	Felix Yensi Arenas Revilla	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	126	423	109	Alejandro Paredes Ali	2011-10-07	1582-1585
226	170	0.0000	120	125	pueblo Joven Corazon de Jesus	IGLESIA ADVENTISTA DEL SEPTIMO DIA	144	p06090391	112		2012-09-15	
586	170	0.0000	119	124			139		111		2019-06-30	
68	170	0.0000	119	125		IASD	137		109		2022-07-27	
568	170	12000.0000	113	123	Eleuterio Cari Belizario	Iglesia Adventista del Septimo dia	130		109	hugo caballero	2019-03-11	
553	170	0.0000	119	125			148		112		2018-01-30	
563	170	0.0000	114	125			139		112		2018-10-13	
535	170	0.0000	113	124	Llanos memesio	Asoc.union Incaica de la iglesia Adventista del Septimo dia	126	2672	111	Guillermo Mayca 	1900-05-06	
548	170	26000.0000	113	123	Manuel   Williams Parqui Acruta	Iglesia Adventista del Septimo Dia	130		109	Linares riveros y Hugo Caballero 	2017-07-12	
607	173	0.0000	115	124			133		111		\N	
600	170	20000.0000	113	124	marco antonio huyllani cuba	IASD	126		109	notaria E.A.Anguis	2022-08-10	
458	170	4600.0000	113	121	Juana Diez Valdez Viuda de Taddey	Iglesia Adventista del Septimo Dia	126	453	109	JORGE BERRIOS VELARDE	1994-11-07	
614	173	0.0000	119	124	Chambi Pilco Richard Barulio		139		111		2010-01-30	
499	170	300.0000	119	124	Asociacion Vivienda los Palos 	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	147	508	109	Luis Vargas  Beltran 	2004-12-10	
613	173	15000.0000	115	123	Pepe chipayo  perez y Bertha Huanaco		139		112		\N	
606	173	0.0000	120	124			139		112		\N	
109	170	6000.0000	113	124	ELIAS GUSTAVO SALAS VILLANUEVA ,FRANCISCO SALAS VILLANUEVA,WILBER SALAS VILLANUEVA JAVIER JESUS SALAS VILLANUEVA Y EMILIO SLAS VILLANUEVA	 Iglesia Adventista del septimo dia	126	1172	109	Oscar Valencia Huisa	2003-02-12	2811 VTA
610	170	5000.0000	114	123	Gregorio Sarmiento Ponce 	IASD	139	11056213	109	Angela diaz Jara	2023-09-05	
615	170	0.0000	113	124	chambilla chambilla Hermes Adan		138		111		\N	
601	173	0.0000	120	125			139		112		2021-09-11	
217	170	1690.0000	113	124	Margarita Soledad Delgado Paredes Viuda de Nina	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	2463	109	Priscila Mendez Payehuanca	2003-01-22	
350	170	15000.0000	113	124	Adrian Vidal Mina -Maria de ma Maternidad Alanoca Ramirez	Iglesia Adventista del Septimo Dia	126	1988	109	herrera Carrera 	2017-07-17	
608	173	0.0000	119	125			148		112		\N	
605	173	0.0000	113	124	Odela Cleofe Cahuna Perca		139		111		\N	
602	170	20000.0000	113	123	Virginia manuela castro Copa	IGLESIA ADVENTISTA DEL SEPTIMO DIA 	126	62080	109	ELBA ARRORA ANGUIS	2022-05-11	
92	170	1650.0000	113	124	RENE  ELVIS QUEA APAZA	Asoc. Union Peruana de la Iglesia Adventista del septimo dia	126	02	109	Oscar Valencia Huisa	2000-01-05	3
617	173	30000.0000	114	123	Jaime Villasante Maquera	IASD	133		109	Bolivar	2023-12-20	
609	173	0.0000	119	124	mujnicipalidad C.P	Iglesia Adventista del Septimo Dia	134		112	Alcalde	2023-07-14	
618	171	0.0000	119	124			139		111		\N	
616	170	25000.0000	119	123	gonzales y Lopez- Walther quispe	IASD	126	2421	109	Aurora Anguis	2023-03-30	
77	170	3000.0000	114	123	General Conference Corporation Of  Seventh Day Adventists	Asoc.Union Peruana de la Iglesia Adventista del Septimo Dia	138	216	109	Pablo Velasquez Julca	2000-08-29	
604	173	0.0000	119	124			139		111		\N	
611	170	65000.0000	113	123	Horacio Edilberto Zegarra Tejada	IASD	126	15629	111		2023-10-31	4961006
603	173	0.0000	119	124			139		111		\N	
612	173	0.0000	115	125	Edizeida Belzi Bustamante Gamarra		130		109	Bolivar	2022-08-31	
389	170	10000.0000	113	123	Chaucca Mollo,Jesusa Francisco Huamani Llamocca	Iglesia Adventista del Septimo Dia	143		109	Lima hercilla	2017-02-03	
620	173	0.0000	120	124	asoc Villa espernza	Mision Peruana del Sur	139		112		\N	
47	170	500.0000	113	123	victor constantino Chambi Quispe	Asociacion Union Peruana de la Iglesia Adventista del Septimo Dia	126	966200	109	Miguel Angel Linares Riveros	2000-01-28	
\.


--
-- Data for Name: predios_fiscal; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_fiscal (id_predio, arbifecha, arbicodigo, arbiresol, impufecha, impucodigo, impuresol, luzfecha, luzcodigo, aguafecha, aguacodigo, construfecha, construtexto, declarafecha, declaratexto) FROM stdin;
87	\N			\N			1900-09-14		1900-09-14		\N		\N	
130	\N			\N			1900-10-31		1900-10-31		\N		\N	
134	\N			\N			1900-10-31		1900-10-31		\N		\N	
16	2018-03-01		-	2018-03-01		-	2018-03-02	145978	2018-03-01	478693	\N		\N	
594	\N			\N			\N		\N		\N		\N	
89	\N			\N			1900-09-15		1900-09-15		\N		\N	
17	2018-03-01	6674766	10800	2018-12-11	30061	2593	2018-03-01	142647 IASD	2020-01-01	0459595 IASD	\N		\N	
131	1995-01-01			1995-01-01			1900-10-31		1900-10-31		\N		\N	
139	2020-09-24	183	216	1986-02-07	183	216	2017-10-31	236322 contrato	1900-10-31		\N		\N	
295	2017-02-22			2017-02-22			1999-11-29		1999-11-29		\N		\N	
133	2013-10-31			2013-05-16			1900-10-31		1900-10-31		\N		\N	
163	2021-11-30	2337	003648B	2016-09-06	2337	003648B	1900-11-07	213046 a nombre dueño	2000-11-07	conex 2466369	\N		\N	
156	2022-11-15	7-06379	7-33276	2022-12-15	7-33276		1900-11-03		1900-11-03		\N		\N	
193	\N			\N			1900-11-11	127518 MLT Mision año 2001	1900-11-11	215  IASD  año 2001	\N		\N	
164	2022-02-04	117	7780	2021-04-22	117	7780	1900-11-09		1900-11-09		\N		\N	
42	2011-05-11	14135	141351	\N			1900-08-31		1900-08-31		\N		\N	
110	2022-10-28	0000000083		1999-10-13	0000000083		2015-01-01	210014891	2013-10-13	1111697 IASD	\N		\N	
221	\N	20190416	carpeta 2664	\N			1900-11-16		1900-11-16		\N		\N	
105	2021-05-06	7205	230112990035880	2021-10-12			1999-10-12		1999-10-12		\N		\N	
40	\N			\N			2011-08-10		2011-08-10		\N		\N	
135	\N			\N			1900-10-31		1900-10-31		\N		\N	
117	1902-10-27			2004-08-27			2018-03-16	214065	1900-10-27		\N		\N	
392	2021-06-01	0000016739		\N			2021-03-02	380106 IASD	1990-02-22		\N		\N	
8	2018-05-04	1202	10636	1984-05-28	1202	0002-2018	2018-05-17	130049--416082	\N	-	\N		\N	
116	2022-05-23	3053		2017-07-19	3053		1900-10-27		2016-03-30	conex 2330747	\N		\N	
143	\N			\N			1900-11-02		1900-11-02		\N		\N	
222	\N	2019060937	carpeta 1934	\N			1900-11-16		2020-11-16	1831476 IASD	\N		\N	
119	1900-10-27	17421		1900-07-20			1900-10-27		1900-10-27		\N		\N	
30	\N			\N			1900-08-02		1900-08-02		\N		\N	
136	\N			\N			2011-09-30	319639	2011-09-20		\N		\N	
307	2020-03-08	1121	03080023-001	2021-05-06	0003371-07		2000-12-08	110047767 IASD 	2000-12-08	7614179 IASD	\N		\N	
114	1900-10-27	22447B	107101	1900-10-27	22447B		1900-10-27		1900-10-27		\N		\N	
414	2022-10-28	0000000083		2019-02-22	0000000083		1990-02-22		1990-02-22		\N		\N	
100	2022-04-20	91886	2.3010108037004E+22	2017-04-28	91886	2.3010108037004E+22	1900-10-28		1900-10-10		\N		\N	
113	2022-10-28	0000000083	20/10/2022	\N	0000000083		1999-10-13		1999-10-13		\N		\N	
88	2018-03-22	1261	1642 -03129	2018-03-22	1261		1900-09-14		1900-09-14		\N		\N	
19	2022-04-12	49566	85373	2019-01-01	49566	85373	2018-03-02	321961	\N	-	\N		\N	
106	2020-12-12	2008	1801011902500600000	2018-04-17	2008		1999-10-12		1999-10-12		\N		\N	
107	2022-10-21	982	36360	1991-10-12			1999-10-12		1999-10-12		\N		\N	
142	\N			\N			1900-11-02		1900-11-02		\N		\N	
86	\N			\N			1900-09-14		1900-09-14		\N		\N	
152	2022-11-15	7-06379	predio N° 01	2022-11-15	7-33276	predio N° 01	1900-11-03	310000150	1900-11-03	30041546	\N		\N	
155	2022-11-15	7-06379	Codi.predio N°03	2022-11-15	7-33276	Codi.predio N°03	1900-11-03		1900-11-03		\N		\N	
90	2022-11-15	7-06379	7-39898	2022-11-15	7-06379	7-06379	1999-03-25		1999-03-25		\N		\N	
168	2022-02-04	117	116	2021-04-22	117	116	1900-11-09	 medidor coliseo 444359- 	1900-11-09		\N		\N	
76	1900-09-09			1900-09-09			1900-09-09		1900-09-09		\N		\N	
132	\N			\N			1900-10-31		1900-10-31		\N		\N	
103	2021-05-06	7205	230112990035880	2021-10-10	7205		1999-10-10		1999-10-10		\N		\N	
140	\N			\N			1900-10-31		1900-10-31		\N		\N	
138	\N			\N			1900-10-31		1900-10-31		\N		\N	
36	\N			\N			1999-08-03		1999-08-03		\N		\N	
181	\N			\N			1900-11-10		1900-11-10		\N		\N	
141	\N			\N			1900-11-02		1900-11-02		\N		\N	
151	2022-11-15	7-06379	7-06379	2022-11-15	7-06379	7-06379	1900-11-03	310002291	1900-11-03		\N		\N	
145	\N			\N			1900-11-03		1900-11-03		\N		\N	
129	\N			\N			1900-10-31		1900-10-31		\N		\N	
109	2022-10-21	982		2004-03-26	95		1999-10-13		1999-10-13		\N		\N	
232	\N			\N			1900-11-17		1900-11-17		\N		\N	
4	2023-02-20	3531	9151	2023-03-28	3531	9151	2016-06-01	IASD 73158	\N		\N		\N	
595	2023-07-16			\N			\N		\N		\N		\N	
158	2018-02-14	8620	9472	2018-02-14	8620	9472	1900-11-06	79188 IASD	1900-11-06	1438299 IASD	\N		\N	
92	2019-03-29	2636		2018-08-03	2636		1999-10-05		1999-10-05	10046196 IAsd	\N		\N	
173	1900-11-09	022333	1161417	2002-09-05			1900-11-09		1900-11-09		\N		\N	
153	2022-11-15	7-06379	7-06379	2023-04-01	7-06379	7-06379	1900-11-03		1900-11-03		\N		\N	
172	2022-02-04	117	4919	2021-04-22	117	4019	2018-03-09	29419	2018-01-01	711913	\N		\N	
170	2018-11-09	2337	1350103	2018-11-09	2337		1900-11-09		1900-11-09		\N		\N	
309	2020-04-11	124467	2253	1999-12-11	124467	2253	2015-06-16	IAS-4piso 244103	1999-12-11	IASD	\N		\N	
596	2022-03-22			\N			\N		\N		\N		\N	
1	2023-05-18	3531	3433	2023-03-27	3531	3433	\N		\N		\N		\N	
162	2020-09-08	124467	40700075	2016-02-18	124467	40700075	1900-11-07		1900-11-07		\N		\N	
165	2022-02-04	117	11299	2021-04-22	117	11299	1900-07-01		2021-04-19	0767180	\N		\N	
159	2019-03-27	5702	390314	2017-09-15	5702	390314	1900-11-06		2000-01-06	1138166	\N		\N	
39	\N			\N			1999-08-04		1999-08-04		\N		\N	
174	2023-03-10	000626		2020-10-01			1900-11-10		1900-11-10	EA17013167	\N		\N	
25	\N			\N			1900-07-30		1900-07-30		\N		\N	
120	2022-03-31	49566	archivo-210514	2021-04-29	4692	archivo 125113	2000-10-27	372444	1900-10-27		\N		\N	
2	2023-05-18	3531	2510	2023-03-27	3531	2510	\N		\N		\N		\N	
149	\N			\N			1900-11-03	445157	1900-11-03		\N		\N	
137	\N			\N			1900-10-31		1900-10-31		\N		\N	
169	2022-02-04	2337	1350102	2018-05-09	2337		1900-11-09		1900-11-09		\N		\N	
161	2017-09-15	5702	480262	2017-09-15	5702		1900-11-12		1900-10-16	1046100 M.Puruana del sur	\N		\N	
184	\N			\N			1900-11-10	168089 choque puma  pascuala	1900-11-10		\N		\N	
115	2021-04-28	49566	53349	2016-08-25	49566	53349	2015-10-27	IASD 281154	2015-10-27	1917640 GAONA GALLEGOS TOMAS TIOFILO	\N		\N	
118	1900-10-27	17421		2008-03-11			1900-10-27		1900-10-27		\N		\N	
599	\N			\N			\N	535636 IASD	\N		\N		\N	
102	2022-04-20	91886	2.3010199177117E+22	2018-07-17	91886	2.3010199177117E+22	2000-10-10	110060763	2000-10-10	13575- clave t6jw17	\N		\N	
144	\N			\N			1900-11-02		1900-11-02		\N		\N	
146	\N			\N			1900-11-03		1900-11-03		\N		\N	
178	\N			\N			1900-11-10		1900-11-10		\N		\N	
175	\N			\N			1900-11-10		1900-11-10		\N		\N	
597	\N			\N			2021-12-21	531303 dueño quispe mendoza abelino	\N		\N		\N	
225	2021-11-03	9304	0290529	2018-04-02	9304	0290529 cod pedio	1900-11-16		1900-11-16		\N		\N	
288	\N			\N			1999-11-28		1999-11-28		\N		\N	
227	2016-09-08	9304	340537	2016-09-09	9304	340537	1900-11-16		1900-11-16		\N		\N	
274	\N			\N			1900-11-19		1900-11-19		\N		\N	
286	2016-09-02	272	cod.predio 4636	2016-09-02	272	cod.predio 4636	1999-11-28		1999-11-28		\N		\N	
512	\N			\N			2015-10-09		2015-10-09		\N		\N	
314	\N			\N			1999-12-12	444359	1999-12-12		\N		\N	
315	\N			\N			1999-12-12		1999-12-12		\N		\N	
287	1999-11-28			1999-11-28			1999-11-28		1999-11-28		\N		\N	
187	2020-02-26	5702	490936	2019-04-23	5702		2001-11-21		2001-11-21		\N		\N	
297	\N			\N			1999-11-29		1999-11-29		\N		\N	
503	\N			\N			1900-05-22		1900-05-22		\N		\N	
362	\N			\N			1990-02-22		1990-02-22		\N		\N	
361	\N			\N			1990-02-22		1990-02-22		\N		\N	
240	2023-06-07	2671	02230034-001	\N	2671	02230034-001	2019-01-18	110043869	2018-03-30	521529	\N		\N	
318	2019-12-31	4235	20003	1999-12-31	4235	20003	1999-12-31		1999-12-31		\N		\N	
279	2021-03-31			2021-03-31			1900-11-19	99999026	1900-11-19		\N		\N	
196	2020-12-21	5702	780033	2017-09-15	5702		1900-11-12		1900-11-12		\N		\N	
404	2022-07-15	00004150		\N			\N		\N		\N		\N	
194	2023-06-09	34114	77354	2018-06-07	843		1900-11-11		1900-11-11		\N		\N	
104	2021-05-06	7205	230112990035870	2021-10-12			1900-10-12		1900-10-12		\N		\N	
506	2019-05-06			\N			1900-07-04	medidor 110094772 dueño	1900-07-04	Usuario 513950-clave hv897l- medidor 513950	\N		\N	
180	2022-03-08	0000001710	040520-06-013-017-001	2022-03-08			\N		\N		\N		\N	
323	\N			\N			1990-02-22		1990-02-22		\N		\N	
305	2023-05-13	0000002198		\N	00002687		1999-12-08	368679	1999-12-08		\N		\N	
302	2021-05-14	124467	2255	2021-05-14	124467	2255	2016-06-16	65630 IASD	1999-12-01	MISION ADVENTISTA 0139465	\N		\N	
192	2018-04-26	9991999		1900-11-11			1900-11-11		1900-11-11		\N		\N	
191	1900-11-11			1988-12-31			1900-11-11		1900-11-11		\N		\N	
321	2024-02-02	4581	01012709001	2024-02-02	4581		2020-07-05	110033156 IASD	1990-02-22	2886	\N		\N	
306	\N			\N			1999-12-08		1999-12-08		\N		\N	
273	1900-11-01	300386		1900-11-19	300386		1900-11-19		1900-11-19		\N		\N	
111	2022-10-28	0000000083		2019-04-01	0000000083		1999-10-13		1999-10-13		\N		\N	
296	\N			\N			1999-11-29		1999-11-29		\N		\N	
325	\N			\N			1900-02-22		1900-02-22		\N		\N	
376	2023-02-28	7-06379	7-06379	2022-11-15	7-06379	7-06379	1990-02-22	310009654 SIGUAYRO FERNANDEZ WENCESLAO	1990-02-22	3183277 SIGUAYRO FERNANDEZ WENCESLAO	\N		\N	
60	\N			\N			2020-06-02	110010013 IASD	2020-09-02	6386 IASD	\N		\N	
324	\N			\N			1990-02-22		1990-02-22		\N		\N	
293	\N			\N			1999-11-29		1999-11-29		\N		\N	
292	\N			\N			1999-11-29		1999-11-29		\N		\N	
235	\N			\N			1900-11-18		1900-11-18		\N		\N	
195	2018-04-03	010101-001	3500018	1900-11-11			1900-11-11		1900-11-11		\N		\N	
179	2022-04-27	3273835	48454	1900-11-10			1900-11-10		1900-11-10		\N		\N	
200	2023-07-03	304742	8651001	2023-07-03	102106	8651001	1900-11-12		1900-11-12	0873573	\N		\N	
482	\N			\N			1900-05-14		1900-05-14		\N		\N	
332	\N			\N			1990-02-22		1990-02-22		\N		\N	
216	2019-08-07	3237	5813	\N			1900-11-16		1900-11-16		\N		\N	
308	\N			\N			1900-12-08		1900-12-08		\N		\N	
190	2018-04-03	10935 inafectado	Inafectado	2018-04-03	10935 Inafectado	Inafectado	1900-11-10		1900-11-10		\N		\N	
47	2017-09-14	5702	254018	2017-09-15	5702	254018	1900-08-31		1900-08-31		\N		\N	
268	2021-05-06	2671	9790011001	2021-05-06	2671		1900-11-19		1900-11-19		\N		\N	
289	\N			\N			1999-11-28		1999-11-28		\N		\N	
331	1990-01-01	120103020301		1990-01-01			1990-02-22		1990-02-22		\N		\N	
198	2020-04-12	5702	253870	2017-09-15	5702	253870	2001-11-07		2005-12-07		\N		\N	
320	2020-11-04	3030	4581	2018-11-02	156302athu		2018-11-13	110037324 IASD	2018-11-13	59327 IASD	\N		\N	
233	2018-02-26	2337	23374	2016-09-07	2337	23374	1900-11-18		1900-11-18		\N		\N	
182	2015-07-19	2198	401080103014001	2015-07-19	2198	401080103014001	2003-11-10	contrato 247958	1900-11-10		\N		\N	
234	2020-12-20	2008		2017-12-20	2008		1900-11-18		1900-11-18		\N		\N	
202	2023-04-21	049566	049566	2021-04-21	099881		2020-11-03	72018 IASD	2018-03-02	0659331	\N		\N	
310	\N			\N			1999-12-11		1999-12-11		\N		\N	
301	2019-02-23	02110018-001		2019-02-23	02110018-001		1999-11-30		1999-11-30		\N		\N	
53	2022-04-20	91886	2.301011305002E+22	2015-10-16	91886	2.301011305002E+22	1900-09-01		1900-09-01		\N		\N	
230	2019-01-14	2337	001829A	2020-01-14	2337	001829A	1900-11-17		1900-11-17		\N		\N	
372	2023-12-15	0004975		\N			1990-02-22	110027244 IASD	1990-02-22		\N		\N	
290	\N			\N			1999-11-29		1999-11-29		\N		\N	
364	2021-02-22	6200	02556919001	2021-02-22	6200	02556919001	1990-02-22	IASD 110060913	1990-02-22	IASD 502 -clave 5eh4h5	\N		\N	
319	2024-02-07	0000012803	02754102	2024-02-07	0000012803		1990-02-22		1990-02-22		\N		\N	
223	2020-12-30	9304	0300452	1994-02-08	9304		1900-11-16		1900-11-16		\N		\N	
224	2021-05-10	9304	350049	2011-11-21	9304	350049	2018-06-08	149409 contrato	1900-11-16		\N		\N	
291	\N			\N			1999-11-29		1999-11-29		\N		\N	
282	2022-04-20	91886	2.301019900287E+22	2018-07-11	91886	2.3001019900287E+23	1900-11-19		1900-11-19		\N		\N	
281	2022-04-20	91886	2.3010129058028E+22	2016-12-22	91886	2.3010129058028E+22	1900-11-19		1900-11-19		\N		\N	
276	\N			\N			1900-11-19		1900-11-19		\N		\N	
275	\N			\N			1900-11-19		1900-11-19		\N		\N	
269	2021-05-06	2671	09790009-001	2021-05-06	09790009-001		1900-11-19		1900-11-19		\N		\N	
272	2023-08-02	49566	85380	2023-08-02	49566	85380	1900-11-19		1900-11-19		\N		\N	
326	\N			\N			1990-02-22		1990-02-22		\N		\N	
177	2022-04-27	3273835	45126	2018-04-09			1900-11-10		1900-11-10		\N		\N	
304	\N	100000182		\N			1900-12-07		1900-12-07		\N		\N	
280	2022-04-20	91886	2.30101990030669E+22	2019-10-16	91886	2.30101990030669E+22	1900-11-19	110-085481	1900-11-19	520773	\N		\N	
189	2005-05-05	4235	490140	2008-05-05	4235	490140	2018-03-06	322003	1900-11-11		\N		\N	
188	2018-02-27	5702	470318	2017-09-15	5702	470318	1900-11-11		1900-11-11		\N		\N	
186	2020-03-09	5702	1140096	2017-09-15		1.2.4.012 018	2016-11-11	338214	2018-03-11	2068315	\N		\N	
267	2022-04-08			\N			1900-11-19		1900-11-19		\N		\N	
197	2017-09-14	5702	360847	2017-09-15	5702	360847	2001-08-08		2001-08-16		\N		\N	
61	\N			\N			1900-09-02		1900-09-02		\N		\N	
311	\N			\N			1999-12-11		1999-12-11		\N		\N	
294	\N			\N			1999-11-29		1999-11-29		\N		\N	
317	1999-12-25	117	4919	1999-12-25	117	4919	1999-12-25		1999-12-25		\N		\N	
464	2023-03-27	180144	80260008	2018-03-28	180144	80260008	1900-04-05		1900-04-05		\N		\N	
391	\N			\N			1990-02-22		1990-02-22		\N		\N	
371	\N			\N			1990-02-22		1990-02-22		\N		\N	
455	\N			\N			1900-03-29		1900-03-29		\N		\N	
347	\N			\N			1990-02-22		1990-02-22		\N		\N	
338	\N			\N			1990-02-22		1990-02-22		\N		\N	
383	\N			\N			1990-02-22		1990-02-22		\N		\N	
417	\N			\N			1990-02-22		1990-02-22		\N		\N	
402	\N			\N			1990-02-22		1990-02-22		\N		\N	
343	2015-04-16	430		2015-04-16	430		1990-02-22		1990-02-22		\N		\N	
344	\N			\N			1990-02-22		1990-02-22		\N		\N	
346	\N			\N			1990-02-22		1990-02-22		\N		\N	
487	\N			\N			1900-05-15		1900-05-15		\N		\N	
407	\N			\N			1990-02-22		1990-02-22		\N		\N	
411	\N			\N			1990-02-22		1990-02-22		\N		\N	
335	\N			\N			1990-02-22		1990-02-22		\N		\N	
336	\N			\N			1990-02-22		2015-02-22		\N		\N	
406	\N			\N			1990-02-22		1990-02-22		\N		\N	
472	\N			\N			1990-05-01		1900-05-01		\N		\N	
22	\N		-	\N		-	\N	-	\N	-	\N		\N	
545	1900-03-28			1900-03-28			1900-03-28		1900-03-28		\N		\N	
484	1900-05-15			1900-05-15			1900-05-15		1900-05-15		\N		\N	
15	\N	-	-	\N	-	-	\N	-	\N	-	\N		\N	
353	\N			\N			1990-02-22	383337 ZAPANA MAMANI RODOLFO BASILIO	1990-02-22		\N		\N	
454	\N			\N			1900-03-23		1900-03-23		\N		\N	
409	2023-03-02	3806		1991-02-22	3806		1990-02-22		\N	Titular IASD	\N		\N	
428	\N			\N			1990-02-22		1990-02-22		\N		\N	
398	2023-06-28	304742	304742	2017-06-01	304742	304742	1990-02-22		2017-12-29	2799906	\N		\N	
9	\N	-	-	\N	-	-	\N	-	\N	-	\N		\N	
556	\N			\N			2018-04-20		2018-04-20		\N		\N	
474	\N			\N			1900-05-11		1900-05-11		\N		\N	
355	2021-05-03	7205	2301129904075999999999	2021-02-22			1990-02-22		1990-02-22	372288	\N		\N	
399	\N			\N			1990-02-22		1990-02-22	3-503 municipalidad ditrital dean valdivia	\N		\N	
477	\N			\N			2016-07-04	2100221037 IASD	1900-05-11		\N		\N	
475	\N			\N			1900-05-11		1900-05-11		\N		\N	
412	\N			\N			1990-02-22		1990-02-22		\N		\N	
436	\N			\N			1990-02-22		1990-02-22		\N		\N	
349	\N			\N			1990-02-22		1990-02-22		\N		\N	
413	2019-12-20	982		1990-02-22			1990-02-22		1990-02-22		\N		\N	
333	\N			\N			1990-02-22	407980 IASD	1990-02-22		\N		\N	
567	\N			\N			\N		\N		\N		\N	
553	\N			\N			1900-03-30		1900-03-30		\N		\N	
382	\N			\N			1990-02-22		1990-02-22		\N		\N	
352	2020-12-30	1121	04010022-001	2021-05-06		04-01-0022-001	1990-02-22		1990-02-22	Jimenes quispe feli	\N		\N	
524	2018-08-21	2671	09530022-001	2018-08-21			1900-10-21		1900-10-21		\N		\N	
495	2022-06-17	00000007205	23011299071201	\N			1900-05-17		2003-06-05	528970 calderon chipana pedro	\N		\N	
342	\N			\N			1990-02-22		1990-02-22		\N		\N	
555	2023-06-02			\N			2018-04-14	486995	2018-04-14		\N		\N	
504	\N			\N			1900-05-22		1900-05-22		\N		\N	
408	2022-10-21	000000083		\N			1990-02-22		1990-02-22		\N		\N	
400	\N			\N			1990-02-22		1990-02-22		\N		\N	
339	\N			\N			1990-02-22		1990-02-22		\N		\N	
467	2022-04-19	1121	04520007-001	2021-05-06	0007550-07	04520007-001	1900-04-22		2016-03-02	60336  IASD	\N		\N	
67	\N			\N			1900-09-03		1900-09-03		\N		\N	
354	\N			\N			1990-02-22		1990-02-22		\N		\N	
463	\N	0000016739		\N			1900-04-04		1900-04-04		\N		\N	
377	\N			\N			1990-02-22		1990-02-22		\N		\N	
393	2018-04-19	0000016739		2018-04-19			1990-02-22	477754 IASD	1990-02-22		\N		\N	
563	\N			\N			2018-10-13		2018-10-13		\N		\N	
473	2022-10-21	982		2018-01-02			1900-05-11		1900-05-11		\N		\N	
410	2021-06-09	982	1.8010122032015E+22	2018-05-03	1634		1990-02-22	210012991 iasd	1990-02-22	10088209 Mayta	\N		\N	
548	2021-04-19	49566	85470	2021-04-19	49566	85470	2017-07-14		2017-07-14		\N		\N	
359	2021-01-28	7205	23011299040846999999999	2021-12-03			2015-02-22		2018-03-13	111111	\N		\N	
389	\N			\N			1990-02-22		1990-02-22		\N		\N	
14	\N		-	\N	-	-	\N	-	\N	-	\N		\N	
499	\N			\N			1900-05-17		1900-05-17		\N		\N	
375	\N			\N			1990-02-22		1990-02-22		\N		\N	
356	2021-06-17	7205	2301129904348690	2015-05-30		pagado	2015-05-30		2015-05-30		\N		\N	
68	\N	0000007205	23011299068088	\N			1900-09-03		1900-09-03		\N		\N	
368	2023-12-15	0000076 dueño		\N	110027244		1990-02-22		1990-02-22		\N		\N	
334	\N			\N			1990-02-22		1990-02-22		\N		\N	
265	2020-02-12	1121	9200004001	2021-05-06		9200004001	2018-07-03	110054500	2018-07-03	51642 IASD	\N		\N	
479	\N			\N			1900-05-14		1900-05-14		\N		\N	
538	2018-03-17	7-51842	cod. contr7-51842	2018-03-17	7-51842	cod.contri7-51842	1990-05-25		1990-05-25		\N		\N	
381	\N			\N			1990-02-22		1990-02-22		\N		\N	
448	\N			\N			1990-02-22		1990-02-22		\N		\N	
379	\N			\N			2015-01-01	112055299	1990-02-22		\N		\N	
337	\N	si		\N			1990-02-22		\N	2621048 	\N		\N	
533	2022-04-20			1900-05-01			2018-03-01	110041998 Iglesia	1900-05-01	20857	\N		\N	
427	\N			\N			1990-02-22		1990-02-22		\N		\N	
535	2021-04-22	11600001	117	2021-04-22	11600001	117	2016-05-06		2016-05-06		\N		\N	
419	\N			\N			1990-02-22		1990-02-22		\N		\N	
421	\N			\N			1990-02-22		1990-02-22		\N		\N	
505	\N			\N			1900-06-23		1900-06-23		\N		\N	
341	\N			\N			1990-02-22		1990-02-22		\N		\N	
480	\N			\N			2017-08-07	contrato 453360	1900-05-14		\N		\N	
328	\N			\N			1990-02-22		1990-02-22		\N		\N	
345	\N			\N			1990-02-22		1990-02-22		\N		\N	
451	\N			\N			1990-02-22	450090 FERNANDEZ CHAMPI ABEL	1990-02-22		\N		\N	
378	\N			\N			1990-02-22		1990-02-22		\N		\N	
52	2023-03-27	3531	23163	2023-03-27	3531	23163	1900-09-01		1900-09-01		\N		\N	
403	\N			\N			1990-02-22		1990-02-22		\N		\N	
405	2015-07-02	12		2015-07-02	12		2015-07-22	IASD-147497	2015-07-22	IASD-7397331	\N		\N	
441	\N			\N			\N		\N		\N		\N	
13	\N	-	-	\N	-	-	\N	-	\N	-	\N		\N	
422	\N			\N			1990-02-22		1990-02-22		\N		\N	
496	2022-08-15	3273835	49295	2018-09-21			1900-05-17		1900-05-17		\N		\N	
350	2021-05-02	1121	07-56-0002-001	2021-05-06		07-56-0002-001	1990-02-22		1990-02-22		\N		\N	
363	2022-03-24	10201	02560820	2022-03-24	10201		2017-02-20	IASD	2017-02-20	520514	\N		\N	
357	\N			\N			1990-02-22		1990-02-22		\N		\N	
54	2023-07-27	91886	2.3010199165334E+22	2015-10-16	91886	2.3010199165334E+22	1900-09-01		1900-09-01		\N		\N	
370	\N			\N			1990-02-22		1990-02-22		\N		\N	
394	\N			\N			1990-02-22		1990-02-22		\N		\N	
340	\N			\N			1990-02-22		1990-02-22		\N		\N	
497	\N			\N			1900-05-17		1900-05-17		\N		\N	
358	\N			\N			1990-02-22		1990-02-22		\N		\N	
425	\N			\N			1990-02-22		1990-02-22		\N		\N	
561	\N			\N			1900-07-10		2018-07-10		\N		\N	
507	2015-07-17			1900-07-17			2015-09-05		2015-09-05		\N		\N	
446	\N			\N			1990-02-22		1990-02-22		\N		\N	
429	\N			\N			1990-02-22		1990-02-22		\N		\N	
551	\N			\N			1900-02-11		1900-02-11		\N		\N	
468	1900-04-30			1900-04-30			1900-04-30		1900-04-30		\N		\N	
447	\N			\N			1990-02-22		1990-02-22		\N		\N	
48	\N			\N			1900-09-01		1900-09-01		\N		\N	
37	2021-05-06	2671	90011331-001	2021-05-06	2671	2671	1999-08-03		1999-08-03		\N		\N	
46	\N			\N			1900-08-31		1900-08-31		\N		\N	
23	2022-07-18	1728	1206	2021-05-14	1728	1206	2016-07-28	210011078 IASD	\N	 10100568 IASD	\N		\N	
51	\N			\N			1900-09-01		1900-09-01		\N		\N	
85	\N			\N			1900-09-10		1900-09-10		\N		\N	
259	2022-04-08	1121	07010041-001	2021-05-06		07010041-001	1900-11-19		1900-11-19		\N		\N	
237	2021-05-06	2671	06360015001	2021-05-06	2671		1900-11-18		1900-11-18		\N		\N	
29	2021-04-29	49566	78317	2021-04-29	49566	78317	2016-03-09	443036	2016-03-18	CO286246	\N		\N	
217	2022-04-20	91886	2.3010199189724E+22	2015-10-16	76289	2.3010199189724E+22	2015-01-01	110067183 IASD	1900-11-16		\N		\N	
493	1900-05-17			1900-05-17			1900-05-17		1900-05-17		\N		\N	
581	1900-06-02			1900-06-02			2019-06-02		2019-06-02		2019-06-02		2019-06-02	
3	2023-06-07	3531	15737	2023-03-27	3531	15737	\N		\N		\N		\N	
71	2021-06-30	7205	230112990042250	2021-09-04		7205	1900-09-04		1900-09-04		\N		\N	
108	2022-10-21	982	18010120098010100000	2017-09-26	982	18010120098010100000	2018-01-15	210001230	1999-10-12	100117895 Asoc.Educ Adv P.S	\N		\N	
44	\N			\N			1900-08-31		1900-08-31		\N		\N	
252	2021-02-01	049566	089525	2017-02-28	049566		1900-11-19	410690 URBANO TINCOPA MAXIMO	1900-11-19	2763564 QQUENTA TTURO MAURICIA	\N		\N	
238	2022-05-12	2671	2150019001	2021-05-06	2671		1999-11-18	110065251 IASD	1999-11-18	21268 aguilar flores manuela	\N		\N	
588	1900-11-19			1900-11-19			1900-11-19		1900-11-19		1900-11-19		1900-11-19	
64	2019-03-29	208		2019-03-29	208		2020-10-03	110104698	2020-10-03	76861	\N		\N	
66	2022-09-02	4493	02551307	1995-08-25	5698	5698	1900-09-03		1900-09-03	297155 IASD	\N		\N	
35	1999-08-03			1999-08-03			1999-08-03		1999-08-03		\N		\N	
568	2019-03-13			2019-03-13			2019-03-13		2019-03-13		2019-03-13		2019-03-13	
183	2019-06-24			\N			2018-11-10	IASD 	2018-11-10	IASD	\N		\N	
478	1900-05-13	49566	85381	1900-05-13	85381	85381	2018-03-22	353312	1900-05-13		\N		\N	
62	2024-02-20	3076	2113504	2024-02-20	3076		2020-07-02	110027712-IASD 	1900-09-02	2822	\N		\N	
587	1900-07-01			1900-07-01			2019-07-01		2019-07-01		2019-07-01		2019-07-01	
263	2020-02-20	1121	9060015001	2021-05-06		9060015001	1900-11-19		1900-11-19		\N		\N	
28	2013-04-30	1625	162501	2015-02-18	1625	162501	1900-08-02	214065  IASD	1900-08-02		\N		\N	
77	\N			\N			1900-09-09		1900-09-09		\N		\N	
266	2020-11-07	1121	01480005-001	2021-05-06			2014-11-19	110077844	1900-11-19	59794	\N		\N	
43	2023-03-10	2620		2005-10-25	2620		2023-04-27	42987 -IASD	1900-08-31		\N		\N	
258	2022-08-24	1121	07160014-001	2021-05-06		07160014-001	1900-11-19		1900-11-19		\N		\N	
569	2022-10-21	0000083		1900-03-16			1900-03-16		1900-03-16		1900-03-16		1900-03-16	
27	\N			\N			\N		\N	532172	\N		\N	
74	2023-12-28	7205	23011299005206	2015-08-01			1900-09-04		1900-09-04		\N		\N	
69	2021-06-17	7205	23011299000699	2015-09-03	      		2000-09-03	110063449	1900-09-03		\N		\N	
560	2018-04-24	8668		2018-04-24	8668		2018-05-10		2018-05-10		\N		\N	
24	2018-02-14	8620	27931	2018-02-14	8620		2007-01-01	363050 IASD	2007-01-01	2180800	\N		\N	
7	\N		-	\N		-	\N		\N		\N		\N	
580	2021-04-22	009304	0320172	1900-11-19			1900-11-19		1900-11-19		1900-11-19		1900-11-19	
55	1900-09-01			1900-09-01			1900-09-01		1900-09-01		\N		\N	
41	2022-11-15	7-06379	predio N° 02	2022-11-15	7-33276	predio N° 02	1900-08-10		1900-08-10		\N		\N	
586	1900-06-30			2019-06-30			2019-06-30	247958	2019-06-30		2019-06-30		2019-06-30	
262	2018-09-26	2671	09200007-001	2018-09-26			1900-11-19	605365860 ASOC.U.P. IASD.	1900-11-19	426060 condori julio eddy V	\N		\N	
256	1900-11-19	1121	02270007-001	2021-05-06			1900-11-19		2016-03-02	165016 IASD	\N		\N	
5	2023-02-20	3531	9876	2023-03-27	3531	9876	\N		\N	0350993	\N		\N	
33	2022-11-15	7-06379	7-06379	2022-11-15	7-06379	7-06379	1999-08-03		1999-08-03		\N		\N	
298	\N			1999-01-01			1999-11-29		1999-11-29		\N		\N	
18	2018-03-01	6674736	10760	2018-12-11	30061	2593	\N		\N	0481399 a nombre de dueño	\N		\N	
75	2023-12-28	7205	23011299052073	2015-08-01			1900-09-04		1900-09-04		\N		\N	
10	\N		-	\N		-	\N	327327	\N	-	\N		\N	
72	2023-12-28	7205	230112990522071	2015-08-01			1900-09-04		1900-09-04		\N		\N	
34	1999-08-03	4493	02443009 estado cta 0000912	2014-03-19	4493	02443009	1999-08-03		1999-08-03		\N		\N	
78	\N			\N			1900-09-09		1900-09-09		\N		\N	
82	\N			\N			1900-09-09		1900-09-09		\N		\N	
79	\N			\N			1900-09-09		1900-09-09		\N		\N	
442	\N			\N			1990-02-22		1990-02-22		\N		\N	
21	2018-03-01	6674755	10785	2018-03-01	6674755	2593	2018-03-06	148837	2018-03-02	440035	\N	1997 -licencia 066-95	\N	
438	\N			\N			1990-02-22		1990-02-22		\N		\N	
150	2022-11-15	7-06379	inafecto	2022-11-15	7-07187	inafecto	1900-11-03		1900-11-03		\N		2019-12-13	declaratoria 
445	\N			\N			1990-02-22		1990-02-22		\N		\N	
80	\N			\N			1900-09-09		1900-09-09		\N		\N	
65	2024-02-20	3076	02552117	2024-02-20	3076		1900-09-03		2022-09-03	1415 - clave t529t	\N		\N	
12	2022-07-21	-	-	\N	-	-	\N	188490 a nombre dueño anterior	\N	-	\N		\N	
32	2022-11-15	7-06379	codig.predio N°04	2022-11-15	7-33276	codig.predio N°04	2022-12-07	310021515	2022-12-07	3227349	\N		\N	
215	2021-05-14	124467	90450059	2021-05-14	124467	90450059	1900-11-12	143429	1900-11-12	1348410	\N		2015-12-04	declaratoria de fabrica 285,590.00
261	2021-05-14	1121	07030001-001	2021-05-06		07030001-001	1900-11-19		1900-11-19		\N		\N	
241	1999-11-18			1998-03-09			2010-11-18	110043869 IASD	1999-11-18		\N		\N	
199	2016-06-30	304742	79001	1900-02-07			1900-11-12		1900-11-12		\N		2015-09-18	declaratoria de fabrica 459,848.70
58	\N			\N			1900-09-02		1900-09-02		\N		\N	
81	\N			\N			1900-09-09		1900-09-09		\N		\N	
278	\N			\N			1900-11-19		1900-11-19		\N		\N	
45	2017-09-13	5702	90610	2005-09-22	55702	90610	2018-01-20	95890	1900-08-31		\N		\N	
423	\N			\N			1990-02-22		1990-02-22		\N		\N	
70	2021-04-21	7205	23011299007429	2021-04-04	7205	6543	1900-09-04	110056685	2018-03-05	51266	\N		\N	
557	\N			\N			2018-04-29		2018-04-29		\N		\N	
440	\N			\N			1990-02-22		1990-02-22		\N		\N	
50	\N			\N			1900-09-01		1900-09-01		\N		\N	
57	\N			\N			1900-09-02		1900-09-02		\N		\N	
59	\N			\N			1900-09-02		1900-09-02		\N		\N	
239	2021-05-06	2671	04180012001	2021-05-06	2671		2001-11-17		2018-05-14	IASD	\N		\N	
520	\N			\N			1900-10-19		1900-10-19		\N		\N	
517	\N			\N			1900-10-17		1900-10-17		\N		\N	
516	\N			\N			1900-10-17		1900-10-17		\N		\N	
519	\N			\N			1900-10-17		1900-10-17		\N		\N	
513	\N			\N			1900-10-17		1900-10-17		\N		\N	
514	\N			\N			1900-10-17		1900-10-17		\N		\N	
515	\N			\N			1900-10-17		1900-10-17		\N		\N	
284	2022-07-26	7205	230112990014560	2021-06-28	7205		1999-11-28		1999-11-28		\N		\N	
452	2021-04-29	49566	85472	2021-04-29	49566	85472	1990-02-22		1990-02-22	0590540 LINARES TERRONES DELIA ESTHER	\N		\N	
73	2020-02-25	7205	230112990528529	1900-09-04	52852999999999		1900-09-04	110031696	1900-09-04	36489 LLANOS PAMPA DAVID IGLESIA EVANGELICA	\N		\N	
285	2021-05-07	7205	23011299006137	2019-11-26		40534	1999-11-28		1999-11-28	54499 IASD	\N		\N	
26	2024-03-06	91886	2.3010103022015E+22	2024-03-06	91886	2.3010103022015E+22	\N		2015-11-14	5080	\N		\N	
601	\N			\N			\N		\N		\N		\N	
606	\N			\N			\N		\N		\N		\N	
518	\N			\N			1900-10-17		1900-10-17		\N		\N	
522	\N			\N			1900-10-19		1900-10-19		\N		\N	
260	1900-11-19	1121	02160002-001	2021-05-06			1900-11-19		1900-11-19		\N		\N	
257	1900-11-19	1121	03010025-001	2021-05-06		03010025-001	1900-11-19		1900-11-19		\N		\N	
525	\N			\N			1900-10-21		1900-10-21		\N		\N	
250	2021-04-19	2337	23373	2016-09-07	2337	23373	1900-11-19		1900-11-19		\N		\N	
602	\N	012803		2022-11-09			\N		\N		\N		\N	
236	2022-11-18	0000000777	pagado	2021-06-24	0000000777	Inafecto	1900-11-18		1900-11-18		\N		\N	
249	2022-03-30	11666	12695	2022-03-30	11666	si	2000-11-19	49195	2000-11-19	1526365	2003-06-11	casa de con 2do piso	\N	
528	\N			\N			1900-12-18		1900-12-18		\N		\N	
460	2022-04-20	91886	2.3010199165751E+22	2018-07-10	91886	2.3010199165751E+22	1990-04-03		1990-04-03		\N		\N	
600	2022-08-26			\N			\N		\N		\N		\N	
458	2023-04-20	91886	2.3010114005002E+22	2023-04-20	91886	2.3010114005002E+22	1990-04-03		1990-04-03	238308 ESTA NOMBRE DE OTRA PERSONA	\N		\N	
620	\N	0000002273		\N	000002273		\N		\N		\N		\N	
617	\N			\N			\N		\N		\N		\N	
614	\N			\N			\N		\N		\N		\N	
527	\N			\N			1900-11-14		1900-11-14		\N		\N	
303	2020-11-30	1811	2551304	2014-08-03	1811		2014-12-03		2014-12-03		\N		\N	
171	2021-04-22	117	7331	2021-04-22	117	7331	1900-11-09		1900-11-09		\N		2021-02-23	costo construccion 135,638.79 soles
618	\N			\N			\N		\N		\N		\N	
351	2022-04-21	1121	08680009-001	2021-05-06		08680009-001	2021-03-08	110041511  IASD codig. 12345678	1990-02-22	518854	\N		\N	
248	2021-03-26	2337	23371	2019-03-26	2337	23371	1900-11-19	111631 IASD	\N	1226404 IASD	\N		\N	
251	2021-01-28	49566	85374	2003-11-25	49566	85374	2021-03-02	21759 IASD	1900-11-19	0569036 a nombre de dueño	\N		\N	
219	2022-03-24	91886	2.3010199168450010101001	2022-03-24	91886	2.301019916845001010001	1900-11-16	110003204 	1900-11-16	17874 - nombre ara borda manuel 	\N		\N	
529	2023-11-13	3237	7663	\N			1900-01-04		1900-01-04		\N		\N	
254	2023-03-01	49566	85377	2021-04-23	49566	85377	1900-11-19	225790-IASD	2010-01-28		\N		2019-12-09	170,870.40 costo del predio
218	1900-11-16	91886	99000000169202900000	1900-11-16	91886	99000000169202900000	2015-01-16	110099692	1900-11-16		\N		\N	
401	2021-11-17			\N			1990-02-22	143111 NORIEGA ZEA YESSICA NOELIA	1990-02-22	7072920 NORIEGA ZEA YESSICA NOELIA	\N		\N	
101	2022-04-20	91886	2.3010103068009E+22	2015-10-16	91886	2083-2014	2001-10-29	1193407 IASD	1999-10-10	21586 iglesia evangelica	\N		\N	
616	\N			\N			\N		\N		\N		\N	
277	\N			\N			1900-11-19		1900-11-19		\N		\N	
609	\N			\N			\N		\N		\N		\N	
185	2022-04-27	3273835	45411	1900-11-10			1900-11-10		\N	7231145 mamani chise timoteo	\N		\N	
112	2023-03-02	000000003806	Dist San Francisco	\N	144		1999-10-13	210007030BENITES CASTAÑEDA  LUIS	1999-10-13	10044456 BENITES CASTAÑEDA LUIS	\N		\N	
604	\N			\N			\N		\N		\N		\N	
255	2022-03-31	49566	archivo 125113	2021-04-29	4692	archivo 125113	2022-01-11	165086 -iasd	2022-11-02	0563128 Asoc.union p.IASD	\N		\N	
534	2022-03-30	11666	38172	2019-04-10	11666		2016-05-05	202649-45083 IASD	2018-02-09	1504050	\N		\N	
611	\N			\N			\N		\N		\N		\N	
608	\N			\N			\N		\N		\N		\N	
160	2021-05-02	2337	23372	2016-09-07	23372	23372	1900-11-06		2000-01-06	1201717-ver ruc	\N		\N	
283	2022-04-20	91886	2.3010118017008E+22	2015-10-16	91886	2.3010118017008E+22	2000-11-19	110058109 Davis Human	2000-11-19	56819-	\N		\N	
607	\N			\N			\N		\N		\N		\N	
613	\N			\N			\N		\N		\N		\N	
300	2021-04-27	3273835	47217	1999-11-29			1999-11-29		1999-11-29	7231375 mamani arias reyna	\N		\N	
270	2023-08-24	91886	2.30101990081709E+22	2019-03-27	91886	2.30101990081709E+22	1900-11-19	110069314 choquecota ROQUE MANUEL	1900-11-19		\N		\N	
549	2022-07-15		46996	2018-11-26			2022-12-16	548913	2022-12-16		\N		\N	
226	2021-04-22	9304	0320172 cod. predio	2004-07-27	9304	0320172 cod predi	1900-11-16		1900-11-16		\N		\N	
605	2023-07-03	00091886	3010199022536999999999	2023-08-03	23010199022536999999999		\N		\N		\N		\N	
453	\N			\N			1990-02-22	no tiene	1990-02-22	cambiao titularidad	\N		\N	
612	\N			\N			\N		\N		\N		\N	
603	\N			\N			\N		\N		\N		\N	
610	2023-09-15			\N			\N		\N		\N		\N	
615	\N			\N			\N		\N		\N		\N	
\.


--
-- Data for Name: predios_medidas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_medidas (id_predio, ubizona, arancel, area_total, area_const, frent_medi, frent_colin, right_medi, right_colin, left_medi, left_colin, back_medi, back_colin) FROM stdin;
89			64.80									
85			60									
22					0	-	0	-	0	-	0	-
23			128		8.	2	16	lote A-11	16	7 	8	A-13
37	Costa		200		10	Jades	20	con propiedad de vendedor	20	con propiedad de vendedor	10	con propiedad Francisco Ticona
16	Sierra	958324364	161.50		9.50	PJE - F	17.00	Lote 4	17.00	Lote 6	9.50	Lote 12
51		994360073										
87			160		8	Los Perales	20	lote 05 y 20	20	lote 03	8	familia Soto
46			132		8	zarumilla	16.50	8	16.50	10	8	15-16
17	pamelatreiies8@gmail.com	959680589	-179.92	-	10.40	-	17.10	-	17.10	-	10.30	-
48		2,256	188.02		9	7	20.90	8	20.90	6	9	15
15	-	-	-	-	0	-	0	-	0	-	0	-
74			160		8	calle	20	04	20	06	8	34
29		958310615	2000	0	56.07	P.J.Mariscal Castilla	28.30	propiedad Constructora LLerena	46.24	Hilario Nicolas 	52.87	colindante Nicolas-Francisca 
67	Costa		250		12.50	Geranios	20	lote 13	20	av. Miguel Grau	12.50	lote 15
59			8695.12		Norte 34	Eriazo con estado	el oeste 35-59-	Eriazo del Estado	Sur 74	Eriazo co el estado	Oeste 50-86-66	Eriazo paralelo al canal de riego
28	Sierra	959549866	975		22.50	18	10-2.5-30	(S.E.E.) 6-5	40	Q	25-10-2.5-10	6-13
81		971941966	11000		110	09	100	terreno municipalidad	100	av.01	110	terreno municipalidad
68			204									
41	Costa		160	146.59	8	calle 18	20	lote 27	20	lote 29	8	lote 21
76	Sierra	928192904	400.50									
5	Sierra	994466048	127.33	-	8.30	42	15.50	6	16.20	4	7.80	2 mz m  villa el mirador
75			160		8	calle	20	05	20	7	8	33
42		12267.30	222.30		19	13	11.70	lote 5	11.79	lote1	19	lote3
79		952930233	246.3		3.66.3	abril	4.65	lote 2,4	18.47	lote 2	17,95	av tacna
30			46.60 % 									
55		968274990	450									
3	Sierra	958715723	175.46	-	16.69	Jr. Alfonso Ugarte	10.59	Lote 11A	10.70	Lote 12	16.31	Lote 10
19	-	960328720	236.47	-	10	av.02	23.70	09	24	lote 07	9.95	04
61	Costa		202.87		10.02	Oscar E. Carbajal Soto	20.27	lote 21	20.17	lote 19	10.05	lote 6
10	-	943627054#99999	300	-	10	av.angel escalante	30	lote 16,15,14	18	lote 18	10	lote 10
183		959393619	669.76	-	25.90	carretera panamericana	24.36	calle sotillo	25,25	lote 9	28.47	lote 3,2
18	Sierra	921494231	200	100	9.50	Pje sin nombre	17.00	Lote 15	17.00	Lote 13	9.50	Bosque N° 5
69	Costa		294		14	11	21	9	21	12	14	22,23
90	Costa	943222245	200.91		10.03	avenida 4	20.08	avenida 1	20.06	lote 100	9.00	lote 8
33	Costa	962619632	160		8.	pasaje 8	20	lote 11	20	lote 9	8	lote 5
71	Costa	999869101	119		6	av Cultura	20	43	20	45	5.90	9
47		979728777 celul	110.07		7.41	8	15	12	15	8g	7.26	8
72	Costa		160		8	107	20	33	20	35	8	05
25	Costa		7000- % 38.24									
146		926404801	204.69		11.25	CALLE N° 8	18.5	LOTES 1 y 18	17.89	LOTE03	11.27	LOTE 15
1		950320604	309.7		10	-AV ARGENTINA	30	-31	30	-29	10	-4
162			361.77		26.10	CALLE JERUSALEN	16	CALLE CARLOS LLOSA	10.15	JOSE REY		
8	rudy1000@outlook.com.pe	953268061	477.53	-	9.68	Calle marscal Casilla	0.990	lote 31,32,33	38.30	LOTE 4	14.86	calle mariscal castilla lote 2
43		100,009.87	358.13		13.46	Av.sepulveda	000	lote 17	35.86	lote 15-12-b,12-a,11	10.85	lote 17
2	Sierra		291.78		10.19	Av. Argentina	28.12	1	27.81	Lote 30	10.72	3
73	jeanet_b118@hotmail.com		279.87		13.98	pasaje 2	20	calle 7	20	lote 10	14.01	lotes 2,1
52		956060619	400									
92	costa	953926372	160 -160-160		8	Pasaje san jose	20	lote n°8	20	san martin	8	lote 6
77	Sierra		576									
181		959404068	535.44		19.40	CALLE PERIMETRAL	27.60	LOTE 4	27.60	LOTE 2	19.40	LOTE 7 y 8
66	Costa		1883.40		42.80		80		49		29.20	
13	Sierra		235.42	-	11.67	calle 7	13.74 ,5.97	-lote 08	08.82 , 11.45	lote 10	12.36	-lote 06
78	Sierra	9755186652	2525									
21		956091420	395.20	229.73	20.15	Calle 5	19.64	Lote 1	19.64	Lote 4	20.10	Lote 16,17
132	Sierra		210.76		18.17	Pasaje 5	11.59	Terreno Eriazo del Estado	11.83	Lote 9	17.84	Pasaje 5 Lote 7
82			427.19									
88		987251420	107.17		6	av 8 de diciembre	18	sub lote 8	18	lote 9	6	lote 08
32	Costa	953928149	160		8	88	20	3	20	5	8	25
153	COSTA	930257545	117.64		7.85	CALLE 51	15.11	Lote 3 de la Manzana N	15.30	Lote 3	7.63	LOTE 01 
14	Costa	974757110	258.08	-	8.05	avenida 15 de agosto	31.99	lote 1	32.29	lote 2	2.37 y 5.60	lote 8y 9
64	Costa	942154751	128		8	2	16	lote 8	16	lote 6	8	terreno eriazo del estado
53	j_vilca_apaza@hotmail.com	974461497 99030	218.70									
36	Costa		300									
45			453.81		14.97	calle 6 ( Junin )	30.10	lote 9	30.43	lote 7	15.06	lote6
9		993103154	690.02	-	0	-	0	-	0	-	0	-
44			180									
50			217.07									
80	Sierra	988384488	325									
7	Sierra	959485285	200		0	-	0	-	0	-	0	-
60		952800690	197.43		25.15	tupac Amaru	16.38	lote 12.11	2.60	jiron la union	20.70	lote 14 B
4	Sierra	978197025	180	-	10.00	3 mz q	18.00	1	18.00	11	10.00	3
39	Costa		1659		42		40.30		40		40.50	
86			300		10	Av Angel Escalantes	30	14-15-16	30	18	10	10
26	Costa	952907517-	248.77		9.97	26 de Mayo	25.26	lote 12	25.29	norte 14	9.93	lote 08
70		945381849 	139.95		6.98	5	20.06	24	20.07	26	6.97	14
62	Costa		200		8	victor fajardo	8	lote 25	25	4-05-06	8	lote |4
58	costa		86									
495		945408966										
57			240									
54	costa	956928070 95299	494.45		20.10	13-14-15	36.60	16	37	12	20.10	28-29-30-31
187		994715643	200		10	LOTE15	20	LOTE9	20	LOTE7	10	LOTE 15
131			90									
134			280									
130			3000		-	-	-	-	-	-	-	-
109			160		8	CALLE ILO	20	MARIANO PACOMPEA	20	IGLESIA ADVENTISTA 	8	MARIANO PACOMPEA
133			315.98		22.48	Av Caylloma Cayarani	14.93	lote 11,12	13.85	lote 9	21.50	Alameda
155	Costa	950879454	155.43		-9.41	mz. 33 	-16.50	08	-16.50	10	-9.43	16
106		953637164	463.310		19.53	Calle Mariano Melgar	22	Lote 5,6,7	25.31	Pasaje Jerusalem	20.43	10
135			257.22		10.25	LIBERTAD	15.66 -13.10	lote 6-8	28.94	calle pizarro	8.09	lote 8
120		940824043	4816		40	CANTERAS YURA	(1) 82.6, (2)12	LOTES 5 Y 6	136.6	lote 3	28	CALLE E-14
200		974501837	93.75		7.50	AV. LEONCIO PRADO	12.50	LOTE 19	12.50	sublote 20a	7.50	21
111		994776107	150		7.50	14	20	14	20	16	7.50	9
143			130			CARRETERA APLAO CORIRE		CON EL COMPRADOR		ROSA DIAZ VDA DE MONTES		ROSA DIAZ VDA DE MONTES 
159		953404140	239.63		10	CALLE N	24.06	LOTE 8	24.08	LOTE 10	9.92	LOTE 12
549			233.6		8	18	29.2	lote 8	29.2	lote 10	8	lote 47
116		990030300	200		10	LOTE 38	20	LOTE 17	20	LOTE19	10	LOTE 9
180		999214527	180		8	CALLE 007	22.50	LOTE 16	22.50	LOTE01	8	LOTE 3
140			500		20.35	av cusco	21.86,9.63,11.9	 lote 7,6Propiedad Gregorio Condori Q	27.81	 lote 9 Propiedad Wlatter Alvarez Quintana	24.35	lote 6 comunidad campesina 
149		996999331	220		10	pasaje N| 3	22	lote 3	22	LOTE 5	10	LOTE 4
173		992257892 92134	214		10.78	JR. JOSE GALVEZ	19.84	JR MIGUEL GRAU	4,07  15.59	LOTE 2	11	LOTE 20
110		961998842	327.25		14.88	CALLE 11	22	CALLE 4	22	lote 3	14.88	LOTE 5 PARQUE
275			300		Norte	lote Blanco	Sur	Bartolome Chambilla	Este	Campo Deportivo	Oeste	Calle Yucamani
113		931018096	877.42									
117		987864842	250		10	CALLE 9	25	LOTE 8	25	LOTE 6	10	LOTE 14
164		989813938	207.5		10.64	pasaje 5	19.82	jiron  principal	19.81	lote 5	10.33	lote 3
188		940227982	71.700		5.60	CALLE 2	7.20	LOTE 1	13	LOTE 13	5.350	LOTE 2
236			3000		48	MICAELA BASTIDAS	62.50	CALLE ATAHUALPA	62.50	CALLE HUAYNA CAPAC	48	Pasaje Inca Roca
150	Costa	953935955	338.60		22.80	Ilo	19.50	calle Dos de Mayo	10.50	Mirave	11 	Manuela Gonzales
142			184		16.24		11.06	LOTE09	11.15	VICTORIA URQUIZO DE CARDENAS	16.92	
119			100.22		5	CALLE 46	20.05	LOTE 20	20.04	LOTE 19A	5	LOTE 4
178					-		--		-		-	
156			171.60		10	73	10	24	17.16	lote 2	17.16	47
114			200		10	D	20	lote 5	20	lote 7	10	lote 1
241			800									
215	declarat fabrica	956722171	250		10	CALLE 8	25	LOTE 7	25	URB LOS ANGELES	10	LOTE 7
115			300	200	10	AVENIDA N° 6	30	LOTE 7	30	LOTE 5	10	LOTE 19
151	Costa	923214462	160		8	JOSE A. DE SUCRE	20	LOTE 3	20	LOTE 5	8	lote 24
193		983936741	900 VARAS									SEQUIA ACENDADOS
168			6464		80		65		77		100	
138			504.84	40	16.5	av 1	30.57	lote9	28.18	lote 11	18.	lote 8
265	edwin666@hotmail.com	942932230 98381	229.81		13.90	Pasaje Cutupari	16.61	Lote 16	16.43	Lote 19	13.93	Lote 8,9
141			Medio Topo			CARRETERA COTAHUASI-ALCA		ANTONIO TELLES		LUIS ROSAS BENAVIDES		VICTOR RONDERMAN
163		958005266										
145			432		19.20	CANDELARIA	22.50	SAN MARTIN	22	JUSTO CHACON	19.20	SANTA ROSA
129			1,430.70		42,33	calle grau	46,55	lote 6,5 pasaje olimpico	22,15	pasaje ccanchis lote 7	20,97	lote 2,3
248	 hectorsan_1@hotmail.com 	980798083	282		12	PASAJE 2	23.50	LOTE 15	23.50	CALLE PAITA	12	LOTE 1 
101		952874477	545			MARIANO MELGAR		PROPIEDAD DE LINO CAHUANA		AMAZONAS		JUAN GRANADOS
108		953966224	630		8	CALLE ILO	20	MARIANO PACOMPEA	20	IGLESIA ADVENTISTA 	8	MARIANO PACOMPEA
112			164.19		8	CALLE 28 DE JULIO	19.91	LOTE 11	19.93	LOTE 09	8.49	LOTE 03  MANZANA ALFA .AREA VERDE
198		986192977	450		15	calle11	30	lote 3	30	lote4	15	lote6
165	Sierra	931818017	853.04		16.36	PASAJE 2	40	LOTE 8 ,4	228.83-16.07	LOTE 6	16.6	asentamiento Humano Santa Martha
172		956103304	355.86		12..03	CALLE VALPARAISO	29.53	LOTE 13	29.50	LOTE15	12.08	LOTE 3 y4
170			166.03		8.59	CALLE HUASCAR	20.10	CELSO MIRANDA	20.10	LOTE 2	7.93	PASAJEFROILAN
171		959001185	152.250 		8.41	CALLE MARCALLE	17.730	LOTE 01	17.56	LOTE3	8.88	LOTE 17
175		984841619	237.34									
258	COSTA		135.120									
179		959460354	640		16	CALLE 03	40	LOTE 01	-		16	LOTE TERRENO OTROS USOS
177		959648488 95889	336		14	AV. DIAGONAL	24	LOTE 2	24	PASAJE PEATONAL	14	LOTE 9
152	Costa	998990582	160									
186		959660874	184.67		9.33	pasaje 3	20.39	lote 10	20.61	jiron 3	8.91	lote 1
136		984493487	348.50		14.91	CALLE SALAVERRY	21.88	COPACABANA	24.52	lote 4	15.25	lote 5,1
137			493			UMPIRE FERNADEZ		CALLE LIMA		SOLAR DEL PUEBLO 		CALLE SAN ANTONIO
169		910170030	165.82		8.58	CALLE HUASCAR	20.10	LOTE  3	20	LOTE 1	7.92	PASAJE FROILAN
158	decl.Fabrica 43	940419283	194.90	con licencia co	10.35	CALLE 9	18.63	LOTE  3	19.24	CALLE 1	10.25	LOTE 5 A
161		969909372	313.50		10.40	JR. RAMON CASTILLA	30.05	LOTE 6	30	LOTE8 	10.50	LOTE 4 Y 5
184		950085725	-		10.05	av los geranios	20.93	lote 18	20.93	lote 18	10.00	lote 8
280			324		18	calle proyectada	36	Lote 23	36	1-2	18	Manzana P
105	Costa		120		6	28	20	23	20	PERIN	6	LOTE 01
118		937259140	200.54		10	CALLE 46	20.06	LOTE 21	20.05	LOTE 19	10	LOTE 3
102			109.16		5.45	AMAZONAS	20	LOTE 13	19.70	LOTE 15	5.55	LOTE 06
144			286		13	calle s/N	20	lote 04	24	lote 02	13	calle s/N
182			300	-		04	-	lote 02	-	10	-	lote 18
174	Rustico		228		17.86	lote 03	12,170	LOTE 01	12.270	LOTE 4	19-700	empresa nacional feroc del peru
104			120		6	calle 28	20	lote 22	20	LOTE 24	6	lote 2
227			200			PASAJE BOLOGNESI		SRA VICTORIA		RESERVORIO		LOZA DEPORTIVA
274			falta									
259	COSTA		117.940									
225		941916962	159.81		8	Pasaje Bolognesi	20	lote 2	20	lote b4	8	lote 10
239		975253135	200									
237			490									
383		961671844										
371	omnimelony@hotmail.com	940239075 95200										
347												
315												
314												
286			1493.01		36.67	7de Junio	40.88	Garcilaso de la Vega	41.14	Francisco Zela	36.15	Manco Capac
309		958309639	814.80		16.70		55.75		53.35		9	
216	Rustico		400		16	ALAMEDA CUAJONE	25	AREA COMUN MISMOS PREDIO	25	TERENO MC VERDE	16	MISMO PREDIO 
318	Sierra	989590040	107.69		21.01	21 de agosto	S/N, y Carreter	14 de octubre	9.83	los propietarios	21	carretera con lienia quebrada
190			439.74									
249			144	con licencia co	8	PASAJE8 	18	LOTE 11	18	LOTE 13	8	LOTE 19
269			144		8	av Proyectada E	18	Lote 3	18	lote 1	8	Lote 15
222		972258383	389		10	Loa Perales 	32.59	Costado derecho del Lote 1	32.59	Costado Izquierdo lote 3,5 y 6	10	Area a Desmenbrar
202		958656434-95933	680.31		17.73	jiron lampa	21.62	lote 1.1a	0.83	lote 11	18.400	lote 10
339			250		10	con calle 32	25	Lote 06	25	lote 8.-9.10	10	Lote 13
257	COSTA		150			PASAJE 16	15	LOTE 18	15	LOTE 16	10	FROILAN TICONA APAZA
273		977569387 92495	200									
283		952978894	184.80									
232	 gerenciacorcanet@gemail.com 	#957811682-9735	200		--		--		-		-	
263	chambilla120@gmail.com	979538728 99025	112		0.7	14	16	Lote 14	16	Lote 16	07	Lote 08
218	catacoral246@hotmail.com	952976116	2060		20.60	AV.  LITORAL ALA PLAYA	100	TORIBIA CALISAYA	100	JOSE GUSRINO CALISAYA	20.60	CAMINO CANAL UCHUSUMA
235			101.05		05	san martin	21.50 	calle vizcarra	21.50	calle junin	13.80	propiedad quintin cayla mamani
268			150		7.50	38	20	lote 1-2-3-	20	Lote 14	7.50	Lote 6
251		954132436	184.09		13.26	  urubamba FELIX BAMDA	10.02, 6.17 ,1.	lote 4	12.14	lote 4	11.05	 lote 6, SIMON ZEBALLOS
267	atlantic.tacna@hotmail.com	969999796 95288	144		8	av Proyectada E	18	LOTE 2	18	38	8	LOTE 15
261			583.070		17.980	AV. EMANCIPACION	32.250	LOTES 15  Y 16	32.250	CALLE H 	18.200	PASAJE 3
321	Costa	979499711	147.50		11.50	Haiti	13	01	16.50	12	10	4 y 5
195			250		10	AURELIO DE LA FUENTE	25	LOTE  3	25	LOTE 5	10	LOTE 38
224			211.22		7.75	JIRON. 2	18.50	PASAJE 1	20	LOTE 5	5 y 8.80	LOTE 2 y 3 
252		983936484	189.77		10.38 Norte	eriazo terrenos estado	10.38 Sur	11	18.29 por el es	23	18.29 por el Oe	21
377		959585007	171.60		8.58	37	20	23	20	lote 1 y 2	8.58	lote 5
197		959065940	126.36		14.72	calle 1er de enero cale 53	8.99	lote 5	8.50	lote 3	14 20	pasaje palmeras
285		957474231	170		8.50	Pasaje 18	20	l0te 3	20	Lote 5	8.50	Lote 9
266	humbertollacac@hotmail.com	952623223 91057	140		7	calle Chucuito	20	Lote 6	20	Lote 4	7	Terreno eriazo del Estado
223		973235640	308.46		24.67	jiron 4	8.37	lote 7	24.10	pasaje 2	19	lote 5
233		959618017	433.15		20.47	calle tramo H:A	21.33	lote 5 y tramo HG	21.28	M. grau Tramo A-B	20.19	Sub Lote  6 B Tramo G-B
230	 paul_7aqp@hotmail.com 	921727265	200		10	AV. 9 DE DICIEMBRE	20	LOTE 2	20	LOTE 4	10	LOTE 6
305			200			con callle 04		con lote 02		con lote 10		Con lote 18
260			308.07		9		20		20		9	
272		967070789 	219.32		11	Jiron Santa Catalina	20	Lote 2 A	20-001-002	 Lote 5,4-27.59-13.51- Av. Libertador San Martin	11	Lote 2 A
189		933396415	506.36		16.71	CALLE BRAZIL	29.98	LOTE 22	29.95	LOTE 24	17.10	LOTE 1,2 
256		952646359	120.48		7.45	CALLE 7	16.14	CALLE 21	16.15	CALLE 8	7.47	LOTE 6
194		923213505	200		10	PASAJE S/N	20	LOTE T9	20	LOTE T12	10	LOTE T1
370												
250	 conirsac@hotmail.com 	953723546	191.76		10.5	CALLE N ° 10	19.5	CALLE N 8	19.03	CALLE 8	10.04 	PARQUEN 2
372			1190		34	Los Heroes de la Guerra del pacif	35	Con Comercio	35	Con el  lote Otrod Fines	34	Con Comercio
255			414.37		17	CALLE INANBARI	24.730	LOTE2	30.240	LOTE 29	2.040, 8.95 y14	LOTE 4 y3
277			750									
350		942645884	131.25		7.50	Maria Parado de Bellido	17.50	lote 16 	17.50	con el lote 18	7.50	con el lote 15
282		989290054/98929	145.96		9.02	PASAJE LL	16.15	PASAJE 7	16.14	LOTE10	9.06	LOTE8
306		973582873	120									
353			201.05		10	F-45	20.15	 lote12	20.15	Lote 14	10	lote 08
349												
226		945031019	200									
276			161									
328												
281	COSTA	965082240	120		46		15	lote 9	15	LOTE 11	8	lote 25
392			190									
238			194.28		9.85	los safiros	19.64	lote2	19.76	lote4	9.9	lote 22,23
278	COSTA		480									
569												
270	COSTA	#999905582	300		15	EMILIO FORERO	20	CALLE ALCAZAR	20	SUB 5B	15	LOTE 4 
199	Sierra	958817240	1055.22		18.68	Avenida Mariscal Castilla	001-002-003	18.70-19-20	38.83	calle Teniente Ferre	35.16	lotes 19.20
382		952871850	1600		40		40		40		40	
300			233.60		8	calle 17	29.20	lote 48	29.20	lotes 1,2,3	8	lote 7
221		983443991	303.03		17.91	AV.VICTOR ANDRES BELAUNDE 	19.95	LOTE 4	20	LOTE 6	12.70	LOTE 19 A
290		951027272	115,11		6		19.67		18.98		5.88	
262	cantor_2100@hotmail.com		298.27		10.01	calle 18	30.03	lote 08	29.63	LOTE 6	10	CALLE 17
279	Sierra		1 TOPO Y 1/4 		Norte	Camino piblico	sur	Doña Rosa Valdivia de Franco	Este	Carretera Tacna Tarata	este	Doña Francisca Segura 
379		927580122										
303	Costa		111		17.50	03	3	Asoc.Tupac Amaru	8.50	Adrian Patiño 	18	IGLESIA ADVENTISTA DEL SEPTIMO DIA
331		#959437438	600									
391												
288			300									
362												
361												
343			600									
295		958852092	140.61		11.96	carretera coporaque	11.65	lote 2	11.92	calle Manco Capac	11.91	sublote 1A
344												
346												
335												
336			400									
338												
287		978626836	5400									
516			400									
487		983648422	640									
417												
513												
503												
411												
520												
429												
545			200		10	avenida 9 de diciembre	20	lote 3	20	lote 5	10	lote 15
406		974386100										
519												
512		956257303										
455			1000		Norte 53.50	Bosq forestalue	sur 48.10	lote 8 y 1	Este 29	Calle buen pastor	Oeste 29	Lote 7
402												
428												
398		982385035	197.61		6.69	avenida San Martin	29.78	lote1a.lote 1b	29.76	sub lote 21b	6.61	lote 1A
401		968613588	225		9	lote 7	25	lote 03	25	lote 05	9	lote 12
310		950085725	200									
412		954600109										
337		994792389	172		10	avenida francisco javier l p	17.20	lote vv3	17.20	lote 8,9	10	lote 12
477			165		7.50	calle 2	18	Lote 5	18	lote 03	7.50	lote n 12 
463			190									
478			211.26		13.63	Yolanda Valdivia	15.50	Yolanda Valdivia	15.50	Yolanda valdivia	13.63	Yolanda valdivia
359		969809993	160		8	calle 142	20	lote 1	20	lote 3	8	lote 36
394		948527142										
364	Costa		161.97		7.93	pasaje el Mocara	20.40	Lote 3	20.45	LOTE 1	7.93	Lote 12
325												
399												
292	acumular		433.24		12.92	Manco Capac	22.43, 4.04 ,5.	lote 10	22.24, 6.07	ronda	18.98	lote7,lote 6
441												
320		924550188	122.44		7.50	Pasaje portugal	16.02	5	16.03	3	7.81	99 Asociacion de vivienda jose abelardo
505			299.925			Calle Publica		03		01		Lote 10-y 04
363		952528340	154.30		7.93	5	20	29	20	27	7.50	03
567			200		02	puno y Lampa	entrando	Puno y Lampa	entrando 	LOTE 4		
393		951520459	200.25		9	413	22,25	4	22.25	c	9	18
524			151.93		10,61	calle 48	16.55	lote 12	13,32	lote 14	10,20	lote 10y 15
351	yudi2carina@hotmail.com		118.52		7.48	32	15.87	41	15.81	2	7.49	14
408		961060690	310.40									
332												
533			250		10						25	
427												
298	willort_248@hotmail.com	974717972	168.74		8	Lima	20.91	Lote 4	21.35	Sub lote 5	8	lote 9
480		941237057	200									
473			144.50		norte 	calle 	sur	calle 07	este	Domitila Mamani	oeste	lote 17
308			152.69		9.81	pasaje 13	14.14	lote 4	9.36-	lote 6,8	11.38	lote 2
334			800									
563			100									
356		930691850	160		8	50	20	Lote 3	20	Lote 5	8	Lote 35
452		959745890										
493		974370088	250									
289			200									
324												
518			200									
389			200									
506		960386140	155		10	carretera panamericana	15.50	lote 8	15.50	lote 11	10	lote 15
345												
460			831.81									
375		953954206										
436		951886169 / 952	184.80									
326												
311			194.30		9.	calle 10	22	lote 04	27	lote 02	8	calle 01
535		965816626										
368			316.27		10.4	av andres avelino Pamo	31.12	lote 10 Area deportiva	30.9	calle 7 de Junio	10	lote 2
467	leo-mh@hotmail.com	941098987 95127	136.71		8.32	pasaje paratia	16.04	lote 31	16.03	LOTE8 	8.74	lote 21,22
291			157.30		7	calle manco capac 	22.54	lote 6	22.43	lote 8 (0tros fines)	7.01	lote 8,6
342			194.790		7.07-5.74	nueva esperanza	13.73	lote 33	14.87	lote 35	14.68	lote 35
376			160		8.	PASAJE 5	20	LOTE 24	20	LOTE 26	8	LOTE 4
445												
294		973509432	medio topo									
454		952485516										
355			160		8	01	20	29	20	31	8	07
381		952213647										
341		962052487										
568			200		10	18	20	01-02	20	20	10	05
302			1089 Varas			Doña Mauricia	Medio	Por el pie con los pantanos alame	Costado	Arriba casa Dr.Gregorio Ugarte	Abajo	Don Carlos Wagner
479			843		23.99	Chapi	43.80	Oscar Choque 	36.74	Elisban Siles	17.90	con pasto
301			320		16	calle 5	20 	lote 12	20	lote 18	16	lote 7-8
438												
378		952213650										
525		952682418										
522			109.80		8.90	Argentina	12.03	Sublote 1	12.12	sub lote 1Aa,1A4	9,32	sub lote 1A3
400		54 533379										
333			402.50		23	calle los angeles	17.50	evangelina alvarez	17.50	las palmeras	23	francisco nayra
451		979097011	200									
422												
529			200									
319			200									
323												
340			180									
440												
421												
548		950441828	130.33		0.8.33	calle 11	15.64	sub lote 3	15.64	sub lote 4-A	08.33	sub lote 4-F y sub lote 4-E linia recta
497												
358												
407												
446												
514			400									
515			250									
517												
561												
472			214.76		Norte	Jesus Chapi Apaza	Sur	Remigio Gomez Nina	Este	Cipriano Flores Infa	oste	Calle Paz Soldan
551		972409432										
484			1024									
447												
507		939179744	1457									
425												
139	957975653		800.19		20.11	calle san luciano	19. 150. 20.570	lote 3,10	23 930 15.700	lote 5,9b	20.390	calle san pedro
468		958081541	1184.01		22.11	Francisco Bolognesi	54.23	Otros Fines	44.540-5.470-2.	3.20 Pasaje 10 Mz. LL  Lote 1	21.89	Manzana LL Lote 11
297			250		Norte	Agapito Yugra Huamani	sur	Juana Huamani Llallacachi	El Este	Asoc. Local Comunal	Oeste	Calle Sabancaya 
594												
284			120		6	principal	20	19,18,17	20	21	6	13
410		957923884/93760	360		20	prolongacion Calle siglo	18	terrenoa eriazos	18	lote 16	20	calle carumas
496		958682344 	200		10	avenida 2	20	lote8	20	lote 10	10	lote 14
409			146.30		8.97	Pasaje San Valentin	17.83	Lote 02	17.69	General Sanchez Cerro	7.53	10
100		952845010-95267	250		10-Norte	Colinda co la calle Cristina Vildoso	10  Sur-	Colinda con Iglesia Adventista	25-Este	Colinda con Maura Cecilia Calderon	25-Oeste	Colinda con calle San Francisco
528			227.55		14.200	av.puno	17.800	lote 7	13.800	lote 9	15.00	Av. 8
534			250									
160	miriam.huarca@gmail.com	973676368 98635	513.15		22	Cerro Juli	23.75	lote 11 de la Mz B	22.90	Lote 12 de la Mz B	22	Lote 13 y 14 de la Mz B
217	Costa	948027103 952 6	112		16-Norte	Propiedad con los Dueños	16 -sur	colindante con la Parcela D	07 El este	Propiedad con los vendedores	7.00 oeste	Propiedad con los vendedores
597			450		15	17	30	area verde de la asoc.	30	lote 03	15	lote 05
581			300									
527			150		7.50	calle 11	20	lote 23	20	lote 25	7.50	lote 11
499			250		12.50	los Geranios	20	16	20	14	12.50	13
40	Costa	961037642	286		12	las orquideas	27	entrando propiedad Eloy Alvis m	25	entrando calle sin Numero	10	propiedad Yensi Arena
556			115.72		9.75	alameda	12.19	sub lote 1a4	12.12	sub lote 1	9.32	sub lote 1a2
34	Costa	951775060	120		8	Pasaje sin Numero	15	lote 23 Felix Calderon Zegarra	15	lote 21 Edurado R. Cahuana	8	lote Catalina Anahua Paco
219			160.80		8	CALLE RESTAURACION	20.10	LOTE 9	20.10	PASAJE AL PARQUE INTERNO	8	PARQUE INTERNO
580												
442												
414		953617274	150		7.50	44	20	Lote 5	20	Lote 7	7.50	Lote 19
600			165									
560			158.63		10.25	hector fernandez	12.14		16.22		9.81	
555			162		9	jupiter	18	lote 07	18	lote 09	9	lote 21
405		958878464	217.76		8.08	Guardiola	27.44	Pasaje 6	01-02	Lote 1	8.12	Pasaje 2 de Mayo
553												
357			902.91		21.2	Miramar	40.2	Arica	39.9	servicios de Salud 	24.15	Calle San Francisco
24	sierra	#952955156	687		14	av.la rivera	42.35	propiedad de don Juan Carlos Alvares Garcia	25-35-6.49-15-3	entrando propiedad Juan Carlos Alvarez 	13.69	propiedad Juan Carlos 
595			200		8	6	25	4	8	16	25	6
599												
588												
12		950723973	804.80		20.37	av independencia	29.81 -10.01 	lote 6-5	40.08	manzana m	15.12 - 4.48 -	lote 35
587												
413		953967916/95506	119.63		7	av La Paz	17.40	apolinario Mamani	17.40	vendedores Genaro Mamani Flores	6.35	Vendedores
403		973116348										
404			136.32		7.64	calle 1	18.31	calle 2	18.34	calle 3	7.50	calle 2
482												
586												
475			120		8	con avenida 2	15	con lote 30	15 	lote 41	8	con lote 06
453		910443984	267.07		13.10	Avenida 04	20	Lote 06	20.47	Calle S/N	9.20	Parque 2
458	oloc.26@hotmail.com	950900606 95228	3245		norte 	Jose Humberto y Hortencia Covinos Taddey	Oeste 102.60		sur	callejon publico 	Este 11.85	
293		983648422	288.58		13.56	ugarte	18.08	lote 4,5,6	10.32,4.61,4.74	lote3	67,10.99,8.81	calle pumacahua
191			367.46		8.05	jiron ricardo palma	40.36	lote 2	17.64-  23	lote 9-4	10.11	jiron sucre
35	Costa Rural	983134790 	300		10.000	Carretera Tacna Calientes recta 10.000	30.000	Elizabeth Huayhua de Herrera	30.000	Ramon Inchuña	10	Ramon Inchuña
254		983046514	193.75 con fabr		10	CALLE OESTE 5	20	LOTE 5 	15	ALAMEDA LOS LIRIOS	10.61 y 3.54	ALAMEDA LOS LIRIOS LOTE 7
557			200									
448												
103	soledad_beatriz_007@hotmail.com		120		6	numero 28	20	numero 21	20	numero 23	6	numero 03
304			100		10	colindante Panamericana Sur	10	colindante con el lote 3-A	10	colindante con el lote 3-C	10	terreno eriazo del estado 
352	mendoza.marysabel@gmail.com	962022547	113.22		7	pasaje asillo	16.18	21	16.17	23	7	11
602	ACCIONES Y DERECHOS  15%		150									
354		926009163										
419												
601			300		10	dos de mayo	30	lote 09	30	lote 11,12,13	10	lote 17
185		959074304	233.6		8	CALLE 7	29.20	LOTE47	29.20	LOTE49	8	LOTE 8
504		988312821-93504	acciones derech									
196		983770224	98.01	segundo piso	10.32	jiron 9	9.62	lote 4	9.65	pasaje 3	10.03	seccion 1
596			116		7.25	20	16	18	16	lote N° 2	7.25	21
538			5000									
423												
234			2,214.21		637.07	CALLE PROLONGACIOPN JORGE  CHAVES	.6.05 -219.81	los crisantemos	20.28 -10.99 -2	otros fines	48.17	lote 23 manzanz z lote 3  Area verde
317	Sierra		2718.96		46.80	limita co la cooperativa del carmen	63.48	linea ligeramente quebrada	53.44	colinda con propieda IADS	42.35	colinda Hnos Llanos
474			120		8	con avenida 02	15	lote 38	15	con lote 40	8	con lote 7
613			220									
296			562		16.50	calle cusco	39	propiedades de Dueños	34	Ricardina Ancco Capira	15.50	Mandy Yanque Churo
240	COSTA	931383810 94465	182.90		9.20	los Jazmines	20	Lote 9	19.60	Lote 11	9.30	Direc.Gral.de la Reforma Agradia y Asent. 
27	ficha r 05113275		3000		50	colinda con los vendedores-norte	61.08	colinda con los vendedores-este	50	colinda con lon vendedores tercero- sur	61.80	colinda con la avenida El Sol-oeste
610												
615												
612			300									
65	Costa		160		8	Jr. Chimu 	20	Lote 03	20	Lote 05	8	Lote 14
192		950076671	259.68		10.1	 calle san isidro NORMA TORRES	26	propiedad de terceros  TEODORO FLORES	26.02	 lote 11 CON LA VENDEEDORA	9.88	lote 9 TERRENO DE LA VENDEDORA
616												
609			200									
464			1,097.06		2.23 y 28.15	paz soldan	36.85	garcia caldern	21.65 y 15.65	pantigoso 	28.32 perimetro	Juan Martin Campos
614			120		8	calle 2	15	lote 40	15	42	8	5
606			127.24		10.81	6	5.11 y 4	5	4.15 y 7.50	2	14.67	2
107			896.94		5.25	CALLE CUZCO	12.55,10.30,3.4	PROPIEDAD  DE DOÑA TRINIDAD PEÑALOZA ,DON ALBARRAC	23.20,7.48, 4.0	APOLINAR MALDONADO MARIANO PACOMPEA	22	IGLESIA ADVENTISTA DEL SEPTIMO DIA
608												
605			160		10	recreacion 01	16	lote 03	16	02	10	lote 01
617			1500									
618												
604			5000		50	camino carrozable	100	Jose vilca Perez	50	Juan Pedro Martin Davalos Lopez	50	Juan Pedro Martin  Davalos Lopez
611			138.30		9.53	calle recta av.	14.88	David Mamani Quilla	14.14	Natividada Velasco Taype	9.56	con canal
307	smile_grenco@hotmail.com	957922903 95343	112.96		7.07	pasaje 20	16.04	con el lote 10	16.05	con el lote 12	7.01	con el lote 14
603												
620			1000									
607			200		10	2	20		20		10	
\.


--
-- Data for Name: predios_registral; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_registral (id_predio, fecha1, fecha2, ficha, libro, folio, asiento, titular, municipio, zonareg) FROM stdin;
48	1999-09-01	\N	P08034290				IASD		
37	1999-05-21	2015-01-01	13388			40563	IASD	Contribuyente 	Tacna
17	2000-02-17	2018-03-01	PO6024376-IASD			4	IASD	Contribuyente 	Arequipa
16	2000-10-01	2018-03-01	PO6097193-IASD				IASD		Arequipa
23	2014-03-18	2018-04-03	11023945-IASD			C0003	IASD	Contribuyente 	AREQUIPA
594	\N	\N							
225	2016-04-05	2013-03-01	P06060962 -IASD				IASD	Contribuyente	AREQUIPA
239	2015-12-09	2018-04-01	11075202-IASD				IASD	Contribuyente 	Tacna
119	2019-05-09	2016-02-01	p06079503				IASD	tribuyente 	AREQUIPA
249	2003-04-09	2013-01-01	P06119496				IASD	Contribuyente 	AREQUIPA
596	2022-04-25	2022-07-12	11062227					contribuyenye	
238	2002-11-18	2011-07-01	P20042928				IASD	Contribuyente	
30	2016-06-23	\N	05128420-IASD				IASD		
42	\N	\N		 p06198763	Comis.formal cof				
221	1900-11-16	2018-04-01	P06085383-IASD				IASD	Contribuyente 	AREQUIPA
168	2024-02-09	2018-05-01	00944748-IASD				IASD	Contribuyente	AREQUIPA
44	2000-02-28	\N	1175391				IASD		Arequipa
71	1999-06-11	2017-01-01	p20073838-IASD				IASD	Contribuyente 	TACNA
116	2001-05-29	2016-01-01	p06071241					contribuyente	AREQUIPA
66	1995-08-25	2013-01-01	21133				IASD Uso	Contribuyente 	Tacna
114	2017-10-27	2017-01-01	P06069565-IASD			6	IASD	Contribuyente 	AREQUIPA
257	2003-03-17	2018-06-01	P200495228				IASD	Contribuyente 	Tacna
599	\N	\N							
29	2019-11-11	2005-04-01	11429438 IASD					contribuyente	Arequipa
65	2024-02-20	2024-02-20	24455			t6497	IASD	Contribuyente 	Tacna
88	2011-06-23	2018-04-01	p06249201-IASD			2	IASD	Contribuyente 	AREQUIPA
173	2002-09-13	2022-04-05	P06089006				IASD	Contribuyente	AREQUIPA
254	1900-11-19	2018-09-04	P06151425-IASD				IASD	Contribuyente	AREQUIPA
172	2014-11-09	2018-05-01	P06049593				IASD	Contribuyente	AREQUIPA
152	1900-11-03	2018-05-01	P08023431-IASD			1	IASD	Contribuyente 	ILO
595	2023-09-01	\N	P06170733						
32	2019-05-10	2018-02-01	11003031-IASD				IASD	contribuyente	ILO
120	1980-10-27	2016-03-01	P06156525-IASD			7	IASD	Contribuyente 	Arequipa
112	1999-10-13	2011-01-01	P08006475				IASD	contribuyente	san Francisco
79	2008-06-24	2008-03-06	p20045494				IASD	Contribuyente 	
111	1900-05-13	2018-03-02	P08009544				IASD	Contribuyente 	
12	2020-03-12	2022-07-21	P06184523					contribuyente	
117	2013-06-25	2014-01-01	P06080724				IASD	Contribuyente 	AREQUIPA
240	2016-04-25	\N	P20070790-IASD				IASD		
62	1991-09-02	2018-02-01	38151-05014932-IASD				IASD	Contribuyente 	
156	2016-09-13	2018-05-01	11003953-IASD			2	IASD	Contribuyente	
159	1999-11-06	2003-01-01	P06033389			5	IASD	Contribuyente 	AREQUIPA
33	2014-04-09	\N	P08012936-IASD			7	IASD	Contribuyente 	Ilo
256	2000-04-19	2018-05-01	P20002853				IASD	Contribuyente 	TACNA
155	2014-06-09	2018-05-01	p08025386-IASD				IASD	Contribuyente	TACNA
26	2015-09-11	2005-04-01	P20009292-IASD				IASD	Contribuyente 	tacna
90	2018-09-18	\N	P66000189-IASD				IASD	Contribuyente 	Ilo
129	2005-08-22	1983-01-01	p06220889				IASD	Contribuyente 	
233	2016-12-07	2018-05-11	P06093818-IASD				IASD 	Contribuyente 	AREQUIPA
47	2001-11-26	2014-01-01	P06173726			3	IASD	Contribuyente 	Arequipa
106	2009-07-07	\N	P08006541				IASD	Contribuyente 	
162	1988-12-29	2005-05-01	00110644-IASD				IASD	Contribuyente 	AREQUIPA
52	2019-09-02	2015-10-01	P06233580-IASD				IASD	contribuyente	
69	2003-09-08	2013-01-01	P20019674				IASD Cofopri	Contribuyente 	Tacna
215	1991-03-06	2017-04-01	01088088-IASD				IASD	Contribuyente 	
5	1990-01-01	\N	P06009428				IASD	Contribuyente	Arequipa
260	2006-11-19	2018-04-01	P20003245				IASD	Contribuyente 	TACNA
105	1998-07-06	2018-05-01	P20026863			5	IASD	Contribuyente 	TACNA
43	2000-02-28	2015-05-04	P06051891			2	IASD	Contribuyente 	Arequipa
73	2014-11-11	2018-02-01	P20018562-IASD			5	IASD Cofopri	Contribuyente 	Tacna
224	2019-08-16	2018-01-01	P06060594-IASD					Contribuyente	AREQUIPA
218	1900-11-16	2011-01-01	20503				IASD	Contribuyente 	TACNA
75	2015-08-25	2017-01-01	P20054109-IASD				IASD	Contribuyente 	Tacna
236	1987-03-11	2016-01-01	P08011988			Ficha 00165	IASD	Contribuyente 	MOQUEGUA
53	2004-09-01	2005-01-01	11008249				IASD	Contribuyente 	
34	1999-07-23	2013-01-01	34196			44308	IASD	Contribuyente 	Tacna
41	1900-08-10	2013-01-01	P08023523-IASD				IASD	Contribuyente 	Moqueg.Dec.Fabri.
109	2003-03-03	2017-04-04	5002417			C005	IASD	Contribuyente 	MOQUEGUA
64	2001-07-21	2011-02-01	P20021048			3	IASD	Contribuyente 	Tacna
188	2019-01-30	2018-04-01	p06201034				IASD	Contribuyente 	AREQUIPA
261	2000-06-29	2018-04-01	P20000011				IASD Cofopri	Contribuyente 	TACNA
60	2002-05-30	2018-01-01	P20008731				IASD	Contribuyente 	Tacna
3	2002-11-25	2010-06-07	P06000276				IASD	Contribuyente 	
74	2015-08-25	2017-01-01	P20054108-IASD				IASD	Contribuyente 	
118	1999-12-17	2018-04-01	P06079504			4	IASD	Contribuyente 	AREQUIPA
103	1999-10-10	2018-05-01	05012767 IASD			3	IASD	Contribuyente 	tacna
72	2015-08-13	2017-01-01	P20054137				IASD	Contribuyente 	
4	1989-12-29	\N	PO6000527			5	IASD	Contribuyente 	Arequipa
2	2000-08-29	2000-01-01	PO6014531				IASD	Contribuyente 	
165	1900-11-09	2018-02-02	P06075685				IASD  	Contribuyente 	AREQUIPA
161	1996-01-03	2016-01-01	P06032108			2	IASD	Contribuyente 	AREQUIPA
184	2019-06-13	\N	P06083148-IASD				IASD		
28	2013-06-25	2017-01-01	P06070059			4	IASD Cofopri	Contribuyente 	AREQUIPA
262	2018-10-01	2018-03-05	11016527-IASD				IASD	Contribuyente	
177	2000-11-20	2018-05-01	P06112877				IASD	Contribuyente	AREQUIPA
70	2012-04-24	2017-01-01	P20037637-IASD			6	IASD	contribuyente	TACNA
67	\N	\N		p20051251 	Comis.formal cof				
102	2001-06-12	2008-05-01	11000967				IASD	Contribuyente 	
219	2024-02-16	2006-01-01	4485				IASD	Contribuyente 	TACNA
25	2013-10-21	\N	05119589-IASD			C0007	IASD		Tacna
597	\N	\N							
104	1900-10-12	2018-05-01	P20026862			6	IASD	Contribuyente 	TACNA
54	2010-02-01	2013-01-01	11004781-IASD			C00003	IASD	Contribuyente 	Tacna
187	1900-11-11	2015-08-01	P06039385				IASD	Contribuyente 	AREQUIPA
139	2004-09-02	2018-01-03	p06211174				IASD	contribuyente	
286	1999-11-28	2018-05-01	P06154790				IASD Cofopri	Contribuyente 	
295	1999-11-29	2018-05-01	P06291603-IASD	IASD				contribuyente	
545	2005-12-27	\N	P06103566				IASD		
507	2015-09-16	\N	11041267				IASD		chivay
227	\N	2014-01-01		p06139470	Comis.formal cof			Contribuyente	
258	2002-06-12	2018-04-01	P20001179				IASD	Contribuyente 	
132	1900-10-31	\N		p06251371 	estado peruano		IASD Cofopri		
309	1920-02-11	2018-05-01	107665				IASD	Contribuyente	AREQUIPA
320	2019-06-21	2018-02-01	P20020595-IASD				IASD	Contribuyente 	
393	\N	2018-04-06	PO6285687-IASD				IASD	Contribuyente	
392	2020-10-09	2022-07-07	p06284554					inscrito	
409	1987-02-22	2018-04-01	P08005989				IASD	Contribuyente 	
19	\N	2018-08-03	11213189-IASD			-	IASD	Contribuyente	-
356	2015-09-21	2016-01-01	P20051898-IASD				IASD	Contribuyente	
350	2017-08-24	2018-09-01	P20041661-IASD				IASD	Contribuyente	
151	2019-08-29	2018-05-01	p08021688	IASD		1		Contribuyente 	MOQUEGUA
9	\N	\N							
8	\N	2018-02-01		p06167222	cofop.trami.2018			Contribuyente 	
569	2019-02-22	2019-03-16	11007557				IASD	20190316	
351	2018-04-09	2018-03-01	P20004750				IASD Cofopri	Contribuyente	
364	2006-06-01	2018-04-01	P20038680			6	IASD	Contribuyente	sede Tacna
398	2017-05-17	2017-06-17	P06279904-IASD			6	IASD	Contribuyente	Arequipa
199	1900-11-12	1901-01-01	P06180113				IASD	Contribuyente 	AQP.Decl.Fabri.
24	\N	2018-07-02		01092990 dueñ			profesora-ela @hotma	Contribuyente 	
186	\N	2018-04-01		p06082844	Comis.formal cof			Contribuyente 	
524	2018-09-07	2018-09-02	11016101				IASD	Contribuyente	
217	\N	2018-05-02						Contribuyente 	
158	1999-11-17	2005-01-05	PO6073031				IASD	Contribuyente 	AREQUIPA
202	1900-11-12	2018-04-01	P06016895				IASD	contribuyente	AREQUIPA
301	1999-11-30	2018-05-01	P20040241				IASD Cofopri	Contribuyente 	
282	2000-03-03	2018-04-01	P20016294				IASD	Contribuyente 	TACNA
355	2015-08-14	2018-03-01	11037173-IASD				IASD	Contribuyente	Tacna
272	2015-08-25	2018-04-01	55131309-P06131753 -IASD			9	IASD	Contribuyente	AREQUIPA
251	2020-02-20	2018-06-02	p06094720					Contribuyente 	
13	\N	\N		p06186466	cofop.trami.2018			Contribuyente 	-
408	2019-02-22	\N	11007558				IASD		
10	2023-03-14	\N	p06182378						
310	\N	\N							
352	2006-08-17	2017-05-01	P20012422				IASD	Contribuyente	Tacna
230	2019-05-21	2018-02-03	55103177 P06103565				IASD	Contribuyente 	
538	2016-02-29	2016-02-29	5019169				IASD	Contribuyente	
234	2018-08-16	\N	P08006648 IASD			1	IASD		MOQUEGUA
414	2007-04-18	2018-06-01	P08010110			4	IASD	Contribuyente 	Tacna
35	\N	2015-06-01						Contribuyente 	
321	1998-06-16	2018-01-01	29591				IASD	contribuyente	Tacna
250	2009-03-06	2005-01-01	01123783-IASD				IASD	Contribuyente 	Arequipa
359	2016-12-04	2016-01-01	p20055128-IASD				IASD	Contribuyente	Tacna
150	2017-07-20	2018-05-01	11001735-IASD				IASD	contribuyente	Ilo Dec. Fabri.
263	2005-11-08	2017-02-01	P20012882				IASD	Contribuyente 	
413	1990-02-22	2017-03-01	5002861				IASD	Contribuyente	
467	2006-03-27	2018-03-01	P20014006			5	IASD	Contribuyente	Tacna
285	2010-02-02	2018-09-02	P20026363				IASD	contribuyente	
458	1994-04-04	2014-02-01	05047765-19200-IASD				IASD	Contribuyente	
268	2017-11-09	2018-02-01	11016748-IASD				IASD	Contribuyente	TACNA
174	2020-11-12	\N	p06101595						AREQUIPA
298	2020-09-07	\N	p06304653				IASD		
506	1900-05-10	\N			11038851				
280	\N	2018-01-01						Contribuyente 	Tacna
269	2018-10-03	2018-12-23	11016735-IASD				IASD	Contribuyente	TACNA
556	2018-05-03	\N	P06294473-IASD				IASD		
460	1990-04-03	2006-01-01	05008673-19510-IASD					Contribuyente	
135	2020-02-13	\N	p06159096 						
171	2009-04-17	2018-05-03	P06126236				IASD	Contribuyente	AREQUIPA
496	2018-09-21	2022-07-07	p06149191				IASD	Contribuyente	
248	\N	2011-01-01						Contribuyente 	
189	2014-11-10	2018-04-02	P06145160-IASD			3	IASD	Contribuyente 	Arequipa
363	2017-04-20	2017-01-01	11007815-IASD				IASD	Contribuyente	
405	2020-03-12	2014-01-01	P06184573 					Contribuyente	
45	\N	2014-05-01		p06031707 	Comis.formal cof			Contribuyente 	
279	2024-05-13	2001-02-01	5119478				IASD	Contribuyente	Tacna
192	2017-10-04	2018-05-09	55158196-P06158873-IASD				IASD-Cofopri	Contribuyente 	
376	2015-12-30	\N	P08015863.IASD				IASD	Contribuyente 	Ilo
534	2016-05-05	2017-01-01	11333657				IASD	Contribuyente	
555	2018-08-07	\N	55122371-P06122810-IASD				IASD		
1	\N	\N		p06014530 cofo	Comis.formal.cof			Contribuyente 	
273	\N	2018-07-04						Contribuyente 	
200	1900-11-12	2005-08-01	P06068132				IASD	Contribuyente 	AREQUIPA
196	2004-02-17	2003-01-01	P06193387 IASD				IASD	Contribuyente 	AREQUIPA
281	2012-05-16	2018-03-01	05011465- IASD			ficha 0000024315	IASD	contribuyente	TACNA
317	2004-07-19	2018-03-02	01166404-IASD			942115	IASD	Contribuyente 	AREQUIPA
255	2003-03-04	2018-03-02	p06094851				IASD	Contribuyente 	declaratoria fabrica
342	2016-01-15	\N	p23021852				IASD		
302	1919-06-11	2001-02-03	P06240555-00110162				IASD	Contribuyente 	Arequipa
560	2018-08-29	\N	12017814				IASD		Arequipa
265	2007-09-05	2019-07-02	P20014293 			5	IASD Cofopri	Contribuyente 	Tacna
266	2006-11-19	2018-11-03	P20019815				IASD	Contribuyente 	TACNA
504	2019-01-17	\N	p20064346-IASD				IASD		
7	\N	\N							tramitando cofopri
522	2018-05-03	\N	P06294472-IASD				IASD		Arequipa
464	2021-01-28	2012-02-01	11461821			2	AEAPS	Contribuyente	Arequipa
55	\N	2012-01-01		p20037127 -p200371126	cofop trami 			Contribuyente 	
259	2002-10-10	2018-06-01	p20001110					Contribuyente 	TACNA
287	\N	2018-04-01						Contribuyente 	
237	\N	2011-01-01						Contribuyente 	
131	\N	1986-01-01						Contribuyente 	
484	\N	2018-05-01						Contribuyente	
468	\N	2010-01-01		P06154394			ADRA	Contribuyente	
343	\N	2017-01-01		 p06244059	Municip.Provinci			Contribuyente 	
335	\N	\N							
22	\N	\N							-
297	\N	\N							
362	\N	\N							
361	\N	\N							
314	\N	\N							
46	\N	\N							
315	\N	\N		p06189904	Comis.formal cof				
371	\N	\N							
87	\N	2022-06-06						contribuyente	
15	\N	\N							
288	\N	\N							
274	\N	\N							
336	\N	\N							
344	\N	\N							
346	\N	\N							
347	\N	\N							
50	\N	\N							
325	\N	\N							
226	\N	2018-02-01		p06090390 	Comis.formal cof			Contribuyente 	
375	\N	\N							
170	\N	2018-05-01						Contribuyente 	
283	\N	2018-02-01						Contribuyente 	
100	\N	2018-05-01						Contribuyente 	
115	\N	2018-05-01						Contribuyente 	
331	\N	\N							
293	\N	\N		p06205305	cofop trami 2018				
358	\N	\N							
193	\N	\N		p06168563					
133	2021-01-31	1972-01-01	p06262783 iasd					Contribuyente	
370	\N	\N		p20073432	cofop.trami.2019				
478	\N	2018-05-01						Contribuyente	
78	\N	\N						Contribuyente 	
353	\N	\N							
368	2024-01-12	\N	p2003318		dueño				
180	2022-03-08	2022-03-08	minuta 					contribuyente	
581	\N	2019-06-02						20190602	
190	\N	1980-05-01						Contribuyente 	
318	\N	2018-05-02						Contribuyente 	AREQUIPA
136	2022-10-26	\N	p06164803						
296	\N	\N		p06172705	Comis.formal cof				
113	\N	\N							
341	\N	\N							
252	\N	2018-04-02		p060124691	dueño			Contribuyente IADS	
197	\N	2018-05-04		p06036020 	Comis.formal cof			Contribuyente 	
308	\N	\N							
324	\N	\N							
68	2022-07-27	\N	p20077148					si	
463	\N	2018-06-01						Contribuyente	
292	2021-01-25	\N	p06154939 IASD						
379	\N	\N							
294	\N	\N							
337	2021-01-19	2021-01-04	p06074009					inscrito IASD	
377	\N	\N							
169	\N	2018-05-03						Contribuyente 	
473	\N	2018-01-02						Contribuyente 	
216	\N	\N							AREQUIPA
290	\N	\N							
142	\N	\N		12016541					
198	\N	2018-04-01		.p06027537	Comis.formal cof			Contribuyente 	Arequipa
141	\N	\N							
59	\N	\N							
143	\N	\N		p06203849	Comis.formal cof				
195	\N	2002-01-01						Contribuyente 	
163	\N	2018-05-01		p06138797 	dueño			contribuyente	AREQUIPA
345	\N	\N							
349	\N	\N		p20001365 	Comis.formal cof				
81	\N	\N							
334	\N	\N							
101	\N	2015-01-01		lote 2=05001944	lote 15=05001955	matriz 05001609		Contribuyente 	
339	\N	2022-07-07		p06162037	Comis.formal cof			contribuyente	
108	\N	2012-09-01				5		Contribuyente 	MOQUEGUA
183	\N	\N		p06076408 	Comis.formal cof				
535	\N	2018-05-01					IASD	Contribuyente	
178	\N	\N							
533	\N	2005-01-01						Contribuyente	
586	\N	2019-06-30						19000630	
140	\N	2022-05-10		P06211098 	Comis.formal cof			contribuyente	tramitar en cofop
223	\N	2018-03-01		p06076834	Comis.formal cof			Contribuyente 	
137	\N	\N							
452	\N	2012-02-01						Contribuyente	
175	\N	\N							
378	\N	\N							
276	\N	\N		p20045914 	Comis.formal cof				
275	\N	\N							
326	\N	\N							
144	\N	\N		p06208856 	Comis.formal cof				
27	\N	2022-05-09						contribuyente	
270	\N	2018-04-01						Contribuyente 	TACNA
568	\N	1990-03-13						19900313	L.c.Q tiene poder re
36	\N	\N							
267	2024-02-20	2024-02-20							TACNA
354	\N	\N							
181	\N	\N							AREQUIPA
241	\N	2018-03-01						Contribuyente 	
588	\N	\N							
92	\N	2018-06-02						Contribuyente 	
372	\N	2023-12-15						004975	
80	\N	\N							
160	\N	2006-01-01		Drea 92080			Drea 92080	Contribuyente 	
323	\N	\N							
548	\N	2018-04-01						Contribuyente	
146	\N	\N							
40	\N	\N							
76	\N	2018-05-03						Contribuyente 	
332	\N	\N							
307	\N	2018-04-02		p20003613	Comis.formal cof			Contribuyente	
493	\N	2017-01-01						Contribuyente	
61	\N	\N		P20005833 cofo					
340	\N	\N							
182	\N	2017-01-01						contribuyente	
134	\N	\N							
338	\N	\N							
51	\N	\N							
89	\N	\N							
130	\N	\N		p06260638	dueño				
85	\N	\N							
455	\N	\N							
503	\N	\N							
391	\N	\N							
407	\N	\N							
512	\N	\N							
429	\N	\N							
516	\N	\N							
520	\N	\N							
402	\N	\N							
425	\N	\N							
519	\N	\N							
513	\N	\N							
411	\N	\N							
517	\N	\N							
406	\N	\N							
417	\N	\N							
383	\N	\N							
551	\N	\N							
514	\N	\N							
515	\N	\N							
561	\N	\N							
446	\N	\N		p20068425 	Comis.formal cof				
487	\N	\N							
472	\N	\N							
447	\N	\N							
284	2021-05-06	2018-04-01	p20027704					Contribuyente	
482	\N	\N							
436	\N	\N							
191	\N	2009-01-01		P06181995 dueño	dueño			Contribuyente 	AREQUIPA
304	\N	\N							
289	\N	\N							
222	\N	\N							
399	\N	\N							
612	\N	\N							
451	\N	\N							
608	\N	\N							
427	\N	\N							
606	\N	\N							
525	\N	\N							
381	\N	\N							
412	\N	\N							
610	2023-09-05	\N	11056213						
528	\N	\N		p06135291	cofopri-				
410	\N	2018-09-01		cofopri p08002776				Contribuyente	
300	\N	2018-05-01		p06114025	Comis.formal cof			Contribuyente 	AREQUIPA
440	\N	\N					cofopri		
110	2002-05-24	2018-08-01	P08007700 				IASD	contribuyente	cofopri
179	2023-04-24	2018-05-01	p06114872		autori autom maje			Contribuyente 	AREQUIPA
428	\N	\N							
454	\N	\N							
604	\N	2023-02-23						90010640001	
611	\N	\N							
518	\N	\N							
605	\N	2023-08-17						0091886	
77	\N	\N		p20046415 cofop					
421	\N	\N							
86	\N	\N		 P06182378	cofop trami 2019				
194	\N	2018-05-11		p06194904		cofop comis form		Contribuyente 	
549	2017-11-20	2017-11-30	p06113985				AEAPS	Contribuyente	
232	\N	\N							
145	\N	\N		p06228334 peru	estado peruano				
563	\N	\N							
567	\N	\N							
382	\N	\N		p20066946 	Comis.formal cof				
438	\N	\N							
453	\N	\N							
333	\N	\N							
600	2022-08-23	\N	p20057255						
404	\N	2022-07-15						contribuyente	
394	\N	\N							
477	\N	\N							
580	\N	\N							
400	\N	\N							
149	\N	\N							
527	\N	\N							
82	\N	\N							
442	\N	\N							
505	\N	\N							
441	\N	\N							
445	\N	\N							
448	\N	\N							
480	\N	\N							
21	2015-11-25	2018-03-01	P06077670				IASD C.U.Cofop	Contribuyente 	Arequipa
553	\N	\N							
607	\N	\N							
306	\N	\N							
305	\N	\N							
403	\N	\N							
39	\N	\N						contribuyente	
474	\N	\N							
328	\N	\N							
479	\N	\N							
291	\N	\N		p06154938	dueño				
107	2009-08-14	2009-11-01	11001636			C0006	IASD	Contribuyente 	MOQUEGUA
357	\N	\N		p20070655 	Comis.formal cof				
389	\N	\N							
602	2022-05-13	\N	11119470						
235	\N	\N							
278	\N	\N		p20044273 	Comis.formal cof				
277	\N	\N							
609	\N	2023-07-14							
303	2011-04-24	2012-01-01	05005856- IASD			987	IASD	Contribuyente 	TACNA
587	\N	2019-07-01						19000701	
185	\N	2018-05-01		p06114024	dueño		majes autonoma	Contribuyente 	Arequipa
14	\N	\N		p06168709	Comis.formal cof				-
401	\N	\N	01161842						Mollendo
311	\N	\N							
138	\N	\N		p06279132 munic	p06279131dueño				
18	2000-12-29	2018-03-01	PO6098122				IASD	contribuyente	
557	\N	\N							
319	2018-11-13	2022-05-05	000122803	IASD				Contribuyente	
419	\N	\N							
57	\N	\N							
422	\N	\N							
423	\N	\N							
529	\N	\N							
164	2014-11-09	2018-05-03	55133339-P06133791-IASD				IASD	Contribuyente 	AREQUIPA
58	\N	\N							
601	2023-03-14	\N	p06182371						
495	\N	2022-06-17						contribuyente	
475	\N	\N							
497	\N	\N							
603	\N	\N							
499	\N	\N		p20051252 	Comis.formal cof				
613	\N	\N							
614	\N	\N							
153	\N	2018-04-01		.p08016892 	Comis.formal cof		Tra.Cof.p08016892	contribuyente	Tacna
617	\N	\N							
618	\N	\N							
620	\N	\N							
615	\N	\N							
616	\N	2023-12-15							
\.


--
-- Data for Name: predios_usos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.predios_usos (id_predio, id_principal, id_tercero, fecha, modo, periodo, pertenece, otros) FROM stdin;
51	149	168	1900-09-01				
134	149	168	1900-10-31				
89	149	168	1900-09-15				
85	149	168	1900-09-10				
87	149	168	1900-09-14				
130	149	168	1900-10-31				
131	149	168	1900-10-31				
157	149	168	1900-11-03				
91	149	168	1999-09-28				
46	149	168	1900-08-31				
48	149	168	1900-09-01				
49	149	168	1900-09-01				
37	168	168	1999-08-03				
139	149	168	1900-10-31				
23	149	168	2014-07-28				
322	149	168	1900-02-22				
259	149	168	1900-11-19				
329	168	168	1990-02-22				
595	149	168	\N				
105	149	168	1900-10-12				
221	149	168	1900-11-16				
64	149	168	1900-09-03				
236	149	168	1900-11-18				
86	149	168	1900-09-14				
133	149	168	1900-10-31				
111	149	168	1900-10-13				
106	149	168	1900-10-12				
140	149	168	1900-10-31				
117	149	168	1900-10-27				
39	149	168	1999-08-04				
88	149	168	1900-09-14				
44	149	168	1900-08-31				
260	149	168	1900-11-19				
75	149	168	1900-09-04				
77	149	168	1900-09-09				
364	149	168	1990-02-22				
308	149	168	1900-12-08				
29	149	168	2014-08-02				
145	149	168	1900-11-03				
132	149	168	1900-10-31				
249	149	168	1900-11-19				
101	149	168	1999-10-10				
183	149	168	1900-11-10				
197	149	168	1900-11-12				
353	149	168	1990-02-22				
74	149	168	1900-09-04				
152	149	168	1900-11-03				
194	149	168	1900-11-11				
61	149	168	1900-09-02				
146	149	168	1900-11-03				
120	149	168	1900-10-27				
30	168	168	1900-08-02				
110	149	168	1900-10-13				
65	153	168	1900-09-03				
59	149	168	1900-09-02				
100	149	168	1999-10-10				
113	149	168	1900-10-13				
71	149	168	1900-09-04				
164	149	168	1900-11-09				
43	149	168	1900-08-31				
42	149	168	1900-08-31				
118	149	168	1900-10-27				
159	149	168	1900-11-06				
119	149	168	1900-10-27				
160	149	168	1900-11-06				
377	149	168	1990-02-22				
135	149	168	1900-10-31				
79	149	168	1900-09-09				
53	149	168	1900-09-01				
114	149	168	1900-10-27				
40	149	168	1999-08-10				
168	149	168	1900-11-09				
90	149	168	1999-09-28				
33	149	168	1999-08-03				
332	149	168	1990-02-22				
73	149	168	1900-09-04				
155	149	168	1900-11-03				
323	149	168	1990-02-22				
138	149	168	1900-10-31				
270	149	168	1900-11-19				
142	149	168	1900-11-02				
198	149	168	1900-11-12				
141	149	168	1900-11-02				
143	149	168	1900-11-02				
41	153	168	1900-08-10				
68	149	168	1900-09-03				
309	149	149	1999-12-11				
76	149	168	1900-09-09				
156	149	168	1900-11-03				
599	149	168	\N				
172	149	168	1900-11-09				
170	149	168	1900-11-09				
171	149	168	1900-11-09				
35	149	168	1999-08-03				
162	149	168	1900-11-07				
331	149	168	1900-02-22				
379	149	168	1990-02-22				
254	149	168	1900-11-19				
165	149	168	1900-11-09				
57	149	168	1900-09-02				
50	149	168	1900-09-01				
163	149	168	1900-11-07				
169	149	168	1900-11-09				
175	149	168	1900-11-10				
177	149	168	1900-11-10				
144	149	168	1900-11-02				
34	149	168	1999-08-03				
78	149	168	1900-09-09				
181	149	168	1900-11-10				
150	149	168	1900-11-03				
82	156	168	1900-09-09				
596	149	168	\N				
69	149	168	1900-09-03				
179	149	168	1900-11-10				
136	149	168	1900-10-31				
36	149	168	1999-08-03				
151	149	168	1900-11-03				
45	149	168	1900-08-31				
115	149	168	1900-10-27				
81	149	168	1900-09-09				
173	149	168	1900-11-09				
80	149	168	1900-09-09				
103	149	168	1999-10-10				
72	149	168	1900-09-04				
108	149	168	1900-10-12				
149	149	168	1900-11-03				
137	149	168	1900-10-31				
47	149	168	1900-08-31				
92	149	168	1999-10-05				
161	149	168	1900-11-06				
52	149	168	1900-09-01				
116	149	168	1900-10-27				
553	149	168	1900-01-30				
55	149	168	1900-09-01				
70	149	168	1900-09-04				
62	149	168	1900-09-02				
102	149	168	1999-10-10				
58	149	168	1900-09-02				
370	149	168	1990-02-22				
153	149	168	1900-11-03				
178	149	168	1900-11-10				
182	149	168	1900-11-10				
597	149	168	\N				
104	149	168	1900-10-12				
359	149	168	1990-02-22				
54	149	168	1900-09-01				
225	149	168	1900-11-16				
330	149	168	1900-02-22				
362	149	168	1990-02-22				
295	149	168	1999-11-29				
237	149	168	1900-11-18				
227	149	168	1900-11-16				
338	149	168	1990-02-22				
288	149	168	1900-10-27				
239	149	168	1900-11-18				
336	149	168	1990-02-22				
314	149	168	1999-12-12				
344	149	168	1990-02-22				
371	149	168	1990-02-22				
346	149	168	1990-02-22				
369	149	168	1990-02-22				
247	149	168	1900-11-19				
361	149	168	1990-02-22				
315	149	168	1999-12-12				
242	149	168	1900-11-18				
287	149	168	1999-11-28				
360	149	168	1990-02-22				
274	149	168	1900-11-19				
297	149	168	1999-11-29				
187	149	168	1900-11-11				
286	149	168	1999-11-28				
347	149	168	1990-02-22				
536	149	168	1900-05-09				
433	149	168	1990-02-22				
526	149	168	1900-11-14				
583	161	161	2019-06-28				
584	161	161	2019-06-28				
585	161	161	2019-06-28				
589	161	161	2019-08-06				
590	161	161	2019-08-16				
591	161	161	2019-08-21				
592	161	161	2019-09-21				
593	161	161	2020-11-26				
455	149	168	1900-03-29				
396	149	168	1990-02-22				
513	149	149	2015-09-17				
507	149	168	1900-09-05				
333	149	168	1990-02-22				
403	149	168	1990-02-22				
326	149	168	1990-02-22				
318	149	168	1999-12-31				
319	149	168	1990-02-22				
186	149	168	1900-11-11				
300	149	154	1999-11-29				
258	149	168	1900-11-19				
358	149	168	1990-02-22				
363	149	168	2016-06-22				
293	149	168	1999-11-29				
368	149	168	1990-02-22				
200	149	168	1900-11-12				
269	149	168	1900-11-19				
560	149	168	2018-05-10				
190	149	168	1900-11-11				
218	149	168	1900-11-16				
354	149	168	1990-02-22				
389	149	168	1990-02-22				
281	149	168	1900-11-19				
222	149	168	1900-11-16				
290	149	168	1999-11-29				
193	149	168	1900-11-11				
302	167	168	1999-12-01				
279	149	168	1900-11-19				
185	154	168	1900-11-10				
305	149	168	1999-12-08				
272	149	168	1900-11-19				
296	149	168	1999-11-29				
216	149	168	1900-11-16				
292	149	168	1999-11-29				
480	149	168	1900-05-14				
252	149	168	1900-11-19				
341	149	168	1990-02-22				
251	149	168	1900-11-19				
345	149	168	1990-02-22				
398	149	168	1990-02-22				
482	149	168	1900-05-14				
267	149	168	1900-11-19				
342	149	168	1990-02-22				
232	149	168	1900-11-17				
324	149	168	1990-02-22				
339	149	168	1990-02-22				
285	149	168	1999-11-28				
268	149	168	1900-11-19				
320	149	168	1990-02-22				
256	149	168	1900-11-19				
248	149	168	1900-11-19				
230	149	168	1900-11-17				
317	160	161	1999-12-25				
304	149	168	1900-12-07				
223	149	168	1900-11-16				
238	149	168	1999-11-18				
196	149	168	1900-11-12				
283	149	168	1900-11-19				
250	149	168	1900-11-19				
533	149	168	1900-05-01				
240	149	168	1900-11-18				
356	149	168	2015-05-30				
273	149	168	1900-11-19				
255	153	168	1900-11-19				
257	149	168	1900-11-19				
306	149	149	1999-12-08				
202	149	168	1900-11-12				
195	153	153	1900-11-11				
350	149	168	1990-02-22				
291	149	168	1999-11-29				
282	149	168	1900-11-19				
189	149	168	1900-11-11				
215	149	168	1900-11-12				
263	149	168	1900-11-19				
188	149	168	1900-11-11				
445	149	168	1990-02-22				
275	149	168	1900-11-19				
504	149	168	1900-05-22				
184	149	168	1900-11-10				
199	149	168	1900-11-12				
454	149	168	1900-03-23				
505	149	168	1900-06-23				
277	149	168	1900-11-19				
357	149	168	1990-02-22				
321	149	168	1990-02-22				
217	149	168	1900-11-16				
301	149	168	1999-11-30				
493	149	168	1900-05-17				
234	149	168	1900-11-18				
372	149	168	1990-02-22				
224	149	168	1900-11-16				
265	149	168	1900-11-19				
266	149	168	1900-11-19				
278	149	168	1900-11-19				
226	149	168	1900-11-16				
334	149	168	1990-02-22				
311	149	168	1900-12-11				
351	149	168	1990-02-22				
294	149	168	1999-11-29				
262	149	168	1900-11-19				
349	149	168	1990-02-22				
467	149	168	1990-04-22				
192	149	168	1900-11-11				
557	149	149	1900-04-29				
219	149	168	1900-11-16				
307	149	168	1999-12-08				
235	149	168	1900-11-18				
548	168	149	2017-07-13				
340	149	168	1990-02-22				
543	159	168	1990-02-07				
487	149	168	1900-05-15				
417	149	168	1990-02-22				
424	149	168	1990-02-22				
514	149	168	1900-10-17				
432	149	168	1990-02-22				
385	149	168	1990-02-22				
515	149	168	1900-10-17				
561	168	161	2018-07-10				
523	149	168	1900-10-19				
545	168	168	1990-03-28				
537	153	168	2016-05-10				
472	149	168	1900-05-01				
374	149	168	1990-02-22				
373	149	168	1990-02-22				
512	149	168	2015-10-09				
437	149	168	1990-02-22				
439	149	168	1990-02-22				
450	149	168	1990-02-22				
520	149	168	1900-10-19				
521	149	168	1900-10-19				
430	149	168	1990-02-22				
431	149	168	1990-02-22				
503	149	168	1900-05-22				
407	149	168	1990-02-22				
397	149	149	1990-02-22				
508	149	168	2015-09-08				
447	149	168	1990-02-22				
402	149	149	1990-02-22				
388	149	168	1990-02-22				
406	149	168	1990-02-22				
509	149	168	1900-10-08				
446	149	168	1990-02-22				
383	149	168	1990-02-22				
551	161	161	2018-02-11				
530	149	149	1990-02-13				
484	149	168	1900-05-15				
420	149	168	1990-02-22				
426	149	168	1990-02-22				
519	149	168	1900-10-17				
387	149	168	1990-02-22				
429	149	168	1990-02-22				
554	149	168	1900-03-30				
411	149	168	1990-02-22				
468	160	149	1900-04-30				
384	149	168	1990-02-22				
418	149	168	1990-02-22				
425	149	168	1990-02-22				
481	149	168	1900-05-14				
6	149	168	\N		-		
22	149	168	\N	Cesion en Uso	-	-	-
517	149	168	\N				
570	161	161	\N				
391	149	168	1990-02-22				
594	161	161	\N				
16	149	168	\N	-	-	-	-
17	149	168	\N	-	-	-	-
15	149	168	\N	-	-	-	-
335	149	168	\N				
410	149	168	1990-02-22				
412	149	168	1990-02-22				
378	149	168	1990-02-22				
419	149	168	1990-02-22				
409	168	149	1990-02-22				
588	161	161	\N				
28	149	168	\N				
463	149	168	2015-04-04				
376	149	168	1990-02-22				
567	149	168	\N				
522	149	149	2015-10-19				
569	149	168	2019-03-16				
477	152	168	1900-05-11				
7	149	168	\N		-		
499	149	168	1900-05-17				
478	149	168	1900-05-13				
442	149	168	1990-02-22				
458	154	168	1994-06-14				
18	149	168	\N	-	-	-	-
413	149	168	1990-02-22				
428	149	168	1990-02-22				
32	149	168	\N				
12	149	168	\N	-	-	-	-
479	149	168	1900-05-14				
527	149	168	1900-11-14				
401	149	168	1990-02-22				
25	168	168	\N				
524	149	168	1900-10-21				
289	149	168	\N				
393	149	168	1990-02-22				
355	149	168	1990-02-22				
298	149	168	1999-11-29				
408	149	168	1990-02-22				
414	149	168	1990-02-22				
464	159	168	\N				
405	149	168	1990-02-22				
441	149	168	1990-02-22				
495	149	168	1900-05-17				
496	149	149	1900-05-17				
460	154	161	1990-04-03				
525	149	168	2015-10-21				
241	149	168	1999-11-18				
14	149	168	\N	-	-	-	-
534	156	168	2016-05-05				
5	149	168	\N		-	-	-
473	149	168	1900-05-11				
436	149	168	1990-02-22				
581	149	168	2019-06-02				
586	161	161	2019-06-30				
394	149	168	1990-02-22				
174	149	168	\N				
129	149	168	\N				
440	149	168	1990-02-22				
24	149	168	\N				
392	149	168	1990-02-22				
580	149	168	1900-11-19				
453	149	168	1990-02-22				
375	149	168	1990-02-22				
352	149	168	1990-02-22				
1	160	168	\N				
13	149	168	\N	-	-	-	-
26	149	168	\N				
421	149	168	1990-02-22				
10	149	168	\N	-	-	-	-
2	149	168	\N				
21	149	168	\N	-			-
528	149	168	1900-12-18				
9	149	168	\N	-	-	-	-
587	161	161	2019-07-01				
382	149	168	1990-02-22				
448	149	168	1990-02-22				
3	149	168	\N		-		
452	149	168	1990-02-22				
399	149	168	1990-02-22				
538	159	150	2016-02-29				
27	168	168	\N				
381	149	168	1990-02-22				
438	149	168	1990-02-22				
451	149	168	1990-02-22				
400	149	168	1990-02-22				
261	149	168	1900-11-19				
427	149	168	1990-02-22				
4	149	168	\N		-		
19	149	168	\N	-	-	-	-
506	149	168	1900-07-04				
422	149	168	1990-02-22				
423	149	168	1990-02-22				
529	149	161	\N				
568	149	168	1900-03-13				
475	149	168	1900-05-11				
497	149	168	1900-05-17				
474	149	168	1900-05-11				
516	149	168	\N				
343	149	168	1990-02-22				
284	149	168	1999-11-28				
337	149	168	1900-02-22				
616	149	168	\N				
549	159	168	2017-11-26				
612	149	168	\N				
60	149	168	1900-09-02				
609	149	168	\N				
614	149	168	\N				
518	149	168	\N				
303	159	159	2011-03-30	comodato	20015	Asoc.educativa Adventista Peruana del Sur	Educacion Inicial Primaria Segundaria
556	149	168	2018-04-20				
608	168	149	\N				
325	149	168	1900-02-22				
605	149	149	\N				
310	149	168	1999-12-11				
617	149	168	\N				
618	161	161	\N				
604	149	168	\N				
328	149	168	1990-02-22				
606	149	168	\N				
611	149	168	\N				
603	149	149	\N				
109	154	154	2015-10-13	Comodato		Asoc.educativa Adventista Peruana del Sur	
107	150	150	1999-10-12	 comodato		a la asociacion Educativa Peruana Del Sur	
233	149	168	1900-11-18				
563	149	168	2018-10-13				
66	154	154	2014-09-03	Comodato		Asoc.educativa Adventista Peruana del Sur	
180	149	168	1900-11-10				
276	149	168	1900-11-19				
158	149	168	1900-11-06				
112	153	168	1900-10-13				
8	149	168	\N	-	-	-	-
620	149	149	\N				
280	149	168	1900-11-19				
67	149	168	1900-09-03				
613	149	168	\N				
607	149	168	\N				
600	149	168	\N				
535	149	168	2016-05-06				
404	149	149	2016-07-18				
191	149	168	1900-11-11				
610	149	168	\N				
615	149	168	\N				
601	149	149	\N				
555	149	168	2018-04-14				
602	149	168	\N				
\.


--
-- Data for Name: sis_ubigeo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sis_ubigeo (id, codigo, nombre, tipo, id_padre, estado, sysuser, sysfecha) FROM stdin;
1208	0102	CORONGO	1	12	1	1	2020-08-26 09:02:55.472307
1209	0102	HUARAZ	1	12	1	1	2020-08-26 09:02:55.472307
1210	0102	HUARI	1	12	1	1	2020-08-26 09:02:55.472307
1211	0102	HUARMEY	1	12	1	1	2020-08-26 09:02:55.472307
1212	0102	HUAYLAS	1	12	1	1	2020-08-26 09:02:55.472307
1213	0102	MCAL. LUZURIAGA	1	12	1	1	2020-08-26 09:02:55.472307
1214	0102	OCROS	1	12	1	1	2020-08-26 09:02:55.472307
1215	0102	PALLASCA	1	12	1	1	2020-08-26 09:02:55.472307
1216	0102	POMABAMBA	1	12	1	1	2020-08-26 09:02:55.472307
1217	0102	RECUAY	1	12	1	1	2020-08-26 09:02:55.472307
1218	0102	SANTA	1	12	1	1	2020-08-26 09:02:55.472307
1219	0102	SIHUAS	1	12	1	1	2020-08-26 09:02:55.472307
1220	0102	YUNGAY	1	12	1	1	2020-08-26 09:02:55.472307
1301	0102	ABANCAY	1	13	1	1	2020-08-26 09:02:55.472307
1302	0102	ANDAHUAYLAS	1	13	1	1	2020-08-26 09:02:55.472307
1303	0102	ANTABAMBA	1	13	1	1	2020-08-26 09:02:55.472307
1304	0102	AYMARAES	1	13	1	1	2020-08-26 09:02:55.472307
1305	0102	COTABAMBAS	1	13	1	1	2020-08-26 09:02:55.472307
1306	0102	CHINCHEROS	1	13	1	1	2020-08-26 09:02:55.472307
1307	0102	GRAU	1	13	1	1	2020-08-26 09:02:55.472307
1807	0102	CUSCO	1	18	1	1	2020-08-26 09:02:55.472307
1808	0102	ESPINAR	1	18	1	1	2020-08-26 09:02:55.472307
1809	0102	LA CONVENCIÓN	1	18	1	1	2020-08-26 09:02:55.472307
1810	0102	PARURO	1	18	1	1	2020-08-26 09:02:55.472307
1811	0102	PAUCARTAMBO	1	18	1	1	2020-08-26 09:02:55.472307
1812	0102	QUISPICANCHIS	1	18	1	1	2020-08-26 09:02:55.472307
1813	0102	URUBAMBA	1	18	1	1	2020-08-26 09:02:55.472307
2303	0102	CHEPÉN	1	23	1	1	2020-08-26 09:02:55.472307
2304	0102	GRAN CHIMÚ	1	23	1	1	2020-08-26 09:02:55.472307
2305	0102	JULCÁN	1	23	1	1	2020-08-26 09:02:55.472307
2306	0102	OTUZCO	1	23	1	1	2020-08-26 09:02:55.472307
2307	0102	PACASMAYO	1	23	1	1	2020-08-26 09:02:55.472307
2308	0102	PATAZ	1	23	1	1	2020-08-26 09:02:55.472307
2309	0102	SÁNCHEZ CARRIÓN	1	23	1	1	2020-08-26 09:02:55.472307
2310	0102	SANTIAGO DE CHUCO	1	23	1	1	2020-08-26 09:02:55.472307
2311	0102	TRUJILLO	1	23	1	1	2020-08-26 09:02:55.472307
2312	0102	VIRÚ	1	23	1	1	2020-08-26 09:02:55.472307
140117	0102	SABANDIA	1	1401	1	1	2020-08-26 09:02:55.472307
140118	0102	SACHACA	1	1401	1	1	2020-08-26 09:02:55.472307
140119	0102	SAN JUAN DE SIGUAS	1	1401	1	1	2020-08-26 09:02:55.472307
140120	0102	SAN JUAN DE TARUCANI	1	1401	1	1	2020-08-26 09:02:55.472307
140121	0102	SANTA ISABEL DE SIGUAS	1	1401	1	1	2020-08-26 09:02:55.472307
140122	0102	SANTA RITA DE SIGUAS	1	1401	1	1	2020-08-26 09:02:55.472307
140123	0102	SOCABAYA	1	1401	1	1	2020-08-26 09:02:55.472307
140124	0102	TIABAYA	1	1401	1	1	2020-08-26 09:02:55.472307
140125	0102	UCHUMAYO	1	1401	1	1	2020-08-26 09:02:55.472307
140126	0102	VITOR	1	1401	1	1	2020-08-26 09:02:55.472307
140127	0102	YANAHUARA	1	1401	1	1	2020-08-26 09:02:55.472307
140128	0102	YARABAMBA	1	1401	1	1	2020-08-26 09:02:55.472307
140129	0102	YURA	1	1401	1	1	2020-08-26 09:02:55.472307
140101	0102	ALTO SELVA ALEGRE	1	1401	1	1	2020-08-26 09:02:55.472307
140102	0102	AREQUIPA	1	1401	1	1	2020-08-26 09:02:55.472307
20	0102	HUÁNUCO	1	0	0	1	2020-08-26 09:02:55.472307
110101	0102	ARAMANGO	1	1101	1	1	2020-08-26 09:02:55.472307
110102	0102	BAGUA	1	1101	1	1	2020-08-26 09:02:55.472307
110103	0102	COPALLIN	1	1101	1	1	2020-08-26 09:02:55.472307
110104	0102	EL PARCO	1	1101	1	1	2020-08-26 09:02:55.472307
110105	0102	IMAZA	1	1101	1	1	2020-08-26 09:02:55.472307
110106	0102	LA PECA	1	1101	1	1	2020-08-26 09:02:55.472307
110201	0102	JUMBILLA	1	1102	1	1	2020-08-26 09:02:55.472307
110202	0102	CHISQUILLA	1	1102	1	1	2020-08-26 09:02:55.472307
110203	0102	CHURUJA	1	1102	1	1	2020-08-26 09:02:55.472307
110204	0102	COROSHA	1	1102	1	1	2020-08-26 09:02:55.472307
2508	0102	OYÓN	1	25	1	1	2020-08-26 09:02:55.472307
2509	0102	SAN VICENTE DE CAÑETE	1	25	1	1	2020-08-26 09:02:55.472307
2510	0102	YAUYOS	1	25	1	1	2020-08-26 09:02:55.472307
2607	0102	DATEM DEL MARAÑON	1	26	1	1	2020-08-26 09:02:55.472307
3111	0102	SAN ROMAN	1	31	1	1	2020-08-26 09:02:55.472307
3112	0102	SANDIA	1	31	1	1	2020-08-26 09:02:55.472307
3113	0102	YUNGUYO	1	31	1	1	2020-08-26 09:02:55.472307
21	0102	ICA	1	0	0	1	2020-08-26 09:02:55.472307
22	0102	JUNIN	1	0	0	1	2020-08-26 09:02:55.472307
23	0102	LA LIBERTAD	1	0	0	1	2020-08-26 09:02:55.472307
24	0102	LAMBAYEQUE	1	0	0	1	2020-08-26 09:02:55.472307
25	0102	LIMA	1	0	0	1	2020-08-26 09:02:55.472307
26	0102	LORETO	1	0	0	1	2020-08-26 09:02:55.472307
27	0102	MADRE DE DIOS	1	0	0	1	2020-08-26 09:02:55.472307
28	0102	MOQUEGUA	1	0	1	1	2020-08-26 09:02:55.472307
29	0102	PASCO	1	0	0	1	2020-08-26 09:02:55.472307
30	0102	PIURA	1	0	0	1	2020-08-26 09:02:55.472307
31	0102	PUNO	1	0	0	1	2020-08-26 09:02:55.472307
32	0102	SAN MARTIN	1	0	0	1	2020-08-26 09:02:55.472307
33	0102	TACNA	1	0	1	1	2020-08-26 09:02:55.472307
34	0102	TUMBES	1	0	0	1	2020-08-26 09:02:55.472307
35	0102	UCAYALI	1	0	0	1	2020-08-26 09:02:55.472307
36	0102	OTROS	1	0	1	1	2020-08-26 09:02:55.472307
140103	0102	CAYMA	1	1401	1	1	2020-08-26 09:02:55.472307
140104	0102	CERRO COLORADO	1	1401	1	1	2020-08-26 09:02:55.472307
140105	0102	CHARACATO	1	1401	1	1	2020-08-26 09:02:55.472307
140106	0102	CHIGUATA	1	1401	1	1	2020-08-26 09:02:55.472307
140107	0102	JACOBO DIXON HUNTER	1	1401	1	1	2020-08-26 09:02:55.472307
140108	0102	JOSE LUIS BUSTAMANTE Y RIVERO	1	1401	1	1	2020-08-26 09:02:55.472307
140109	0102	LA JOYA	1	1401	1	1	2020-08-26 09:02:55.472307
140110	0102	MARIANO MELGAR	1	1401	1	1	2020-08-26 09:02:55.472307
140111	0102	MIRAFLORES	1	1401	1	1	2020-08-26 09:02:55.472307
140112	0102	MOLLEBAYA	1	1401	1	1	2020-08-26 09:02:55.472307
140113	0102	PAUCARPATA	1	1401	1	1	2020-08-26 09:02:55.472307
140114	0102	POCSI	1	1401	1	1	2020-08-26 09:02:55.472307
140115	0102	POLOBAYA	1	1401	1	1	2020-08-26 09:02:55.472307
140116	0102	QUEQUEÑA	1	1401	1	1	2020-08-26 09:02:55.472307
1401	0102	AREQUIPA	1	14	1	1	2020-08-26 09:02:55.472307
1402	0102	CAMANA	1	14	1	1	2020-08-26 09:02:55.472307
1403	0102	CARAVELI	1	14	1	1	2020-08-26 09:02:55.472307
1404	0102	CASTILLA	1	14	1	1	2020-08-26 09:02:55.472307
1405	0102	CAYLLOMA	1	14	1	1	2020-08-26 09:02:55.472307
1406	0102	CONDESUYOS	1	14	1	1	2020-08-26 09:02:55.472307
1407	0102	ISLAY	1	14	1	1	2020-08-26 09:02:55.472307
1408	0102	LA UNION	1	14	1	1	2020-08-26 09:02:55.472307
1501	0102	CANGALLO	1	15	1	1	2020-08-26 09:02:55.472307
1502	0102	HUAMANGA	1	15	1	1	2020-08-26 09:02:55.472307
1503	0102	HUANCA SANCOS	1	15	1	1	2020-08-26 09:02:55.472307
1504	0102	HUANTA	1	15	1	1	2020-08-26 09:02:55.472307
1505	0102	LA MAR	1	15	1	1	2020-08-26 09:02:55.472307
1506	0102	LUCANAS	1	15	1	1	2020-08-26 09:02:55.472307
1507	0102	PARINACOCHAS	1	15	1	1	2020-08-26 09:02:55.472307
1508	0102	PAUCAR DEL SARA SARA	1	15	1	1	2020-08-26 09:02:55.472307
1509	0102	SUCRE	1	15	1	1	2020-08-26 09:02:55.472307
1510	0102	VICTOR FAJARDO	1	15	1	1	2020-08-26 09:02:55.472307
1511	0102	VILCAS HUAMÁN	1	15	1	1	2020-08-26 09:02:55.472307
1601	0102	CAJABAMBA	1	16	1	1	2020-08-26 09:02:55.472307
1602	0102	CAJAMARCA	1	16	1	1	2020-08-26 09:02:55.472307
1603	0102	CELENDÍN	1	16	1	1	2020-08-26 09:02:55.472307
1604	0102	CHOTA	1	16	1	1	2020-08-26 09:02:55.472307
1605	0102	CONTUMAZA	1	16	1	1	2020-08-26 09:02:55.472307
1606	0102	CUTERVO	1	16	1	1	2020-08-26 09:02:55.472307
1607	0102	HUALGAYOC	1	16	1	1	2020-08-26 09:02:55.472307
1608	0102	JAÉN	1	16	1	1	2020-08-26 09:02:55.472307
1609	0102	SAN IGNACIO	1	16	1	1	2020-08-26 09:02:55.472307
1610	0102	SAN MARCOS	1	16	1	1	2020-08-26 09:02:55.472307
1611	0102	SAN MIGUEL	1	16	1	1	2020-08-26 09:02:55.472307
1612	0102	SAN PABLO	1	16	1	1	2020-08-26 09:02:55.472307
1613	0102	SANTA CRUZ	1	16	1	1	2020-08-26 09:02:55.472307
1701	0102	CALLAO	1	17	1	1	2020-08-26 09:02:55.472307
1801	0102	ACOMAYO	1	18	1	1	2020-08-26 09:02:55.472307
1802	0102	ANTA	1	18	1	1	2020-08-26 09:02:55.472307
1803	0102	CALCA	1	18	1	1	2020-08-26 09:02:55.472307
1804	0102	CANAS	1	18	1	1	2020-08-26 09:02:55.472307
1101	0102	BAGUA	1	11	1	1	2020-08-26 09:02:55.472307
1102	0102	BONGARÁ	1	11	1	1	2020-08-26 09:02:55.472307
1103	0102	CHACHAPOYAS	1	11	1	1	2020-08-26 09:02:55.472307
1104	0102	CONDORCANQUI	1	11	1	1	2020-08-26 09:02:55.472307
1105	0102	LUYA	1	11	1	1	2020-08-26 09:02:55.472307
1106	0102	RODRIGUEZ DE MENDOZA	1	11	1	1	2020-08-26 09:02:55.472307
1107	0102	UTCUBAMBA	1	11	1	1	2020-08-26 09:02:55.472307
1201	0102	AIJA	1	12	1	1	2020-08-26 09:02:55.472307
1202	0102	ANTONIO RAIMONDI	1	12	1	1	2020-08-26 09:02:55.472307
1203	0102	ASUNCION	1	12	1	1	2020-08-26 09:02:55.472307
1204	0102	BOLOGNESI	1	12	1	1	2020-08-26 09:02:55.472307
1205	0102	CARHUAZ	1	12	1	1	2020-08-26 09:02:55.472307
1206	0102	CARLOS F. FITZCARRALD	1	12	1	1	2020-08-26 09:02:55.472307
1207	0102	CASMA	1	12	1	1	2020-08-26 09:02:55.472307
1805	0102	CANCHIS	1	18	1	1	2020-08-26 09:02:55.472307
1806	0102	CHUMBIVILCAS	1	18	1	1	2020-08-26 09:02:55.472307
1901	0102	ACOBAMBA	1	19	1	1	2020-08-26 09:02:55.472307
1902	0102	ANGARAES	1	19	1	1	2020-08-26 09:02:55.472307
1903	0102	CASTROVIRREYNA	1	19	1	1	2020-08-26 09:02:55.472307
1904	0102	CHURCAMPA	1	19	1	1	2020-08-26 09:02:55.472307
1905	0102	HUANCAVELICA	1	19	1	1	2020-08-26 09:02:55.472307
1906	0102	HUAYTARÁ	1	19	1	1	2020-08-26 09:02:55.472307
1907	0102	TAYACAJA	1	19	1	1	2020-08-26 09:02:55.472307
2001	0102	AMBO	1	20	1	1	2020-08-26 09:02:55.472307
2002	0102	DOS DE MAYO	1	20	1	1	2020-08-26 09:02:55.472307
2003	0102	HUACAYBAMBA	1	20	1	1	2020-08-26 09:02:55.472307
2004	0102	HUAMALÍES	1	20	1	1	2020-08-26 09:02:55.472307
2005	0102	HUÁNUCO	1	20	1	1	2020-08-26 09:02:55.472307
2006	0102	LAURICOCHA	1	20	1	1	2020-08-26 09:02:55.472307
2007	0102	LEONCIO PRADO	1	20	1	1	2020-08-26 09:02:55.472307
2008	0102	MARAÑÓN	1	20	1	1	2020-08-26 09:02:55.472307
2009	0102	PACHITEA	1	20	1	1	2020-08-26 09:02:55.472307
2010	0102	PUERTO INCA	1	20	1	1	2020-08-26 09:02:55.472307
2011	0102	YAROWILCA	1	20	1	1	2020-08-26 09:02:55.472307
2101	0102	CHINCHA	1	21	1	1	2020-08-26 09:02:55.472307
2102	0102	ICA	1	21	1	1	2020-08-26 09:02:55.472307
2103	0102	NAZCA	1	21	1	1	2020-08-26 09:02:55.472307
2104	0102	PALPA	1	21	1	1	2020-08-26 09:02:55.472307
2105	0102	PISCO	1	21	1	1	2020-08-26 09:02:55.472307
2201	0102	CHANCHAMAYO	1	22	1	1	2020-08-26 09:02:55.472307
2202	0102	CHUPACA	1	22	1	1	2020-08-26 09:02:55.472307
2203	0102	CONCEPCIÓN	1	22	1	1	2020-08-26 09:02:55.472307
2204	0102	HUANCAYO	1	22	1	1	2020-08-26 09:02:55.472307
2205	0102	JAUJA	1	22	1	1	2020-08-26 09:02:55.472307
2206	0102	JUNIN	1	22	1	1	2020-08-26 09:02:55.472307
2207	0102	SATIPO	1	22	1	1	2020-08-26 09:02:55.472307
2208	0102	TARMA	1	22	1	1	2020-08-26 09:02:55.472307
2209	0102	YAULI	1	22	1	1	2020-08-26 09:02:55.472307
2301	0102	ASCOPE	1	23	1	1	2020-08-26 09:02:55.472307
2302	0102	BOLIVAR	1	23	1	1	2020-08-26 09:02:55.472307
110205	0102	CUISPES	1	1102	1	1	2020-08-26 09:02:55.472307
110206	0102	FLORIDA	1	1102	1	1	2020-08-26 09:02:55.472307
110207	0102	JAZAN	1	1102	1	1	2020-08-26 09:02:55.472307
110208	0102	RECTA	1	1102	1	1	2020-08-26 09:02:55.472307
110209	0102	SAN CARLOS	1	1102	1	1	2020-08-26 09:02:55.472307
110210	0102	SHIPASBAMBA	1	1102	1	1	2020-08-26 09:02:55.472307
110211	0102	VALERA	1	1102	1	1	2020-08-26 09:02:55.472307
110212	0102	YAMBRASBAMBA	1	1102	1	1	2020-08-26 09:02:55.472307
110301	0102	CHACHAPOYAS	1	1103	1	1	2020-08-26 09:02:55.472307
110302	0102	ASUNCION	1	1103	1	1	2020-08-26 09:02:55.472307
110303	0102	BALSAS	1	1103	1	1	2020-08-26 09:02:55.472307
110304	0102	CHETO	1	1103	1	1	2020-08-26 09:02:55.472307
110305	0102	CHIQUILIN	1	1103	1	1	2020-08-26 09:02:55.472307
110306	0102	CHUQUIBAMBA	1	1103	1	1	2020-08-26 09:02:55.472307
110307	0102	GRANADA	1	1103	1	1	2020-08-26 09:02:55.472307
110308	0102	HUANCAS	1	1103	1	1	2020-08-26 09:02:55.472307
110309	0102	LA JALCA	1	1103	1	1	2020-08-26 09:02:55.472307
110310	0102	LEIMEBAMBA	1	1103	1	1	2020-08-26 09:02:55.472307
110311	0102	LEVANTO	1	1103	1	1	2020-08-26 09:02:55.472307
110312	0102	MAGDALENA	1	1103	1	1	2020-08-26 09:02:55.472307
110313	0102	MCAL. CASTILLA	1	1103	1	1	2020-08-26 09:02:55.472307
110314	0102	MOLINOPAMPA	1	1103	1	1	2020-08-26 09:02:55.472307
110315	0102	MONTEVIDEO	1	1103	1	1	2020-08-26 09:02:55.472307
110316	0102	OLLEROS	1	1103	1	1	2020-08-26 09:02:55.472307
110317	0102	QUINJALCA	1	1103	1	1	2020-08-26 09:02:55.472307
110318	0102	SAN FRANCISCO DE DAGUAS	1	1103	1	1	2020-08-26 09:02:55.472307
2401	0102	CHICLAYO	1	24	1	1	2020-08-26 09:02:55.472307
2402	0102	FERREÑAFE	1	24	1	1	2020-08-26 09:02:55.472307
2403	0102	LAMBAYEQUE	1	24	1	1	2020-08-26 09:02:55.472307
2501	0102	BARRANCA	1	25	1	1	2020-08-26 09:02:55.472307
2502	0102	CAJATAMBO	1	25	1	1	2020-08-26 09:02:55.472307
2503	0102	CANTA	1	25	1	1	2020-08-26 09:02:55.472307
2504	0102	HUARAL	1	25	1	1	2020-08-26 09:02:55.472307
2505	0102	HUAROCHIRÍ	1	25	1	1	2020-08-26 09:02:55.472307
2506	0102	HUAURA	1	25	1	1	2020-08-26 09:02:55.472307
2507	0102	LIMA	1	25	1	1	2020-08-26 09:02:55.472307
2601	0102	ALTO AMAZONAS	1	26	1	1	2020-08-26 09:02:55.472307
2602	0102	LORETO	1	26	1	1	2020-08-26 09:02:55.472307
2603	0102	MARISCAL RAMON CASTILLA	1	26	1	1	2020-08-26 09:02:55.472307
2604	0102	MAYNAS	1	26	1	1	2020-08-26 09:02:55.472307
2605	0102	REQUENA	1	26	1	1	2020-08-26 09:02:55.472307
2606	0102	UCAYALI	1	26	1	1	2020-08-26 09:02:55.472307
2801	0102	GENERAL SANCHEZ CERRO	1	28	1	1	2020-08-26 09:02:55.472307
2701	0102	TAHUAMANU	1	27	1	1	2020-08-26 09:02:55.472307
2702	0102	MANU	1	27	1	1	2020-08-26 09:02:55.472307
2703	0102	TAMBOPATA	1	27	1	1	2020-08-26 09:02:55.472307
2802	0102	ILO	1	28	1	1	2020-08-26 09:02:55.472307
2803	0102	MARISCAL NIETO	1	28	1	1	2020-08-26 09:02:55.472307
2901	0102	DANIEL ALCIDES CARRION	1	29	1	1	2020-08-26 09:02:55.472307
2902	0102	OXAPAMPA	1	29	1	1	2020-08-26 09:02:55.472307
2903	0102	PASCO	1	29	1	1	2020-08-26 09:02:55.472307
3001	0102	AYABACA	1	30	1	1	2020-08-26 09:02:55.472307
3002	0102	HUANCABAMBA	1	30	1	1	2020-08-26 09:02:55.472307
3003	0102	MORROPON	1	30	1	1	2020-08-26 09:02:55.472307
3004	0102	PAITA	1	30	1	1	2020-08-26 09:02:55.472307
3005	0102	PIURA	1	30	1	1	2020-08-26 09:02:55.472307
3006	0102	SECHURA	1	30	1	1	2020-08-26 09:02:55.472307
3007	0102	SULLANA	1	30	1	1	2020-08-26 09:02:55.472307
3008	0102	TALARA	1	30	1	1	2020-08-26 09:02:55.472307
3101	0102	AZANGARO	1	31	1	1	2020-08-26 09:02:55.472307
3102	0102	CARABAYA	1	31	1	1	2020-08-26 09:02:55.472307
3103	0102	CHUCUITO	1	31	1	1	2020-08-26 09:02:55.472307
3104	0102	EL COLLAO	1	31	1	1	2020-08-26 09:02:55.472307
3105	0102	HUANCANE	1	31	1	1	2020-08-26 09:02:55.472307
3106	0102	LAMPA	1	31	1	1	2020-08-26 09:02:55.472307
3107	0102	MELGAR	1	31	1	1	2020-08-26 09:02:55.472307
3108	0102	MOHO	1	31	1	1	2020-08-26 09:02:55.472307
3109	0102	PUNO	1	31	1	1	2020-08-26 09:02:55.472307
3110	0102	SAN ANTONIO DE PUTINA	1	31	1	1	2020-08-26 09:02:55.472307
3201	0102	BELLAVISTA	1	32	1	1	2020-08-26 09:02:55.472307
3202	0102	EL DORADO	1	32	1	1	2020-08-26 09:02:55.472307
3203	0102	HUALLAGA	1	32	1	1	2020-08-26 09:02:55.472307
3204	0102	LAMAS	1	32	1	1	2020-08-26 09:02:55.472307
3205	0102	MARISCAL CACERES	1	32	1	1	2020-08-26 09:02:55.472307
3206	0102	MOYOBAMBA	1	32	1	1	2020-08-26 09:02:55.472307
3207	0102	PICOTA	1	32	1	1	2020-08-26 09:02:55.472307
3208	0102	RIOJA	1	32	1	1	2020-08-26 09:02:55.472307
3209	0102	SAN MARTIN	1	32	1	1	2020-08-26 09:02:55.472307
3210	0102	TOCACHE	1	32	1	1	2020-08-26 09:02:55.472307
3301	0102	CANDARAVE	1	33	1	1	2020-08-26 09:02:55.472307
3302	0102	JORGE BASADRE	1	33	1	1	2020-08-26 09:02:55.472307
3303	0102	TACNA	1	33	1	1	2020-08-26 09:02:55.472307
3304	0102	TARATA	1	33	1	1	2020-08-26 09:02:55.472307
3401	0102	CONTRALMIRANTE VILLAR	1	34	1	1	2020-08-26 09:02:55.472307
3402	0102	TUMBES	1	34	1	1	2020-08-26 09:02:55.472307
3403	0102	ZARUMILLA	1	34	1	1	2020-08-26 09:02:55.472307
3501	0102	ATALAYA	1	35	1	1	2020-08-26 09:02:55.472307
3502	0102	CORONEL PORTILLO	1	35	1	1	2020-08-26 09:02:55.472307
3503	0102	PADRE ABAD	1	35	1	1	2020-08-26 09:02:55.472307
3504	0102	PURUS	1	35	1	1	2020-08-26 09:02:55.472307
3601	0102	EXTRANJERO	1	36	1	1	2020-08-26 09:02:55.472307
110319	0102	SAN ISIDRO DE MAINO	1	1103	1	1	2020-08-26 09:02:55.472307
110320	0102	SOLOCO	1	1103	1	1	2020-08-26 09:02:55.472307
110321	0102	SONCHE	1	1103	1	1	2020-08-26 09:02:55.472307
110401	0102	SANTA MARIA DE NIEVA	1	1104	1	1	2020-08-26 09:02:55.472307
110402	0102	EL CENEPA	1	1104	1	1	2020-08-26 09:02:55.472307
110403	0102	RIO SANTIAGO	1	1104	1	1	2020-08-26 09:02:55.472307
110501	0102	LAMUD	1	1105	1	1	2020-08-26 09:02:55.472307
110502	0102	CAMPORREDONDO	1	1105	1	1	2020-08-26 09:02:55.472307
110503	0102	COCABAMBA	1	1105	1	1	2020-08-26 09:02:55.472307
110504	0102	COLCAMAR	1	1105	1	1	2020-08-26 09:02:55.472307
110505	0102	CONILA	1	1105	1	1	2020-08-26 09:02:55.472307
110506	0102	INGUILPATA	1	1105	1	1	2020-08-26 09:02:55.472307
110507	0102	LONGUITA	1	1105	1	1	2020-08-26 09:02:55.472307
110508	0102	LONYA CHICO	1	1105	1	1	2020-08-26 09:02:55.472307
110509	0102	LUYA	1	1105	1	1	2020-08-26 09:02:55.472307
110510	0102	LUYA VIEJO	1	1105	1	1	2020-08-26 09:02:55.472307
110511	0102	MARIA	1	1105	1	1	2020-08-26 09:02:55.472307
110512	0102	OCALLI	1	1105	1	1	2020-08-26 09:02:55.472307
110513	0102	OCUMAL	1	1105	1	1	2020-08-26 09:02:55.472307
110514	0102	PISUQUIA	1	1105	1	1	2020-08-26 09:02:55.472307
110515	0102	PROVIDENCIA	1	1105	1	1	2020-08-26 09:02:55.472307
110516	0102	SAN CRISTOBAL	1	1105	1	1	2020-08-26 09:02:55.472307
110517	0102	SAN FRANCISCO DEL YESO	1	1105	1	1	2020-08-26 09:02:55.472307
110518	0102	SAN JERONIMO	1	1105	1	1	2020-08-26 09:02:55.472307
110519	0102	SAN JUAN DE LOPECANCHA	1	1105	1	1	2020-08-26 09:02:55.472307
110520	0102	SANTA CATALINA	1	1105	1	1	2020-08-26 09:02:55.472307
110521	0102	SANTO TOMAS	1	1105	1	1	2020-08-26 09:02:55.472307
110522	0102	TINGO	1	1105	1	1	2020-08-26 09:02:55.472307
110523	0102	TRITA	1	1105	1	1	2020-08-26 09:02:55.472307
110601	0102	SAN NICOLAS	1	1106	1	1	2020-08-26 09:02:55.472307
110602	0102	CHIRIMOTO	1	1106	1	1	2020-08-26 09:02:55.472307
110603	0102	COCHAMAL	1	1106	1	1	2020-08-26 09:02:55.472307
110604	0102	HUAMBO	1	1106	1	1	2020-08-26 09:02:55.472307
110605	0102	LIMABAMBA	1	1106	1	1	2020-08-26 09:02:55.472307
110606	0102	LONGAR	1	1106	1	1	2020-08-26 09:02:55.472307
110607	0102	MARISCAL BENAVIDES	1	1106	1	1	2020-08-26 09:02:55.472307
110608	0102	MILPUC	1	1106	1	1	2020-08-26 09:02:55.472307
110609	0102	OMIA	1	1106	1	1	2020-08-26 09:02:55.472307
110610	0102	SANTA ROSA	1	1106	1	1	2020-08-26 09:02:55.472307
110611	0102	TOTORA	1	1106	1	1	2020-08-26 09:02:55.472307
110612	0102	VISTA ALEGRE	1	1106	1	1	2020-08-26 09:02:55.472307
110701	0102	BAGUA GRANDE	1	1107	1	1	2020-08-26 09:02:55.472307
110702	0102	CAJARURO	1	1107	1	1	2020-08-26 09:02:55.472307
110703	0102	CUMBA	1	1107	1	1	2020-08-26 09:02:55.472307
110704	0102	EL MILAGRO	1	1107	1	1	2020-08-26 09:02:55.472307
110705	0102	JAMALCA	1	1107	1	1	2020-08-26 09:02:55.472307
110706	0102	LONYA GRANDE	1	1107	1	1	2020-08-26 09:02:55.472307
110707	0102	YAMON	1	1107	1	1	2020-08-26 09:02:55.472307
120101	0102	AIJA	1	1201	1	1	2020-08-26 09:02:55.472307
120102	0102	CORTIS	1	1201	1	1	2020-08-26 09:02:55.472307
120103	0102	HUACLLAN	1	1201	1	1	2020-08-26 09:02:55.472307
120104	0102	LA MERCED	1	1201	1	1	2020-08-26 09:02:55.472307
120105	0102	SUCCHA	1	1201	1	1	2020-08-26 09:02:55.472307
120201	0102	ACZO	1	1202	1	1	2020-08-26 09:02:55.472307
120202	0102	CHACCHO	1	1202	1	1	2020-08-26 09:02:55.472307
120203	0102	CHINGAS	1	1202	1	1	2020-08-26 09:02:55.472307
120204	0102	LLAMELLIN	1	1202	1	1	2020-08-26 09:02:55.472307
120205	0102	MIRGAS	1	1202	1	1	2020-08-26 09:02:55.472307
120206	0102	SAN JOSE DE RONTOY	1	1202	1	1	2020-08-26 09:02:55.472307
120301	0102	ACOCHACA	1	1203	1	1	2020-08-26 09:02:55.472307
120302	0102	CHACAS	1	1203	1	1	2020-08-26 09:02:55.472307
120401	0102	ABELARDO PARDO LEZAMETA	1	1204	1	1	2020-08-26 09:02:55.472307
120402	0102	ANTONIO RAYMONDI	1	1204	1	1	2020-08-26 09:02:55.472307
120403	0102	AQUIA	1	1204	1	1	2020-08-26 09:02:55.472307
120404	0102	CAJACAY	1	1204	1	1	2020-08-26 09:02:55.472307
120405	0102	CANIS	1	1204	1	1	2020-08-26 09:02:55.472307
120406	0102	CHIQUIÁN	1	1204	1	1	2020-08-26 09:02:55.472307
120407	0102	COLQUIOC	1	1204	1	1	2020-08-26 09:02:55.472307
120408	0102	HAYLLACAYAN	1	1204	1	1	2020-08-26 09:02:55.472307
120409	0102	HUALLANCA	1	1204	1	1	2020-08-26 09:02:55.472307
120410	0102	HUASTA	1	1204	1	1	2020-08-26 09:02:55.472307
120411	0102	LA PRIMAVERA	1	1204	1	1	2020-08-26 09:02:55.472307
120412	0102	MANGAS	1	1204	1	1	2020-08-26 09:02:55.472307
120413	0102	PACLLON	1	1204	1	1	2020-08-26 09:02:55.472307
120414	0102	SAN MIGUEL DE CORPANQUI	1	1204	1	1	2020-08-26 09:02:55.472307
120415	0102	TICLLOS	1	1204	1	1	2020-08-26 09:02:55.472307
120501	0102	ACOPAMPA	1	1205	1	1	2020-08-26 09:02:55.472307
120502	0102	AMASHCA	1	1205	1	1	2020-08-26 09:02:55.472307
120503	0102	ANTA	1	1205	1	1	2020-08-26 09:02:55.472307
120504	0102	ATAQUERO	1	1205	1	1	2020-08-26 09:02:55.472307
120505	0102	CARHUAZ	1	1205	1	1	2020-08-26 09:02:55.472307
120506	0102	MARCARA	1	1205	1	1	2020-08-26 09:02:55.472307
120507	0102	PARIAHUANCA	1	1205	1	1	2020-08-26 09:02:55.472307
120508	0102	SAN MIGUEL DE ACO	1	1205	1	1	2020-08-26 09:02:55.472307
120509	0102	SHILLA	1	1205	1	1	2020-08-26 09:02:55.472307
120510	0102	TINCO	1	1205	1	1	2020-08-26 09:02:55.472307
120511	0102	YUNGAR	1	1205	1	1	2020-08-26 09:02:55.472307
120601	0102	SAN LUIS	1	1206	1	1	2020-08-26 09:02:55.472307
120602	0102	SAN NICOLAS	1	1206	1	1	2020-08-26 09:02:55.472307
120603	0102	YAUYA	1	1206	1	1	2020-08-26 09:02:55.472307
120701	0102	BUENA VISTA ALTA	1	1207	1	1	2020-08-26 09:02:55.472307
120702	0102	CASMA	1	1207	1	1	2020-08-26 09:02:55.472307
120703	0102	COMANDANTE NOEL	1	1207	1	1	2020-08-26 09:02:55.472307
120704	0102	YAUTAN	1	1207	1	1	2020-08-26 09:02:55.472307
120802	0102	BAMBAS	1	1208	1	1	2020-08-26 09:02:55.472307
120803	0102	CORONGO	1	1208	1	1	2020-08-26 09:02:55.472307
120804	0102	CUSCA	1	1208	1	1	2020-08-26 09:02:55.472307
120805	0102	LA PAMPA	1	1208	1	1	2020-08-26 09:02:55.472307
120806	0102	YANAC	1	1208	1	1	2020-08-26 09:02:55.472307
120807	0102	YUPAN	1	1208	1	1	2020-08-26 09:02:55.472307
120901	0102	COCHABAMBA	1	1209	1	1	2020-08-26 09:02:55.472307
120902	0102	COLCABAMBA	1	1209	1	1	2020-08-26 09:02:55.472307
120903	0102	HUANCHAY	1	1209	1	1	2020-08-26 09:02:55.472307
120904	0102	HUARAZ	1	1209	1	1	2020-08-26 09:02:55.472307
120905	0102	INDEPENDENCIA	1	1209	1	1	2020-08-26 09:02:55.472307
120906	0102	JANGAS	1	1209	1	1	2020-08-26 09:02:55.472307
120907	0102	LA LIBERTAD	1	1209	1	1	2020-08-26 09:02:55.472307
120908	0102	OLLEROS	1	1209	1	1	2020-08-26 09:02:55.472307
120909	0102	PAMPAS	1	1209	1	1	2020-08-26 09:02:55.472307
120910	0102	PARIACOTO	1	1209	1	1	2020-08-26 09:02:55.472307
120911	0102	PIRA	1	1209	1	1	2020-08-26 09:02:55.472307
120912	0102	TARICA	1	1209	1	1	2020-08-26 09:02:55.472307
121001	0102	ANRA	1	1210	1	1	2020-08-26 09:02:55.472307
121002	0102	CAJAY	1	1210	1	1	2020-08-26 09:02:55.472307
121003	0102	CHAVIN DE HUANTAR	1	1210	1	1	2020-08-26 09:02:55.472307
121004	0102	HUACACHI	1	1210	1	1	2020-08-26 09:02:55.472307
121005	0102	HUACCHIS	1	1210	1	1	2020-08-26 09:02:55.472307
121006	0102	HUACHIS	1	1210	1	1	2020-08-26 09:02:55.472307
121007	0102	HUANTAR	1	1210	1	1	2020-08-26 09:02:55.472307
121008	0102	HUARI	1	1210	1	1	2020-08-26 09:02:55.472307
121009	0102	MASIN	1	1210	1	1	2020-08-26 09:02:55.472307
121010	0102	PAUCAS	1	1210	1	1	2020-08-26 09:02:55.472307
121011	0102	PONTO	1	1210	1	1	2020-08-26 09:02:55.472307
121012	0102	RAPAYAN	1	1210	1	1	2020-08-26 09:02:55.472307
121013	0102	SAN MARCOS	1	1210	1	1	2020-08-26 09:02:55.472307
121014	0102	SAN PEDRO DE CHANA	1	1210	1	1	2020-08-26 09:02:55.472307
121015	0102	UCO	1	1210	1	1	2020-08-26 09:02:55.472307
121101	0102	COCHAPETI	1	1211	1	1	2020-08-26 09:02:55.472307
121102	0102	CULEBRAS	1	1211	1	1	2020-08-26 09:02:55.472307
121103	0102	HUARMEY	1	1211	1	1	2020-08-26 09:02:55.472307
121104	0102	HUAYAN	1	1211	1	1	2020-08-26 09:02:55.472307
121105	0102	MALVAS	1	1211	1	1	2020-08-26 09:02:55.472307
121201	0102	CARAZ	1	1212	1	1	2020-08-26 09:02:55.472307
121202	0102	HUALLANCA	1	1212	1	1	2020-08-26 09:02:55.472307
121203	0102	HUATA	1	1212	1	1	2020-08-26 09:02:55.472307
121204	0102	HUAYLAS	1	1212	1	1	2020-08-26 09:02:55.472307
121205	0102	MATO	1	1212	1	1	2020-08-26 09:02:55.472307
121206	0102	PAMPAROMAS	1	1212	1	1	2020-08-26 09:02:55.472307
121207	0102	PUEBLO LIBRE	1	1212	1	1	2020-08-26 09:02:55.472307
121208	0102	SANTA CRUZ	1	1212	1	1	2020-08-26 09:02:55.472307
121209	0102	SANTO TORIBIO	1	1212	1	1	2020-08-26 09:02:55.472307
121210	0102	YURACMARCA	1	1212	1	1	2020-08-26 09:02:55.472307
121301	0102	CASCA	1	1213	1	1	2020-08-26 09:02:55.472307
121302	0102	ELEAZAR GUZMAN BARRON	1	1213	1	1	2020-08-26 09:02:55.472307
121303	0102	FIDEL OLIVAS ESCUDERO	1	1213	1	1	2020-08-26 09:02:55.472307
121304	0102	LLAMA	1	1213	1	1	2020-08-26 09:02:55.472307
121305	0102	LLUMPA	1	1213	1	1	2020-08-26 09:02:55.472307
121306	0102	LUCMA	1	1213	1	1	2020-08-26 09:02:55.472307
121307	0102	MUSGA	1	1213	1	1	2020-08-26 09:02:55.472307
121308	0102	PISCOBAMBA	1	1213	1	1	2020-08-26 09:02:55.472307
121401	0102	ACAS	1	1214	1	1	2020-08-26 09:02:55.472307
121402	0102	CAJAMARQUILLA	1	1214	1	1	2020-08-26 09:02:55.472307
121403	0102	CARHUAPAMPA	1	1214	1	1	2020-08-26 09:02:55.472307
121404	0102	COCHAS	1	1214	1	1	2020-08-26 09:02:55.472307
121405	0102	CONGAS	1	1214	1	1	2020-08-26 09:02:55.472307
121406	0102	LLIPA	1	1214	1	1	2020-08-26 09:02:55.472307
121407	0102	OCROS	1	1214	1	1	2020-08-26 09:02:55.472307
121408	0102	SAN CRISTOBAL DE RAJAN	1	1214	1	1	2020-08-26 09:02:55.472307
121409	0102	SAN PEDRO	1	1214	1	1	2020-08-26 09:02:55.472307
121410	0102	SANTIAGO DE CHILCAS	1	1214	1	1	2020-08-26 09:02:55.472307
121501	0102	BOLOGNESI	1	1215	1	1	2020-08-26 09:02:55.472307
121502	0102	CABANA	1	1215	1	1	2020-08-26 09:02:55.472307
121503	0102	CONCHUCOS	1	1215	1	1	2020-08-26 09:02:55.472307
121504	0102	HUANDOVAL	1	1215	1	1	2020-08-26 09:02:55.472307
121505	0102	HUASCACHUQUE	1	1215	1	1	2020-08-26 09:02:55.472307
121506	0102	LACABAMBA	1	1215	1	1	2020-08-26 09:02:55.472307
121507	0102	LLAPO	1	1215	1	1	2020-08-26 09:02:55.472307
121508	0102	PALLASCA	1	1215	1	1	2020-08-26 09:02:55.472307
121509	0102	PAMPAS	1	1215	1	1	2020-08-26 09:02:55.472307
121510	0102	SANTA ROSA	1	1215	1	1	2020-08-26 09:02:55.472307
121511	0102	TAUCA	1	1215	1	1	2020-08-26 09:02:55.472307
121601	0102	HUAYLLAN	1	1216	1	1	2020-08-26 09:02:55.472307
121602	0102	PAROBAMBA	1	1216	1	1	2020-08-26 09:02:55.472307
121603	0102	POMABAMBA	1	1216	1	1	2020-08-26 09:02:55.472307
121604	0102	QUINUABAMBA	1	1216	1	1	2020-08-26 09:02:55.472307
121701	0102	CATAC	1	1217	1	1	2020-08-26 09:02:55.472307
121702	0102	COTAPARACO	1	1217	1	1	2020-08-26 09:02:55.472307
121703	0102	HUAYLLAPAMPA	1	1217	1	1	2020-08-26 09:02:55.472307
121704	0102	LLACLLIN	1	1217	1	1	2020-08-26 09:02:55.472307
121705	0102	MARCA	1	1217	1	1	2020-08-26 09:02:55.472307
121706	0102	PAMPAS CHICO	1	1217	1	1	2020-08-26 09:02:55.472307
121707	0102	PARARIN	1	1217	1	1	2020-08-26 09:02:55.472307
121708	0102	RECUAY	1	1217	1	1	2020-08-26 09:02:55.472307
121709	0102	TAPACOCHA	1	1217	1	1	2020-08-26 09:02:55.472307
121710	0102	TICAPAMPA	1	1217	1	1	2020-08-26 09:02:55.472307
121801	0102	CACERES DEL PERÚ	1	1218	1	1	2020-08-26 09:02:55.472307
121802	0102	CHIMBOTE	1	1218	1	1	2020-08-26 09:02:55.472307
121803	0102	COISHCO	1	1218	1	1	2020-08-26 09:02:55.472307
121804	0102	MACATE	1	1218	1	1	2020-08-26 09:02:55.472307
121805	0102	MORO	1	1218	1	1	2020-08-26 09:02:55.472307
121806	0102	NEPEÑA	1	1218	1	1	2020-08-26 09:02:55.472307
121807	0102	NUEVO CHIMBOTE	1	1218	1	1	2020-08-26 09:02:55.472307
121808	0102	SAMANCO	1	1218	1	1	2020-08-26 09:02:55.472307
121809	0102	SANTA	1	1218	1	1	2020-08-26 09:02:55.472307
121901	0102	ACOBAMBA	1	1219	1	1	2020-08-26 09:02:55.472307
121902	0102	ALFONSO UGARTE	1	1219	1	1	2020-08-26 09:02:55.472307
121903	0102	CASHAPAMPA	1	1219	1	1	2020-08-26 09:02:55.472307
121904	0102	CHINGALPO	1	1219	1	1	2020-08-26 09:02:55.472307
121905	0102	HUAYLLABAMBA	1	1219	1	1	2020-08-26 09:02:55.472307
121906	0102	QUICHES	1	1219	1	1	2020-08-26 09:02:55.472307
121907	0102	RAGASH	1	1219	1	1	2020-08-26 09:02:55.472307
121908	0102	SAN JUAN	1	1219	1	1	2020-08-26 09:02:55.472307
121909	0102	SICSIBAMBA	1	1219	1	1	2020-08-26 09:02:55.472307
121910	0102	SIHUAS	1	1219	1	1	2020-08-26 09:02:55.472307
122001	0102	CASCAPARA	1	1220	1	1	2020-08-26 09:02:55.472307
122002	0102	MANCOS	1	1220	1	1	2020-08-26 09:02:55.472307
130214	0102	SAN JERONIMO	1	1302	1	1	2020-08-26 09:02:55.472307
130215	0102	SANTA MARIA DE CHICMO	1	1302	1	1	2020-08-26 09:02:55.472307
130216	0102	TALAVERA	1	1302	1	1	2020-08-26 09:02:55.472307
130217	0102	TUMAY HUARACA	1	1302	1	1	2020-08-26 09:02:55.472307
130218	0102	TURPO	1	1302	1	1	2020-08-26 09:02:55.472307
130301	0102	ANTABAMBA	1	1303	1	1	2020-08-26 09:02:55.472307
130302	0102	EL ORO	1	1303	1	1	2020-08-26 09:02:55.472307
130303	0102	HUAQUIRCA	1	1303	1	1	2020-08-26 09:02:55.472307
130304	0102	JUAN ESPINOZA MEDRANO	1	1303	1	1	2020-08-26 09:02:55.472307
130305	0102	OROPESA	1	1303	1	1	2020-08-26 09:02:55.472307
130306	0102	PACHACONAS	1	1303	1	1	2020-08-26 09:02:55.472307
130307	0102	SABAINO	1	1303	1	1	2020-08-26 09:02:55.472307
130401	0102	CAPAYA	1	1304	1	1	2020-08-26 09:02:55.472307
130402	0102	CARAYBAMBA	1	1304	1	1	2020-08-26 09:02:55.472307
130403	0102	CHALHUANCA	1	1304	1	1	2020-08-26 09:02:55.472307
130404	0102	CHAPIMARCA	1	1304	1	1	2020-08-26 09:02:55.472307
130405	0102	COLCABAMBA	1	1304	1	1	2020-08-26 09:02:55.472307
130406	0102	COTARUSE	1	1304	1	1	2020-08-26 09:02:55.472307
130407	0102	HUAYLLO	1	1304	1	1	2020-08-26 09:02:55.472307
130408	0102	JUSTO APU SAHUARAURA	1	1304	1	1	2020-08-26 09:02:55.472307
130409	0102	LUCRE	1	1304	1	1	2020-08-26 09:02:55.472307
130410	0102	POCOHUANCA	1	1304	1	1	2020-08-26 09:02:55.472307
130411	0102	SAN JOSE DE CHACÑA	1	1304	1	1	2020-08-26 09:02:55.472307
130412	0102	SAÑAYCA	1	1304	1	1	2020-08-26 09:02:55.472307
130413	0102	SORAYA	1	1304	1	1	2020-08-26 09:02:55.472307
130414	0102	TAPAIRIHUA	1	1304	1	1	2020-08-26 09:02:55.472307
130415	0102	TINTAY	1	1304	1	1	2020-08-26 09:02:55.472307
130416	0102	TORAYA	1	1304	1	1	2020-08-26 09:02:55.472307
130417	0102	YANACA	1	1304	1	1	2020-08-26 09:02:55.472307
130501	0102	CHALLHUAHUACHO	1	1305	1	1	2020-08-26 09:02:55.472307
130502	0102	COTABAMBAS	1	1305	1	1	2020-08-26 09:02:55.472307
130503	0102	COYLLURQUI	1	1305	1	1	2020-08-26 09:02:55.472307
130504	0102	HAQUIRA	1	1305	1	1	2020-08-26 09:02:55.472307
130505	0102	MARA	1	1305	1	1	2020-08-26 09:02:55.472307
130506	0102	TAMBOBAMBA	1	1305	1	1	2020-08-26 09:02:55.472307
130601	0102	ANCO-HUALLO	1	1306	1	1	2020-08-26 09:02:55.472307
130602	0102	CHINCHEROS	1	1306	1	1	2020-08-26 09:02:55.472307
130603	0102	COCHARCAS	1	1306	1	1	2020-08-26 09:02:55.472307
130604	0102	HUACCANA	1	1306	1	1	2020-08-26 09:02:55.472307
130605	0102	OCOBAMBA	1	1306	1	1	2020-08-26 09:02:55.472307
130606	0102	ONGOY	1	1306	1	1	2020-08-26 09:02:55.472307
130607	0102	RANRACANCHA	1	1306	1	1	2020-08-26 09:02:55.472307
130608	0102	URANMARCA	1	1306	1	1	2020-08-26 09:02:55.472307
130701	0102	CHIQUIBAMBILLA	1	1307	1	1	2020-08-26 09:02:55.472307
130702	0102	CURASCO	1	1307	1	1	2020-08-26 09:02:55.472307
130703	0102	CURPAHUASI	1	1307	1	1	2020-08-26 09:02:55.472307
130704	0102	GAMARRA	1	1307	1	1	2020-08-26 09:02:55.472307
130705	0102	HUAYLLATI	1	1307	1	1	2020-08-26 09:02:55.472307
130706	0102	MAMARA	1	1307	1	1	2020-08-26 09:02:55.472307
130707	0102	MICAELA BASTIDAS	1	1307	1	1	2020-08-26 09:02:55.472307
130708	0102	PATAYPAMPA	1	1307	1	1	2020-08-26 09:02:55.472307
130709	0102	PROGRESO	1	1307	1	1	2020-08-26 09:02:55.472307
130710	0102	SAN ANTONIO	1	1307	1	1	2020-08-26 09:02:55.472307
130711	0102	SANTA ROSA	1	1307	1	1	2020-08-26 09:02:55.472307
130712	0102	TURPAY	1	1307	1	1	2020-08-26 09:02:55.472307
130713	0102	VILCABAMBA	1	1307	1	1	2020-08-26 09:02:55.472307
130714	0102	VIRUNDO	1	1307	1	1	2020-08-26 09:02:55.472307
140201	0102	CAMANA	1	1402	1	1	2020-08-26 09:02:55.472307
140202	0102	JOSE MARIA QUIMPER	1	1402	1	1	2020-08-26 09:02:55.472307
140203	0102	MARIANO NICOLAS VALCARCEL	1	1402	1	1	2020-08-26 09:02:55.472307
140204	0102	MARISCAL CACERES	1	1402	1	1	2020-08-26 09:02:55.472307
140205	0102	NICOLAS DE PIEROLA	1	1402	1	1	2020-08-26 09:02:55.472307
140206	0102	OCOÑA	1	1402	1	1	2020-08-26 09:02:55.472307
140207	0102	QUILCA	1	1402	1	1	2020-08-26 09:02:55.472307
140208	0102	SAMUEL PASTOR	1	1402	1	1	2020-08-26 09:02:55.472307
140301	0102	ACARI	1	1403	1	1	2020-08-26 09:02:55.472307
140302	0102	ATICO	1	1403	1	1	2020-08-26 09:02:55.472307
140303	0102	ATIQUIPA	1	1403	1	1	2020-08-26 09:02:55.472307
140304	0102	BELLA UNION	1	1403	1	1	2020-08-26 09:02:55.472307
140305	0102	CAHUACHO	1	1403	1	1	2020-08-26 09:02:55.472307
140306	0102	CARAVELI	1	1403	1	1	2020-08-26 09:02:55.472307
140307	0102	CHALA	1	1403	1	1	2020-08-26 09:02:55.472307
140308	0102	CHAPARRA	1	1403	1	1	2020-08-26 09:02:55.472307
140309	0102	HUANUHUANU	1	1403	1	1	2020-08-26 09:02:55.472307
140310	0102	JAQUI	1	1403	1	1	2020-08-26 09:02:55.472307
140311	0102	LOMAS	1	1403	1	1	2020-08-26 09:02:55.472307
140312	0102	QUICACHA	1	1403	1	1	2020-08-26 09:02:55.472307
140313	0102	YAUCA	1	1403	1	1	2020-08-26 09:02:55.472307
140401	0102	ANDAGUA	1	1404	1	1	2020-08-26 09:02:55.472307
140402	0102	APLAO	1	1404	1	1	2020-08-26 09:02:55.472307
140403	0102	AYO	1	1404	1	1	2020-08-26 09:02:55.472307
140404	0102	CHACHAS	1	1404	1	1	2020-08-26 09:02:55.472307
140405	0102	CHILCAYMARCA	1	1404	1	1	2020-08-26 09:02:55.472307
140406	0102	CHOCO	1	1404	1	1	2020-08-26 09:02:55.472307
140407	0102	HUANCARQUI	1	1404	1	1	2020-08-26 09:02:55.472307
140408	0102	MACHAGUAY	1	1404	1	1	2020-08-26 09:02:55.472307
140409	0102	ORCOPAMPA	1	1404	1	1	2020-08-26 09:02:55.472307
140410	0102	PAMPACOLCA	1	1404	1	1	2020-08-26 09:02:55.472307
140411	0102	TIPAN	1	1404	1	1	2020-08-26 09:02:55.472307
140412	0102	UÑON	1	1404	1	1	2020-08-26 09:02:55.472307
140413	0102	URACA	1	1404	1	1	2020-08-26 09:02:55.472307
140414	0102	VIRACO	1	1404	1	1	2020-08-26 09:02:55.472307
140501	0102	ACHOMA	1	1405	1	1	2020-08-26 09:02:55.472307
140502	0102	CABANACONDE	1	1405	1	1	2020-08-26 09:02:55.472307
140503	0102	CALLALLI	1	1405	1	1	2020-08-26 09:02:55.472307
140504	0102	CAYLLOMA	1	1405	1	1	2020-08-26 09:02:55.472307
140505	0102	CHIVAY	1	1405	1	1	2020-08-26 09:02:55.472307
140506	0102	COPORAQUE	1	1405	1	1	2020-08-26 09:02:55.472307
140507	0102	HUAMBO	1	1405	1	1	2020-08-26 09:02:55.472307
140508	0102	HUANCA	1	1405	1	1	2020-08-26 09:02:55.472307
140509	0102	ICHUPAMPA	1	1405	1	1	2020-08-26 09:02:55.472307
140510	0102	LARI	1	1405	1	1	2020-08-26 09:02:55.472307
140511	0102	LLUTA	1	1405	1	1	2020-08-26 09:02:55.472307
140512	0102	MACA	1	1405	1	1	2020-08-26 09:02:55.472307
140513	0102	MADRIGAL	1	1405	1	1	2020-08-26 09:02:55.472307
140514	0102	MAJES	1	1405	1	1	2020-08-26 09:02:55.472307
140515	0102	SAN ANTONIO DE CHUCA	1	1405	1	1	2020-08-26 09:02:55.472307
140516	0102	SIBAYO	1	1405	1	1	2020-08-26 09:02:55.472307
140517	0102	TAPAY	1	1405	1	1	2020-08-26 09:02:55.472307
140518	0102	TISCO	1	1405	1	1	2020-08-26 09:02:55.472307
140519	0102	TUTI	1	1405	1	1	2020-08-26 09:02:55.472307
140520	0102	YANQUE	1	1405	1	1	2020-08-26 09:02:55.472307
140601	0102	ANDARAY	1	1406	1	1	2020-08-26 09:02:55.472307
140602	0102	CAYARANI	1	1406	1	1	2020-08-26 09:02:55.472307
140603	0102	CHICHAS	1	1406	1	1	2020-08-26 09:02:55.472307
140604	0102	CHUQUIBAMBA	1	1406	1	1	2020-08-26 09:02:55.472307
140605	0102	IRAY	1	1406	1	1	2020-08-26 09:02:55.472307
140606	0102	RIO GRANDE	1	1406	1	1	2020-08-26 09:02:55.472307
140607	0102	SALAMANCA	1	1406	1	1	2020-08-26 09:02:55.472307
140608	0102	YANAQUIHUA	1	1406	1	1	2020-08-26 09:02:55.472307
140701	0102	COCACHACRA	1	1407	1	1	2020-08-26 09:02:55.472307
140702	0102	DEAN VALDIVIA	1	1407	1	1	2020-08-26 09:02:55.472307
140703	0102	ISLAY	1	1407	1	1	2020-08-26 09:02:55.472307
140704	0102	MEJIA	1	1407	1	1	2020-08-26 09:02:55.472307
140705	0102	MOLLENDO	1	1407	1	1	2020-08-26 09:02:55.472307
140706	0102	PUNTA DE BOMBON	1	1407	1	1	2020-08-26 09:02:55.472307
140801	0102	ALCA	1	1408	1	1	2020-08-26 09:02:55.472307
140802	0102	CHARCANA	1	1408	1	1	2020-08-26 09:02:55.472307
140803	0102	COTAHUASI	1	1408	1	1	2020-08-26 09:02:55.472307
140804	0102	HUAYNACOTAS	1	1408	1	1	2020-08-26 09:02:55.472307
140805	0102	PAMPAMARCA	1	1408	1	1	2020-08-26 09:02:55.472307
140806	0102	PUYCA	1	1408	1	1	2020-08-26 09:02:55.472307
140807	0102	QUECHUALLA	1	1408	1	1	2020-08-26 09:02:55.472307
140808	0102	SAYLA	1	1408	1	1	2020-08-26 09:02:55.472307
140809	0102	TAURIA	1	1408	1	1	2020-08-26 09:02:55.472307
140810	0102	TOMEPAMPA	1	1408	1	1	2020-08-26 09:02:55.472307
140811	0102	TORO	1	1408	1	1	2020-08-26 09:02:55.472307
150101	0102	CANGALLO	1	1501	1	1	2020-08-26 09:02:55.472307
150102	0102	CHUSCHI	1	1501	1	1	2020-08-26 09:02:55.472307
150103	0102	LOS MOROCHUCOS	1	1501	1	1	2020-08-26 09:02:55.472307
150104	0102	MARIA PARADO DE BELLIDO	1	1501	1	1	2020-08-26 09:02:55.472307
150105	0102	PARAS	1	1501	1	1	2020-08-26 09:02:55.472307
150106	0102	TOTOS	1	1501	1	1	2020-08-26 09:02:55.472307
150201	0102	ACOCRO	1	1502	1	1	2020-08-26 09:02:55.472307
150202	0102	ACOS VINCHOS	1	1502	1	1	2020-08-26 09:02:55.472307
150203	0102	AYACUCHO	1	1502	1	1	2020-08-26 09:02:55.472307
150204	0102	CARMEN ALTO	1	1502	1	1	2020-08-26 09:02:55.472307
150205	0102	CHIARA	1	1502	1	1	2020-08-26 09:02:55.472307
150206	0102	JESUS NAZARENO	1	1502	1	1	2020-08-26 09:02:55.472307
150207	0102	OCROS	1	1502	1	1	2020-08-26 09:02:55.472307
150208	0102	PACAYCASA	1	1502	1	1	2020-08-26 09:02:55.472307
150209	0102	QUINUA	1	1502	1	1	2020-08-26 09:02:55.472307
150210	0102	SAN JOSE DE TICLLAS	1	1502	1	1	2020-08-26 09:02:55.472307
150211	0102	SAN JUAN BAUTISTA	1	1502	1	1	2020-08-26 09:02:55.472307
150212	0102	SANTIAGO DE PISCHA	1	1502	1	1	2020-08-26 09:02:55.472307
150213	0102	SOCOS	1	1502	1	1	2020-08-26 09:02:55.472307
150214	0102	TAMBILLO	1	1502	1	1	2020-08-26 09:02:55.472307
150215	0102	VINCHOS	1	1502	1	1	2020-08-26 09:02:55.472307
150301	0102	CARAPO	1	1503	1	1	2020-08-26 09:02:55.472307
150302	0102	SACSAMARCA	1	1503	1	1	2020-08-26 09:02:55.472307
150303	0102	SANCOS	1	1503	1	1	2020-08-26 09:02:55.472307
150304	0102	SANTIAGO DE LUCANAMARCA	1	1503	1	1	2020-08-26 09:02:55.472307
150401	0102	AYAHUANCO	1	1504	1	1	2020-08-26 09:02:55.472307
150402	0102	HUAMANGUILLA	1	1504	1	1	2020-08-26 09:02:55.472307
150403	0102	HUANTA	1	1504	1	1	2020-08-26 09:02:55.472307
150404	0102	IGUAIN	1	1504	1	1	2020-08-26 09:02:55.472307
150405	0102	LLOCHEGUA	1	1504	1	1	2020-08-26 09:02:55.472307
150406	0102	LURICOCHA	1	1504	1	1	2020-08-26 09:02:55.472307
150407	0102	SANTILLANA	1	1504	1	1	2020-08-26 09:02:55.472307
150408	0102	SIVIA	1	1504	1	1	2020-08-26 09:02:55.472307
150501	0102	ANCO	1	1505	1	1	2020-08-26 09:02:55.472307
150502	0102	AYNA	1	1505	1	1	2020-08-26 09:02:55.472307
150503	0102	CHILCAS	1	1505	1	1	2020-08-26 09:02:55.472307
150504	0102	CHINGUI	1	1505	1	1	2020-08-26 09:02:55.472307
150505	0102	LUIS CARRANZA	1	1505	1	1	2020-08-26 09:02:55.472307
150506	0102	SAN MIGUEL	1	1505	1	1	2020-08-26 09:02:55.472307
150507	0102	SANTA ROSA	1	1505	1	1	2020-08-26 09:02:55.472307
150508	0102	TAMBO	1	1505	1	1	2020-08-26 09:02:55.472307
150601	0102	AUCARA	1	1506	1	1	2020-08-26 09:02:55.472307
150602	0102	CABANA	1	1506	1	1	2020-08-26 09:02:55.472307
150603	0102	CARMEN SALCEDO	1	1506	1	1	2020-08-26 09:02:55.472307
150604	0102	CHAVIÑA	1	1506	1	1	2020-08-26 09:02:55.472307
150605	0102	CHIPAO	1	1506	1	1	2020-08-26 09:02:55.472307
150606	0102	HUAC-HUAS	1	1506	1	1	2020-08-26 09:02:55.472307
150607	0102	LARAMATE	1	1506	1	1	2020-08-26 09:02:55.472307
150608	0102	LEONCIO PRADO	1	1506	1	1	2020-08-26 09:02:55.472307
150609	0102	LLAUTA	1	1506	1	1	2020-08-26 09:02:55.472307
150610	0102	LUCANAS	1	1506	1	1	2020-08-26 09:02:55.472307
150611	0102	OCAÑA	1	1506	1	1	2020-08-26 09:02:55.472307
150612	0102	OTOCA	1	1506	1	1	2020-08-26 09:02:55.472307
150613	0102	PUQUIO	1	1506	1	1	2020-08-26 09:02:55.472307
150614	0102	SAISA	1	1506	1	1	2020-08-26 09:02:55.472307
150615	0102	SAN CRISTOBAL	1	1506	1	1	2020-08-26 09:02:55.472307
150616	0102	SAN JUAN	1	1506	1	1	2020-08-26 09:02:55.472307
150617	0102	SAN PEDRO	1	1506	1	1	2020-08-26 09:02:55.472307
160604	0102	CUTERVO	1	1606	1	1	2020-08-26 09:02:55.472307
150618	0102	SAN PEDRO DE PALCO	1	1506	1	1	2020-08-26 09:02:55.472307
150619	0102	SANCOS	1	1506	1	1	2020-08-26 09:02:55.472307
150620	0102	SANTA ANA DE HUAYCAHUACHO	1	1506	1	1	2020-08-26 09:02:55.472307
150621	0102	SANTA LUCIA	1	1506	1	1	2020-08-26 09:02:55.472307
150701	0102	CHUMPI	1	1507	1	1	2020-08-26 09:02:55.472307
150702	0102	CORACORA	1	1507	1	1	2020-08-26 09:02:55.472307
150703	0102	CORONEL CASTAÑEDA	1	1507	1	1	2020-08-26 09:02:55.472307
150704	0102	PACAPAUSA	1	1507	1	1	2020-08-26 09:02:55.472307
150705	0102	PULLO	1	1507	1	1	2020-08-26 09:02:55.472307
150706	0102	PUYUSCA	1	1507	1	1	2020-08-26 09:02:55.472307
150707	0102	SAN FRANCISCO DE RAVACAYCO	1	1507	1	1	2020-08-26 09:02:55.472307
150708	0102	UPAHUACHO	1	1507	1	1	2020-08-26 09:02:55.472307
150801	0102	COLTA	1	1508	1	1	2020-08-26 09:02:55.472307
150802	0102	CORCULLA	1	1508	1	1	2020-08-26 09:02:55.472307
150803	0102	LAMPA	1	1508	1	1	2020-08-26 09:02:55.472307
150804	0102	MARCABAMBA	1	1508	1	1	2020-08-26 09:02:55.472307
150805	0102	OYOLO	1	1508	1	1	2020-08-26 09:02:55.472307
150806	0102	PARARCA	1	1508	1	1	2020-08-26 09:02:55.472307
150807	0102	PAUSA	1	1508	1	1	2020-08-26 09:02:55.472307
150808	0102	SAN JAVIER DE ALPABAMBA	1	1508	1	1	2020-08-26 09:02:55.472307
150809	0102	SAN JOSE DE USHUA	1	1508	1	1	2020-08-26 09:02:55.472307
150810	0102	SARA SARA	1	1508	1	1	2020-08-26 09:02:55.472307
150901	0102	BELEN	1	1509	1	1	2020-08-26 09:02:55.472307
150902	0102	CHALCOS	1	1509	1	1	2020-08-26 09:02:55.472307
150903	0102	CHILCAYOC	1	1509	1	1	2020-08-26 09:02:55.472307
150904	0102	HUACAÑA	1	1509	1	1	2020-08-26 09:02:55.472307
150905	0102	MORCOLLA	1	1509	1	1	2020-08-26 09:02:55.472307
150906	0102	PAICO	1	1509	1	1	2020-08-26 09:02:55.472307
150907	0102	QUEROBAMBA	1	1509	1	1	2020-08-26 09:02:55.472307
150908	0102	SAN PEDRO DE LARCAY	1	1509	1	1	2020-08-26 09:02:55.472307
150909	0102	SAN SALVADOR DE QUIJE	1	1509	1	1	2020-08-26 09:02:55.472307
150910	0102	SANTIAGO DE PAUCARAY	1	1509	1	1	2020-08-26 09:02:55.472307
150911	0102	SORAS	1	1509	1	1	2020-08-26 09:02:55.472307
151001	0102	ALCAMENCA	1	1510	1	1	2020-08-26 09:02:55.472307
151002	0102	APONGO	1	1510	1	1	2020-08-26 09:02:55.472307
151003	0102	ASQUIPATA	1	1510	1	1	2020-08-26 09:02:55.472307
151004	0102	CANARIA	1	1510	1	1	2020-08-26 09:02:55.472307
151005	0102	CAYARA	1	1510	1	1	2020-08-26 09:02:55.472307
151006	0102	COLCA	1	1510	1	1	2020-08-26 09:02:55.472307
151007	0102	HUAMANQUIQUIA	1	1510	1	1	2020-08-26 09:02:55.472307
151008	0102	HUANCAPI	1	1510	1	1	2020-08-26 09:02:55.472307
151009	0102	HUANCARAYLLA	1	1510	1	1	2020-08-26 09:02:55.472307
151010	0102	HUAYA	1	1510	1	1	2020-08-26 09:02:55.472307
151011	0102	SARHUA	1	1510	1	1	2020-08-26 09:02:55.472307
151012	0102	VILCANCHOS	1	1510	1	1	2020-08-26 09:02:55.472307
151101	0102	ACCOMARCA	1	1511	1	1	2020-08-26 09:02:55.472307
151102	0102	CARHUANCA	1	1511	1	1	2020-08-26 09:02:55.472307
151103	0102	CONCEPCION	1	1511	1	1	2020-08-26 09:02:55.472307
151104	0102	HUAMBALPA	1	1511	1	1	2020-08-26 09:02:55.472307
151105	0102	INDEPENDENCIA	1	1511	1	1	2020-08-26 09:02:55.472307
151106	0102	SAURAMA	1	1511	1	1	2020-08-26 09:02:55.472307
151107	0102	VILCAS HUAMÁN	1	1511	1	1	2020-08-26 09:02:55.472307
151108	0102	VISCHONGO	1	1511	1	1	2020-08-26 09:02:55.472307
160101	0102	CACHACHI	1	1601	1	1	2020-08-26 09:02:55.472307
160102	0102	CAJABAMBA	1	1601	1	1	2020-08-26 09:02:55.472307
160103	0102	CONDEBAMBA	1	1601	1	1	2020-08-26 09:02:55.472307
160104	0102	SITACOCHA	1	1601	1	1	2020-08-26 09:02:55.472307
160201	0102	ASUNCION	1	1602	1	1	2020-08-26 09:02:55.472307
160202	0102	CAJAMARCA	1	1602	1	1	2020-08-26 09:02:55.472307
160203	0102	CHETILLA	1	1602	1	1	2020-08-26 09:02:55.472307
160204	0102	COSPAN	1	1602	1	1	2020-08-26 09:02:55.472307
160205	0102	ENCAÑADA	1	1602	1	1	2020-08-26 09:02:55.472307
160206	0102	JESUS	1	1602	1	1	2020-08-26 09:02:55.472307
160207	0102	LLACANORA	1	1602	1	1	2020-08-26 09:02:55.472307
160208	0102	LOS BAÑOS DEL INCA	1	1602	1	1	2020-08-26 09:02:55.472307
160209	0102	MAGDALENA	1	1602	1	1	2020-08-26 09:02:55.472307
160210	0102	MATARA	1	1602	1	1	2020-08-26 09:02:55.472307
160211	0102	NAMORA	1	1602	1	1	2020-08-26 09:02:55.472307
160212	0102	SAN JUAN	1	1602	1	1	2020-08-26 09:02:55.472307
160301	0102	CELENDÍN	1	1603	1	1	2020-08-26 09:02:55.472307
160302	0102	CHUMUCH	1	1603	1	1	2020-08-26 09:02:55.472307
160303	0102	CORTEGANA	1	1603	1	1	2020-08-26 09:02:55.472307
160304	0102	HUASMIN	1	1603	1	1	2020-08-26 09:02:55.472307
160305	0102	JORGE CHAVEZ	1	1603	1	1	2020-08-26 09:02:55.472307
160306	0102	JOSE GALVEZ	1	1603	1	1	2020-08-26 09:02:55.472307
160307	0102	LA LIBERTAD DE PALLAN	1	1603	1	1	2020-08-26 09:02:55.472307
160308	0102	MIGUEL IGLESIAS	1	1603	1	1	2020-08-26 09:02:55.472307
160309	0102	OXAMARCA	1	1603	1	1	2020-08-26 09:02:55.472307
160310	0102	SOROCHUCO	1	1603	1	1	2020-08-26 09:02:55.472307
160311	0102	SUCRE	1	1603	1	1	2020-08-26 09:02:55.472307
160312	0102	UTCO	1	1603	1	1	2020-08-26 09:02:55.472307
160401	0102	ANGUIA	1	1604	1	1	2020-08-26 09:02:55.472307
160402	0102	CHADIN	1	1604	1	1	2020-08-26 09:02:55.472307
160403	0102	CHALAMARCA	1	1604	1	1	2020-08-26 09:02:55.472307
160404	0102	CHIGUIRIP	1	1604	1	1	2020-08-26 09:02:55.472307
160405	0102	CHIMBAN	1	1604	1	1	2020-08-26 09:02:55.472307
160406	0102	CHOROPAMPA	1	1604	1	1	2020-08-26 09:02:55.472307
160407	0102	CHOTA	1	1604	1	1	2020-08-26 09:02:55.472307
160408	0102	COCHABAMBA	1	1604	1	1	2020-08-26 09:02:55.472307
160409	0102	CONCHAN	1	1604	1	1	2020-08-26 09:02:55.472307
160410	0102	HUAMBOS	1	1604	1	1	2020-08-26 09:02:55.472307
160411	0102	LAJAS	1	1604	1	1	2020-08-26 09:02:55.472307
160412	0102	LLAMA	1	1604	1	1	2020-08-26 09:02:55.472307
160413	0102	MIRACOSTA	1	1604	1	1	2020-08-26 09:02:55.472307
160414	0102	PACCHA	1	1604	1	1	2020-08-26 09:02:55.472307
160415	0102	PION	1	1604	1	1	2020-08-26 09:02:55.472307
160416	0102	QUEROCOTO	1	1604	1	1	2020-08-26 09:02:55.472307
160417	0102	SAN JUAN DE LICUPIS	1	1604	1	1	2020-08-26 09:02:55.472307
160418	0102	TACABAMBA	1	1604	1	1	2020-08-26 09:02:55.472307
160419	0102	TOCMOCHE	1	1604	1	1	2020-08-26 09:02:55.472307
160501	0102	CHILETE	1	1605	1	1	2020-08-26 09:02:55.472307
160502	0102	CONTUMAZA	1	1605	1	1	2020-08-26 09:02:55.472307
160503	0102	CUPISNIQUE	1	1605	1	1	2020-08-26 09:02:55.472307
160504	0102	GUZMANGO	1	1605	1	1	2020-08-26 09:02:55.472307
160505	0102	SAN BENITO	1	1605	1	1	2020-08-26 09:02:55.472307
160506	0102	SANTA CRUZ DE TOLEDO	1	1605	1	1	2020-08-26 09:02:55.472307
160507	0102	TANTARICA	1	1605	1	1	2020-08-26 09:02:55.472307
160508	0102	YONAN	1	1605	1	1	2020-08-26 09:02:55.472307
160601	0102	CALLAYUC	1	1606	1	1	2020-08-26 09:02:55.472307
160602	0102	CHOROS	1	1606	1	1	2020-08-26 09:02:55.472307
160603	0102	CUJILLO	1	1606	1	1	2020-08-26 09:02:55.472307
160605	0102	LA RAMADA	1	1606	1	1	2020-08-26 09:02:55.472307
160606	0102	PIMPINGOS	1	1606	1	1	2020-08-26 09:02:55.472307
160607	0102	QUEROCOTILLO	1	1606	1	1	2020-08-26 09:02:55.472307
160608	0102	SAN ANDRES DE CUTERVO	1	1606	1	1	2020-08-26 09:02:55.472307
160609	0102	SAN JUAN DE CUTERVO	1	1606	1	1	2020-08-26 09:02:55.472307
160610	0102	SAN LUIS DE LUCMA	1	1606	1	1	2020-08-26 09:02:55.472307
160611	0102	SANTA CRUZ	1	1606	1	1	2020-08-26 09:02:55.472307
160612	0102	SANTO DOMINGO DE LA CAPILLA	1	1606	1	1	2020-08-26 09:02:55.472307
160613	0102	SANTO TOMAS	1	1606	1	1	2020-08-26 09:02:55.472307
160614	0102	SOCOTA	1	1606	1	1	2020-08-26 09:02:55.472307
160615	0102	TORIBIO CASANOVA	1	1606	1	1	2020-08-26 09:02:55.472307
160701	0102	BAMBAMARCA	1	1607	1	1	2020-08-26 09:02:55.472307
160702	0102	CHUGUR	1	1607	1	1	2020-08-26 09:02:55.472307
160703	0102	HUALGAYOC	1	1607	1	1	2020-08-26 09:02:55.472307
160801	0102	BELLAVISTA	1	1608	1	1	2020-08-26 09:02:55.472307
160802	0102	CHONTALI	1	1608	1	1	2020-08-26 09:02:55.472307
160803	0102	COLASAY	1	1608	1	1	2020-08-26 09:02:55.472307
160804	0102	HUABAL	1	1608	1	1	2020-08-26 09:02:55.472307
160805	0102	JAÉN	1	1608	1	1	2020-08-26 09:02:55.472307
160806	0102	LAS PIRIAS	1	1608	1	1	2020-08-26 09:02:55.472307
160807	0102	POMAHUACA	1	1608	1	1	2020-08-26 09:02:55.472307
160808	0102	PUCARA	1	1608	1	1	2020-08-26 09:02:55.472307
160809	0102	SALLIQUE	1	1608	1	1	2020-08-26 09:02:55.472307
160810	0102	SAN FELIPE	1	1608	1	1	2020-08-26 09:02:55.472307
160811	0102	SAN JOSE DE ALTO	1	1608	1	1	2020-08-26 09:02:55.472307
160812	0102	SANTA ROSA	1	1608	1	1	2020-08-26 09:02:55.472307
160901	0102	CHIRINOS	1	1609	1	1	2020-08-26 09:02:55.472307
160902	0102	HUARANGO	1	1609	1	1	2020-08-26 09:02:55.472307
160903	0102	LA COIPA	1	1609	1	1	2020-08-26 09:02:55.472307
160904	0102	NAMBALLE	1	1609	1	1	2020-08-26 09:02:55.472307
160905	0102	SAN IGNACIO	1	1609	1	1	2020-08-26 09:02:55.472307
160906	0102	SAN JOSE DE LOURDES	1	1609	1	1	2020-08-26 09:02:55.472307
160907	0102	TABACONAS	1	1609	1	1	2020-08-26 09:02:55.472307
161001	0102	CHANCAY	1	1610	1	1	2020-08-26 09:02:55.472307
161002	0102	EDUARDO VILLANUEVA	1	1610	1	1	2020-08-26 09:02:55.472307
161003	0102	GREGORIO PITA	1	1610	1	1	2020-08-26 09:02:55.472307
161004	0102	ICHOCAN	1	1610	1	1	2020-08-26 09:02:55.472307
161005	0102	JOSE MANUEL QUIROZ	1	1610	1	1	2020-08-26 09:02:55.472307
161006	0102	JOSE SABOGAL	1	1610	1	1	2020-08-26 09:02:55.472307
161007	0102	PEDRO GALVEZ	1	1610	1	1	2020-08-26 09:02:55.472307
161101	0102	BOLIVAR	1	1611	1	1	2020-08-26 09:02:55.472307
161102	0102	CALQUIS	1	1611	1	1	2020-08-26 09:02:55.472307
161103	0102	CATILLUC	1	1611	1	1	2020-08-26 09:02:55.472307
161104	0102	EL PRADO	1	1611	1	1	2020-08-26 09:02:55.472307
161105	0102	LA FLORIDA	1	1611	1	1	2020-08-26 09:02:55.472307
161106	0102	LLAPA	1	1611	1	1	2020-08-26 09:02:55.472307
161107	0102	NANCHOC	1	1611	1	1	2020-08-26 09:02:55.472307
161108	0102	NIEPOS	1	1611	1	1	2020-08-26 09:02:55.472307
161109	0102	SAN GREGORIO	1	1611	1	1	2020-08-26 09:02:55.472307
161110	0102	SAN MIGUEL	1	1611	1	1	2020-08-26 09:02:55.472307
161111	0102	SAN SILVESTRE DE COCHAN	1	1611	1	1	2020-08-26 09:02:55.472307
161112	0102	TONGOD	1	1611	1	1	2020-08-26 09:02:55.472307
161113	0102	UNION AGUA BLANCA	1	1611	1	1	2020-08-26 09:02:55.472307
161201	0102	SAN BERNARDINO	1	1612	1	1	2020-08-26 09:02:55.472307
161202	0102	SAN LUIS	1	1612	1	1	2020-08-26 09:02:55.472307
161203	0102	SAN PABLO	1	1612	1	1	2020-08-26 09:02:55.472307
161204	0102	TUMBADEN	1	1612	1	1	2020-08-26 09:02:55.472307
161301	0102	ANDABAMBA	1	1613	1	1	2020-08-26 09:02:55.472307
161302	0102	CATACHE	1	1613	1	1	2020-08-26 09:02:55.472307
161303	0102	CHANCAYBAÑOS	1	1613	1	1	2020-08-26 09:02:55.472307
161304	0102	LA ESPERANZA	1	1613	1	1	2020-08-26 09:02:55.472307
161305	0102	NINABAMBA	1	1613	1	1	2020-08-26 09:02:55.472307
161306	0102	PULAN	1	1613	1	1	2020-08-26 09:02:55.472307
161307	0102	SANTA CRUZ	1	1613	1	1	2020-08-26 09:02:55.472307
161308	0102	SAUCEPAMPA	1	1613	1	1	2020-08-26 09:02:55.472307
161309	0102	SEXI	1	1613	1	1	2020-08-26 09:02:55.472307
161310	0102	UTICYACU	1	1613	1	1	2020-08-26 09:02:55.472307
161311	0102	YAUYUCAN	1	1613	1	1	2020-08-26 09:02:55.472307
170101	0102	BELLAVISTA	1	1701	1	1	2020-08-26 09:02:55.472307
170102	0102	CALLAO	1	1701	1	1	2020-08-26 09:02:55.472307
170103	0102	CARMEN DE LEGUA REYNOSO	1	1701	1	1	2020-08-26 09:02:55.472307
170104	0102	LA PERLA	1	1701	1	1	2020-08-26 09:02:55.472307
170105	0102	LA PUNTA	1	1701	1	1	2020-08-26 09:02:55.472307
170106	0102	VENTANILLA	1	1701	1	1	2020-08-26 09:02:55.472307
180101	0102	ACOMAYO	1	1801	1	1	2020-08-26 09:02:55.472307
180102	0102	ACOPIA	1	1801	1	1	2020-08-26 09:02:55.472307
180103	0102	ACOS	1	1801	1	1	2020-08-26 09:02:55.472307
180104	0102	MOSOC LLACTA	1	1801	1	1	2020-08-26 09:02:55.472307
180105	0102	POMACANCHI	1	1801	1	1	2020-08-26 09:02:55.472307
180106	0102	RONDOCAN	1	1801	1	1	2020-08-26 09:02:55.472307
180107	0102	SANGARARA	1	1801	1	1	2020-08-26 09:02:55.472307
180201	0102	ANCAHUASI	1	1802	1	1	2020-08-26 09:02:55.472307
180202	0102	ANTA	1	1802	1	1	2020-08-26 09:02:55.472307
180203	0102	CACHIMAYO	1	1802	1	1	2020-08-26 09:02:55.472307
180204	0102	CHINCHAYPUJIO	1	1802	1	1	2020-08-26 09:02:55.472307
180205	0102	HUAROCONDO	1	1802	1	1	2020-08-26 09:02:55.472307
180206	0102	LIMATAMBO	1	1802	1	1	2020-08-26 09:02:55.472307
180207	0102	MOLLEPATA	1	1802	1	1	2020-08-26 09:02:55.472307
180208	0102	PUCYURA	1	1802	1	1	2020-08-26 09:02:55.472307
180209	0102	ZURITE	1	1802	1	1	2020-08-26 09:02:55.472307
180301	0102	CALCA	1	1803	1	1	2020-08-26 09:02:55.472307
180302	0102	COYA	1	1803	1	1	2020-08-26 09:02:55.472307
180303	0102	LAMAY	1	1803	1	1	2020-08-26 09:02:55.472307
180304	0102	LARES	1	1803	1	1	2020-08-26 09:02:55.472307
180305	0102	PISAC	1	1803	1	1	2020-08-26 09:02:55.472307
180306	0102	SAN SALVADOR	1	1803	1	1	2020-08-26 09:02:55.472307
180307	0102	TARAY	1	1803	1	1	2020-08-26 09:02:55.472307
180308	0102	YANATILE	1	1803	1	1	2020-08-26 09:02:55.472307
180401	0102	CHECCA	1	1804	1	1	2020-08-26 09:02:55.472307
180402	0102	KUNTURKANKI	1	1804	1	1	2020-08-26 09:02:55.472307
180403	0102	LANGUI	1	1804	1	1	2020-08-26 09:02:55.472307
180404	0102	LAYO	1	1804	1	1	2020-08-26 09:02:55.472307
180405	0102	PAMPAMARCA	1	1804	1	1	2020-08-26 09:02:55.472307
180406	0102	QUEHUE	1	1804	1	1	2020-08-26 09:02:55.472307
180407	0102	TUPAC AMARU	1	1804	1	1	2020-08-26 09:02:55.472307
180408	0102	YANAOCA	1	1804	1	1	2020-08-26 09:02:55.472307
180501	0102	CHECACUPE	1	1805	1	1	2020-08-26 09:02:55.472307
180502	0102	COMBAPATA	1	1805	1	1	2020-08-26 09:02:55.472307
180503	0102	MARANGANI	1	1805	1	1	2020-08-26 09:02:55.472307
180504	0102	PITUMARCA	1	1805	1	1	2020-08-26 09:02:55.472307
180505	0102	SAN PABLO	1	1805	1	1	2020-08-26 09:02:55.472307
180506	0102	SAN PEDRO	1	1805	1	1	2020-08-26 09:02:55.472307
180507	0102	SICUANI	1	1805	1	1	2020-08-26 09:02:55.472307
180508	0102	TINTA	1	1805	1	1	2020-08-26 09:02:55.472307
180601	0102	CAPACMARCA	1	1806	1	1	2020-08-26 09:02:55.472307
180602	0102	CHAMACA	1	1806	1	1	2020-08-26 09:02:55.472307
180603	0102	COLQUEMARCA	1	1806	1	1	2020-08-26 09:02:55.472307
180604	0102	LIVITACA	1	1806	1	1	2020-08-26 09:02:55.472307
180605	0102	LLUSCO	1	1806	1	1	2020-08-26 09:02:55.472307
180606	0102	QUIÑOTA	1	1806	1	1	2020-08-26 09:02:55.472307
180607	0102	SANTO TOMÁS	1	1806	1	1	2020-08-26 09:02:55.472307
180608	0102	VELILLE	1	1806	1	1	2020-08-26 09:02:55.472307
180701	0102	CCORCA	1	1807	1	1	2020-08-26 09:02:55.472307
180702	0102	CUSCO	1	1807	1	1	2020-08-26 09:02:55.472307
180703	0102	POROY	1	1807	1	1	2020-08-26 09:02:55.472307
180704	0102	SAN JERONIMO	1	1807	1	1	2020-08-26 09:02:55.472307
180705	0102	SAN SEBASTIAN	1	1807	1	1	2020-08-26 09:02:55.472307
180706	0102	SANTIAGO	1	1807	1	1	2020-08-26 09:02:55.472307
180707	0102	SAYLLA	1	1807	1	1	2020-08-26 09:02:55.472307
180708	0102	WANCHAQ	1	1807	1	1	2020-08-26 09:02:55.472307
180801	0102	ALTO PICHIGUA	1	1808	1	1	2020-08-26 09:02:55.472307
180802	0102	CONDOROMA	1	1808	1	1	2020-08-26 09:02:55.472307
180803	0102	COPORAQUE	1	1808	1	1	2020-08-26 09:02:55.472307
180804	0102	ESPINAR	1	1808	1	1	2020-08-26 09:02:55.472307
180805	0102	OCORURO	1	1808	1	1	2020-08-26 09:02:55.472307
180806	0102	PALLPATA	1	1808	1	1	2020-08-26 09:02:55.472307
180807	0102	PICHIGUA	1	1808	1	1	2020-08-26 09:02:55.472307
180808	0102	SUYCKUTAMBO	1	1808	1	1	2020-08-26 09:02:55.472307
180901	0102	ECHARATE	1	1809	1	1	2020-08-26 09:02:55.472307
180902	0102	HUAYOPATA	1	1809	1	1	2020-08-26 09:02:55.472307
180903	0102	MARANURA	1	1809	1	1	2020-08-26 09:02:55.472307
180904	0102	OCOBAMBA	1	1809	1	1	2020-08-26 09:02:55.472307
180905	0102	PICHARI	1	1809	1	1	2020-08-26 09:02:55.472307
180906	0102	QUELLOUNO	1	1809	1	1	2020-08-26 09:02:55.472307
180907	0102	QUIMBIRI	1	1809	1	1	2020-08-26 09:02:55.472307
180908	0102	SANTA ANA	1	1809	1	1	2020-08-26 09:02:55.472307
180909	0102	SANTA TERESA	1	1809	1	1	2020-08-26 09:02:55.472307
180910	0102	VILCABAMBA	1	1809	1	1	2020-08-26 09:02:55.472307
181001	0102	ACCHA	1	1810	1	1	2020-08-26 09:02:55.472307
181002	0102	CCAPI	1	1810	1	1	2020-08-26 09:02:55.472307
181003	0102	COLCHA	1	1810	1	1	2020-08-26 09:02:55.472307
181004	0102	HUANOQUITE	1	1810	1	1	2020-08-26 09:02:55.472307
181005	0102	OMACHA	1	1810	1	1	2020-08-26 09:02:55.472307
181006	0102	PACCARITAMBO	1	1810	1	1	2020-08-26 09:02:55.472307
181007	0102	PARURO	1	1810	1	1	2020-08-26 09:02:55.472307
181008	0102	PILLPINTO	1	1810	1	1	2020-08-26 09:02:55.472307
181009	0102	YAURISQUE	1	1810	1	1	2020-08-26 09:02:55.472307
181101	0102	CAICAY	1	1811	1	1	2020-08-26 09:02:55.472307
181102	0102	CHALLABAMBA	1	1811	1	1	2020-08-26 09:02:55.472307
181103	0102	COLQUEPATA	1	1811	1	1	2020-08-26 09:02:55.472307
181104	0102	HUANCARANI	1	1811	1	1	2020-08-26 09:02:55.472307
181105	0102	KOSÑIPATA	1	1811	1	1	2020-08-26 09:02:55.472307
181106	0102	PAUCARTAMBO	1	1811	1	1	2020-08-26 09:02:55.472307
181201	0102	ANDAHUAYLILLAS	1	1812	1	1	2020-08-26 09:02:55.472307
181202	0102	CAMANTI	1	1812	1	1	2020-08-26 09:02:55.472307
181203	0102	CCARHUAYO	1	1812	1	1	2020-08-26 09:02:55.472307
181204	0102	CCATCA	1	1812	1	1	2020-08-26 09:02:55.472307
181205	0102	CUSIPATA	1	1812	1	1	2020-08-26 09:02:55.472307
181206	0102	HUARO	1	1812	1	1	2020-08-26 09:02:55.472307
181207	0102	LUCRE	1	1812	1	1	2020-08-26 09:02:55.472307
181208	0102	MARCAPATA	1	1812	1	1	2020-08-26 09:02:55.472307
181209	0102	OCONGATE	1	1812	1	1	2020-08-26 09:02:55.472307
181210	0102	OROPESA	1	1812	1	1	2020-08-26 09:02:55.472307
181211	0102	QUIQUIJANA	1	1812	1	1	2020-08-26 09:02:55.472307
181212	0102	URCOS	1	1812	1	1	2020-08-26 09:02:55.472307
181301	0102	CHINCHERO	1	1813	1	1	2020-08-26 09:02:55.472307
181302	0102	HUAYLLABAMBA	1	1813	1	1	2020-08-26 09:02:55.472307
181303	0102	MACCHUPICCHU	1	1813	1	1	2020-08-26 09:02:55.472307
181304	0102	MARAS	1	1813	1	1	2020-08-26 09:02:55.472307
181305	0102	OLLANTAYTAMBO	1	1813	1	1	2020-08-26 09:02:55.472307
181306	0102	URUBAMBA	1	1813	1	1	2020-08-26 09:02:55.472307
181307	0102	YUCAY	1	1813	1	1	2020-08-26 09:02:55.472307
190101	0102	ACOBAMBA	1	1901	1	1	2020-08-26 09:02:55.472307
190102	0102	ANDABAMBA	1	1901	1	1	2020-08-26 09:02:55.472307
190103	0102	ANTA	1	1901	1	1	2020-08-26 09:02:55.472307
190104	0102	CAJA	1	1901	1	1	2020-08-26 09:02:55.472307
190105	0102	MARCAS	1	1901	1	1	2020-08-26 09:02:55.472307
190106	0102	PAUCARA	1	1901	1	1	2020-08-26 09:02:55.472307
190107	0102	POMACOCHA	1	1901	1	1	2020-08-26 09:02:55.472307
190108	0102	ROSARIO	1	1901	1	1	2020-08-26 09:02:55.472307
190201	0102	ANCHONGA	1	1902	1	1	2020-08-26 09:02:55.472307
190202	0102	CALLANMARCA	1	1902	1	1	2020-08-26 09:02:55.472307
190203	0102	CCOCHACCASA	1	1902	1	1	2020-08-26 09:02:55.472307
190204	0102	CHINCHO	1	1902	1	1	2020-08-26 09:02:55.472307
190205	0102	CONGALLA	1	1902	1	1	2020-08-26 09:02:55.472307
190206	0102	HUANCA-HUANCA	1	1902	1	1	2020-08-26 09:02:55.472307
190207	0102	HUAYLLAY GRANDE	1	1902	1	1	2020-08-26 09:02:55.472307
190208	0102	JULCAMARCA	1	1902	1	1	2020-08-26 09:02:55.472307
190209	0102	LIRCAY	1	1902	1	1	2020-08-26 09:02:55.472307
190210	0102	SAN ANTONIO DE ANTAPARCO	1	1902	1	1	2020-08-26 09:02:55.472307
190211	0102	SANTO TOMAS DE PATA	1	1902	1	1	2020-08-26 09:02:55.472307
190212	0102	SECCLLA	1	1902	1	1	2020-08-26 09:02:55.472307
190301	0102	ARMA	1	1903	1	1	2020-08-26 09:02:55.472307
190302	0102	AURAHUA	1	1903	1	1	2020-08-26 09:02:55.472307
190303	0102	CAPILLAS	1	1903	1	1	2020-08-26 09:02:55.472307
190304	0102	CASTROVIRREYNA	1	1903	1	1	2020-08-26 09:02:55.472307
190305	0102	CHUPAMARCA	1	1903	1	1	2020-08-26 09:02:55.472307
190306	0102	COCAS	1	1903	1	1	2020-08-26 09:02:55.472307
190307	0102	HUACHOS	1	1903	1	1	2020-08-26 09:02:55.472307
190308	0102	HUAMATAMBO	1	1903	1	1	2020-08-26 09:02:55.472307
190309	0102	MOLLEPAMPA	1	1903	1	1	2020-08-26 09:02:55.472307
190310	0102	SAN JUAN	1	1903	1	1	2020-08-26 09:02:55.472307
190311	0102	SANTA ANA	1	1903	1	1	2020-08-26 09:02:55.472307
190312	0102	TANTARA	1	1903	1	1	2020-08-26 09:02:55.472307
190313	0102	TICRAPO	1	1903	1	1	2020-08-26 09:02:55.472307
190401	0102	ANCO	1	1904	1	1	2020-08-26 09:02:55.472307
190402	0102	CHINCHIHUASI	1	1904	1	1	2020-08-26 09:02:55.472307
190403	0102	CHURCAMPA	1	1904	1	1	2020-08-26 09:02:55.472307
190404	0102	EL CARMEN	1	1904	1	1	2020-08-26 09:02:55.472307
190405	0102	LA MERCED	1	1904	1	1	2020-08-26 09:02:55.472307
190406	0102	LOCROJA	1	1904	1	1	2020-08-26 09:02:55.472307
190407	0102	PACHAMARCA	1	1904	1	1	2020-08-26 09:02:55.472307
190408	0102	PAUCARBAMBA	1	1904	1	1	2020-08-26 09:02:55.472307
190409	0102	SAN MIGUEL DE MAYOCC	1	1904	1	1	2020-08-26 09:02:55.472307
190410	0102	SAN PEDRO DE CORIS	1	1904	1	1	2020-08-26 09:02:55.472307
190501	0102	ACOBAMBILLA	1	1905	1	1	2020-08-26 09:02:55.472307
190502	0102	ACORIA	1	1905	1	1	2020-08-26 09:02:55.472307
190503	0102	ASCENCION	1	1905	1	1	2020-08-26 09:02:55.472307
190504	0102	CONAYCA	1	1905	1	1	2020-08-26 09:02:55.472307
190505	0102	CUENCA	1	1905	1	1	2020-08-26 09:02:55.472307
190506	0102	HUACHOCOLPA	1	1905	1	1	2020-08-26 09:02:55.472307
190507	0102	HUANCAVELICA	1	1905	1	1	2020-08-26 09:02:55.472307
190508	0102	HUANDO	1	1905	1	1	2020-08-26 09:02:55.472307
190509	0102	HUAYLLAHUARA	1	1905	1	1	2020-08-26 09:02:55.472307
190510	0102	IZCUCHACA	1	1905	1	1	2020-08-26 09:02:55.472307
190511	0102	LARIA	1	1905	1	1	2020-08-26 09:02:55.472307
190512	0102	MANTA	1	1905	1	1	2020-08-26 09:02:55.472307
190513	0102	MARISCAL CACERES	1	1905	1	1	2020-08-26 09:02:55.472307
190514	0102	MOYA	1	1905	1	1	2020-08-26 09:02:55.472307
190515	0102	NUEVO OCCORO	1	1905	1	1	2020-08-26 09:02:55.472307
190516	0102	PALCA	1	1905	1	1	2020-08-26 09:02:55.472307
190517	0102	PILCHACA	1	1905	1	1	2020-08-26 09:02:55.472307
190518	0102	VILCA	1	1905	1	1	2020-08-26 09:02:55.472307
190519	0102	YAULI	1	1905	1	1	2020-08-26 09:02:55.472307
190601	0102	AYAVI	1	1906	1	1	2020-08-26 09:02:55.472307
190602	0102	CORDOVA	1	1906	1	1	2020-08-26 09:02:55.472307
190603	0102	HUAYACUNDO ARMA	1	1906	1	1	2020-08-26 09:02:55.472307
190604	0102	HUAYTARÁ	1	1906	1	1	2020-08-26 09:02:55.472307
190605	0102	LARAMARCA	1	1906	1	1	2020-08-26 09:02:55.472307
190606	0102	OCOYO	1	1906	1	1	2020-08-26 09:02:55.472307
190607	0102	PILPICHACA	1	1906	1	1	2020-08-26 09:02:55.472307
190608	0102	QUERCO	1	1906	1	1	2020-08-26 09:02:55.472307
190609	0102	QUITO-ARMA	1	1906	1	1	2020-08-26 09:02:55.472307
190610	0102	SAN ANTONIO DE CUSICANCHA	1	1906	1	1	2020-08-26 09:02:55.472307
190611	0102	SAN FRANCISCO DE SANGAYAICO	1	1906	1	1	2020-08-26 09:02:55.472307
190612	0102	SAN ISIDRO	1	1906	1	1	2020-08-26 09:02:55.472307
190613	0102	SANTIAGO DE CHOCORVOS	1	1906	1	1	2020-08-26 09:02:55.472307
190614	0102	SANTIAGO DE QUIRAHUARA	1	1906	1	1	2020-08-26 09:02:55.472307
190615	0102	SANTO DOMINGO DE CAPILLAS	1	1906	1	1	2020-08-26 09:02:55.472307
190616	0102	TAMBO	1	1906	1	1	2020-08-26 09:02:55.472307
190701	0102	ACOSTAMBO	1	1907	1	1	2020-08-26 09:02:55.472307
190702	0102	ACRAQUIA	1	1907	1	1	2020-08-26 09:02:55.472307
190703	0102	AHUAYCHA	1	1907	1	1	2020-08-26 09:02:55.472307
190704	0102	COLCABAMBA	1	1907	1	1	2020-08-26 09:02:55.472307
190705	0102	DANIEL HERNANDEZ	1	1907	1	1	2020-08-26 09:02:55.472307
190706	0102	HUACHOCOLPA	1	1907	1	1	2020-08-26 09:02:55.472307
190707	0102	HUARIBAMBA	1	1907	1	1	2020-08-26 09:02:55.472307
190708	0102	ÑAHUIMPUQUIO	1	1907	1	1	2020-08-26 09:02:55.472307
190709	0102	PAMPAS	1	1907	1	1	2020-08-26 09:02:55.472307
190710	0102	PAZOS	1	1907	1	1	2020-08-26 09:02:55.472307
190711	0102	QUISHUAR	1	1907	1	1	2020-08-26 09:02:55.472307
190712	0102	SALCABAMBA	1	1907	1	1	2020-08-26 09:02:55.472307
190713	0102	SALCAHUASI	1	1907	1	1	2020-08-26 09:02:55.472307
190714	0102	SAN MARCOS DE ROCCHAC	1	1907	1	1	2020-08-26 09:02:55.472307
190715	0102	SURCUBAMBA	1	1907	1	1	2020-08-26 09:02:55.472307
190716	0102	TINTAYPUNCU	1	1907	1	1	2020-08-26 09:02:55.472307
200101	0102	AMBO	1	2001	1	1	2020-08-26 09:02:55.472307
200102	0102	CAYNA	1	2001	1	1	2020-08-26 09:02:55.472307
200103	0102	COLPAS	1	2001	1	1	2020-08-26 09:02:55.472307
200104	0102	CONCHAMARCA	1	2001	1	1	2020-08-26 09:02:55.472307
200105	0102	HUACAR	1	2001	1	1	2020-08-26 09:02:55.472307
200106	0102	SAN FRANCISCO	1	2001	1	1	2020-08-26 09:02:55.472307
200107	0102	SAN RAFAEL	1	2001	1	1	2020-08-26 09:02:55.472307
200108	0102	TOMAY KICHWA	1	2001	1	1	2020-08-26 09:02:55.472307
200201	0102	CHUQUIS	1	2002	1	1	2020-08-26 09:02:55.472307
200202	0102	LA UNIÓN	1	2002	1	1	2020-08-26 09:02:55.472307
200203	0102	MARIAS	1	2002	1	1	2020-08-26 09:02:55.472307
200204	0102	PACHAS	1	2002	1	1	2020-08-26 09:02:55.472307
200205	0102	QUIVILLA	1	2002	1	1	2020-08-26 09:02:55.472307
200206	0102	RIPAN	1	2002	1	1	2020-08-26 09:02:55.472307
200207	0102	SHUNQUI	1	2002	1	1	2020-08-26 09:02:55.472307
200208	0102	SILLAPATA	1	2002	1	1	2020-08-26 09:02:55.472307
200209	0102	YANAS	1	2002	1	1	2020-08-26 09:02:55.472307
200301	0102	CANCHABAMBA	1	2003	1	1	2020-08-26 09:02:55.472307
200302	0102	COCHABAMBA	1	2003	1	1	2020-08-26 09:02:55.472307
200303	0102	HUACAYBAMBA	1	2003	1	1	2020-08-26 09:02:55.472307
200304	0102	PINRA	1	2003	1	1	2020-08-26 09:02:55.472307
200401	0102	ARANCAY	1	2004	1	1	2020-08-26 09:02:55.472307
200402	0102	CHAVIN DE PARIARCA	1	2004	1	1	2020-08-26 09:02:55.472307
200403	0102	JACAS GRANDE	1	2004	1	1	2020-08-26 09:02:55.472307
200404	0102	JIRCAN	1	2004	1	1	2020-08-26 09:02:55.472307
200405	0102	LLATA	1	2004	1	1	2020-08-26 09:02:55.472307
200406	0102	MIRAFLORES	1	2004	1	1	2020-08-26 09:02:55.472307
200407	0102	MONZON	1	2004	1	1	2020-08-26 09:02:55.472307
200408	0102	PUNCHAO	1	2004	1	1	2020-08-26 09:02:55.472307
200409	0102	PUÑOS	1	2004	1	1	2020-08-26 09:02:55.472307
200410	0102	SINGA	1	2004	1	1	2020-08-26 09:02:55.472307
200411	0102	TANTAMAYO	1	2004	1	1	2020-08-26 09:02:55.472307
200501	0102	AMARILIS	1	2005	1	1	2020-08-26 09:02:55.472307
200502	0102	CHINCHAO	1	2005	1	1	2020-08-26 09:02:55.472307
200503	0102	CHURUBAMBA	1	2005	1	1	2020-08-26 09:02:55.472307
200504	0102	HUÁNUCO	1	2005	1	1	2020-08-26 09:02:55.472307
200505	0102	MARGOS	1	2005	1	1	2020-08-26 09:02:55.472307
200506	0102	PILLCO MARCA	1	2005	1	1	2020-08-26 09:02:55.472307
200507	0102	QUISQUI	1	2005	1	1	2020-08-26 09:02:55.472307
200508	0102	SAN FRANCISCO DE CAYRAN	1	2005	1	1	2020-08-26 09:02:55.472307
200509	0102	SAN PEDRO DE CHAULAN	1	2005	1	1	2020-08-26 09:02:55.472307
200510	0102	SANTA MARIA DEL VALLE	1	2005	1	1	2020-08-26 09:02:55.472307
200511	0102	YARUMAYO	1	2005	1	1	2020-08-26 09:02:55.472307
200601	0102	BAÑOS	1	2006	1	1	2020-08-26 09:02:55.472307
200602	0102	JESÚS	1	2006	1	1	2020-08-26 09:02:55.472307
200603	0102	JIVIA	1	2006	1	1	2020-08-26 09:02:55.472307
200604	0102	QUEROPALCA	1	2006	1	1	2020-08-26 09:02:55.472307
200605	0102	RONDOS	1	2006	1	1	2020-08-26 09:02:55.472307
200606	0102	SAN FRANCISCO DE ASIS	1	2006	1	1	2020-08-26 09:02:55.472307
200607	0102	SAN MIGUEL DE CAURI	1	2006	1	1	2020-08-26 09:02:55.472307
200701	0102	DANIEL ALOMIAS ROBLES	1	2007	1	1	2020-08-26 09:02:55.472307
200702	0102	HERMILIO VALDIZAN	1	2007	1	1	2020-08-26 09:02:55.472307
200703	0102	JOSE CRESPO Y CASTILLO	1	2007	1	1	2020-08-26 09:02:55.472307
200704	0102	LUYANDO	1	2007	1	1	2020-08-26 09:02:55.472307
200705	0102	MARIANO DAMASO BERAUN	1	2007	1	1	2020-08-26 09:02:55.472307
200706	0102	RUPA-RUPA	1	2007	1	1	2020-08-26 09:02:55.472307
200801	0102	CHOLON	1	2008	1	1	2020-08-26 09:02:55.472307
200802	0102	HUACRACHUCO	1	2008	1	1	2020-08-26 09:02:55.472307
200803	0102	SAN BUENAVENTURA	1	2008	1	1	2020-08-26 09:02:55.472307
200901	0102	CHAGLLA	1	2009	1	1	2020-08-26 09:02:55.472307
200902	0102	MOLINO	1	2009	1	1	2020-08-26 09:02:55.472307
200903	0102	PANAO	1	2009	1	1	2020-08-26 09:02:55.472307
200904	0102	UMARI	1	2009	1	1	2020-08-26 09:02:55.472307
201001	0102	CODO DEL POZUZO	1	2010	1	1	2020-08-26 09:02:55.472307
201002	0102	HONORIA	1	2010	1	1	2020-08-26 09:02:55.472307
201003	0102	PUERTO INCA	1	2010	1	1	2020-08-26 09:02:55.472307
201004	0102	TOURNAVISTA	1	2010	1	1	2020-08-26 09:02:55.472307
201005	0102	YUYAPICHIS	1	2010	1	1	2020-08-26 09:02:55.472307
201101	0102	CAHUAC	1	2011	1	1	2020-08-26 09:02:55.472307
201102	0102	CHACABAMBA	1	2011	1	1	2020-08-26 09:02:55.472307
201103	0102	CHAVINILLO	1	2011	1	1	2020-08-26 09:02:55.472307
201104	0102	CHORAS	1	2011	1	1	2020-08-26 09:02:55.472307
201105	0102	CHUPAN	1	2011	1	1	2020-08-26 09:02:55.472307
201106	0102	JACAS CHICO	1	2011	1	1	2020-08-26 09:02:55.472307
201107	0102	OBAS	1	2011	1	1	2020-08-26 09:02:55.472307
201108	0102	PAMPAMARCA	1	2011	1	1	2020-08-26 09:02:55.472307
210101	0102	ALTO LARAN	1	2101	1	1	2020-08-26 09:02:55.472307
210102	0102	CHAVIN	1	2101	1	1	2020-08-26 09:02:55.472307
210103	0102	CHINCHA ALTA	1	2101	1	1	2020-08-26 09:02:55.472307
210104	0102	CHINCHA BAJA	1	2101	1	1	2020-08-26 09:02:55.472307
210105	0102	EL CARMEN	1	2101	1	1	2020-08-26 09:02:55.472307
210106	0102	GROCIO PRADO	1	2101	1	1	2020-08-26 09:02:55.472307
210107	0102	PUEBLO NUEVO	1	2101	1	1	2020-08-26 09:02:55.472307
210108	0102	SAN JUAN DE YANAC	1	2101	1	1	2020-08-26 09:02:55.472307
210109	0102	SAN PEDRO DE HUACARPANA	1	2101	1	1	2020-08-26 09:02:55.472307
210110	0102	SUNAMPE	1	2101	1	1	2020-08-26 09:02:55.472307
210111	0102	TAMBO DE MORA	1	2101	1	1	2020-08-26 09:02:55.472307
210201	0102	ICA	1	2102	1	1	2020-08-26 09:02:55.472307
210202	0102	LA TINGUIÑA	1	2102	1	1	2020-08-26 09:02:55.472307
210203	0102	LOS AQUIJES	1	2102	1	1	2020-08-26 09:02:55.472307
210204	0102	OCUCAJE	1	2102	1	1	2020-08-26 09:02:55.472307
210205	0102	PACHACUTEC	1	2102	1	1	2020-08-26 09:02:55.472307
210206	0102	PARCONA	1	2102	1	1	2020-08-26 09:02:55.472307
210207	0102	PUEBLO NUEVO	1	2102	1	1	2020-08-26 09:02:55.472307
210208	0102	SALAS	1	2102	1	1	2020-08-26 09:02:55.472307
210209	0102	SAN JOSE DE LOS MOLINOS	1	2102	1	1	2020-08-26 09:02:55.472307
210210	0102	SAN JUAN BAUTISTA	1	2102	1	1	2020-08-26 09:02:55.472307
210211	0102	SANTIAGO	1	2102	1	1	2020-08-26 09:02:55.472307
210212	0102	SUBTANJALLA	1	2102	1	1	2020-08-26 09:02:55.472307
210213	0102	TATE	1	2102	1	1	2020-08-26 09:02:55.472307
210214	0102	YAUCA DEL ROSARIO	1	2102	1	1	2020-08-26 09:02:55.472307
210301	0102	CHANGUILLO	1	2103	1	1	2020-08-26 09:02:55.472307
210302	0102	EL INGENIO	1	2103	1	1	2020-08-26 09:02:55.472307
210303	0102	MARCONA	1	2103	1	1	2020-08-26 09:02:55.472307
210304	0102	NAZCA	1	2103	1	1	2020-08-26 09:02:55.472307
210305	0102	VISTA ALEGRE	1	2103	1	1	2020-08-26 09:02:55.472307
210401	0102	LLIPATA	1	2104	1	1	2020-08-26 09:02:55.472307
210402	0102	PALPA	1	2104	1	1	2020-08-26 09:02:55.472307
210403	0102	RIO GRANDE	1	2104	1	1	2020-08-26 09:02:55.472307
210404	0102	SANTA CRUZ	1	2104	1	1	2020-08-26 09:02:55.472307
210405	0102	TIBILLO	1	2104	1	1	2020-08-26 09:02:55.472307
210501	0102	HUANCANO	1	2105	1	1	2020-08-26 09:02:55.472307
210502	0102	HUMAY	1	2105	1	1	2020-08-26 09:02:55.472307
210503	0102	INDEPENDENCIA	1	2105	1	1	2020-08-26 09:02:55.472307
210504	0102	PARACAS	1	2105	1	1	2020-08-26 09:02:55.472307
210505	0102	PISCO	1	2105	1	1	2020-08-26 09:02:55.472307
210506	0102	SAN ANDRES	1	2105	1	1	2020-08-26 09:02:55.472307
210507	0102	SAN CLEMENTE	1	2105	1	1	2020-08-26 09:02:55.472307
210508	0102	TUPAC AMARU INCA	1	2105	1	1	2020-08-26 09:02:55.472307
220101	0102	CHANCHAMAYO	1	2201	1	1	2020-08-26 09:02:55.472307
220102	0102	PERENE	1	2201	1	1	2020-08-26 09:02:55.472307
220103	0102	PICHANAQUI	1	2201	1	1	2020-08-26 09:02:55.472307
220104	0102	SAN LUIS DE SIHUARO	1	2201	1	1	2020-08-26 09:02:55.472307
220105	0102	SAN RAMON	1	2201	1	1	2020-08-26 09:02:55.472307
220106	0102	VITOC	1	2201	1	1	2020-08-26 09:02:55.472307
220201	0102	3 DE OCTUBRE	1	2202	1	1	2020-08-26 09:02:55.472307
220202	0102	AHUAC	1	2202	1	1	2020-08-26 09:02:55.472307
220203	0102	CHONGOS BAJO	1	2202	1	1	2020-08-26 09:02:55.472307
220204	0102	CHUPACA	1	2202	1	1	2020-08-26 09:02:55.472307
220205	0102	HUACHAC	1	2202	1	1	2020-08-26 09:02:55.472307
220206	0102	HUAMANCACA CHICO	1	2202	1	1	2020-08-26 09:02:55.472307
220207	0102	SAN JUAN DE ISCOS	1	2202	1	1	2020-08-26 09:02:55.472307
220208	0102	SAN JUAN DE JARPA	1	2202	1	1	2020-08-26 09:02:55.472307
220209	0102	YANACANCHA	1	2202	1	1	2020-08-26 09:02:55.472307
220301	0102	9 DE JULIO	1	2203	1	1	2020-08-26 09:02:55.472307
220302	0102	ACO	1	2203	1	1	2020-08-26 09:02:55.472307
220303	0102	ANDAMARCA	1	2203	1	1	2020-08-26 09:02:55.472307
220304	0102	CHAMBARA	1	2203	1	1	2020-08-26 09:02:55.472307
220305	0102	COCHAS	1	2203	1	1	2020-08-26 09:02:55.472307
220306	0102	COMAS	1	2203	1	1	2020-08-26 09:02:55.472307
220307	0102	CONCEPCIÓN	1	2203	1	1	2020-08-26 09:02:55.472307
220308	0102	HEROINAS TOLEDO	1	2203	1	1	2020-08-26 09:02:55.472307
220309	0102	MANZANARES	1	2203	1	1	2020-08-26 09:02:55.472307
220310	0102	MARISCAL CASTILLA	1	2203	1	1	2020-08-26 09:02:55.472307
220311	0102	MATAHUASI	1	2203	1	1	2020-08-26 09:02:55.472307
220312	0102	MITO	1	2203	1	1	2020-08-26 09:02:55.472307
220313	0102	ORCOTUNA	1	2203	1	1	2020-08-26 09:02:55.472307
220314	0102	SAN JOSE DE QUERO	1	2203	1	1	2020-08-26 09:02:55.472307
220315	0102	SANTA ROSA DE OCOPA	1	2203	1	1	2020-08-26 09:02:55.472307
220401	0102	CARHUACALLANGA	1	2204	1	1	2020-08-26 09:02:55.472307
220402	0102	CHACAPAMPA	1	2204	1	1	2020-08-26 09:02:55.472307
220403	0102	CHICCHE	1	2204	1	1	2020-08-26 09:02:55.472307
220404	0102	CHILCA	1	2204	1	1	2020-08-26 09:02:55.472307
220405	0102	CHONGOS ALTO	1	2204	1	1	2020-08-26 09:02:55.472307
220406	0102	CHUPURO	1	2204	1	1	2020-08-26 09:02:55.472307
220407	0102	COLCA	1	2204	1	1	2020-08-26 09:02:55.472307
220408	0102	CULLHUAS	1	2204	1	1	2020-08-26 09:02:55.472307
220409	0102	EL TAMBO	1	2204	1	1	2020-08-26 09:02:55.472307
220410	0102	HUACRAPUQUIO	1	2204	1	1	2020-08-26 09:02:55.472307
220411	0102	HUALHUAS	1	2204	1	1	2020-08-26 09:02:55.472307
220412	0102	HUANCAN	1	2204	1	1	2020-08-26 09:02:55.472307
220413	0102	HUANCAYO	1	2204	1	1	2020-08-26 09:02:55.472307
220414	0102	HUASICANCHA	1	2204	1	1	2020-08-26 09:02:55.472307
220415	0102	HUAYUCACHI	1	2204	1	1	2020-08-26 09:02:55.472307
220416	0102	INGENIO	1	2204	1	1	2020-08-26 09:02:55.472307
220417	0102	PARIAHUANCA	1	2204	1	1	2020-08-26 09:02:55.472307
220418	0102	PILCOMAYO	1	2204	1	1	2020-08-26 09:02:55.472307
220419	0102	PUCARA	1	2204	1	1	2020-08-26 09:02:55.472307
220420	0102	QUICHUAY	1	2204	1	1	2020-08-26 09:02:55.472307
220421	0102	QUILCAS	1	2204	1	1	2020-08-26 09:02:55.472307
220422	0102	SAN AGUSTIN	1	2204	1	1	2020-08-26 09:02:55.472307
220423	0102	SAN JERONIMO DE TUNAN	1	2204	1	1	2020-08-26 09:02:55.472307
220424	0102	SAÑO	1	2204	1	1	2020-08-26 09:02:55.472307
220425	0102	SANTO DOMINGO DE ACOBAMBA	1	2204	1	1	2020-08-26 09:02:55.472307
220426	0102	SAPALLANGA	1	2204	1	1	2020-08-26 09:02:55.472307
220427	0102	SICAYA	1	2204	1	1	2020-08-26 09:02:55.472307
220428	0102	VIQUES	1	2204	1	1	2020-08-26 09:02:55.472307
220501	0102	ACOLLA	1	2205	1	1	2020-08-26 09:02:55.472307
220502	0102	APATA	1	2205	1	1	2020-08-26 09:02:55.472307
220503	0102	ATAURA	1	2205	1	1	2020-08-26 09:02:55.472307
220504	0102	CHANCAYLLO	1	2205	1	1	2020-08-26 09:02:55.472307
220505	0102	CURICACA	1	2205	1	1	2020-08-26 09:02:55.472307
220506	0102	EL MANTARO	1	2205	1	1	2020-08-26 09:02:55.472307
220507	0102	HUAMALI	1	2205	1	1	2020-08-26 09:02:55.472307
220508	0102	HUARIPAMPA	1	2205	1	1	2020-08-26 09:02:55.472307
220509	0102	HUERTAS	1	2205	1	1	2020-08-26 09:02:55.472307
220510	0102	JANJAILLO	1	2205	1	1	2020-08-26 09:02:55.472307
220511	0102	JAUJA	1	2205	1	1	2020-08-26 09:02:55.472307
220512	0102	JULCAN	1	2205	1	1	2020-08-26 09:02:55.472307
220513	0102	LEONOR ORDOÑEZ	1	2205	1	1	2020-08-26 09:02:55.472307
220514	0102	LLOCLLAPAMPA	1	2205	1	1	2020-08-26 09:02:55.472307
220515	0102	MARCO	1	2205	1	1	2020-08-26 09:02:55.472307
220516	0102	MASMA	1	2205	1	1	2020-08-26 09:02:55.472307
220517	0102	MASMA CHICCHE	1	2205	1	1	2020-08-26 09:02:55.472307
220518	0102	MOLINOS	1	2205	1	1	2020-08-26 09:02:55.472307
220519	0102	MONOBAMBA	1	2205	1	1	2020-08-26 09:02:55.472307
220520	0102	MUQUI	1	2205	1	1	2020-08-26 09:02:55.472307
220521	0102	MUQUIYAUYO	1	2205	1	1	2020-08-26 09:02:55.472307
220523	0102	PACCHA	1	2205	1	1	2020-08-26 09:02:55.472307
220524	0102	PANCAN	1	2205	1	1	2020-08-26 09:02:55.472307
220525	0102	PARCO	1	2205	1	1	2020-08-26 09:02:55.472307
220526	0102	POMACANCHA	1	2205	1	1	2020-08-26 09:02:55.472307
220527	0102	RICRAN	1	2205	1	1	2020-08-26 09:02:55.472307
220528	0102	SAN LORENZO	1	2205	1	1	2020-08-26 09:02:55.472307
220529	0102	SAN PEDRO DE CHUNAN	1	2205	1	1	2020-08-26 09:02:55.472307
220530	0102	SAUSA	1	2205	1	1	2020-08-26 09:02:55.472307
220531	0102	SINCOS	1	2205	1	1	2020-08-26 09:02:55.472307
220532	0102	TUNAN MARCA	1	2205	1	1	2020-08-26 09:02:55.472307
220533	0102	YAULI	1	2205	1	1	2020-08-26 09:02:55.472307
220534	0102	YAUYOS	1	2205	1	1	2020-08-26 09:02:55.472307
220601	0102	CARHUAMAYO	1	2206	1	1	2020-08-26 09:02:55.472307
220602	0102	JUNIN	1	2206	1	1	2020-08-26 09:02:55.472307
220603	0102	ONDORES	1	2206	1	1	2020-08-26 09:02:55.472307
220604	0102	ULCUMAYO	1	2206	1	1	2020-08-26 09:02:55.472307
220701	0102	COVIRIALI	1	2207	1	1	2020-08-26 09:02:55.472307
220702	0102	LLAYLLA	1	2207	1	1	2020-08-26 09:02:55.472307
220703	0102	MAZAMARI	1	2207	1	1	2020-08-26 09:02:55.472307
220704	0102	PAMPA HERMOSA	1	2207	1	1	2020-08-26 09:02:55.472307
220705	0102	PANGOA	1	2207	1	1	2020-08-26 09:02:55.472307
220706	0102	RIO NEGRO	1	2207	1	1	2020-08-26 09:02:55.472307
220707	0102	RIO TAMBO	1	2207	1	1	2020-08-26 09:02:55.472307
220708	0102	SATIPO	1	2207	1	1	2020-08-26 09:02:55.472307
220801	0102	ACOBAMBA	1	2208	1	1	2020-08-26 09:02:55.472307
220802	0102	HUARICOLCA	1	2208	1	1	2020-08-26 09:02:55.472307
220803	0102	HUASAHUASI	1	2208	1	1	2020-08-26 09:02:55.472307
220804	0102	LA UNION	1	2208	1	1	2020-08-26 09:02:55.472307
220805	0102	PALCA	1	2208	1	1	2020-08-26 09:02:55.472307
220806	0102	PALCAMAYO	1	2208	1	1	2020-08-26 09:02:55.472307
220807	0102	SAN PEDRO DE CAJAS	1	2208	1	1	2020-08-26 09:02:55.472307
220808	0102	TAPO	1	2208	1	1	2020-08-26 09:02:55.472307
220809	0102	TARMA	1	2208	1	1	2020-08-26 09:02:55.472307
220901	0102	CHACAPALPA	1	2209	1	1	2020-08-26 09:02:55.472307
220902	0102	HUAY-HUAY	1	2209	1	1	2020-08-26 09:02:55.472307
220903	0102	LA OROYA	1	2209	1	1	2020-08-26 09:02:55.472307
220904	0102	MARCAPOMACOCHA	1	2209	1	1	2020-08-26 09:02:55.472307
220905	0102	MOROCOCHA	1	2209	1	1	2020-08-26 09:02:55.472307
220906	0102	PACCHA	1	2209	1	1	2020-08-26 09:02:55.472307
220907	0102	SANTA BARBARA DE CARHUACAYAN	1	2209	1	1	2020-08-26 09:02:55.472307
220908	0102	SANTA ROSA DE SACCO	1	2209	1	1	2020-08-26 09:02:55.472307
220909	0102	SUITUCANCHA	1	2209	1	1	2020-08-26 09:02:55.472307
220910	0102	YAULI	1	2209	1	1	2020-08-26 09:02:55.472307
230101	0102	ASCOPE	1	2301	1	1	2020-08-26 09:02:55.472307
230102	0102	CASA GRANDE	1	2301	1	1	2020-08-26 09:02:55.472307
230103	0102	CHICAMA	1	2301	1	1	2020-08-26 09:02:55.472307
230104	0102	CHOCOPE	1	2301	1	1	2020-08-26 09:02:55.472307
230105	0102	MAGDALENA DE CAO	1	2301	1	1	2020-08-26 09:02:55.472307
230106	0102	PAIJAN	1	2301	1	1	2020-08-26 09:02:55.472307
230107	0102	RAZURI	1	2301	1	1	2020-08-26 09:02:55.472307
230108	0102	SANTIAGO DE CAO	1	2301	1	1	2020-08-26 09:02:55.472307
230201	0102	BAMBAMARCA	1	2302	1	1	2020-08-26 09:02:55.472307
230202	0102	BOLIVAR	1	2302	1	1	2020-08-26 09:02:55.472307
230203	0102	CONDORMARCA	1	2302	1	1	2020-08-26 09:02:55.472307
230204	0102	LONGOTEA	1	2302	1	1	2020-08-26 09:02:55.472307
230205	0102	UCHUMARCA	1	2302	1	1	2020-08-26 09:02:55.472307
230206	0102	UCUNCHA	1	2302	1	1	2020-08-26 09:02:55.472307
230301	0102	CHEPÉN	1	2303	1	1	2020-08-26 09:02:55.472307
230302	0102	PACANGA	1	2303	1	1	2020-08-26 09:02:55.472307
230303	0102	PUEBLO NUEVO	1	2303	1	1	2020-08-26 09:02:55.472307
230401	0102	CASCAS	1	2304	1	1	2020-08-26 09:02:55.472307
230402	0102	LUCMA	1	2304	1	1	2020-08-26 09:02:55.472307
230403	0102	MARMOT	1	2304	1	1	2020-08-26 09:02:55.472307
230404	0102	SAYAPULLO	1	2304	1	1	2020-08-26 09:02:55.472307
230501	0102	CALAMARCA	1	2305	1	1	2020-08-26 09:02:55.472307
230502	0102	CARABAMBA	1	2305	1	1	2020-08-26 09:02:55.472307
230503	0102	HUASO	1	2305	1	1	2020-08-26 09:02:55.472307
230504	0102	JULCÁN	1	2305	1	1	2020-08-26 09:02:55.472307
230601	0102	AGALLPAMPA	1	2306	1	1	2020-08-26 09:02:55.472307
230602	0102	CHARAT	1	2306	1	1	2020-08-26 09:02:55.472307
230603	0102	HUARANCHAL	1	2306	1	1	2020-08-26 09:02:55.472307
230604	0102	LA CUESTA	1	2306	1	1	2020-08-26 09:02:55.472307
230605	0102	MACHE	1	2306	1	1	2020-08-26 09:02:55.472307
230606	0102	OTUZCO	1	2306	1	1	2020-08-26 09:02:55.472307
230607	0102	PARANDAY	1	2306	1	1	2020-08-26 09:02:55.472307
230608	0102	SALPO	1	2306	1	1	2020-08-26 09:02:55.472307
230609	0102	SINSICAP	1	2306	1	1	2020-08-26 09:02:55.472307
230610	0102	USQUIL	1	2306	1	1	2020-08-26 09:02:55.472307
230701	0102	GUADALUPE	1	2307	1	1	2020-08-26 09:02:55.472307
230702	0102	JEQUETEPEQUE	1	2307	1	1	2020-08-26 09:02:55.472307
230703	0102	PACASMAYO	1	2307	1	1	2020-08-26 09:02:55.472307
230704	0102	SAN JOSE	1	2307	1	1	2020-08-26 09:02:55.472307
230705	0102	SAN PEDRO DE LLOC	1	2307	1	1	2020-08-26 09:02:55.472307
230801	0102	BULDIBUYO	1	2308	1	1	2020-08-26 09:02:55.472307
230802	0102	CHILLIA	1	2308	1	1	2020-08-26 09:02:55.472307
230803	0102	HUANCASPATA	1	2308	1	1	2020-08-26 09:02:55.472307
230804	0102	HUAYLILLAS	1	2308	1	1	2020-08-26 09:02:55.472307
230805	0102	HUAYO	1	2308	1	1	2020-08-26 09:02:55.472307
230806	0102	ONGON	1	2308	1	1	2020-08-26 09:02:55.472307
230807	0102	PARCOY	1	2308	1	1	2020-08-26 09:02:55.472307
230808	0102	PATAZ	1	2308	1	1	2020-08-26 09:02:55.472307
230809	0102	PIAS	1	2308	1	1	2020-08-26 09:02:55.472307
230810	0102	SANTIAGO DE CHALLAS	1	2308	1	1	2020-08-26 09:02:55.472307
230811	0102	TAURIJA	1	2308	1	1	2020-08-26 09:02:55.472307
230812	0102	TAYABAMBA	1	2308	1	1	2020-08-26 09:02:55.472307
230813	0102	URPAY	1	2308	1	1	2020-08-26 09:02:55.472307
230901	0102	CHUGAY	1	2309	1	1	2020-08-26 09:02:55.472307
230902	0102	COCHORCO	1	2309	1	1	2020-08-26 09:02:55.472307
230903	0102	CURGOS	1	2309	1	1	2020-08-26 09:02:55.472307
230904	0102	HUAMACHUCO	1	2309	1	1	2020-08-26 09:02:55.472307
230905	0102	MARCABAL	1	2309	1	1	2020-08-26 09:02:55.472307
230906	0102	SANAGORAN	1	2309	1	1	2020-08-26 09:02:55.472307
230907	0102	SARIN	1	2309	1	1	2020-08-26 09:02:55.472307
230908	0102	SARTIMBAMBA	1	2309	1	1	2020-08-26 09:02:55.472307
231001	0102	ANGASMARCA	1	2310	1	1	2020-08-26 09:02:55.472307
231002	0102	CACHICADAN	1	2310	1	1	2020-08-26 09:02:55.472307
231003	0102	MOLLEBAMBA	1	2310	1	1	2020-08-26 09:02:55.472307
231004	0102	MOLLEPATA	1	2310	1	1	2020-08-26 09:02:55.472307
231005	0102	QUIRUVILCA	1	2310	1	1	2020-08-26 09:02:55.472307
231006	0102	SANTA CRUZ DE CHUCA	1	2310	1	1	2020-08-26 09:02:55.472307
231007	0102	SANTIAGO DE CHUCO	1	2310	1	1	2020-08-26 09:02:55.472307
231008	0102	SITABAMBA	1	2310	1	1	2020-08-26 09:02:55.472307
231101	0102	EL PORVENIR	1	2311	1	1	2020-08-26 09:02:55.472307
231102	0102	FLORENCIA DE MORA	1	2311	1	1	2020-08-26 09:02:55.472307
231103	0102	HUANCHACO	1	2311	1	1	2020-08-26 09:02:55.472307
231104	0102	LA ESPERANZA	1	2311	1	1	2020-08-26 09:02:55.472307
231105	0102	LAREDO	1	2311	1	1	2020-08-26 09:02:55.472307
231106	0102	MOCHE	1	2311	1	1	2020-08-26 09:02:55.472307
231107	0102	POROTO	1	2311	1	1	2020-08-26 09:02:55.472307
231108	0102	SALAVERRY	1	2311	1	1	2020-08-26 09:02:55.472307
231109	0102	SIMBAL	1	2311	1	1	2020-08-26 09:02:55.472307
231110	0102	TRUJILLO	1	2311	1	1	2020-08-26 09:02:55.472307
231111	0102	VICTOR LARCO HERRERA	1	2311	1	1	2020-08-26 09:02:55.472307
231201	0102	CHAO	1	2312	1	1	2020-08-26 09:02:55.472307
231202	0102	GUADALUPITO	1	2312	1	1	2020-08-26 09:02:55.472307
231203	0102	VIRÚ	1	2312	1	1	2020-08-26 09:02:55.472307
240101	0102	CAYALTI	1	2401	1	1	2020-08-26 09:02:55.472307
240102	0102	CHICLAYO	1	2401	1	1	2020-08-26 09:02:55.472307
240103	0102	CHONGOYAPE	1	2401	1	1	2020-08-26 09:02:55.472307
240104	0102	ETEN	1	2401	1	1	2020-08-26 09:02:55.472307
240105	0102	ETEN PUERTO	1	2401	1	1	2020-08-26 09:02:55.472307
240106	0102	JOSE LEONARDO ORTIZ	1	2401	1	1	2020-08-26 09:02:55.472307
240107	0102	LA VICTORIA	1	2401	1	1	2020-08-26 09:02:55.472307
240108	0102	LAGUNAS	1	2401	1	1	2020-08-26 09:02:55.472307
240109	0102	MONSEFU	1	2401	1	1	2020-08-26 09:02:55.472307
240110	0102	NUEVA ARICA	1	2401	1	1	2020-08-26 09:02:55.472307
240111	0102	OYOTUN	1	2401	1	1	2020-08-26 09:02:55.472307
240112	0102	PATAPO	1	2401	1	1	2020-08-26 09:02:55.472307
240113	0102	PICSI	1	2401	1	1	2020-08-26 09:02:55.472307
240114	0102	PIMENTEL	1	2401	1	1	2020-08-26 09:02:55.472307
240115	0102	POMALCA	1	2401	1	1	2020-08-26 09:02:55.472307
240116	0102	PUCALA	1	2401	1	1	2020-08-26 09:02:55.472307
240117	0102	REQUE	1	2401	1	1	2020-08-26 09:02:55.472307
240118	0102	SAÑA	1	2401	1	1	2020-08-26 09:02:55.472307
240119	0102	SANTA ROSA	1	2401	1	1	2020-08-26 09:02:55.472307
240120	0102	TUMAN	1	2401	1	1	2020-08-26 09:02:55.472307
240201	0102	CAÑARIS	1	2402	1	1	2020-08-26 09:02:55.472307
240202	0102	FERREÑAFE	1	2402	1	1	2020-08-26 09:02:55.472307
240203	0102	INCAHUASI	1	2402	1	1	2020-08-26 09:02:55.472307
240204	0102	PITIPO	1	2402	1	1	2020-08-26 09:02:55.472307
240205	0102	PUEBLO NUEVO	1	2402	1	1	2020-08-26 09:02:55.472307
240301	0102	CHOCHOPE	1	2403	1	1	2020-08-26 09:02:55.472307
240302	0102	ILLIMO	1	2403	1	1	2020-08-26 09:02:55.472307
240303	0102	JAYANCA	1	2403	1	1	2020-08-26 09:02:55.472307
240304	0102	LAMBAYEQUE	1	2403	1	1	2020-08-26 09:02:55.472307
240305	0102	MOCHUMI	1	2403	1	1	2020-08-26 09:02:55.472307
240306	0102	MORROPE	1	2403	1	1	2020-08-26 09:02:55.472307
240307	0102	MOTUPE	1	2403	1	1	2020-08-26 09:02:55.472307
240308	0102	OLMOS	1	2403	1	1	2020-08-26 09:02:55.472307
240309	0102	PACORA	1	2403	1	1	2020-08-26 09:02:55.472307
240310	0102	SALAS	1	2403	1	1	2020-08-26 09:02:55.472307
240311	0102	SAN JOSE	1	2403	1	1	2020-08-26 09:02:55.472307
240312	0102	TUCUME	1	2403	1	1	2020-08-26 09:02:55.472307
250101	0102	BARRANCA	1	2501	1	1	2020-08-26 09:02:55.472307
250102	0102	PARAMONGA	1	2501	1	1	2020-08-26 09:02:55.472307
250103	0102	PATIVILCA	1	2501	1	1	2020-08-26 09:02:55.472307
250104	0102	SUPE	1	2501	1	1	2020-08-26 09:02:55.472307
250105	0102	SUPE PUERTO	1	2501	1	1	2020-08-26 09:02:55.472307
250201	0102	CAJATAMBO	1	2502	1	1	2020-08-26 09:02:55.472307
250202	0102	COPA	1	2502	1	1	2020-08-26 09:02:55.472307
250203	0102	GORGOR	1	2502	1	1	2020-08-26 09:02:55.472307
250204	0102	HUANCAPON	1	2502	1	1	2020-08-26 09:02:55.472307
250205	0102	MANAS	1	2502	1	1	2020-08-26 09:02:55.472307
250301	0102	ARAHUAY	1	2503	1	1	2020-08-26 09:02:55.472307
250302	0102	CANTA	1	2503	1	1	2020-08-26 09:02:55.472307
250303	0102	HUAMANTANGA	1	2503	1	1	2020-08-26 09:02:55.472307
250304	0102	HUAROS	1	2503	1	1	2020-08-26 09:02:55.472307
250305	0102	LACHAQUI	1	2503	1	1	2020-08-26 09:02:55.472307
250306	0102	SAN BUENAVENTURA	1	2503	1	1	2020-08-26 09:02:55.472307
250307	0102	SANTA ROSA DE QUIVES	1	2503	1	1	2020-08-26 09:02:55.472307
250401	0102	27 DE NOVIEMBRE	1	2504	1	1	2020-08-26 09:02:55.472307
250402	0102	ATAVILLOS ALTO	1	2504	1	1	2020-08-26 09:02:55.472307
250403	0102	ATAVILLOS BAJO	1	2504	1	1	2020-08-26 09:02:55.472307
250404	0102	AUCALLAMA	1	2504	1	1	2020-08-26 09:02:55.472307
250405	0102	CHANCAY	1	2504	1	1	2020-08-26 09:02:55.472307
250406	0102	HUARAL	1	2504	1	1	2020-08-26 09:02:55.472307
250407	0102	IHUARI	1	2504	1	1	2020-08-26 09:02:55.472307
250408	0102	LAMPIAN	1	2504	1	1	2020-08-26 09:02:55.472307
250409	0102	PACARAOS	1	2504	1	1	2020-08-26 09:02:55.472307
250410	0102	SAN MIGUEL DE ACOS	1	2504	1	1	2020-08-26 09:02:55.472307
250411	0102	SANTA CRUZ DE ANDAMARCA	1	2504	1	1	2020-08-26 09:02:55.472307
250412	0102	SUMBILCA	1	2504	1	1	2020-08-26 09:02:55.472307
250501	0102	ANTIOQUIA	1	2505	1	1	2020-08-26 09:02:55.472307
250502	0102	CALLAHUANCA	1	2505	1	1	2020-08-26 09:02:55.472307
250503	0102	CARAMPOMA	1	2505	1	1	2020-08-26 09:02:55.472307
250504	0102	CHICLA	1	2505	1	1	2020-08-26 09:02:55.472307
250505	0102	CUENCA	1	2505	1	1	2020-08-26 09:02:55.472307
250506	0102	HUACHUPAMPA	1	2505	1	1	2020-08-26 09:02:55.472307
250507	0102	HUANZA	1	2505	1	1	2020-08-26 09:02:55.472307
250508	0102	HUAROCHIRI	1	2505	1	1	2020-08-26 09:02:55.472307
250509	0102	LAHUAYTAMBO	1	2505	1	1	2020-08-26 09:02:55.472307
250510	0102	LANGA	1	2505	1	1	2020-08-26 09:02:55.472307
250511	0102	LARAOS	1	2505	1	1	2020-08-26 09:02:55.472307
250512	0102	MARIATANA	1	2505	1	1	2020-08-26 09:02:55.472307
250513	0102	MATUCANA	1	2505	1	1	2020-08-26 09:02:55.472307
250514	0102	RICARDO PALMA	1	2505	1	1	2020-08-26 09:02:55.472307
250515	0102	SAN ANDRES DE TUPICOCHA	1	2505	1	1	2020-08-26 09:02:55.472307
250516	0102	SAN ANTONIO	1	2505	1	1	2020-08-26 09:02:55.472307
250517	0102	SAN BARTOLOME	1	2505	1	1	2020-08-26 09:02:55.472307
250518	0102	SAN DAMIAN	1	2505	1	1	2020-08-26 09:02:55.472307
250519	0102	SAN JUAN DE IRIS	1	2505	1	1	2020-08-26 09:02:55.472307
250520	0102	SAN JUAN DE TANTARANCHE	1	2505	1	1	2020-08-26 09:02:55.472307
250521	0102	SAN LORENZO DE QUINTI	1	2505	1	1	2020-08-26 09:02:55.472307
250522	0102	SAN MATEO	1	2505	1	1	2020-08-26 09:02:55.472307
250523	0102	SAN MATEO DE OTAO	1	2505	1	1	2020-08-26 09:02:55.472307
250524	0102	SAN PEDRO DE CASTA	1	2505	1	1	2020-08-26 09:02:55.472307
250525	0102	SAN PEDRO DE HUANCAYRE	1	2505	1	1	2020-08-26 09:02:55.472307
250526	0102	SANGALLAYA	1	2505	1	1	2020-08-26 09:02:55.472307
250527	0102	SANTA CRUZ DE COCACHACRA	1	2505	1	1	2020-08-26 09:02:55.472307
250528	0102	SANTA EULALIA	1	2505	1	1	2020-08-26 09:02:55.472307
250529	0102	SANTIAGO DE ANCHUCAYA	1	2505	1	1	2020-08-26 09:02:55.472307
250530	0102	SANTIAGO DE TUNA	1	2505	1	1	2020-08-26 09:02:55.472307
250531	0102	SANTO DOMINGO DE LOS OLLEROS	1	2505	1	1	2020-08-26 09:02:55.472307
250532	0102	SURCO	1	2505	1	1	2020-08-26 09:02:55.472307
250601	0102	AMBAR	1	2506	1	1	2020-08-26 09:02:55.472307
250602	0102	CALETA DE CARQUIN	1	2506	1	1	2020-08-26 09:02:55.472307
250603	0102	CHECRAS	1	2506	1	1	2020-08-26 09:02:55.472307
250604	0102	HUACHO	1	2506	1	1	2020-08-26 09:02:55.472307
250605	0102	HUALMAY	1	2506	1	1	2020-08-26 09:02:55.472307
250606	0102	HUAURA	1	2506	1	1	2020-08-26 09:02:55.472307
250607	0102	LEONCIO PRADO	1	2506	1	1	2020-08-26 09:02:55.472307
250608	0102	PACCHO	1	2506	1	1	2020-08-26 09:02:55.472307
250609	0102	SANTA LEONOR	1	2506	1	1	2020-08-26 09:02:55.472307
250610	0102	SANTA MARIA	1	2506	1	1	2020-08-26 09:02:55.472307
250611	0102	SAYAN	1	2506	1	1	2020-08-26 09:02:55.472307
250612	0102	VEGUETA	1	2506	1	1	2020-08-26 09:02:55.472307
250701	0102	ANCON	1	2507	1	1	2020-08-26 09:02:55.472307
250702	0102	ATE	1	2507	1	1	2020-08-26 09:02:55.472307
250703	0102	BARRANCO	1	2507	1	1	2020-08-26 09:02:55.472307
250704	0102	BREÑA	1	2507	1	1	2020-08-26 09:02:55.472307
250705	0102	CARABAYLLO	1	2507	1	1	2020-08-26 09:02:55.472307
250706	0102	CHACLACAYO	1	2507	1	1	2020-08-26 09:02:55.472307
250707	0102	CHORILLOS	1	2507	1	1	2020-08-26 09:02:55.472307
250708	0102	CIENEGUILLA	1	2507	1	1	2020-08-26 09:02:55.472307
250709	0102	COMAS	1	2507	1	1	2020-08-26 09:02:55.472307
250710	0102	EL AGUSTINO	1	2507	1	1	2020-08-26 09:02:55.472307
250711	0102	INDEPENDENCIA	1	2507	1	1	2020-08-26 09:02:55.472307
250712	0102	JESUS MARIA	1	2507	1	1	2020-08-26 09:02:55.472307
250713	0102	LA MOLINA	1	2507	1	1	2020-08-26 09:02:55.472307
250714	0102	LA VICTORIA	1	2507	1	1	2020-08-26 09:02:55.472307
250715	0102	LIMA	1	2507	1	1	2020-08-26 09:02:55.472307
250716	0102	LINCE	1	2507	1	1	2020-08-26 09:02:55.472307
250717	0102	LOS OLIVOS	1	2507	1	1	2020-08-26 09:02:55.472307
250718	0102	LURIGANCHO	1	2507	1	1	2020-08-26 09:02:55.472307
250719	0102	LURIN	1	2507	1	1	2020-08-26 09:02:55.472307
250720	0102	MAGDALENA DEL MAR	1	2507	1	1	2020-08-26 09:02:55.472307
250721	0102	MAGDALENA VIEJA	1	2507	1	1	2020-08-26 09:02:55.472307
250722	0102	MIRAFLORES	1	2507	1	1	2020-08-26 09:02:55.472307
250723	0102	PACHACAMAC	1	2507	1	1	2020-08-26 09:02:55.472307
250724	0102	PUCUSANA	1	2507	1	1	2020-08-26 09:02:55.472307
250725	0102	PUENTE PIEDRA	1	2507	1	1	2020-08-26 09:02:55.472307
250726	0102	PUNTA HERMOSA	1	2507	1	1	2020-08-26 09:02:55.472307
250727	0102	PUNTA NEGRA	1	2507	1	1	2020-08-26 09:02:55.472307
250728	0102	RIMAC	1	2507	1	1	2020-08-26 09:02:55.472307
250729	0102	SAN BARTOLO	1	2507	1	1	2020-08-26 09:02:55.472307
250730	0102	SAN BORJA	1	2507	1	1	2020-08-26 09:02:55.472307
250731	0102	SAN ISIDRO	1	2507	1	1	2020-08-26 09:02:55.472307
250732	0102	SAN JUAN DE LURIGANCHO	1	2507	1	1	2020-08-26 09:02:55.472307
250733	0102	SAN JUAN DE MIRAFLORES	1	2507	1	1	2020-08-26 09:02:55.472307
250734	0102	SAN LUIS	1	2507	1	1	2020-08-26 09:02:55.472307
250735	0102	SAN MARTIN DE PORRES	1	2507	1	1	2020-08-26 09:02:55.472307
250736	0102	SAN MIGUEL	1	2507	1	1	2020-08-26 09:02:55.472307
250737	0102	SANTA ANITA	1	2507	1	1	2020-08-26 09:02:55.472307
250738	0102	SANTA MARIA DEL MAR	1	2507	1	1	2020-08-26 09:02:55.472307
250739	0102	SANTA ROSA	1	2507	1	1	2020-08-26 09:02:55.472307
250740	0102	SANTIAGO DE SURCO	1	2507	1	1	2020-08-26 09:02:55.472307
250741	0102	SURQUILLO	1	2507	1	1	2020-08-26 09:02:55.472307
250742	0102	VILLA EL SALVADOR	1	2507	1	1	2020-08-26 09:02:55.472307
250743	0102	VILLA MARIA DEL TRIUNFO	1	2507	1	1	2020-08-26 09:02:55.472307
250801	0102	ANDAJES	1	2508	1	1	2020-08-26 09:02:55.472307
250802	0102	CAUJUL	1	2508	1	1	2020-08-26 09:02:55.472307
250803	0102	COCHAMARCA	1	2508	1	1	2020-08-26 09:02:55.472307
250804	0102	NAVAN	1	2508	1	1	2020-08-26 09:02:55.472307
250805	0102	OYÓN	1	2508	1	1	2020-08-26 09:02:55.472307
250806	0102	PACHANGARA	1	2508	1	1	2020-08-26 09:02:55.472307
250901	0102	SAN VICENTE DE CAÑETE	1	2509	1	1	2020-08-26 09:02:55.472307
250902	0102	ASIA	1	2509	1	1	2020-08-26 09:02:55.472307
250903	0102	CALANGO	1	2509	1	1	2020-08-26 09:02:55.472307
250904	0102	CERRO AZUL	1	2509	1	1	2020-08-26 09:02:55.472307
250905	0102	CHILCA	1	2509	1	1	2020-08-26 09:02:55.472307
250906	0102	COAYLLO	1	2509	1	1	2020-08-26 09:02:55.472307
250907	0102	IMPERIAL	1	2509	1	1	2020-08-26 09:02:55.472307
250908	0102	LUNAHUANA	1	2509	1	1	2020-08-26 09:02:55.472307
250909	0102	MALA	1	2509	1	1	2020-08-26 09:02:55.472307
250910	0102	NUEVO IMPERIAL	1	2509	1	1	2020-08-26 09:02:55.472307
250911	0102	PACARAN	1	2509	1	1	2020-08-26 09:02:55.472307
250912	0102	QUILMANA	1	2509	1	1	2020-08-26 09:02:55.472307
250913	0102	SAN ANTONIO	1	2509	1	1	2020-08-26 09:02:55.472307
250914	0102	SAN LUIS	1	2509	1	1	2020-08-26 09:02:55.472307
250915	0102	SANTA CRUZ DE FLORES	1	2509	1	1	2020-08-26 09:02:55.472307
250916	0102	ZUÑIGA	1	2509	1	1	2020-08-26 09:02:55.472307
251001	0102	ALIS	1	2510	1	1	2020-08-26 09:02:55.472307
251002	0102	AYAUCA	1	2510	1	1	2020-08-26 09:02:55.472307
251003	0102	AYAVIRI	1	2510	1	1	2020-08-26 09:02:55.472307
251004	0102	AZANGARO	1	2510	1	1	2020-08-26 09:02:55.472307
251005	0102	CACRA	1	2510	1	1	2020-08-26 09:02:55.472307
251006	0102	CARANIA	1	2510	1	1	2020-08-26 09:02:55.472307
251007	0102	CATAHUASI	1	2510	1	1	2020-08-26 09:02:55.472307
251008	0102	CHOCOS	1	2510	1	1	2020-08-26 09:02:55.472307
251009	0102	COCHAS	1	2510	1	1	2020-08-26 09:02:55.472307
251010	0102	COLONIA	1	2510	1	1	2020-08-26 09:02:55.472307
251011	0102	HONGOS	1	2510	1	1	2020-08-26 09:02:55.472307
251012	0102	HUAMPARA	1	2510	1	1	2020-08-26 09:02:55.472307
251013	0102	HUANCAYA	1	2510	1	1	2020-08-26 09:02:55.472307
251014	0102	HUAÑEC	1	2510	1	1	2020-08-26 09:02:55.472307
251015	0102	HUANGASCAR	1	2510	1	1	2020-08-26 09:02:55.472307
251016	0102	HUANTAN	1	2510	1	1	2020-08-26 09:02:55.472307
251017	0102	LARAOS	1	2510	1	1	2020-08-26 09:02:55.472307
251018	0102	LINCHA	1	2510	1	1	2020-08-26 09:02:55.472307
251019	0102	MADEAN	1	2510	1	1	2020-08-26 09:02:55.472307
251020	0102	MIRAFLORES	1	2510	1	1	2020-08-26 09:02:55.472307
251021	0102	OMAS	1	2510	1	1	2020-08-26 09:02:55.472307
251022	0102	PUTINZA	1	2510	1	1	2020-08-26 09:02:55.472307
251023	0102	QUINCHES	1	2510	1	1	2020-08-26 09:02:55.472307
251024	0102	QUINOCAY	1	2510	1	1	2020-08-26 09:02:55.472307
251025	0102	SAN JOAQUIN	1	2510	1	1	2020-08-26 09:02:55.472307
251026	0102	SAN PEDRO DE PILAS	1	2510	1	1	2020-08-26 09:02:55.472307
251027	0102	TANTA	1	2510	1	1	2020-08-26 09:02:55.472307
251028	0102	TAURIPAMPA	1	2510	1	1	2020-08-26 09:02:55.472307
251029	0102	TOMAS	1	2510	1	1	2020-08-26 09:02:55.472307
251030	0102	TUPE	1	2510	1	1	2020-08-26 09:02:55.472307
251031	0102	VIÑAC	1	2510	1	1	2020-08-26 09:02:55.472307
251032	0102	VITIS	1	2510	1	1	2020-08-26 09:02:55.472307
251033	0102	YAUYOS	1	2510	1	1	2020-08-26 09:02:55.472307
260101	0102	BALSAPUERTO	1	2601	1	1	2020-08-26 09:02:55.472307
260102	0102	BARRANCA	1	2601	1	1	2020-08-26 09:02:55.472307
260103	0102	CAHUAPANAS	1	2601	1	1	2020-08-26 09:02:55.472307
260104	0102	JEBEROS	1	2601	1	1	2020-08-26 09:02:55.472307
260105	0102	LAGUNAS	1	2601	1	1	2020-08-26 09:02:55.472307
260106	0102	MANSERICHE	1	2601	1	1	2020-08-26 09:02:55.472307
260107	0102	MORONA	1	2601	1	1	2020-08-26 09:02:55.472307
260108	0102	PASTAZA	1	2601	1	1	2020-08-26 09:02:55.472307
260109	0102	SANTA CRUZ	1	2601	1	1	2020-08-26 09:02:55.472307
260110	0102	TENIENTE CESAR LOPEZ ROJAS	1	2601	1	1	2020-08-26 09:02:55.472307
260111	0102	YURIMAGUAS	1	2601	1	1	2020-08-26 09:02:55.472307
260201	0102	NAUTA	1	2602	1	1	2020-08-26 09:02:55.472307
260202	0102	PARINARI	1	2602	1	1	2020-08-26 09:02:55.472307
260203	0102	TIGRE	1	2602	1	1	2020-08-26 09:02:55.472307
260204	0102	TROMPETEROS	1	2602	1	1	2020-08-26 09:02:55.472307
260205	0102	URARINAS	1	2602	1	1	2020-08-26 09:02:55.472307
260301	0102	PEBAS	1	2603	1	1	2020-08-26 09:02:55.472307
260302	0102	RAMON CASTILLA	1	2603	1	1	2020-08-26 09:02:55.472307
260303	0102	SAN PABLO	1	2603	1	1	2020-08-26 09:02:55.472307
260304	0102	YAVARI	1	2603	1	1	2020-08-26 09:02:55.472307
260401	0102	ALTO NANAY	1	2604	1	1	2020-08-26 09:02:55.472307
260402	0102	BELEN	1	2604	1	1	2020-08-26 09:02:55.472307
260403	0102	FERNANDO LORES	1	2604	1	1	2020-08-26 09:02:55.472307
260404	0102	INDIANA	1	2604	1	1	2020-08-26 09:02:55.472307
260405	0102	IQUITOS	1	2604	1	1	2020-08-26 09:02:55.472307
260406	0102	LAS AMAZONAS	1	2604	1	1	2020-08-26 09:02:55.472307
260407	0102	MAZAN	1	2604	1	1	2020-08-26 09:02:55.472307
260408	0102	NAPO	1	2604	1	1	2020-08-26 09:02:55.472307
260409	0102	PUNCHANA	1	2604	1	1	2020-08-26 09:02:55.472307
260410	0102	PUTUMAYO	1	2604	1	1	2020-08-26 09:02:55.472307
260411	0102	SAN JUAN BAUTISTA	1	2604	1	1	2020-08-26 09:02:55.472307
260412	0102	TORRES CAUSANA	1	2604	1	1	2020-08-26 09:02:55.472307
260501	0102	ALTO TAPICHE	1	2605	1	1	2020-08-26 09:02:55.472307
260502	0102	CAPELO	1	2605	1	1	2020-08-26 09:02:55.472307
260503	0102	EMILIO SAN MARTIN	1	2605	1	1	2020-08-26 09:02:55.472307
260504	0102	JENARO HERRERA	1	2605	1	1	2020-08-26 09:02:55.472307
260505	0102	MAQUIA	1	2605	1	1	2020-08-26 09:02:55.472307
260506	0102	PUINAHUA	1	2605	1	1	2020-08-26 09:02:55.472307
260507	0102	REQUENA	1	2605	1	1	2020-08-26 09:02:55.472307
260508	0102	SAQUENA	1	2605	1	1	2020-08-26 09:02:55.472307
260509	0102	SOPLIN	1	2605	1	1	2020-08-26 09:02:55.472307
260510	0102	TAPICHE	1	2605	1	1	2020-08-26 09:02:55.472307
260511	0102	YAQUERANA	1	2605	1	1	2020-08-26 09:02:55.472307
260601	0102	CONTAMANA	1	2606	1	1	2020-08-26 09:02:55.472307
260602	0102	INAHUAYA	1	2606	1	1	2020-08-26 09:02:55.472307
260603	0102	PADRE MARQUEZ	1	2606	1	1	2020-08-26 09:02:55.472307
260604	0102	PAMPA HERMOSA	1	2606	1	1	2020-08-26 09:02:55.472307
260605	0102	SARAYACU	1	2606	1	1	2020-08-26 09:02:55.472307
260606	0102	VARGAS GUERRA	1	2606	1	1	2020-08-26 09:02:55.472307
270101	0102	IBERIA	1	2701	1	1	2020-08-26 09:02:55.472307
270102	0102	IÑAPARI	1	2701	1	1	2020-08-26 09:02:55.472307
270103	0102	TAHUAMANU	1	2701	1	1	2020-08-26 09:02:55.472307
270201	0102	FITZCARRALD	1	2702	1	1	2020-08-26 09:02:55.472307
270202	0102	HUEPETUHE	1	2702	1	1	2020-08-26 09:02:55.472307
270203	0102	MADRE DE DIOS	1	2702	1	1	2020-08-26 09:02:55.472307
270204	0102	MANU	1	2702	1	1	2020-08-26 09:02:55.472307
270301	0102	INAMBARI	1	2703	1	1	2020-08-26 09:02:55.472307
270302	0102	LABERINTO	1	2703	1	1	2020-08-26 09:02:55.472307
270303	0102	LAS PIEDRAS	1	2703	1	1	2020-08-26 09:02:55.472307
270304	0102	TAMBOPATA	1	2703	1	1	2020-08-26 09:02:55.472307
280101	0102	CHOJATA	1	2801	1	1	2020-08-26 09:02:55.472307
280102	0102	COALAQUE	1	2801	1	1	2020-08-26 09:02:55.472307
280103	0102	ICHUÑA	1	2801	1	1	2020-08-26 09:02:55.472307
280104	0102	LA CAPILLA	1	2801	1	1	2020-08-26 09:02:55.472307
280105	0102	LLOQUE	1	2801	1	1	2020-08-26 09:02:55.472307
280106	0102	MATALACHE	1	2801	1	1	2020-08-26 09:02:55.472307
280107	0102	OMATE	1	2801	1	1	2020-08-26 09:02:55.472307
280108	0102	PUQUINA	1	2801	1	1	2020-08-26 09:02:55.472307
280109	0102	QUINISTAQUILLAS	1	2801	1	1	2020-08-26 09:02:55.472307
280110	0102	UBINAS	1	2801	1	1	2020-08-26 09:02:55.472307
280111	0102	YUNGA	1	2801	1	1	2020-08-26 09:02:55.472307
280201	0102	EL ALGARROBAL	1	2802	1	1	2020-08-26 09:02:55.472307
280202	0102	ILO	1	2802	1	1	2020-08-26 09:02:55.472307
280203	0102	PACOCHA	1	2802	1	1	2020-08-26 09:02:55.472307
280301	0102	CACHUMBAYA	1	2803	1	1	2020-08-26 09:02:55.472307
280302	0102	CARUMAS	1	2803	1	1	2020-08-26 09:02:55.472307
280303	0102	MOQUEGUA	1	2803	1	1	2020-08-26 09:02:55.472307
280304	0102	SAMEGUA	1	2803	1	1	2020-08-26 09:02:55.472307
280305	0102	SAN CRISTOBAL	1	2803	1	1	2020-08-26 09:02:55.472307
280306	0102	TORATA	1	2803	1	1	2020-08-26 09:02:55.472307
290101	0102	CHACAYAN	1	2901	1	1	2020-08-26 09:02:55.472307
290102	0102	GOYLLARISQUIZGA	1	2901	1	1	2020-08-26 09:02:55.472307
290103	0102	PAUCAR	1	2901	1	1	2020-08-26 09:02:55.472307
290104	0102	SAN PEDRO DE PILLAO	1	2901	1	1	2020-08-26 09:02:55.472307
290105	0102	SANTA ANA DE TUSI	1	2901	1	1	2020-08-26 09:02:55.472307
290106	0102	TAPUC	1	2901	1	1	2020-08-26 09:02:55.472307
290107	0102	VILCABAMBA	1	2901	1	1	2020-08-26 09:02:55.472307
290108	0102	YANAHUANCA	1	2901	1	1	2020-08-26 09:02:55.472307
290201	0102	CHONTABAMBA	1	2902	1	1	2020-08-26 09:02:55.472307
290202	0102	HUANCABAMBA	1	2902	1	1	2020-08-26 09:02:55.472307
290203	0102	OXAPAMPA	1	2902	1	1	2020-08-26 09:02:55.472307
290204	0102	PALCAZU	1	2902	1	1	2020-08-26 09:02:55.472307
290205	0102	POZUZO	1	2902	1	1	2020-08-26 09:02:55.472307
290206	0102	PUERTO BERMUDEZ	1	2902	1	1	2020-08-26 09:02:55.472307
290207	0102	VILLA RICA	1	2902	1	1	2020-08-26 09:02:55.472307
290301	0102	CHAUPIMARCA	1	2903	1	1	2020-08-26 09:02:55.472307
290302	0102	HUACHON	1	2903	1	1	2020-08-26 09:02:55.472307
290303	0102	HUARIACA	1	2903	1	1	2020-08-26 09:02:55.472307
290304	0102	HUAYLLAY	1	2903	1	1	2020-08-26 09:02:55.472307
290305	0102	NINACACA	1	2903	1	1	2020-08-26 09:02:55.472307
290306	0102	PALLANCHACRA	1	2903	1	1	2020-08-26 09:02:55.472307
290307	0102	PAUCARTAMBO	1	2903	1	1	2020-08-26 09:02:55.472307
290308	0102	SAN FCO DE ASIS DE YARUSYACAN	1	2903	1	1	2020-08-26 09:02:55.472307
290309	0102	SIMON BOLIVAR	1	2903	1	1	2020-08-26 09:02:55.472307
290310	0102	TICLACAYAN	1	2903	1	1	2020-08-26 09:02:55.472307
290311	0102	TINYAHUARCO	1	2903	1	1	2020-08-26 09:02:55.472307
290312	0102	VICCO	1	2903	1	1	2020-08-26 09:02:55.472307
290313	0102	YANACANCHA	1	2903	1	1	2020-08-26 09:02:55.472307
300101	0102	AYABACA	1	3001	1	1	2020-08-26 09:02:55.472307
300102	0102	FRIAS	1	3001	1	1	2020-08-26 09:02:55.472307
300103	0102	JILILI	1	3001	1	1	2020-08-26 09:02:55.472307
300104	0102	LAGUNAS	1	3001	1	1	2020-08-26 09:02:55.472307
300105	0102	MONTERO	1	3001	1	1	2020-08-26 09:02:55.472307
300106	0102	PACAIPAMPA	1	3001	1	1	2020-08-26 09:02:55.472307
300107	0102	PAIMAS	1	3001	1	1	2020-08-26 09:02:55.472307
300108	0102	SAPILLICA	1	3001	1	1	2020-08-26 09:02:55.472307
300109	0102	SICCHEZ	1	3001	1	1	2020-08-26 09:02:55.472307
300110	0102	SUYO	1	3001	1	1	2020-08-26 09:02:55.472307
300201	0102	CANCHAQUE	1	3002	1	1	2020-08-26 09:02:55.472307
300202	0102	EL CARMEN DE LA FRONTERA	1	3002	1	1	2020-08-26 09:02:55.472307
300203	0102	HUANCABAMBA	1	3002	1	1	2020-08-26 09:02:55.472307
300204	0102	HUARMACA	1	3002	1	1	2020-08-26 09:02:55.472307
300205	0102	LALAQUIZ	1	3002	1	1	2020-08-26 09:02:55.472307
300206	0102	SAN MIGUEL DE EL FAIQUE	1	3002	1	1	2020-08-26 09:02:55.472307
300207	0102	SONDOR	1	3002	1	1	2020-08-26 09:02:55.472307
300208	0102	SONDORILLO	1	3002	1	1	2020-08-26 09:02:55.472307
300301	0102	BUENOS AIRES	1	3003	1	1	2020-08-26 09:02:55.472307
300302	0102	CHALACO	1	3003	1	1	2020-08-26 09:02:55.472307
300303	0102	CHULUCANAS	1	3003	1	1	2020-08-26 09:02:55.472307
300304	0102	LA MATANZA	1	3003	1	1	2020-08-26 09:02:55.472307
300305	0102	MORROPON	1	3003	1	1	2020-08-26 09:02:55.472307
300306	0102	SALITRAL	1	3003	1	1	2020-08-26 09:02:55.472307
300307	0102	SAN JUAN DE BIGOTE	1	3003	1	1	2020-08-26 09:02:55.472307
300308	0102	SANTA CATALINA DE MOSSA	1	3003	1	1	2020-08-26 09:02:55.472307
300309	0102	SANTO DOMINGO	1	3003	1	1	2020-08-26 09:02:55.472307
300310	0102	YAMANGO	1	3003	1	1	2020-08-26 09:02:55.472307
300401	0102	AMOTAPE	1	3004	1	1	2020-08-26 09:02:55.472307
300402	0102	ARENAL	1	3004	1	1	2020-08-26 09:02:55.472307
300403	0102	COLAN	1	3004	1	1	2020-08-26 09:02:55.472307
300404	0102	LA HUACA	1	3004	1	1	2020-08-26 09:02:55.472307
300405	0102	PAITA	1	3004	1	1	2020-08-26 09:02:55.472307
300406	0102	TAMARINDO	1	3004	1	1	2020-08-26 09:02:55.472307
300407	0102	VICHAYAL	1	3004	1	1	2020-08-26 09:02:55.472307
300501	0102	CASTILLA	1	3005	1	1	2020-08-26 09:02:55.472307
300502	0102	CATACAOS	1	3005	1	1	2020-08-26 09:02:55.472307
300503	0102	CURA MORI	1	3005	1	1	2020-08-26 09:02:55.472307
300504	0102	EL TALLAN	1	3005	1	1	2020-08-26 09:02:55.472307
300505	0102	LA ARENA	1	3005	1	1	2020-08-26 09:02:55.472307
300506	0102	LA UNION	1	3005	1	1	2020-08-26 09:02:55.472307
300507	0102	LAS LOMAS	1	3005	1	1	2020-08-26 09:02:55.472307
300508	0102	PIURA	1	3005	1	1	2020-08-26 09:02:55.472307
300509	0102	TAMBO GRANDE	1	3005	1	1	2020-08-26 09:02:55.472307
300601	0102	BELLAVISTA DE LA UNION	1	3006	1	1	2020-08-26 09:02:55.472307
300602	0102	BERNAL	1	3006	1	1	2020-08-26 09:02:55.472307
300603	0102	CRISTO NOS VALGA	1	3006	1	1	2020-08-26 09:02:55.472307
300604	0102	RINCONADA LLICUAR	1	3006	1	1	2020-08-26 09:02:55.472307
300605	0102	SECHURA	1	3006	1	1	2020-08-26 09:02:55.472307
300606	0102	VICE	1	3006	1	1	2020-08-26 09:02:55.472307
300701	0102	BELLAVISTA	1	3007	1	1	2020-08-26 09:02:55.472307
300702	0102	IGNACIO ESCUDERO	1	3007	1	1	2020-08-26 09:02:55.472307
300703	0102	LANCONES	1	3007	1	1	2020-08-26 09:02:55.472307
300704	0102	MARCAVELICA	1	3007	1	1	2020-08-26 09:02:55.472307
300705	0102	MIGUEL CHECA	1	3007	1	1	2020-08-26 09:02:55.472307
300706	0102	QUERECOTILLO	1	3007	1	1	2020-08-26 09:02:55.472307
300707	0102	SALITRAL	1	3007	1	1	2020-08-26 09:02:55.472307
300708	0102	SULLANA	1	3007	1	1	2020-08-26 09:02:55.472307
300801	0102	EL ALTO	1	3008	1	1	2020-08-26 09:02:55.472307
300802	0102	LA BREA	1	3008	1	1	2020-08-26 09:02:55.472307
300803	0102	LOBITOS	1	3008	1	1	2020-08-26 09:02:55.472307
300804	0102	LOS ORGANOS	1	3008	1	1	2020-08-26 09:02:55.472307
300805	0102	MANCORA	1	3008	1	1	2020-08-26 09:02:55.472307
300806	0102	PARIÑAS	1	3008	1	1	2020-08-26 09:02:55.472307
310101	0102	ACHAYA	1	3101	1	1	2020-08-26 09:02:55.472307
310102	0102	ARAPA	1	3101	1	1	2020-08-26 09:02:55.472307
310103	0102	ASILLO	1	3101	1	1	2020-08-26 09:02:55.472307
310104	0102	AZANGARO	1	3101	1	1	2020-08-26 09:02:55.472307
310105	0102	CAMINACA	1	3101	1	1	2020-08-26 09:02:55.472307
310106	0102	CHUPA	1	3101	1	1	2020-08-26 09:02:55.472307
310107	0102	JOSE DOMINGO CHOQUEHUANCA	1	3101	1	1	2020-08-26 09:02:55.472307
310108	0102	MUÑANI	1	3101	1	1	2020-08-26 09:02:55.472307
310109	0102	POTONI	1	3101	1	1	2020-08-26 09:02:55.472307
310110	0102	SAMAN	1	3101	1	1	2020-08-26 09:02:55.472307
310111	0102	SAN ANTON	1	3101	1	1	2020-08-26 09:02:55.472307
310112	0102	SAN JOSÉ	1	3101	1	1	2020-08-26 09:02:55.472307
310113	0102	SAN JUAN DE SALINAS	1	3101	1	1	2020-08-26 09:02:55.472307
310114	0102	SANTIAGO DE PUPUJA	1	3101	1	1	2020-08-26 09:02:55.472307
310115	0102	TIRAPATA	1	3101	1	1	2020-08-26 09:02:55.472307
310201	0102	AJOYANI	1	3102	1	1	2020-08-26 09:02:55.472307
310202	0102	AYAPATA	1	3102	1	1	2020-08-26 09:02:55.472307
310203	0102	COASA	1	3102	1	1	2020-08-26 09:02:55.472307
310204	0102	CORANI	1	3102	1	1	2020-08-26 09:02:55.472307
310205	0102	CRUCERO	1	3102	1	1	2020-08-26 09:02:55.472307
310206	0102	ITUATA	1	3102	1	1	2020-08-26 09:02:55.472307
310207	0102	MACUSANI	1	3102	1	1	2020-08-26 09:02:55.472307
310208	0102	OLLACHEA	1	3102	1	1	2020-08-26 09:02:55.472307
310209	0102	SAN GABAN	1	3102	1	1	2020-08-26 09:02:55.472307
310210	0102	USICAYOS	1	3102	1	1	2020-08-26 09:02:55.472307
310301	0102	DESAGUADERO	1	3103	1	1	2020-08-26 09:02:55.472307
340201	0102	CORRALES	1	3402	1	1	2020-08-26 09:02:55.472307
310302	0102	HUACULLANI	1	3103	1	1	2020-08-26 09:02:55.472307
310303	0102	JULI	1	3103	1	1	2020-08-26 09:02:55.472307
310304	0102	KELLUYO	1	3103	1	1	2020-08-26 09:02:55.472307
310305	0102	PISACOMA	1	3103	1	1	2020-08-26 09:02:55.472307
310306	0102	POMATA	1	3103	1	1	2020-08-26 09:02:55.472307
310307	0102	ZEPITA	1	3103	1	1	2020-08-26 09:02:55.472307
310401	0102	CAPASO	1	3104	1	1	2020-08-26 09:02:55.472307
310402	0102	CONDURIRI	1	3104	1	1	2020-08-26 09:02:55.472307
310403	0102	ILAVE	1	3104	1	1	2020-08-26 09:02:55.472307
310404	0102	PILCUYO	1	3104	1	1	2020-08-26 09:02:55.472307
310405	0102	SANTA ROSA	1	3104	1	1	2020-08-26 09:02:55.472307
310501	0102	COJATA	1	3105	1	1	2020-08-26 09:02:55.472307
310502	0102	HUANCANE	1	3105	1	1	2020-08-26 09:02:55.472307
310503	0102	HUATASANI	1	3105	1	1	2020-08-26 09:02:55.472307
310504	0102	INCHUPALLA	1	3105	1	1	2020-08-26 09:02:55.472307
310505	0102	PUSI	1	3105	1	1	2020-08-26 09:02:55.472307
310506	0102	ROSASPATA	1	3105	1	1	2020-08-26 09:02:55.472307
310507	0102	TARACO	1	3105	1	1	2020-08-26 09:02:55.472307
310508	0102	VILQUE CHICO	1	3105	1	1	2020-08-26 09:02:55.472307
310601	0102	CABANILLA	1	3106	1	1	2020-08-26 09:02:55.472307
310602	0102	CALAPUJA	1	3106	1	1	2020-08-26 09:02:55.472307
310603	0102	LAMPA	1	3106	1	1	2020-08-26 09:02:55.472307
310604	0102	NICASIO	1	3106	1	1	2020-08-26 09:02:55.472307
310605	0102	OCUVIRI	1	3106	1	1	2020-08-26 09:02:55.472307
310606	0102	PALCA	1	3106	1	1	2020-08-26 09:02:55.472307
310607	0102	PARATIA	1	3106	1	1	2020-08-26 09:02:55.472307
310608	0102	PUCARA	1	3106	1	1	2020-08-26 09:02:55.472307
310609	0102	SANTA LUCIA	1	3106	1	1	2020-08-26 09:02:55.472307
310610	0102	VILAVILA	1	3106	1	1	2020-08-26 09:02:55.472307
310701	0102	ANTAUTA	1	3107	1	1	2020-08-26 09:02:55.472307
310702	0102	AYAVIRI	1	3107	1	1	2020-08-26 09:02:55.472307
310703	0102	CUPI	1	3107	1	1	2020-08-26 09:02:55.472307
310704	0102	LLALLI	1	3107	1	1	2020-08-26 09:02:55.472307
310705	0102	MACARI	1	3107	1	1	2020-08-26 09:02:55.472307
310706	0102	NUÑOA	1	3107	1	1	2020-08-26 09:02:55.472307
310707	0102	ORURILLO	1	3107	1	1	2020-08-26 09:02:55.472307
310708	0102	SANTA ROSA	1	3107	1	1	2020-08-26 09:02:55.472307
310709	0102	UMACHIRI	1	3107	1	1	2020-08-26 09:02:55.472307
310801	0102	CONIMA	1	3108	1	1	2020-08-26 09:02:55.472307
310802	0102	HUAYRAPATA	1	3108	1	1	2020-08-26 09:02:55.472307
310803	0102	MOHO	1	3108	1	1	2020-08-26 09:02:55.472307
310804	0102	TILALI	1	3108	1	1	2020-08-26 09:02:55.472307
310901	0102	ACORA	1	3109	1	1	2020-08-26 09:02:55.472307
310902	0102	AMANTANI	1	3109	1	1	2020-08-26 09:02:55.472307
310903	0102	ATUNCOLLA	1	3109	1	1	2020-08-26 09:02:55.472307
310904	0102	CAPACHICA	1	3109	1	1	2020-08-26 09:02:55.472307
310905	0102	CHUCUITO	1	3109	1	1	2020-08-26 09:02:55.472307
310906	0102	COATA	1	3109	1	1	2020-08-26 09:02:55.472307
310907	0102	HUATA	1	3109	1	1	2020-08-26 09:02:55.472307
310908	0102	MAÑAZO	1	3109	1	1	2020-08-26 09:02:55.472307
310909	0102	PAUCARCOLLA	1	3109	1	1	2020-08-26 09:02:55.472307
310910	0102	PICHACANI	1	3109	1	1	2020-08-26 09:02:55.472307
310911	0102	PLATERIA	1	3109	1	1	2020-08-26 09:02:55.472307
310912	0102	PUNO	1	3109	1	1	2020-08-26 09:02:55.472307
310913	0102	SAN ANTONIO	1	3109	1	1	2020-08-26 09:02:55.472307
310914	0102	TIQUILLACA	1	3109	1	1	2020-08-26 09:02:55.472307
310915	0102	VILQUE	1	3109	1	1	2020-08-26 09:02:55.472307
311001	0102	ANANEA	1	3110	1	1	2020-08-26 09:02:55.472307
311002	0102	PEDRO VILCA APAZA	1	3110	1	1	2020-08-26 09:02:55.472307
311003	0102	PUTINA	1	3110	1	1	2020-08-26 09:02:55.472307
311004	0102	QUILCAPUNCU	1	3110	1	1	2020-08-26 09:02:55.472307
311005	0102	SINA	1	3110	1	1	2020-08-26 09:02:55.472307
311101	0102	CABANA	1	3111	1	1	2020-08-26 09:02:55.472307
311102	0102	CABANILLAS	1	3111	1	1	2020-08-26 09:02:55.472307
311103	0102	CARACOTO	1	3111	1	1	2020-08-26 09:02:55.472307
311104	0102	JULIACA	1	3111	1	1	2020-08-26 09:02:55.472307
311201	0102	ALTO INAMBARI	1	3112	1	1	2020-08-26 09:02:55.472307
311202	0102	CUYOCUYO	1	3112	1	1	2020-08-26 09:02:55.472307
311203	0102	LIMBANI	1	3112	1	1	2020-08-26 09:02:55.472307
311204	0102	PATAMBUCO	1	3112	1	1	2020-08-26 09:02:55.472307
311205	0102	PHARA	1	3112	1	1	2020-08-26 09:02:55.472307
311206	0102	QUIACA	1	3112	1	1	2020-08-26 09:02:55.472307
311207	0102	SAN JUAN DEL ORO	1	3112	1	1	2020-08-26 09:02:55.472307
311208	0102	SANDIA	1	3112	1	1	2020-08-26 09:02:55.472307
311209	0102	YANAHUAYA	1	3112	1	1	2020-08-26 09:02:55.472307
311301	0102	ANAPIA	1	3113	1	1	2020-08-26 09:02:55.472307
311302	0102	COPANI	1	3113	1	1	2020-08-26 09:02:55.472307
311303	0102	CUTURAPI	1	3113	1	1	2020-08-26 09:02:55.472307
311304	0102	OLLARAYA	1	3113	1	1	2020-08-26 09:02:55.472307
311305	0102	TINICACHI	1	3113	1	1	2020-08-26 09:02:55.472307
311306	0102	UNICACHI	1	3113	1	1	2020-08-26 09:02:55.472307
311307	0102	YUNGUYO	1	3113	1	1	2020-08-26 09:02:55.472307
320101	0102	ALTO BIAVO	1	3201	1	1	2020-08-26 09:02:55.472307
320102	0102	BAJO BIAVO	1	3201	1	1	2020-08-26 09:02:55.472307
320103	0102	BELLAVISTA	1	3201	1	1	2020-08-26 09:02:55.472307
320104	0102	HUALLAGA	1	3201	1	1	2020-08-26 09:02:55.472307
320105	0102	SAN PABLO	1	3201	1	1	2020-08-26 09:02:55.472307
320106	0102	SAN RAFAEL	1	3201	1	1	2020-08-26 09:02:55.472307
320201	0102	AGUA BLANCA	1	3202	1	1	2020-08-26 09:02:55.472307
320202	0102	SAN JOSÉ DE SISA	1	3202	1	1	2020-08-26 09:02:55.472307
320203	0102	SAN MARTIN	1	3202	1	1	2020-08-26 09:02:55.472307
320204	0102	SANTA ROSA	1	3202	1	1	2020-08-26 09:02:55.472307
320205	0102	SHATOJA	1	3202	1	1	2020-08-26 09:02:55.472307
320301	0102	ALTO SAPOSOA	1	3203	1	1	2020-08-26 09:02:55.472307
320302	0102	EL ESLABON	1	3203	1	1	2020-08-26 09:02:55.472307
320303	0102	PISCOYACU	1	3203	1	1	2020-08-26 09:02:55.472307
320304	0102	SACANCHE	1	3203	1	1	2020-08-26 09:02:55.472307
320305	0102	SAPOSOA	1	3203	1	1	2020-08-26 09:02:55.472307
320306	0102	TINGO DE SAPOSOA	1	3203	1	1	2020-08-26 09:02:55.472307
320401	0102	ALONSO DE ALVARADO	1	3204	1	1	2020-08-26 09:02:55.472307
320402	0102	BARRANQUITA	1	3204	1	1	2020-08-26 09:02:55.472307
320403	0102	CAYNARACHI	1	3204	1	1	2020-08-26 09:02:55.472307
320404	0102	CUÑUMBUQUI	1	3204	1	1	2020-08-26 09:02:55.472307
320405	0102	LAMAS	1	3204	1	1	2020-08-26 09:02:55.472307
320406	0102	PINTO RECODO	1	3204	1	1	2020-08-26 09:02:55.472307
320407	0102	RUMISAPA	1	3204	1	1	2020-08-26 09:02:55.472307
320408	0102	SAN ROQUE DE CUMBAZA	1	3204	1	1	2020-08-26 09:02:55.472307
320409	0102	SHANAO	1	3204	1	1	2020-08-26 09:02:55.472307
320410	0102	TABALOSOS	1	3204	1	1	2020-08-26 09:02:55.472307
320411	0102	ZAPATERO	1	3204	1	1	2020-08-26 09:02:55.472307
320501	0102	CAMPANILLA	1	3205	1	1	2020-08-26 09:02:55.472307
320502	0102	HUICUNGO	1	3205	1	1	2020-08-26 09:02:55.472307
320503	0102	JUANJUI	1	3205	1	1	2020-08-26 09:02:55.472307
320504	0102	PACHIZA	1	3205	1	1	2020-08-26 09:02:55.472307
320505	0102	PAJARILLO	1	3205	1	1	2020-08-26 09:02:55.472307
320601	0102	CALZADA	1	3206	1	1	2020-08-26 09:02:55.472307
320602	0102	HABANA	1	3206	1	1	2020-08-26 09:02:55.472307
320603	0102	JEPELACIO	1	3206	1	1	2020-08-26 09:02:55.472307
320604	0102	MOYOBAMBA	1	3206	1	1	2020-08-26 09:02:55.472307
320605	0102	SORITOR	1	3206	1	1	2020-08-26 09:02:55.472307
320606	0102	YANTALO	1	3206	1	1	2020-08-26 09:02:55.472307
320701	0102	BUENOS AIRES	1	3207	1	1	2020-08-26 09:02:55.472307
320702	0102	CASPISAPA	1	3207	1	1	2020-08-26 09:02:55.472307
320703	0102	PICOTA	1	3207	1	1	2020-08-26 09:02:55.472307
320704	0102	PILLUANA	1	3207	1	1	2020-08-26 09:02:55.472307
320705	0102	PUCACACA	1	3207	1	1	2020-08-26 09:02:55.472307
320706	0102	SAN CRISTOBAL	1	3207	1	1	2020-08-26 09:02:55.472307
320707	0102	SAN HILARION	1	3207	1	1	2020-08-26 09:02:55.472307
11	0102	AMAZONAS	1	0	0	1	2020-08-26 09:02:55.472307
12	0102	ANCASH	1	0	0	1	2020-08-26 09:02:55.472307
13	0102	APURIMAC	1	0	0	1	2020-08-26 09:02:55.472307
14	0102	AREQUIPA	1	0	1	1	2020-08-26 09:02:55.472307
15	0102	AYACUCHO	1	0	0	1	2020-08-26 09:02:55.472307
16	0102	CAJAMARCA	1	0	0	1	2020-08-26 09:02:55.472307
17	0102	CALLAO	1	0	0	1	2020-08-26 09:02:55.472307
18	0102	CUZCO	1	0	0	1	2020-08-26 09:02:55.472307
19	0102	HUANCAVELICA	1	0	0	1	2020-08-26 09:02:55.472307
120801	0102	ACO	1	1208	1	1	2020-08-26 09:02:55.472307
122003	0102	MATACOTO	1	1220	1	1	2020-08-26 09:02:55.472307
122004	0102	QUILLO	1	1220	1	1	2020-08-26 09:02:55.472307
122005	0102	RANRAHIRCA	1	1220	1	1	2020-08-26 09:02:55.472307
122006	0102	SHUPLUY	1	1220	1	1	2020-08-26 09:02:55.472307
122007	0102	YANAMA	1	1220	1	1	2020-08-26 09:02:55.472307
122008	0102	YUNGAY	1	1220	1	1	2020-08-26 09:02:55.472307
130101	0102	ABANCAY	1	1301	1	1	2020-08-26 09:02:55.472307
130102	0102	CHACOCHE	1	1301	1	1	2020-08-26 09:02:55.472307
130103	0102	CIRCA	1	1301	1	1	2020-08-26 09:02:55.472307
130104	0102	CURAHUASI	1	1301	1	1	2020-08-26 09:02:55.472307
130105	0102	HUANIPACA	1	1301	1	1	2020-08-26 09:02:55.472307
130106	0102	LAMBRAMA	1	1301	1	1	2020-08-26 09:02:55.472307
130107	0102	PICHIRHUA	1	1301	1	1	2020-08-26 09:02:55.472307
130108	0102	SAN PEDRO DE CACHORA	1	1301	1	1	2020-08-26 09:02:55.472307
130109	0102	TAMBURCO	1	1301	1	1	2020-08-26 09:02:55.472307
130201	0102	ANDAHUAYLAS	1	1302	1	1	2020-08-26 09:02:55.472307
130202	0102	ANDARAPA	1	1302	1	1	2020-08-26 09:02:55.472307
130203	0102	CHIARA	1	1302	1	1	2020-08-26 09:02:55.472307
130204	0102	HUANCARAMA	1	1302	1	1	2020-08-26 09:02:55.472307
130205	0102	HUANCARAY	1	1302	1	1	2020-08-26 09:02:55.472307
130206	0102	HUAYANA	1	1302	1	1	2020-08-26 09:02:55.472307
130207	0102	KAQUIABAMBA	1	1302	1	1	2020-08-26 09:02:55.472307
130208	0102	KISHUARA	1	1302	1	1	2020-08-26 09:02:55.472307
130209	0102	PACOBAMBA	1	1302	1	1	2020-08-26 09:02:55.472307
130210	0102	PACUCHA	1	1302	1	1	2020-08-26 09:02:55.472307
130211	0102	PAMPACHIRI	1	1302	1	1	2020-08-26 09:02:55.472307
130212	0102	POMACOCHA	1	1302	1	1	2020-08-26 09:02:55.472307
130213	0102	SAN ANTONIO DE CACHI	1	1302	1	1	2020-08-26 09:02:55.472307
220522	0102	PACA	1	2205	1	1	2020-08-26 09:02:55.472307
320708	0102	SHAMBOYACU	1	3207	1	1	2020-08-26 09:02:55.472307
320709	0102	TINGO DE PONASA	1	3207	1	1	2020-08-26 09:02:55.472307
320710	0102	TRES UNIDOS	1	3207	1	1	2020-08-26 09:02:55.472307
320801	0102	AWAJUN	1	3208	1	1	2020-08-26 09:02:55.472307
320802	0102	ELIAS SOPLIN VARGAS	1	3208	1	1	2020-08-26 09:02:55.472307
320803	0102	NUEVA CAJAMARCA	1	3208	1	1	2020-08-26 09:02:55.472307
320804	0102	PARDO MIGUEL	1	3208	1	1	2020-08-26 09:02:55.472307
320805	0102	POSIC	1	3208	1	1	2020-08-26 09:02:55.472307
320806	0102	RIOJA	1	3208	1	1	2020-08-26 09:02:55.472307
320807	0102	SAN FERNANDO	1	3208	1	1	2020-08-26 09:02:55.472307
320808	0102	YORONGOS	1	3208	1	1	2020-08-26 09:02:55.472307
320809	0102	YURACYACU	1	3208	1	1	2020-08-26 09:02:55.472307
320901	0102	ALBERTO LEVEAU	1	3209	1	1	2020-08-26 09:02:55.472307
320902	0102	CACATACHI	1	3209	1	1	2020-08-26 09:02:55.472307
320903	0102	CHAZUTA	1	3209	1	1	2020-08-26 09:02:55.472307
320904	0102	CHIPURANA	1	3209	1	1	2020-08-26 09:02:55.472307
320905	0102	EL PORVENIR	1	3209	1	1	2020-08-26 09:02:55.472307
320906	0102	HUIMBAYOC	1	3209	1	1	2020-08-26 09:02:55.472307
320907	0102	JUAN GUERRA	1	3209	1	1	2020-08-26 09:02:55.472307
320908	0102	LA BANDA DE SHILCAYO	1	3209	1	1	2020-08-26 09:02:55.472307
320909	0102	MORALES	1	3209	1	1	2020-08-26 09:02:55.472307
320910	0102	PAPAPLAYA	1	3209	1	1	2020-08-26 09:02:55.472307
320911	0102	SAN ANTONIO	1	3209	1	1	2020-08-26 09:02:55.472307
320912	0102	SAUCE	1	3209	1	1	2020-08-26 09:02:55.472307
320913	0102	SHAPAJA	1	3209	1	1	2020-08-26 09:02:55.472307
320914	0102	TARAPOTO	1	3209	1	1	2020-08-26 09:02:55.472307
321001	0102	NUEVO PROGRESO	1	3210	1	1	2020-08-26 09:02:55.472307
321002	0102	POLVORA	1	3210	1	1	2020-08-26 09:02:55.472307
321003	0102	SHUNTE	1	3210	1	1	2020-08-26 09:02:55.472307
321004	0102	TOCACHE	1	3210	1	1	2020-08-26 09:02:55.472307
321005	0102	UCHIZA	1	3210	1	1	2020-08-26 09:02:55.472307
330101	0102	CAIRANI	1	3301	1	1	2020-08-26 09:02:55.472307
330102	0102	CAMILACA	1	3301	1	1	2020-08-26 09:02:55.472307
330103	0102	CANDARAVE	1	3301	1	1	2020-08-26 09:02:55.472307
330104	0102	CURIBAYA	1	3301	1	1	2020-08-26 09:02:55.472307
330105	0102	HUANUARA	1	3301	1	1	2020-08-26 09:02:55.472307
330106	0102	QUILAHUANI	1	3301	1	1	2020-08-26 09:02:55.472307
330201	0102	ILABAYA	1	3302	1	1	2020-08-26 09:02:55.472307
330202	0102	ITE	1	3302	1	1	2020-08-26 09:02:55.472307
330203	0102	LOCUMBA	1	3302	1	1	2020-08-26 09:02:55.472307
330301	0102	ALTO DE LA ALIANZA	1	3303	1	1	2020-08-26 09:02:55.472307
330302	0102	CALANA	1	3303	1	1	2020-08-26 09:02:55.472307
330303	0102	CIUDAD NUEVA	1	3303	1	1	2020-08-26 09:02:55.472307
330304	0102	CORONEL GREGORIO ALBARRACIN	1	3303	1	1	2020-08-26 09:02:55.472307
330305	0102	INCLAN	1	3303	1	1	2020-08-26 09:02:55.472307
330306	0102	PACHIA	1	3303	1	1	2020-08-26 09:02:55.472307
330307	0102	PALCA	1	3303	1	1	2020-08-26 09:02:55.472307
330308	0102	POCOLLAY	1	3303	1	1	2020-08-26 09:02:55.472307
330309	0102	SAMA	1	3303	1	1	2020-08-26 09:02:55.472307
330310	0102	TACNA	1	3303	1	1	2020-08-26 09:02:55.472307
330401	0102	CHUCATAMANI	1	3304	1	1	2020-08-26 09:02:55.472307
330402	0102	ESTIQUE	1	3304	1	1	2020-08-26 09:02:55.472307
330403	0102	ESTIQUE-PAMPA	1	3304	1	1	2020-08-26 09:02:55.472307
330404	0102	SITAJARA	1	3304	1	1	2020-08-26 09:02:55.472307
330405	0102	SUSAPAYA	1	3304	1	1	2020-08-26 09:02:55.472307
330406	0102	TARATA	1	3304	1	1	2020-08-26 09:02:55.472307
330407	0102	TARUCACHI	1	3304	1	1	2020-08-26 09:02:55.472307
330408	0102	TICACO	1	3304	1	1	2020-08-26 09:02:55.472307
340101	0102	CASITAS	1	3401	1	1	2020-08-26 09:02:55.472307
340102	0102	ZORRITOS	1	3401	1	1	2020-08-26 09:02:55.472307
340202	0102	LA CRUZ	1	3402	1	1	2020-08-26 09:02:55.472307
340203	0102	PAMPAS DE HOSPITAL	1	3402	1	1	2020-08-26 09:02:55.472307
340204	0102	SAN JACINTO	1	3402	1	1	2020-08-26 09:02:55.472307
340205	0102	SAN JUAN DE LA VIRGEN	1	3402	1	1	2020-08-26 09:02:55.472307
340206	0102	TUMBES	1	3402	1	1	2020-08-26 09:02:55.472307
340301	0102	AGUAS VERDES	1	3403	1	1	2020-08-26 09:02:55.472307
340302	0102	MATAPALO	1	3403	1	1	2020-08-26 09:02:55.472307
340303	0102	PAPAYAL	1	3403	1	1	2020-08-26 09:02:55.472307
340304	0102	ZARUMILLA	1	3403	1	1	2020-08-26 09:02:55.472307
350101	0102	RAYMONDI	1	3501	1	1	2020-08-26 09:02:55.472307
350102	0102	SEPAHUA	1	3501	1	1	2020-08-26 09:02:55.472307
350103	0102	TAHUANIA	1	3501	1	1	2020-08-26 09:02:55.472307
350104	0102	YURUA	1	3501	1	1	2020-08-26 09:02:55.472307
350201	0102	CALLARIA	1	3502	1	1	2020-08-26 09:02:55.472307
350202	0102	CAMPOVERDE	1	3502	1	1	2020-08-26 09:02:55.472307
350203	0102	IPARIA	1	3502	1	1	2020-08-26 09:02:55.472307
350204	0102	MASISEA	1	3502	1	1	2020-08-26 09:02:55.472307
350205	0102	NUEVA REQUENA	1	3502	1	1	2020-08-26 09:02:55.472307
350206	0102	YARINACOCHA	1	3502	1	1	2020-08-26 09:02:55.472307
350301	0102	CURIMANA	1	3503	1	1	2020-08-26 09:02:55.472307
350302	0102	IRAZOLA	1	3503	1	1	2020-08-26 09:02:55.472307
350303	0102	PADRE ABAD	1	3503	1	1	2020-08-26 09:02:55.472307
350401	0102	PURUS	1	3504	1	1	2020-08-26 09:02:55.472307
360101	0102	EXTRANJERO	1	3601	1	1	2020-08-26 09:02:55.472307
\.


--
-- Name: config_perfil config_perfil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_perfil
    ADD CONSTRAINT config_perfil_pkey PRIMARY KEY (id);


--
-- Name: config_tablas config_tablas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_tablas
    ADD CONSTRAINT config_tablas_pkey PRIMARY KEY (id);


--
-- Name: igl_iglesias igl_igle_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.igl_iglesias
    ADD CONSTRAINT igl_igle_pkey PRIMARY KEY (id);


--
-- Name: igl_usuarios igl_usuarios_xxx_pkey1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.igl_usuarios
    ADD CONSTRAINT igl_usuarios_xxx_pkey1 PRIMARY KEY (id);


--
-- Name: predios_archivos predios_archivos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_archivos
    ADD CONSTRAINT predios_archivos_pkey PRIMARY KEY (id);


--
-- Name: predios_deprec predios_deprec_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_deprec
    ADD CONSTRAINT predios_deprec_pkey PRIMARY KEY (id);


--
-- Name: predios_docum predios_docum_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_docum
    ADD CONSTRAINT predios_docum_pkey PRIMARY KEY (id_predio);


--
-- Name: predios_fiscal predios_fiscal_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_fiscal
    ADD CONSTRAINT predios_fiscal_pkey PRIMARY KEY (id_predio);


--
-- Name: predios_medidas predios_medidas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_medidas
    ADD CONSTRAINT predios_medidas_pkey PRIMARY KEY (id_predio);


--
-- Name: predios predios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios
    ADD CONSTRAINT predios_pkey PRIMARY KEY (id);


--
-- Name: predios_registral predios_registral_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_registral
    ADD CONSTRAINT predios_registral_pkey PRIMARY KEY (id_predio);


--
-- Name: predios_usos predios_usos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_usos
    ADD CONSTRAINT predios_usos_pkey PRIMARY KEY (id_predio);


--
-- Name: sis_ubigeo sis_ubigeo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sis_ubigeo
    ADD CONSTRAINT sis_ubigeo_pkey PRIMARY KEY (id);


--
-- Name: maestro tb_maestro_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.maestro
    ADD CONSTRAINT tb_maestro_pkey PRIMARY KEY (id);


--
-- Name: idx_maestro_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_maestro_id ON public.maestro USING btree (id);


--
-- Name: idx_predios; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_predios ON public.predios USING btree (id);


--
-- Name: idx_predios_usos; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_predios_usos ON public.predios_usos USING btree (id_predio);


--
-- Name: config_perfil config_perfil_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config_perfil
    ADD CONSTRAINT config_perfil_fkey1 FOREIGN KEY (id_tabla) REFERENCES public.config_tablas(id) NOT VALID;


--
-- Name: igl_usuarios_perfil fkey_usuarios_perfil; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.igl_usuarios_perfil
    ADD CONSTRAINT fkey_usuarios_perfil FOREIGN KEY (id_usuario) REFERENCES public.igl_usuarios(id) NOT VALID;


--
-- Name: predios_archivos predios_archivos_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_archivos
    ADD CONSTRAINT predios_archivos_fkey FOREIGN KEY (id_predio) REFERENCES public.predios(id) NOT VALID;


--
-- Name: predios_deprec predios_deprec_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_deprec
    ADD CONSTRAINT predios_deprec_fkey FOREIGN KEY (id_predio) REFERENCES public.predios(id) NOT VALID;


--
-- Name: predios_docum predios_docum_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_docum
    ADD CONSTRAINT predios_docum_fkey FOREIGN KEY (id_predio) REFERENCES public.predios(id) NOT VALID;


--
-- Name: predios_fiscal predios_fiscal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_fiscal
    ADD CONSTRAINT predios_fiscal_fkey FOREIGN KEY (id_predio) REFERENCES public.predios(id) NOT VALID;


--
-- Name: predios_medidas predios_medidas_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_medidas
    ADD CONSTRAINT predios_medidas_fkey FOREIGN KEY (id_predio) REFERENCES public.predios(id) NOT VALID;


--
-- Name: predios_registral predios_registral_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.predios_registral
    ADD CONSTRAINT predios_registral_fkey FOREIGN KEY (id_predio) REFERENCES public.predios(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

