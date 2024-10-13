<?php

//we need to load the original mu-plugins from a separate folder 
//as we want to add our own ones for development

$extra_mu_plugins_dir = WP_CONTENT_DIR . '/extra-mu-plugins';
if (is_dir($extra_mu_plugins_dir)) {
    foreach (glob($extra_mu_plugins_dir . '/*.php') as $file) {
        require_once $file;
    }
}