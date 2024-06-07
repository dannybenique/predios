<!-- bootstrap datepicker -->
<link rel="stylesheet" href="libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<script src="libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="libs/moment/min/moment.min.js"></script>

<section class="content-header">
  <h1><i class="fa fa-tasks"></i> Maestro</h1>
  <ol class="breadcrumb">
    <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Maestro</li>
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
                if($_SESSION["usr_perfil"][1]["del"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonDelete();"><i class="fa fa-trash-o"></i></button>'); }
                if($_SESSION["usr_perfil"][1]["ins"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonNuevo();"><i class="fa fa-plus"></i></button>'); }
              ?>
            </div>
            <div class="btn-group">
              <button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonReset();" title="Volver a cargar todo el archivo maestro"><i class="fa fa-refresh"></i></button>
            </div>
            <div class="btn-group">
              <select id="cboMaestro" class="btn btn-default btn-sm" style="height:30px;text-align:left;" onchange="javascript:appGridAll();"></select>
            </div>
            <div class="btn-group">
              <input type="text" id="txtBuscar" class="form-control input-sm pull-right" placeholder="buscar detalle..." onkeypress="javascript:appBotonBuscar(event);" autocomplete="off">
              <span class="fa fa-search form-control-feedback"></span>
            </div>
            <span id="grdDatosCount" style="display:inline-block;margin-left:5px;font-size:20px;font-weight:600;"></span>
          </div>
          <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="grdDatos">
                <thead>
                  <tr>
                    <th style="width:25px;"><input type="checkbox" id="chk_BorrarAll" onclick="toggleAll(this,'chk_Borrar');"/></th>
                    <th style="width:50px;">ID</th>
                    <th style="width:70px;text-align:center;">Codigo</th>
                    <th style="width:70px;text-align:center;">Total</th>
                    <th>Detalle</th>
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
                <div class="row">
                  <div class="col-xs-6">
                    <div id="div_ID" class="form-group">
                      <div class="input-group" style="width:150px;">
                        <span class="input-group-addon" style="width:50px;"><b>ID</b></span>
                        <input id="txt_ID" name="txt_ID" type="text" class="form-control" style="width:100px;" disabled="disabled"/>
                      </div>
                    </div>
                  </div>
                  <div class="col-xs-6">
                    <div class="form-group" style="width:100%;">
                      <div class="input-group" style="width:100%;">
                        <select id="cboMaestro1" class="btn btn-default" disabled="disabled" style="width:100%;text-align:left;"></select>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="div_codigo" class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Codigo</b></span>
                    <input id="txt_codigo" name="txt_codigo" type="text" maxlength="5" class="form-control" placeholder="..."/>
                  </div>
                </div>
                <div id="div_nombre" class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Nombre</b></span>
                    <input id="txt_nombre" name="txt_nombre" type="text" maxlength="70" class="form-control" placeholder="nombre..."/>
                  </div>
                </div>
                <div id="div_abrevia" class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon"><b>Abreviatura</b></span>
                    <input id="txt_abrevia" name="txt_abrevia" type="text" maxlength="5" class="form-control" placeholder="..."/>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="box-body box-profile">
            <button type="button" class="btn btn-default" onclick="javascript:appBotonCancel();"><i class="fa fa-angle-double-left"></i> Regresar</button>
            <?php
              if($_SESSION["usr_perfil"][1]["ins"]==1){ echo('<button id="btnInsert" type="button" class="btn btn-primary pull-right" onclick="javascript:appBotonInsert();"><i class="fa fa-save"></i> Guardar</button>'); }
              if($_SESSION["usr_perfil"][1]["upd"]==1){ echo('<button id="btnUpdate" type="button" class="btn btn-info pull-right" onclick="javascript:appBotonUpdate();"><i class="fa fa-save"></i> Actualizar</button>'); }
            ?>
          </div>
        </div>
      </form>
    </div>
  </div>
</section>

<script src="pages/catalogos/maestro/script.js"></script>
<script>
  $(document).ready(function(){
    appBotonReset();
  });
</script>
