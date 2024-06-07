<?php
  include_once('includes/sess_verifica.php');
  include_once('includes/web_config.php');
  if(isset($_SESSION['usr_ID'])) {
    include_once('includes/sess_perfiluser.php');
?>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="Expires" content="0">
  <meta http-equiv="Last-Modified" content="0">
  <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
  <meta http-equiv="Pragma" content="no-cache">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <title>sistema de Gestion de Predios [Iglesia Adventista]</title>
  <link rel="shortcut icon" href="favicon.png" />
  <link rel="icon" type="image/vnd.microsoft.icon" href="favicon.png" />
  <link rel="stylesheet" href="./libs/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="./libs/font-awesome/4.7.0/css/all.min.css">
  <link rel="stylesheet" href="./app/css/fonts.css" />
  <link rel="stylesheet" href="./app/css/interfaz.css" />
  <script src="./libs/jquery/jquery-3.6.0.min.js"></script>
  <script src="./libs/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="./app/js/interfaz/adminLTE.min.js"></script>
  <script src="./app/js/interfaz/funciones.js"></script>
  <script src="./app/js/interfaz/interfaz.js"></script>
</head>
<body class="hold-transition skin-blue sidebar-mini">
  <div class="wrapper">
    <header class="main-header">
      <!-- Logo -->
      <a href="interfaz.php" class="logo" style="background:#1A2226;">
        <!-- mini logo for sidebar mini 50x50 pixels -->
        <span class="logo-mini"><b>P</b>rd</span>
        <!-- logo for regular state and mobile devices -->
        <span class="logo-lg"><b>PRE</b>dial</span>
      </a>
      <!-- Header Navbar: style can be found in header.less -->
      <nav class="navbar navbar-static-top">
        <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
          <span class="sr-only">Toggle navigation</span>
          <span class="icon-bar"></span>
        </a>
        <div class="navbar-custom-menu">
          <ul class="nav navbar-nav">
            <!-- Notificaciones: style can be found in dropdown.less -->
            <li class="dropdown notifications-menu">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <i class="fa fa-bell-o"></i>
                <span id="lblNotifiCount1" class="label label-warning NotifiCount"></span>
              </a>
              <ul class="dropdown-menu">
                <li class="header">Tienes <span id="lblNotifiCount2" class="NotifiCount"></span> notificaciones</li>
                <li>
                  <ul class="menu" id="appInterfazNotificaciones">
                  </ul>
                </li>
                <li class="footer"><a href="javascript:appSubmitButton('notificaciones');">Ver todas...</a></li>
              </ul>
            </li>
            <!-- Menu Usuario: style can be found in dropdown.less -->
            <li class="dropdown user user-menu">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                <img id="ifaz_barra_imagen" src="" class="user-image" alt="Usuario">
                <span id="ifaz_barra_nombrecorto" class="hidden-xs"></span>
              </a>
              <ul class="dropdown-menu">
                <!-- User image -->
                <li class="user-header">
                  <img id="ifaz_perfil_imagen" src="" class="img-circle" alt="User Image">
                  <p>
                    <span id="ifaz_perfil_nombrecorto"></span>
                    <small id="ifaz_perfil_cargo"></small>
                  </p>
                </li>
                <!-- Menu Footer-->
                <li class="user-footer">
                  <div class="pull-left">
                    <a href="javascript:appSubmitButton('profile');" class="btn btn-default btn-flat">Perfil</a>
                  </div>
                  <div class="pull-right">
                    <a href="javascript:appSubmitButton('logout');" class="btn btn-default btn-flat">Salir</a>
                  </div>
                </li>
              </ul>
            </li>
          </ul>
        </div>
      </nav>
    </header>
  <!-- =========================== MENU ============================== -->
<?php
  $menuDashboard = "";
  $menuCat = "";
  $menuCatMaestro = "";
  $menuCatUbigeo = "";
  $menuCatMisiones = "";
  $menuCatDistritos = "";
  $menuCatUsuarios = "";
  $menuCatPredios = "";
  $menuRpt = "";
  $menuRptResMision = "";
  $menuRptAdquisicion = "";
  $menuRptFisco = "";
  $menuRptRegPublicos = "";
  $menuRptPredios = "";

  $appPage = "pages/global/dashboard/page.php";
  if(isset($_GET["page"])){
    switch ($_GET["page"]) {
      case "profile": $appPage = "pages/global/profile/profile.php"; break;
      case "catMaestro" :   $menuCat = 'active menu-open'; $menuCatMaestro = 'class="active"'; $appPage = "pages/catalogos/maestro/page.php"; break;
      case "catUbigeo" :    $menuCat = 'active menu-open'; $menuCatUbigeo = 'class="active"'; $appPage = "pages/catalogos/ubigeo/page.php"; break;
      case "catMisiones" :  $menuCat = 'active menu-open'; $menuCatMisiones = 'class="active"'; $appPage = "pages/catalogos/misiones/page.php"; break;
      case "catDistritos" : $menuCat = 'active menu-open'; $menuCatDistritos = 'class="active"'; $appPage = "pages/catalogos/distritos/page.php"; break;
      case "catUsuarios" :  $menuCat = 'active menu-open'; $menuCatUsuarios = 'class="active"'; $appPage = "pages/catalogos/usuarios/page.php"; break;
      case "catPredios" :   $menuCat = 'active menu-open'; $menuCatPredios = 'class="active"'; $appPage = "pages/catalogos/predios/page.php"; break;
      case "rptResMision" : $menuRpt = 'active menu-open'; $menuRptResMision = 'class="active"'; $appPage = "pages/reportes/mision/page.php"; break;
      case "rptPredios" :   $menuRpt = 'active menu-open'; $menuRptPredios = 'class="active"'; $appPage = "pages/reportes/predios/page.php"; break;
    }
  } else{
    $menuDashboard = 'class="active"';
  }
?>

    <aside class="main-sidebar">
      <!-- MENU PRINCIPAL -->
      <section class="sidebar">
        <div class="user-panel" style="background:#1A2226;display:none;">
          <div class="pull-left image">
            <img id="ifaz_menu_imagen" src="" class="img-circle" alt="foto de usuario">
          </div>
          <div class="pull-left info">
            <p id="ifaz_menu_nombrecorto"></p>
            <small id="ifaz_menu_login" style="color:#859E9E;position:relative;top:-5px;"></small>
          </div>
        </div>
        <ul class="sidebar-menu" data-widget="tree">
          <li <?php echo($menuDashboard);?>>
            <a href="interfaz.php"><i class="fa fa-dashboard"></i> <span>Dashboard</span></a>
          </li>
          <li class="treeview <?php echo($menuCat);?>">
            <a href="#">
              <i class="fa fa-gears"></i>
              <span>Catalogos</span>
              <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
            </a>
            <ul class="treeview-menu">
              <?php
              if($_SESSION["usr_perfil"][0]["sel"]==1){ echo('<li '.$menuCatUbigeo.'><a href="javascript:appSubmitButton(\'catUbigeo\');"><i class="fa fa-wrench"></i> <span> Ubigeo</span></a></li>');}
              if($_SESSION["usr_perfil"][1]["sel"]==1){ echo('<li '.$menuCatMaestro.'><a href="javascript:appSubmitButton(\'catMaestro\');"><i class="fa fa-wrench"></i> <span> Maestro</span></a></li>');}
              if($_SESSION["usr_perfil"][3]["sel"]==1){ echo('<li '.$menuCatUsuarios.'><a href="javascript:appSubmitButton(\'catUsuarios\');"><i class="fa fa-wrench"></i> <span> Usuarios</span></a></li>');}
              if($_SESSION["usr_perfil"][2]["sel"]==1){ echo('<li '.$menuCatMisiones.'><a href="javascript:appSubmitButton(\'catMisiones\');"><i class="fa fa-wrench"></i> <span> Misiones</span></a></li>');}
              if($_SESSION["usr_perfil"][4]["sel"]==1){ echo('<li '.$menuCatDistritos.'><a href="javascript:appSubmitButton(\'catDistritos\');"><i class="fa fa-wrench"></i> <span> Dist. Misio.</span></a></li>');}
              if($_SESSION["usr_perfil"][5]["sel"]==1){ echo('<li '.$menuCatPredios.'><a href="javascript:appSubmitButton(\'catPredios\');"><i class="fa fa-wrench"></i> <span> Predios</span></a></li>');}
              ?>
            </ul>
          </li>
          <li class="treeview <?php echo($menuRpt);?>">
            <a href="#">
              <i class="fa fa-gears"></i>
              <span>Reportes</span>
              <span class="pull-right-container"><i class="fa fa-angle-left pull-right"></i></span>
            </a>
            <ul class="treeview-menu">
              <li <?php echo($menuRptResMision);?>><a href="javascript:appSubmitButton('rptResMision');"><i class="fa fa-circle-o"></i> <span>Resumen de Mision</span></a></li>
              <li <?php echo($menuRptAdquisicion);?>><a href="javascript:appSubmitButton('rptAdquisicion');"><i class="fa fa-circle-o"></i> <span>Reporte de Adquicisiones</span></a></li>
              <li <?php echo($menuRptFisco);?>><a href="javascript:appSubmitButton('rptFisco');"><i class="fa fa-circle-o"></i> <span>Reporte del Fisco</span></a></li>
              <li <?php echo($menuRptRegPublicos);?>><a href="javascript:appSubmitButton('rptRegPublicos');"><i class="fa fa-circle-o"></i> <span>Reporte de RR.PP.</span></a></li>
              <li <?php echo($menuRptPredios);?>><a href="javascript:appSubmitButton('rptPredios');"><i class="fa fa-circle-o"></i> <span>Reporte de Predios</span></a></li>
            </ul>
          </li>
        </ul>
      </section>
    </aside>
    <!-- ========================= CONTENIDO  ====================== -->
    <div class="content-wrapper">
      <?php include_once($appPage); ?>
    </div>
  </div>
</body>
</html>
<?php
  } else {
    header('location:./');
  }
?>
