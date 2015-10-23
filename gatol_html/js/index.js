/* Inpired by Jee Dribbble Shot ( http://dribbble.com/shots/770815-Login ) */ 
/* coded by alireza attari ( @alireza_attari ) */

var GameAThon = (function() {

    // PRIVATE VARIABLES
    var loginContainer; // holds login objects, value set in the "start" method below

    // PRIVATE METHODS

    var attachCreateHandler = function(e) {

        // hide the login screen initially
        loginContainer.find("#login_screen").hide();

        // hide the register screen initially
        loginContainer.find("#register_screen").hide();

        // hide the forgot screen initially
        loginContainer.find('#forgot_screen').hide();

        // hide the login title
        loginContainer.find('#login_title').hide();

        // forgot password 
        loginContainer.on('click', '.forgot_link', function(e) {
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

        // student login
        loginContainer.on('click', '#student_login', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Login');
            loginContainer.find('#login_title').show();
            loginContainer.find("#select_screen").hide();
            loginContainer.find("#login_screen").show(); 
        });

        loginContainer.on('click', '#sign_in', function(e) {
            // do sign in logic
        });

        // login back
        loginContainer.on('click', '#login_back', function(e) {
            loginContainer.find('#login_title').hide();
            loginContainer.find("#login_screen").hide();
            loginContainer.find("#select_screen").show();
        });

        // trainer login
        loginContainer.on('click', '#trainer_login', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Login');
            loginContainer.find('#login_title').show();
            loginContainer.find('#select_screen').hide();   
            loginContainer.find("#login_screen").show(); 
        });

        // register 
        loginContainer.on('click', '#register', function(e) {
            loginContainer.find('#login_title').html('');
            loginContainer.find('#login_title').append('Register');
            loginContainer.find('#login_title').show();
            loginContainer.find('#select_screen').hide(); 
            loginContainer.find('#register_screen').show();
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
