<script src="plugins/excel-export/xlsx.core.min.js"></script>
<script src="plugins/excel-export/FileSaver.js"></script>
<script src="plugins/excel-export/jhxlsx.js"></script>

<!-- bootstrap datepicker -->
<link rel="stylesheet" href="libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<script src="libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="libs/moment/min/moment.min.js"></script>

<!-- modal de Personas -->
<script src="pages/modals/predios/mod.script.js"></script>

<section class="content-header">
  <h1><i class="fa fa-tasks"></i> Predios</h1>
  <ol class="breadcrumb">
    <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Predios</li>
  </ol>
</section>
<section class="content">
  <div class="row" id="grid">
    <div class="col-md-12">
      <div class="box box-primary">
        <div class="box-header no-padding">
          <div class="mailbox-controls">
            <div class="btn-group">
              <?php
                if($_SESSION["usr_perfil"][5]["ins"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonDelete();" title="Eliminar Predios"><i class="fa fa-trash-o"></i></button>'); }
                if($_SESSION["usr_perfil"][5]["del"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonNuevo();" title="Agregar un nuevo predio"><i class="fa fa-plus"></i></button>'); }
              ?>
              <button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonDownload();" title="descargar los predios de acuerdo al distrito misionero actual"><i class="fa fa-download"></i></button>
            </div>
            <div class="btn-group">
              <button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonReset();" title="Volver a cargar toda la lista"><i class="fa fa-refresh"></i></button>
            </div>
            <div class="btn-group">
              <select id="cboDMisioneros" class="btn btn-default btn-sm" style="height:30px;text-align:left;" onchange="javascript:appGridAll();" title="Distritos Misioneros"></select>
            </div>
            <div class="btn-group">
              <input type="text" id="txtBuscar" class="form-control input-sm pull-right" placeholder="buscar predio..." onkeypress="javascript:appBotonBuscar(event);" autocomplete="off">
              <span class="fa fa-search form-control-feedback"></span>
            </div>
            <span id="grdDatosCount" style="display:inline-block;margin-left:5px;font-size:20px;font-weight:600;"></span>
          </div>
          <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="grdDatos">
                <thead>
                  <tr>
                    <th style="width:25px;"><input type="checkbox" id="chk_BorrarAll" onclick="toggleAll(this,'chk_Borrar');"/></th>
                    <th style="width:110px;">Clase</th>
                    <th style="width:130px;">Dist. Misio.</th>
                    <th style="width:130px;">Dist. Politico</th>
                    <th style="width:250px;">Predio</th>
                    <th style="width:90px;">Mision</th>
                    <th>Direccion</th>
                  </tr>
                </thead>
                <tbody id="grdDatosBody">
                </tbody>
              </table>
            </div>
        </div>
      </div>
    </div>
  </div>
  <div class="row" id="edit" style="display:none;">
    <form class="form-horizontal" id="frmWorker" autocomplete="off">
      <div class="col-md-3">
        <div class="box box-widget widget-user-2">
          <div class="widget-user-header" style="background:#f9f9f9;">
            <div class="widget-user-image">
              <img class="profile-user-img img-circle" src="data/predios/home.jpg"/>
            </div>
            <div style="min-height:70px;">
              <h5 class="widget-user-username fontFlexoRegular" id="lbl_minipredio"></h5>
              <h4 class="widget-user-desc fontFlexoRegular" id="lbl_miniclase"></h4>
            </div>
          </div>
          <div class="no-padding">
            <ul class="list-group list-group-unbordered">
              <li class="list-group-item" style="padding:5px 10px 5px 10px;"><b>ID</b><a class="pull-right" id="lbl_ID"></a></li>
              <li class="list-group-item" style="padding:5px 10px 5px 10px;"><b>Mision</b><a class="pull-right" id="lbl_minimision"></a></li>
              <li class="list-group-item" style="padding:5px 10px 5px 10px;"><b>Dist. Misio.</b><a class="pull-right" id="lbl_minidmisionero"></a></li>
            </ul>
          </div>
          <div class="box-body">
            <button type="button" class="btn btn-default" onclick="javascript:appBotonCancel();"><i class="fa fa-angle-double-left"></i> Regresar</button>
            <?php
              if($_SESSION["usr_perfil"][5]["ins"]==1){ echo('<button id="btnInsert" type="button" class="btn btn-primary pull-right" onclick="javascript:appBotonInsert();"><i class="fa fa-save"></i> Guardar</button>'); }
              if($_SESSION["usr_perfil"][5]["upd"]==1){ echo('<button id="btnUpdate" type="button" class="btn btn-info pull-right" onclick="javascript:appBotonUpdate();"><i class="fa fa-save"></i> Actualizar</button>'); }
            ?>
          </div>
        </div>
      </div>
      <div class="col-md-9">
        <div class="nav-tabs-custom">
          <ul class="nav nav-tabs">
            <li class="active"><a href="#datosBasico" data-toggle="tab"><i class="fa fa-home"></i> Basico</a></li>
            <li class=""><a href="#datosDocum" data-toggle="tab"><i class="fa fa-briefcase"></i> Documentaria</a></li>
            <li class=""><a href="#datosRegistral" data-toggle="tab"><i class="fa fa-tags"></i> Registral</a></li>
            <li class=""><a href="#datosUsos" data-toggle="tab"><i class="fa fa-trophy"></i> Usos</a></li>
            <li class=""><a href="#datosFiscal" data-toggle="tab"><i class="fa fa-legal"></i> Fiscal</a></li>
            <li class=""><a href="#datosEspec" data-toggle="tab"><i class="fa fa-info-circle"></i> Especificaciones</a></li>
            <li class=""><a href="#datosFiles" data-toggle="tab"><i class="fa fa-folder"></i> Archivos</a></li>
          </ul>
          <div class="tab-content">
            <div class="tab-pane active" id="datosBasico">
              <div class="box-body">
                <div class="col-md-5">
                  <div class="box-body">
                    <strong><i class="fa fa-user margin-r-5"></i> Basicos</strong>
                    <p class="text-muted">
                      <input type="hidden" id="hid_PredioID" value="">
                      Codigo: <a id="lbl_PredioCodigo"></a><br>
                      Nombre: <a id="lbl_PredioNombre"></a><br>
                      Mision: <a id="lbl_PredioMision"></a><br><br>
                      Clase: <a id="lbl_PredioClase"></a><br>
                      Distrito Misionero: <a id="lbl_PredioDisMisionero"></a><br>
                      Persona Juridica: <a id="lbl_PredioJuridica"></a><br>
                    </p>
                    <hr>

                    <strong><i class="fa fa-phone margin-r-5"></i> Contacto</strong>
                    <p class="text-muted">
                      Telefonos: <a id="lbl_PredioTelefonos"></a><br>
                      Correo: <a id="lbl_PredioEmail"></a><br>
                    </p>
                    <hr>
                  </div>
                </div>
                <div class="col-md-7">
                  <div class="box-body">
                    <strong><i class="fa fa-map-marker margin-r-5"></i> Ubicacion</strong>
                    <p class="text-muted">
                      <a id="lbl_PredioUbigeo"></a><br>
                      Sector: <a id="lbl_PredioSector"></a><a id="lbl_PredioAvenida"></a><br>
                        <a id="lbl_PredioNro"></a>
                        <a id="lbl_PredioDpto"></a>
                        <a id="lbl_PredioMza"></a>
                        <a id="lbl_PredioLote"></a>
                    </p>
                    <hr>

                    <strong><i class="fa fa-file-text-o margin-r-5"></i> Observaciones</strong>
                    <p class="text-muted">
                      <span id="lbl_PredioObservac"></span>
                    </p><br><br>
                    <strong><i class="fa fa-eye margin-r-5"></i> Auditoria</strong>
                    <div style="font-style:italic;font-size:11px;color:gray;">
                      Fecha: <span id="lbl_PredioSysFecha"></span><br>
                      Modif. por: <span id="lbl_PredioSysUser"></span>
                    </div><br>
                    <?php
                      if($_SESSION["usr_perfil"][5]["upd"]==1){ echo '<button id="btn_PredioUpdate" type="button" class="btn btn-primary btn-xs" onclick="javascript:appPredioBotonEditar();"><i class="fa fa-flash"></i> Modificar Datos</button>'; }
                    ?>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane" id="datosDocum">
              <div class="box-body">
                <div class="col-md-6">
                  <div class="box-body">
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Condicion del Terreno" style="background:#EEEEEE;font-weight:bold;">Condicion Terreno</span>
                        <select id="cboDocum_CondiTerreno" name="cboDocum_CondiTerreno" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Tipo de adquicision" style="background:#EEEEEE;font-weight:bold;">Adquirido mediante</span>
                        <select id="cboDocum_modoID" name="cboDocum_modoID" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" id="divDocum_Valor" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Valor de adquicision del Terreno" style="background:#EEEEEE;font-weight:bold;">Valor Adqui.</span>
                        <input id="txtDocum_Valor" name="txtDocum_Valor" type="text" class="form-control" value="0.00" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">moneda</span>
                        <select id="cboDocum_monedaID" name="cboDocum_monedaID" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Personas que transfieren el predio" style="background:#EEEEEE;font-weight:bold;">Transfirientes</span>
                        <input id="txtDocum_Transfirientes" name="txtDocum_Transfirientes" type="text" class="form-control" maxlength="200" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Personas que adquieren el terreno" style="background:#EEEEEE;font-weight:bold;">Adquirientes</span>
                        <input id="txtDocum_Adquirientes" name="txtDocum_Adquirientes" type="text" class="form-control" maxlength="200" placeholder="..."/>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="box-body">
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Documento de adquicision" style="background:#EEEEEE;font-weight:bold;">Doc. Adqui.</span>
                        <select id="cboDocum_tituloID" name="cboDocum_tituloID" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Numero del documento" style="background:#EEEEEE;font-weight:bold;">Nro</span>
                        <input id="txtDocum_Nro" name="txtDocum_Nro" type="text" class="form-control" maxlength="20" placeholder="..."/>
                        <span class="input-group-addon" title="Folio del documento" style="background:#EEEEEE;font-weight:bold;">Folio</span>
                        <input id="txtDocum_Folio" name="txtDocum_Folio" type="text" class="form-control" maxlength="200" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Fecha</span>
                        <span class="input-group-addon" id="spanDocum_Fecha"><input id="chkDocum_Fecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanDocum_Fecha','#txtDocum_Fecha');"/></span>
                        <input id="txtDocum_Fecha" name="txtDocum_Fecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Fedatario</span>
                        <select id="cboDocum_fedatarioID" name="cboDocum_fedatarioID" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Nombre del Fedatario" style="background:#EEEEEE;font-weight:bold;">Nombres</span>
                        <input id="txtDocum_Fedatario" name="txtDocum_Fedatario" type="text" class="form-control" maxlength="200" placeholder="nombre del fedatario..."/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane" id="datosRegistral">
              <div class="box-body">
                <div class="col-md-6">
                  <div class="box-body">
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Nro de Ficha / Partida Electronica" style="background:#EEEEEE;font-weight:bold;">Ficha</span>
                        <input id="txtRegistral_NoFicha" name="txtRegistral_NoFicha" type="text" class="form-control" maxlength="50" placeholder="..."/>
                        <span class="input-group-addon" title="Fecha de registro del numero de Ficha" style="background:#EEEEEE;font-weight:bold;"><i class="fa fa-calendar"></i></span>
                        <span class="input-group-addon" id="spanRegistral_FichaFecha"><input id="chkRegistral_FichaFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanRegistral_FichaFecha','#txtRegistral_FichaFecha');"/></span>
                        <input id="txtRegistral_FichaFecha" name="txtRegistral_FichaFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Municipio" style="background:#EEEEEE;font-weight:bold;">Munic.</span>
                        <input id="txtRegistral_Municipio" name="txtRegistral_Municipio" type="text" class="form-control" maxlength="50" placeholder="..."/>
                        <span class="input-group-addon" title="Fecha de registro en el municipio" style="background:#EEEEEE;font-weight:bold;"><i class="fa fa-calendar"></i></span>
                        <span class="input-group-addon" id="spanRegistral_MuniFecha"><input id="chkRegistral_MuniFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanRegistral_MuniFecha','#txtRegistral_MuniFecha');"/></span>
                        <input id="txtRegistral_MuniFecha" name="txtRegistral_MuniFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Libro" style="background:#EEEEEE;font-weight:bold;">Libro</span>
                        <input id="txtRegistral_Libro" name="txtRegistral_Libro" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Folio" style="background:#EEEEEE;font-weight:bold;">Folio</span>
                        <input id="txtRegistral_Folio" name="txtRegistral_Folio" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Folio" style="background:#EEEEEE;font-weight:bold;">Asiento</span>
                        <input id="txtRegistral_Asiento" name="txtRegistral_Asiento" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Folio" style="background:#EEEEEE;font-weight:bold;">Titular</span>
                        <input id="txtRegistral_Titular" name="txtRegistral_Titular" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Folio" style="background:#EEEEEE;font-weight:bold;">Zona Registral</span>
                        <input id="txtRegistral_Zonareg" name="txtRegistral_Zonareg" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane" id="datosUsos">
              <div class="box-body">
                <div class="col-md-6">
                  <div class="box-body">
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Uso principal" style="background:#EEEEEE;font-weight:bold;">Uso principal</span>
                        <select id="cboUsos_principalID" name="cboUsos_principalID" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Uso principal" style="background:#EEEEEE;font-weight:bold;">Uso secundario</span>
                        <select id="cboUsos_terceroID" name="cboUsos_terceroID" class="form-control selectpicker"></select>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Modo de Sesion" style="background:#EEEEEE;font-weight:bold;">Modo</span>
                        <input id="txtUsos_Sesion" name="txtUsos_Sesion" type="text" maxlength="50" class="form-control" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Fecha de registro del Modo de Sesion" style="background:#EEEEEE;font-weight:bold;">Fecha</span>
                        <span class="input-group-addon" id="spanUsos_SesionFecha"><input id="chkUsos_SesionFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanUsos_SesionFecha','#txtUsos_SesionFecha');"/></span>
                        <input id="txtUsos_SesionFecha" name="txtUsos_SesionFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Periodo" style="background:#EEEEEE;font-weight:bold;">Periodo</span>
                        <input id="txtUsos_Periodo" name="txtUsos_Periodo" type="text" maxlength="50" class="form-control" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="La institucion pertenece a..." style="background:#EEEEEE;font-weight:bold;">Pertenencia</span>
                        <input id="txtUsos_Pertenece" name="txtUsos_Pertenece" type="text" maxlength="100" class="form-control" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Otros usos para el predio" style="background:#EEEEEE;font-weight:bold;">Otros usos</span>
                        <input id="txtUsos_Otros" name="txtUsos_Otros" type="text" maxlength="100" class="form-control" placeholder="..."/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane" id="datosFiscal">
              <div class="box-body">
                <div class="col-md-6">
                  <div class="box-body">
                    <strong><i class="fa fa-legal"></i> Arbitrios Municipales</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Contribuyente" style="background:#EEEEEE;font-weight:bold;">Cod. Contrib.</span>
                        <input id="txtFiscal_ArbiCodigo" name="txtFiscal_ArbiCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Cod. Predio</span>
                        <input id="txtFiscal_PredioCodigo" name="txtFiscal_PredioCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Ultimo pago</span>
                        <span class="input-group-addon" id="spanFiscal_ArbiFecha"><input id="chkFiscal_ArbiFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanFiscal_ArbiFecha','#txtFiscal_ArbiFecha');"/></span>
                        <input id="txtFiscal_ArbiFecha" name="txtFiscal_ArbiFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>

                    <strong><i class="fa fa-lightbulb-o"></i> Luz / Energia</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Contribuyente" style="background:#EEEEEE;font-weight:bold;">Cod. Contrib.</span>
                        <input id="txtFiscal_LuzCodigo" name="txtFiscal_LuzCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Ultimo pago</span>
                        <span class="input-group-addon" id="spanFiscal_LuzFecha"><input id="chkFiscal_LuzFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanFiscal_LuzFecha','#txtFiscal_LuzFecha');"/></span>
                        <input id="txtFiscal_LuzFecha" name="txtFiscal_LuzFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>

                    <strong><i class="fa fa-tint"></i> Agua</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Contribuyente" style="background:#EEEEEE;font-weight:bold;">Cod. Contrib.</span>
                        <input id="txtFiscal_AguaCodigo" name="txtFiscal_AguaCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Ultimo pago</span>
                        <span class="input-group-addon" id="spanFiscal_AguaFecha"><input id="chkFiscal_AguaFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanFiscal_AguaFecha','#txtFiscal_AguaFecha');"/></span>
                        <input id="txtFiscal_AguaFecha" name="txtFiscal_AguaFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="box-body">
                    <strong><i class="fa fa-file-text-o"></i> Impuesto Predial(Autoavaluo)</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Contribuyente" style="background:#EEEEEE;font-weight:bold;">Cod. Contrib.</span>
                        <input id="txtFiscal_AvaluoCodigo" name="txtFiscal_AvaluoCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Resolucion Inafeccion" style="background:#EEEEEE;font-weight:bold;">Resol. Inaf.</span>
                        <input id="txtFiscal_ResolInaf" name="txtFiscal_ResolInaf" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Ultimo pago</span>
                        <span class="input-group-addon" id="spanFiscal_AvaluoFecha"><input id="chkFiscal_AvaluoFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanFiscal_AvaluoFecha','#txtFiscal_AvaluoFecha');"/></span>
                        <input id="txtFiscal_AvaluoFecha" name="txtFiscal_AvaluoFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>

                    <strong><i class="fa fa-home"></i> Licencia de Construccion</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Contribuyente" style="background:#EEEEEE;font-weight:bold;">Cod. Contrib.</span>
                        <input id="txtFiscal_ConstrCodigo" name="txtFiscal_ConstrCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Ultimo pago</span>
                        <span class="input-group-addon" id="spanFiscal_ConstrFecha"><input id="chkFiscal_ConstrFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanFiscal_ConstrFecha','#txtFiscal_ConstrFecha');"/></span>
                        <input id="txtFiscal_ConstrFecha" name="txtFiscal_ConstrFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>

                    <strong><i class="fa fa-file-text-o"></i> Declaratoria de Fabrica valorizado</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Contribuyente" style="background:#EEEEEE;font-weight:bold;">Cod. Contrib.</span>
                        <input id="txtFiscal_FabricaCodigo" name="txtFiscal_FabricaCodigo" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Codigo del Predio" style="background:#EEEEEE;font-weight:bold;">Ultimo pago</span>
                        <span class="input-group-addon" id="spanFiscal_FabricaFecha"><input id="chkFiscal_FabricaFecha" type="checkbox" onclick="javascript:appCheckOnOff(this,'#spanFiscal_FabricaFecha','#txtFiscal_FabricaFecha');"/></span>
                        <input id="txtFiscal_FabricaFecha" name="txtFiscal_FabricaFecha" type="text" class="form-control" style="width:115px;"/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane" id="datosEspec">
              <div class="box-body">
                <div class="col-md-6">
                  <div class="box-body">
                    <strong><i class="fa fa-home"></i> Especificaciones del Inmueble</strong>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Ubicado en zona" style="background:#EEEEEE;font-weight:bold;">Ubicado en zona</span>
                        <input id="txtEspec_Zona" name="txtEspec_Zona" type="text" class="form-control" maxlength="50" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Arancel" style="background:#EEEEEE;font-weight:bold;">Arancel</span>
                        <input id="txtEspec_Arancel" name="txtEspec_Arancel" type="text" maxlength="15" class="form-control" placeholder="..."/>
                      </div>
                    </div>
                    <div class="form-group" style="margin-bottom:5px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Area total del Terreno" style="background:#EEEEEE;font-weight:bold;">Area Terreno</span>
                        <input id="txtEspec_AreaTerreno" name="txtEspec_AreaTerreno" type="text" maxlength="15" class="form-control" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">M<sup>2</sup></span>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Area total de la Construccion" style="background:#EEEEEE;font-weight:bold;">Area Construida</span>
                        <input id="txtEspec_AreaConstruida" name="txtEspec_AreaConstruida" type="text" maxlength="15" class="form-control" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">M<sup>2</sup></span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="box-body">
                    <strong><i class="fa fa-home"></i> Medidas Perimetricas y Colindantes</strong>
                    <div class="form-group" style="margin-bottom:3px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Perimetro de Frente" style="background:#EEEEEE;font-weight:bold;">Frente</span>
                        <input id="txtEspec_Frente" name="txtEspec_Frente" type="text" maxlength="15" class="form-control" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">ML</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Colina con la calle..." style="background:#EEEEEE;font-weight:bold;">Calle</span>
                        <input id="txtEspec_FrenteCalle" name="txtEspec_FrenteCalle" type="text" maxlength="50" class="form-control" placeholder="..."/>
                      </div>
                    </div>

                    <div class="form-group" style="margin-bottom:3px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Perimetro de la Derecha" style="background:#EEEEEE;font-weight:bold;">Derecha</span>
                        <input id="txtEspec_Derecha" name="txtEspec_Derecha" type="text" maxlength="15" class="form-control" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">ML</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Colina con la calle..." style="background:#EEEEEE;font-weight:bold;">Calle</span>
                        <input id="txtEspec_DerechaCalle" name="txtEspec_DerechaCalle" type="text" maxlength="50" class="form-control" placeholder="..."/>
                      </div>
                    </div>

                    <div class="form-group" style="margin-bottom:3px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Perimetro de la Izquierda" style="background:#EEEEEE;font-weight:bold;">Izquierda</span>
                        <input id="txtEspec_Izquierda" name="txtEspec_Izquierda" type="text" maxlength="15" class="form-control" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">ML</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Colina con la calle..." style="background:#EEEEEE;font-weight:bold;">Calle</span>
                        <input id="txtEspec_IzquierdaCalle" name="txtEspec_IzquierdaCalle" type="text" maxlength="50" class="form-control" placeholder="..."/>
                      </div>
                    </div>

                    <div class="form-group" style="margin-bottom:3px;">
                      <div class="input-group">
                        <span class="input-group-addon" title="Perimetro de la Izquierda" style="background:#EEEEEE;font-weight:bold;">Fondo</span>
                        <input id="txtEspec_Fondo" name="txtEspec_Fondo" type="text" maxlength="15" class="form-control" placeholder="..."/>
                        <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">ML</span>
                      </div>
                    </div>
                    <div class="form-group">
                      <div class="input-group">
                        <span class="input-group-addon" title="Colina con la calle..." style="background:#EEEEEE;font-weight:bold;">Calle</span>
                        <input id="txtEspec_FondoCalle" name="txtEspec_FondoCalle" type="text" maxlength="50" class="form-control" placeholder="..."/>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane" id="datosFiles">
              <div class="box-body">
                <div class="box-header no-padding">
                  <div class="mailbox-controls">
                    <div class="btn-group">
                      <?php
                      if($_SESSION["usr_perfil"][5]["ins"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appPredioArchBotonAdd();" title="Agregar archivo para este predio"><i class="fa fa-plus"></i></button>'); }
                      ?>
                    </div>
                    <span id="grdArchivosCount" style="display:inline-block;margin-left:5px;font-size:20px;font-weight:600;"></span>
                  </div>
                  <div class="box-body table-responsive no-padding">
                      <table class="table table-hover" id="grdArchivos">
                        <thead>
                          <tr>
                            <th style="width:25px;">#</th>
                            <th style="width:25px;"><i class="fa fa-times"></i></th>
                            <th style="width:25px;"><i class="fa fa-eye"></i></th>
                            <th>Documento</th>
                          </tr>
                        </thead>
                        <tbody id="grdArchivosBody">
                        </tbody>
                      </table>
                    </div>
                </div>
              </div>
            </div>
          </div>
        </div>
    </div>
    </form>
  </div>
  <div class="modal fade" id="modalPredios" role="dialog">
  </div>
  <div class="modal fade" id="modalArchivos" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" style="background:#f9f9f9;padding:8px;">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title fontFlexoRegular">Archivos</h4>
        </div>
        <form class="form-horizontal" id="frmModalArchivos" autocomplete="off">
          <div class="modal-body no-padding">
            <div class="box-body">
              <div class="col-md-12">
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon no-border">Nombre de archivo</span>
                    <input type="text" class="form-control" id="txt_modArchNombre" placeholder="..." autocomplete="off">
                  </div>
                </div>
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon no-border">Archivo</span>
                    <input type="file" id="file_modArchPDF" name="file_modArchPDF" class="form-control" accept=".pdf" />
                    <input type="hidden" id="hid_modArchUrlPDF" value="">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer" style="background:#f9f9f9;padding:8px;">
            <input type="hidden" id="usrIDpassw" value="">
            <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><i class="fa fa-close"></i> Cerrar</button>
            <button type="button" class="btn btn-primary" onclick="javascript:modArchSubirPDF();"><i class="fa fa-flash"></i> Subir Archivo</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</section>

<script src="pages/catalogos/predios/script.js"></script>
<script>
  $(document).ready(function(){
    Predio.addModalToParentForm('modalPredios');
    appBotonReset();
  });
</script>
