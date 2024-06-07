<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }

  $data = json_decode($_REQUEST['appSQL']);
  switch ($data->TipoQuery) {
    case "dashboard":
      //cantidad de predios
      $qry = $db->query_all("select count(*) as cuenta from predios p,igl_iglesias i where p.estado=1 and p.id_iglesia=i.id and i.id_padre=".$_SESSION['usr_data']['iglmision']);
      $predios = reset($qry)['cuenta'];
      
      //cantidad de dist. misio.
      $qry = $db->query_all("select count(*) as cuenta from igl_iglesias where estado=1 and id_padre=".$_SESSION['usr_data']['iglmision']);
      $dmisioneros = reset($qry)["cuenta"];

      //respuesta
      $db->enviarRespuesta(array(
        "predios" => $predios,
        "dmisioneros" => $dmisioneros
      ));
      break;
  }
  $db->close();
?>
