<?php
  include_once('../../../includes/sess_verifica.php');
  include_once('../../../includes/db_database.php');
  include_once('../../../includes/funciones.php');

  if (!isset($_SESSION["usr_ID"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Caducó la sesión.")); }
  if (!isset($_REQUEST["appSQL"])) { $db->enviarRespuesta(array("error" => true, "mensaje" => "Ninguna variable en POST")); }

  $data = json_decode($_REQUEST['appSQL']);
  $rpta = 0;

  switch ($data->TipoQuery) {
    case "selPredios":
      $tabla = array();
      $whr = (($data->distritoID)=="0")?(""):(" and id_iglesia=".$data->distritoID);
      $whr .= (($data->buscar=="")?(""):(" and (predio ilike'%".$data->buscar."%')"));
      //conteo de predios
      $qry = $db->query_all("select count(*) as cuenta from vw_predios where estado=1 ".$whr.";");
      $rsCount = reset($qry);

      //carga de predios
      $qry = $db->query_all("select * from vw_predios where estado=1 ".$whr." order by predio;");
      if ($qry) {
        foreach($qry as $rs){
          $direccion = ($rs["sector"]." ".$rs["avenida"].(($rs["nro"]!="")?(" Nro: ".$rs["nro"]):("")).(($rs["mza"]!="")?(" Mza: ".$rs["mza"]):("")).(($rs["lote"]!="")?(" Lte: ".$rs["lote"]):("")));

          $tabla[] = array(
            "ID" => $rs["id"],
            "clase" => $rs["clase"],
            "dmisionero" => $rs["dmisionero"],
            "distrito" => $rs["distrito"],
            "predio" => $rs["predio"],
            "mision" => $rs["mision"],
            "arbifecha" => $rs["arbifecha"],
            "direccion" => $direccion
          );
        }
      }

      //fecha actual - año actual
      $qry = $db->query_all("select extract(year from current_date) as curr;");
      $currdate = reset($qry)["curr"];

      //respuesta
      $rpta = array("cuenta"=>$rsCount["cuenta"],"tabla"=>$tabla,"currdate"=>$currdate);
      $db->enviarRespuesta($rpta);
      break;
    case "editPredioFull":
      //documentaria
      $qry = $db->query_all("select * from predios_docum where id_predio=".($data->ID));
      if($qry) {
        $rs = reset($qry);
        $docum = array(
          "conditerreno" => $rs["conditerreno"],
          "valor" => $rs["valordocum"]*1,
          "id_modo" => $rs["id_modo"],
          "id_moneda" => $rs["id_moneda"],
          "transfirientes" => $rs["transdocum"],
          "adquirientes" => $rs["adquidocum"],
          "id_titulo" => $rs["id_titulo"],
          "nro_titulo" => $rs["nro_titulo"],
          "id_fedatario" => $rs["id_fedatario"],
          "nombrefedatario" => $rs["nombrefedatario"],
          "fecha" => ($rs["fechadocum"]==null)?(null):(date("d/m/Y",strtotime($rs["fechadocum"]))),
          "folio" => $rs["foliodocum"]
        );
      } else { $docum = null; }

      //registral
      $qry = $db->query_all("select * from predios_registral where id_predio=".($data->ID));
      if($qry) {
        $rs = reset($qry);
        $registral = array(
          "fecha1" => ($rs["fecha1"]==null)?(null):(date("d/m/Y",strtotime($rs["fecha1"]))),
          "fecha2" => ($rs["fecha2"]==null)?(null):(date("d/m/Y",strtotime($rs["fecha2"]))),
          "ficha" => $rs["ficha"],
          "libro" => $rs["libro"],
          "folio" => $rs["folio"],
          "asiento" => $rs["asiento"],
          "titular" => $rs["titular"],
          "municipio" => $rs["municipio"],
          "zonareg" => $rs["zonareg"]
        );
      } else { $registral = null; }

      //usos
      $qry = $db->query_all("select * from predios_usos where id_predio=".($data->ID));
      if($qry) {
        $rs = reset($qry);
        $preusos = array(
          "principalID" => $rs["id_principal"],
          "terceroID" => $rs["id_tercero"],
          "fecha" => ($rs["fecha"]==null)?(null):(date("d/m/Y",strtotime($rs["fecha"]))),
          "modo" => $rs["modo"],
          "periodo" => $rs["periodo"],
          "pertenece" => $rs["pertenece"],
          "otros" => $rs["otros"]
        );
      } else { $preusos = null; }

      //fiscal
      $qry = $db->query_all("select * from predios_fiscal where id_predio=".($data->ID));
      if($qry) {
        $rs = reset($qry);
        $fiscal = array(
          "arbifecha" => ($rs["arbifecha"]==null)?(null):(date("d/m/Y",strtotime($rs["arbifecha"]))),
          "arbicodigo" => $rs["arbicodigo"],
          "arbiresol" => $rs["arbiresol"],
          "impufecha" => ($rs["impufecha"]==null)?(null):(date("d/m/Y",strtotime($rs["impufecha"]))),
          "impucodigo" => $rs["impucodigo"],
          "impuresol" => $rs["impuresol"],
          "luzfecha" => ($rs["luzfecha"]==null)?(null):(date("d/m/Y",strtotime($rs["luzfecha"]))),
          "luzcodigo" => $rs["luzcodigo"],
          "aguafecha" => ($rs["aguafecha"]==null)?(null):(date("d/m/Y",strtotime($rs["aguafecha"]))),
          "aguacodigo" => $rs["aguacodigo"],
          "construfecha" => ($rs["construfecha"]==null)?(null):(date("d/m/Y",strtotime($rs["construfecha"]))),
          "construtexto" => $rs["construtexto"],
          "declarafecha" => ($rs["declarafecha"]==null)?(null):(date("d/m/Y",strtotime($rs["declarafecha"]))),
          "declaratexto" => $rs["declaratexto"]
        );
      } else { $fiscal = null; }

      //especificaciones
      $qry = $db->query_all("select * from predios_medidas where id_predio=".($data->ID));
      if($qry) {
        $rs = reset($qry);
        $espec = array(
          "ubizona" => $rs["ubizona"],
          "arancel" => $rs["arancel"],
          "area_total" => $rs["area_total"],
          "area_const" => $rs["area_const"],
          "frent_medi" => $rs["frent_medi"],
          "frent_colin" => $rs["frent_colin"],
          "right_medi" => $rs["right_medi"],
          "right_colin" => $rs["right_colin"],
          "left_medi" => $rs["left_medi"],
          "left_colin" => $rs["left_colin"],
          "back_medi" => $rs["back_medi"],
          "back_colin" => $rs["back_colin"]
        );
      } else { $espec = null; }

      //archivos
      $arch = array();
      $qry = $db->query_all("select * from predios_archivos where estado=1 and id_predio=".($data->ID));
      if($qry) {
        foreach($qry as $rs){
          $arch[] = array(
            "ID" => $rs["id"],
            "predioID" => $rs["id_predio"],
            "nombre" => $rs["nombre"],
            "url" => $rs["url"]
          );
        }
      } else { $arch = null; }

      //respuesta
      $rpta = array(
        "predio"=>$fn->getPredio($data->ID),
        "docum"=>$docum,
        "registral"=>$registral,
        "preusos"=>$preusos,
        "fiscal"=>$fiscal,
        "espec"=>$espec,
        "arch"=>$arch,
        "fedatarios"=>$fn->getComboBox("select id,nombre from maestro where id_padre=2 and estado=1 order by nombre;"),
        "modos"=>$fn->getComboBox("select id,nombre from maestro where id_padre=3 and estado=1 order by nombre;"),
        "monedas"=>$fn->getComboBox("select id,nombre from maestro where id_padre=4 and estado=1 order by nombre;"),
        "titulos"=>$fn->getComboBox("select id,nombre from maestro where id_padre=5 and estado=1 order by nombre;"),
        "usos"=>$fn->getComboBox("select id,nombre from maestro where id_padre=6 and estado=1 order by nombre;"),
        "conditerreno"=>$fn->getComboBox("select id,nombre from maestro where id_padre=7 and estado=1 order by nombre;")
      );
      $db->enviarRespuesta($rpta);
      break;
    case "execPredioFull":
      switch($data->commandSQL){
        case "INS":
          //documentaria
          $doc = $data->docum;
          $params = [
            ":predioID"=>$data->predioID,
            ":condiTerreno"=>$doc->condiTerreno,
            ":valor"=>$doc->valor,
            ":modoID"=>$doc->modoID,
            ":monedaID"=>$doc->monedaID,
            ":trans"=>$doc->trans,
            ":adqui"=>$doc->adqui,
            ":tituloID"=>$doc->tituloID,
            ":tituloNro"=>$doc->tituloNRO,
            ":fedatarioID"=>$doc->fedatarioID,
            ":fedatarioNombres"=>$doc->fedatarioNombres,
            ":fecha"=>$doc->fecha,
            ":folio"=>$doc->folio
          ];
          $sql = "insert into predios_docum values(:predioID,:condiTerreno,:valor,:modoID,:monedaID,:trans,:adqui,:tituloID,:tituloNro,:fedatarioID,:fedatarioNombres,:fecha,:folio);";
          $qry = $db->query_all($sql,$params);
          
          //registral
          $reg = $data->registral;
          $params = [
            ":predioID"=>$data->predioID,
            ":fecha1"=>$reg->fecha1,
            ":fecha2"=>$reg->fecha2,
            ":ficha"=>$reg->ficha,
            ":libro"=>$reg->libro,
            ":folio"=>$reg->folio,
            ":asiento"=>$reg->asiento,
            ":titular"=>$reg->titular,
            ":municipio"=>$reg->municipio,
            ":zonareg"=>$reg->zonareg
          ];
          $sql = "insert into predios_registral values(:predioID,:fecha1,:fecha2,:ficha,:libro,:folio,:asiento,:titular,:municipio,:zonareg);";
          $qry = $db->query_all($sql, $params);
          
          //usos
          $uso = $data->usos;
          $params = [
            ":predioID"=>$data->predioID,
            ":principalID"=>$uso->principalID,
            ":terceroID"=>$uso->terceroID,
            ":fecha"=>$uso->fecha,
            ":modo"=>$uso->modo,
            ":periodo"=>$uso->periodo,
            ":pertenece"=>$uso->pertenece,
            ":otros"=>$uso->otros
          ];
          $sql = "insert into predios_usos values(:predioID,:principalID,:terceroID,:fecha,:modo,:periodo,:pertenece,:otros);";
          $qry = $db->query_all($sql, $params);
          
          //fiscal
          $fis = $data->fiscal;
          $params = [
            ":predioID"=>$data->predioID,
            ":arbifecha"=>$fis->arbifecha,
            ":arbicodigo"=>$fis->arbicodigo,
            ":arbiresol"=>$fis->arbiresol,
            ":impufecha"=>$fis->impufecha,
            ":impucodigo"=>$fis->impucodigo,
            ":impuresol"=>$fis->impuresol,
            ":luzfecha"=>$fis->luzfecha,
            ":luzcodigo"=>$fis->luzcodigo,
            ":aguafecha"=>$fis->aguafecha,
            ":aguacodigo"=>$fis->aguacodigo,
            ":construfecha"=>$fis->construfecha,
            ":construtexto"=>$fis->construtexto,
            ":declarafecha"=>$fis->declarafecha,
            ":declaratexto"=>$fis->declaratexto
          ];
          $sql = "insert into predios_fiscal values(:predioID,:arbifecha,:arbicodigo,:arbiresol,:impufecha,:impucodigo,:impuresol,:luzfecha,:luzcodigo,:aguafecha,:aguacodigo,:construfecha,:construtexto,:declarafecha,:declaratexto);";
          $qry = $db->query_all($sql, $params);
          
          //espec
          $esp = $data->espec;
          $params = [
            ":predioID"=>$data->predioID,
            ":ubizona"=>$esp->ubizona,
            ":arancel"=>$esp->arancel,
            ":area_total"=>$esp->area_total,
            ":area_const"=>$esp->area_const,
            ":frent_medi"=>$esp->frent_medi,
            ":frent_colin"=>$esp->frent_colin,
            ":right_medi"=>$esp->right_medi,
            ":right_colin"=>$esp->right_colin,
            ":left_medi"=>$esp->left_medi,
            ":left_colin"=>$esp->left_colin,
            ":back_medi"=>$esp->back_medi,
            ":back_colin"=>$esp->back_colin
          ];
          $sql = "insert into predios_medidas values(:predioID,:ubizona,:arancel,:area_total,:area_const,:frent_medi,:frent_colin,:right_medi,:right_colin,:left_medi,:left_colin,:back_medi,:back_colin);";
          $qry = $db->query_all($sql, $params);
          break;
        case "UPD":
          //documentaria
          $qry = $db->query_all("select count(*) as cuenta from predios_docum where id_predio=".$data->predioID);
          $cuenta = reset($qry)["cuenta"];
          $doc = $data->docum;
          $params = [
            ":predioID"=>$data->predioID,
            ":conditerreno"=>$doc->condiTerreno,
            ":valor"=>$doc->valor,
            ":modoID"=>$doc->modoID,
            ":monedaID"=>$doc->monedaID,
            ":trans"=>$doc->trans,
            ":adqui"=>$doc->adqui,
            ":tituloID"=>$doc->tituloID,
            ":tituloNro"=>$doc->tituloNRO,
            ":fedatarioID"=>$doc->fedatarioID,
            ":fedatarioNombres"=>$doc->fedatarioNombres,
            ":fecha"=>$doc->fecha,
            ":folio"=>$doc->folio
          ];
          if($cuenta>0) { $sql = "update predios_docum set conditerreno=:conditerreno,valordocum=:valor,id_modo=:modoID,id_moneda=:monedaID,transdocum=:trans,adquidocum=:adqui,id_titulo=:tituloID,nro_titulo=:tituloNro,id_fedatario=:fedatarioID,nombrefedatario=:fedatarioNombres,fechadocum=:fecha,foliodocum=:folio where id_predio=:predioID;"; }
          else { $sql = "insert into predios_docum values(:predioID,:conditerreno,:valor,:modoID,:monedaID,:trans,:adqui,:tituloID,:tituloNro,:fedatarioID,:fedatarioNombres,:fecha,:folio);"; }
          $qry = $db->query_all($sql, $params);

          //registral
          $qry = $db->query_all("select count(*) as cuenta from predios_registral where id_predio=".$data->predioID);
          $cuenta = reset($qry)["cuenta"];
          $reg = $data->registral;
          $params = [
            ":predioID"=>$data->predioID,
            ":fecha1"=>$reg->fecha1,
            ":fecha2"=>$reg->fecha2,
            ":ficha"=>$reg->ficha,
            ":libro"=>$reg->libro,
            ":folio"=>$reg->folio,
            ":asiento"=>$reg->asiento,
            ":titular"=>$reg->titular,
            ":municipio"=>$reg->municipio,
            ":zonareg"=>$reg->zonareg
          ];
          if($cuenta>0) { $sql = "update predios_registral set fecha1=:fecha1,fecha2=:fecha2,ficha=:ficha,libro=:libro,folio=:folio,asiento=:asiento,titular=:titular,municipio=:municipio,zonareg=:zonareg where id_predio=:predioID;"; }
          else { $sql = "insert into predios_registral values(:predioID,:fecha1,:fecha2,:ficha,:libro,:folio,:asiento,:titular,:municipio,:zonareg);"; }
          $qry = $db->query_all($sql, $params);

          //usos
          $qry = $db->query_all("select count(*) as cuenta from predios_usos where id_predio=".$data->predioID);
          $cuenta = reset($qry)["cuenta"];
          $uso = $data->usos;
          $params = [
            ":predioID"=>$data->predioID,
            ":principalID"=>$uso->principalID,
            ":terceroID"=>$uso->terceroID,
            ":fecha"=>$uso->fecha,
            ":modo"=>$uso->modo,
            ":periodo"=>$uso->periodo,
            ":pertenece"=>$uso->pertenece,
            ":otros"=>$uso->otros
          ];
          if($cuenta>0) { $sql = "update predios_usos set id_principal=:principalID,id_tercero=:terceroID,fecha=:fecha,modo=:modo,periodo=:periodo,pertenece=:pertenece,otros=:otros where id_predio=:predioID;"; }
          else { $sql = "insert into predios_usos values(:predioID,:principalID,:terceroID,:fecha,:modo,:periodo,:pertenece,:otros);"; }
          $qry = $db->query_all($sql, $params);

          //fiscal
          $qry = $db->query_all("select count(*) as cuenta from predios_fiscal where id_predio=".$data->predioID);
          $cuenta = reset($qry)["cuenta"];
          $fis = $data->fiscal;
          $params = [
            ":predioID"=>$data->predioID,
            ":arbifecha"=>$fis->arbifecha,
            ":arbicodigo"=>$fis->arbicodigo,
            ":arbiresol"=>$fis->arbiresol,
            ":impufecha"=>$fis->impufecha,
            ":impucodigo"=>$fis->impucodigo,
            ":impuresol"=>$fis->impuresol,
            ":luzfecha"=>$fis->luzfecha,
            ":luzcodigo"=>$fis->luzcodigo,
            ":aguafecha"=>$fis->aguafecha,
            ":aguacodigo"=>$fis->aguacodigo,
            ":construfecha"=>$fis->construfecha,
            ":construtexto"=>$fis->construtexto,
            ":declarafecha"=>$fis->declarafecha,
            ":declaratexto"=>$fis->declaratexto
          ];
          if($cuenta>0) { $sql = "update predios_fiscal set arbifecha=:arbifecha,arbicodigo=:arbicodigo,arbiresol=:arbiresol,impufecha=:impufecha,impucodigo=:impucodigo,impuresol=:impuresol,luzfecha=:luzfecha,luzcodigo=:luzcodigo,aguafecha=:aguafecha,aguacodigo=:aguacodigo,construfecha=:construfecha,construtexto=:construtexto,declarafecha=:declarafecha,declaratexto=:declaratexto where id_predio=:predioID;"; }
          else { $sql = "insert into predios_fiscal values(:predioID,:arbifecha,:arbicodigo,:arbiresol,:impufecha,:impucodigo,:impuresol,:luzfecha,:luzcodigo,:aguafecha,:aguacodigo,:construfecha,:construtexto,:declarafecha,:declaratexto);"; }
          $qry = $db->query_all($sql, $params);

          //espec
          $qry = $db->query_all("select count(*) as cuenta from predios_medidas where id_predio=".$data->predioID);
          $cuenta = reset($qry)["cuenta"];
          $esp = $data->espec;
          $params = [
            ":predioID"=>$data->predioID,
            ":ubizona"=>$esp->ubizona,
            ":arancel"=>$esp->arancel,
            ":area_total"=>$esp->area_total,
            ":area_const"=>$esp->area_const,
            ":frent_medi"=>$esp->frent_medi,
            ":frent_colin"=>$esp->frent_colin,
            ":right_medi"=>$esp->right_medi,
            ":right_colin"=>$esp->right_colin,
            ":left_medi"=>$esp->left_medi,
            ":left_colin"=>$esp->left_colin,
            ":back_medi"=>$esp->back_medi,
            ":back_colin"=>$esp->back_colin
          ];
          if($cuenta>0) { $sql = "update predios_medidas set ubizona=:ubizona,arancel=:arancel,area_total=:area_total,area_const=:area_const,frent_medi=:frent_medi,frent_colin=:frent_colin,right_medi=:right_medi,right_colin=:right_colin,left_medi=:left_medi,left_colin=:left_colin,back_medi=:back_medi,back_colin=:back_colin where id_predio=:predioID;"; }
          else { $sql = "insert into predios_medidas values(:predioID,:ubizona,:arancel,:area_total,:area_const,:frent_medi,:frent_colin,:right_medi,:right_colin,:left_medi,:left_colin,:back_medi,:back_colin);"; }
          $qry = $db->query_all($sql, $params);
          break;
        case "DEL":
          for($xx=0; $xx<count($data->IDs); $xx++){
            $params = [":id"=>$data->IDs[$xx]];
            $sql = "update predios set estado=0 where id=:id;";
            $qry = $db->query_all($sql, $params);
          }
          break;
      }

      $rpta = array("error" => false,"exec" => 1);
      $db->enviarRespuesta($rpta);
      break;
    case "comboDMisioneros":
      $misionID = ($_SESSION['usr_data']['iglmision']==0)?(1):($_SESSION['usr_data']['iglmision']);
      $qry = $db->query_all("select id,tipo,id_padre from igl_iglesias where id=".$misionID.";");
      $rs = reset($qry);

      $dismis = $fn->getComboBox("select * from igl_iglesias where id_padre=".(($rs["tipo"]==5)?($rs["id_padre"]):($misionID))." and estado=1 order by nombre");
      $dismis[] = array("ID"=>0,"nombre"=>"Todos los Distritos Misioneros");

      //respuesta
      $rpta = array("tipo"=>$rs["tipo"], "misionID"=>$misionID, "tabla"=>$dismis);
      $db->enviarRespuesta($rpta);
      break;
    case "downloadPredios":
      $whr = "";
      $dmisionero = array("codigo"=>"ALL");
      $tabla[] = array(
        array("text" => "Pers. Juridica"),
        array("text" => "Mision"),
        array("text" => "Nombre Predio"),
        array("text" => "Clase"),
        array("text" => "Dist. Misio."),
        array("text" => "Dist. Polit."),
        array("text" => "Direccion"),
        array("text" => "Telefonos"),
        array("text" => "Correo"),
        array("text" => "Cond. Terreno"),
        array("text" => "Modo"),
        array("text" => "Valor"),
        array("text" => "Moneda"),
        array("text" => "Nombre Transf."),
        array("text" => "Nombre Adquir."),
        array("text" => "Titulo"),
        array("text" => "Nro Titulo"),
        array("text" => "Fedatario"),
        array("text" => "Nombre Fedatario"),
        array("text" => "Fecha Docum."),
        array("text" => "Folio Docum."),
        array("text" => "Ficha Reg"),
        array("text" => "Fecha Reg"),
        array("text" => "Libro Reg"),
        array("text" => "Folio Reg"),
        array("text" => "Asiento Reg"),
        array("text" => "Titular de Registro"),
        array("text" => "Municipio de Registro"),
        array("text" => "Fecha Municipal"),
        array("text" => "Zona Registral"),
        array("text" => "Fecha Arbitrios"),
        array("text" => "Codigo Arbitrios"),
        array("text" => "Codigo del Predio"),
        array("text" => "Fecha Impuesto"),
        array("text" => "Codigo Impuesto"),
        array("text" => "Resol. Impuesto"),
        array("text" => "Arancel"),
        array("text" => "Area Total Terreno"),
        array("text" => "Area Construida"),
        array("text" => "Frente Colinda"),
        array("text" => "Frente Medidas"),
        array("text" => "Derecha Colinda"),
        array("text" => "Derecha Medidas"),
        array("text" => "Izquierda Colinda"),
        array("text" => "Izquierda Medidas"),
        array("text" => "Atras Colinda"),
        array("text" => "Atras Medidas")
      );

      if(($data->dmisioneroID) > 0) {
        $whr = "and p.id_iglesia=".($data->dmisioneroID);
        //distrito misionero
        $qry = $db->query_all("select codigo from igl_iglesias where id=".$data->dmisioneroID);
        $rs = reset($qry);
        $dmisionero["codigo"] = ($rs["codigo"]);
      }
      $sql = "select p.id,p.per_juridica,	p.mision,p.nombre,c.nombre AS clase,d.nombre AS dmisionero,ur.nombre AS region,up.nombre AS provincia,ud.nombre AS distrito,p.sector,p.avenida,p.nro,p.dpto,p.mza,p.lote,p.telefono,p.correo,t.nombre AS terreno,m.nombre AS modo,pd.valordocum,mn.nombre as moneda,pd.transdocum,pd.adquidocum,ti.nombre as titulo,pd.nro_titulo,fe.nombre as fedatario,pd.nombrefedatario,to_char(pd.fechadocum, 'DD/MM/YYYY'::text) AS fechadocum,pd.foliodocum,pr.ficha,to_char(pr.fecha1, 'DD/MM/YYYY'::text) AS fechareg,pr.libro,pr.folio as folioreg,pr.asiento as asiento,pr.titular,pr.municipio,to_char(pr.fecha2, 'DD/MM/YYYY'::text) AS fechamuni,pr.zonareg,to_char(pf.arbifecha, 'DD/MM/YYYY'::text) AS arbifecha,pf.arbicodigo,pf.arbiresol,to_char(pf.impufecha, 'DD/MM/YYYY'::text) AS impufecha,pf.impucodigo,pf.impuresol,pm.arancel,pm.area_total,pm.area_const,pm.frent_colin,pm.frent_medi,pm.right_colin,pm.right_medi,pm.left_colin,pm.left_medi,pm.back_colin,pm.back_medi from predios p,predios_docum pd,predios_registral pr,predios_fiscal pf,predios_medidas pm,maestro c,maestro t,maestro m,maestro mn,maestro ti,maestro fe,igl_iglesias d,sis_ubigeo ud,sis_ubigeo up,sis_ubigeo ur where p.id_clase=c.id and p.id_iglesia=d.id and p.id_distrito=ud.id and ud.id_padre=up.id AND up.id_padre=ur.id AND pd.conditerreno=t.id and p.id=pd.id_predio and p.id=pr.id_predio and p.id=pm.id_predio and p.id=pf.id_predio and pd.id_modo=m.id and pd.id_moneda=mn.id and pd.id_titulo=ti.id and pd.id_fedatario=fe.id and p.estado=1 ".$whr." order by dmisionero,p.nombre";
      $qry = $db->query_all($sql);
      if ($qry) {
        foreach($qry as $rs){
          $avenida = ($rs["avenida"]!="")?(" - Av./ Jr./ Calle: ".$rs["avenida"]):("");
          $nro = ($rs["nro"]!="")?(" Nro: ".$rs["nro"]):("");
          $dpto = ($rs["dpto"]!="")?(" Dpto: ".$rs["dpto"]):("");
          $mza = ($rs["mza"]!="")?(" Mza: ".$rs["mza"]):("");
          $lte = ($rs["lote"]!="")?(" Lte: ".$rs["lote"]):("");
          $direccion  = ($rs["sector"]).$avenida.$nro.$dpto.$mza.$lte;

          $tabla[] = array(
            array("text" => $rs["per_juridica"]),
            array("text" => $rs["mision"]),
            array("text" => $rs["nombre"]),
            array("text" => $rs["clase"]),
            array("text" => $rs["dmisionero"]),
            array("text" => $rs["region"]." - ".$rs["provincia"]." - ".$rs["distrito"]),
            array("text" => $direccion),
            array("text" => $rs["telefono"]),
            array("text" => $rs["correo"]),
            array("text" => $rs["terreno"]),
            array("text" => $rs["modo"]),
            array("text" => $rs["valordocum"]*1),
            array("text" => $rs["moneda"]),
            array("text" => $rs["transdocum"]),
            array("text" => $rs["adquidocum"]),
            array("text" => $rs["titulo"]),
            array("text" => $rs["nro_titulo"]),
            array("text" => $rs["fedatario"]),
            array("text" => $rs["nombrefedatario"]),
            array("text" => $rs["fechadocum"]),
            array("text" => $rs["foliodocum"]),
            array("text" => $rs["ficha"]),
            array("text" => $rs["fechareg"]),
            array("text" => $rs["libro"]),
            array("text" => $rs["folioreg"]),
            array("text" => $rs["asiento"]),
            array("text" => $rs["titular"]),
            array("text" => $rs["municipio"]),
            array("text" => $rs["fechamuni"]),
            array("text" => $rs["zonareg"]),
            array("text" => $rs["arbifecha"]),
            array("text" => $rs["arbicodigo"]),
            array("text" => $rs["arbiresol"]),
            array("text" => $rs["impufecha"]),
            array("text" => $rs["impucodigo"]),
            array("text" => $rs["impuresol"]),
            array("text" => $rs["arancel"]),
            array("text" => $rs["area_total"]),
            array("text" => $rs["area_const"]),
            array("text" => $rs["frent_colin"]),
            array("text" => $rs["frent_medi"]),
            array("text" => $rs["right_colin"]),
            array("text" => $rs["right_medi"]),
            array("text" => $rs["left_colin"]),
            array("text" => $rs["left_medi"]),
            array("text" => $rs["back_colin"]),
            array("text" => $rs["back_medi"])
          );
        }
      }

      //respuesta
      $options = array("fileName"=>"predios_".$dmisionero["codigo"]);
      $tableData[] = array("sheetName"=>"predios","data"=>$tabla);
      $rpta = array("options"=>$options,"tableData"=>$tableData);
      $db->enviarRespuesta($rpta);
      break;
    case "subirArchivos":
      //manejo del archivo
      if(isset($_FILES["filePDF"])){
        $archivo = $_FILES["filePDF"];
        if(is_uploaded_file($archivo['tmp_name'])){
          if(mime_content_type($archivo["tmp_name"])=="application/pdf"){
            // try{
              //acceso a la base de datos para registro del nombre
              $qry = $db->query_all("select coalesce(max(id)+1,1) as maxi from predios_archivos");
              $ID = reset($qry)["maxi"];
              $url = "data/archivos/" . htmlspecialchars($data->predioID) . "_" . $ID . ".pdf";
              $params = [
                ":id"=>$ID,
                ":predioID"=>htmlspecialchars($data->predioID),
                ":nombre"=>htmlspecialchars($data->nombre),
                ":url"=>$url,
                ":tipo"=>1,
                ":estado"=>1,
                ":sysuser"=>$_SESSION["usr_ID"]
              ];
              $sql = "insert into predios_archivos values(:id,:predioID,:nombre,:url,:tipo,:estado,:sysuser,now())";
              $qry = $db->query_all($sql, $params);

              //guardar archivo en S.O.
              $ruta = "../../../".$url;
              if(!move_uploaded_file($archivo["tmp_name"], $ruta)) {
                throw new RuntimeException("Error al mover el archivo a su ubicación final.");
              }

              //recoger data de archivos
              $rpta = $fn->getArchivos($data->predioID);
            // } catch(Exception $e){
            //   error_log("Error en la subida del archivo PDF: " . $e->getMessage());
            //   $rpta = ["error" => "Se produjo un error durante la subida del archivo."];
            // }
          } else { $rpta = ["error" => "El archivo no es un PDF válido."]; }
        } else { $rpta = ["error" => "Error al subir el archivo."]; }
      } else {  $rpta = ["error" => "No se ha proporcionado ningún archivo."]; }

      $db->enviarRespuesta($rpta);
      break;
    case "borrarArchivos":
      $qry = $db->query_all("delete from predios_archivos where id=".$data->ID);
      unlink("../../../data/archivos/".$data->predioID."_".$data->ID.".pdf");
      
      //respuesta
      $rpta = $fn->getArchivos($data->predioID);
      $db->enviarRespuesta($rpta);
      break;
  }
  $db->close();
?>
