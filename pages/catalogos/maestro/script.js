const rutaSQL = "pages/catalogos/maestro/sql.php";

//=========================funciones para workers============================
async function appGridAll(){
  const padreID = $("#cboMaestro").val();
  const txtBuscar = $("#txtBuscar").val();
  const datos = {
    TipoQuery : 'selMaestro',
    padreID : padreID,
    buscar : txtBuscar
  };
  $('#grdDatosBody').html('<tr><td colspan="5" style="text-align:center;"><br><div class="progress progress-sm active" style=""><div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" style="width:100%"></div></div></td></tr>');
  const resp = await appAsynFetch(datos,rutaSQL);
  
  if(resp.tabla.length>0){
    let rows = "";
    $.each(resp.tabla,function(key, valor){
      rows += '<tr>'+
              '<td>'+((valor.total>0)?(''):('<input type="checkbox" name="chk_Borrar" value="'+(valor.ID)+'"/>'))+'</td>'+
              '<td>'+(valor.ID)+'</td>'+
              '<td style="text-align:center;">'+(valor.codigo)+'</td>'+
              '<td style="text-align:center;">'+((valor.total>0)?(valor.total):("-"))+'</td>'+
              '<td><a href="javascript:appMaestroEdit('+(valor.ID)+')" title="'+(valor.ID)+'">'+(valor.nombre)+'</a></td>'+
              '</tr>';
    });
    $('#grdDatosBody').html(rows);
  }else{
    $('#grdDatosBody').html('<tr><td colspan="5" style="text-align:center;color:red;">Sin Resultados '+((txtBuscar=="")?(""):("para "+txtBuscar))+'</td></tr>');
  }
  $('#grdDatosCount').html(resp.tabla.length+"/"+resp.cuenta);
}

async function appBotonReset(){
  $("#txtBuscar").val("");
  const resp = await appAsynFetch({ TipoQuery:'comboMaestro' },rutaSQL);
  
  appLlenarDataEnComboBox(resp,"#cboMaestro",0);
  appGridAll();
}

function appBotonBuscar(e){
  if(e.keyCode === 13) { appGridAll(); }
}

async function appBotonNuevo(){
  const resp = await appAsynFetch({ TipoQuery:'comboMaestro' },rutaSQL);
  
  appLlenarDataEnComboBox(resp,"#cboMaestro1",$("#cboMaestro").val());
  $("#txt_ID, #txt_codigo, #txt_nombre, #txt_abrevia").val("");
  $('#grid, #btnUpdate').hide();
  $('#edit, #btnInsert').show();
}

async function appBotonDelete(){
  const arr = $('[name="chk_Borrar"]:checked').map(function(){ return this.value; }).get();
  if((arr.length)==0){
    alert("!!!Debe elegir por lo menos UN REGISTRO para borrar!!!");
  } else {
    if(confirm("¿Esta seguro de borrar estos "+arr.length+" registros?")){
      const datos = { TipoQuery : 'execMaestro', commandSQL : "DEL", IDs : arr };
      const resp = await appAsynFetch(datos,rutaSQL);
      if (!resp.error) { appGridAll(); }
    }
  }
}

function appBotonCancel(){
    $('#edit').hide();
    $('#grid').show();
}

async function appBotonInsert(){
  const datos = appGetDatosToDatabase();
  if(datos!=false){
    datos.commandSQL = "INS";
    const resp = await appAsynFetch(datos,rutaSQL);
    appGridAll();
    appBotonCancel();
  } else {
    alert("¡¡¡FALTAN LLENAR ALGUNOS DATOS!!!");
  }
}

async function appBotonUpdate(){
  const datos = appGetDatosToDatabase();
  if(datos!=false){
    datos.commandSQL = "UPD";
    const resp = await appAsynFetch(datos,rutaSQL);
    appGridAll();
    appBotonCancel();
  } else {
    alert("¡¡¡FALTAN LLENAR ALGUNOS DATOS!!!");
  }
}

async function appMaestroEdit(maestroID){
  const datos = {
    TipoQuery : 'editMaestro',
    ID : maestroID
  }
  const resp = await appAsynFetch(datos,rutaSQL);
  const combo = await appAsynFetch({ TipoQuery:'comboMaestro' },rutaSQL);
    
  appLlenarDataEnComboBox(combo,"#cboMaestro1",resp.padreID);
  $("#txt_ID").val(resp.ID);
  $("#txt_codigo").val(resp.codigo);
  $("#txt_nombre").val(resp.nombre);
  $("#txt_abrevia").val(resp.abrevia);

  $("#btnInsert, #grid").hide();
  $("#btnUpdate, #edit").show();
}

function appGetDatosToDatabase(){
  let EsError = false;
  let rpta = "";

  $('.box-body .form-group').removeClass('has-error');
  if($("#txt_codigo").val()=="") { $("#div_codigo").prop("class","form-group has-error"); EsError = true; }
  if($("#txt_nombre").val()=="") { $("#div_nombre").prop("class","form-group has-error"); EsError = true; }

  if(!EsError){
    rpta = {
      TipoQuery : "execMaestro",
      ID : $("#txt_ID").val(),
      codigo : $("#txt_codigo").val(),
      nombre : $("#txt_nombre").val(),
      abrevia : $("#txt_abrevia").val(),
      id_padre : $("#cboMaestro1").val()
    }
    return rpta;
  } else { 
    return false;
  }
}
