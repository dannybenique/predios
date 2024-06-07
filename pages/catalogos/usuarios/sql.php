<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }

  $data = json_decode($_REQUEST['appSQL']);
  $rpta = 0;

  switch ($data->TipoQuery) {
    case "selUsuarios":
      $tabla = array();

      //cargar datos de maestro
      $whr = ($data->misionID>0)?(" and (u.id_iglesia=".$data->misionID." or u.id_iglesia in (select id from igl_iglesias where id_padre=".$data->misionID."))"):("");
      $whr .= (($data->buscar)!="")?(" and (concat(u.name,', ',u.lastname) ilike'%".$data->buscar."%') "):("");
      $qryCount = $db->query_all("select count(u.*) as cuenta from igl_usuarios u where u.estado=1 ".$whr.";");
      $rsCount = reset($qryCount);

      $sql = "select u.*,i.nombre,i.tipo,i.abrevia,ub.region from igl_usuarios u join igl_iglesias as i on u.id_iglesia=i.id left join vw_ubigeo as ub on i.id_ubigeo=ub.id_distrito where u.estado=1 ".$whr." order by i.tipo,ub.region,u.lastname,u.name;";
      $qry = $db->query_all($sql);
      if ($qry) {
        foreach($qry as $rs){
          $tabla[] = array(
            "ID" => $rs["id"],
            "login" => ($rs["login"]),
            "usuario" => ($rs["lastname"].", ".$rs["name"]),
            "abrevia" => ($rs["abrevia"]==null)?($rs["nombre"]):($rs["abrevia"]),
            "misionID" => ($rs["id_iglesia"]),
            "region" => ($rs["region"])
          );
        }
      }

      //respuesta
      $rpta = array("sql"=>$sql,"cuenta"=>$rsCount["cuenta"],"tabla"=>$tabla);
      $db->enviarRespuesta($rpta);
      break;
    case "editUsuario":
      $qry = $db->query_all("select * from igl_usuarios where id=".($data->ID));
      if ($qry) {
        $rs = reset($qry);
        $tabla = array(
          "ID" => $rs["id"],
          "nombres" => ($rs["name"]),
          "apellidos" => ($rs["lastname"]),
          "login" => ($rs["login"]),
          "admin" => ($rs["admin"]),
          "id_iglmision" => ($rs["id_iglesia"])
        );
      }

      //respuesta
      $db->enviarRespuesta($tabla);
      break;
    case "execUsuario":
      switch($data->commandSQL){
        case "INS":
          //maximo ID para usuario
          $qry = $db->query_all("select coalesce(max(id)+1,1) as maxi from igl_usuarios");
          $id = reset($qry)["maxi"];
          
          //ingresar usuario
          $params = [
            ":id"=>$id,
            ":misionID"=>$data->misionID,
            ":login"=>$data->login,
            ":passw"=>null,
            ":nombres"=>$data->nombres,
            ":apellidos"=>$data->apellidos,
            ":estado"=>1,
            ":admin"=>$data->admin,
            ":sysuser"=>$_SESSION['usr_ID']
          ];
          $sql = "insert into igl_usuarios values(:id,:misionID,:login,:passw,:nombres,:apellidos,:estado,:admin,:sysuser,now());";
          $qry = $db->query_all($sql, $params);

          //ingresar perfil inicial
          $sql = "insert into igl_usuarios_perfil select u.id as id_usuario,c.id as id_tabla,0 as sel,0 as ins,0 as upd,0 as del from igl_usuarios u,config_tablas c where u.id=".$id." order by id_usuario,id_tabla;";
          $qry = $db->query_all($sql);
          break;
        case "UPD":
          $params = [
            ":id"=>$data->ID,
            ":misionID"=>$data->misionID,
            ":nombres"=>$data->nombres,
            ":apellidos"=>$data->apellidos,
            ":login"=>$data->login,
            ":admin"=>$data->admin,
            ":sysuser"=>$_SESSION['usr_ID']
          ];
          $sql = "update igl_usuarios set id_iglesia=:misionID,name=:nombres,lastname=:apellidos,login=:login,admin=:admin,sysuser=:sysuser,sysfecha=now() where id=:id;";
          $qry = $db->query_all($sql, $params);
          break;
        case "DEL":
          for($xx = 0; $xx<count($data->IDs); $xx++){
            $sql = "update igl_usuarios set estado=0 where id=:id";
            $params = [":id"=>$data->IDs[$xx]];
            $qry = $db->query_all($sql, $params);
          }
          break;
      }

      $rpta = array("error" => false,"exec" => 1);
      $db->enviarRespuesta($rpta);
      break;
    case "comboMisiones":
      //user admin
      $qry = $db->query_all("select * from igl_usuarios where id=".$_SESSION['usr_ID']);
      $rs = reset($qry);
      $user = array("id_iglesia"=>$rs["id_iglesia"],"verCombo" => (($rs["id_iglesia"]>0)?(true):(false)));

      //misiones
      $misiones = $fn->getComboBox("select * from igl_iglesias where estado=1 and id_padre=(select id_padre from igl_iglesias where id=".$rs["id_iglesia"].") order by nombre");
      
      //respuesta
      $rpta = array("user"=>$user, "tabla"=>$misiones);
      $db->enviarRespuesta($rpta);
      break;
    case "comboMisiones1":
      //user admin
      $qry = $db->query_all("select * from igl_usuarios where id=".$_SESSION['usr_ID']);
      $rs = reset($qry);
      $user = array("id_iglesia"=>$rs["id_iglesia"], "verCombo"=>(($rs["id_iglesia"]>0)?(true):(false)));

      //misiones
      $misiones = array();
      $misiones[] = array("ID"=>"1","nombre"=>"Asociacion General");

      $qry = $db->query_all("select * from igl_iglesias where estado=1 and id_padre=".$misiones[0]["ID"]." order by nombre");
      if ($qry) {
        foreach($qry as $rs){
          $misiones[] = array(
            "ID" => $rs["id"],
            "nombre" => ("____".$rs["nombre"])
          );
          $misiones = $fn->getJerarquiaIglesias($rs["id"],$misiones);
        }
      }

      $rpta = array("user"=>$user, "tabla"=>$misiones);
      $db->enviarRespuesta($rpta);
      break;
    case "selDatosPassw":
      $qry = $db->query_all("select * from igl_usuarios where id=".$data->userID);
      if($qry) { 
        $rs = reset($qry); 
        $user = array( "nombrecorto" => ($rs["lastname"].", ".$rs["name"]) );
      }
      $rpta = $user;
      $db->enviarRespuesta($rpta);
      break;
    case "updDatosPassw":
      $params = [
        ":passw"=>$data->pass,
        ":userID"=>$data->userID
      ];
      $sql = "update igl_usuarios set passw=:passw where id=:userID;";
      $qry = $db->query_all($sql, $params);
      if($qry) {
        $rpta = array("error"=>false, "mensaje" => "Se actualizo el passw" );
      } else{
        $rpta = array("error"=>true, "mensaje" => "Fallo actualizacion" );
      }
      //respuesta
      $db->enviarRespuesta($rpta);
      break;
    case "selPerfilUsuario":
      //datos usuario
      $qry = $db->query_all("select * from igl_usuarios where id=".$data->userID);
      $usuario = reset($qry)["login"];

      //datos perfil
      $perfil = array();
      $qry = $db->query_all("select p.*,t.nombre from igl_usuarios_perfil p,config_tablas t where p.id_tabla=t.id and p.id_usuario=".$data->userID." order by p.id_tabla;");
      if($qry){
        foreach($qry as $rs){
          $perfil[] = array(
            "id_tabla" => $rs["id_tabla"],
            "nombre" => ($rs["nombre"]),
            "sel" => ($rs["sel"]),
            "ins" => ($rs["ins"]),
            "upd" => ($rs["upd"]),
            "del" => ($rs["del"])
          );
        }
      }

      //respuesta
      $resp = array("usuario"=>$usuario, "perfil"=>$perfil);
      $db->enviarRespuesta($resp);
      break;
    case "updPerfilUsuario":
      foreach($data->perfil as $detalle){
        $params = [
          ":userID"=>$data->userID,
          ":tablaID"=>$detalle->id_tabla,
          ":sel"=>$detalle->sel,
          ":ins"=>$detalle->ins,
          ":upd"=>$detalle->upd,
          ":del"=>$detalle->del
        ];
        $sql = "update igl_usuarios_perfil set sel=:sel,ins=:ins,upd=:upd,del=:del where id_tabla=:tablaID and id_usuario=:userID";
        $qry = $db->query_all($sql,$params);
      }
      //respuesta
      $rpta = array("error"=>false);
      $db->enviarRespuesta($rpta);
      break;
  }
  $db->close();
?>
