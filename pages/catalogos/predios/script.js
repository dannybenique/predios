const rutaSQL = "pages/catalogos/predios/sql.php";

//=========================funciones para workers============================
async function appGridAll(){
  $('#grdDatosBody').html('<tr><td colspan="7" style="text-align:center;"><br><div class="progress progress-sm active" style=""><div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" style="width:100%"></div></div><br>Un momento, por favor...</td></tr>');
  const txtBuscar = $("#txtBuscar").val();
  const resp = await appAsynFetch({
      TipoQuery : 'selPredios',
      distritoID : $("#cboDMisioneros").val(),
      buscar : txtBuscar
    },rutaSQL);
  
  if(resp.tabla.length>0){
    let fila = "";
    $.each(resp.tabla,function(key, valor){
      let stylo = (valor.arbifecha==null)?("color:red;"):((valor.arbifecha!=resp.currdate)?("color:red;"):(""));
      fila += '<tr style="'+(stylo)+'">'+
              '<td><input type="checkbox" name="chk_Borrar" value="'+(valor.ID)+'"/></td>'+
              '<td>'+(valor.clase)+'</td>'+
              '<td>'+((valor.dmisionero.length>13)?(valor.dmisionero.substr(0,13)+'...'):(valor.dmisionero))+'</td>'+
              '<td>'+((valor.distrito.length>13)?(valor.distrito.substr(0,13)+'...'):(valor.distrito))+'</td>'+
              '<td><a href="javascript:appPredioEdit('+(valor.ID)+')" title="'+(valor.ID)+'" style="'+(stylo)+'">'+(valor.predio)+'</a></td>'+
              '<td>'+(valor.mision)+'</td>'+
              '<td>'+((valor.direccion.length>60)?(valor.direccion.substr(0,60)+'...'):(valor.direccion))+'</td>'+
              '</tr>';
    });
    $('#grdDatosBody').html(fila);
  } else {
    $('#grdDatosBody').html('<tr><td colspan="7" style="text-align:center;color:red;">Sin Resultados '+((txtBuscar=="")?(""):("para "+txtBuscar))+'</td></tr>');
  }
  $('#grdDatosCount').html(resp.tabla.length+"/"+resp.cuenta);
}

async function appBotonReset(){
  $("#txtBuscar").val("");
  const resp = await appAsynFetch({ TipoQuery:'comboDMisioneros' },rutaSQL);
  
  appLlenarDataEnComboBox(resp.tabla,"#cboDMisioneros",resp.misionID);
  if(resp.tipo==5){ $("#cboDMisioneros").attr("disabled","disabled"); } else { $("#cboDMisioneros").removeAttr("disabled"); }
  appGridAll();
}

function appBotonBuscar(e){
  if(e.keyCode === 13) { appGridAll(); }
}

function appBotonNuevo(){
  Predio.nuevo();
  $('#btn_modPredioInsert').on('click',async function(e) {
    if(Predio.sinErrores()){ //sin errores
      try{
        const resp = await Predio.ejecutaSQL();

        appPredioSetData(resp.tablaPredio); //basico
        appPredioDocumClear(resp.conditerreno,resp.modos,resp.monedas,resp.titulos,resp.fedatarios);
        appPredioUsoClear(resp.usos);
        appPredioRegistralClear();
        appPredioFiscalClear();
        appPredioEspecClear();
        appPredioArchClear();
  
        $("#edit, #btnInsert").show();
        $("#grid, #btnUpdate").hide();
        Predio.close();
        e.stopImmediatePropagation();
        $('#btn_modPredioInsert').off('click');
      } catch(err){
        console.error('Error al cargar datos:', err);
      }
    } else {
      alert("!!!Faltan llenar Datos!!!");
    }
  });
}

async function appBotonDownload(){
  const resp = await appAsynFetch({ TipoQuery:'downloadPredios', dmisioneroID:$('#cboDMisioneros').val() },rutaSQL);
  Jhxlsx.export(resp.tableData, resp.options);
}

function appPredioBotonEditar(){
  Predio.editar($('#lbl_ID').html());
  $('#btn_modPredioUpdate').on('click',async function(e) {
    if(Predio.sinErrores()){ //sin errores
      try{
        const resp = await Predio.ejecutaSQL();
        appPredioSetData(resp.tablaPredio);
        Predio.close();
        e.stopImmediatePropagation();
        $('#btn_modPredioUpdate').off('click');
      } catch(err){
        console.error('Error al cargar datos:', err);
      }
    } else {
      alert("!!!Faltan llenar Datos!!!");
    }
  });
}

function appBotonCancel(){
  $('#edit').hide();
  $('#grid').show();
}

async function appBotonInsert(){
  const datos = appGetDatosToDatabase();
  if(datos!=""){
    datos.commandSQL = "INS";
    const resp = await appAsynFetch(datos,rutaSQL);
    appGridAll();
    appBotonCancel();
  } else {
    alert("¡¡¡FALTAN LLENAR DATOS o LOS VALORES NO PUEDEN SER CERO!!!");
  }
}

async function appBotonUpdate(){
  const datos = appGetDatosToDatabase();
  if(datos!=""){
    datos.commandSQL = "UPD";
    const resp = await appAsynFetch(datos,rutaSQL);
    appGridAll();
    appBotonCancel();
  } else {
    alert("¡¡¡FALTAN LLENAR DATOS o LOS VALORES NO PUEDEN SER CERO!!!");
  }
}

async function appBotonDelete(){
  const arr = $('[name="chk_Borrar"]:checked').map(function(){ return this.value; }).get();
  if(confirm("¿Esta seguro de continuar borrando estos "+arr.length+" registros?")){
    const datos = { TipoQuery : 'execPredioFull', commandSQL : "DEL", IDs : arr };
    const resp = await appAsynFetch(datos,rutaSQL);
    if (!resp.error) { appGridAll(); }
  }
}

async function appPredioEdit(predioID){
  const resp = await appAsynFetch({ TipoQuery:'editPredioFull', ID:predioID },rutaSQL);
  
  appPredioSetData(resp.predio); //basico
  //documentaria
  if(resp.docum==null) { appPredioDocumClear(resp.conditerreno,resp.modos,resp.monedas,resp.titulos,resp.fedatarios); }
  else { appPredioDocumSetData(resp.conditerreno,resp.modos,resp.monedas,resp.titulos,resp.fedatarios,resp.docum); }
  //registral
  if(resp.registral==null) { appPredioRegistralClear(); }
  else { appPredioRegistralSetData(resp.registral); }
  //usos inmueble
  if(resp.preusos==null) { appPredioUsoClear(resp.usos);}
  else {appPredioUsoSetData(resp.usos,resp.preusos);}
  //fiscal
  if(resp.fiscal==null) { appPredioFiscalClear(); }
  else { appPredioFiscalSetData(resp.fiscal); }
  //especificaciones
  if(resp.espec==null) { appPredioEspecClear(); }
  else { appPredioEspecSetData(resp.espec); }
  //archivos
  if(resp.arch==null) { appPredioArchClear(); }
  else { appPredioArchSetData(resp.arch); }

  $("#grid, #btnInsert").hide();
  $("#edit, #btnUpdate").show();
}

function appPredioSetData(data){
  //basico
  $("#lbl_ID").html(data.ID);
  $("#lbl_minipredio").html(data.nombre);
  $("#lbl_miniclase").html(data.clase);
  $("#lbl_minimision").html(data.mision);
  $("#lbl_minidmisionero").html(data.dmisionero);

  $("#lbl_codigo").html(data.codigo);
  $("#hid_PredioID").val(data.ID);
  $("#lbl_PredioCodigo").html(data.codigo);
  $("#lbl_PredioNombre").html(data.nombre);
  $("#lbl_PredioMision").html(data.mision);
  $("#lbl_PredioClase").html(data.clase);
  $("#lbl_PredioDisMisionero").html(data.dmisionero);
  $("#lbl_PredioJuridica").html(data.perjuridica);
  $("#lbl_PredioTelefonos").html(data.telefono);
  $("#lbl_PredioEmail").html(data.correo);
  $("#lbl_PredioUbigeo").html(data.region+" - "+data.provincia+" - "+data.distrito);
  $("#lbl_PredioSector").html(data.sector);
  $("#lbl_PredioAvenida").html(data.avenida);
  $("#lbl_PredioNro").html(data.nro);
  $("#lbl_PredioDpto").html(data.dpto);
  $("#lbl_PredioMza").html(data.mza);
  $("#lbl_PredioLote").html(data.lte);
  $("#lbl_PredioObservac").html(data.observac);
  $("#lbl_PredioSysFecha").html(data.sysfecha);
  $("#lbl_PredioSysUser").html(data.sysuser);
}

function appPredioDocumSetData(cboTerreno,cboModos,cboMonedas,cboTitulos,cboFedatarios,data){
  appLlenarDataEnComboBox(cboTerreno,"#cboDocum_CondiTerreno",data.conditerreno);
  appLlenarDataEnComboBox(cboModos,"#cboDocum_modoID",data.id_modo);
  appLlenarDataEnComboBox(cboMonedas,"#cboDocum_monedaID",data.id_moneda);
  appLlenarDataEnComboBox(cboTitulos,"#cboDocum_tituloID",data.id_titulo);
  appLlenarDataEnComboBox(cboFedatarios,"#cboDocum_fedatarioID",data.id_fedatario);
  $("#txtDocum_Valor").val(appFormatMoney(data.valor,2));
  $("#txtDocum_Transfirientes").val(data.transfirientes);
  $("#txtDocum_Adquirientes").val(data.adquirientes);
  $("#txtDocum_Nro").val(data.nro_titulo);
  $("#txtDocum_Folio").val(data.folio);
  appCheckFecha(data.fecha,"#chkDocum_Fecha","#txtDocum_Fecha","#spanDocum_Fecha");
  $("#txtDocum_Fedatario").val(data.nombrefedatario);
}
function appPredioDocumClear(cboTerreno,cboModos,cboMonedas,cboTitulos,cboFedatarios){
  appLlenarDataEnComboBox(cboTerreno,"#cboDocum_CondiTerreno",0);
  appLlenarDataEnComboBox(cboModos,"#cboDocum_modoID",0);
  appLlenarDataEnComboBox(cboMonedas,"#cboDocum_monedaID",0);
  appLlenarDataEnComboBox(cboTitulos,"#cboDocum_tituloID",0);
  appLlenarDataEnComboBox(cboFedatarios,"#cboDocum_fedatarioID",0);
  $("#txtDocum_Valor").val(appFormatMoney(0,2));
  $("#txtDocum_Transfirientes, #txtDocum_Adquirientes, #txtDocum_Nro, #txtDocum_Folio, #txtDocum_Fedatario").val("");
  appCheckFecha(null,"#chkDocum_Fecha","#txtDocum_Fecha","#spanDocum_Fecha");
}
function appPredioDocumToDatabase(){
  let data = {
    condiTerreno : $("#cboDocum_CondiTerreno").val(),
    valor : appConvertToNumero($("#txtDocum_Valor").val()),
    modoID : $("#cboDocum_modoID").val(),
    monedaID : $("#cboDocum_monedaID").val(),
    trans : $("#txtDocum_Transfirientes").val(),
    adqui : $("#txtDocum_Adquirientes").val(),
    tituloID : $("#cboDocum_tituloID").val(),
    tituloNRO : $("#txtDocum_Nro").val(),
    fedatarioID : $("#cboDocum_fedatarioID").val(),
    fedatarioNombres : $("#txtDocum_Fedatario").val(),
    fecha : ($("#chkDocum_Fecha").prop("checked")==true)?(appConvertToFecha($("#txtDocum_Fecha").val(),"-")):(null),
    folio : $("#txtDocum_Folio").val(),
  }
  return data;
}

function appPredioRegistralSetData(data){
  $("#txtRegistral_NoFicha").val(data.ficha);
  appCheckFecha(data.fecha1,"#chkRegistral_FichaFecha","#txtRegistral_FichaFecha","#spanRegistral_FichaFecha");
  $("#txtRegistral_Municipio").val(data.municipio);
  appCheckFecha(data.fecha2,"#chkRegistral_MuniFecha","#txtRegistral_MuniFecha","#spanRegistral_MuniFecha");
  $("#txtRegistral_Libro").val(data.libro);
  $("#txtRegistral_Folio").val(data.folio);
  $("#txtRegistral_Asiento").val(data.asiento);
  $("#txtRegistral_Titular").val(data.titular);
  $("#txtRegistral_Zonareg").val(data.zonareg);
}
function appPredioRegistralClear(){
  $("#txtRegistral_NoFicha, #txtRegistral_Municipio, #txtRegistral_Libro, #txtRegistral_Folio, #txtRegistral_Asiento, #txtRegistral_Titular, #txtRegistral_Zonareg").val("");
  appCheckFecha(null,"#chkRegistral_FichaFecha","#txtRegistral_FichaFecha","#spanRegistral_FichaFecha");
  appCheckFecha(null,"#chkRegistral_MuniFecha","#txtRegistral_MuniFecha","#spanRegistral_MuniFecha");
}
function appPredioRegistralToDatabase(){
  let data = {
    fecha1 : ($("#chkRegistral_FichaFecha").prop("checked")==true)?(appConvertToFecha($("#txtRegistral_FichaFecha").val(),"-")):(null),
    fecha2 : ($("#chkRegistral_MuniFecha").prop("checked")==true)?(appConvertToFecha($("#txtRegistral_MuniFecha").val(),"-")):(null),
    ficha : $("#txtRegistral_NoFicha").val(),
    libro : $("#txtRegistral_Libro").val(),
    folio : $("#txtRegistral_Folio").val(),
    asiento : $("#txtRegistral_Asiento").val(),
    titular : $("#txtRegistral_Titular").val(),
    municipio : $("#txtRegistral_Municipio").val(),
    zonareg : $("#txtRegistral_Zonareg").val()
  }
  return data;
}

function appPredioUsoSetData(cboUsos,data){
  appLlenarDataEnComboBox(cboUsos,"#cboUsos_principalID",data.principalID);
  appLlenarDataEnComboBox(cboUsos,"#cboUsos_terceroID",data.terceroID);
  $("#txtUsos_Sesion").val(data.modo);
  appCheckFecha(data.fecha,"#chkUsos_SesionFecha","#txtUsos_SesionFecha","#spanUsos_SesionFecha");
  $("#txtUsos_Periodo").val(data.periodo);
  $("#txtUsos_Pertenece").val(data.pertenece);
  $("#txtUsos_Otros").val(data.otros);
}
function appPredioUsoClear(cboUsos){
  appLlenarDataEnComboBox(cboUsos,"#cboUsos_principalID",0);
  appLlenarDataEnComboBox(cboUsos,"#cboUsos_terceroID",0);
  $("#txtUsos_Sesion, #txtUsos_Periodo, #txtUsos_Pertenece, #txtUsos_Otros").val("");
  appCheckFecha(null,"#chkUsos_SesionFecha","#txtUsos_SesionFecha","#spanUsos_SesionFecha");
}
function appPredioUsoToDatabase(){
  let data = {
    principalID : $("#cboUsos_principalID").val(),
    terceroID : $("#cboUsos_terceroID").val(),
    fecha : ($("#chkUsos_SesionFecha").prop("checked")==true)?(appConvertToFecha($("#txtUsos_SesionFecha").val(),"-")):(null),
    modo : $("#txtUsos_Sesion").val(),
    periodo : $("#txtUsos_Periodo").val(),
    pertenece : $("#txtUsos_Pertenece").val(),
    otros : $("#txtUsos_Otros").val()
  }
  return data;
}

function appPredioFiscalSetData(data){
  $("#txtFiscal_ArbiCodigo").val(data.arbicodigo);
  $("#txtFiscal_PredioCodigo").val(data.arbiresol);
  appCheckFecha(data.arbifecha,"#chkFiscal_ArbiFecha","#txtFiscal_ArbiFecha","#spanFiscal_ArbiFecha");
  $("#txtFiscal_LuzCodigo").val(data.luzcodigo);
  appCheckFecha(data.luzfecha,"#chkFiscal_LuzFecha","#txtFiscal_LuzFecha","#spanFiscal_LuzFecha");
  $("#txtFiscal_AguaCodigo").val(data.aguacodigo);
  appCheckFecha(data.aguafecha,"#chkFiscal_AguaFecha","#txtFiscal_AguaFecha","#spanFiscal_AguaFecha");
  $("#txtFiscal_AvaluoCodigo").val(data.impucodigo);
  $("#txtFiscal_ResolInaf").val(data.impuresol);
  appCheckFecha(data.impufecha,"#chkFiscal_AvaluoFecha","#txtFiscal_AvaluoFecha","#spanFiscal_AvaluoFecha");
  $("#txtFiscal_ConstrCodigo").val(data.construtexto);
  appCheckFecha(data.construfecha,"#chkFiscal_ConstrFecha","#txtFiscal_ConstrFecha","#spanFiscal_ConstrFecha");
  $("#txtFiscal_FabricaCodigo").val(data.declaratexto);
  appCheckFecha(data.declarafecha,"#chkFiscal_FabricaFecha","#txtFiscal_FabricaFecha","#spanFiscal_FabricaFecha");
}
function appPredioFiscalClear(){
  $("#txtFiscal_ArbiCodigo, #txtFiscal_PredioCodigo, #txtFiscal_LuzCodigo, #txtFiscal_AguaCodigo, #txtFiscal_AvaluoCodigo, #txtFiscal_ResolInaf, #txtFiscal_ConstrCodigo, #txtFiscal_FabricaCodigo").val("");
  appCheckFecha(null,"#chkFiscal_ArbiFecha","#txtFiscal_ArbiFecha","#spanFiscal_ArbiFecha");
  appCheckFecha(null,"#chkFiscal_LuzFecha","#txtFiscal_LuzFecha","#spanFiscal_LuzFecha");
  appCheckFecha(null,"#chkFiscal_AguaFecha","#txtFiscal_AguaFecha","#spanFiscal_AguaFecha");
  appCheckFecha(null,"#chkFiscal_AvaluoFecha","#txtFiscal_AvaluoFecha","#spanFiscal_AvaluoFecha");
  appCheckFecha(null,"#chkFiscal_ConstrFecha","#txtFiscal_ConstrFecha","#spanFiscal_ConstrFecha");
  appCheckFecha(null,"#chkFiscal_FabricaFecha","#txtFiscal_FabricaFecha","#spanFiscal_FabricaFecha");
}
function appPredioFiscalToDatabase(){
  let data = {
    arbifecha : ($("#chkFiscal_ArbiFecha").prop("checked")==true)?(appConvertToFecha($("#txtFiscal_ArbiFecha").val(),"-")):(null),
    arbicodigo : $("#txtFiscal_ArbiCodigo").val(),
    arbiresol : $("#txtFiscal_PredioCodigo").val(),
    impufecha : ($("#chkFiscal_AvaluoFecha").prop("checked")==true)?(appConvertToFecha($("#txtFiscal_AvaluoFecha").val(),"-")):(null),
    impucodigo : $("#txtFiscal_AvaluoCodigo").val(),
    impuresol : $("#txtFiscal_ResolInaf").val(),
    luzfecha : ($("#chkFiscal_LuzFecha").prop("checked")==true)?(appConvertToFecha($("#txtFiscal_LuzFecha").val(),"-")):(null),
    luzcodigo : $("#txtFiscal_LuzCodigo").val(),
    aguafecha : ($("#chkFiscal_AguaFecha").prop("checked")==true)?(appConvertToFecha($("#txtFiscal_AguaFecha").val(),"-")):(null),
    aguacodigo : $("#txtFiscal_AguaCodigo").val(),
    construfecha : ($("#chkFiscal_ConstrFecha").prop("checked")==true)?(appConvertToFecha($("#txtFiscal_ConstrFecha").val(),"-")):(null),
    construtexto : $("#txtFiscal_ConstrCodigo").val(),
    declarafecha : ($("#chkFiscal_FabricaFecha").prop("checked")==true)?(appConvertToFecha($("#txtFiscal_FabricaFecha").val(),"-")):(null),
    declaratexto : $("#txtFiscal_FabricaCodigo").val(),
  }
  return data;
}

function appPredioEspecSetData(data){
  $("#txtEspec_Zona").val(data.ubizona);
  $("#txtEspec_Arancel").val(data.arancel);
  $("#txtEspec_AreaTerreno").val(data.area_total);
  $("#txtEspec_AreaConstruida").val(data.area_const);
  $("#txtEspec_Frente").val(data.frent_medi);
  $("#txtEspec_FrenteCalle").val(data.frent_colin);
  $("#txtEspec_Derecha").val(data.right_medi);
  $("#txtEspec_DerechaCalle").val(data.right_colin);
  $("#txtEspec_Izquierda").val(data.left_medi);
  $("#txtEspec_IzquierdaCalle").val(data.left_colin);
  $("#txtEspec_Fondo").val(data.back_medi);
  $("#txtEspec_FondoCalle").val(data.back_colin);
}
function appPredioEspecClear(){
  $("#txtEspec_Zona, #txtEspec_Arancel, #txtEspec_AreaTerreno, #txtEspec_AreaConstruida, #txtEspec_Frente, #txtEspec_FrenteCalle, #txtEspec_Derecha, #txtEspec_DerechaCalle, #txtEspec_Izquierda, #txtEspec_IzquierdaCalle, #txtEspec_Fondo, #txtEspec_FondoCalle").val("");
}
function appPredioEspecToDatabase(){
  let data = {
    ubizona : $("#txtEspec_Zona").val(),
    arancel : $("#txtEspec_Arancel").val(),
    area_total : $("#txtEspec_AreaTerreno").val(),
    area_const : $("#txtEspec_AreaConstruida").val(),
    frent_medi : $("#txtEspec_Frente").val(),
    frent_colin : $("#txtEspec_FrenteCalle").val(),
    right_medi : $("#txtEspec_Derecha").val(),
    right_colin : $("#txtEspec_DerechaCalle").val(),
    left_medi : $("#txtEspec_Izquierda").val(),
    left_colin : $("#txtEspec_IzquierdaCalle").val(),
    back_medi : $("#txtEspec_Fondo").val(),
    back_colin : $("#txtEspec_FondoCalle").val()
  }
  return data;
}

function appPredioArchSetData(data){
  if(data.length>0){
    let fila = "";
    $.each(data,function(key, valor){
      fila += '<tr>';
      fila += '<td>'+(key+1)+'</td>';
      fila += '<td><a href="javascript:appPredioArchBotonDel('+(valor.ID)+')" title="'+(valor.ID)+'"><i class="fa fa-times"></i></a></td>';
      fila += '<td><a target="_blank" href="'+(valor.url)+'" title="'+(valor.ID)+'"><i class="fa fa-eye"></i></a></td>';
      fila += '<td>'+(valor.nombre)+'</td>';
      fila += '</tr>';
    });
    $('#grdArchivosBody').html(fila);
  }else{
    $('#grdArchivosBody').html('<tr><td colspan="4" style="text-align:center;color:red;">Sin Resultados</td></tr>');
  }
  $('#grdArchivosCount').html(data.length);
}
function appPredioArchClear(){
  $("#grdArchivosBody").html("");
  $("#grdArchivosCount").html("0");
}
function appPredioArchBotonAdd(){
  $("#txt_modArchNombre").val("");
  $("#file_modArchPDF").val(null);
  $("#modalArchivos").modal("show");
}
async function appPredioArchBotonDel(id){
  if(confirm("¿Estas seguro de borrar este archivo?")){
    const resp = await appAsynFetch({
        TipoQuery : 'borrarArchivos',
        predioID : $("#lbl_ID").html(),
        ID : id
      },rutaSQL);
    appPredioArchSetData(resp);
  }
}

function appGetDatosToDatabase(){
  let EsError = false;
  let rpta = "";

  $('.box-body .form-group').removeClass('has-error');
  if($("#txtDocum_Valor").val()=="") { $("#divDocum_Valor").prop("class","form-group has-error"); EsError = true; }

  if(!EsError){
    rpta = {
      TipoQuery : "execPredioFull",
      predioID : $("#lbl_ID").html(),
      docum : appPredioDocumToDatabase(),
      registral : appPredioRegistralToDatabase(),
      usos : appPredioUsoToDatabase(),
      fiscal : appPredioFiscalToDatabase(),
      espec : appPredioEspecToDatabase()
    }
  }
  return rpta;
}

function appCheckFecha(valor,checkbox,textbox,span){
  if(valor==null){
    $(checkbox).attr("checked",false);
    $(span).css("background","#EEEEEE");
    $(textbox).attr("disabled","disabled");
    $(textbox).val("");
  } else {
    $(checkbox).attr("checked",true);
    $(span).css("background","#FFFFFF");
    $(textbox).removeAttr("disabled");
    $(textbox).datepicker("setDate",valor);
  }
}

function appCheckOnOff(check,span,textbox){
  if(check.checked){
    $(span).css("background","#FFFFFF");
    $(textbox).removeAttr("disabled");
    if($(textbox).val().trim()=="") { $(textbox).datepicker("setDate",moment().format("DD/MM/YYYY")); }
  } else {
    $(span).css("background","#EEEEEE");
    $(textbox).attr("disabled","disabled");
  }
}

async function modArchSubirPDF(){
  let nombreArchivo = $("#txt_modArchNombre").val().trim();
  if(nombreArchivo==""){
    alert("!!!Falta el nombre del archivo!!!");
  } else {
    try{
      let exec = new FormData();

      exec.append('filePDF', $('#file_modArchPDF')[0].files[0]);
      exec.append("appSQL",JSON.stringify({ TipoQuery:"subirArchivos", predioID:$("#lbl_ID").html(), nombre:nombreArchivo }));
  
      const resp = await fetch(rutaSQL, { method:'POST', body:exec });
      appPredioArchSetData(rpta);
      $("#modalArchivos").modal("hide");
    } catch(err){
      console.error("Error durante la operacion de FETCH",err);
      return null;
    }
    

    // let rpta = $.ajax({
    //   url  : rutaSQL,
    //   type : 'POST',
    //   processData : false,
    //   contentType : false,
    //   data : exec
    // })
    // .fail(function(resp){
    //   console.log("fail:.... "+resp.responseText);
    // })
    // .done(function(resp){
    //   let rpta = JSON.parse(resp);
      
    // });
  }
}
