class sentry::python(){

    $packages = ["python2.7", "python-dev", "python-setuptools"]

    # won't cause error if package was previously declared
    ensure_packages($packages)

    exec{'pip_install':
        command => 'sudo easy_install pip',
        require => Package[$packages]
    }

    exec{'virtualenv_install':
        command => 'sudo easy_install virtualenv',
        require => Package[$packages]
    }
}
