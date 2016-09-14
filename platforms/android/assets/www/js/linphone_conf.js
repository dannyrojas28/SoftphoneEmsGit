var pol = {
    // Application Constructor
    initialize: function() {
        this.bindEventsx();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEventsx: function() {
        document.addEventListener('deviceready', this.onDeviceReadyx, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReadyx: function() {
        pol.receivedEventx();
    },
    // Update DOM on a Received Event
    receivedEventx: function() {
              var mySip;
              var interval;
              var options;
              var rf= false;
                    
              
                   // document.getElementById('refresh').innerHTML='<i><span style="top:30px;font-size:35px;" class="material-icons"  onclick="Contenido(\'inicio.html\')">&#xE317;</span></i>';
                      if(localStorage.getItem('llamada') != null){
                           $('#telefono-contestado').css('display','block');
                           console.log(localStorage.getItem('llamada'));
                            $('#num-llama').html(localStorage.getItem('llamada'));
                           $('#number').html(localStorage.getItem('llamada'));
                           $('#horas').val(localStorage.getItem('hor'));
                           $('#minutos').val( localStorage.getItem('min'));
                           $('#segundos').val( localStorage.getItem('seg'));
                           $("#btncolllam").removeAttr("disabled");
                           $('#colgado').val("false");
                           $("#btncolllam").removeAttr("disabled");
                           if (localStorage.getItem('seg') != '00'){
                               callEstablished();
                           }
                      }else{
                        var numero = $('#llamar-contact').val();
                        if(numero != 0){
                            LlamarOtroMedio(numero);
                        }else{
                          localStorage.setItem('seg','00');
                          localStorage.setItem('min','00');
                          localStorage.setItem('hor','00');
                         // mySip = cordova.plugins.SIP;
                          $('#telefono-llamar').css('display','block');
                          Colombia();
                        
                         var cel = localStorage.getItem('cel');
                         var pas = localStorage.getItem('uipass');
                          console.log(cel);
                          console.log(pas);
                          onDeregister();
                          onRegister(cel,pas);
                         navigator.proximity.disableSensor();
                         console.log("se cargaron los contactos");

                        }
                          //cargar paises
                          console.log("se cargo todo bie");

                      }

                    
                        onStartListenerClick();
                
                
    }
};

      
               
        