PGDMP     ,    /                z            wk    14.5    14.5                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16667    wk    DATABASE     b   CREATE DATABASE wk WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE wk;
                postgres    false                        2615    16668    teste_delphi    SCHEMA        CREATE SCHEMA teste_delphi;
    DROP SCHEMA teste_delphi;
                postgres    false                       0    0    SCHEMA teste_delphi    COMMENT     <   COMMENT ON SCHEMA teste_delphi IS 'standard public schema';
                   postgres    false    6            �            1255    16669 �   endereco_enderecointegracao(bigint, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     �  CREATE PROCEDURE teste_delphi.endereco_enderecointegracao(IN a_idpessoa bigint, IN a_dscep character varying, IN a_dsuf character varying, IN a_nmcidade character varying, IN a_nmbairro character varying, IN a_nmlogradouro character varying, IN a_dscomplemento character varying)
    LANGUAGE plpgsql
    AS $$
	
DECLARE
  _idendereco BIGINT;
BEGIN

INSERT INTO teste_delphi.endereco (
	idpessoa, 
	dscep
) VALUES (
	a_idpessoa,
	a_dscep
)RETURNING idendereco INTO _idendereco;

INSERT INTO teste_delphi.endereco_integracao (
	idendereco,
	dsuf, 
	nmcidade, 
	nmbairro, 
	nmlogradouro, 
	dscomplemento
) VALUES (
	_idendereco,
	a_dsuf, 
	a_nmcidade, 
	a_nmbairro, 
	a_nmlogradouro, 
	a_dscomplemento
);

END;
$$;
   DROP PROCEDURE teste_delphi.endereco_enderecointegracao(IN a_idpessoa bigint, IN a_dscep character varying, IN a_dsuf character varying, IN a_nmcidade character varying, IN a_nmbairro character varying, IN a_nmlogradouro character varying, IN a_dscomplemento character varying);
       teste_delphi          postgres    false    6            �            1255    16670 �   pessoa_endereco(integer, character varying, character varying, character varying, date, character varying, character varying, character varying, character varying, character varying, character varying) 	   PROCEDURE     6  CREATE PROCEDURE teste_delphi.pessoa_endereco(IN a_flnatureza integer, IN a_dsdocumento character varying, IN a_nmprimeiro character varying, IN a_nmsegundo character varying, IN a_dtregistro date, IN a_dscep character varying, IN a_dsuf character varying, IN a_nmcidade character varying, IN a_nmbairro character varying, IN a_nmlogradouro character varying, IN a_dscomplemento character varying)
    LANGUAGE plpgsql
    AS $$
	
DECLARE 
  _idpessoa   BIGINT;
  _idendereco BIGINT;
BEGIN

INSERT INTO teste_delphi.pessoa (
	flnatureza, 
	dsdocumento, 
	nmprimeiro, 
	nmsegundo, 
	dtregistro
) VALUES (
	a_flnatureza,
	a_dsdocumento,
	a_nmprimeiro,
	a_nmsegundo,
	a_dtregistro
) RETURNING idpessoa INTO _idpessoa;

INSERT INTO teste_delphi.endereco (
	idpessoa, 
	dscep
) VALUES (
	_idpessoa,
	a_dscep
)RETURNING idendereco INTO _idendereco;

INSERT INTO teste_delphi.endereco_integracao (
	idendereco,
	dsuf, 
	nmcidade, 
	nmbairro, 
	nmlogradouro, 
	dscomplemento
) VALUES (
	_idendereco,
	a_dsuf, 
	a_nmcidade, 
	a_nmbairro, 
	a_nmlogradouro, 
	a_dscomplemento
);

END;
$$;
 �  DROP PROCEDURE teste_delphi.pessoa_endereco(IN a_flnatureza integer, IN a_dsdocumento character varying, IN a_nmprimeiro character varying, IN a_nmsegundo character varying, IN a_dtregistro date, IN a_dscep character varying, IN a_dsuf character varying, IN a_nmcidade character varying, IN a_nmbairro character varying, IN a_nmlogradouro character varying, IN a_dscomplemento character varying);
       teste_delphi          postgres    false    6            �            1259    16671    endereco    TABLE     �   CREATE TABLE teste_delphi.endereco (
    idendereco bigint NOT NULL,
    idpessoa bigint NOT NULL,
    dscep character varying(15)
);
 "   DROP TABLE teste_delphi.endereco;
       teste_delphi         heap    postgres    false    6            �            1259    16674    endereco_idendereco_seq    SEQUENCE     �   CREATE SEQUENCE teste_delphi.endereco_idendereco_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE teste_delphi.endereco_idendereco_seq;
       teste_delphi          postgres    false    6    210            	           0    0    endereco_idendereco_seq    SEQUENCE OWNED BY     _   ALTER SEQUENCE teste_delphi.endereco_idendereco_seq OWNED BY teste_delphi.endereco.idendereco;
          teste_delphi          postgres    false    211            �            1259    16675    endereco_integracao    TABLE       CREATE TABLE teste_delphi.endereco_integracao (
    idendereco bigint NOT NULL,
    dsuf character varying(50),
    nmcidade character varying(100),
    nmbairro character varying(50),
    nmlogradouro character varying(100),
    dscomplemento character varying(100)
);
 -   DROP TABLE teste_delphi.endereco_integracao;
       teste_delphi         heap    postgres    false    6            �            1259    16678    pessoa    TABLE     	  CREATE TABLE teste_delphi.pessoa (
    idpessoa bigint NOT NULL,
    flnatureza smallint NOT NULL,
    dsdocumento character varying(20) NOT NULL,
    nmprimeiro character varying(100) NOT NULL,
    nmsegundo character varying(100) NOT NULL,
    dtregistro date
);
     DROP TABLE teste_delphi.pessoa;
       teste_delphi         heap    postgres    false    6            �            1259    16681    pessoa_idpessoa_seq    SEQUENCE     �   CREATE SEQUENCE teste_delphi.pessoa_idpessoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE teste_delphi.pessoa_idpessoa_seq;
       teste_delphi          postgres    false    6    213            
           0    0    pessoa_idpessoa_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE teste_delphi.pessoa_idpessoa_seq OWNED BY teste_delphi.pessoa.idpessoa;
          teste_delphi          postgres    false    214            h           2604    16682    endereco idendereco    DEFAULT     �   ALTER TABLE ONLY teste_delphi.endereco ALTER COLUMN idendereco SET DEFAULT nextval('teste_delphi.endereco_idendereco_seq'::regclass);
 H   ALTER TABLE teste_delphi.endereco ALTER COLUMN idendereco DROP DEFAULT;
       teste_delphi          postgres    false    211    210            i           2604    16683    pessoa idpessoa    DEFAULT     ~   ALTER TABLE ONLY teste_delphi.pessoa ALTER COLUMN idpessoa SET DEFAULT nextval('teste_delphi.pessoa_idpessoa_seq'::regclass);
 D   ALTER TABLE teste_delphi.pessoa ALTER COLUMN idpessoa DROP DEFAULT;
       teste_delphi          postgres    false    214    213            �          0    16671    endereco 
   TABLE DATA           E   COPY teste_delphi.endereco (idendereco, idpessoa, dscep) FROM stdin;
    teste_delphi          postgres    false    210   H)       �          0    16675    endereco_integracao 
   TABLE DATA           v   COPY teste_delphi.endereco_integracao (idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento) FROM stdin;
    teste_delphi          postgres    false    212   x)                  0    16678    pessoa 
   TABLE DATA           l   COPY teste_delphi.pessoa (idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro) FROM stdin;
    teste_delphi          postgres    false    213   �)                  0    0    endereco_idendereco_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('teste_delphi.endereco_idendereco_seq', 4728, true);
          teste_delphi          postgres    false    211                       0    0    pessoa_idpessoa_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('teste_delphi.pessoa_idpessoa_seq', 4774, true);
          teste_delphi          postgres    false    214            k           2606    16685    endereco endereco_pk 
   CONSTRAINT     `   ALTER TABLE ONLY teste_delphi.endereco
    ADD CONSTRAINT endereco_pk PRIMARY KEY (idendereco);
 D   ALTER TABLE ONLY teste_delphi.endereco DROP CONSTRAINT endereco_pk;
       teste_delphi            postgres    false    210            m           2606    16687 )   endereco_integracao enderecointegracao_pk 
   CONSTRAINT     u   ALTER TABLE ONLY teste_delphi.endereco_integracao
    ADD CONSTRAINT enderecointegracao_pk PRIMARY KEY (idendereco);
 Y   ALTER TABLE ONLY teste_delphi.endereco_integracao DROP CONSTRAINT enderecointegracao_pk;
       teste_delphi            postgres    false    212            o           2606    16689    pessoa pessoa_pk 
   CONSTRAINT     Z   ALTER TABLE ONLY teste_delphi.pessoa
    ADD CONSTRAINT pessoa_pk PRIMARY KEY (idpessoa);
 @   ALTER TABLE ONLY teste_delphi.pessoa DROP CONSTRAINT pessoa_pk;
       teste_delphi            postgres    false    213            p           2606    16690    endereco endereco_fk_pessoa    FK CONSTRAINT     �   ALTER TABLE ONLY teste_delphi.endereco
    ADD CONSTRAINT endereco_fk_pessoa FOREIGN KEY (idpessoa) REFERENCES teste_delphi.pessoa(idpessoa) ON DELETE CASCADE;
 K   ALTER TABLE ONLY teste_delphi.endereco DROP CONSTRAINT endereco_fk_pessoa;
       teste_delphi          postgres    false    3183    213    210            q           2606    16695 2   endereco_integracao enderecointegracao_fk_endereco    FK CONSTRAINT     �   ALTER TABLE ONLY teste_delphi.endereco_integracao
    ADD CONSTRAINT enderecointegracao_fk_endereco FOREIGN KEY (idendereco) REFERENCES teste_delphi.endereco(idendereco) ON DELETE CASCADE;
 b   ALTER TABLE ONLY teste_delphi.endereco_integracao DROP CONSTRAINT enderecointegracao_fk_endereco;
       teste_delphi          postgres    false    210    3179    212            �       x�3170�4175�43206107������ 5.�      �      x�3170��=... ^�          2   x�3175�4�4F�I�yY�������y)�Ŝ�����F��\1z\\\ j��     