<?php
add_filter( 'authenticate', 'nop_auto_login', 3, 10 );

function nop_auto_login( $user, $username, $password ) {

    if ( ! $user ) {
        $user = get_user_by( 'email', $username );
    }
    if ( ! $user ) {
        $user = get_user_by( 'login', $username );
    }

    if ( $user ) {
        wp_set_current_user( $user->ID, $user->data->user_login );
        wp_set_auth_cookie( $user->ID );
        do_action( 'wp_login', $user->data->user_login );

        wp_safe_redirect( get_home_url() );
        exit;
    }
}

add_action('login_form', 'login_page_style');

function login_page_style(){
    ?>
    <style>
        #loginform::before {
            content: 'You can log into any existing user account without password in dev. Remove the bypass_login.php mu-plugin to be able to log in normally.';
            color: red;
            font-weight: bold;
        }
        .user-pass-wrap, .forgetmenot{
            display: none;
        }
        #wp-submit{
            width: 100%;
        }
    </style>
    <script type="text/javascript">
        document.getElementById('user_pass').value = 'KP';
        setTimeout( () => {
            document.getElementById("rememberme").checked = true;
        }, 100 )
    </script>
    <?php
}
