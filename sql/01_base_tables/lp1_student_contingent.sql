--
-- PostgreSQL database dump
--

\restrict mlVZvCzxOxpYNxPkPaUtj0SZErUui43iVteClOPw1pzJaWltP0hszYdFrgbbWGw

-- Dumped from database version 18.0
-- Dumped by pg_dump version 18.0

-- Started on 2025-10-09 21:11:00

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16398)
-- Name: educationform; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.educationform (
    education_form_id integer NOT NULL,
    education_form_name character varying NOT NULL,
    education_form_code character varying NOT NULL,
    education_form_duration integer
);


ALTER TABLE public.educationform OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16408)
-- Name: enrollmentorder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollmentorder (
    order_id integer NOT NULL,
    order_number character varying NOT NULL,
    order_date date NOT NULL,
    order_base character varying NOT NULL,
    order_type character varying NOT NULL
);


ALTER TABLE public.enrollmentorder OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16387)
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    faculty_id integer NOT NULL,
    faculty_name character varying NOT NULL,
    dean_name character varying NOT NULL,
    dean_surname character varying NOT NULL,
    dean_patronymic character varying,
    faculty_phone character varying,
    faculty_email character varying
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16431)
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    student_id integer NOT NULL,
    student_name character varying NOT NULL,
    student_surname character varying NOT NULL,
    student_patronymic character varying,
    record_book_id character varying NOT NULL,
    birth_date date NOT NULL,
    student_email character varying,
    student_phone character varying,
    group_id integer,
    enrollment_order_id integer,
    education_form_id integer,
    student_status character varying NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16420)
-- Name: studentgroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.studentgroup (
    group_id integer NOT NULL,
    group_name character varying NOT NULL,
    enrollment_year integer NOT NULL,
    faculty_id integer,
    max_students integer,
    education_form_id integer,
    is_active boolean DEFAULT true,
    curriculum_id integer
);


ALTER TABLE public.studentgroup OWNER TO postgres;

--
-- TOC entry 4931 (class 0 OID 16398)
-- Dependencies: 220
-- Data for Name: educationform; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.educationform (education_form_id, education_form_name, education_form_code, education_form_duration) FROM stdin;
\.


--
-- TOC entry 4932 (class 0 OID 16408)
-- Dependencies: 221
-- Data for Name: enrollmentorder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollmentorder (order_id, order_number, order_date, order_base, order_type) FROM stdin;
\.


--
-- TOC entry 4930 (class 0 OID 16387)
-- Dependencies: 219
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty (faculty_id, faculty_name, dean_name, dean_surname, dean_patronymic, faculty_phone, faculty_email) FROM stdin;
\.


--
-- TOC entry 4934 (class 0 OID 16431)
-- Dependencies: 223
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (student_id, student_name, student_surname, student_patronymic, record_book_id, birth_date, student_email, student_phone, group_id, enrollment_order_id, education_form_id, student_status) FROM stdin;
\.


--
-- TOC entry 4933 (class 0 OID 16420)
-- Dependencies: 222
-- Data for Name: studentgroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.studentgroup (group_id, group_name, enrollment_year, faculty_id, max_students, education_form_id, is_active, curriculum_id) FROM stdin;
\.


--
-- TOC entry 4774 (class 2606 OID 16407)
-- Name: educationform educationform_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.educationform
    ADD CONSTRAINT educationform_pkey PRIMARY KEY (education_form_id);


--
-- TOC entry 4776 (class 2606 OID 16419)
-- Name: enrollmentorder enrollmentorder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollmentorder
    ADD CONSTRAINT enrollmentorder_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4772 (class 2606 OID 16397)
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (faculty_id);


--
-- TOC entry 4780 (class 2606 OID 16443)
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (student_id);


--
-- TOC entry 4782 (class 2606 OID 16445)
-- Name: student student_record_book_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_record_book_id_key UNIQUE (record_book_id);


--
-- TOC entry 4778 (class 2606 OID 16430)
-- Name: studentgroup studentgroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.studentgroup
    ADD CONSTRAINT studentgroup_pkey PRIMARY KEY (group_id);


-- Completed on 2025-10-09 21:11:00

--
-- PostgreSQL database dump complete
--

\unrestrict mlVZvCzxOxpYNxPkPaUtj0SZErUui43iVteClOPw1pzJaWltP0hszYdFrgbbWGw

