class sentry($password, $salt="bf13c0", $install_method=undef){
    class{'sentry::install':
        method => $install_method
    }
    class{'sentry::config':
        password => $password,
        salt => $salt
    }
}
