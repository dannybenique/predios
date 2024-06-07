<?php
  function iniciarSesion($usuarios) { // En este punto, el usuario ya esta validado. Grabamos los datos del usuario en una sesion.
    session_cache_limiter('nocache,private');
    session_name("predios");
    session_start();

    foreach ($usuarios as $usr) { // Asignamos variables de sesion con datos del Usuario para el uso en el resto de paginas autentificadas.
      $user = [
          "ID" => $usr['id'],
          "login" => $usr['login'],
          "iglmision" => $usr['id_iglesia'],
          "urlfoto" => 'data/personas/fotouser.jpg',
          "admin"=> $usr['admin']
      ];
      $_SESSION['usr_ID'] = $usr['id'];
      $_SESSION['usr_data'] = $user;
    }
  }
  function enviarRespuesta($resp) {
    header('Content-Type: application/json');
    echo json_encode($resp);
    exit;
  }

  if (isset($_POST["frmLogin"])){
    $rpta = "";
    try{
      include_once('db_database.php');
      include_once('web_config.php');
      $data = json_decode($_POST['frmLogin']);
      $params = [
        ':dblogin' => $data->login,
        ':dbpassw' => $data->passw
      ]; 
      $sql = "select * from igl_usuarios where login=:dblogin and passw=:dbpassw";
      $qry = $db->query_all($sql,$params);
      if($qry){
        iniciarSesion($qry);
        $rpta = array("error" => false);
      } else {
        $rpta = array("error" => true, "data" => "credenciales sin acceso");
      }
      enviarRespuesta($rpta);
    } catch(PDOException $e){
      enviarRespuesta(["error" => true, "data" => $e->getMessage()]);
    } finally{
      $db->close();
    }
  } else{
    enviarRespuesta(["error" => true, "data" => "Ninguna variable en POST"]);
  }
?>
