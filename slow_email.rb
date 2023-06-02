require 'action_mailer'
require 'bootstrap-email'
require 'bootstrap-email/rails/mail_builder'

module Rails
  def self.root
    Pathname.new(__dir__)
  end
end

BootstrapEmail.configure do |config|
  config.sass_email_string = '
  $font-size-base: 14px;

  $headings-font-weight: 600;
  $headings-margin-bottom: 1rem;
  $headings: (
    1: 1.15 * $font-size-base,
    2: 1.15 * $font-size-base,
    3: 1.15 * $font-size-base,
    4: 1.15 * $font-size-base,
    5: 1.15 * $font-size-base,
    6: 1.15 * $font-size-base
  ) !default;

  //= @import bootstrap-email;
  '

  # Custom sass that can be passed in to customize sass variables and such for the head sass
  config.sass_log_enabled = true
  # Turn on or off whether or not rails will also include a plain text email part, Default: true
  config.generate_rails_text_part = false
end

class ExampleMailer < ActionMailer::Base
  def bootstrap_mail(*args, &block)
    message = mail(*args, &block)
    BootstrapEmail::Rails::MailBuilder.perform(message)
  end

  def greet(greeting)
    bootstrap_mail(
      to: 'to@example.com',
      from: 'from@example.com',
      subject: 'Hi From Bootstrap Email',
      layout: 'bootstrap-mailer'
    ) do |format|
      format.html { render html: greeting.to_s }
    end
  end
end

mailer = ExampleMailer.new

4.times do |i|
  puts '=' * 80
  puts "Email: #{i}\n"

  start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  ExampleMailer.new.greet('greet')
  now = Process.clock_gettime(Process::CLOCK_MONOTONIC)

  puts "Took: #{now - start}s"
  puts '=' * 80
  puts "\n"
end
