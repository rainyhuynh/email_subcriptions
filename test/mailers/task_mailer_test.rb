require 'test_helper'

class TaskMailerTest < ActionMailer::TestCase
  test "task_created" do
    mail = TaskMailer.task_created
    assert_equal "Task created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "task_completed" do
    mail = TaskMailer.task_completed
    assert_equal "Task completed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
