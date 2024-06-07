const rutaSQL = "pages/catalogos/misiones/sql.php";

//=========================funciones para workers============================
async function appGridAll(){
  $('#grdDatosBody').html('<tr><td colspan="7" style="text-align:center;"><br><div class="progress progress-sm active" style=""><div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" style="width:100%"></div></div><br>Un momento, por favor...</td></tr>');
  const txtBuscar = $("#txtBuscar").val();
  const datos = {
    TipoQuery : 'selMisiones',
    unionID : $("#cboUniones").val(),
    buscar : txtBuscar
  };
  
  const resp = await appAsynFetch(datos,rutaSQL);
  if(resp.tabla.length>0){
    const disabledDelete = "";//(resp.usernivel==resp.admin) ? ("") : ("disabled");
    let fila = "";

    $.each(resp.tabla,function(key, valor){
      fila += '<tr>'+
              '<td><input type="checkbox" name="chk_Borrar" value="'+(valor.ID)+'" '+(disabledDelete)+'/></td>'+
              '<td style="text-align:center;">'+(valor.codigo)+'</td>'+
              '<td style="text-align:left;">'+(valor.abrevia)+'</td>'+
              '<td><a href="javascript:appMisionEdit('+(valor.ID)+')" title="'+(valor.ID)+'">'+(valor.nombre)+'</a></td>'+
              '<td style="text-align:center;">'+((valor.activo=='1')?('<i class="fa fa-check"></i>'):(''))+'</td>'+
              '<td>'+(valor.direccion)+'</td>'+
              '</tr>';
    });
    $('#grdDatosBody').html(fila);
  }else{
    $('#grdDatosBody').html('<tr><td colspan="6" style="text-align:center;color:red;">Sin Resultados '+((txtBuscar=="")?(""):("para "+txtBuscar))+'</td></tr>');
  }
  $('#grdDatosCount').html(resp.tabla.length+"/"+resp.cuenta);
}

async function appBotonReset(){
  $("#txtBuscar").val("");
  const resp = await appAsynFetch({ TipoQuery:'comboUniones' },rutaSQL);
  appLlenarDataEnComboBox(resp,"#cboUniones",1);
  appGridAll();
}

function appBotonBuscar(e){
  if(e.keyCode === 13) { appGridAll(); }
}

function appBotonNuevo(){
  $("#txt_ID, #txt_codigo, #txt_nombre, #txt_abrevia, #txt_direccion, #txt_observac").val("");
  appComboUbiGeo("#cbo_region",0,14);
  appComboUbiGeo("#cbo_provincia",14,1401);
  appComboUbiGeo("#cbo_distrito",1401,140101);

  $('#edit, #btnInsert').show();
  $('#grid, #btnUpdate').hide();
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
    if(!resp.error){
      appGridAll();
      appBotonCancel();
    } else {
      console.error("hubo un error al momento de ingresar los datos");
    }
  } else {
    alert("¡¡¡FALTAN LLENAR ALGUNOS DATOS!!!");
  }
}

async function appBotonUpdate(){
  let datos = appGetDatosToDatabase();
  if(datos!=false){
    datos.commandSQL = "UPD";
    const resp = await appAsynFetch(datos,rutaSQL);    ;
    if(!resp.error){
      appGridAll();
      appBotonCancel();
    } else {
      console.error("hubo un error al momento de actualizar los datos");
    }
  } else {
    alert("¡¡¡FALTAN LLENAR ALGUNOS DATOS!!!");
  }
}

async function appBotonDelete(){
  const arr = $('[name="chk_Borrar"]:checked').map(function(){ return this.value; }).get();
  if((arr.length)==0){
    alert("!!!Debe elegir por lo menos UN REGISTRO para borrar!!!");
  } else {
    if(confirm("¿Esta seguro de borrar estos "+arr.length+" registros?")){
      const datos = { TipoQuery : 'execMision', commandSQL : "DEL", IDs : arr };
      const resp = await appAsynFetch(datos,rutaSQL);
      if (!resp.error) { 
        appGridAll(); 
      } else {
        console.error("hubo un problema");
      }
    }
  }
}

async function appMisionEdit(distritoID){
  const resp = await appAsynFetch({
      TipoQuery : 'editMision',
      ID : distritoID
    },rutaSQL);

  $("#txt_ID").val(resp.ID);
  $("#txt_codigo").val(resp.codigo);
  $("#txt_nombre").val(resp.nombre);
  $("#txt_abrevia").val(resp.abrevia);
  $("#txt_direccion").val(resp.direccion);
  $("#txt_observac").val(resp.observac);
  appComboUbiGeo("#cbo_region",0,resp.id_region);
  appComboUbiGeo("#cbo_provincia",resp.id_region,resp.id_provincia);
  appComboUbiGeo("#cbo_distrito",resp.id_provincia,resp.id_distrito);

  $("#grid, #btnInsert").hide();
  $("#edit, #btnUpdate").show();
}

async function appComboUbiGeo(miCombo,padreID,miValor){
  const resp = await appAsynFetch({ TipoQuery : 'ubigeo', padreID: padreID },rutaSQL);
  appLlenarDataEnComboBox(resp,miCombo,miValor);
}

function appGetDatosToDatabase(){
  let EsError = false;
  let rpta = "";

  $('.box-body .form-group').removeClass('has-error');
  if($("#txt_codigo").val()=="") { $("#div_codigo").prop("class","form-group has-error"); EsError = true; }
  if($("#txt_nombre").val()=="") { $("#div_nombre").prop("class","form-group has-error"); EsError = true; }
  if($("#txt_direccion").val()=="") { $("#div_direccion").prop("class","form-group has-error"); EsError = true; }

  if(!EsError){
    rpta = {
      TipoQuery : "execMision",
      ID : $("#txt_ID").val(),
      codigo : $("#txt_codigo").val(),
      nombre : $("#txt_nombre").val(),
      abrevia : $("#txt_abrevia").val(),
      id_ubigeo : $("#cbo_distrito").val(),
      direccion : $("#txt_direccion").val(),
      observac : $("#txt_observac").val()
    }
    return rpta;
  } else { return false; }
}
