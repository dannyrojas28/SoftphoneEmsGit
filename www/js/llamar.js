                var mySip;
                var interval;
                var options;
                var rf= false;
                var sum=0;
                var bandera = "";
                var nombre = "";
                var au= 0;
                function Numero(num){
                  var numf = $('#numero-llam').val();
                  console.log(au)
                  if(numf.length == 0 ){
                    if(num == 3){
                      au = 4;
                      sum = 6;
                    }else{
                      sum = 7;
                      au = 3;
                    }
                  }
                  $('#btn-borr').html('<h5 id="no-tap-delayd" class="html5logo material-icons right" style="color:#ADACB2;margin-top:12px;font-size:32px;" >&#xE14A;</h5>');
                 
                  if($('#number').html().length <= 11){
                    $('#number').css('font-size','34px');
                  }else{
                    if($('#number').html().length <= 16){
                      $('#number').css('font-size','24px');
                    }else{
                      if($('#number').html().length <= 20){
                        $('#number').css('font-size','20px');
                      }else{
                        $('#number').css('font-size','16px');
                      }
                    }
                  }
                  

                  if($('#numero-llam').val() == '08' || $('#numero-llam').val() == '00'  || $('#numero-llam').val() == '01'  ){
                     $('#number').html($('#number').html() + " ");
                     sum=5;
                  }else{
                    if($('#numero-llam').val() == '001'){
                       $('#number').html($('#number').html() + " ");
                       sum=6;
                    }
                  }

                  if ($('#numero-llam').val() == '037' || $('#numero-llam').val() == '01'){
                    bandera = "";
                  }
                  $('#numero-llam').val($('#numero-llam').val() + num);

                  if ($('#number').html().length == 3 && $('#number').html() != '08 ' && $('#number').html() != '00 '){
                      $('#number').html($('#number').html() + " "+num);
                  }else{
                        $('#number').html($('#number').html() + num);
                  }
                  
                  var numero=$('#numero-llam').val();
                  var pais=numero;
                  var indi,precio;
                  console.log("este es el numero que "+ $('#numero-llam').val());
                   if($('#numero-llam').val().length >= 3   ){
                 /*   $.post('https://app.emsivoz.'+localStorage.getItem('server')+'/funciones/prod/programadas/indicativos_pais.php',{'pais':pais},function(data){
                      console.log(data);
                      if(data != 0){  
                        
                      }else{
                        Colombia();
                      }
                    });*/
                  console.log("pasate tio");
console.log(nombre + " " +bandera)
                     $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos_pais.php',{'pais':pais,'nombre':nombre,'bandera':bandera},function(data){
                      console.log(data);
                        if(data != 0){   
                          rf=true;                         
                          var print=JSON.parse(data);
                          var h="";           
                          $('#number').html($('#number').html() + " ");
                          sum=$('#numero-llam').val().length + au;
                          nombre=print[0]['nombre'];
                          bandera = print[0]['bandera'];
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
                                 precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#89B137;font-size:14px">Hoy</span><span style="color:#89B137"> '+valor2+' Min </span>';
                              }
                          console.log(nombre+' valor min. $'+precio);
                             imgBtn = '<img src="https://www.emsivoz.co/img/banderas-tarifas/'+bandera+'" style="width: 35px;height: 35px;" alt="" class="circle">';
                             $('#connect').html(imgBtn + '<span class="conPais">'+nombre+'</span>'+precio);
                        }else{
                          rf=false;
                        }
                        if($('#numero-llam').val().length == sum){
                         $('#number').html( $('#number').html() + " ");
                         sum=$('#numero-llam').val().length + au;
                       }
                   });
                  }else{
                    //  Colombia();
                    if(localStorage.getItem('sft_server') == 'co'){
                      Colombia();
                    }
                  }
                  console.log("el numero donde se salta es "+sum);
                }

                function BorrarNumero(){

                    if(sum > ($('#numero-llam').val().length + 1)){
                      sum = sum - 2;
                    }
                    var num= $('#number').html();
                    var numero="";
                    var numD= $('#numero-llam').val();
                    var numeroD="";
                      $p=1;
                      console.log(num.length);
                      for(var i =0;i < num.length - $p;i++){
                        console.log(i);
                          if ( i == num.length - 2) {
                              if(num[i] != " "){
                                if(num[i + 1 ] != " "){
                                  numero=numero+ num[i];
                                }
                              }
                          }else{
                             numero=numero+ num[i];
                          }
                      }
                    
                      for(var i =0;i < numD.length - 1;i++){
                          numeroD=numeroD+ numD[i];
                      }

                  $('#number').html(numero);
                  $('#numero-llam').val(numeroD);

                  if ($('#number').html().length == 0 ) {
                    $('#btn-borr').html('<h5 id="no-tap-delayd" class="html5logo material-icons right" style="color:transparent;margin-top:12px;font-size:32px;" >&#xE14A;</h5>');
                    //Colombia();
                    sum = 0;
                    au = 0;
                   bandera  = "";
                    if(localStorage.getItem('sft_server') == 'co'){
                      Colombia();
                    }
                  }
                  if($('#number').html().length <= 12){
                    $('#number').css('font-size','34px');
                  }else{
                    if($('#number').html().length <= 17){
                      $('#number').css('font-size','24px');
                    }else{
                       if($('#number').html().length <= 21){
                        $('#number').css('font-size','20px');
                        }else{
                          $('#number').css('font-size','16px');
                        }
                    }
                  }

                  if($('#numero-llam').val().length < 4){
                         // Colombia();
                    }
                  var pais=numeroD;
                  var indi,precio,nombre;
                    console.log($('#number').html());
                     $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos_pais.php',{'pais':pais},function(data){
                      console.log(data);
                        if(data != 0){
                          var print=JSON.parse(data);
                           var h="";           
                          $('#number').html($('#number').html() + " ");
                          sum=$('#numero-llam').val().length + au;
                          nombre=print[0]['nombre'];
                          bandera = print[0]['bandera'];
                              if(print[0]['precio'] == print[1]['precio']){
                                if(localStorage.getItem('sft_moneda') == "$"){
                                  valor= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                }else{
                                  valor= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                }
                                precio='<span style="color:#ADACB2"> '+valor+' Min </span>';
                              }else{
                                if(localStorage.getItem('moneda') == "$"){
                                  valor= localStorage.getItem('sft_moneda')+print[1]['precio'];
                                  valor2= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                }else{
                                  valor= print[1]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                  valor2= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                }
                                 precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#89B137;font-size:14px">Hoy</span><span style="color:#89B137"> '+valor2+' Min </span>';
                              }
                          console.log(nombre+' valor min. $'+precio);
                             imgBtn = '<img src="https://www.emsivoz.co/img/banderas-tarifas/'+bandera+'" style="width: 35px;height: 35px;" alt="" class="circle">';
                             $('#connect').html(imgBtn+' <span class="conPais">'+nombre+'</span>'+precio);
                      }
                   });

                     
                }
                
                function LlamarOtroMedio(numero){ 
                  console.log("este es el numero purito "+numero);
                  var espacio_blanco = $('#espacio_blanco').val();
                  var numeroenvi="";
                  for (var i = 0; i < numero.length; i++) {
                    if(numero[i] != espacio_blanco || numero[i] != " "){
                        for (var j = 0; j <= 9;j++) {
                                if(numero[i] == j && numero[i] != espacio_blanco && numero[i] != " "){
                                    numeroenvi = numeroenvi + numero[i];
                                }
                        }
                       if(i == 2){
                          if(numeroenvi == '57'){
                            numeroenvi="";
                            console.log('sew cambio el numero');
                          }
                        }
                    }
                  }
                  numero = numero.replace(espacio_blanco,'');
                  numero = numero.replace(' ','');
                  $('#number').html(numero);
                  $('#numero-llam').val(numeroenvi)
                  console.log("EL NUMERO QUE SE ENVIO AL SERVIDOR ES "+numeroenvi)
                  Llamar();
                }

                
                function Llamar(){
                  if (localStorage.getItem('sft_llamada') == null) {
                    navigator.proximity.enableSensor();
                   
                    setInterval(function(){
                      navigator.proximity.getProximityState(onSuccessProx);
                    }, 1000);
                    var num= $('#numero-llam').val();
                    var numeroenvi="";
                    for (var i = 0; i < num.length; i++) {
                        for (var j = 0; j <= 9;j++) {
                            if(num[i] != " "){
                                if(num[i] == j){
                                    numeroenvi = numeroenvi + num[i];
                                }
                            }
                        }
                       if(i == 2){
                          if(numeroenvi == '57'){
                            numeroenvi="";
                            console.log('sew cambio el numero');
                          }
                        }
                       
                    }
                    if(numeroenvi.length >= 3){
                      ValorLlamada(numeroenvi);
                      console.log(numeroenvi);
                     onCall(numeroenvi);
                     localStorage.setItem('sft_llamada',numeroenvi);
                    }

                    if(numeroenvi.length == 0){
                      GetUltimoNumber();
                    }
                  }

                }

                function Colgar(){

                    //var $toastContent = $('<span>Llamada Finalizada</span>');
                   // Materialize.toast($toastContent, 3000);
                   
                    clearInterval(interval);
                    localStorage.removeItem('sft_llamada');
                    localStorage.removeItem('sft_seg');
                    localStorage.removeItem('sft_min');
                    localStorage.removeItem('sft_hor');
                    $('#telefono-contestado').css('display','none');
                    $('#colgado').val('true');
                    onTerminateCall();
                    var argument=$('#page').val();
                    if(argument != "index"){
                      ContenidoPrincipal(argument);
                    }else{
                      $(location).attr('href',argument+".html");
                    }
                }
                function ActivarParlante(){
                    $('#speaker').html('<a class="btn-floating btn-large waves-effect waves-light"  style="background:#fff;border:1px solid #ADACB2;width:68px;height:68.5px;font-size:45px;" onclick="DescativarParlante()"> <i class="material-icons" style="color:#516AA3;font-size:45px;margin-top:5px" >&#xE050;</i> </a>');
                    $('#parlante_act').val('1');
                    onEnableSpeakerClick();
                }
                function DescativarParlante(){
                    $('#speaker').html('<a class="btn-floating btn-large waves-effect waves-light" style="background:#fff;border:1px solid #ADACB2;width:68px;height:68.5px;font-size:45px;" onclick="ActivarParlante()"> <i class="material-icons" style="color:#ADACB2;font-size:45px;margin-top:5px" >&#xE050;</i> </a>');
                      $('#parlante_act').val('0');
                      onDisableSpeakerClick();

                }
                function TecladoPequeno(){
                    $('#opciones').css('display','none');
                    $('#contacs').css('display','none');
                    $('#tecladopequeno').css('display','block');
                    $('#touchdtmf').html('<button class="btn-floating btn-large waves-effect waves-light" style="background:#fff;border:1px solid #ADACB2;width:68px;height:68.5px;font-size:45px;"  onclick="OcultarTeclado()">  <i class="material-icons" style="color:#516AA3;font-size:40px;" >&#xE0BC;</i></button>');
                }
                function OcultarTeclado(){
                    $('#opciones').css('display','block');
                    $('#tecladopequeno').css('display','none');
                    $('#contacs').css('display','none');
                    $('#colgar-di').css('display','block');
                    $('#touchdtmf').html('<button class="btn-floating btn-large waves-effect waves-light" style="background:#fff;border:1px solid #ADACB2;width:68px;height:68.5px;font-size:45px;" onclick="TecladoPequeno()">  <i class="material-icons" style="color:#ADACB2;font-size:40px;"  >&#xE0BC;</i></button>');
                }
                function Dtmf(num){
                    console.log(num);
                  $('#dtmf_key').val(num);
                   onSendDtmfClick();
                   $('#dtmf').html($('#dtmf').html() + num);
                }
                function callEstablished(){
                  if($('#call_esta').val() == 0){
                    console.log("se establecio callEstablished")
                    interval = setInterval(tiempoaa,1000);
                     $('#call_esta').val(23213);
                     console.log("dsjdhgajgdjhasg")
                  }
                }
                function tiempoaa(){
                      var colgado = $('#colgado').val();
                      console.log(colgado)
                      if(colgado == "false"){
                    console.log("se establecio tiempo")

                        var min = $('#minutos').val();
                        var seg = $('#segundos').val();
                        var hor = $('#horas').val();
                        var dddd = hor +':'+ min + ':'+ seg;
                        console.log(dddd);
                            if(seg == 59){
                                seg=00;
                                min=01+parseInt(min);
                                if(min < 10){
                                    min='0'+min;
                                  }
                            }else{
                                seg=01+parseInt(seg);
                            }
                            if(min == 59){
                                min=00;
                                hor=01+parseInt(hor);
                            }
                            
                          var string = "";
                          if(seg < 10){
                            seg='0'+seg;
                          }
                          
                          string += hor +':'+ min + ':'+ seg;
                          console.log(string);
                          $('#horas').val(hor);
                          $('#minutos').val(min);
                          $('#segundos').val(seg);
                          document.getElementById("time-llama").innerHTML = string;
                          localStorage.setItem('sft_seg',seg);
                          localStorage.setItem('sft_min',min);
                          localStorage.setItem('sft_hor',hor);
                      }else{
                          clearInterval(interval);
                      }
                }

                function callEnd(){
                   // var $toastContent = $('<span>Llamada Finalizada</span>');
                     //Materialize.toast($toastContent, 3000);
                   clearInterval(interval);
                    localStorage.removeItem('sft_llamada');
                    localStorage.removeItem('sft_seg');
                    localStorage.removeItem('sft_min');
                    localStorage.removeItem('sft_hor');
                    $('#colgado').val('true');
                    $('#telefono-contestado').css('display','none');
                    onTerminateCall();
                    var argument=$('#page').val();
                    if(argument != "index"){
                        ContenidoPrincipal(argument);
                    }else{
                        $(location).attr('href',argument+".html");
                      ContenidoPrincipal(argument);
                    }
                    
                }
                function Mute(){
                   //mySip.muteCall('on');
                }
                function Stop(){
                    $('#estados-llama').html('<a class="btn-floating btn-large waves-effect waves-light transparent" style="border:1px solid #fff">  <i class="material-icons" style="color:#fff;font-size:30px;" onclick="Listen()">&#xE037;</i></a>');
                    //mySip.stopListenCall();
                }
                function Listen(){
                   $('#estados-llama').html('<a class="btn-floating btn-large waves-effect waves-light transparent" style="border:1px solid #fff">  <i class="material-icons" style="color:#fff;font-size:30px;" onclick="Stop()">&#xE034;</i></a>');
                  // mySip.listenCall();
                }

                function Destin(){
                  $('#modal5').openModal();
                  
                }
                 function callRingingBack(){
                    $("#btncolllam").removeAttr("disabled");
                    $("#btncolllam").removeAttr("disabled");
                }
                function onSuccessProx(state) {
                      console.log('Proximity state: ' + (state ? 'near' : 'far'));
                };
                function ConctsHtml(){
                    $('#opciones').css('display','none');
                    $('#tecladopequeno').css('display','none');
                    $('#contacs').css('display','block');
                    $('#colgar-di').css('display','none');
                    $('#htCons').html($('#result').html());
                }
               function Contactos(){
               // join.initialize();
               //  pol.initialize();
                  TelefonoContestado();
                  navigator.proximity.disableSensor();
                  navigator.contacts.pickContact(function(contact){
                    var impri = "";
                        impri = '<center><i class="material-icons" style="font-size:60px;color:#ADACB2">&#xE853;</i><p style="font-size:19px">'+getName(contact)+'</p></center>';
                              
                        console.log(contact.phoneNumbers.length);
                           for(var j = 0; j < contact.phoneNumbers.length; j++) {
                              
                              var phone = contact.phoneNumbers[j].value;
                              impri = impri +'<div style="border-top:1px solid #ADACB2" class="col s12">'+
                                                 '<div class="col s10" >'+
                                                    '<p style="font-size:16px;margin-top:10px" onclick="LlamarOtroMedio(\''+phone+'\')" >'+phone+'</p>'+
                                                 '</div>'+
                                                '<div class="col s2">'+
                                                  '<a onclick="LlamarOtroMedio(\''+phone+'\')" class="secondary-content btn-floating btnllam" style="background:#89B137;margin-top:3px"><i class="material-icons"><i class="material-icons" style="color:#fff;font-size:24px;">&#xE0CD;</i></i></a>'+
                                                '</div>'+
                                            '</div>';
                           }
                        
                        $('#Contactos_lon').html(impri);
                        $('#modal9').openModal();
                    
                  },function(err){
                    if(err != 6){
                      alert('ERROR, No Hemos podido acceder a tus contactos: ' + err);
                    }
                  });
                }

                function getName(c) {
                  var name = c.displayName;
                  if(!name || name === "") {
                      if(c.name.formatted) return c.name.formatted;
                      if(c.name.givenName && c.name.familyName) return c.name.givenName +" "+c.name.familyName;
                      return "Nameless";
                  }
                  return name;
              }
              function GetUltimoNumber(){
                        var parametro={'session':localStorage.getItem('sft_session')};
                        $.ajax({
                            data:parametro,
                            type:"POST",
                            url:'https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_get_ultimo_numero.php',
                            success:function(data){
                            var print=JSON.parse(data);
                            var res = "";
                            if(print[0]['resul'] == "ok"){
                             for (var i = 0; i < print.length;i++){
                                num = print[i]['dnid'];
                                $('#number').html(num);
                                $('#numero-llam').val(num);
                                $('#btn-borr').html('<h5 id="no-tap-delayd" class="html5logo material-icons right" style="color:#ADACB2;margin-top:12px;font-size:32px;">&#xE14A;</h5>');
                                if($('#number').html().length <= 11){
                                  $('#number').css('font-size','34px');
                                }else{
                                  if($('#number').html().length <= 16){
                                    $('#number').css('font-size','24px');
                                  }else{
                                    if($('#number').html().length <= 20){
                                      $('#number').css('font-size','20px');
                                    }else{
                                      $('#number').css('font-size','16px');
                                    }
                                  }
                                }
                                var numeroD = print[i]['dnid'];
                                console.log("la destination de la llamada es"+print[i]['destination']);
                                var pais=print[i]['destination'];
                                var indi,precio,nombre;
                                  console.log($('#number').html());
                                   $.post('https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_indicativos_pais.php',{'pais': '00'+pais},function(data){
                                    console.log(data);
                                      if(data != "error"){
                                        var print=JSON.parse(data);
                                        var h="";
                                         for ( i = 0; i < numeroD.length; i++) {
                                          h = h+ numeroD[i];
                                          if(i == 2){
                                              h= h + " ";
                                          }
                                          if (i == (parseInt(numeroD.length)- 1 )) {
                                              h = h + " ";
                                          }
                                       }       

                                       $('#number').html(h); 
                                        var imgBtn ='<img src="https://www.emsivoz.co/img/banderas-tarifas/'+print[0]['bandera']+'" style="width: 35px;height: 35px;" alt="" class="circle">';
                                        nombre=print[0]['nombre'];
                                          if(print[0]['indi'] == 1){
                                            if(print[0]['precio'] == print[2]['precio']){
                                              if(localStorage.getItem('sft_moneda') == "$"){
                                                valor= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                              }else{
                                                valor= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                              }
                                              precio='<span style="color:#ADACB2"> '+valor+' Min </span>';
                                            }else{
                                              if(localStorage.getItem('sft_moneda') == "$"){
                                                valor= localStorage.getItem('sft_moneda')+print[2]['precio'];
                                                valor2= localStorage.getItem('sft_moneda')+print[0]['precio'];
                                              }else{
                                                valor= print[2]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                                valor2= print[0]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                              }
                                               precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#89B137;font-size:14px">Hoy</span><span style="color:#89B137"> '+valor2+' Min </span>';
                                            }
                                          }else{
                                            if(print[1]['precio'] == print[3]['precio']){
                                              if(localStorage.getItem('sft_moneda') == "$"){
                                                valor= localStorage.getItem('sft_moneda')+print[1]['precio'];
                                              }else{
                                                valor= print[1]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                              }
                                              precio='<span style="color:#ADACB2"> '+valor+' Min </span>';
                                            }else{
                                              if(localStorage.getItem('sft_moneda') == "$"){
                                                  valor= localStorage.getItem('sft_moneda')+print[3]['precio'];
                                                  valor2= localStorage.getItem('sft_moneda')+print[1]['precio'];
                                                }else{
                                                  valor= print[3]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                                  valor2= print[1]['precio'] + " "+ localStorage.getItem('sft_moneda');
                                                }
                                               precio='<span style="color:#ADACB2;font-size:14px"><del> '+valor+'</del> |</span><span style="color:#89B137;font-size:14px">Hoy</span><span style="color:#89B137"> '+valor2+' Min </span>';
                                            }
                                          }
                                        console.log(nombre+' valor min. $'+precio);
                                           $('#connect').html(imgBtn + '<span class="conPais">'+nombre+'</span>'+precio);
                                    }else{
                                      Colombia();
                                    }
                                 });
                             }
                            }
                            // NombreContact();
                                                         
                           }
                    });
              }
               function Historial(){
                   //cargar historial de llamadas
                    console.log(localStorage.getItem('htmlHistori') );
                    $('#historial').html(localStorage.getItem('htmlHistori'));
                    var parametro={'session':localStorage.getItem('sft_sessioncard')};
                    $.ajax({
                        data:parametro,
                        type:"POST",
                        url:'https://app.emsivoz.'+localStorage.getItem('sft_server')+'/Sotfphone/php/controlls/ctrApp_historial.php',
                        success:function(data){
                           var print=JSON.parse(data);
                           if(print[0]['resul'] == "ok"){
                             for (var i = 0; i < print.length; i++) {
                                  ko = print[i]['dnid'];
                                  fecha  = print[i]['start'];
                                  tiempo = print[i]['tiempo'];
                                  precio = print[i]['precio'];
                                  if(print[i]['tiempo'] != '00:00:00'){
                                      color="color:#89B137;";
                                      icon ="&#xE0B2;";
                                  }else{
                                      color="color:#ED565A;";
                                      icon ="&#xE0B4;";
                                  }
                                  if(localStorage.getItem('sft_moneda') == "$"){
                                      var valor= localStorage.getItem('sft_moneda')+precio;
                                  }else{
                                      var valor= precio + " "+ localStorage.getItem('sft_moneda');
                                  }
                                  num= '<span style="font-size:16px;font-weight:bold;">'+ko+'</span><br>';
                                  $("#historial").html($("#historial").html() + '<div class="col s12" style="background:#ecedef;margin-top:5px">'+
                                                        '<div class="col s3 center" >'+
                                                            '<i class="material-icons" style="font-size:34px;font-weight:bold;'+color+'">'+icon+'</i> '+
                                                            '<span style="font-size:20px;color:#ADACB2">'+fecha+'</span><br>'+
                                                            '<span style="color:#ADACB2">'+tiempo+'</span>'+  
                                                       '</div>'+
                                                        '<div class="col s7" style="margin-top:10px;color:#000">'+num+
                                                            '<span style="font-size:18px;font-weight:bold">'+valor+'</span>'+
                                                        '</div>'+
                                                        '<div class="col s2"> '+
                                                            '<a onclick="LlamarOtroMedio(\''+ko+'\')" class="secondary-content btn-floating right btnllam" style="background:#89B137;margin-top:13px;width:44px;height:44.5px"><i class="material-icons" style="color:#fff;font-size:28px;line-height:44px">&#xE0CD;</i></a>'+
                                                        '</div>'+
                                                      '</div>');
                                  if((i - 1) == (print.length - 1)){
                                    localStorage.setItem('htmlHistori',$("#historial").html());
                                    localStorage.setItem('hist','1');
                                    console.log('entro');
                                  }
                             }
                           }else{
                            res="<br><br><br><br><center><h5>No has realizado Ninguna Llamada</h5></center>";
                             $('#cargad').html('');
                              $('#cargad').css('display','none');
                              $("#historial").html(res);
                          }
                      }  
                    });
                }