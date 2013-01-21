class sentry($password, $salt="bf13c0", $method=undef){
    class{'sentry::install':
        password => $password,
        salt => $salt,
        method => $method
    }

}
