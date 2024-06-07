<?php
  class funciones{
    //Obtiene la IP del cliente
    public function getClientIP() {
      $ipaddress = '';
      if (getenv('HTTP_CLIENT_IP')) $ipaddress = getenv('HTTP_CLIENT_IP');
      else if(getenv('HTTP_X_FORWARDED_FOR')) $ipaddress = getenv('HTTP_X_FORWARDED_FOR');
      else if(getenv('HTTP_X_FORWARDED')) $ipaddress = getenv('HTTP_X_FORWARDED');
      else if(getenv('HTTP_FORWARDED_FOR')) $ipaddress = getenv('HTTP_FORWARDED_FOR');
      else if(getenv('HTTP_FORWARDED')) $ipaddress = getenv('HTTP_FORWARDED');
      else if(getenv('REMOTE_ADDR')) $ipaddress = getenv('REMOTE_ADDR');
      else $ipaddress = 'UNKNOWN';
      return $ipaddress; 
    }
    public function getValorCampo($cadSQL,$campo){ //devuelve el valor de UN SOLO campo segun la consulta
      $db = $GLOBALS["db"];
      $qry = $db->query_all($cadSQL);
      $rs = reset($qry);
      return $rs[$campo];
    }
    public function getComboBox($cadSQL) { //devuelve una lista clave valor para llenarla en un combobox segun la consulta
      $db = $GLOBALS["db"];
      $tabla = array();
      $qry = $db->query_all($cadSQL);
      if ($qry) {
        foreach($qry as $rs){
          $tabla[] = array(
            "ID" => $rs["id"],
            "nombre" => $rs["nombre"]
          );
        }
      }
      return $tabla; 
    }
    public function getFechaActualDB(){
      $db = $GLOBALS["db"];
      //obtener fecha actual de operacion
      $qry = $db->query_all("select cast(now() as date) as fecha");
      $rs = reset($qry);
      return $rs["fecha"];
    }
    public function getJerarquiaIglesias($iglesiaID,$tabla){
      $db = $GLOBALS["db"];
      $qry = $db->query_all("select id,nombre,tipo from igl_iglesias where id_padre=".$iglesiaID." order by nombre;");
      if ($qry) {
        foreach($qry as $rs){
          $nombre = ($rs["tipo"]==3)?("________".$rs["nombre"]):(($rs["tipo"]==4)?("____________".$rs["nombre"]):("________________".$rs["nombre"]));
          $tabla[] = array(
            "ID" => $rs["id"],
            "nombre" => $nombre
          );
          $tabla = $this->getJerarquiaIglesias($rs["id"],$tabla);
        }
      }
      return $tabla;
    }
    public function getPredio($predioID){
      $db = $GLOBALS["db"];
      //extraes data
      $qry = $db->query_all("select * from vw_predios_nofiscal where id=".$predioID);
      if ($qry) {
        $rs = reset($qry);
        $avenida = ($rs["avenida"]!="")?(" Av./ Jr./ Calle: ".$rs["avenida"]):("");
        $nro = ($rs["nro"]!="")?(" Nro: ".$rs["nro"]):("");
        $dpto = ($rs["dpto"]!="")?(" Dpto: ".$rs["dpto"]):("");
        $mza = ($rs["mza"]!="")?(" Mza: ".$rs["mza"]):("");
        $lte = ($rs["lote"]!="")?(" Lte: ".$rs["lote"]):("");
        $tabla = array(
          "ID" => $rs["id"],
          "codigo" => $rs["codigo"],
          "nombre" => $rs["predio"],
          "mision" => $rs["mision"],
          "clase" => $rs["clase"],
          "dmisionero" => $rs["dmisionero"],
          "perjuridica" => $rs["per_juridica"],
          "telefono" => $rs["telefono"],
          "correo" => $rs["correo"],
          "region" => $rs["region"],
          "provincia" => $rs["provincia"],
          "distrito" => $rs["distrito"],
          "sector" => $rs["sector"],
          "avenida" => $avenida,
          "nro" => $nro,
          "dpto" => $dpto,
          "mza" => $mza,
          "lte" => $lte,
          "observac" => $rs["observac"],
          "sysfecha" => $rs["sysfecha"],
          "sysuser" => $rs["login"]
        );
        return $tabla;
      }
    }
    public function getArchivos($predioID){
      $db = $GLOBALS["db"];
      //extraer data
      $tabla = array();
      $qry = $db->query_all("select * from predios_archivos where estado=1 and id_predio=".$predioID);
      if ($qry) {
        foreach($qry as $rs){
          $tabla[] = array(
            "ID" => $rs["id"],
            "predioID" => $rs["id_predio"],
            "nombre" => $rs["nombre"],
            "url" => $rs["url"]
          );
        }
      }
      return $tabla;
    }
  }
  $fn = new funciones();
?>
