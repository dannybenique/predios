<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }

  $data = json_decode($_REQUEST['appSQL']);
  $rpta = 0;

  switch ($data->TipoQuery) {
    case "selDistritos":
      $tabla = array();

      //cargar datos de maestro
      $whr = (($data->misionID)=="0")?(""):(" and id_padre=".$data->misionID);
      $whr .= (($data->buscar)!="")?(" and (nombre ilike'%".$data->buscar."%') "):("");
      $qryCount = $db->query_all("select count(*) as cuenta from igl_iglesias where estado=1 ".$whr.";");
      $rsCount = reset($qryCount);

      $qry = $db->query_all("select i.*,u.region from igl_iglesias i,vw_ubigeo u where estado=1 and i.id_ubigeo=u.id_distrito ".$whr." order by region,nombre;");
      if ($qry) {
        foreach($qry as $rs){
          $cant_Igl = 0;
          $cant_Grp = 0;
          $cant_Otr = 0;
          
          $qrx = $db->query_all("select id_clase,count(*) as cant from predios where estado=1 and id_iglesia=".$rs["id"]." group by id_clase order by id_clase;");
          foreach($qrx as $rx){
            switch($rx["id_clase"]){
              case 101: $cant_Igl = $rx["cant"]; break; //iglesias
              case 102: $cant_Grp = $rx["cant"]; break; //grupos
              default: $cant_Otr += $rx["cant"]; break; //Otros
            }
          }
          $tabla[] = array(
            "ID" => $rs["id"],
            "codigo" => ($rs["codigo"]),
            "nombre" => ($rs["nombre"]),
            "region" => ($rs["region"]),
            "iglesias" => ($cant_Igl),
            "grupos" => ($cant_Grp),
            "otros" => ($cant_Otr)
          );
        }
      }

      //respuesta
      $rpta = array("cuenta"=>$rsCount["cuenta"],"tabla"=>$tabla);
      $db->enviarRespuesta($rpta);
      break;
    case "editDistrito":
      $qry = $db->query_all("select i.*,p.id as id_provincia,r.id as id_region from igl_iglesias i,sis_ubigeo d,sis_ubigeo p,sis_ubigeo r where d.id=i.id_ubigeo and p.id=d.id_padre and r.id=p.id_padre and i.id=".$data->ID);
      if ($qry) {
        $rs = reset($qry);
        $tabla = array(
          "ID" => $rs["id"],
          "codigo" => ($rs["codigo"]),
          "nombre" => ($rs["nombre"]),
          "iglmision" => ($rs["id_padre"]),
          "id_distrito" => ($rs["id_ubigeo"]),
          "id_provincia" => ($rs["id_provincia"]),
          "id_region" => ($rs["id_region"])
        );
      }

      //respuesta
      $rpta = $tabla;
      $db->enviarRespuesta($rpta);
      break;
    case "execDistrito":
      switch($data->commandSQL){
        case "INS":
          $qry = $db->query_all("select coalesce(max(id)+1,1) as maxi from igl_iglesias");
          $rs = reset($qry);
          $params = [
            ":id"=>$rs["maxi"],
            ":codigo"=>$data->codigo,
            ":nombre"=>$data->nombre,
            ":abrevia"=>null,
            ":ubigeoID"=>$data->id_ubigeo,
            ":padreID"=>$data->id_padre,
            ":direccion"=>null,
            ":observac"=>null,
            ":tipo"=>5,
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
            ":ubigeoID"=>$data->id_ubigeo,
            ":sysuser"=>$_SESSION['usr_ID']
          ];
          $sql = "update igl_iglesias set codigo=:codigo,nombre=:nombre,id_ubigeo=:ubigeoID,sysuser=:sysuser,sysfecha=now() where id=:id;";
          $qry = $db->query_all($sql, $params);
          break;
        case "DEL":
          for($xx = 0; $xx<count($data->IDs); $xx++){
            $sql = "update igl_iglesias set estado=0,sysfecha=now() where id=:id";
            $params = [":id"=>$data->IDs[$xx]];
            $qry = $db->query_all($sql, $params);
          }
          break;
      }

      $rpta = array("error" => false,"exec" => 1);
      $db->enviarRespuesta($rpta);
      break;
    case "comboMisiones":
      $misionID = ($_SESSION['usr_data']['iglmision']==0)?(1):($_SESSION['usr_data']['iglmision']);
      $rpta = array("misionID"=>$misionID,"tabla"=>$fn->getComboBox("select id,nombre from igl_iglesias where id_padre=20 and estado=1 order by nombre"));
      //respuesta
      $db->enviarRespuesta($rpta);
      break;
    case "ubigeo":
      //respuesta
      $db->enviarRespuesta($fn->getComboBox("select id,nombre from sis_ubigeo where id_padre=".$data->padreID." order by nombre"));
      break;
  }
  $db->close();
?>
