<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }

  $data = json_decode($_REQUEST['appSQL']);
  $rpta = 0;

  switch ($data->TipoQuery) {
    case "selMisiones":
      $tabla = array();

      //cargar datos de maestro
      $whr = " and id_padre=".$data->unionID;
      $whr .= (($data->buscar)!="")?(" and (nombre ilike'%".$data->buscar."%') "):("");
      $qryCount = $db->query_all("select count(*) as cuenta from igl_iglesias where estado=1 ".$whr.";");
      $rsCount = reset($qryCount);

      $qry = $db->query_all("select * from igl_iglesias where estado=1 ".$whr." order by nombre;");
      if ($qry) {
        foreach($qry as $rs){
          $tabla[] = array(
            "ID" => $rs["id"],
            "codigo" => ($rs["codigo"]),
            "abrevia" => ($rs["abrevia"]),
            "nombre" => ($rs["nombre"]),
            "activo" => ($rs["activo"]),
            "direccion" => ($rs["direccion"])
          );
        }
      }

      //respuesta
      $rpta = array("cuenta"=>$rsCount["cuenta"],"tabla"=>$tabla);
      $db->enviarRespuesta($rpta);
      break;
    case "editMision":
      $qry = $db->query_all("select m.*,p.id as id_provincia,r.id as id_region from igl_iglesias m,sis_ubigeo d,sis_ubigeo p,sis_ubigeo r where d.id=m.id_ubigeo and p.id=d.id_padre and r.id=p.id_padre and m.id=".($data->ID));
      if ($qry) {
        $rs = reset($qry);
        $tabla = array(
          "ID" => $rs["id"],
          "codigo" => ($rs["codigo"]),
          "nombre" => ($rs["nombre"]),
          "abrevia" => ($rs["abrevia"]),
          "direccion" => ($rs["direccion"]),
          "observac" => ($rs["observac"]),
          "id_distrito" => ($rs["id_ubigeo"]),
          "id_provincia" => ($rs["id_provincia"]),
          "id_region" => ($rs["id_region"])
        );
      }

      //respuesta
      $rpta = $tabla;
      $db->enviarRespuesta($rpta);
      break;
    case "execMision":
      switch($data->commandSQL){
        case "INS":
          $qry = $db->query_all("select coalesce(max(id)+1,1) as maxi from igl_iglesias");
          $rs = reset($qry);
          $params = [
            ":id"=>$rs["maxi"],
            ":codigo"=>$data->codigo,
            ":nombre"=>$data->nombre,
            ":abrevia"=>$data->abrevia,
            ":ubigeoID"=>$data->id_ubigeo,
            ":padreID"=>20, //id = Union Peruana del Sur
            ":direccion"=>$data->direccion,
            ":observac"=>$data->observac,
            ":tipo"=>4,
            ":activo"=>0,
            ":estado"=>1,
            ":sysuser"=>$_SESSION['usr_ID']
          ];
          $sql = "insert into igl_iglesias values(:id,:codigo,:nombre,:abrevia,:ubigeoID,:padreID,:direccion,:observac,:tipo,:activo,:estado,:sysuser,now());";
          $qry = $db->query_all($sql, $params);
          break;
        case "UPD":
          $params = [
            ":id"=>$data->ID,
            ":codigo"=>$data->codigo,
            ":nombre"=>$data->nombre,
            ":abrevia"=>$data->abrevia,
            ":ubigeoID"=>$data->id_ubigeo,
            ":direccion"=>$data->direccion,
            ":observac"=>$data->observac,
            ":sysuser"=>$_SESSION['usr_ID']
          ];
          $sql = "update igl_iglesias set codigo=:codigo,nombre=:nombre,abrevia=:abrevia,id_ubigeo=:ubigeoID,direccion=:direccion,observac=:observac,sysuser=:sysuser,sysfecha=now() where id=:id;";
          $qry = $db->query_all($sql, $params);
          break;
        case "DEL":
          for($xx = 0; $xx<count($data->IDs); $xx++){
            $sql = "update igl_iglesias set estado=0 where id=:id";
            $params = [":id"=>$data->IDs[$xx]];
            $qry = $db->query_all($sql, $params);
          }
          break;
      }

      $rpta = array("error" => false,"exec" => 1);
      $db->enviarRespuesta($rpta);
      break;
    case "ubigeo":
      //respuesta
      $rpta = $fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$data->padreID." order by nombre");
      $db->enviarRespuesta($rpta);
      break;
    case "comboUniones":
      $rpta = $fn->getComboBox("select * from igl_iglesias where id_padre=2 and estado=1 order by nombre");
      $db->enviarRespuesta($rpta);
      break;
  }
  $db->close();
?>
