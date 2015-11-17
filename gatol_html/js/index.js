/* Inpired by Jee Dribbble Shot ( http://dribbble.com/shots/770815-Login ) */ 
/* coded by alireza attari ( @alireza_attari ) */

var GameAThon = (function() {

    // PRIVATE VARIABLES
    var loginContainer; // holds login objects, value set in the "start" method below

    // the backend we are using
    var apiUrl = 'https://calm-garden-9078.herokuapp.com' 

    // PRIVATE METHODS

     /**
     * HTTP POST request
     * @param  {string}   url       URL path, e.g. "/api/trainers"
     * @param  {Object}   data      JSON data to send in request body
     * @param  {function} onSuccess   callback method to execute upon request success (201 status)
     * @param  {function} onFailure   callback method to execute upon request failure (non-201 status)
     * @return {None}
     */
    var makePostRequest = function(url, data, onSuccess, onFailure) {
        $.ajax({
            type: 'POST',
            url: apiUrl + url,
            data: JSON.stringify(data),
            contentType: "application/json",
            dataType: "JSON",
            success: onSuccess,
            error: onFailure
        });
    };

    var attachCreateHandler = function(e) {

        // hide the login screen initially
        loginContainer.find("#login_screen").hide();

        // hide the trainer login screen initially
        loginContainer.find("#trainer_login_screen").hide();

        // hide the register screen initially
        loginContainer.find("#register_screen").hide();

        // hide the forgot screen initially
        loginContainer.find('#forgot_screen').hide();

        // hide the trainer forgot screen initially
        loginContainer.find("#trainer_forgot_screen").hide();

        // hide the login title
        loginContainer.find('#login_title').hide();

        // forgot password 
        loginContainer.on('click', '#user_forgot', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Reset Password');
            loginContainer.find('#login_title').show();
            loginContainer.find('#login_screen').hide();
            loginContainer.find('#forgot_screen').show(); 
        });

        // forgot password back button
        loginContainer.on('click', '#forgot_back', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Login');
            loginContainer.find('#login_title').show();
            loginContainer.find('#forgot_screen').hide();
            loginContainer.find('#login_screen').show(); 
        });

        // forgot trainer password 
        loginContainer.on('click', '#trainer_forgot', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Reset Trainer Password');
            loginContainer.find('#login_title').show();
            loginContainer.find('#trainer_login_screen').hide();
            loginContainer.find('#trainer_forgot_screen').show(); 
        });

        // forgot trainer password back button
        loginContainer.on('click', '#trainer_forgot_back', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Trainer Login');
            loginContainer.find('#login_title').show();
            loginContainer.find('#trainer_forgot_screen').hide();
            loginContainer.find('#trainer_login_screen').show(); 
        });


        // student login
        loginContainer.on('click', '#student_login', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Login');
            loginContainer.find('#login_title').show();
            loginContainer.find("#select_screen").hide();
            loginContainer.find("#login_screen").show(); 
        });

        loginContainer.on('click', '#sign_in', function(e) {
            // do user sign in logic
            
        });

        loginContainer.on('click', '#trainer_sign_in', function(e) {
            // do trainer sign in logic
        });


        // login back
        loginContainer.on('click', '#login_back', function(e) {
            loginContainer.find('#login_title').hide();
            loginContainer.find("#login_screen").hide();
            loginContainer.find("#select_screen").show();
        });

        // trainer login back
        loginContainer.on('click', '#trainer_login_back', function(e) {
            loginContainer.find('#login_title').hide();
            loginContainer.find("#trainer_login_screen").hide();
            loginContainer.find("#select_screen").show();
        });


        // trainer login
        loginContainer.on('click', '#trainer_login', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Trainer Login');
            loginContainer.find('#login_title').show();
            loginContainer.find('#select_screen').hide();   
            loginContainer.find("#trainer_login_screen").show(); 
        });

        // register 
        loginContainer.on('click', '#register', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Register');
            loginContainer.find('#login_title').show();
            loginContainer.find('#select_screen').hide(); 
            loginContainer.find('#register_screen').show();
        });

        loginContainer.on('click', '#register_user', function(e) {
            var creds = {} // prepare credentials for passing into backend

            if (loginContainer.find('#register_password').val() != loginContainer.find('#register_confirm_password').val()) {
                alert('password does not match');
                return;
            }

            creds.email = loginContainer.find('#register_email').val();
            creds.password = loginContainer.find('#register_password').val();
            creds.confirm_password = loginContainer.find('#register_confirm_password').val();

            var onSuccess = function(data) {
                alert('successfully registered user');
            };
            var onFailure = function() { 
                console.error('failure to register user');
            };
            
            url = '/api/trainers';
            console.log(creds);
            makePostRequest(url, creds, onSuccess, onFailure);

        });

        // register back
        loginContainer.on('click', '#register_back', function(e) {
            loginContainer.find('#login_title').hide();
            loginContainer.find('#register_screen').hide();
            loginContainer.find('#select_screen').show();
        });

    }

    

    /**
     * Start the app by displaying the most recent smiles and attaching event handlers.
     * @return {None}
     */
    var start = function() {
        loginContainer = $("#login_container");

        attachCreateHandler();
    };

    // PUBLIC METHODS
    // any private methods returned in the hash are accessible via Smile.key_name, e.g. Smile.start()
    return {
        start: start
    };

})();
