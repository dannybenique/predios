<?php
  include_once('../../../includes/sess_verifica.php');

  if(isset($_SESSION["usr_ID"])){
    if (isset($_REQUEST["appSQL"])){
      include_once('../../../includes/db_database.php');
      include_once('../../../includes/funciones.php');

      $data = json_decode($_REQUEST['appSQL']);
      $rpta = 0;

      switch ($data->TipoQuery) {
        //****************contabilidad****************
        case "selUbigeo":
          //cargar Ubigeo
          $pID = (array_key_exists('id',$_REQUEST)) ? ($pID = $_REQUEST['id']) : (0);
          $qry = $db->query_all("select * from sis_ubigeo where id_padre=".$pID." order by id;");
          if ($qry) {
            $tabla = array();
            foreach($qry as $rs){
              //$rscount = $db->fetch_array($db->query("select count(*) as cuenta from sis_ubigeo where id_padre=".$rs["id"]));
              $tabla[] = array(
                "id" => ($rs["id"]),
                "pId" => ($pID),
                "name" => ($rs["codigo"])." - ".($rs["nombre"]),
                "isParent"=>(strlen($rs["id"])<6 ? true : false)
              );
            }
          }
          //respuesta
          header('Content-Type: application/json');
          echo json_encode($tabla);
          break;
        case "editUbigeo": //falta corregir
          //verificar usuario
          $qryusr = $db->query_all("select admin from igl_usuarios where id=".$_SESSION['usr_ID'].";");
          $rsusr = reset($qryusr);
          $usuario = array(
            "id_usuario" => $_SESSION['usr_ID'],
            "usernivel" => $rsusr["admin"],
            "admin" => 701
          );

          //verificar Cuenta Contable
          $tabla = array();
          $qry = $db->query_all("select * from vw_conta_cuentas where ID=".$data->ID);
          if ($qry) { $rs = reset($qry); }
          $tabla = array(
            "ID" => ($rs["ID"]),
            "codigo" => ($rs["codigo"]),
            "nombre"=> ($rs["nombre"]),
            "id_padre"=> ($rs["id_padre"]),
            "nombrePadre" => ($rs["nombrePadre"])
          );

          $rpta = array("tabla"=>$tabla,"usuario"=>$usuario);
          header('Content-Type: application/json');
          echo json_encode($rpta);
          break;
        case "execUbigeo": //falta corregir
          $rpta = array();
          $params = array();
          $sql = "exec sp_conta_cuentas '".$data->commandSQL."',".($data->ID).",'".($data->codigo)."','".($data->nombre)."',".($data->padreID).",'".$fn->getClientIP()."',".$_SESSION['usr_ID'];
          $qry = $db->query_all($sql, $params);
          $rs = reset($qry);
          
          //respuesta
          $rpta = array("error" => 0,"afectados" => 1);
          header('Content-Type: application/json');
          echo json_encode($rpta);
          break;
      }
      $db->close();
    } else{
      $resp = array("error"=>true,"mensaje"=>"ninguna variable en POST");
      echo json_encode($resp);
    }
  } else {
    $resp = array("error"=>true,"mensaje"=>"Caducó la sesion.");
    echo json_encode($resp);
  }
?>
