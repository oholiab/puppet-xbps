Puppet::Type.type(:package).provide :xbps do 
  include Puppet::Util::Package
  desc "Package management via `xbps-install`.

    This provider supports the `install_options` attribute, which allows command-line flags to be passed to xbps-install.
    These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
    or an array where each element is either a string or a hash."

  commands :xbpsinstall => "/usr/bin/xbps-install"
  commands :xbpsquery => "/usr/bin/xbps-query"
  commands :xbpsremove => "/usr/bin/xbps-remove"

  defaultfor :operatingsystem => [:void] #FIXME make sure this resolves

  def install
    should = @resource[:ensure]
    str = @resource[:name]
    case should
    when true, false, Symbol
      #pass
    else
      # Add the package version and force option
      str += "=#{should}"
      cmd << "-f"
    end

    cmd += install_options if @resource[:install_options]

    xbpsinstall(*cmd)
  end
  
  def self.extrainstall
    # overwrite config FIXME: not sure if this is right incantation
    if config = @resource[:configfiles]
      cmd << "-ff"
    end
  end
end
