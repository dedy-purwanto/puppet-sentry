class sentry::python(){

    $packages = ["python2.7", "python-dev", "python-setuptools"]

    package{$packages:
        ensure => installed,
    }

    exec{'pip_install':
        command => 'sudo easy_install pip',
        require => Package[$packages]
    }

    exec{'virtualenv_install':
        command => 'sudo easy_install virtualenv',
        require => Package[$packages]
    }
}

class sentry::install(){


}

class sentry(){
    class{'sentry::python':}
    class{'sentry::install':
        require => Class['sentry::python']
    }

}
