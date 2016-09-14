/**
* Created with OlaAPP.
* User: yedeveloper
* Date: 2015-08-20
* Time: 02:18 AM
* To change this template use Tools | Templates.
*/

function Contenido(argument){
    $('.cols').css('display','none');
    $('#'+argument).css('display','block');
    if(argument == "historial"){
        Historial();
    }
}
 /*Esta funcion permite cargar los contenidos a mostrar*/
    /**/
    /**/
    function dom(argument){
        return document.getElementById(argument);
    } 
function verPass(){
    var verpassword=$('#verpass').val();
    if(verpassword == 0){
        document.getElementById('password').type="text";
        document.getElementById('verpass').value="1";
        $('#ocultarPassD').html('<i class="material-icons  iconIn prefix " onclick="verPass()" style="color:#ADACB2"> &#xE8F5;</i>');
    }else{
        document.getElementById('password').type="password";
        document.getElementById('verpass').value="0";
        $('#ocultarPassD').html('<i class="material-icons  iconIn prefix " onclick="verPass()" style="color:#ADACB2"> &#xE8F4;</i>');
    }
}
function verPassDos(){
    var verpassword=$('#verpass').val();
    if(verpassword == 0){
        document.getElementById('pass').type="text";
        document.getElementById('verpass').value="1";
        $('#ocultarPass').html('<i class="material-icons  iconIn prefix " onclick="verPassDos()" style="color:#ADACB2"> &#xE8F5;</i>');
    }else{
        document.getElementById('pass').type="password";
        document.getElementById('verpass').value="0";
        $('#ocultarPass').html('<i class="material-icons  iconIn prefix " onclick="verPassDos()" style="color:#ADACB2"> &#xE8F4;</i>');
    }
}
function TelefonoContestado(){
  /*var argument = "telefono_contestado";
  crossDomain : true,
     $.get(argument+".html").done(
            function(data){
                $(dom('telefono-contestado')).html(data);
            });*/
}

function CerrarSession(){
  $.post('https://app.emsivoz.co/Sotfphone/php/controlls/ctrApp_updStateTel.php',{'id':localStorage.getItem('sft_session'),'state':'OFF'},function(data){
    console.log(data)
    localStorage.clear();
    $(location).attr('href',"index.html");
  });
  }
function ContenidoPrincipal(argument){ 
    $('#salir').val(1);
    $('#barraGD').html('');
    $('#barraD').html('');
    $('#llamar-contact').val(0);
    $('#btn-ll').html('<div style="width:100%" onclick="ContenidoPrincipal(\'llamar\')" > <img src="img/btn-llam.png" class="img-btn" style="width:100% !important;margin-right:3px "></div>');
    document.addEventListener("deviceready", onDeviceReady, false);
    crossDomain : true,
     $.get(argument+".html").done(
            function(data){
                $(dom('micont')).html(data);
                document.addEventListener("deviceready", onDeviceReady, false);
                $('#nav').css('position','fixed');
                $('#nav').css('top','0');
                $('#btn-atras').css('display','inline-block');
                $('.psl').removeClass('col');
                $('.psl').removeClass('s3');
                $('.psl').addClass('c');
                $('.img-btn').css('width','90%');
            });
}

function FiltrarIndicativo(){
  var pais=$('#pais').val();
  console.log(pais);
  $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos.php',{'pais':pais},function(data){
    console.log(data);
     var print=JSON.parse(data);
     var tabla='<table  class=" bordered centered" id="tab"><thead><tr><th style="font-size:20px">Destino</th><th style="font-size:20px">Indicativo</th></tr></thead>';
     for (var i = 0; i < print.length;i++){
          var img='<div class="col offset-s2 s8"><img src="https://www.emsivoz.'+localStorage.getItem('sft_server')+'/img/banderas-tarifas/'+print[i]['bandera']+'" style="width:100% !important;" class="circle"></div><br>';
          var td='<tbody><tr><td style="font-size:20px">'+print[i]['nombre']+'</td><td style="font-size:20px">'+print[i]['prefix']+'</td></tr></tbody>';
     }
     $('#rta').html(tabla+td+'</table><br>'+img);
  });
}

function FiltrarTarifa(){
  var pais=$('#pais').val();
  console.log(pais);
  $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_tarifas_todospaises.php',{'pais':pais},function(data){
    console.log(data);
     var print=JSON.parse(data);
     var td="";
     var tabla='<br><table class=" bordered centered" id="tab"><thead><tr><th style="font-size:20px">Destino</th><th style="font-size:20px">Tarifa</th></tr></thead><tbody>';
     var img='<br><br><div class="col offset-s2 s8"><img src="https://www.emsivoz.'+localStorage.getItem('sft_server')+'/img/banderas-tarifas/'+print[0]['bandera']+'" style="width:100% !important;" class="circle"></div><br>';
     for (var i = 0; i < print.length;i++){
          if(localStorage.getItem('sft_moneda') == "$"){
            var valor= localStorage.getItem('sft_moneda')+print[i]['precio'];
          }else{
            var valor= print[i]['precio'] + " "+ localStorage.getItem('sft_moneda');
          }
        td = td+'<tr><td style="font-size:20px">'+print[i]['nombre']+'</td><td style="font-size:20px">'+valor+'</td></tr>';
     }
     $('#rta').html(img+tabla+td+'</tbody></table>');
  });
}

  function loadIndi(){
 $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_paises.php',function(data){
          if(data != '0'){
            var print=data.split("+");
                  var option = "";
                  var sum=print.length - 1;
                  var select='<br><br><div class="input-field  input"  style="display:block;"><select style="display:block;font-size:19px" onchange="FiltrarIndicativo()" name="pais" class=""  id="pais" > <option value="0">Selecciona el Pais</option>';
                   for (var i = 0; i < print.length;i=i+2){
                      if(i != sum){
                        option=option+'<option value="'+print[i]+'">'+print[i+1]+'</option>';
                      }
                   }
                   $('#pol').html(select+option+'</select></div>');
          }else{
            $('#indi').html('no hay ningun pais');
          }
        });
}
function loadIndiLlamar(){
  $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_paises_banderas.php',function(data){
          if(data != '0'){
            console.log(data);
            var print=data.split("+");
                  var option = "";
                  var sum=print.length - 1;
                  var select='<div class="input-field  input"  style="display:block;"><select style="display:block;font-size:17px;" onchange="FiltrarPrecioLlamar()" name="pais_ll" class=""  id="pais_ll" > <option value="0">Selecciona el Pais</option>';
                   for (var i = 0; i < print.length;i=i+3){
                    if(i != sum){
                      option=option+'<option value="'+print[i]+'">'+print[i+1]+'</option>';
                    }
                   }
                   $('#paises').html(select+option+'</select></div>');
          }else{
            $('#indi').html('no hay ningun pais');
          }
        });
}

function FiltrarPrecioLlamar(){
  if(localStorage.getItem('sft_server') == 'co'){
    g = 42;
  }

  var pais = $('#pais_ll').val();
  $('#modal8').closeModal();
  console.log(pais);
  esta = pais;
  if(pais == 0){
      $('#number').html('');
      $('#connect').html('<a class="btn-floating blue"> <i class="material-icons">&#xE8B4;</i></a>');
  }else{
      console.log(pais);
    $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos.php',{'pais':pais},function(data){
     //$('#connect').html('<a class="btn-floating blue modal-trigger " href="#modal8"> <i class="material-icons">&#xE8B4;</i></a>');
      console.log(data);
       var print=JSON.parse(data);
       var imgBTn = '<img src="https://www.emsivoz.'+localStorage.getItem('sft_server')+'/img/banderas-tarifas/'+print[0]['bandera']+'" style="width: 35px;height: 35px;" alt="" class="circle">';
       var imprim='';
       for (var i = 0; i < print.length;i++){
           imprim=imprim + print[i]['prefix'];
         }
        console.log(esta);
         if (esta != g) {
            $('#numero-llam').val(imprim);
            var h = "";
             for ( i = 0; i < imprim.length; i++) {
                h = h+ imprim[i];
                  if(i == 1){
                    h= h + " ";
                  }
                  
                  if (i == (parseInt(imprim.length)- 1 )) {
                    h = h + " ";
                  }
             } 
            $('#number').html(h);
         }else{

             $('#number').html('');
             $('#numero-llam').val('');
         }
         var pais=imprim;
         var indi,precio;
              $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos_pais.php',{'pais':pais},function(data){
              console.log(data);
                if(data != 0){
                  var print=JSON.parse(data);
                  nombre=print[0]['nombre'];
                      if(print[0]['precio'] == print[1]['precio']){
                                if(localStorage.getItem('sft_moneda') == "$"){
                                  valor= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                }else{
                                  valor= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                }
                                precio='<span style="color:#ADACB2"> '+valor+' Min </span>';
                              }else{
                                if(localStorage.getItem('sft_moneda') == "$"){
                                  valor= localStorage.getItem('sft_moneda')+print[1]['precio'];
                                  valor2= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                }else{
                                  valor= print[1]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                  valor2= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                }
                                 precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#00457A;font-size:14px">Hoy</span><span style="color:#00457A"> '+valor2+' Min </span>';
                              }
                  console.log(nombre+' valor min. $'+precio);
                  $('#btn-borr').html('<h5 id="no-tap-delayd" class="html5logo material-icons right" style="color:#ADACB2;margin-top:12px;font-size:32px;">&#xE14A;</h5>');
                   $('#connect').html(imgBTn + '<span class="conPais">'+nombre+'</span>'+precio);
                }
              });
    });
  }
}
function Colombia(){
  if(localStorage.getItem('sft_server') == 'co'){
    indi = '0057';
    g='0057';
  }

   au = 4;
   console.log(indi);
    $('#btn-borr').html('<h5 class="material-icons right" style="color:#ADACB2;margin-top:12px;font-size:32px;" >&#xE14A;</h5>');
        
         var indi,precio,nombre;
              $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos_pais.php',{'pais':indi},function(data){
               if (indi != g) {
                var numero=indi;
                $('#numero-llam').val(numero);
                var h = "";
                  for ( i = 0; i < numero.length; i++) {
                                      h = h+ numero[i];
                                      if(i == 1){
                                          h= h + " ";
                                          sum = $('#numero-llam').val().length + au;
                                      }
                                     
                                      if (i == (parseInt(numero.length)- 1 )) {
                                          h = h + " ";
                                          sum=$('#numero-llam').val().length + au;
                                      }
                                   } 
                  $('#number').html(h);
               }
              console.log(data);
                if(data != 0){
                  var print=JSON.parse(data);
                   var imgBTn = '<img src="https://www.emsivoz.'+localStorage.getItem('sft_server')+'/img/banderas-tarifas/'+print[0]['bandera']+'" style="width: 35px;height: 35px;" alt="" class="circle">';
                  nombre=print[0]['nombre'];
                    if(print[0]['precio'] == print[1]['precio']){
                                if(localStorage.getItem('sft_moneda') == "$"){
                                  valor= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                }else{
                                  valor= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                }
                                precio='<span style="color:#ADACB2"> '+valor+' Min </span>';
                              }else{
                                if(localStorage.getItem('sft_moneda') == "$"){
                                  valor= localStorage.getItem('sft_moneda')+print[1]['precio'];
                                  valor2= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                }else{
                                  valor= print[1]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                  valor2= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                }
                                 precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#00457A;font-size:14px">Hoy</span><span style="color:#00457A"> '+valor2+' Min </span>';
                              }
                  console.log(nombre+' valor min. $'+precio);
                   $('#connect').html(imgBTn+'<span class="conPais">'+nombre+'</span>'+precio);
                }
              });
}
function OpenMod(){
   $('#modal8').openModal();
}
function loadTarif(){
  $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_paises.php',function(data){
          if(data != '0'){
            var print=data.split("+");
                  var option = "";
                  var sum=print.length - 1;
                  var select='<br><br><div class="input-field input " style="display:block;"><select  onchange="FiltrarTarifa()" name="pais"  id="pais" style="display:block;font-size:19px" > <option value="0">Selecciona el pais</option>';
                   for (var i = 0; i < print.length;i=i+2){
                    if(i != sum){
                      option=option+'<option value="'+print[i]+'">'+print[i+1]+'</option>';
                    }
                   }
                   $('#pol').html(select+option+'</select></div>');
          }else{
            $('#indi').html('no hay ningun pais');
          }
        });
}



function ValorLlamada(numero){
  var num  = "";
  var imd  = false;
  var bandera,precio,nombre;
  for (var i = 0; i < numero.length; i++) {
    num = num + numero[i];
    if (num.length >= 4){
        $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos_pais.php',{'pais':num},function(data){
          console.log(data);
            if(data != 0){   
                imd = true;
                console.log("se cambio");         
                var print=JSON.parse(data);
                nombre=print[0]['nombre'];
                  if(print[0]['precio'] == print[1]['precio']){
                      if(localStorage.getItem('sft_moneda') == "$"){
                        valor= localStorage.getItem('sft_moneda')+print[0]['precio'];
                      }else{
                        valor= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                      }
                      precio='<span style="color:#ADACB2"> '+valor+' Min </span>';
                  }else{
                      if(localStorage.getItem('sft_moneda') == "$"){
                        valor= localStorage.getItem('sft_moneda')+print[1]['precio'];
                        valor2= localStorage.getItem('sft_moneda')+print[0]['precio'];
                      }else{
                        valor= print[1]['precio'] + " "+ localStorage.getItem('sft_moneda');
                        valor2= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                      }
                      precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#00457A;font-size:14px">Hoy</span><span style="color:#00457A"> '+valor2+' Min </span>';
                  }
                  bandera = print[0]['bandera'];
          }
        });
    }
  }
}
function ShowSaldo(){
  console.log(localStorage.getItem('sft_sessioncard')+" id cc_card")
  localStorage.setItem('sft_name', localStorage.getItem('sft_name').split(" ",1) );
  //obtenemos el credito o saldo del usuario
                        input=localStorage.getItem('sft_credit');

                        if(localStorage.getItem('sft_moneda') == "$"){
                            var num = input.replace(/\./g,'');
                              if(!isNaN(num)){
                              num = num.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g,'$1.');
                              num = num.split('').reverse().join('').replace(/^[\.]/,'');
                              
                            }
                          }else{
                            num = input;
                          }
                          if(localStorage.getItem('sft_moneda') == "$"){
                           var dj= localStorage.getItem('sft_moneda')+" <span id='saldo_good'>"+num+"</span>";
                          }else{
                           var dj= " <span id='saldo_good'>"+num+ " " +localStorage.getItem('sft_moneda')+"</span>";
                          }
                     document.getElementById('goodD').innerHTML= "Bienvenido "+localStorage.getItem('sft_name')+"! Saldo: "+dj;
                    var miId=localStorage.getItem('sft_sessioncard');
                    var micred=localStorage.getItem('sft_credit');
                    var param={'credit':miId};
                    console.log(localStorage.getItem('sft_name')+"! - Saldo: $"+localStorage.getItem('sft_credit'));
                      $.ajax({
                         data:param,
                          type:'POST',
                          url:'https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_getcredit.php',
                           
                          success:function(data){

                            if(data == "En estos momentos estamos realizando cambios "){
                                document.getElementById('goodD').innerHTML= "En estos momentos estamos realizando cambios";
                                 $('#palabraD').css('background','#F2A914');
                            }else{
                              if(data == "Vuelve a Registrarte.."){
                                 document.getElementById('goodD').innerHTML= "Vuelve a Registrarte";
                                 $('#palabraD').css('background','#F2A914');
                              }else{
                                  console.log(data);
                                if(data != micred){
                                 localStorage.setItem('sft_credit',data);
                                  input=localStorage.getItem('sft_credit');
                                   if(localStorage.getItem('sft_moneda') == "$"){ 
                                      var num = input.replace(/\./g,'');
                                        if(!isNaN(num)){
                                        num = num.toString().split('').reverse().join('').replace(/(?=\d*\.?)(\d{3})/g,'$1.');
                                        num = num.split('').reverse().join('').replace(/^[\.]/,'');
                                        
                                      }
                                    }else{
                                      num = input;
                                    }
                                if(input <= 500 && localStorage.getItem('sft_moneda') == "$"){
                                  $('#palabraD').css('background','#ED565A');
                                  $('#goodD').css('color','#fff');
                               }else{
                                  $('#palabraD').css('background','#00457A');
                                  $('#goodD').css('color','#fff');
                               }
                                if(localStorage.getItem('sft_moneda') == "$"){
                                   var dj= localStorage.getItem('sft_moneda')+" <span id='saldo_good'>"+num+"</span>";
                                  }else{
                                   var dj= " <span id='saldo_good'>"+num+ " " +localStorage.getItem('sft_moneda')+"</span>";
                                  }
                                   document.getElementById('goodD').innerHTML= "Bienvenido "+localStorage.getItem('sft_name')+"! Saldo: "+dj ;
                                }
                              }
                              
                          }
                          
                      }
                    });
}




