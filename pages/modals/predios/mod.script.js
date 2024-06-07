//=========================funciones para crear el modal de predios============================
(function (window,document){
  const Predio = {
    rutaSQL : "pages/modals/predios/mod.sql.php",
    rutaHTML : "pages/modals/predios/mod.page.html",
    predioID : 0,
    commandSQL : "",
    queryBuscar : "",
    permiteAdd : "",
    foreignKey : "",
    tablaPredio : 0,
    addModalToParentForm(contenedor) { $("#"+contenedor).load(this.rutaHTML); },
    close(){ $("#modalPredios").modal("hide"); },
    async nuevo(){
      const resp = await appAsynFetch({ TipoQuery:"predio_new" },this.rutaSQL);
        
      this.commandSQL = "INS";
      this.predioID = 0;
      this.tablaPredio = 0;
      $("#txtPredio_Codigo").val(resp.codigo);
      $("#txtPredio_PersJuridica, #txtPredio_Mision, #txtPredio_Nombre, #txtPredio_Telefonos, #txtPredio_Correo, #txtPredio_Sector, #txtPredio_Calle, #txtPredio_Nro, #txtPredio_Dpto, #txtPredio_Mza, #txtPredio_Lote, #txtPredio_Observac").val("");
      appLlenarDataEnComboBox(resp.clases,"#cboPredio_Clases",0); //clases
      appLlenarDataEnComboBox(resp.dmisioneros,"#cboPredio_DMisioneros",0); //distrito misioneros
      appLlenarDataEnComboBox(resp.regiones,"#cboPredio_Region",0); //region
      appLlenarDataEnComboBox(resp.provincias,"#cboPredio_Provincia",0); //provincia
      appLlenarDataEnComboBox(resp.distritos,"#cboPredio_Distrito",0); //distrito

      //config inicial
      $("#btn_modPredioUpdate").hide();
      if(resp.error_dmisioneros!=4){
        $("#btn_modPredioInsert").hide();
        alert("NO se pudo cargar correctamente ningun distrito misionero");
      } else { $("#btn_modPredioInsert").show(); }

      $('.box-body .form-group').removeClass('has-error');
      $("#modalPredios").modal({keyboard:true}).on('shown.bs.modal', () => $('#txtPredio_PersJuridica').focus());
    },
    async editar(predioID){
      const resp = await appAsynFetch({ TipoQuery:'predio_edit', predioID },Predio.rutaSQL);
      
      //config inicial
      this.datosToForm(resp);
      $("#btn_modPredioInsert").hide();
      if(resp.error_dmisioneros!=4){
        $("#btn_modPredioUpdate").hide();
        alert("NO se pudo cargar correctamente ningun distrito misionero");
      } else { 
        $("#btn_modPredioUpdate").show(); 
      }
      
      $("#modalPredios").modal({keyboard:true}).on('shown.bs.modal', () => $('#txtPredio_Codigo').focus());
    },
    async comboProvincia(){
      const resp = await appAsynFetch({ TipoQuery:"comboUbigeo", padreID:$("#cboPredio_Region").val() },this.rutaSQL);
      appLlenarDataEnComboBox(resp.provincias,"#cboPredio_Provincia",0); //provincia
      appLlenarDataEnComboBox(resp.distritos,"#cboPredio_Distrito",0); //distrito
    },
    async comboDistrito(){
      const resp = await appAsynFetch({ TipoQuery:"comboUbigeo", padreID:$("#cboPredio_Provincia").val() },this.rutaSQL);
      appLlenarDataEnComboBox(resp.distritos,"#cboPredio_Distrito",0); //distrito
    },
    sinErrores(){
      let rpta = true;
      $('.box-body .form-group').removeClass('has-error');
      if($("#txtPredio_PersJuridica").val().trim()=="") { $("#divPredio_PersJuridica").prop("class","form-group has-error"); rpta = false; }
      if($("#txtPredio_Mision").val().trim()=="") { $("#divPredio_Mision").prop("class","form-group has-error"); rpta = false; }
      if($("#txtPredio_Nombre").val().trim()=="") { $("#divPredio_Nombre").prop("class","form-group has-error"); rpta = false; }
      if($("#txtPredio_Sector").val().trim()=="") { $("#divPredio_Sector").prop("class","form-group has-error"); rpta = false; }
      return rpta;
    },
    datosToDatabase(){
      let datos = {
        TipoQuery : ((this.predioID==0)?("predio_ins"):("predio_upd")),
        commandSQL : this.commandSQL,
        ID : this.predioID,
        id_clase : $("#cboPredio_Clases").val(),
        id_iglesia : $("#cboPredio_DMisioneros").val(),
        codigo : $("#txtPredio_Codigo").val().trim(),
        per_juridica : $("#txtPredio_PersJuridica").val().trim(),
        mision : $("#txtPredio_Mision").val().trim(),
        nombre : $("#txtPredio_Nombre").val().trim(),
        telefono : $("#txtPredio_Telefonos").val().trim(),
        correo : $("#txtPredio_Correo").val().trim(),
        observac : $("#txtPredio_Observac").val().trim(),
        id_distrito : $("#cboPredio_Distrito").val(),
        sector : $("#txtPredio_Sector").val().trim(),
        avenida : $("#txtPredio_Calle").val().trim(),
        nro : $("#txtPredio_Nro").val().trim(),
        dpto : $("#txtPredio_Dpto").val().trim(),
        mza : $("#txtPredio_Mza").val().trim(),
        lote : $("#txtPredio_Lote").val().trim(),
        maps : "",
      };
      return datos;
    },
    datosToForm(data){
      this.commandSQL = "UPD";
      this.predioID = data.predio.ID;
      $("#txtPredio_Codigo").val(data.predio.codigo);
      $("#txtPredio_PersJuridica").val(data.predio.per_juridica);
      $("#txtPredio_Mision").val(data.predio.mision);
      appLlenarDataEnComboBox(data.clases,"#cboPredio_Clases",data.predio.id_clase); //clases
      appLlenarDataEnComboBox(data.dmisioneros,"#cboPredio_DMisioneros",data.predio.id_igldistrito); //distrito misioneros
      $("#txtPredio_Nombre").val(data.predio.nombre);
      $("#txtPredio_Telefonos").val(data.predio.telefono);
      $("#txtPredio_Correo").val(data.predio.correo);
      appLlenarDataEnComboBox(data.regiones,"#cboPredio_Region",data.predio.id_region); //region
      appLlenarDataEnComboBox(data.provincias,"#cboPredio_Provincia",data.predio.id_provincia); //provincia
      appLlenarDataEnComboBox(data.distritos,"#cboPredio_Distrito",data.predio.id_distrito); //distrito
      $("#txtPredio_Sector").val(data.predio.sector);
      $("#txtPredio_Calle").val(data.predio.avenida);
      $("#txtPredio_Nro").val(data.predio.nro);
      $("#txtPredio_Dpto").val(data.predio.dpto);
      $("#txtPredio_Mza").val(data.predio.mza);
      $("#txtPredio_Lote").val(data.predio.lote);
      $("#txtPredio_Observac").val(data.predio.observac);
    },
    async ejecutaSQL(){
      const exec = new FormData();
      exec.append("appSQL",JSON.stringify(this.datosToDatabase()));
      try{
        const resp = await fetch(this.rutaSQL, { method:'POST', body:exec });
        
        if(!resp.ok){ throw new Error('respuesta de la Red no fue positiva');}
        return await resp.json();
      } catch(err){
        console.error("Error durante la operacion de FETCH",err);
        return null;
      }
    }
  };
  if(typeof window.Predio === 'undefined'){ window.Predio = Predio; }
})(window,document);
