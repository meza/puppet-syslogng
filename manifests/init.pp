class syslog-ng {

	package { "syslog-ng":
		ensure  => latest
	} -> service { "syslog-ng":
		ensure => running
	}

	define server($sources=[]) {
		deployFile { "fileForServer":
			isServer => true,
			sources  => $sources
		}
	}

	define client($loghostIP, $sources=[]) {
		deployFile { "fileForClient":
			isServer  => false,
			loghostIP => $loghostIP,
			sources   => $sources
		}
	}

	define deployFile($isServer, $loghostIP="0.0.0.0", $sources=[]) {
		file { "/etc/syslog-ng/syslog-ng.conf":
			content     => template("syslog-ng/syslog-ng.conf.erb"),
			ensure      => present,
			replace     => true,
			require     => Package["syslog-ng"],
			notify      => Service["syslog-ng"]
		}
	}

}
