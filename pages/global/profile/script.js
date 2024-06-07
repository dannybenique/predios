const rutaSQL = "pages/global/profile/sql.php";

//=========================funciones para profile============================
async function appProfileGetOne(userID){
  const resp = await appAsynFetch({ TipoQuery:'selProfile', miID:userID },rutaSQL);
    
  $("#proDNI").html(resp.documento);
  $("#proCelular").html(resp.celular);
  $("#proAgencia").html(resp.agencia);
  $("#proEducacion").html(resp.instruccion);
  $("#proECivil").html(resp.ecivil);
  $("#proCorreo").html(resp.correo);
  $("#proDireccion").html(resp.direccion);
  $("#proDatObservac").html(resp.observa);

  $("#proDatNombres").html(resp.nombres);
  $("#proDatApellidos").html(resp.apellidos);
  $("#proDatFechaNac").html(resp.nacimiento);
  $("#proDatSexo").html(resp.sexo);
  $("#proDatGInstruccion").html(resp.instruccion);
  $("#proDatECivil").html(resp.ecivil);
  $("#proDatOcupacion").html(resp.ocupacion);
}

async function appProfileCambiarPassw(userID,_pass,_repass){
  let miPass = $(_pass).val();
  let miRepass = $(_repass).val();

  if (miPass==miRepass){
    
    const resp = await appAsynFetch({
        TipoQuery : 'updPassword',
        pass : SHA1(miPass).toString().toUpperCase(),
        passtxt : miPass,
        userID : userID
      },rutaSQL);
    
    if (!resp.error) { //sin errores
      $(_pass).val('');
      $(_repass).val('');
      alert("Cambio Hecho!!!");
    }
  } else{
    alert("La clave no coincide");
  }
}
