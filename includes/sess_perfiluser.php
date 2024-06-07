<?php
  include_once('db_database.php');
  $tabla = array();
  $qry = $db->query_all("select * from igl_usuarios_perfil where id_usuario=".$_SESSION['usr_ID']." order by id_tabla;");
  if ($qry) {
    foreach($qry as $index=>$rs){
      $tabla[$index] = array(
        "tabla" => $rs["id_tabla"],
        "sel" => $rs["sel"],
        "ins" => $rs["ins"],
        "upd" => $rs["upd"],
        "del" => $rs["del"]
      );
    }
    $_SESSION["usr_perfil"] = $tabla;
  }
?>
