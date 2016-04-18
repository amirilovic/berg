require "icelab_com_au/email"
require "admin/container"

module Admin
  class Email < IcelabComAu::Email
    configure do |config|
      config.root = Container.root.join("emails")
      config.name = "email"
    end
  end
end
