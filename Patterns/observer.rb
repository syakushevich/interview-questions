# Observer Pattern Example( PubSub)

# Subscriber (Observer)
class Subscriber
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def update(channel_name, video_title)
    puts "#{name} received a notification: New video '#{video_title}' uploaded on #{channel_name}!"
  end
end

# YouTube Channel (Subject)
class YouTubeChannel
  attr_reader :name

  def initialize(name)
    @name = name
    @subscribers = []
  end

  def subscribe(subscriber)
    @subscribers << subscriber
  end

  def unsubscribe(subscriber)
    @subscribers.delete(subscriber)
  end

  def upload_video(video_title)
    puts "#{name} uploaded a new video: #{video_title}"
    notify_subscribers(video_title)
  end

  private

  def notify_subscribers(video_title)
    @subscribers.each { |subscriber| subscriber.update(name, video_title) }
  end
end

# Usage
channel = YouTubeChannel.new("TechReview")
subscriber1 = Subscriber.new("Alice")
subscriber2 = Subscriber.new("Bob")

channel.subscribe(subscriber1)
channel.subscribe(subscriber2)

channel.upload_video("Ruby Design Patterns Explained")

# Output:
# TechReview uploaded a new video: Ruby Design Patterns Explained
# Alice received a notification: New video 'Ruby Design Patterns Explained' uploaded on TechReview!
# Bob received a notification: New video 'Ruby Design Patterns Explained' uploaded on TechReview!
