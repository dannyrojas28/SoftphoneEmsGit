

function Login(){
    document.addEventListener("deviceready", onDeviceReady, false);
    var username = $('#user').val();
    var password = $('#pass').val();

    var Suusuario=document.getElementsByName('user');
    var Supass=document.getElementsByName('pass');

    if(username.length > 0 ){
       Suusuario[0].style.borderBottom = "thin dotted #AAAEB0";
          document.getElementById('icoUser').style.color="#AAAEB0";
        if(password.length > 0){
            Supass[0].style.borderBottom = "thin dotted #AAAEB0";
                var parametro={'usname':username,'uspass':password};
                $('#fade').css('display','none');
                $('#carga2').css('display','block');
                setTimeout(function(){
                        $.ajax({
                             data:parametro,
                              type:"POST",
                              url:'https://app.emsivoz.co/Sotfphone/php/controlls/ctrApp_login.php',
                              success:function(response){
                                console.log(response);
                                $('#carga2').css('display','none');
                                var data=JSON.parse(response);
                                if(data[0].mensaje == "ok"){
                                  $('#fade').css('display','none');
                                  $('#login_telefonos').css('display','block');
                                  console.log('ok')
                                     localStorage.setItem('sft_user', username);
                                      localStorage.setItem('sft_uspass', password);
                                      localStorage.setItem('sft_name', data[0].name);
                                      localStorage.setItem('sft_credit', data[0].credit);
                                      localStorage.setItem('sft_cel',data[0].cel);
                                      localStorage.setItem('sft_uipass',data[0].uipass);
                                      localStorage.setItem('sft_sessioncard',data[0].session);
                                      localStorage.setItem('sft_llamar','1');
                                      localStorage.setItem('sft_htmlHistori', "");
                                      localStorage.setItem('sft_server', "co");
                                      localStorage.setItem('sft_moneda', "$");
                                      
                                      var option = "";
                                      console.log(data.length)
                                      for (var i = 1; i < data.length; i++) {
                                        if(data[i].state == "OFF"){
                                          option  = option + '<option value="'+data[i].idtel+'">'+data[i].tipo+'</option>';
                                        }else{
                                          option  = option + '<option value="'+data[i].idtel+'" disabled>'+data[i].tipo+' - Ocupado</option>';
                                        }
                                        console.log(option)
                                      }

                                       

                                       $('#sl').html('<div class="input-field col s10 offset-s1 input"> '+
                                          '<i class="material-icons iconIn prefix pais validate " id="icoPais" name="icoPais" style="color:#AAAEB0;font-size: 2.5em">&#xE0CD;</i>'+
                                           '<select class="optionff icons validate " name="celular" id="celular" >'+
                                              option+
                                          '</select>'+
                                        '</div>');
                                      $('.materialboxed').materialbox();
                                      $('select').material_select();
                                    }else{
                                      $('#fade').removeClass('fadeOut');
                                      $('#fade').addClass('fadeIn');
                                        $('#fade').css('display','block');
                                        $('#carga2').css('display','none');
                                        if(response == "En estos momentos estamos realizando cambios "){
                                            $('#gh').html("<font color='red'> <h5><i class='material-icons'>&#xE7F3;</i>  En estos momentos estamos realizando cambios</font> </h5>");
                                        }else{
                                           $('#gh').html("<font color='red'> <h5><i class='material-icons'>&#xE7F3;</i>  Datos Incorrectos</font> </h5>");
                                           Suusuario[0].style.borderBottom = "thin dotted red";
                                           document.getElementById('icoUser').style.color="red";
                                           Supass[0].style.borderBottom = "thin dotted red";
                                           document.getElementById('icoPass').style.color="red";
                                         }
                                    }
                                }
                         }).done( function() {
                            //alert( 'Success!!' );
                         }).fail( function() {
                             navigator.notification.alert('ESte servido no ha sido encontrado', alertCallback, "Page no Found", "Aceptar");
                              console.log( 'EN ESTOS MOMENTOS SOLO ESTAMOS EN COLOMBIA!!' );
                              $('#fade').removeClass('fadeOut');
                              $('#fade').addClass('fadeIn');
                              $('#fade').css('display','block');
                               $('#carga2').css('display','none');
                          }).always( function() {
                            console.log(323)
                          });
                   } ,10);
          }else{
              Supass[0].style.borderBottom = "thin dotted red";
              document.getElementById('icoPass').style.color="red";
          }
    }else{
          Suusuario[0].style.borderBottom = "thin dotted red";
          document.getElementById('icoUser').style.color="red";
          if(password.length == 0){
            Supass[0].style.borderBottom = "thin dotted red";
            document.getElementById('icoPass').style.color="red";
         } 
    }
}

function alertCallback(){

}
function SelectNumber(){
  var select = $('#celular').val();
  if(select.length > 0 || select != null){
    localStorage.setItem('sft_session', select);
    $('#login').css('display','none');
    $.post('https://app.emsivoz.co/Sotfphone/php/controlls/ctrApp_updStateTel.php',{'id':select,'state':'ON'},function(data){console.log(data)});
     $(location).attr('href',"index.html");
  }else{
    $('#fh').css('display','block');
  }
}
