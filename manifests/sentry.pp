class sentry($password, $salt="bf13c0"){
    class{'sentry::python':}
    class{'sentry::install':
        require => Class['sentry::python'],
        password => $password,
        salt => $salt,
    }

}
