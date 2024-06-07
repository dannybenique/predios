<!-- bootstrap datepicker -->
<link rel="stylesheet" href="libs/bootstrap-datepicker/dist/css/bootstrap-datepicker.min.css">
<script src="libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="libs/moment/min/moment.min.js"></script>

<section class="content-header">
  <h1><i class="fa fa-tasks"></i> Distritos Misioneros</h1>
  <ol class="breadcrumb">
    <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Distritos Misioneros</li>
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
                if($_SESSION["usr_perfil"][4]["del"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonDelete();"><i class="fa fa-trash-o"></i></button>'); }
                if($_SESSION["usr_perfil"][4]["del"]==1){ echo('<button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonNuevo();"><i class="fa fa-plus"></i></button>'); }
              ?>
            </div>
            <div class="btn-group">
              <button type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonReset();" title="Volver a cargar todos los Distritos Misioneros"><i class="fa fa-refresh"></i></button>
            </div>
            <div class="btn-group">
              <select id="cboMisiones" class="btn btn-default btn-sm" style="height:30px;text-align:left;" onchange="javascript:appGridAll();" title="Misiones"></select>
            </div>
            <div class="btn-group">
              <input type="text" id="txtBuscar" class="form-control input-sm pull-right" placeholder="buscar dst misionero..." onkeypress="javascript:appBotonBuscar(event);" autocomplete="off">
              <span class="fa fa-search form-control-feedback"></span>
            </div>
            <span id="grdDatosCount" style="display:inline-block;margin-left:5px;font-size:20px;font-weight:600;"></span>
          </div>
          <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="grdDatos">
                <thead>
                  <tr>
                    <th style="width:25px;"><input type="checkbox" id="chk_BorrarAll" onclick="toggleAll(this,'chk_Borrar');"/></th>
                    <th style="width:60px;text-align:right;">Iglesias</th>
                    <th style="width:60px;text-align:right;">Grupos</th>
                    <th style="width:60px;text-align:right;">Otros</th>
                    <th style="width:90px;text-align:center;">codigo</th>
                    <th>Dst. Misionero</th>
                    <th style="width:150px;">Region</th>
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
                <div id="div_codigo" class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Codigo</span>
                    <input id="txt_codigo" name="txt_codigo" type="text" maxlength="4" class="form-control" placeholder="..."/>
                  </div>
                </div>
                <div id="div_nombre" class="form-group" style="margin-bottom:25px;">
                  <div class="input-group">
                    <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Nombre</span>
                    <input id="txt_nombre" name="txt_nombre" type="text" maxlength="50" class="form-control" placeholder="nombre..."/>
                  </div>
                </div>
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Region</span>
                    <select id="cbo_region" class="form-control selectpicker" onchange="javascript:appComboUbiGeo('#cbo_provincia',this.value,0);"></select>
                  </div>
                </div>
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Provincia</span>
                    <select id="cbo_provincia" class="form-control selectpicker" onchange="javascript:appComboUbiGeo('#cbo_distrito',this.value,0);"></select>
                  </div>
                </div>
                <div class="form-group" style="margin-bottom:5px;">
                  <div class="input-group">
                    <span class="input-group-addon" style="background:#EEEEEE;font-weight:bold;">Distrito</span>
                    <select id="cbo_distrito" class="form-control selectpicker"></select>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="box-body box-profile">
            <button type="button" class="btn btn-default" onclick="javascript:appBotonCancel();"><i class="fa fa-angle-double-left"></i> Regresar</button>
            <?php
              if($_SESSION["usr_perfil"][4]["ins"]==1){ echo('<button id="btnInsert" type="button" class="btn btn-primary pull-right" onclick="javascript:appBotonInsert();"><i class="fa fa-save"></i> Guardar</button>'); }
              if($_SESSION["usr_perfil"][4]["upd"]==1){ echo('<button id="btnUpdate" type="button" class="btn btn-info pull-right" onclick="javascript:appBotonUpdate();"><i class="fa fa-save"></i> Actualizar</button>'); }
            ?>
          </div>
        </div>
      </form>
    </div>
  </div>
</section>

<script src="pages/catalogos/distritos/script.js"></script>
<script>
  $(document).ready(function(){
    appBotonReset();
  });
</script>
