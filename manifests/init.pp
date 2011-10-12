class syslog-ng {

	package { "syslog-ng":
		ensure  => latest
	} -> service { "syslog-ng":
		ensure => running
	}

	define server() {
		deployFile { "fileForServer":
			isServer => true
		}
	}

	define client($loghostIP) {
		deployFile { "fileForClient":
			isServer  => false,
			loghostIP => $loghostIP
		}
	}

	define deployFile($isServer, $loghostIP="0.0.0.0") {
		file { "/etc/syslog-ng/syslog-ng.conf":
			content     => template("syslog-ng/syslog-ng.conf.erb"),
			ensure      => present,
			replace     => true,
			refreshonly => true,
			notify      => Service["syslog-ng"]
		}
	}

}
