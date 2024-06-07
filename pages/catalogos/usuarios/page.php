<style>
  .optNivel02{ padding-left:10px; }
  .optNivel03{ padding-left:20px; }
  .optNivel04{ padding-left:30px; }
  .optNivel05{ padding-left:40px; }
</style>
<!-- SHA1 -->
<script type="text/javascript" src="libs/webtoolkit/webtoolkit.sha1.js"></script>

<!-- bootstrap datepicker -->
<link rel="stylesheet" href="libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<script src="libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="libs/moment/min/moment.min.js"></script>

<section class="content-header">
  <h1><i class="fa fa-tasks"></i> Usuarios</h1>
  <ol class="breadcrumb">
    <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Usuarios</li>
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
                if($_SESSION["usr_perfil"][3]["del"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonDelete();"><i class="fa fa-trash-o"></i></button>'); }
                if($_SESSION["usr_perfil"][3]["ins"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonNuevo();"><i class="fa fa-plus"></i></button>'); }
              ?>
            </div>
            <div class="btn-group">
              <button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonReset();" title="Volver a cargar toda la lista de potenciales ahorristas"><i class="fa fa-refresh"></i></button>
            </div>
            <div id="div_cboMisiones" class="btn-group">
              <select id="cboMisiones" class="btn btn-default btn-sm" style="height:30px;text-align:left;" onchange="javascript:appGridAll();"></select>
            </div>
            <div class="btn-group">
              <input type="text" id="txtBuscar" class="form-control input-sm pull-right" placeholder="buscar usuario..." onkeypress="javascript:appBotonBuscar(event);" autocomplete="off">
              <span class="fa fa-search form-control-feedback"></span>
            </div>
            <span id="grdDatosCount" style="display:inline-block;margin-left:5px;font-size:20px;font-weight:600;"></span>
          </div>
          <div class="box-body table-responsive no-padding">
            <table class="table table-hover" id="grdDatos">
              <thead>
                <tr>
                  <th style="width:25px;"><input type="checkbox" id="chk_BorrarAll" onclick="toggleAll(this,'chk_Borrar');"/></th>
                  <th style="width:25px;"><i class="fa fa-lock"></i></th>
                  <th style="width:25px;"><i class="fa fa-cogs"></i></th>
                  <th style="width:250px;">login</th>
                  <th style="width:300px;">Usuario</th>
                  <th style="width:300px;">Distrito Misionero</th>
                  <th>Region Ubigeo</th>
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
    <div class="col-md-6">
      <form class="form-horizontal" autocomplete="off">
        <div class="box box-primary">
          <div class="box-body">
            <div class="col-md-12">
              <div class="box-body">
                <div id="div_ID" class="form-group">
                  <div class="input-group" style="width:150px;">
                    <span class="input-group-addon" style="width:50px;"><b>ID</b></span>
                    <input id="txt_ID" name="txt_ID" type="text" class="form-control" style="width:100px;" disabled="disabled"/>
                  </div>
                </div>
                <div id="div_nombres" class="form-group" style="margin-bottom:5px">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Nombres</b></span>
                    <input id="txt_nombres" name="txt_nombres" type="text" maxlength="50" class="form-control" placeholder="nombres..."/>
                  </div>
                </div>
                <div id="div_apellidos" class="form-group">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Apellidos</b></span>
                    <input id="txt_apellidos" name="txt_apellidos" type="text" maxlength="50" class="form-control" placeholder="apellidos..."/>
                  </div>
                </div>
                <div id="div_login" class="form-group">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Login</b></span>
                    <input id="txt_login" name="txt_login" type="text" maxlength="50" class="form-control" placeholder="login..."/>
                  </div>
                </div>
                <div class="form-group">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Mision</b></span>
                    <select id="cboMisiones1" class="btn btn-default btn-sm" style="height:30px;text-align:left;">
                      <option>nivel 1</option>
                      <option>____nivel 2</option>
                      <option>________nivel 3</option>
                      <option>____________nivel 4</option>
                      <option>________nivel 3</option>
                      <option>____________nivel 4</option>
                      <option>____________nivel 4</option>
                      <option>________________nivel 5</option>
                    </select>
                  </div>
                </div>
                <div class="form-group">
                  <div class="checkbox">
                    <label><input type="checkbox" id="chk_admin"> SuperUsuario </label>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="box-body box-profile">
            <button type="button" class="btn btn-default" onclick="javascript:appBotonCancel();"><i class="fa fa-angle-double-left"></i> Regresar</button>
            <?php
              if($_SESSION["usr_perfil"][3]["ins"]==1){ echo('<button id="btnInsert" type="button" class="btn btn-primary pull-right" onclick="javascript:appBotonInsert();"><i class="fa fa-save"></i> Guardar</button>'); }
              if($_SESSION["usr_perfil"][3]["upd"]==1){ echo('<button id="btnUpdate" type="button" class="btn btn-info pull-right" onclick="javascript:appBotonUpdate();"><i class="fa fa-save"></i> Actualizar</button>'); }
            ?>
          </div>
        </div>
      </form>
    </div>
  </div>
  <div class="modal fade" id="modalChangePassw" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header" style="background:#f9f9f9;padding:8px;">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title fontFlexoRegular">Cambiar Password</h4>
        </div>
        <form class="form-horizontal" id="frmChangePassw" autocomplete="off">
          <div class="modal-body no-padding">
            <div class="box-body">
              <h4 class="timeline-header no-border fontFlexoRegular">
                <span class="appSpanPerfil" >Usuario</span>
                <span id="usrNombreCorto" style="color:#3c8dbc;font-weight:600;"></span>
              </h4>
            </div>
            <div class="box-body">
              <div class="col-md-12">
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon no-border">Nuevo Password</span>
                    <input type="password" class="form-control" id="txt_passwordNew" placeholder="password..." autocomplete="off">
                  </div>
                </div>
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon no-border">Repetir Password</span>
                    <input type="password" class="form-control" id="txt_passwordRenew" placeholder="repetir password..." autocomplete="off">
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="modal-footer" style="background:#f9f9f9;padding:8px;">
            <input type="hidden" id="usrIDpassw" value="">
            <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><i class="fa fa-close"></i> Cerrar</button>
            <button type="button" class="btn btn-primary" onclick="javascript:modPassw_BotonUpdatePassw();"><i class="fa fa-flash"></i> Cambiar Password</button>
          </div>
        </form>
      </div>
    </div>
  </div>
  <div class="modal fade" id="modalPerfiles" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <form class="form-horizontal" id="frmPerfilUsuario" autocomplete="off">
          <div class="modal-header" style="background:#f9f9f9;padding:8px;">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title fontFlexoRegular">Perfil de Usuario</h4>
          </div>
          <div class="modal-body" style="border-right:1px solid white;">
            <div class="box-body">
              <h4 class="timeline-header no-border fontFlexoRegular">
                <span style="color:#3c8dbc;font-weight:bold;">Usuario: </span>
                <span id="lbl_userPerfilNombreCorto" style="color:#3c8dbc;font-weight:bold;"></span>
              </h4>
            </div>
            <div class="box-body">
              <div class="table-responsive no-padding">
                <table class="table table-hover" id="grdUserPerfil">
                  <thead>
                    <tr>
                      <th>Tabla</th>
                      <th style="width:55px;text-align:center;">SEL</th>
                      <th style="width:55px;text-align:center;">INS</th>
                      <th style="width:55px;text-align:center;">UPD</th>
                      <th style="width:55px;text-align:center;">DEL</th>
                    </tr>
                  </thead>
                  <tbody id="grdUserPerfilBody">
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div class="modal-footer" style="background:#f9f9f9;padding:8px;">
            <input type="hidden" id="hid_userPerfilID" value=""/>
            <button type="button" class="btn btn-default pull-left" data-dismiss="modal"><i class="fa fa-close"></i> Cerrar</button>
            <button type="button" class="btn btn-primary" onclick="javascript:modPerfil_BotonGuardar();"><i class="fa fa-flash"></i> Guardar Perfil</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</section>

<script src="pages/catalogos/usuarios/script.js"></script>
<script>
  $(document).ready(function(){
    appBotonReset();
  });
</script>
