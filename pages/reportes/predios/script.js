const rutaSQL = "pages/reportes/mision/sql.php";
var gridMision = 0;

//=========================funciones para workers============================
async function appBotonConsultar(){
  $("#divchart").html('<div class="progress progress-sm active" style="text-align:center;"><div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" style="width:100%"></div></div>');
  $('#grdDatosBody').html('<tr><td colspan="14" style="text-align:center;"><br><div class="progress progress-sm active" style=""><div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" style="width:100%"></div></div></td></tr>');
  const resp = await appAsynFetch({ TipoQuery:'reporteMision' },rutaSQL);

  $("#lbl_minipredios").html(resp.predios);
  $("#lbl_minidmisioneros").html(resp.dmisioneros);
  $("#btnExportExcel").removeAttr("disabled");
  llenarGraficos(resp.grafico);
  llenarGrid(resp.tablaResumen);
}

function llenarGrid(data){
  gridMision = data;
  if(data.length>0){
    let fila = "";
    $.each(data,function(key, valor){
      fila += '<tr>'+
              '<td>'+(valor.dmisionero)+'</td>'+
              '<td>'+(valor.total)+'</td>'+
              '<td>'+((valor.claseIGL>0)?(valor.claseIGL):("-"))+'</td>'+
              '<td>'+((valor.claseGRP>0)?(valor.claseGRP):("-"))+'</td>'+
              '<td>'+((valor.claseOTR>0)?(valor.claseOTR):("-"))+'</td>'+
              '<td>'+((valor.condiPRP>0)?(valor.condiPRP):("-"))+'</td>'+
              '<td>'+((valor.condiALQ>0)?(valor.condiALQ):("-"))+'</td>'+
              '<td>'+((valor.condiOTR>0)?(valor.condiOTR):("-"))+'</td>'+
              '<td>'+((valor.regpub>0)?(valor.regpub):("-"))+'</td>'+
              '<td>'+((valor.escpub>0)?(valor.escpub):("-"))+'</td>'+
              '<td>'+((valor.contra>0)?(valor.contra):("-"))+'</td>'+
              '<td>'+((valor.sindocs>0)?(valor.sindocs):("-"))+'</td>'+
              '<td>'+((valor.resinafec>0)?(valor.resinafec):("-"))+'</td>'+
              '<td>'+((valor.impred>0)?(valor.impred):("-"))+'</td>'+
              '</tr>';
    });
    $('#grdDatosBody').html(fila);
  }else{
    $('#grdDatosBody').html('<tr><td colspan="14" style="text-align:center;color:red;">Sin Resultados '+((txtBuscar=="")?(""):("para "+txtBuscar))+'</td></tr>');
  }
}

function llenarGraficos(data){
  let fila = "";
  $.each(data,function(key,valor){
    fila += '<p class="text-center"><strong>'+(valor.region)+'</strong></p><div class="chart"><canvas class="pull-left" id="prediosChart'+(key+1)+'" style="height:150px;"></canvas></div>';
  });
  $("#divchart").html(fila);
  $.each(data,function(key,valor){
    let sChart = "#prediosChart"+(key+1);
    appGraph(sChart,valor.grafico);
  });
}

function appGraph(objChart,data){
  let chartGraf = {labels:[], totales:[]};
  $.each(data,function(key, valor){
    chartGraf.labels.push(valor.codigo);
    chartGraf.totales.push(valor.total);
  });
  let chartCanvas = $(objChart).get(0).getContext('2d');
  let miChart = new Chart(chartCanvas);
  let chartData = {
    labels  : chartGraf.labels,
    datasets: [
      {
        label               : 'Cartera',
        fillColor           : 'rgba(45, 192, 236,0.7)',
        strokeColor         : 'rgba(38, 164, 201,1)',
        pointColor          : 'rgb(45, 192, 236)',
        pointStrokeColor    : 'rgb(45, 192, 236)',
        pointHighlightFill  : 'rgb(52, 123, 161)',
        pointHighlightStroke: 'rgb(52, 123, 161)',
        data                : chartGraf.totales
      }
    ]
  };
  let chartOptions = {
    showScale               : true,   // Boolean - If we should show the scale at all
    scaleShowGridLines      : true,  // Boolean - Whether grid lines are shown across the chart
    scaleGridLineColor      : 'rgba(0,0,0,.05)',  // String - Colour of the grid lines
    scaleGridLineWidth      : 1,      // Number - Width of the grid lines
    scaleShowHorizontalLines: true,   // Boolean - Whether to show horizontal lines (except X axis)
    scaleShowVerticalLines  : true,   // Boolean - Whether to show vertical lines (except Y axis)
    bezierCurve             : true,   // Boolean - Whether the line is curved between points
    bezierCurveTension      : 0.3,    // Number - Tension of the bezier curve between points
    pointDot                : true,  // Boolean - Whether to show a dot for each point
    pointDotRadius          : 4,      // Number - Radius of each point dot in pixels
    pointDotStrokeWidth     : 1,      // Number - Pixel width of point dot stroke
    pointHitDetectionRadius : 20,     // Number - amount extra to add to the radius to cater for hit detection outside the drawn point
    datasetStroke           : true,   // Boolean - Whether to show a stroke for datasets
    datasetStrokeWidth      : 2,      // Number - Pixel width of dataset stroke
    datasetFill             : true,   // Boolean - Whether to fill the dataset with a color
    // String - A legend template
    //legendTemplate          : '<ul class=\'<%=name.toLowerCase()%>-legend\'><% for (var i=0; i<datasets.length; i++){%><li> <span style=\'background-color:<%=datasets[i].lineColor%>\'></span><%=datasets[i].label%></li><%}%></ul>',
    maintainAspectRatio     : true,   // Boolean - whether to maintain the starting aspect ratio or not when responsive, if set to false, will take up entire container
    responsive              : true    // Boolean - whether to make the chart responsive to window resizing
  };

  //miChart.Doughnut(pieGraf, pieOptions);
  miChart.Bar(chartData, chartOptions);
}

async function appBotonDownload(){
  const resp = await appAsynFetch({ TipoQuery:'downloadMision', grid:gridMision },rutaSQL);
  
  resp.tableData.data = gridMision;
  console.log(resp.tableData);
  Jhxlsx.export(resp.tableData, resp.options);
}
