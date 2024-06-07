<?php
  include_once('../../../includes/sess_verifica.php');

  if(isset($_SESSION["usr_ID"])){
    if (isset($_REQUEST["appSQL"])){
      include_once('../../../includes/db_database.php');
      include_once('../../../includes/funciones.php');
      function get_DataGrafico($padreID){
        $db = $GLOBALS["db"];
        $tabla = array();
        $qry = $db->query("select d.id,d.codigo,d.nombre,count(p.id) as total from predios p,vw_ubigeo u,igl_distritos d where p.id_distrito=u.id_distrito and p.id_igldistrito=d.id and u.id_region=".$padreID." group by d.id,d.codigo,d.nombre");
        for($xx=0; $xx < $db->num_rows($qry); $xx++){
          $rs = $db->fetch_array($qry);
          $tabla[] = array(
            "codigo" => $rs["codigo"],
            "total" => $rs["total"]
          );
        }
        return $tabla;
      }

      if ($db->conn){
        $data = json_decode($_REQUEST['appSQL']);

        switch ($data->TipoQuery) {
          case "reporteMision":
            //conteo de predios
            $rsCount = $db->fetch_array($db->query("select count(*) as cuenta from predios where estado=1;"));
            $predios = $rsCount["cuenta"];
            $rsCount = $db->fetch_array($db->query("select count(*) as cuenta from igl_distritos where estado=1;"));
            $dmisioneros = $rsCount["cuenta"];

            //carga de predios
            $tablaResumen = array();
            $qry = $db->query("select d.id,d.codigo,d.nombre,count(p.id) as total from predios p,vw_ubigeo u,igl_distritos d where p.id_distrito=u.id_distrito and p.id_igldistrito=d.id group by d.id,d.codigo,d.nombre order by nombre");
            if ($db->num_rows($qry)>0) {
              for($xx=0; $xx<$db->num_rows($qry); $xx++){
                $rs = $db->fetch_array($qry);
                $rs_igl = $db->fetch_array($db->query("select count(*) as cuenta from predios where id_clase=101 and id_igldistrito=".$rs["id"]));
                $rs_grp = $db->fetch_array($db->query("select count(*) as cuenta from predios where id_clase=102 and id_igldistrito=".$rs["id"]));
                $claseOtros = $rs["total"]-($rs_igl["cuenta"]+$rs_grp["cuenta"]);

                $rs_prp = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_docum d,predios p where p.id=d.id_predio and d.conditerreno=170 and p.id_igldistrito=".$rs["id"]));
                $rs_alq = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_docum d,predios p where p.id=d.id_predio and d.conditerreno=171 and p.id_igldistrito=".$rs["id"]));
                $condiOtros = $rs["total"]-($rs_prp["cuenta"]+$rs_alq["cuenta"]);

                $rs_rrpp = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_registral d,predios p where p.id=d.id_predio and (trim(d.ficha)!='') and p.id_igldistrito=".$rs["id"]));
                $rs_epb = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_docum d,predios p where p.id=d.id_predio and d.id_titulo in (126,127,128,135,138,140,145,147) and p.id_igldistrito=".$rs["id"]));
                $rs_ctr = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_docum d,predios p where p.id=d.id_predio and d.id_titulo in (129,130,136,146) and p.id_igldistrito=".$rs["id"]));
                $rs_sdc = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_docum d,predios p where p.id=d.id_predio and d.id_titulo=137 and p.id_igldistrito=".$rs["id"]));
                $rs_muni = $db->fetch_array($db->query("select count(d.*) as cuenta from predios_docum d,predios p where p.id=d.id_predio and d.id_titulo=141 and p.id_igldistrito=".$rs["id"]));
                $rs_impred = $db->fetch_array($db->query("select count(f.*) as cuenta from predios_fiscal f,predios p where p.id=f.id_predio and (f.impufecha is not null) and p.id_igldistrito=".$rs["id"]));

                $tablaResumen[] = array(
                  "ID" => $rs["id"],
                  "codigo" => $rs["codigo"],
                  "dmisionero" => $rs["nombre"],
                  "total" => $rs["total"],
                  "claseIGL" => $rs_igl["cuenta"],
                  "claseGRP" => $rs_grp["cuenta"],
                  "claseOTR" => $claseOtros,
                  "condiPRP" => $rs_prp["cuenta"],
                  "condiALQ" => $rs_alq["cuenta"],
                  "condiOTR" => $condiOtros,
                  "regpub" => $rs_rrpp["cuenta"],
                  "escpub" => $rs_epb["cuenta"],
                  "contra" => $rs_ctr["cuenta"],
                  "sindocs" => $rs_sdc["cuenta"],
                  "resinafec" => $rs_muni["cuenta"],
                  "impred" => $rs_impred["cuenta"]
                );
              }
            }

            //grafico
            $grafico = array();
            $qry = $db->query("select distinct reg.id,reg.nombre from predios p,sis_ubigeo dis,sis_ubigeo pro,sis_ubigeo reg where p.id_distrito=dis.id and pro.id=dis.id_padre and reg.id=pro.id_padre");
            if ($db->num_rows($qry)>0) {
              for($xx=0; $xx<$db->num_rows($qry); $xx++){
                $rs = $db->fetch_array($qry);
                $grafico[] = array(
                  "ID" => $rs["id"],
                  "region" => $rs["nombre"],
                  "grafico" => get_DataGrafico($rs["id"])
                );
              }
            }

            //respuesta
            $rpta = array("predios"=>$predios,"dmisioneros"=>$dmisioneros,"grafico"=>$grafico,"tablaResumen"=>$tablaResumen);
            echo json_encode($rpta);
            break;
          case "comboDMisioneros":
            $misionID = ($_SESSION['usr_iglmision']==0)?(1):($_SESSION['usr_iglmision']);
            $rpta = getComboBox("select * from igl_distritos where id_iglmision=".($misionID)." and estado=1 order by nombre");
            $rpta[] = array("ID"=>0,"nombre"=>"Todos los Distritos Misioneros");

            echo json_encode($rpta);
            break;
          case "downloadMision":
            $tabla[] = array(
              array("text" => "Distrito Misionero"),
              array("text" => "predios"),
              array("text" => "iglesias"),
              array("text" => "grupos"),
              array("text" => "otros"),
              array("text" => "propia"),
              array("text" => "alquiler"),
              array("text" => "otros"),
              array("text" => "registros publicos"),
              array("text" => "escritura publica"),
              array("text" => "contrato"),
              array("text" => "sin documentacion"),
              array("text" => "resolucion municipal"),
              array("text" => "impuesto predial")
            );

            if (count($data->grid)>0) {
              for($xx=0; $xx<count($data->grid); $xx++){
                $tabla[] = array(
                  array("text" => $data->grid[$xx]->dmisionero),
                  array("text" => $data->grid[$xx]->total),
                  array("text" => $data->grid[$xx]->claseIGL),
                  array("text" => $data->grid[$xx]->claseGRP),
                  array("text" => $data->grid[$xx]->claseOTR),
                  array("text" => $data->grid[$xx]->condiPRP),
                  array("text" => $data->grid[$xx]->condiALQ),
                  array("text" => $data->grid[$xx]->condiOTR),
                  array("text" => $data->grid[$xx]->regpub),
                  array("text" => $data->grid[$xx]->escpub),
                  array("text" => $data->grid[$xx]->contra),
                  array("text" => $data->grid[$xx]->sindocs),
                  array("text" => $data->grid[$xx]->resinafec),
                  array("text" => $data->grid[$xx]->impred)
                );
              }
            }

            //respuesta
            $options = array("fileName"=>"res_mision");
            $tableData[] = array("sheetName"=>"resumen","data"=>$tabla);
            $rpta = array("options"=>$options,"tableData"=>$tableData);
            echo json_encode($rpta);
            break;
        }
        $db->close();
      } else {
        $resp = array("error" => true,"mensaje" => "coneccion cerrada");
        echo json_encode($resp);
      }
    } else{
      $resp = array("error" => true,"mensaje" => "ninguna variable en POST");
      echo json_encode($resp);
    }
  } else {
    $resp = array("error" => true,"mensaje" => "Caducó la sesion.");
    echo json_encode($resp);
  }
?>
