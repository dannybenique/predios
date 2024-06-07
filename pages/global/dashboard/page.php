<!-- datepicker -->
<script src="libs/bootstrap-datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<!-- ChartJS -->
<script src="libs/chart.js/chart.min.js"></script>

<!-- Content Header (Page header) -->
<section class="content-header">
  <h1>Dashboard</h1>
  <ol class="breadcrumb">
    <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>
    <li class="active">Dashboard</li>
  </ol>
</section>

<!-- Main content -->
<section class="content">
  <div class="row">
    <div class="col-lg-3 col-xs-6">
      <div class="small-box bg-green">
        <div class="inner">
          <h3 id="appTotalPredios"><sup style="font-size:20px">00</sup></h3>
          <p>Predios</p>
        </div>
        <div class="icon">
          <i class="fa fa-home"></i>
        </div>
        <a href="javascript:appSubmitButton('catPredios');" class="small-box-footer">Mas info <i class="fa fa-arrow-circle-right"></i></a>
      </div>
    </div>
    <div class="col-lg-3 col-xs-6">
      <div class="small-box bg-blue">
        <div class="inner">
          <h3 id="appTotalDMisioneros"><sup style="font-size:20px">00</sup></h3>
          <p>Dist. Misio.</p>
        </div>
        <div class="icon">
          <i class="fa fa-sitemap"></i>
        </div>
        <a href="javascript:appSubmitButton('catDistritos');" class="small-box-footer">Mas info <i class="fa fa-arrow-circle-right"></i></a>
      </div>
    </div>
</section>

<!-- dashboard.js -->
<script src="pages/global/dashboard/script.js"></script>

<script>
  $(document).ready(function(){ appDashBoard(); });
</script>
