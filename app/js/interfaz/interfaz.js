$(document).ready(async function() {
  try{
    const resp = await appAsynFetch({ TipoQuery:'selDataUser' },"includes/sess_interfaz.php");
    
    $("#ifaz_menu_imagen").attr("src",resp.urlfoto);
    $("#ifaz_menu_nombrecorto").text(resp.nombrecorto);
    $("#ifaz_menu_login").text(resp.login);
    $("#ifaz_barra_imagen").attr("src",resp.urlfoto);
    $("#ifaz_barra_nombrecorto").text(resp.login);
    $("#ifaz_perfil_imagen").attr("src",resp.urlfoto);
    $("#ifaz_perfil_nombrecorto").text(resp.login);
    $("#ifaz_perfil_cargo").text("--");
    if(resp.admin!=1){
      var elements = $("body");
      elements.on("contextmenu", function() { return false; }); // Deshabilitar el menú contextual
      elements.on("dragstart", function() { return false; }); // Deshabilitar el arrastre
      elements.on("selectstart", function() { return false; }); // Deshabilitar la selección de texto
    }
  } catch(err){
    console.error('Error al cargar datos:', err);
  }
});

//=========================funciones para boton Submit============================
function appSubmitButton(miTarea,miModulo){
  switch (miTarea) {
    case "logout": location.href = 'includes/sess_logout.php'; break;
    default: location.href = 'interfaz.php?page='+miTarea; break;
  }
}

// function appNotificacionesSetInterval(){
//   $.ajax({
//     url:'includes/sql_select.php',
//     type:'POST',
//     dataType:'json',
//     data:{"appSQL":JSON.stringify({TipoQuery:'notificaciones'})},
//     success: function(data){ appNotificacionesData(data); },
//     complete:function(data){ setTimeout(appNotificacionesSetInterval,4000); }
//   });
// }

// function appNotificaciones(){
//   appAjaxSelect('includes/sql_select.php',{TipoQuery:'notificaciones'}).done(function(data){
//     appNotificacionesData(data);
//   });
// }

function appNotificacionesData(resp){
  //cuenta total
  $('.NotifiCount').html(resp.cuenta);
  if(resp.cuenta>0) { $('#lblNotifiCount1').show(); } else { $('#lblNotifiCount1').hide(); }

  //detalle de datos
  if(resp.tabla.length>0){
    let appData = "";
    $.each(resp.tabla,function(key, valor){
      if(key<=4) { appData += '<li><a href="javascript:appSubmitButton(\'notificaciones\');" title="'+(valor.usr_solic)+' &raquo; '+(valor.persona)+'"><i class="fa fa-shield text-aqua"></i> '+(valor.usr_solic)+' <i class="fa fa-angle-double-right" style="width:12px;"></i>'+(valor.persona)+'</a></li>'; }
      else { return false; }
    });
    $('#appInterfazNotificaciones').html(appData);
  } else{
    $('#appInterfazNotificaciones').html("");
  }
}
