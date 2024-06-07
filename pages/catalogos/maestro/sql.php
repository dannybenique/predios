<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }
  
  $data = json_decode($_REQUEST['appSQL']);
  $rpta = 0;
  
//****************respuesta JSON****************
switch ($data->TipoQuery) {
  case "comboMaestro":
    //respuesta
    $db->enviarRespuesta($fn->getComboBox("select id,nombre from maestro where id_padre is null order by id;"));
    break;
  case "selMaestro":
    $tabla = array();

    //cargar datos de maestro
    $whr = (($data->buscar)!="")?(" and (nombre ilike'%".$data->buscar."%') "):("");
    $qryCount = $db->query_all("select count(*) as cuenta from maestro where estado=1 and id_padre=".$data->padreID.$whr.";");
    $rsCount = reset($qryCount);

    $qry = $db->query_all("select * from maestro where estado=1 and id_padre=".$data->padreID.$whr." order by nombre;");
    if ($qry) {
      foreach($qry as $rs){
        switch($data->padreID){
          case 1: $sqlTotal = "select count(*) as total from predios where estado=1 and id_clase=".$rs["id"]; break; //clases
          case 2: $sqlTotal = "select count(*) as total from predios_docum d,predios p where p.id=d.id_predio and p.estado=1 and d.id_fedatario=".$rs["id"]; break; //fedatarios
          case 3: $sqlTotal = "select count(*) as total from predios_docum d,predios p where p.id=d.id_predio and p.estado=1 and d.id_modo=".$rs["id"]; break; //modos
          case 4: $sqlTotal = "select count(*) as total from predios_docum d,predios p where p.id=d.id_predio and p.estado=1 and d.id_moneda=".$rs["id"]; break; //monedas
          case 5: $sqlTotal = "select count(*) as total from predios_docum d,predios p where p.id=d.id_predio and p.estado=1 and d.id_titulo=".$rs["id"]; break; //titulos
          case 6: $sqlTotal = "select count(*) as total from predios_usos u, predios p where p.id=u.id_predio and p.estado=1 and u.id_principal=".$rs["id"]; break; //usos
          case 7: $sqlTotal = "select count(*) as total from predios_docum d,predios p where p.id=d.id_predio and p.estado=1 and d.conditerreno=".$rs["id"]; break; //condicion terreno
        }
        $qrx = $db->query_all($sqlTotal);
        $rsTotal = reset($qrx);

        $tabla[] = array(
          "ID" => $rs["id"],
          "codigo"=> ($rs["codigo"]),
          "total" => ($rsTotal["total"])*1,
          "nombre"=> ($rs["nombre"])
        );
      }
    }

    //respuesta
    $rpta = array("cuenta"=>$rsCount["cuenta"],"tabla"=>$tabla);
    $db->enviarRespuesta($rpta);
    break;
  case "editMaestro":
    $qry = $db->query_all("select * from maestro where id=".$data->ID);
    if ($qry) {
      $rs = reset($qry);
      $tabla = array(
        "ID" => $rs["id"],
        "codigo" => ($rs["codigo"]),
        "nombre" => ($rs["nombre"]),
        "abrevia" => ($rs["abrevia"]),
        "padreID" => ($rs["id_padre"]),
        "sysuser" => ($rs["sysuser"]),
        "sysfecha" => ($rs["sysfecha"])
      );
    }

    //respuesta
    $rpta = $tabla;
    $db->enviarRespuesta($rpta);
    break;
  case "execMaestro":
    switch($data->commandSQL){
      case "INS":
        $qrx = $db->query_all("select coalesce(max(id)+1,1) as maxi from maestro");
        $rs = reset($qrx);
        $params = [
          ":id"=>$rs["maxi"],
          ":codigo"=>$data->codigo,
          ":nombre"=>$data->nombre,
          ":abrevia"=>$data->abrevia,
          ":padreID"=>$data->id_padre,
          ":estado"=>"1",
          ":sysuser"=>$_SESSION['usr_ID']
        ];
        $sql = "insert into maestro values(:id,:codigo,:nombre,:abrevia,:padreID,:estado,:sysuser,now());";
        $qry = $db->query_all($sql, $params);
        break;
      case "UPD":
        $params = [
          "id"=>$data->ID,
          "codigo"=>$data->codigo,
          "nombre"=>$data->nombre,
          "abrevia"=>$data->abrevia,
          "sysuser"=>$_SESSION['usr_ID']
        ];
        $sql = "update maestro set codigo=:codigo,nombre=:nombre,abrevia=:abrevia,sysuser=:sysuser,sysfecha=now() where id=:id;";
        $qry = $db->query_all($sql, $params);
        break;
      case "DEL":
        for($xx = 0; $xx<count($data->IDs); $xx++){
          $sql = "update maestro set estado=0,sysfecha=now() where id=:id";
          $params = [":id"=>$data->IDs[$xx]];
          $qry = $db->query_all($sql, $params);
        }
        break;
    }

    $rpta = array("error" => false,"exec" => 1);
    $db->enviarRespuesta($rpta);
    break;
}
$db->close();
?>
