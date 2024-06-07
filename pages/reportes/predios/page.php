<!-- exportar Excel -->
<script src="plugins/excel-export/xlsx.core.min.js"></script>
<script src="plugins/excel-export/FileSaver.js"></script>
<script src="plugins/excel-export/jhxlsx.js"></script>

<section class="content">
  <div class="row" id="edit">
    <form class="form-horizontal" id="frmReporte" autocomplete="off">
      <div class="col-md-3">
        <div class="box box-widget widget-user-2">
          <div class="widget-user-header" style="background:#f9f9f9;">
            <div class="widget-user-image">
              <img class="profile-user-img img-circle" src="data/predios/home.jpg"/>
            </div>
            <div style="min-height:70px;">
              <h5 class="widget-user-username fontFlexoRegular"> Reporte de Predios</h5>
              <h4 class="widget-user-desc fontFlexoRegular">por distrito misionero</h4>
            </div>
          </div>
          <ul class="list-group list-group-unbordered">
            <li class="list-group-item" style="padding:5px 10px 5px 10px;"><b>Predios</b><a class="pull-right" id="lbl_minipredios"></a></li>
            <li class="list-group-item" style="padding:5px 10px 5px 10px;"><b>Dist. Misio.</b><a class="pull-right" id="lbl_minidmisioneros"></a></li>
          </ul>
          <div class="mailbox-controls">
            <div class="btn-group">
              <button id="btnExportExcel" type="button" class="btn btn-default btn-sm" onclick="javascript:appBotonDownload();" disabled><i class="fa fa-download"></i></button>
            </div>
            <div class="btn-group pull-right">
              <button type="button" class="btn btn-primary btn-sm" onclick="javascript:appBotonConsultar();"><i class="fa fa-flash"></i> Consultar</button>
            </div>
          </div>
        </div>
      </div>
      <div class="col-md-9">
        <div class="box box-primary">
          <div class="box-body">
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="grdDatos">
                <thead>
                  <tr>
                    <th>Distrito Misionero</th>
                    <th style="width:80px;text-align:left;" title="Predios">PRE</th>
                    <th style="width:40px;text-align:left;" title="Iglesias">IGL</th>
                    <th style="width:40px;text-align:left;" title="Grupos">GRP</th>
                    <th style="width:80px;text-align:left;" title="Otros">OTR</th>
                    <th style="width:40px;text-align:left;" title="Terreno Propio">PRP</th>
                    <th style="width:40px;text-align:left;" title="Terreno Alquilado">ALQ</th>
                    <th style="width:80px;text-align:left;" title="Otros">OTR</th>
                    <th style="width:80px;text-align:left;" title="Registros Publicos">RR.PP.</th>
                    <th style="width:40px;text-align:left;" title="Escritura Publica">EPB</th>
                    <th style="width:40px;text-align:left;" title="Contrato">CTR</th>
                    <th style="width:40px;text-align:left;" title="Sin Documentacion">SDC</th>
                    <th style="width:40px;text-align:left;" title="Resolucion Inafeccion">RIN</th>
                    <th style="width:40px;text-align:left;" title="Impuesto Predial">IPR</th>
                  </tr>
                </thead>
                <tbody id="grdDatosBody">
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </form>
  </div>
</section>

<script src="pages/reportes/predios/script.js"></script>
