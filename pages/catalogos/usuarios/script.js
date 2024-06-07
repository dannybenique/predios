const rutaSQL = "pages/catalogos/usuarios/sql.php";
var gridPerfil = new Array();

//=========================funciones para workers============================
async function appGridAll(){
  $('#grdDatosBody').html('<tr><td colspan="7" style="text-align:center;"><br><div class="progress progress-sm active" style=""><div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" style="width:100%"></div></div><br>Un momento, por favor...</td></tr>');
  const txtBuscar = $("#txtBuscar").val();
  const resp = await appAsynFetch({
      TipoQuery : 'selUsuarios',
      misionID : parseInt($("#cboMisiones").val()),
      buscar : txtBuscar
    },rutaSQL);
  
  if(resp.tabla.length>0){
    let fila = "";
    $.each(resp.tabla,function(key, valor){
      fila += '<tr>';
      fila += '<td><input type="checkbox" name="chk_Borrar" value="'+(valor.ID)+'"/></td>';
      fila += '<td><a href="javascript:appLinkPassw('+(valor.ID)+');"><i class="fa fa-lock"></i></a></td>';
      fila += '<td><a href="javascript:appLinkPerfil('+(valor.ID)+');"><i class="fa fa-cogs"></i></a></td>';
      fila += '<td style="">'+(valor.login)+'</td>';
      fila += '<td><a href="javascript:appUsuarioEdit('+(valor.ID)+')" title="'+(valor.ID)+'">'+(valor.usuario)+'</a></td>';
      fila += '<td style="">'+(valor.abrevia)+'</td>';
      fila += '<td style="">'+(valor.region)+'</td>';
      fila += '</tr>';
    });
    $('#grdDatosBody').html(fila);
  }else{
    $('#grdDatosBody').html('<tr><td colspan="7" style="text-align:center;color:red;">Sin Resultados '+((txtBuscar=="")?(""):("para "+txtBuscar))+'</td></tr>');
  }
  $('#grdDatosCount').html(resp.tabla.length+"/"+resp.cuenta);
}

async function appLinkPassw(userID){
  const resp = await appAsynFetch({ TipoQuery:'selDatosPassw', userID },rutaSQL);

  $('#usrIDpassw').val(userID);
  $('#txt_passwordNew, #txt_passwordRenew').val('');
  $('#usrNombreCorto').html(resp.nombrecorto);
  $('#modalChangePassw').modal();
}

async function appLinkPerfil(userID){
  const datos = {
    TipoQuery : 'selPerfilUsuario',
    userID : userID
  }
  const resp = await appAsynFetch(datos,rutaSQL);
  
  gridPerfil = resp.perfil;
  modPerfil_LlenarTablaPermisos();
  $('#lbl_userPerfilNombreCorto').html(resp.usuario);
  $('#hid_userPerfilID').val(userID);
  $('#modalPerfiles').modal();
}

async function modPassw_BotonUpdatePassw(){
  const userID = $('#usrIDpassw').val();
  const miPass = $('#txt_passwordNew').val();
  const miRepass = $('#txt_passwordRenew').val();

  if (miPass==miRepass){
    const datos = {
      TipoQuery : 'updDatosPassw',
      pass : SHA1(miPass).toString().toUpperCase(),
      passtxt : miPass,
      userID : userID
    }
    const resp = await appAsynFetch(datos,rutaSQL);
    if (!resp.error) {
      $('#txt_passwordNew').val('');
      $('#txt_passwordRenew').val('');
      $('#modalChangePassw').modal('hide');
    }
  } else {
    alert("La clave no coincide");
  }
}

function modPerfil_LlenarTablaPermisos(){
  let fila = "";
  if(gridPerfil.length>0){
    $.each(gridPerfil,function(key, valor){
      fila += '<tr>'+
              '<td>'+(valor.nombre)+'</td>'+
              '<td style="text-align:center;"><a href="javascript:modPerfil_LinkCambiarPerm('+(valor.id_tabla)+',1,'+(valor.sel)+');" '+((valor.sel==0)?('style="color:#cdcdcd;"'):(""))+'><i class="fa fa-toggle-'+((valor.sel==0)?("off"):("on"))+'"></i></a></td>'+
              '<td style="text-align:center;"><a href="javascript:modPerfil_LinkCambiarPerm('+(valor.id_tabla)+',2,'+(valor.ins)+');" '+((valor.ins==0)?('style="color:#cdcdcd;"'):(""))+'><i class="fa fa-toggle-'+((valor.ins==0)?("off"):("on"))+'"></i></a></td>'+
              '<td style="text-align:center;"><a href="javascript:modPerfil_LinkCambiarPerm('+(valor.id_tabla)+',3,'+(valor.upd)+');" '+((valor.upd==0)?('style="color:#cdcdcd;"'):(""))+'><i class="fa fa-toggle-'+((valor.upd==0)?("off"):("on"))+'"></i></a></td>'+
              '<td style="text-align:center;"><a href="javascript:modPerfil_LinkCambiarPerm('+(valor.id_tabla)+',4,'+(valor.del)+');" '+((valor.del==0)?('style="color:#cdcdcd;"'):(""))+'><i class="fa fa-toggle-'+((valor.del==0)?("off"):("on"))+'"></i></a></td>'+
              '</tr>';
    });
  }
  $('#grdUserPerfilBody').html(fila);
}

function modPerfil_LinkCambiarPerm(tablaID,permisoID,valor){
  const tabla = tablaID-1;
  const nvalor = (valor==0)?(1):(0);
  const permisos = ['sel', 'ins', 'upd', 'del'];

  if (permisoID >= 1 && permisoID <= 4) { gridPerfil[tabla][permisos[permisoID - 1]] = nvalor; }
  modPerfil_LlenarTablaPermisos();
}

async function modPerfil_BotonGuardar(){
  const resp = await appAsynFetch(datos = {
      TipoQuery : 'updPerfilUsuario',
      userID : $('#hid_userPerfilID').val(),
      perfil : gridPerfil
    },rutaSQL);

  if (!resp.error) { 
    gridPerfil = [];
    alert("!!!el PERFIL se actualizo correctamente!!!");
    $('#modalPerfiles').modal('hide');
  } else { 
    alert("!!!Hubo errores!!!"); 
  }
}

async function appBotonReset(){
  $("#txtBuscar").val("");
  const resp = await appAsynFetch({ TipoQuery:'comboMisiones' },rutaSQL);
  appLlenarDataEnComboBox(resp.tabla,"#cboMisiones",resp.user.id_iglesia);
  
  if(resp.user.verCombo) { $("#div_cboMisiones").show(); } 
  else { $("#div_cboMisiones").hide(); }
  appGridAll();
}

function appBotonBuscar(e){
  if(e.keyCode === 13) { appGridAll(); }
}

async function appBotonNuevo(){
  let datos = { TipoQuery:'comboMisiones1' }
  const resp = await appAsynFetch(datos,rutaSQL);
  
  appLlenarDataEnComboBox(resp.tabla,"#cboMisiones1",resp.user.id_iglmision);

  if(resp.user.verCombo) { $("#div_admin").show(); } else { $("#div_admin").hide(); }
  $("#txt_ID, #txt_nombres, #txt_apellidos, #txt_login").val("");
  $("#chk_admin").prop("checked",false);

  $('#edit, #btnInsert').show();
  $('#grid, #btnUpdate').hide();
}

function appBotonCancel(){
    $('#edit').hide();
    $('#grid').show();
}

async function appBotonInsert(){
  let datos = appGetDatosToDatabase();
  if(datos!=""){
    datos.commandSQL = "INS";
    const resp = await appAsynFetch(datos,rutaSQL);
    if(!resp.error){
      appGridAll();
      appBotonCancel();
    }
  } else {
    alert("¡¡¡FALTAN LLENAR DATOS o LOS VALORES NO PUEDEN SER CERO!!!");
  }
}

async function appBotonUpdate(){
  let datos = appGetDatosToDatabase();
  if(datos!=""){
    datos.commandSQL = "UPD";
    const resp = await appAsynFetch(datos,rutaSQL);
    if(!resp.error){
      appGridAll();
      appBotonCancel();
    }
  } else {
    alert("¡¡¡FALTAN LLENAR DATOS o LOS VALORES NO PUEDEN SER CERO!!!");
  }
}

async function appBotonDelete(){
  let arr = $('[name="chk_Borrar"]:checked').map(function(){ return this.value; }).get();
  if(confirm("¿Esta seguro de continuar borrando estos "+arr.length+" registros?")){
    const datos = { TipoQuery : 'execUsuario', commandSQL : "DEL", IDs : arr };
    const resp = await appAsynFetch(datos,rutaSQL);
    if(!resp.error) { appGridAll(); }
  }
}

async function appUsuarioEdit(usuarioID){
  const resp = await appAsynFetch({ TipoQuery:'editUsuario', ID:usuarioID },rutaSQL);
  const rpta = await appAsynFetch({ TipoQuery:'comboMisiones1' },rutaSQL);
  
  appLlenarDataEnComboBox(rpta.tabla,"#cboMisiones1",resp.id_iglmision);
  if(rpta.user.verCombo) { $("#div_admin").show(); } else { $("#div_admin").hide(); }
  $("#txt_ID").val(resp.ID);
  $("#txt_nombres").val(resp.nombres);
  $("#txt_apellidos").val(resp.apellidos);
  $("#txt_login").val(resp.login);
  $("#chk_admin").prop("checked",(resp.admin==1)?(true):(false));

  $("#grid, #btnInsert").hide();
  $("#edit, #btnUpdate").show();
}

function appGetDatosToDatabase(){
  let EsError = false;
  let rpta = "";

  $('.box-body .form-group').removeClass('has-error');
  if($("#txt_nombres").val()=="") { $("#div_nombres").prop("class","form-group has-error"); EsError = true; }
  if($("#txt_apellidos").val()=="") { $("#div_apellidos").prop("class","form-group has-error"); EsError = true; }
  if($("#txt_login").val()=="") { $("#div_login").prop("class","form-group has-error"); EsError = true; }

  if(!EsError){
    rpta = {
      TipoQuery : "execUsuario",
      ID : $("#txt_ID").val(),
      nombres : $("#txt_nombres").val(),
      apellidos : $("#txt_apellidos").val(),
      misionID : $("#cboMisiones1").val(),
      login : $("#txt_login").val(),
      admin : ($("#chk_admin").prop("checked")==true)?(1):(0)
    }
  }
  return rpta;
}
