(function($){
  $(function(){

    $('.button-collapse').sideNav();

  }); // end of document ready
})(jQuery); // end of jQuery name space 

  $(document).ready(function(){
    // the "href" attribute of .modal-trigger must specify the modal ID that wants to be triggered
     $('.modal-trigger').leanModal({
      dismissible: false, // Modal can be dismissed by clicking outside of the modal
      opacity: .5, // Opacity of modal background
      in_duration: 0, // Transition in duration
      out_duration: 0, // Transition out duration
      ready: function() { }, // Callback for Modal open
      complete: function() { } // Callback for Modal close
    }
  );   $('.materialboxed').materialbox();
        $('select').material_select();
        $('.fixed-action-btn').openFAB();
          $('.fixed-action-btn').closeFAB();
         $('.dropdown-button').dropdown({
      inDuration: 300,
      outDuration: 225,
      constrain_width: false, // Does not change width of dropdown to that of the activator
      hover: true, // Activate on hover
      gutter: 0, // Spacing from edge
      belowOrigin: false, // Displays dropdown below the button
      alignment: 'left' // Displays dropdown with edge aligned to the left of button
    }
  );
         
  });

