const rutaSQL = "pages/catalogos/ubigeo/sql.php";
//=========================funciones para Agencias============================
function appRootGetAll(){
  let setting = {
    async: {
      enable : true,
      url    : rutaSQL,
      type   : "post",
      autoParam  : ["id", "name", "level"],
      otherParam : {"appSQL":JSON.stringify({"TipoQuery":'selUbigeo'})},
      dataFilter : appFiltro
    }
  };
  $.fn.zTree.init($("#appTreeView"), setting);
}

function appResetNodo(){
  let zTree = $.fn.zTree.getZTreeObj("appTreeView");
  let nodes = zTree.getSelectedNodes();
  if (nodes.length == 0) {
    appRootGetAll();
  } else {
    let nodo = nodes[0];
    zTree.reAsyncChildNodes(nodo, "refresh");
    zTree.selectNode(nodo);
  }
}

function appFiltro(treeId, parentNode, childNodes) {
  return childNodes;
}

function appNew(nodo){
  $("#txt_ID").val("0");
  $("#txt_Codigo, txt_Nombre").val("");
  $("#txt_Parent").val(nodo.id+" - "+nodo.name);
  $("#hid_ParentID").val(nodo.id);
  $("#btn_modalInsert").show();
  $("#btn_modalUpdate").hide();

  $("#div_Codigo").prop("class","form-group");
  $("#div_Nombre").prop("class","form-group");

  $("#modalUbigeo").modal();
}

async function appEdit(nodo){
  const resp = await appAsynFetch({ TipoQuery:'editUbigeo', ID:nodo.id },rutaSQL);
  
  $("#txt_ID").val(resp.tabla.ID);
  $("#txt_Codigo").val(resp.tabla.codigo);
  $("#txt_Nombre").val(resp.tabla.nombre);
  $("#txt_Parent").val(resp.tabla.nombrePadre);

  $("#btn_modalUpdate").show();
  $("#btn_modalInsert").hide();

  $("#div_Codigo").prop("class","form-group");
  $("#div_Nombre").prop("class","form-group");

  $("#modalUbigeo").modal();
}

async function modalInsert(){
  const datos = appGetDataToDataBase();
  if(datos!=""){
    datos.commandSQL = "INS";
    const resp = await appAsynFetch(datos,rutaSQL);
    
    let zTree = $.fn.zTree.getZTreeObj("appTreeView");
    let nodes = zTree.getSelectedNodes();
    let nodo = nodes[0];
    if(nodo.isParent==false) {nodo.isParent=true;}
    zTree.reAsyncChildNodes(nodo, "refresh");
    zTree.selectNode(nodo);
    $("#modalUbigeo").modal("hide");
  }
}

async function modalUpdate(){
  let datos = appGetDataToDataBase();
  if(datos!=""){
    datos.commandSQL = "UPD";
    const resp = await appAsynFetch(datos,rutaSQL);
    
    let zTree = $.fn.zTree.getZTreeObj("appTreeView");
    let nodes = zTree.getSelectedNodes();
    let nodo = nodes[0];
    nodo.name = $("#txt_Codigo").val()+" - "+$("#txt_Nombre").val();
    zTree.updateNode(nodo);
    zTree.selectNode(nodo);
    $("#modalUbigeo").modal("hide");
  }
}

function refreshNode(e) {
  var zTree = $.fn.zTree.getZTreeObj("appTreeView");
  var nodes = zTree.getSelectedNodes();
  if (nodes.length == 0) {
    alert("!!!Debe seleccionar una UBICACION!!!");
  } else {
    switch(e.data.type){
      case "add": appNew(nodes[0]); break;
      case "edt": appEdit(nodes[0]); break;
    }
  }
}

function appGetDataToDataBase(){
  let EsError = false;
  let rpta = "";

  $('.box-body .form-group').removeClass('has-error');
  if($("#txt_Codigo").val()=="") { $("#div_Codigo").prop("class","form-group has-error"); EsError = true; }
  if($("#txt_Nombre").val()=="") { $("#div_Nombre").prop("class","form-group has-error"); EsError = true; }

  if(!EsError){
    rpta = {
      TipoQuery : 'execUbigeo',
      ID : $("#txt_ID").val(),
      codigo : $("#txt_Codigo").val(),
      nombre : $("#txt_Nombre").val(),
      padreID : $("#hid_ParentID").val()
    }
  }
  return rpta;
}
