class TimeOfRequestService
  def call
    NotificationBuilder.call(['sms', 'push'], data)
  end
end

class TimeOfRequestServiceSpec
  def call
    NotificationBuilder.call(['sms', 'push'], data)
  end
end

class NotificationBuilder
  def self.call(notification_types, data)
    notification_types.each { |notif_type| to_class(notif_type).call(data) }
  end

  private

  def to_class(notif_type)
    notif_type.to_ruby_class
  end
end

class AbstractNotifier
  def self.call(data)

  end
end

class Mailer < AbstractNotifier
  def self.call(data)
    data
  end
end

class SMS
  def self.call(data);
end

class Push
  def self.call(data);
end

# Notify rules
# notification types:
Mailer, SMS, Push

# notification data:
username, email, credit_card