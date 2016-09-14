var join= {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        join.receivedEvent();
    },
    // Update DOM on a Received Event
    receivedEvent: function() {
        if(localStorage.getItem('sft_session') != null){
             Linphone.initLinphoneCore(function(id) {
                   //  alert("linphone succes");
            
            },function(e){
               // alert(error);
                join.initialize();
            });
         //alert('linphoneCore will be ready a few second!');
                 Onload();
        }            
    }
};

join.initialize();
function Onload(){
   // alert("listo");
    var mySip;
              var interval;
              var options;
              var rf= false;                   
                   // document.getElementById('refresh').innerHTML='<i><span style="top:30px;font-size:35px;" class="material-icons"  onclick="Contenido(\'inicio.html\')">&#xE317;</span></i>';
                      if(localStorage.getItem('sft_llamada') != null){
                           $('#telefono-contestado').css('display','block');
                           console.log(localStorage.getItem('sft_llamada'));
                            $('#num-llama').html(localStorage.getItem('sft_llamada'));
                           $('#number').html(localStorage.getItem('sft_llamada'));
                           $('#horas').val(localStorage.getItem('sft_hor'));
                           $('#minutos').val( localStorage.getItem('sft_min'));
                           $('#segundos').val( localStorage.getItem('sft_seg'));
                           $("#btncolllam").removeAttr("disabled");
                           $('#colgado').val("false");
                           $("#btncolllam").removeAttr("disabled");
                           if (localStorage.getItem('sft_seg') != '00'){
                               callEstablished();
                           }
                      }else{
                          localStorage.setItem('sft_seg','00');
                          localStorage.setItem('sft_min','00');
                          localStorage.setItem('sft_hor','00');
                         // mySip = cordova.plugins.SIP;
                          $('#inicio').css('display','block');
                         var cel = localStorage.getItem('sft_cel');
                         var pas = localStorage.getItem('sft_uipass');
                         var ser = 'sip.emsivoz.co';

                        console.log( "--------------EL NUMERO REGUSTRADO ES "+cel+" Y LA CLAVE ES "+pas+" Y EL SERVIDOR ES "+ser)
                       //  alert(cel +" -"+pas+" -"+ser);
                          onRegister(cel,pas,ser);
                          Colombia();
                         navigator.proximity.disableSensor();
                         console.log("se cargaron los contactos");
                        }
                        //cargar paises
                        console.log("se cargo todo bie");
                        onStartListenerClick();
}


   function onRegister(cel,pass,ser) {
                                        Linphone.registerSIP(
                                        cel,
                                        cel,
                                        ser,
                                        pass,
                                        'udp',
                                        function(id) {
                                            //alert('REGISTERED');
                                            $('#connect').css('color','green');
                                            $("#btnllam").removeAttr("disabled");
                                            $('#registrado').val(1);
                                           // alert('coonect')
                                            // var $toastContent = $('<span>Estas Conectado</span>');
                                             //Materialize.toast($toastContent, 3000,'rounded');
                                        },
                                        function(e) {
                                           // alert(e);
                                            onRegister(cel,pass,ser);
                                        });      
                        }

        function onDeregister() {
             //alert('DE-REGISTERED '+localStorage.getItem('server'));
                    Linphone.deregisterSIP(
                        localStorage.getItem('sft_cel'),
                        'sip.emsivoz.'+localStorage.getItem('sft_server'),
                        function(id) {
                       /*     localStorage.removeItem('usname');
                            localStorage.removeItem('uspass');
                            localStorage.removeItem('name');
                            localStorage.removeItem('credit');
                            localStorage.removeItem('session');
                            localStorage.removeItem('cel');
                            localStorage.removeItem('uipass');
                            localStorage.removeItem('llamar');
                            localStorage.removeItem('server');
                            localStorage.clear();
                            $(location).attr('href',"index.html");*/
                        },function(error){
                            console.log(error);
                            onDeregister();
                        });
        }

        function onGetRegisterState() {
                    Linphone.getRegisterStatusSIP(
                        document.getElementsByName("state_username")[0].value,
                        document.getElementsByName("state_domain")[0].value,
                        function(state) {
                            //alert(state);
                        });
        }

        function onCall(cel){
            cordova.plugins.diagnostic.requestMicrophoneAuthorization(function(status){
                      console.log("Microphone access is: "+status);
                    
                    }, function(error){
            }); 
                    Linphone.makeCall(
                        cel,
                        'sip.emsivoz.'+localStorage.getItem('sft_server'),
                        cel,
                        function(id) {
                            var num= $('#number').html();
                            $('#num-llama').html(num);
                            $('#telefono-contestado').css('display','block');
                            $('#palabraDF').html($('#palabraD').html());
                            console.log("salio la llamada")
                            onDisableSpeakerClick();
                            //alert('CALLING');
                        },
                        function(e){
                           // var $toastContent = $('<span>Problemas al realizar Llamada</span>');
                          //   Materialize.toast($toastContent, 3000);
                           // alert('error');
                            onCall(cel);
                            
                        });
        }

                
        function onAcceptCallClick() {
                    Linphone.acceptCall(
                        function(id) {
                            alert('ACCEPTED');
                        });
        }
                
        function onDeclineCallClick() {
                    Linphone.declineCall(
                        function(id) {
                            alert('DECLINED');
                        });
        }
                
        function onSendDtmfClick() {
            var dtmf =  document.getElementsByName("dtmf_key")[0].value;
                  onDisableSpeakerClick();
            Linphone.sendDtmf(
               dtmf,
                function(id) {
                 //alert('SENT DTMF -> '+ dtmf);
                 par =  $('#parlante_act').val();
                 console.log("EL PARLANTE ESTA EN "+par);
                   if(par == '1' ){
                     onEnableSpeakerClick();
                   }
                },function(error){
                    alert(error);
                });
          }
        function onGetVolumeMaxClick() {
                    Linphone.getVolumeMax(
                        function(id) {
                            alert('VOLUME MAX IS: ' + id);
                        });
        }
                
        function onAdjustVolumeClick() {
            Linphone.volume(
                document.getElementsByName("volume_number")[0].value,
                function(id) {
                    //alert('ADJUSTED VOLUME');
                });
        }
        function onTerminateCall() {
            Linphone.terminateCall(
                function(id) {
                    $('#telefono-contestado').css('display','none');
                    //onDeregister();
                    //alert('TERMINATED CALL');
                });
        }
        function onMuteCallClick() {
            Linphone.muteCall(
                function(id) {
                    alert('MUTED CALL');
                });
        }
        function onUnmuteCallClick() {
            Linphone.unmuteCall(
                function(id) {
                    alert('UNMUTED CALL');
                });
        }
        function onEnableSpeakerClick() {
            Linphone.enableSpeaker(
                function(id) {
                    //alert('ENABLED SPEAKER');
                });
        }
        function onDisableSpeakerClick() {
            Linphone.disableSpeaker(
                function(id) {
                    //alert('DISABLED SPEAKER');
                });
        }
        function onHoldCallClick() {
            Linphone.holdCall(
                function(id) {
                    alert('HOLDED CALL');
                },
                function(e) {
                    alert(e);
                });
        }
        function onUnholdCallClick() {
            Linphone.unholdCall(
                function(id) {
                    alert('UNHOLDED CALL');
                },
                function(e) {
                    alert(e);
                });
        }
        function onStartListenerClick() {  
           
            Linphone.startListener(

                function(data) {
                    console.log(data.event);
                    var r=false;
                    if (data.event == "INCOMING_RECEIVED") {
                        console.log("Event: " + data.event + "\n"
                            + "State: " + data.state + "\n"
                            + "Message: " + data.message + "\n"
                            + "Caller: " + data.caller + "\n"
                            + "Callee: " + data.callee);
                    }else if (data.event == "CALL_EVENT") {
                       /*console.log(".................EVENTO EN LA LLAMADA Event: " + data.event + "\n"
                             + "State: " + data.state + "\n"
                             + "Message: " + data.message + "\n"
                             + "Caller: " + data.caller + "\n"
                             + "Callee: " + data.callee);*/
                        switch(data.state){
                            case "OutgoingInit":
                                  console.log("ESTA TIMBRANDO");
                            break;
                            case "OutgoingProgress":
                                   console.log("ESTA TIMBRANDO");
                            break; 
                            case "Connected":
                                console.log('entro coonected')
                                $('#colgado').val("false");
                                callEstablished();
                                   
                            break;
                            case "CallEnd":
                                   Colgar();
                            break;
                             case "Error":
                                   //var $toastContent = $('<span>Problemas al realizar Llamada</span>');
                                    //Materialize.toast($toastContent, 3000);
                                    Colgar();
                            break;
                        }

                    }else if (data.event == "REGISTRATION_CHANGE") {
                        console.log("Event: " + data.event + "\n"
                            + "State: " + data.state + "\n"
                            + "Message: " + data.message + "\n"
                            + "Username: " + data.username + "\n"
                            + "Domain: " + data.domain);
                       
                        if(data.state == "RegistrationFailed"){
                            $('#palabraD').css('background','#ED565A');
                            $('#goodD').css('color','#fff');
                            $('#goodD').html('No estas Registrado');
                            $(".btnllam").attr("disabled", true);
                           console.log("SE CAMBIO EL COLOR A ROJO")
                           //  alert(cel +" -"+pas+" -"+ser);
                           //  onDeregister();
                        }else{
                            if(data.state == "RegistrationOk"){
                             console.log("SE CAMBIO EL COLOR A VERDE")
                             $('#palabraD').css('background','#89B137');
                             $('#goodD').css('color','#fff');
                             ShowSaldo();
                            }
                        }
                    }
                },
                function(e) {
                    //alert(e);
                });

        }



