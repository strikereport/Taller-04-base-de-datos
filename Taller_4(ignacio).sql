
--Ej 2

-- Tabla    CUENTA

CREATE TABLE CUENTA 
(
  NUMERO NUMBER NOT NULL 
, NOMBRE VARCHAR2(80) 
, DIRECCION VARCHAR2(100) 
, CIUDAD VARCHAR2(60) 
, FONO VARCHAR2(30) 
, SALDO NUMBER 
, CONSTRAINT CUENTA_PK PRIMARY KEY 
  (
    NUMERO 
  )
  ENABLE 
);

-- Tabla MOVIMIENTO

CREATE TABLE MOVIMIENTO 
(
  NUMERO NUMBER 
, OPERACION VARCHAR2(1) 
, NOMBRE VARCHAR2(80) 
, DIRECCION VARCHAR2(100) 
, CIUDAD VARCHAR2(60) 
, FONO VARCHAR2(30) 
, SALDO NUMBER 
);

-- Datos de Prueba

INSERT INTO "SYSTEM"."CUENTA" (NUMERO, NOMBRE, DIRECCION, CIUDAD, FONO, SALDO) VALUES ('111', 'ignacio', 'bajo el puente', 'antofagasta', '123456', '100000')
INSERT INTO "SYSTEM"."CUENTA" (NUMERO, NOMBRE, DIRECCION, CIUDAD, FONO, SALDO) VALUES ('222', 'carmen', 'casa carmen', 'valparaiso', '654321', '20000')
INSERT INTO "SYSTEM"."CUENTA" (NUMERO, NOMBRE, DIRECCION, CIUDAD, FONO, SALDO) VALUES ('333', 'solaris', 'sol', 'bialactea', '555555', '222222')

INSERT INTO "SYSTEM"."MOVIMIENTO" (NUMERO, OPERACION, NOMBRE, DIRECCION, CIUDAD, FONO, SALDO) VALUES ('6273', 'I', 'JOSE FUENTES SAVEEDRA', 'LATORRE 2210', 'ANTOFAGASTA', '55-214411', '200000')
INSERT INTO "SYSTEM"."MOVIMIENTO" (NUMERO, OPERACION, SALDO) VALUES ('111', 'U', '999999')
INSERT INTO "SYSTEM"."MOVIMIENTO" (NUMERO, OPERACION) VALUES ('333', 'D')
INSERT INTO "SYSTEM"."MOVIMIENTO" (NUMERO, OPERACION, NOMBRE, DIRECCION, CIUDAD, FONO, SALDO) VALUES ('222', 'I', 'MARCO', 'POLO', 'SANTIAGO', '55-334455', '442555')
INSERT INTO "SYSTEM"."MOVIMIENTO" (NUMERO, OPERACION, NOMBRE, DIRECCION, SALDO) VALUES ('777', 'U', 'DIEGO', 'XML', '3232')
INSERT INTO "SYSTEM"."MOVIMIENTO" (NUMERO, OPERACION) VALUES ('888', 'D')


-- Bloque

Declare
    cursor c is select * from MOVIMIENTO;
    cant NUMBER; 

    Procedure actualiza (u_numero in CUENTA.NUMERO%TYPE, u_nombre in CUENTA.NOMBRE%TYPE , u_direccion in CUENTA.DIRECCION%TYPE ,
                         u_ciudad in CUENTA.CIUDAD%TYPE, u_fono in CUENTA.FONO%TYPE , u_saldo in CUENTA.SALDO%TYPE)
        IS 
        od_numero CUENTA.NUMERO%TYPE;
        od_nombre CUENTA.NOMBRE%TYPE;
        od_direccion CUENTA.DIRECCION%TYPE;
        od_ciudad CUENTA.CIUDAD%TYPE;
        od_fono CUENTA.FONO%TYPE;
        od_saldo CUENTA.SALDO%TYPE;
        
        begin
            select NUMERO , NOMBRE , DIRECCION , CIUDAD , FONO , SALDO 
              into od_numero , od_nombre , od_direccion , od_ciudad , od_fono  , od_saldo
              from CUENTA
             where NUMERO = u_numero;

             update CUENTA
                set  
                    NOMBRE = nvl(u_nombre,od_nombre), 
                    DIRECCION = nvl(u_direccion,od_direccion), 
                    CIUDAD = nvl(u_ciudad,od_ciudad), 
                    FONO = nvl(u_fono,od_fono), 
                    SALDO = nvl(u_saldo,od_saldo)
              where NUMERO = u_numero;
                
    end actualiza;
    
    Procedure inserta (i_numero in CUENTA.NUMERO%TYPE, i_nombre in CUENTA.NOMBRE%TYPE , i_direccion in CUENTA.DIRECCION%TYPE ,
                       i_ciudad in CUENTA.CIUDAD%TYPE, i_fono in CUENTA.FONO%TYPE , i_saldo in CUENTA.SALDO%TYPE)
        IS
        begin
          insert into CUENTA
          values (i_numero , i_nombre  , i_direccion  , i_ciudad , i_fono  , i_saldo );
    end inserta; 
    Procedure borra(d_numero in CUENTA.NUMERO%TYPE)
        IS 
        begin
        delete from CUENTA
         where NUMERO = d_numero ; 
      
    end borra;  


begin
  for r in c loop
    
    select count(*)
      into cant
      from CUENTA
     where NUMERO = r.NUMERO;
    
    if cant > 0 and (r.OPERACION = 'I' or r.OPERACION = 'U') then
      actualiza(r.NUMERO,r.NOMBRE,r.DIRECCION, r.CIUDAD , r.FONO , r.SALDO);
    elsif r.OPERACION = 'I' or r.OPERACION = 'U' then
      inserta(r.NUMERO,r.NOMBRE,r.DIRECCION, r.CIUDAD , r.FONO , r.SALDO);
    elsif cant > 0 then
      borra(r.NUMERO);  
    end if;

  end loop;
end;  


-- Ej 3

CREATE TABLE COMPRA 
(
  NUMCUENTA NUMBER 
, RUTCLIENTE VARCHAR2(50) 
, MONTOCOMPRA NUMBER 
, FECHACOMPRA DATE 
);


create or replace trigger valCompra 
before insert on COMPRA 
for each row
Declare
suma NUMBER;
begin
  select sum(MONTOCOMPRA)
    into suma
    from COMPRA
   where NUMCUENTA = :new.NUMCUENTA and RUTCLIENTE = :new.RUTCLIENTE and trunc(FECHACOMPRA) = trunc(:new.FECHACOMPRA); 
 
  if (suma + :new.MONTOCOMPRA > 200000) then
    raise_application_error(-20000, 'monto diario exedido');
  end if;  

end;

-- EJ 1
create or replace function digitoVerificador(rut in varchar2)
return varchar2 
is 
  resultado number:=0;
  contador number(3):=2;
  numero varchar2(255);
begin
 for pos in reverse 1..length(rut) loop
   numero:=substr(rut,pos,1);
   if contador>7 then
      contador:=2;
   end if;
   resultado:=resultado + (to_number(numero)*contador);
   contador:=contador+1;
 end loop;
 resultado:=11-mod(resultado,11);
 if resultado=11 then
   numero:='k';
 else if resultado =10 then
   numero:='0';
 else 
   numero:=to_char(resultado);
 end if;  
 end if;
 return rut||'-'||numero;
end;

set serveroutput on;
declare
 rut varchar2(255);
begin 
 select digitoVerificador(&rutt)into rut from table1;
 dbms_output.put_line('--------------------------------------------');
 dbms_output.put_line('Rut: '||rut);
end;

