<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }
  
  $data = json_decode($_REQUEST['appSQL']);

  switch ($data->TipoQuery) {
    case "predio_new": //nuevo predio
      $qry = $db->query_all("select to_char(now(), 'YYYYMMDD-') as codigo,i.tipo from igl_iglesias i, igl_usuarios u where i.id=u.id_iglesia and u.id=".$_SESSION['usr_ID']);
      $rs = reset($qry);
      $codigo = $rs["codigo"].str_pad($_SESSION['usr_ID'],5,"0",STR_PAD_LEFT);//fecha-userID
      $tipo = $rs["tipo"];

      $dmisioneros = $fn->getComboBox("select i.id,i.nombre from igl_iglesias i, igl_usuarios u where i.id_padre=u.id_iglesia and u.id=".$_SESSION['usr_ID']." order by i.nombre;");
      $clases = $fn->getComboBox("select id,nombre from maestro where id_padre=1 and estado=1 order by nombre;");
      $regiones = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=0 order by nombre;");
      $provincias = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$regiones[0]["ID"]." order by nombre;");
      $distritos = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$provincias[0]["ID"]." order by nombre;");

      //respuesta
      $rpta = array(
        "error" => false,
        "codigo" => $codigo,
        "regiones" => $regiones,
        "provincias" => $provincias,
        "distritos" => $distritos,
        "error_dmisioneros" => $tipo, //tipo=4 acceso de mision SIN errores
        "dmisioneros" => $dmisioneros,
        "clases" => $clases
      );
      $db->enviarRespuesta($rpta);
      break;
    case "predio_edit": //editar predio
      //consultar por el ID
      $qry = $db->query_all("select p.*,u.*,u.id_region,u.id_provincia from predios p,vw_ubigeo u where p.id_distrito=u.id_distrito and p.id=".$data->predioID);
      if ($qry) {
        $rs = reset($qry);
        $predio = array(
          "ID" => $rs["id"],
          "id_clase" => $rs["id_clase"],
          "id_igldistrito" => $rs["id_iglesia"],
          "codigo" => $rs["codigo"],
          "per_juridica" => $rs["per_juridica"],
          "mision" => $rs["mision"],
          "nombre" => $rs["nombre"],
          "telefono" => $rs["telefono"],
          "correo" => $rs["correo"],
          "observac" => $rs["observac"],
          "id_region" => $rs["id_region"],
          "id_provincia" => $rs["id_provincia"],
          "id_distrito" => $rs["id_distrito"],
          "sector" => $rs["sector"],
          "avenida" => $rs["avenida"],
          "nro" => $rs["nro"],
          "dpto" => $rs["dpto"],
          "mza" => $rs["mza"],
          "lote" => $rs["lote"],
          "maps" => $rs["maps"]
        );
      }

      $qry = $db->query_all("select i.tipo from igl_iglesias i, igl_usuarios u where i.id=u.id_iglesia and u.id=".$_SESSION['usr_ID']);
      $tipo = reset($qry)["tipo"];
      $dmisioneros = $fn->getComboBox("select i.id,i.nombre from igl_iglesias i,igl_usuarios u where i.id_padre=u.id_iglesia and u.id=".$_SESSION['usr_ID']." order by i.nombre;");
      $clases = $fn->getComboBox("select id,nombre from maestro where id_padre=1 and estado=1 order by nombre;");
      $regiones = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=0 order by nombre;");
      $provincias = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$rs["id_region"]." order by nombre;");
      $distritos = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$rs["id_provincia"]." order by nombre;");

      $rpta = array(
        "error" => false,
        "regiones" => $regiones,
        "provincias" => $provincias,
        "distritos" => $distritos,
        "error_dmisioneros" => $tipo, //tipo=4 acceso de mision SIN errores
        "dmisioneros" => $dmisioneros,
        "clases" => $clases,
        "predio" => $predio
      );
      $db->enviarRespuesta($rpta);
      break;
    case "predio_ins": //insert predio
      try {
        $qry = $db->query_all("select coalesce(max(id)+1,1) as maxi from predios;");
        $predioID = reset($qry)["maxi"];
        
        $codigo = $data->codigo."-".str_pad($predioID,8,"0",STR_PAD_LEFT);
        $params = [
          ":id"=>$predioID,
          ":claseID"=>$data->id_clase,
          ":iglesiaID"=>$data->id_iglesia,
          ":codigo"=>$codigo,
          ":perjuridica"=>$data->per_juridica,
          ":mision"=>$data->mision,
          ":nombre"=>$data->nombre,
          ":telefono"=>$data->telefono,
          ":correo"=>$data->correo,
          ":distritoID"=>$data->id_distrito,
          ":sector"=>$data->sector,
          ":avenida"=>$data->avenida,
          ":nro"=>$data->nro,
          ":dpto"=>$data->dpto,
          ":mza"=>$data->mza,
          ":lote"=>$data->lote,
          ":maps"=>$data->maps,
          ":observac"=>$data->observac,
          ":estado"=>1,
          ":sysuser"=>$_SESSION["usr_ID"]
        ];
        $sql = "insert into predios values(:id,:claseID,:iglesiaID,:codigo,:perjuridica,:mision,:nombre,:telefono,:correo,:distritoID,:sector,:avenida,:nro,:dpto,:mza,:lote,:maps,:observac,:estado,:sysuser,now())";
        $qry = $db->query_all($sql, $params);

        $rpta = array(
          "error"=>0,
          "tablaPredio"=>$fn->getPredio($predioID),
          "fedatarios"=>$fn->getComboBox("select id,nombre from maestro where id_padre=2 and estado=1 order by nombre;"),
          "modos"=>$fn->getComboBox("select id,nombre from maestro where id_padre=3 and estado=1 order by nombre;"),
          "monedas"=>$fn->getComboBox("select id,nombre from maestro where id_padre=4 and estado=1 order by nombre;"),
          "titulos"=>$fn->getComboBox("select id,nombre from maestro where id_padre=5 and estado=1 order by nombre;"),
          "usos"=>$fn->getComboBox("select id,nombre from maestro where id_padre=6 and estado=1 order by nombre;"),
          "conditerreno"=>$fn->getComboBox("select id,nombre from maestro where id_padre=7 and estado=1 order by nombre;")
        );
        $db->enviarRespuesta($rpta);
      } catch(Exception $e) { $db->enviarRespuesta($e->getMessage()); }
      break;
    case "predio_upd": //update predio
      try {
        //datos para DB
        $params = [
          ":id"=>$data->ID,
          ":claseID"=>$data->id_clase,
          ":iglesiaID"=>$data->id_iglesia,
          ":codigo"=>$data->codigo,
          ":perjuridica"=>$data->per_juridica,
          ":mision"=>$data->mision,
          ":nombre"=>$data->nombre,
          ":telefono"=>$data->telefono,
          ":correo"=>$data->correo,
          ":distritoID"=>$data->id_distrito,
          ":sector"=>$data->sector,
          ":avenida"=>$data->avenida,
          ":nro"=>$data->nro,
          ":dpto"=>$data->dpto,
          ":mza"=>$data->mza,
          ":lote"=>$data->lote,
          ":maps"=>$data->maps,
          ":observac"=>$data->observac,
          ":sysuser"=>$_SESSION["usr_ID"]
        ];
        $sql = "update predios set id_clase=:claseID,id_iglesia=:iglesiaID,codigo=:codigo,per_juridica=:perjuridica,mision=:mision,nombre=:nombre,telefono=:telefono,correo=:correo,id_distrito=:distritoID,sector=:sector,avenida=:avenida,nro=:nro,dpto=:dpto,mza=:mza,lote=:lote,maps=:maps,observac=:observac,sysuser=:sysuser,sysfecha=now() where id=:id";
        $qry = $db->query_all($sql,$params);

        //respuesta
        $rpta = array("error"=>false, "tablaPredio"=>$fn->getPredio($data->ID));
        $db->enviarRespuesta($rpta);
      } catch(Exception $e) { $db->enviarRespuesta($e->getMessage()); }
      break;
    case "comboUbigeo":
      switch(strlen(strval($data->padreID))){
        case 2: //actualiza provincia
          $provincias = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$data->padreID." order by nombre;");
          $distritos = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$provincias[0]["ID"]." order by nombre;");
          $rpta = array("provincias"=>$provincias, "distritos"=>$distritos);
          break;
        case 4: //actualiza distrito
          $distritos = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$data->padreID." order by nombre;");
          $rpta = array("distritos"=>$distritos);
          break;
      }
      $db->enviarRespuesta($rpta);
      break;
  }
  $db->close();
  ?>
