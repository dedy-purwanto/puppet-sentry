class sentry($password, $salt="bf13c0", $method=undef){
    class{'sentry::install':
        method => $method
    }
    class{'sentry::config':
        password => $password,
        salt => $salt
    }
}
